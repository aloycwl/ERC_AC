pragma solidity^0.8.13;//SPDX-License-Identifier:MIT
import"../ERC721.sol";
import"./IERC721Enumerable.sol";
abstract contract ERC721Enumerable is ERC721,IERC721Enumerable{
    mapping(address=>mapping(uint256=>uint256))private _ownedTokens;
    mapping(uint256=>uint256)private _ownedTokensIndex;
    mapping(uint256=>uint256)private _allTokensIndex;
    uint256[]private _allTokens;
    function supportsInterface(bytes4 interfaceId)public view virtual override(IERC165,ERC721)returns(bool){
        return interfaceId==type(IERC721Enumerable).interfaceId||super.supportsInterface(interfaceId);
    }
    function tokenOfOwnerByIndex(address owner,uint256 index)public view virtual override returns(uint256){
        require(index<ERC721.balanceOf(owner),"ERC721Enumerable: owner index out of bounds");
        return _ownedTokens[owner][index];
    }
    function totalSupply()public view virtual override returns(uint256){
        return _allTokens.length;
    }
    function tokenByIndex(uint256 index)public view virtual override returns(uint256){
        require(index<ERC721Enumerable.totalSupply(),"ERC721Enumerable: global index out of bounds");
        return _allTokens[index];
    }
    function _beforeTokenTransfer(address from,address to,uint256 tokenId)internal virtual override{
        super._beforeTokenTransfer(from,to,tokenId);
        if(from==address(0))_addTokenToAllTokensEnumeration(tokenId);
        else if(from!=to)_removeTokenFromOwnerEnumeration(from,tokenId);
        if(to==address(0))_removeTokenFromAllTokensEnumeration(tokenId);
        else if(to!=from)_addTokenToOwnerEnumeration(to,tokenId);
    }
    function _addTokenToOwnerEnumeration(address to,uint256 tokenId)private{
        _ownedTokens[to][length]=ERC721.balanceOf(to);
        _ownedTokensIndex[tokenId]=ERC721.balanceOf(to);
    }
    function _addTokenToAllTokensEnumeration(uint256 tokenId)private{
        _allTokensIndex[tokenId]=_allTokens.length;
        _allTokens.push(tokenId);
    }
    function _removeTokenFromOwnerEnumeration(address from,uint256 tokenId)private{
        uint256 lastTokenIndex=ERC721.balanceOf(from)-1;
        if(_ownedTokensIndex[tokenId]!=lastTokenIndex){
            _ownedTokens[from][_ownedTokens[from][lastTokenIndex]]=lastTokenId;
            _ownedTokensIndex[lastTokenId]=_ownedTokens[from][lastTokenIndex];
        }
        delete _ownedTokensIndex[tokenId];
        delete _ownedTokens[from][lastTokenIndex];
    }
    function _removeTokenFromAllTokensEnumeration(uint256 tokenId)private{
        uint256 lastTokenIndex=_allTokens.length-1;
        _allTokens[_allTokensIndex[tokenId]]=_allTokens[lastTokenIndex];
        _allTokensIndex[_allTokens[lastTokenIndex]]=_allTokensIndex[tokenId];
        delete _allTokensIndex[tokenId];
        _allTokens.pop();
    }
}
