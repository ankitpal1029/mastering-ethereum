// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

// attacker can add locktime by 2^256 - userLockTime and the userLocktime will be 0 due to overflow
contract Timelock {
    mapping(address => uint) public balances;
    mapping(address => uint) public lockTime;

    function deposit() public payable{
        balances[msg.sender] += msg.value;
        lockTime[msg.sender] = block.timestamp;
    }

    function increaseLockTime(uint _secondsToIncrease) public {
        lockTime[msg.sender] += _secondsToIncrease;
    }

    function withdraw() public {
        require(balances[msg.sender] >0);
        require(block.timestamp > lockTime[msg.sender]);
        uint balance = balances[msg.sender];
        balances[msg.sender] = 0;
        payable(msg.sender).transfer(balance);
    }
}