//SPDX-License-Identifier:None
pragma solidity ^0.8.18;
pragma abicoder v1;

contract Child {

    uint private amount;

    constructor (uint _amount) {

        amount = _amount;

    }

    function amt() external view returns (uint) {

        return amount;

    }

}

contract Parent {

    address[]private childs;

    function createChild (uint _amount) external {

        Child child=new Child(_amount);
        childs.push(address(child));

    }

    function displayChilds () external view returns (address[] memory _c) {

        _c = childs;

    }

    function fetchAmt (address _a) external view returns (uint) {

        return Child(_a).amt();

    }
    
}
