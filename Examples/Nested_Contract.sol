pragma solidity>0.8.0;//SPDX-License-Identifier:None

contract Child{
    uint private amount;
    constructor(uint _amount){
        amount=_amount;
    }
    function amt()external view returns(uint){
        return amount;
    }
}

contract Parent{
    mapping(uint=>address)private childs;
    uint private count;
    function createChild(uint _amount)external{
        Child child=new Child(_amount);
        childs[count]=address(child);
        count++;
    }
    function displayChilds()external view returns(address[] memory _c){
        _c=new address[](count);
        for(uint i=0;i<count;i++)_c[i]=childs[i];
    }
    function fetchAmt(address _a)external view returns(uint){
        return Child(_a).amt();
    }
}