//SPDX-License-Identifier:None
pragma solidity>0.8.0;

interface IERC721 {
    event Transfer(address indexed from, address indexed to, uint indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
    event Approval(address indexed owner, address indexed approved, uint indexed tokenId);
    function balanceOf(address)                                         external view returns(uint);
    function ownerOf(uint)                                              external view returns(address);
    function getApproved(uint)                                          external view returns(address);
    function isApprovedForAll(address, address)                         external view returns(bool);
    function approve(address, uint)                                     external;
    function setApprovalForAll(address, bool)                           external;
    function transferFrom(address, address, uint)                       external;
    function safeTransferFrom(address, address, uint)                   external;
    function safeTransferFrom(address, address, uint, bytes calldata)   external;
}

interface IERC721Metadata {
    function name()                                                     external view returns(string memory);
    function symbol()                                                   external view returns(string memory);
    function tokenURI(uint)                                             external view returns(string memory);
}
contract ERC721AC is IERC721, IERC721Metadata {

    address public owner;
    string public name="Name";
    string public symbol="SYM";
    mapping(uint=>address)public ownerOf;
    mapping(address=>uint)public balanceOf;
    mapping(uint=>address)public getApproved;
    mapping(address=>mapping(address=>bool))public isApprovedForAll;

    constructor() {

        owner = msg.sender;

    }
    function supportsInterface(bytes4 a)external pure returns(bool) {
        return a==type(IERC721).interfaceId||a==type(IERC721Metadata).interfaceId;
    }
    
    function tokenURI(uint)external pure returns(string memory) {
        return"";
    }
    function approve(address a, uint b)external {
        require(msg.sender==ownerOf[b]||isApprovedForAll[ownerOf[b]][msg.sender]);
        getApproved[b]=a;
        emit Approval(ownerOf[b], a, b);
    }
    
    function setApprovalForAll(address a, bool b)external {
        isApprovedForAll[msg.sender][a]=b;
        emit ApprovalForAll(msg.sender, a, b);
    }
    
    function safeTransferFrom(address a, address b, uint c)external {
        transferFrom(a, b, c);
    }
    function safeTransferFrom(address a, address b, uint c, bytes memory)external {
        transferFrom(a, b, c);
    }
    function transferFrom(address a, address b, uint c)public {unchecked {
        require(a==ownerOf[c]||getApproved[c]==a||isApprovedForAll[ownerOf[c]][a]);
        (getApproved[c]=address(0), --balanceOf[a], ++balanceOf[b], ownerOf[c]=b);
        emit Approval(ownerOf[c], b, c);
        emit Transfer(a, b, c);
    }}
}
