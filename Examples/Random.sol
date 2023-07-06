//SPDX-License-Identifier:None
pragma solidity ^0.8.18;
pragma abicoder v1;

contract random{

    function ranArr() external view returns (uint[10] memory array) {
        
        unchecked{

            uint something=uint(keccak256(abi.encodePacked(block.timestamp)));

            for(uint i; i < 10; ++i) (array[i] = something % 2, something /= block.difficulty);

        }

    }

    function ranNum() external view returns (uint n) {

        unchecked {

            return uint(keccak256(abi.encodePacked(block.timestamp))) % 10;

        }

    }
    
}
