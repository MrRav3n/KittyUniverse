// SPDX-License-Identifier: GPL-3.0
// test blockchain - KOVAN
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;
import "safeMath.sol";
import "aggregatorInterface.sol";

contract KittyUniverse {
    using SafeMath for uint256;
    AggregatorV3Interface internal priceFeed;

    string public constant name = "KittyUniverse";
    string public constant symbol = "KIU";
    uint8 public constant decimals = 18;
    uint256 totalSupply_;
    address creator;

    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
    event Transfer(address indexed from, address indexed to, uint tokens);

    mapping(address => uint256) balances;
    mapping(address => mapping (address => uint256)) allowed;

    constructor(uint256 total) {
        totalSupply_ = total;
        priceFeed = AggregatorV3Interface(0x9326BFA02ADD2366b30bacB125260Af641031331);
        creator = msg.sender;
    }

    event FeedEvent(uint id, uint userId, uint tokens, uint foodAmount, string foodType, uint feederId);
    event AdoptEvent(uint id, uint userId, uint tokens, uint duration);
    event AdoptionContinuationEvent(uint id, uint userId, uint tokens, uint duration);
    event PlayEvent(uint id, uint userId, uint tokens, uint toyId, uint duration, uint playgroundId);

    function feed(uint id, uint userId, uint tokens, uint foodAmount, string memory foodType, uint feederId) public payable {
        transfer(creator, tokens);
        emit FeedEvent(id, userId, tokens, foodAmount, foodType, feederId);
    }

    function adopt(uint id, uint userId, uint tokens, uint duration) public payable {
        transfer(creator, tokens);
        emit AdoptEvent(id, userId, tokens, duration);
    }

    function adoptionContinuation(uint id, uint userId, uint tokens, uint duration) public payable {
        transfer(creator, tokens);
        emit AdoptionContinuationEvent(id, userId, tokens, duration);
    }

    function play(uint id, uint userId, uint tokens, uint toyId, uint duration, uint playgroundId) public payable {
        transfer(creator, tokens);
        emit PlayEvent(id, userId, tokens, toyId, duration, playgroundId);
    }

    function buyTokens(uint tokensAmount) public payable returns (bool) {
        uint256 tokensPrice = oneTokenPriceInWEI() * tokensAmount;
        if (msg.value < tokensPrice) {
            payable(msg.sender).transfer(msg.value);
            return false;
        }
        balances[msg.sender] += tokensAmount;
        uint256 etherLeft = msg.value - tokensPrice;
        if (etherLeft > 0) {
            payable(msg.sender).transfer(etherLeft);
        }
        return true;
    }

    function oneTokenPriceInWEI() public view returns (uint256) {
        uint256 TOKEN_PRICE = 100000000000000000000000000; // MUST HAVE 26 '0' after number !!!
        int currentETHPrice = ethPriceInUSD();
        uint256 valueToPay = TOKEN_PRICE / uint256(currentETHPrice);
        return valueToPay;
    }

    function ethPriceInUSD() public view returns (int) {
        (
        uint80 roundID,
        int price,
        uint startedAt,
        uint timeStamp,
        uint80 answeredInRound
        ) = priceFeed.latestRoundData();
        return price;
    }

    function totalSupply() public view returns (uint256) {
        return totalSupply_;
    }

    function balanceOf(address tokenOwner) public view returns (uint) {
        return balances[tokenOwner];
    }

    function transfer(address receiver, uint numTokens) public returns (bool) {
        require(numTokens <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender].sub(numTokens);
        balances[receiver] = balances[receiver].add(numTokens);
        emit Transfer(msg.sender, receiver, numTokens);
        return true;
    }

    function approve(address delegate, uint numTokens) public returns (bool) {
        allowed[msg.sender][delegate] = numTokens;
        Approval(msg.sender, delegate, numTokens);
        return true;
    }

    function allowance(address owner, address delegate) public view returns (uint) {
        return allowed[owner][delegate];
    }

    function transferFrom(address owner, address buyer, uint numTokens) public returns (bool) {
        require(numTokens <= balances[owner]);
        require(numTokens <= allowed[owner][msg.sender]);

        balances[owner] = balances[owner].sub(numTokens);
        allowed[owner][msg.sender] = allowed[owner][msg.sender].sub(numTokens);
        balances[buyer] = balances[buyer].add(numTokens);
        Transfer(owner, buyer, numTokens);
        return true;
    }
}

