//SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.6.0 <0.9.0;

import "./SimpleStorage.sol";

contract StorageFactory is SimpleStorage {

    SimpleStorage[] private simpleStorageArray;

    function createSimpleStorage() public {
        SimpleStorage ss = new SimpleStorage();
        simpleStorageArray.push(ss);
    }

    function sfStore(uint256 _id, uint256 _balance) public {
        SimpleStorage(address(simpleStorageArray[_id])).store(_balance);
    }

    function sfShowBalance(uint256 _id) public view returns(uint256) {
        return SimpleStorage(address(simpleStorageArray[_id])).showBalance();
    }
}