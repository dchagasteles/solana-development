//! An example of an escrow program, inspired by PaulX tutorial seen here
//! https://paulx.dev/blog/2021/01/14/programming-on-solana-an-introduction/
//! This example has some changes to implementation, but more or less should be the same overall
//! Also gives examples on how to use some newer anchor features and CPI
//!
//! User (Initializer) constructs an escrow deal:
//! - SPL token (X) they will offer and amount
//! - SPL token (Y) count they want in return and amount
//! - Program will take ownership of initializer's token X account
//!
//! Once this escrow is initialised, either:
//! 1. User (Taker) can call the exchange function to exchange their Y for X
//! - This will close the escrow account and no longer be usable
//! OR
//! 2. If no one has exchanged, the initializer can close the escrow account
//! - Initializer will get back ownership of their token X account

use anchor_lang::prelude::*;
use anchor_spl::token::{self, CloseAccount, Mint, SetAuthority, TokenAccount, Transfer};
use spl_token::instruction::AuthorityType;

declare_id!("Fg6PaFpoGXkYsidMpWTK6W2BeZ7FEfcYkg476zPFsLnS");

#[program]
pub mod escrow {
    use super::*;

    const ESCROW_PDA_SEED: &[u8] = b"escrow";

    pub fn initialize_escrow(
        ctx: Context<InitializeEscrow>,
        _vault_account_bump: u8,
        initializer_amount: u64,
        taker_amount: u64,
    ) -> ProgramResult {
        // input accounts are assigned to EscrowAccount fileds one by one
        ctx.accounts.escrow_account.initializer_key = *ctx.accounts.initializer.key;
        ctx.accounts.escrow_account.initializer_deposit_token_account = 
            *ctx.accounts
                .initializer_deposit_token_account
                .to_account_info()
                .key;
        ctx.accounts.escrow_account.initializer_receive_token_account =
            *ctx.accounts
                .initializer_receive_token_account
                .to_account_info()
                .key;
        ctx.accounts.escrow_account.initializer_amount = initializer_amount;
        ctx.accounts.escrow_account.taker_amount = taker_amount;

        // new PDA (vault_authority)
        let (vault_authority, _vault_authority_bump) =
            Pubkey::find_program_address(&[ESCROW_PDA_SEED], ctx.program_id);

        // set initializer's authority to the above PDA
        token::set_authority(
            ctx.accounts.into_set_authority_context(),
            AuthorityType::AccountOwner,
            Some(vault_authority),
        )?;

        // transfer initializer_amount tokens to PDA(vault_account)
        token::transfer(
            ctx.accounts.into_transfer_to_pda_context(),
            ctx.accounts.escrow_account.initializer_amount,
        )?;

        Ok(())
    }

    pub fn cancel_escrow(ctx: Context<CancelEscrow>) -> ProgramResult {
        // PDA for vault_authority
        let (_vault_authority, vault_authority_bump) =
            Pubkey::find_program_address(&[ESCROW_PDA_SEED], ctx.program_id);
        let authority_seeds = &[&ESCROW_PDA_SEED[..], &[vault_authority_bump]];

        // transfer x tokens from vault_account to initializer_deposit_token_account
        token::transfer(
        ctx.accounts                                              // &mut CancelEscrow
                .into_transfer_to_initializer_context()             // CpiContext<Transfer>
                .with_signer(&[&authority_seeds[..]]),
            ctx.accounts.escrow_account.initializer_amount,
        )?;

        // close PDA(vault_account)
        token::close_account(
        ctx.accounts                                              // &mut CancelEscrow
                .into_close_context()                           // Cpitext(CloseAccount)
                .with_signer(&[&authority_seeds[..]]),                    // signer_seeds
        )?;

        Ok(())
    }

