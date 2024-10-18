# Overview

Msg represents a type of tx or action that can be executed on the blockchain.
Each `Msg` type encapsulates the data needed for a specific type of tx, such as transferring tokens, staking, or executing a contract.

# Purpose

- Encapsulation: Encapsulates the details of tx or operation.
  For example, a `MsgSend` message might contain the sender's address, the recipient's address, and the amount of tokens to be sent.

- Validation & Processing: Provides methods for validating the message and processing it within the blockchain's state machine.

# Key Components

- Fields: Defines data required for tx or action
- Methods: Implements the `sdk.Msg` interface, which includes methods like `Route()`, `Type()`, `GetSignBytes()`, and `ValidateBasic()`

Example Msg Type:

```
type MsgSend struct {
    FromAddress sdk.AccAddress `json:"from_address" yaml:"from_address"`
    ToAddress   sdk.AccAddress `json:"to_address" yaml:"to_address"`
    Amount      sdk.Coins      `json:"amount" yaml:"amount"`
}

func (msg MsgSend) Route() string { return "bank" }
func (msg MsgSend) Type() string { return "send" }
func (msg MsgSend) GetSignBytes() []byte {
    bz, _ := json.Marshal(msg)
    return sdk.MustSortJSON(bz)
}
func (msg MsgSend) ValidateBasic() error {
    if msg.FromAddress.Empty() {
        return sdkerrors.Wrap(sdkerrors.ErrInvalidAddress, "missing from address")
    }
    if msg.ToAddress.Empty() {
        return sdkerrors.Wrap(sdkerrors.ErrInvalidAddress, "missing to address")
    }
    if msg.Amount.IsNegative() {
        return sdkerrors.Wrap(sdkerrors.ErrInvalidCoins, "negative amount")
    }
    return nil
}

```

# How Msg is Used

1. Transaction Submission

- client-side: Users create & sign tx that include one or more `Msg` types.
- broadcasting: The signed tx is broadcast to the network where it is validated and processed.

2. Message handling

- Handlers: Each `Msg` type has an associated handler function that processes the message, performs the necessary state changes, and interacts with other modules if needed.
- State Updates: The handler uses the keeper to update the blockchain state based on the `Msg` data.

```
func handleMsgSend(ctx sdk.Context, k keeper.Keeper, msg MsgSend) sdk.Result {
    // Process the transaction
    err := k.SendCoins(ctx, msg.FromAddress, msg.ToAddress, msg.Amount)
    if err != nil {
        return sdk.Result{Code: sdk.CodeUnknownRequest, Log: err.Error()}
    }

    return sdk.Result{}
}

```

3. Routing and Typing

- Route(): Defines which module should handle the message.
- Type(): Identifies the type of the message, which helps in routing and processing.
