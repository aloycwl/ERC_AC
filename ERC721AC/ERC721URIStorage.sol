pragma solidity^0.8.13;//SPDX-License-Identifier:MIT
import "ERC721.sol";
abstract contract ERC721URIStorage is ERC721{
    using Strings for uint256;
    mapping(uint256=>string)private _tokenURIs;
    function tokenURI(uint256 tokenId) public view virtual override returns(string memory){
        if(bytes(_baseURI()).length==0)return _tokenURIs[tokenId];
        if(bytes(_tokenURIs[tokenId]).length>0)return string(abi.encodePacked(_baseURI(),_tokenURIs[tokenId]));
        return super.tokenURI(tokenId);
    }
    function _setTokenURI(uint256 tokenId,string memory _tokenURI) internal virtual{
        _tokenURIs[tokenId]=_tokenURI;
    }
    function _burn(uint256 tokenId) internal virtual override{
        super._burn(tokenId);
        if(bytes(_tokenURIs[tokenId]).length!=0)delete _tokenURIs[tokenId];
    }
}
