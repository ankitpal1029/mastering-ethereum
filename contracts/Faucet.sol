// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;
import "hardhat/console.sol";

contract owned {
    address payable owner;
    constructor(){
        owner = payable(msg.sender);
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Only contract owner can call this");
        _;
    }
}

contract mortal is owned {
    function destroy() public onlyOwner {
        selfdestruct(owner);
    }
}

contract Faucet{
    event Withdrawal(address indexed to, uint amount);
    event Deposit(address indexed from, uint amount);
    event Random(string val);

    function withdraw(uint withdraw_amount) public {
        require(withdraw_amount < 0.1 ether);
        require(address(this).balance >= withdraw_amount, "insufficient balance in faucet");
        payable(msg.sender).transfer(withdraw_amount);
        emit Withdrawal(msg.sender, withdraw_amount);
    }

    fallback() external {
    }
    receive() external payable {
        console.log("yo");
        emit Deposit(msg.sender, msg.value);
    }
}