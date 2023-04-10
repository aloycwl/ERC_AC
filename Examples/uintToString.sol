pragma solidity>0.8.0;//SPDX-License-Identifier:None

contract StringUtil{
    function u2s(uint a) public pure returns (string memory) {
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
