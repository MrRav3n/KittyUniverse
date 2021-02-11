// SPDX-License-Identifier: GPL-3.0
// test blockchain - KOVAN
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

contract CryptoCitties {

    string public constant name = "KittyUniverse";
    string public constant symbol = "KIU";
    uint8 public constant decimals = 18;  
	AggregatorV3Interface internal priceFeed;

    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
    event Transfer(address indexed from, address indexed to, uint tokens);


    mapping(address => uint256) balances;

    mapping(address => mapping (address => uint256)) allowed;
    
    uint256 totalSupply_;

    using SafeMath for uint256;


	constructor(uint256 total) {  
		totalSupply_ = total;
		priceFeed = AggregatorV3Interface(0x9326BFA02ADD2366b30bacB125260Af641031331);
    }  

    function totalSupply() public view returns (uint256) {
		return totalSupply_;
    }
    
    function balanceOf(address tokenOwner) public view returns (uint) {
        return balances[tokenOwner];
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

library SafeMath { 
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
      assert(b <= a);
      return a - b;
    }
    
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
      uint256 c = a + b;
      assert(c >= a);
      return c;
    }
}

interface AggregatorV3Interface {

  function decimals() external view returns (uint8);
  function description() external view returns (string memory);
  function version() external view returns (uint256);

  function getRoundData(uint80 _roundId)
    external
    view
    returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    );
  function latestRoundData()
    external
    view
    returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    );
}
