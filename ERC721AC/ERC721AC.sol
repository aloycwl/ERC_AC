//SPDX-License-Identifier:None
pragma solidity ^0.8.18;
pragma abicoder v1;

interface IERC721 {

    event Transfer          (address indexed from, address indexed to, uint indexed tokenId);
    event ApprovalForAll    (address indexed owner, address indexed operator, bool approved);
    event Approval          (address indexed owner, address indexed approved, uint indexed tokenId);

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

    address                                                             public owner;
    string constant                                                     public name = "Name";
    string constant                                                     public symbol = "SYM";
    mapping (uint => address)                                           public ownerOf;
    mapping (address => uint)                                           public balanceOf;
    mapping (uint => address)                                           public getApproved;
    mapping (address => mapping (address => bool))                      public isApprovedForAll;

    constructor() {

        owner = msg.sender;

    }

    function supportsInterface(bytes4 i) external pure returns(bool) {

        return i == type(IERC721).interfaceId || i == type(IERC721Metadata).interfaceId;

    }
    
    function tokenURI(uint) external pure returns(string memory) {

        return "";

    }

    function approve(address to, uint id) external {

        assert(msg.sender == ownerOf[id] || isApprovedForAll[ownerOf[id]][msg.sender]);
        emit Approval(ownerOf[id], getApproved[id] = to, id);

    }
    
    function setApprovalForAll(address to, bool bol) external {

        emit ApprovalForAll(msg.sender, to, isApprovedForAll[msg.sender][to] = bol);

    }
    
    function safeTransferFrom(address from, address to, uint id) external {

        transferFrom(from, to, id);

    }

    function safeTransferFrom(address from, address to, uint id, bytes memory) external {

        transferFrom(from, to, id);

    }

    function transferFrom(address from, address to, uint id) public { 

        address _owner = ownerOf[id];

        assert(from == _owner || 
               getApproved[id] == from || 
               isApprovedForAll[_owner][from]);
        
        unchecked {
        
            (--balanceOf[from], ++balanceOf[to], getApproved[id] = address(0));
        
            emit Approval(ownerOf[id] = to, to, id);
            emit Transfer(from, to, id);

        }
    }
}
