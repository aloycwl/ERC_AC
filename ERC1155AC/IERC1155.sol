pragma solidity>0.8.0;//SPDX-License-Identifier:None
import"./IERC165.sol";
interface IERC1155 is IERC165 {
    event TransferSingle(address indexed operator,address indexed from,address indexed to,uint256 id,uint256 value);
    event TransferBatch(address indexed operator,address indexed from,address indexed to,uint256[]ids,uint256[]values);
    event ApprovalForAll(address indexed account,address indexed operator,bool approved);
    event URI(string value,uint256 indexed id);
    function balanceOf(address,uint256)external view returns (uint256);
    function balanceOfBatch(address[]calldata,uint256[]calldata)external view returns (uint256[]memory);
    function setApprovalForAll(address,bool)external;
    function isApprovedForAll(address,address)external view returns (bool);
    function safeTransferFrom(address,address,uint256,uint256,bytes calldata)external;
    function safeBatchTransferFrom(address,address,uint256[]calldata,uint256[]calldata,bytes calldata)external;
}