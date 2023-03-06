pragma solidity>0.8.0;//SPDX-License-Identifier:None

interface IOwlContract{
    function MINT(address _t,uint256 _a)external;
} 

contract testCrossContract{
    IOwlContract private ioc;
    function testMint(uint256 _t)external{
        ioc.MINT(msg.sender,_t);
    }
    function setAddress(address _a)external{
        ioc=IOwlContract(_a);
    }
}
