pragma solidity>0.8.0;//SPDX-License-Identifier:None

contract Child{
    uint amount;
    constructor(uint _amount){
        amount=_amount;
    }
}

contract Parent{
    Child public child; 
    function createChild(uint _amount) public returns(Child) {
       child = new Child(_amount);
       return child;
    }
}