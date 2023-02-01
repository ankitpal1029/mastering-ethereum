// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;
import "hardhat/console.sol";

contract calledContract {
     event callEvent(address sender, address origin, address from);
     function calledFunction() public {
        emit callEvent(msg.sender, address(tx.origin), address(this));
     }
}

library calledLibrary {
    event callEvent(address sender, address origin, address from);
    function calledFunction() public {
        emit callEvent(msg.sender, address(tx.origin), address(this));
    }
}

contract caller {
    function make_calls(calledContract _calledContract) public {
        // _calledContract.calledFunction();
        // calledLibrary.calledFunction();
        
        (bool success, ) = address(_calledContract).call(abi.encodeWithSignature("calledFunction()"));
        require(success, "call not made");
        (bool success2, ) = address(_calledContract).delegatecall(abi.encodeWithSignature("calledFunction()"));
        require(success2, "call 2 not made");
    }
}