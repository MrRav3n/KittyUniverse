import { contractAbi, contractAddress, config } from './scripts/contractConfig.js';
import { getWeb3 } from "./scripts/getWeb3.js";

let web3;
let contract;
let tokenPrice;

const _feed = async (id, userId, tokens, foodAmount, foodType, feederId) => {
    await contract.methods.feed(id, userId, tokens, foodAmount, foodType, feederId).send({from: web3.eth.defaultAccount})
}

const _adopt = async (id, userId, tokens, duration) => {
    await contract.methods.adopt(id, userId, tokens, duration).send({from: web3.eth.defaultAccount})
}

const _continueAdoption = async (id, userId, tokens, duration) => {
    await contract.methods.continueAdoption(id, userId, tokens, duration).send({from: web3.eth.defaultAccount})
}

const _play = async (id, userId, tokens, toyId, duration, playgroundId) => {
    await contract.methods.play(id, userId, tokens, toyId, duration, playgroundId).send({from: web3.eth.defaultAccount})
}

const onClickBuyTokens = () => {
    document.querySelector("#buyTokensButton")
        .addEventListener("click", e => buyTokens(e));
}

const buyTokens = async (e) => {
    e.preventDefault();
    let inputElement = document.getElementById("tokensAmount");
    const tokensAmount = inputElement.value;
    const tokensPrice = tokensAmount * tokenPrice;
    await contract.methods.buyTokens(tokensAmount).send({from: web3.eth.defaultAccount, value: tokensPrice})
    await setBalance("balance");
    alert("Udało się!")
    inputElement.value = "";
}


async function startApp() {
    web3 = await getWeb3();
    contract = await getContract();
    await setDefaultAccount();
    await setBalance();
    await getOneTokenPrice();
    onClickBuyTokens();
}

const getContract = () => {
    return new web3.eth.Contract(contractAbi, contractAddress);
}

const setDefaultAccount = async () => {
    const accounts = await web3.eth.getAccounts();
    web3.eth.defaultAccount = accounts[0];
    document.getElementById(config.accountAddressId).innerText = accounts[0];
}

const setBalance = async () => {
    document.getElementById(config.balanceId).innerText = await contract.methods.balanceOf(web3.eth.defaultAccount).call();
}

const getOneTokenPrice = async () => {
    tokenPrice = await contract.methods.oneTokenPriceInWEI().call();
    setOneTokenPrice();
}

const setOneTokenPrice = () => {
    document.getElementById(config.tokenPriceId).innerText = web3.utils.fromWei(tokenPrice);
}

startApp();