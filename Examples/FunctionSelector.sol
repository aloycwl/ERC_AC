//SPDX-License-Identifier:None
pragma solidity ^0.8.18;
pragma abicoder v1;

contract Selector {

    function getSelector() external pure returns (bytes4) {
        return bytes4(keccak256("listData(address,address,uint256)"));
    }

}