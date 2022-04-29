pragma solidity^0.8.13;//SPDX-License-Identifier:None
contract random{
    function ranArr()external view returns(uint256[10] memory array){unchecked{
        uint256 something = uint256(keccak256(abi.encodePacked(block.timestamp)));
        for(uint256 i=0;i<10;i++){
            array[i]=something%2;
            something/=block.difficulty;
        }
    }}
}
