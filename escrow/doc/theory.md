
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
6. All internal Solana internal account information are saved into [fields on the account](https://docs.rs/solana-program/1.5.0/solana_program/account_info/struct.AccountInfo.html#fields) but never into the data field which is solely meant for user space information

### Sysbar
Solana has sysvars that are parameters of the Solana cluster you are on. These sysvars can be accessed through accounts and store parameters such as what the current fee or rent is. As of solana-program version 1.6.5, sysvars can also be accessed without being passed into the entrypoint as an account (opens new window)(this tutorial will continue to use the old way for now, but you shouldn't!).
#