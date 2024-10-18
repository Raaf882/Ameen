// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

contract Test {
    uint age;

    function setAge(uint _age) public{
        age = _age;
    }

    function getAge() public  view returns (uint){
        return age;
    }
}
