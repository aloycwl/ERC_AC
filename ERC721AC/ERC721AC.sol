pragma solidity>0.8.0;//SPDX-License-Identifier:None
interface IERC721{
    event Transfer(address indexed from,address indexed to,uint indexed tokenId);
    event Approval(address indexed owner,address indexed approved,uint indexed tokenId);
    event ApprovalForAll(address indexed owner,address indexed operator,bool approved);
    function balanceOf(address)external view returns(uint);
    function ownerOf(uint)external view returns(address);
    function safeTransferFrom(address,address,uint)external;
    function transferFrom(address,address,uint)external;
    function approve(address,uint)external;
    function getApproved(uint)external view returns(address);
    function setApprovalForAll(address,bool)external;
    function isApprovedForAll(address,address)external view returns(bool);
    function safeTransferFrom(address,address,uint,bytes calldata)external;
}
interface IERC721Metadata{
    function name()external view returns(string memory);
    function symbol()external view returns(string memory);
    function tokenURI(uint)external view returns(string memory);
}
contract ERC721AC is IERC721,IERC721Metadata{
    address private _owner;
    string public name="Name";
    string public symbol="SYM";
    mapping(uint=>address)internal _owners;
    mapping(address=>uint)internal _balances;
    mapping(uint=>address)internal _tokenApprovals;
    mapping(address=>mapping(address=>bool))internal _operatorApprovals;
    constructor(){
        _owner=msg.sender;
    }
    function supportsInterface(bytes4 a)external pure returns(bool){
        return a==type(IERC721).interfaceId||a==type(IERC721Metadata).interfaceId;
    }
    function balanceOf(address a)external view returns(uint){
        return _balances[a];
    }
    function ownerOf(uint a)public view returns(address){
        return _owners[a]; 
    }
    function owner()external view returns(address){
        return _owner;
    }
    function tokenURI(uint)external pure returns(string memory){
        return"";
    }
    function approve(address a,uint b)external{
        require(msg.sender==ownerOf(b)||isApprovedForAll(ownerOf(b),msg.sender));
        _tokenApprovals[b]=a;
        emit Approval(ownerOf(b),a,b);
    }
    function getApproved(uint a)public view returns(address){
        return _tokenApprovals[a];
    }
    function setApprovalForAll(address a,bool b)external{
        _operatorApprovals[msg.sender][a]=b;
        emit ApprovalForAll(msg.sender,a,b);
    }
    function isApprovedForAll(address a,address b)public view returns(bool){
        return _operatorApprovals[a][b];
    }
    function safeTransferFrom(address a,address b,uint c)external{
        transferFrom(a,b,c);
    }
    function safeTransferFrom(address a,address b,uint c,bytes memory)external{
        transferFrom(a,b,c);
    }
    function transferFrom(address a,address b,uint c)public{unchecked{
        require(a==ownerOf(c)||getApproved(c)==a||isApprovedForAll(ownerOf(c),a));
        (_tokenApprovals[c]=address(0),_balances[a]--,_balances[b]++,_owners[c]=b);
        emit Approval(ownerOf(c),b,c);
        emit Transfer(a,b,c);
    }}
}
