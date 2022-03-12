// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;

//import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract FundMe {
  
    address owner;
    mapping(address=>uint256) public addressToAmount;
    address[] trnsAddresses;

    constructor() {
        owner = msg.sender;
    }

    function pay() public payable{
        //uint256 minUSD = 50*10**18;
        //require(getUSDfromEth(msg.value)>=minUSD,"Transactions must be above 50USD.");
        addressToAmount[msg.sender] += msg.value;
        trnsAddresses.push(msg.sender);
    }

    function getVersion() public view returns(uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x9326BFA02ADD2366b30bacB125260Af641031331);
        return priceFeed.version();
    }

    function getPrice() public view returns(uint256){
        (,int256 answer,,,)  = AggregatorV3Interface(0x9326BFA02ADD2366b30bacB125260Af641031331).latestRoundData();
        return uint256(answer * 1000000000);
    }

    function getUSDfromEth(uint256 eth) public view returns (uint256){
        return getPrice() * eth / 1000000000000000000;
    }

    function withdraw () public onlyOwner payable {
        payable(msg.sender).transfer(address(this).balance);

        for(uint256 indx = 0;indx<trnsAddresses.length;indx++){
            addressToAmount[trnsAddresses[indx]] = 0;
            trnsAddresses = new address[](0);
        }
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Only owner can do it!");
        _;
    }
}