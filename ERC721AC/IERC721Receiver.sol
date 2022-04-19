pragma solidity^0.8.13;//SPDX-License-Identifier: MIT
interface IERC721Receiver{
    function onERC721Received(address operator,address from,uint256 tokenId,bytes calldata data)external returns(bytes4);
}
