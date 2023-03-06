pragma solidity>0.8.0;//SPDX-License-Identifier:None
interface IERC1155{
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
interface IERC1155MetadataURI is IERC1155{
    function uri(uint256 id)external view returns(string memory);
}
contract ERC1155 is IERC1155,IERC1155MetadataURI{
    mapping(uint256=>mapping(address=>uint256))private _b;
    mapping(address=>mapping(address=>bool))private _o;
    string private _uri;
    constructor(string memory uri_){
        _uri=uri_;
    }
    function supportsInterface(bytes4 a)external pure returns(bool){
        return a==type(IERC1155).interfaceId||a==type(IERC1155MetadataURI).interfaceId;
    }
    function uri(uint256)external view virtual override returns(string memory){
        return _uri;
    }
    function balanceOf(address a,uint256 b)public view virtual override returns(uint256){
        return _b[b][a];
    }
    function balanceOfBatch(address[]memory a,uint256[]memory b)external view virtual override returns(uint256[]memory c){
        c=new uint256[](a.length);
        for(uint256 i=0;i<a.length;++i)c[i]=balanceOf(a[i],b[i]);
    }
    function setApprovalForAll(address a,bool b)external override{
        require(msg.sender!=a);
        _o[msg.sender][a]=b;
        emit ApprovalForAll(msg.sender,a,b);
    }
    function isApprovedForAll(address a,address b)public view virtual override returns(bool){
        return _o[a][b];
    }
    function safeTransferFrom(address a,address b,uint256 c,uint256 d,bytes memory)external override{unchecked{
        require(a==msg.sender||isApprovedForAll(a,msg.sender));
        require(_b[c][a]>=d);
        (_b[c][a]-=d,_b[c][b]+=d);
        emit TransferSingle(msg.sender,a,b,c,d);
    }}
    function safeBatchTransferFrom(address a,address b,uint256[]memory c,uint256[]memory d,bytes memory)external override{unchecked{
        require(a==msg.sender||isApprovedForAll(a,msg.sender));
        require(c.length==d.length);
        for(uint256 i=0;i<c.length;++i){
            require(_b[c[i]][a]>=d[i]);
            (_b[c[i]][a]-=d[i],_b[c[i]][b]+=d[i]);
        }
        emit TransferBatch(msg.sender,a,b,c,d);
    }}
    function _mint(address a,uint256 b,uint256 c,bytes memory)internal virtual{unchecked{
        _b[b][a]+=c;
        emit TransferSingle(msg.sender,address(0),a,b,c);
    }}
    function _mintBatch(address a,uint256[]memory b,uint256[]memory c,bytes memory)internal virtual{unchecked{
        require(b.length==c.length);
        for(uint256 i=0;i<b.length;i++)_b[b[i]][a]+=c[i];
        emit TransferBatch(msg.sender,address(0),a,b,c);
    }}
    function _burn(address a,uint256 b,uint256 c)internal virtual{unchecked{
        require(_b[b][a]>=c);
        _b[b][a]=_b[b][a]-c;
        emit TransferSingle(msg.sender,a,address(0),b,c);
    }}
    function _burnBatch(address a,uint256[]memory b,uint256[]memory c)internal virtual{unchecked{
        require(b.length==c.length);
        for(uint256 i=0;i<b.length;i++){
            require(_b[b[i]][a]>=c[i]);
            _b[b[i]][a]-=c[i];
        }
        emit TransferBatch(msg.sender,a,address(0),b,c);
    }}
}