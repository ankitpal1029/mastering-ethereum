// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract EtherGame {
    uint public payoutMilestone1 = 3 ether;
    uint public milestone1Reward = 2 ether;
    uint public payoutMilestone2 = 5 ether;
    uint public milestone2Reward = 3 ether;
    uint public finalMilestone = 10 ether;
    uint public finalReward = 5 ether;

    mapping(address => uint) redeemableEther;

    function play() public payable {
        require(msg.value == 0.5 ether);
        uint currentBalance = address(this).balance + msg.value;
        require(currentBalance <= finalMilestone);
        if (currentBalance == payoutMilestone1){
            redeemableEther[msg.sender] += milestone1Reward;
        }
        else if(currentBalance == payoutMilestone2){
            redeemableEther[msg.sender] += milestone2Reward;
        }
        else if(currentBalance == finalMilestone){
            redeemableEther[msg.sender] += finalReward;
        }
        return;
    }

    function claimReward() public {
        require(address(this).balance == finalMilestone);
        require(redeemableEther[msg.sender] > 0);
        redeemableEther[msg.sender] = 0;
        payable(msg.sender).transfer(address(this).balance);
    }
}