//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.6.0 <0.9.0;

contract SimpleStorage {

    struct Contract {
        uint256 balance;
        address Address;
    }

    uint256 private balance;

    address Address = 0xa77C6a10B2c2df1B1C0596E2925DCb1d0C76A975;

    Contract public firstContract = Contract({balance: 5,Address:Address});
    
    Contract[] public arrayContracts;
    mapping(string=>Contract) public mapContracts;

    function store( uint256 _balance) public {
        balance = _balance;
    }

    function showNumber() public view returns(uint256)  { return balance;}

    function getHash(uint256 hash) public pure returns(uint256) {return hash * 2;}

    function addContract(string memory _login, uint256 _balance, address _address) public {
        arrayContracts.push(Contract(_balance,_address));
        mapContracts[_login] = Contract(_balance,_address);
    }
}