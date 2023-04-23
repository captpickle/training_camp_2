// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;


// proxy负责存储   ？？？？？
contract CounterProxy  {
    address public impl;
    uint public counter;
    constructor() {
    }

    function upgradeTo(address _impl) public {
        impl = _impl;
    }

    // 分别代理到 Counter
    function delegateAdd(uint256 n) external {
        bytes memory callData = abi.encodeWithSignature("add(uint256)", n);
        (bool ok,) = address(impl).delegatecall(callData);
        if(!ok) revert("Delegate call failed");
    }

    function delegateGet() external returns(uint256) {
        bytes memory callData = abi.encodeWithSignature("get()");
        (bool ok, bytes memory retVal) = address(impl).delegatecall(callData);

        if(!ok) revert("Delegate call failed");

        return abi.decode(retVal, (uint256));
    }

} 

contract Counter {
    // impl是为了和proxy保持一致
    address public impl;
    uint256 public counter;

    function setNumber(uint256 newNumber) public {
        counter = newNumber;
    }

    function increment() public {
        counter++;
    }

    function count() public {
        counter = counter + 1;
    }
}
