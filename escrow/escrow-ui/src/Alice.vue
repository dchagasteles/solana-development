<template>
  <div class="bg">
    <p class="title">Escrow UI</p>
    <div>
      <div class="mb-1">
          <label for="2020-12-24-programId-escrow-alice">Throwaway private key (as byte array from sollet.io, without the '[]')</label>
          <input class="display-block" type="text" v-model="formState.privateKey">
      </div>
      <div class="mb-1">
          <label for="2020-12-24-programId-escrow-alice">Program id</label>
          <input class="display-block" type="text" id="2020-12-24-programId-escrow-alice" v-model="formState.programId">
      </div>
      <div class="mb-1">
          <label for="">Alice's X token account pubkey</label>
          <input class="display-block" type="text" v-model="formState.aliceXTokenAccountPubkey">
      </div>
      <div class="mb-1">
          <label for="">Amount of X tokens to send to escrow</label>
          <input class="display-block" type="number" v-model="formState.amountXTokensToSendToEscrow">
      </div>
      <div class="mb-1">
          <label for="">Alice's Y token account pubkey</label>
          <input class="display-block" type="text" v-model="formState.aliceYTokenAccountPubkey">
      </div>
      <div class="mb-1">
          <label for="">Amount of Y tokens Alice wants</label>
          <input class="display-block" type="number" v-model="formState.amountYTokensAliceExpects">
      </div>
      <div class="mb-1">
          <input style="margin-right: 5px;" class="cursor-pointer border-none bg-btn normal-font-size" type="submit" value="Reset UI" @click="resetAliceUI">
          <input class="cursor-pointer border-none bg-btn normal-font-size" type="submit" value="Init escrow" @click="onInitEscrow">
      </div>
    </div>
    <div>
      <div class="mb-1">
        Escrow account:
        <div>{{ escrowState.escrowAccountPubkey ?? '--' }}</div>
      </div>
      <div class="mb-1">
        Decoded State
      </div>
      <div class="mb-1">
        Is initialized:
        <div>{{ escrowState.isInitialized ?? '--' }}</div>
      </div>
      <div class="mb-1">
        Initializer account:
        <div>{{ escrowState.initializerAccountPubkey ?? '--' }}</div>
      </div>
      <div class="mb-1">
        X token temp account:
        <div>{{ escrowState.XTokenTempAccountPubkey ?? '--' }}</div>
      </div>
      <div class="mb-1">
        Initializer Y token account:
        <div>{{ escrowState.initializerYTokenAccount ?? '--' }}</div>
      </div>
      <div class="mb-1">
        ExpectedAmount:
        <div>{{ escrowState.expectedAmount ?? '--' }}</div>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, reactive } from "vue";
import { initEscrow } from "./util/initEscrow";

interface EscrowState {
    escrowAccountPubkey: null | string;
    isInitialized: null | boolean;
    initializerAccountPubkey: null | string;
    XTokenTempAccountPubkey: null | string;
    initializerYTokenAccount: null | string;
    expectedAmount: null | number;
}

export default defineComponent({
  setup() {
    const formState = reactive({
      privateKey: "",
      programId: "",
      aliceXTokenAccountPubkey: "",
      aliceYTokenAccountPubkey: "",
      amountXTokensToSendToEscrow: 0,
      amountYTokensAliceExpects: 0
    })

    const escrowState: EscrowState = reactive({
      escrowAccountPubkey: null,
      isInitialized: null,
      initializerAccountPubkey: null,
      XTokenTempAccountPubkey: null,
      initializerYTokenAccount: null,
      expectedAmount: null
    });

    const resetAliceUI = () => {
      formState.privateKey = "";
      formState.programId = "";
      formState.aliceXTokenAccountPubkey = "";
      formState.aliceYTokenAccountPubkey = "";
      formState.amountXTokensToSendToEscrow = 0;
      formState.amountYTokensAliceExpects = 0;
      Object.keys(escrowState).forEach(key => escrowState[key as keyof EscrowState] = null);
    }

    const onInitEscrow = async () => {
      try {
        const { 
          escrowAccountPubkey,
          isInitialized,
          initializerAccountPubkey,
          XTokenTempAccountPubkey,
          initializerYTokenAccount,
          expectedAmount
        } = await initEscrow(
          formState.privateKey,
          formState.aliceXTokenAccountPubkey,
          formState.amountXTokensToSendToEscrow,
          formState.aliceYTokenAccountPubkey,
          formState.amountYTokensAliceExpects,
          formState.programId
        );
        escrowState.escrowAccountPubkey = escrowAccountPubkey;
        escrowState.isInitialized = isInitialized;
        escrowState.initializerAccountPubkey = initializerAccountPubkey;
        escrowState.XTokenTempAccountPubkey = XTokenTempAccountPubkey;
        escrowState.initializerYTokenAccount = initializerYTokenAccount;
        escrowState.expectedAmount = expectedAmount;
      } catch(err) {
        alert(err.message);
      }
    }

    return {
      formState,
      resetAliceUI,
      onInitEscrow,
      escrowState
    }
  }
})
</script>
