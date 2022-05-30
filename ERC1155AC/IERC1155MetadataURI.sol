pragma solidity>0.8.0;//SPDX-License-Identifier:None
import "./IERC1155.sol";
interface IERC1155MetadataURI is IERC1155{
    function uri(uint256 id)external view returns(string memory);
}