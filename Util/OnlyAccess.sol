// SPDX-License-Identifier: None
pragma solidity ^0.8.18;
pragma abicoder v1;

contract Access {

    mapping(address => uint) public access;

    constructor () {

        access[msg.sender] = 1e3;

    }

    modifier OnlyAccess () {

        require(access[msg.sender] > 0,         "Insufficient access");
        _;

    }

    function setAccess (address addr, uint u) external OnlyAccess {

        uint acc = access[msg.sender];
        
        require(acc > access[addr] && acc > u,  "Invalid access");

        access[addr] = u;

    }
    
}