pragma solidity>0.8.0;//SPDX-License-Identifier:None

interface IOwlContract{
    function MINT(address _t,uint _a)external;
} 

contract testCrossContract{
    IOwlContract private ioc;
    function testMint(uint _t)external{
        ioc.MINT(msg.sender,_t);
    }
    function setAddress(address _a)external{
        ioc=IOwlContract(_a);
    }
    function direct(address _1,address _2,uint _a)external{
        IOwlContract(_1).MINT(_2,_a);
    }
}
