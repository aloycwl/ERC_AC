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
    mapping(uint256=>mapping(address=>uint256))private _balances;
    mapping(address=>mapping(address=>bool))private _operatorApprovals;
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
        return _balances[b][a];
    }
    function balanceOfBatch(address[]memory a,uint256[]memory b)external view virtual override returns(uint256[]memory c){
        c=new uint256[](a.length);
        for(uint256 i=0;i<a.length;++i)c[i]=balanceOf(a[i],b[i]);
    }
    function setApprovalForAll(address a,bool b)external virtual override{
        _setApprovalForAll(msg.sender,a,b);
    }
    function isApprovedForAll(address a,address b)public view virtual override returns(bool){
        return _operatorApprovals[a][b];
    }
    function safeTransferFrom(address a,address b,uint256 c,uint256 d,bytes memory data)public virtual override{
        require(a==msg.sender||isApprovedForAll(a,msg.sender));
        _safeTransferFrom(a,b,c,d,data);
    }
    function safeBatchTransferFrom(address from,address to,uint256[]memory ids,uint256[]memory amounts,bytes memory data)public virtual override{
        require(from==msg.sender||isApprovedForAll(from,msg.sender));
        _safeBatchTransferFrom(from,to,ids,amounts,data);
    }
    function _safeTransferFrom(address from,address to,uint256 id,uint256 amount,bytes memory)internal virtual{unchecked{
        require(to!=address(0));
        require(_balances[id][from]>=amount);
       (_balances[id][from]=_balances[id][from]-amount,_balances[id][to]+=amount);
        emit TransferSingle(msg.sender,from,to,id,amount);
    }}
    function _safeBatchTransferFrom(address from,address to,uint256[]memory ids,uint256[]memory amounts,bytes memory)internal virtual{unchecked{
        require(ids.length==amounts.length);
        require(to!=address(0));
        for(uint256 i=0;i<ids.length;++i){
            require(_balances[ids[i]][from]>=amounts[i]);
           (_balances[ids[i]][from]=_balances[ids[i]][from]-amounts[i],_balances[ids[i]][to]+=amounts[i]);
        }
        emit TransferBatch(msg.sender,from,to,ids,amounts);
    }}
    function _mint(address to,uint256 id,uint256 amount,bytes memory)internal virtual{
        _balances[id][to]+=amount;
        emit TransferSingle(msg.sender,address(0),to,id,amount);
    }
    function _mintBatch(address to,uint256[]memory ids,uint256[]memory amounts,bytes memory)internal virtual{
        require(ids.length==amounts.length);
        for(uint256 i=0;i<ids.length;i++)_balances[ids[i]][to]+=amounts[i];
        emit TransferBatch(msg.sender,address(0),to,ids,amounts);
    }
    function _burn(address from,uint256 id,uint256 amount)internal virtual{unchecked{
        uint256 fromBalance=_balances[id][from];
        require(fromBalance>=amount);
        _balances[id][from]=fromBalance -amount;
        emit TransferSingle(msg.sender,from,address(0),id,amount);
    }}
    function _burnBatch(address from,uint256[]memory ids,uint256[]memory amounts)internal virtual{unchecked{
        require(from!=address(0));
        require(ids.length==amounts.length);
        for(uint256 i=0;i<ids.length;i++){
            require(_balances[ids[i]][from]>=amounts[i]);
            _balances[ids[i]][from]=_balances[ids[i]][from]-amounts[i];
        }
        emit TransferBatch(msg.sender,from,address(0),ids,amounts);
    }}
    function _setApprovalForAll(address owner,address operator,bool approved)internal virtual{
        require(owner!=operator);
        _operatorApprovals[owner][operator]=approved;
        emit ApprovalForAll(owner,operator,approved);
    }
    function _asSingletonArray(uint256 element)private pure returns(uint256[]memory array){
        array=new uint256[](1);
        array[0]=element;
    }
}