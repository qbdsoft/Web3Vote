<script setup>
import useWeb3 from "../hooks/useWeb3";
import { ref, onMounted } from "vue";
const { web3, voteContract, getAccount } = useWeb3();


const host = ref("");
const getHost = async () => {
  host.value = await voteContract.methods.host().call();
};

const voterAddress = ref("");
const mandate = async () => {
  const arr = eval(voterAddress.value);
  const account = await getAccount();
  voteContract.methods
    .mandate(arr)
    .send({ from: account })
    .on("receipt", () => {
      console.log("选票分发成功");
    });
};

onMounted(async () => {
  await getHost();
});
/*
  0x62815B4970983B8C58C2Fb649B6ba78b5BA05f70
  0xe4525BF45E1b1Cf46A136171BD51e63f4256a0DF
  0xE251ddBe6191594922bfd3d338529EC9C613eB67
  0xC76E9893BB9a75730Fc61d0169241fD80AD644f6
  ["0xe4525BF45E1b1Cf46A136171BD51e63f4256a0DF","0xE251ddBe6191594922bfd3d338529EC9C613eB67","0xC76E9893BB9a75730Fc61d0169241fD80AD644f6"]
*/
</script>

<template>
  <div class="box1">
    <van-divider>分发票权</van-divider>
    <div class="host">
      <van-space>
        <p class="label"><van-icon name="manager" />主持人地址</p>
        <p class="address">{{ host }}</p>
      </van-space>
    </div>
    <div>
      <van-space>
        <p class="label"><van-icon name="friends-o" />投票人地址</p>
        <textarea class="votors" v-model="voterAddress"></textarea>
      </van-space>
    </div>
    <div class="btn">
      <van-button block @click="mandate">开始分发选票</van-button>
    </div>
  </div>
</template>

<style lang="scss"></style>