    pub fn exchange(ctx: Context<Exchange>) -> ProgramResult {
        let (_vault_authority, vault_authority_bump) =
            Pubkey::find_program_address(&[ESCROW_PDA_SEED], ctx.program_id);
        let authority_seeds = &[&ESCROW_PDA_SEED[..], &[vault_authority_bump]];

        // transfer y tokens from taker_deposit_token_account to initializer_deposit_token_account
        token::transfer(
            ctx.accounts.into_transfer_to_initializer_context(),
            ctx.accounts.escrow_account.taker_amount,
        )?;

        // transfer x tokens from vault_account to taker_receive_token_account
        token::transfer(
        ctx.accounts                                // &mut Exchange
                .into_transfer_to_taker_context()     // CpiContext<Transfer>
                .with_signer(&[&authority_seeds[..]]),       // signer_seeds
            ctx.accounts.escrow_account.initializer_amount,
        )?;

        // close vault_account
        token::close_account(
        ctx.accounts                                   // &mut Exchange
                .into_close_context()             // CpiContext<CloseAccount>
                .with_signer(&[&authority_seeds[..]]),
        )?;

        Ok(())
    }
}

/**
 * ProgramAccount: Boxed container for a deserialized `account`
 *                 being used to reference account owned by the currently executing Program
 * AccountInfo:    key, is_signer, is_writable, lamports, data, owner, exectable, rent_epoch
 * Account:        Account continaer that checks ownership and deserialization
 */
#[derive(Accounts)]
#[instruction(vault_account_bump: u8, initializer_amount: u64)]
pub struct InitializeEscrow<'info> {
    #[account(mut, signer)]
    pub initializer: AccountInfo<'info>,
    pub mint: Account<'info, Mint>,
    #[account(
        init,
        seeds = [b"token-seed".as_ref()],
        bump = vault_account_bump,
        payer = initializer,
        token::mint = mint,
        token::authority = initializer,
    )]
    pub vault_account: Account<'info, TokenAccount>,
    #[account(
        mut,
        constraint = initializer_deposit_token_account.amount >= initializer_amount
    )]
    pub initializer_deposit_token_account: Account<'info, TokenAccount>,
    pub initializer_receive_token_account: Account<'info, TokenAccount>,
    #[account(zero)]
    pub escrow_account: ProgramAccount<'info, EscrowAccount>,
    pub system_program: AccountInfo<'info>,
    pub rent: Sysvar<'info, Rent>,
    pub token_program: AccountInfo<'info>,
}

#[derive(Accounts)]
pub struct CancelEscrow<'info> {
    #[account(mut, signer)]
    pub initializer: AccountInfo<'info>,
    #[account(mut)]
    pub vault_account: Account<'info, TokenAccount>,
    pub vault_authority: AccountInfo<'info>,
    #[account(mut)]
    pub initializer_deposit_token_account: Account<'info, TokenAccount>,
    #[account(
        mut,
        constraint = escrow_account.initializer_key == *initializer.key,
        constraint = escrow_account.initializer_deposit_token_account == *initializer_deposit_token_account.to_account_info().key,
        close = initializer
    )]
    pub escrow_account: ProgramAccount<'info, EscrowAccount>,
    pub token_program: AccountInfo<'info>,
}

// derive in Rust: allows new item to be automatically generated for data structures
#[derive(Accounts)]
pub struct Exchange<'info> {
    #[account(signer)]  // check if given account signed the Tx
    pub taker: AccountInfo<'info>,
    #[account(mut)]     // mark the account as mutable and persists the state transition
    pub taker_deposit_token_account: Account<'info, TokenAccount>,
    #[account(mut)]
    pub taker_receive_token_account: Account<'info, TokenAccount>,
    #[account(mut)]
    pub initializer_deposit_token_account: Account<'info, TokenAccount>,
    #[account(mut)]
    pub initializer_receive_token_account: Account<'info, TokenAccount>,
    #[account(mut)]
    pub initializer: AccountInfo<'info>,
    #[account(
        mut,
        constraint = escrow_account.taker_amount <= taker_deposit_token_account.amount,
        constraint = escrow_account.initializer_deposit_token_account == *initializer_deposit_token_account.to_account_info().key,
        constraint = escrow_account.initializer_receive_token_account == *initializer_receive_token_account.to_account_info().key,
        constraint = escrow_account.initializer_key == *initializer.key,
        close = initializer // mark the account as beingn closed at the end of Ix's execution, sending rent exemption lamports to the initializer
    )]
    pub escrow_account: ProgramAccount<'info, EscrowAccount>,
    #[account(mut)]
    pub vault_account: Account<'info, TokenAccount>,
    pub vault_authority: AccountInfo<'info>,
    pub token_program: AccountInfo<'info>,
}

