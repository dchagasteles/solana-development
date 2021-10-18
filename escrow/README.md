## Intro & Motivation
This guide is meant to serve as an intro to coding on the [Solana](https://solana.com/) Blockchain, using an escrow program as an example. We'll go through the code together, building the escrow program step by step. I've also created a UI you will be able to use to try out your program. Additionally, you'll get to play with the (shameless plug) [spl-token-ui](https://www.spl-token-ui.com).


## Setup Dev Environment

### Install Run and Solana
1. Install Rust from https://rustup.rs/
2. Install Solana from https://docs.solana.com/cli/install-solana-cli-tools#use-solanas-install-tool

## Build and test for program compiled natively
`$ cargo build` <br />
`$ cargo test`

## Build and test the program compiled for BPF
`$ cargo build-bpf` <br />
`$ cargo test-bpf`


## Necessary knowledge

### Rust Basic
- [Crate](https://doc.rust-lang.org/book/ch07-01-packages-and-crates.html) <br />
- [Marcro](https://doc.rust-lang.org/stable/book/ch19-06-macros.html)

### Solana Basic
- [entrypoint](https://docs.solana.com/developing/on-chain-programs/developing-rust#program-entrypoint)
- [BPF Loader](https://docs.solana.com/developing/on-chain-programs/overview)
- [accounts](https://docs.solana.com/developing/programming-model/accounts)
- [Programs](https://docs.solana.com/developing/on-chain-programs/overview)



### Solanan/Rust development
- each program is processed by its BPF Loader and has an entrypoint whose structure depends on which BPF Loader is used
- accounts are used to store state
- accounts are owned by programs
- only the account owner may debit an account and adjust its data
- all accounts to be written to or read must be passed into the entrypoint