pragma solidity>0.8.0;//SPDX-License-Identifier:None

contract random{
    function ranArr()external view returns(uint[10] memory array){unchecked{
        uint something=uint(keccak256(abi.encodePacked(block.timestamp)));
        for(uint i=0;i<10;i++)(array[i]=something%2,something/=block.difficulty);
    }}
    function ranNum()external view returns(uint){unchecked{
        return uint(keccak256(abi.encodePacked(block.timestamp)))%10;
    }}
}
