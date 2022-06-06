pragma solidity>0.8.0;//SPDX-License-Identifier:None

contract OnlyAccess {
    modifier onlyAccess(){require(_access[msg.sender]==1);_;}
}