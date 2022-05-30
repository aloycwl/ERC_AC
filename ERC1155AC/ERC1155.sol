pragma solidity>0.8.0;//SPDX-License-Identifier:None
import"./IERC1155.sol";
import"./IERC1155Receiver.sol";
import"./IERC1155MetadataURI.sol";
import"./Address.sol";
import"./Context.sol";
import"./ERC165.sol";
contract ERC1155 is Context,ERC165,IERC1155,IERC1155MetadataURI{
    using Address for address;
    mapping(uint256=>mapping(address=>uint256))private _balances;
    mapping(address=>mapping(address=>bool))private _operatorApprovals;
    string private _uri;
    constructor(string memory uri_){
        _setURI(uri_);
    }
    function supportsInterface(bytes4 i)public view virtual override(ERC165,IERC165)returns(bool){
        return i==type(IERC1155).interfaceId||i==type(IERC1155MetadataURI).interfaceId||super.supportsInterface(i);
    }
    function uri(uint256)public view virtual override returns(string memory){
        return _uri;
    }
    function balanceOf(address account,uint256 id)public view virtual override returns(uint256){
        require(account!=address(0));
        return _balances[id][account];
    }
    function balanceOfBatch(address[]memory accounts,uint256[]memory ids)public view virtual override returns(uint256[]memory){
        require(accounts.length==ids.length);
        uint256[]memory batchBalances=new uint256[](accounts.length);
        for(uint256 i=0;i<accounts.length;++i)batchBalances[i]=balanceOf(accounts[i],ids[i]);
        return batchBalances;
    }
    function setApprovalForAll(address operator,bool approved)public virtual override{
        _setApprovalForAll(_msgSender(),operator,approved);
    }
    function isApprovedForAll(address account,address operator)public view virtual override returns(bool){
        return _operatorApprovals[account][operator];
    }
    function safeTransferFrom(address from,address to,uint256 id,uint256 amount,bytes memory data)public virtual override{
        require(from==_msgSender()|| isApprovedForAll(from,_msgSender()));
        _safeTransferFrom(from,to,id,amount,data);
    }
    function safeBatchTransferFrom(address from,address to,uint256[]memory ids,uint256[]memory amounts,bytes memory data)public virtual override{
        require(from==_msgSender()|| isApprovedForAll(from,_msgSender()));
        _safeBatchTransferFrom(from,to,ids,amounts,data);
    }
    function _safeTransferFrom(address from,address to,uint256 id,uint256 amount,bytes memory data)internal virtual{unchecked{
        require(to!=address(0));
       (uint256[]memory ids,uint256[]memory amounts)=(_asSingletonArray(id),_asSingletonArray(amount));
        _beforeTokenTransfer(msg.sender,from,to,ids,amounts,data);
        require(_balances[id][from]>=amount);
       (_balances[id][from]=_balances[id][from]-amount,_balances[id][to]+=amount);
        emit TransferSingle(msg.sender,from,to,id,amount);
        _afterTokenTransfer(msg.sender,from,to,ids,amounts,data);
        _doSafeTransferAcceptanceCheck(msg.sender,from,to,id,amount,data);
    }}
    function _safeBatchTransferFrom(address from,address to,uint256[]memory ids,uint256[]memory amounts,bytes memory data)internal virtual{unchecked{
        require(ids.length==amounts.length);
        require(to!=address(0));
        _beforeTokenTransfer(msg.sender,from,to,ids,amounts,data);
        for(uint256 i=0;i<ids.length;++i){
            require(_balances[ids[i]][from]>=amounts[i]);
           (_balances[ids[i]][from]=_balances[ids[i]][from]-amounts[i],_balances[ids[i]][to]+=amounts[i]);
        }
        emit TransferBatch(msg.sender,from,to,ids,amounts);
        _afterTokenTransfer(msg.sender,from,to,ids,amounts,data);
        _doSafeBatchTransferAcceptanceCheck(msg.sender,from,to,ids,amounts,data);
    }}
    function _setURI(string memory newuri)internal virtual{
        _uri=newuri;
    }
    function _mint(address to,uint256 id,uint256 amount,bytes memory data)internal virtual{
        require(to!=address(0));
        address operator=_msgSender();
        uint256[]memory ids=_asSingletonArray(id);
        uint256[]memory amounts=_asSingletonArray(amount);
        _beforeTokenTransfer(operator,address(0),to,ids,amounts,data);
        _balances[id][to]+=amount;
        emit TransferSingle(operator,address(0),to,id,amount);
        _afterTokenTransfer(operator,address(0),to,ids,amounts,data);
        _doSafeTransferAcceptanceCheck(operator,address(0),to,id,amount,data);
    }
    function _mintBatch(address to,uint256[]memory ids,uint256[]memory amounts,bytes memory data)internal virtual{
        require(to!=address(0));
        require(ids.length==amounts.length);
        _beforeTokenTransfer(msg.sender,address(0),to,ids,amounts,data);
        for(uint256 i=0;i<ids.length;i++)_balances[ids[i]][to]+=amounts[i];
        emit TransferBatch(msg.sender,address(0),to,ids,amounts);
        _afterTokenTransfer(msg.sender,address(0),to,ids,amounts,data);
        _doSafeBatchTransferAcceptanceCheck(msg.sender,address(0),to,ids,amounts,data);
    }
    function _burn(address from,uint256 id,uint256 amount)internal virtual{unchecked{
        require(from!=address(0));
        address operator=_msgSender();
        uint256[]memory ids=_asSingletonArray(id);
        uint256[]memory amounts=_asSingletonArray(amount);
        _beforeTokenTransfer(operator,from,address(0),ids,amounts,"");
        uint256 fromBalance=_balances[id][from];
        require(fromBalance>=amount);
        _balances[id][from]=fromBalance -amount;
        emit TransferSingle(operator,from,address(0),id,amount);
        _afterTokenTransfer(operator,from,address(0),ids,amounts,"");
    }}
    function _burnBatch(address from,uint256[]memory ids,uint256[]memory amounts)internal virtual{unchecked{
        require(from!=address(0));
        require(ids.length==amounts.length);
        address operator=_msgSender();
        _beforeTokenTransfer(operator,from,address(0),ids,amounts,"");
        for(uint256 i=0;i<ids.length;i++){
            require(_balances[ids[i]][from]>=amounts[i]);
            _balances[ids[i]][from]=_balances[ids[i]][from]-amounts[i];
        }
        emit TransferBatch(operator,from,address(0),ids,amounts);
        _afterTokenTransfer(operator,from,address(0),ids,amounts,"");
    }}
    function _setApprovalForAll(address owner,address operator,bool approved)internal virtual{
        require(owner!=operator);
        _operatorApprovals[owner][operator]=approved;
        emit ApprovalForAll(owner,operator,approved);
    }
    function _beforeTokenTransfer(address operator,address from,address to,uint256[]memory ids,uint256[]memory amounts,bytes memory data)internal virtual{}
    function _afterTokenTransfer(address operator,address from,address to,uint256[]memory ids,uint256[]memory amounts,bytes memory data)internal virtual{}
    function _doSafeTransferAcceptanceCheck(address operator,address from,address to,uint256 id,uint256 amount,bytes memory data)private{
        if(to.isContract())
        try IERC1155Receiver(to).onERC1155Received(operator,from,id,amount,data)returns(bytes4 response){
            if(response!=IERC1155Receiver.onERC1155Received.selector)revert();
        }catch Error(string memory reason){
            revert(reason);
        }catch{
            revert();
        }
    }
    function _doSafeBatchTransferAcceptanceCheck(address operator,address from,address to,uint256[]memory ids,uint256[]memory amounts,bytes memory data)private{
        if(to.isContract())
        try IERC1155Receiver(to).onERC1155BatchReceived(operator,from,ids,amounts,data)returns(
            bytes4 response
        ){
            if(response!=IERC1155Receiver.onERC1155BatchReceived.selector)revert();
        }catch Error(string memory reason){
            revert(reason);
        }catch{
            revert();
        }
    }
    function _asSingletonArray(uint256 element)private pure returns(uint256[]memory array){
        array=new uint256[](1);
        array[0]=element;
    }
}