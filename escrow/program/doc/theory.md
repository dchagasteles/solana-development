### Account
1. each program is processed by its BPF Loader and has an entrypoint whose structure depends on which BPF Loader is used
2. accounts are used to store state
3. accounts are owned by programs
4. only the account owner may debit an account and adjust its data
5. all accounts to be written to or read must be passed into the entrypoint


### Program
1. developers should use the data field to save data inside accounts
2. the token program owns token accounts which - inside their data field - hold [relevant information](https://github.com/solana-labs/solana-program-library/blob/master/token/program/src/state.rs#L86)
3. the token program also owns token mint accounts with [relevant data](https://github.com/solana-labs/solana-program-library/blob/master/token/program/src/state.rs#L86)
4. each token account holds a reference to their token mint account, thereby stating which token mint they belong to
5. the token program allows the (user space) owner of a token account to transfer its ownership to another address
6. All internal Solana internal account information is saved into [fields on the account](https://docs.rs/solana-program/1.5.0/solana_program/account_info/struct.AccountInfo.html#fields) but never into the data field which is solely meant for userspace information


### Solana Sysbar
Solana has sysvars that are parameters of the Solana cluster you are on. These sysvars can be accessed through accounts and store parameters such as what the current fee or rent is. As of solana-program version 1.6.5, sysvars can also be accessed without being passed into the entrypoint as an account (opens new window)(this tutorial will continue to use the old way for now, but you shouldn't!).


### Rent
Rent is deducted from an accounts' balance according to their space requirements regularly. An account can, however, be made rend-exempt if its balance is higher than some threshold that depends on the space it's consuming


### Program Derived Address(PDA) & [CPI](https://docs.solana.com/developing/programming-model/calling-between-programs#cross-program-invocations)
- Program Derived Addresses do not lie on the ed255519 curve and therefore have no private key associated with them.
- When including a `signed` account in program call, in all CPIs including that account made by that program inside the current instruction, the account will also be `signed`. i.e, the signature is extended to the CPIs.


### Instructions
- There can be several instructions(ix) inside one transactions(tx) in Solana. These ixs are executed out synchronously and the tx as a whole is executed atomically. These instructions can call different programs.
- The system program is responsible for allocating account space and assigning (internal - not user space) account ownership.
- Instructions may depend on previous instructions inside the same transaction.
- Commitment settings give downstream developers ways to query the network which differ in finality likelihood.


### 
- When a program calls `invoke_signed`, the runtime uses the given seeds and the program id of the calling program to recreate the PDA and if it matches one of the given accounts inside invoke_signed's arguments, that account's signed property will be set to true.
- If an account has no balance left, it will be purged from memory by the runtime after the tx. *you can see this when going to an account that has been closed in the explorer)
- "closing" instructions must set the data field properly, even if the intent is to have the account be purged from memory after the tx.