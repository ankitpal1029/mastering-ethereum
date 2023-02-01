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

contract Token {
    mapping(address => uint) balances;
    uint totalSupply;

    constructor(uint _initialSupply){
        balances[msg.sender] = totalSupply = _initialSupply;
    }

    function transfer(address _to, uint _value) public returns (bool) {
        // any _value even if balance is 0 will lead to a positive balance because of underflow
        require(balances[msg.sender] - _value >= 0);
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        return true;
    }

    function balanceOf(address _owner) public view returns (uint balance){
        return balances[_owner];
    }
}

// -------------------------- Corrected Contracts ------------------------------------------

library SafeMath {
    function add(uint256 a, uint256 b) public pure returns(uint256){
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }

    function sub(uint256 a, uint256 b) public pure returns(uint256){
        assert(b <= a);
        return a - b;
    }

    function div(uint256 a, uint256 b) public pure returns(uint256){
        uint256 c = a/b;
        // holds in al cases
        // assert(c * a == b);
        return c;
    }

    function mul(uint256 a, uint256 b) public pure returns(uint256){
        if(a == 0){
            return 0;
        }

        uint256 c = a * b;
        assert(c /a == b);
        return c;
    }
    
}

contract TimelockFixed {
    using SafeMath for uint;

    mapping(address => uint) public balances;
    mapping(address => uint) public lockTime;

    function deposit() public payable{
        balances[msg.sender] = balances[msg.sender].add(msg.value);
        lockTime[msg.sender] = block.timestamp;
    }

    function increaseLockTime(uint _secondsToIncrease) public {
        lockTime[msg.sender] =  lockTime[msg.sender].add(_secondsToIncrease);
    }

    function withdraw() public {
        require(balances[msg.sender] >0);
        require(block.timestamp > lockTime[msg.sender]);
        uint balance = balances[msg.sender];
        balances[msg.sender] = 0;
        payable(msg.sender).transfer(balance);
    }
}