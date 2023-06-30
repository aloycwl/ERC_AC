//SPDX-License-Identifier:None
pragma solidity ^0.8.18;
pragma abicoder v1;

import "ERC20AC/IERC20.sol";

interface IERC20Metadata is IERC20{
    function name()external view returns(string memory);
    function symbol()external view returns(string memory);
    function decimals()external view returns(uint8);
}
