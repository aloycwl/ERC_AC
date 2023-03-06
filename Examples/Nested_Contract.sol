/*
To view child's contract, put the returned address in "At Address"
*/

pragma solidity>0.8.0;//SPDX-License-Identifier:None

contract Child{
    uint public amount;
    constructor(uint _amount){
        amount=_amount;
    }
}

contract Parent{
    function createChild(uint _amount) public returns(Child) {
        Child child = new Child(_amount);
        return child;
    }
}