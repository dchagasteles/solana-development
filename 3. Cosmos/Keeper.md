# Overview

- Responsible for handling state of module, including reading & writing to blockchain's state store.
- Go struct containing references to the necessary components for managing state, such as the store keys, interfaces, and utility functions.

```
type keeper struct {
    storeKey    sdk.StoreKey
    cdc         *codec.Codec
    paramstore  subspace.Subspace
    // Other dependencies or interfaces
}
```

# How to Add

## 1. Defin the Keeper

```
package keeper

import (
    sdk "github.com/cosmos/cosmos-sdk/types"
    "github.com/cosmos/cosmos-sdk/x/some_module/types"
    "github.com/cosmos/cosmos-sdk/x/some_module/codec"
)

type Keeper struct {
    storeKey sdk.StoreKey
    cdc      codec.Codec
}

func NewKeeper(cdc codec.Codec, key sdk.StoreKey) Keeper {
    return Keeper{
        storeKey: key,
        cdc:      cdc,
    }
}
```

## 2. Implement Keeper Methods

```
func (k Keeper) SetValue(ctx sdk.Context, key string, value string) {
    store := ctx.KVStore(k.storeKey)
    bz := k.cdc.MustMarshalBinaryBare(value)
    store.Set([]byte(key), bz)
}


func (k Keeper) GetValue(ctx sdk.Context, key string) (value string) {
    store := ctx.KVStore(k.storeKey)
    bz := store.Get([]byte(key))
    if bz == nil {
        return ""
    }
    k.cdc.MustUnmarshalBinaryBare(bz, &value)
    return value
}

```

## 3. Integrate the Keeper in the Module

- Update Module Struct

```
package module

import (
    "github.com/cosmos/cosmos-sdk/x/some_module/keeper"
)

type Module struct {
    Keeper keeper.Keeper
    // Other fields
}
```

- Initialize Keeper
  In the NewAppModule function or a similar initialization function, initialize the keeper and pass it to the module.

```
func NewAppModule(cdc codec.Codec, key sdk.StoreKey) Module {
    k := keeper.NewKeeper(cdc, key)
    return Module{
        Keeper: k,
        // Other initializations
    }
}
```

## 4. Use the Keeper in Handlers

In your message handlers, use the keeper to interact with the blockchain state. This is where you will perform operations like reading from or writing to the state.

```
func handleMsg(ctx sdk.Context, k keeper.Keeper, msg types.MsgSomeAction) sdk.Result {
    // Use keeper methods
    value := k.GetValue(ctx, msg.Key)
    // Process message and update state if needed
    k.SetValue(ctx, msg.Key, msg.NewValue)

    return sdk.Result{}
}

```

## 5. Register the Keeper in the Module’s RegisterRoutes Function

If your module includes routes (e.g., for REST or gRPC), ensure the keeper is available in route handlers.

```
func RegisterRoutes(ctx sdk.Context, rtr *mux.Router, k keeper.Keeper) {
    rtr.HandleFunc("/some_path", func(w http.ResponseWriter, r *http.Request) {
        // Use the keeper here
        value := k.GetValue(ctx, "some_key")
        // Handle the request
    })
}
```

## 6. Update Genesis and State

Ensure that your module's genesis file and state management are updated to handle any new data or functionality introduced by the keeper.

- Example Genesis State Initialization:

```
func InitGenesis(ctx sdk.Context, k keeper.Keeper, data GenesisState) {
    for _, item := range data.Items {
        k.SetValue(ctx, item.Key, item.Value)
    }
}
```

- Example Export Genesis State:

```
func ExportGenesis(ctx sdk.Context, k keeper.Keeper) GenesisState {
    var items []Item
    store := ctx.KVStore(k.storeKey)
    // Iterate over store and collect data
    return GenesisState{Items: items}
}
```

## 7. Test Your Keeper

Ensure that you thoroughly test your keeper's functionality. Write unit tests to verify that the keeper methods correctly interact with the state store.

```
func TestKeeper_SetValue(t *testing.T) {
    ctx, k := setupKeeper() // Implement setup function to create context and keeper
    k.SetValue(ctx, "key", "value")
    got := k.GetValue(ctx, "key")
    if got != "value" {
        t.Errorf("expected 'value', got %s", got)
    }
}
```
