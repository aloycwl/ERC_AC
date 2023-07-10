//SPDX-License-Identifier:None
pragma solidity ^0.8.18;
pragma abicoder v1;

contract StringUtil {

    function u2s(uint a) public pure returns(string memory) {

        unchecked {
        
            if (a == 0) return "0";
            uint j = a;
            uint l;
            while (j != 0) (++l, j /= 10);
            bytes memory bstr = new bytes(l);
            j = a;
            while (j != 0) (bstr[--l] = bytes1(uint8(48 + j % 10)), j /= 10);
            return string(bstr);
            
        }

    }

    function string_assembly(uint) external pure returns(string memory) {

        assembly {
            mstore(0x0, 0x20)
            mstore(0x20, 0x20)
            mstore(0x40, "String value")
            return(0x0, 0x60)
        }

    }

}
