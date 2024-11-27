# Deposit

Provide liquidity to the market

## Deposit APY

- Base Market Rate: 13.94%
- Radiant Emissions: 509% (only activated for those who supply Dynamic Liquidity)

## Collateral

- After deposit, can enable them as collateral
- Collateralized asset will activate borrowing power, but can be partially liquidated

## 1-Click Loop & Lock (Leverage your Collateral)

Enables users to increase collateral value by automating depsoit & borrow cycle multiple times

- may not execute if selected leverage causes `health factor` to drop below 1.11.
  if loop tx fails, lower the leverage
- automatically ensures dLP eligibility.
  if user already eligible, zero ETH will be borrowed.
  if ineligible for RDNT emission, will automatically borow ETH to zap into a locked dLP position to maintain minimum 5% dLP requirementn for activating RDNT emissions
- slippage is fixed at 5%.
  If user wants to reduce it, recommend to manually create dLP on Balancer Pool.
- dLP will be locked for Default Locking Length

## rToken (interest-bearing tokens: rUSDC)

rTokens' value is pegged to the value of correspoding deposited asset at 1:1 rate.
All interest collected is distributed for rTokens holders directly by continuously increasing their wallet balance.

## Withdraw

Be sure there is enough (unborrowed) liquidity in the protocol in order to withdraw.

- need to wait for more liquidity to be provided by depositors
- or from borrowers repaying their loans for you to be able to withdraw the initial desired amount.

# Selling vs Borrow

- Selling closes the position to free up liquid captial.
- If its "long" on asset, selling would no longer entitle to any potential upside.
- In most countries. selling is treated as a taxable event.

## How to borrow

- before borrowing, asset must be deposited to be utlized as collateral
- borrowing Eligibility: not able to borrow if
  - there is not enough liquidity
  - or health factor is low
- LTV (loand to value) ration represents the maximum borrowing power

## Health Factor (Protect from liquidation)

Numeric representation of the safety of deposited assets weighted again any borrowed assets and underlying value.
The higher the leath factor is, the safer the state of funds is against a potential liquidation.

If Health factor <= 1, liquidiation will be triggered.
If triggered, up to 50% of the borrowing debt is repaid and that value + liquidation fee is taken from the collateral.
After a liquidation, that amount liquidiated from your debt is repaid.

Health factor depends on the liquidation threshold of collateral again the value of borrowed funds.
Health factor will increase or decrease depending on fluctuaton in the underlying token value of deposits.

If you maintain strong health factor,

- decreased likelihood of liquidation, particulary when fluctuating assets are used as collateral (low-risk strategy)
- improves borrowing eligibility in order to leverage more collateral (high-risk strategy)

## Loan Repay

Loans must be paid back with the same asset that was borrowed.
For example, if 1 Ethereum is borrowed, 1 ETH must be repaid with fees accrued in order to repay the loan.

## Liquidations

This occuers when a borrower's Health Factor is reduced to 1 or lower.
To reduce the risk of liquidation, can repay any outstanding loans or deposit additional collateral to increase your Health Factor.

Liquidation Scenario

- Roger deposits 10 ETH and borrows 5 ETH worth of DAI
- If Roger’s Health Factor drops below 1, his loan will be eligible for liquidation
- A liquidator can repay up to 50% of a single borrowed amount (in this case, 2.5 ETH worth of DAI)
- In return, the liquidator can claim a single collateral, which is ETH, at a 7.5% bonus
- The liquidator claims 2.5 + 0.1875 ETH for repaying Roger's bad debt (2.5 ETH worth of DAI)
- 0.1875 ETH is claimed by the protocol at a 7.5% bonus (15% total penalty)
- After liquidation, Roger has 7.125 ETH (10-2.5-0.1875-0.1875 ETH) of supplied ETH collateral and 2.5 ETH worth of DAI borrowed.

## Flash Loans

It allows to borrow any available assets without putting up any collateral as long as the liquidity returns to the protocol within one block transaction
