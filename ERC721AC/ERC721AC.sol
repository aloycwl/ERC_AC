pragma solidity^0.8.13;//SPDX-License-Identifier:MIT
interface IERC721{
    event Transfer(address indexed a,address indexed b,uint256 indexed c);
    event Approval(address indexed a,address indexed b,uint256 indexed c);
    event ApprovalForAll(address indexed a,address indexed b,bool c);
    function balanceOf(address a)external view returns(uint256 b);
    function ownerOf(uint256 a)external view returns(address b);
    function safeTransferFrom(address a,address b,uint256 c)external;
    function transferFrom(address a,address b,uint256 c)external;
    function approve(address a,uint256 b)external;
    function getApproved(uint256 a)external view returns(address b);
    function setApprovalForAll(address a,bool b)external;
    function isApprovedForAll(address a,address b)external view returns(bool);
    function safeTransferFrom(address a,address b,uint256 c,bytes calldata d)external;
}
interface IERC721Metadata{
    function name()external view returns(string memory);
    function symbol()external view returns(string memory);
    function tokenURI(uint256 a)external view returns(string memory);
}
contract ERC721AC is IERC721,IERC721Metadata{
    address private _owner;
    mapping(uint256=>address)private _owners;
    mapping(address=>uint256)private _balances;
    mapping(uint256=>address)private _tokenApprovals;
    mapping(address=>mapping(address=>bool))private _operatorApprovals;
    constructor(){
        _owner=msg.sender;
    }
    function supportsInterface(bytes4 a)external pure returns(bool){
        return a==type(IERC721).interfaceId||a==type(IERC721Metadata).interfaceId;
    }
    function balanceOf(address a)external view override returns(uint256){
        return _balances[a];
    }
    function ownerOf(uint256 a)public view override returns(address){
        return _owners[a];
    }
    function owner()external view returns(address){
        return _owner;
    }
    function name()external pure override returns(string memory){
        return "Ethereum Request for Command 721 Aloysius Chan";
    }
    function symbol()external pure override returns(string memory){
        return "ERC721AC";
    }
    function tokenURI(uint256 a)external pure override returns(string memory){
        a;
        return"";
    }
    function approve(address a,uint256 b)external override{
        require(msg.sender==ownerOf(b)||isApprovedForAll(ownerOf(b),msg.sender));
        _tokenApprovals[b]=a;
        emit Approval(ownerOf(b),a,b);
    }
    function getApproved(uint256 a)public view override returns(address){
        return _tokenApprovals[a];
    }
    function setApprovalForAll(address a,bool b)external override{
        _operatorApprovals[msg.sender][a]=b;
        emit ApprovalForAll(msg.sender,a,b);
    }
    function isApprovedForAll(address a,address b)public view override returns(bool){
        return _operatorApprovals[a][b];
    }
    function transferFrom(address a,address b,uint256 c)public override{unchecked{
        require(a==ownerOf(c)||getApproved(c)==a||isApprovedForAll(ownerOf(c),a));
        _tokenApprovals[c]=address(0);
        emit Approval(ownerOf(c),b,c);
        _balances[a]-=1;
        _balances[b]+=1;
        _owners[c]=b;
        emit Transfer(a,b,c);
    }}
    function safeTransferFrom(address a,address b,uint256 c)external override{
        transferFrom(a,b,c);
    }
    function safeTransferFrom(address a,address b,uint256 c,bytes memory d)external override{
        transferFrom(a,b,c);d;
    }
    function MINT(address a,uint256 b)public{unchecked{
        _balances[a]+=1;
        _owners[b]=a;
        emit Transfer(address(0),a,b);
    }}
}