#[account]
pub struct EscrowAccount {
    pub initializer_key: Pubkey,
    pub initializer_deposit_token_account: Pubkey,
    pub initializer_receive_token_account: Pubkey,
    pub initializer_amount: u64,
    pub taker_amount: u64,
}

impl<'info> InitializeEscrow<'info> {
    // transfer x tokens from initializer_deposit_token_account to vault_account
    fn into_transfer_to_pda_context(&self) -> CpiContext<'_, '_, '_, 'info, Transfer<'info>> {
        let cpi_accounts = Transfer {
            from: self
                .initializer_deposit_token_account
                .to_account_info()
                .clone(),
            to: self.vault_account.to_account_info().clone(),
            authority: self.initializer.clone(),
        };
        CpiContext::new(self.token_program.clone(), cpi_accounts)
    }

    // set initializer's authority to vault_account 
    fn into_set_authority_context(&self) -> CpiContext<'_, '_, '_, 'info, SetAuthority<'info>> {
        let cpi_accounts = SetAuthority {
            account_or_mint: self.vault_account.to_account_info().clone(),
            current_authority: self.initializer.clone(),
        };
        let cpi_program = self.token_program.to_account_info();
        CpiContext::new(cpi_program, cpi_accounts)
    }
}

impl<'info> CancelEscrow<'info> {
    // generate CPI context for Transfer
    fn into_transfer_to_initializer_context(
        &self,
    ) -> CpiContext<'_, '_, '_, 'info, Transfer<'info>> {
        let cpi_accounts = Transfer {
            from: self.vault_account.to_account_info().clone(),
            to: self
                .initializer_deposit_token_account
                .to_account_info()
                .clone(),
            authority: self.vault_authority.clone(),
        };
        let cpi_program = self.token_program.to_account_info();
        CpiContext::new(cpi_program, cpi_accounts)
    }

    fn into_close_context(&self) -> CpiContext<'_, '_, '_, 'info, CloseAccount<'info>> {
        let cpi_accounts = CloseAccount {
            account: self.vault_account.to_account_info().clone(),
            destination: self.initializer.clone(),
            authority: self.vault_authority.clone(),
        };
        let cpi_program = self.token_program.to_account_info();
        CpiContext::new(cpi_program, cpi_accounts)
    }
}

impl<'info> Exchange<'info> {
    fn into_transfer_to_initializer_context(
        &self,
    ) -> CpiContext<'_, '_, '_, 'info, Transfer<'info>> {
        let cpi_accounts = Transfer {
            from: self.taker_deposit_token_account.to_account_info().clone(),
            to: self
                .initializer_receive_token_account
                .to_account_info()
                .clone(),
            authority: self.taker.clone(),
        };
        let cpi_program = self.token_program.to_account_info();
        CpiContext::new(cpi_program, cpi_accounts)
    }

    fn into_transfer_to_taker_context(&self) -> CpiContext<'_, '_, '_, 'info, Transfer<'info>> {
        let cpi_accounts = Transfer {
            from: self.vault_account.to_account_info().clone(),
            to: self.taker_receive_token_account.to_account_info().clone(),
            authority: self.vault_authority.clone(),
        };
        CpiContext::new(self.token_program.clone(), cpi_accounts)
    }

    fn into_close_context(&self) -> CpiContext<'_, '_, '_, 'info, CloseAccount<'info>> {
        let cpi_accounts = CloseAccount {
            account: self.vault_account.to_account_info().clone(),
            destination: self.initializer.clone(),
            authority: self.vault_authority.clone(),
        };
        CpiContext::new(self.token_program.clone(), cpi_accounts)
    }
}