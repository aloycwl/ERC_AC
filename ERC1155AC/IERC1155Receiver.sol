pragma solidity>0.8.0;//SPDX-License-Identifier:None
import "./IERC165.sol";
interface IERC1155Receiver is IERC165{
    function onERC1155Received(address,address,uint256,uint256,bytes calldata) external returns(bytes4);
    function onERC1155BatchReceived(address,address,uint256[]calldata,uint256[]calldata,bytes calldata)external returns(bytes4);
}