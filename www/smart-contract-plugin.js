import { contractAbi } from './contractAbi.js';
let web3;
let contract;
let tokenPrice;
let config = {
    contractAddress: "0x6bE2253b1a4EBdA6a18c68604F4F17cf26F910c7",
    accountAddressId: "account",
    balanceId: "balance",
    tokenPriceId: "tokenPrice"
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
    tokenPrice = await getOneTokenPrice();
    setOneTokenPrice(); 
    console.log(web3.eth.defaultAccount);
    onClickBuyTokens();
}

const getWeb3 = () => {
    return new Promise((resolve, reject) => {
        window.addEventListener("load", async () => {
            if (window.ethereum) {
                const web3 = new Web3(window.ethereum);
                try {
                    await window.ethereum.request({ method: "eth_requestAccounts" });
                    resolve(web3);
                } catch (error) {
                    reject(error);
                }
            } else {
                reject("Must install MetaMask");
            }
        });
    });
};

const getOneTokenPrice = async () => {
    return await contract.methods.oneTokenPriceInWEI().call();
};

const setOneTokenPrice = () => {
    document.getElementById(config.tokenPriceId).innerText = web3.utils.fromWei(tokenPrice);
}

const setDefaultAccount = async () => {
    const accounts = await web3.eth.getAccounts();
    web3.eth.defaultAccount = accounts[0];
    document.getElementById(config.accountAddressId).innerText = accounts[0];
};

const setBalance = async () => {
    document.getElementById(config.balanceId).innerText = await contract.methods.balanceOf(web3.eth.defaultAccount).call();
}

const getContract = async () => {
    return new web3.eth.Contract(
        contractAbi,
        config.contractAddress
    );
};

startApp();