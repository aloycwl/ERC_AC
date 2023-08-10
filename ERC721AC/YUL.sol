//SPDX-License-Identifier:None
pragma solidity ^0.8.18;
pragma abicoder v1;

contract ERC721AC {

    event Transfer(address indexed from, address indexed to, uint indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
    event Approval(address indexed owner, address indexed approved, uint indexed tokenId);
    bytes32 constant private OWN = 0x658a3ae51bffe958a5b16701df6cfe4c3e73eac576c08ff07c35cf359a8a002e;
    bytes32 constant private IN7 = 0x80ac58cd00000000000000000000000000000000000000000000000000000000;
    bytes32 constant private INM = 0x5b5e139f00000000000000000000000000000000000000000000000000000000;

    mapping (uint => address)                                           public ownerOf;
    mapping (address => uint)                                           public balanceOf;
    mapping (uint => address)                                           public getApproved;
    mapping (address => mapping (address => bool))                      public isApprovedForAll;

    constructor() {
        assembly {
            sstore(OWN, caller())
        }
    }

    function supportsInterface(bytes4 a) external pure returns(bool) {
        assembly {
            mstore(0x00, or(eq(a, IN7), eq(a, INM)))
            return(0x00, 0x20)
        }
    }

    function name() external pure returns(string memory) {
        assembly {
            mstore(0x80, 0x20)
            mstore(0xa0, 0x04)
            mstore(0xc0, "Name")
            return(0x80, 0x60)
        }
    }

    function symbol() external pure returns(string memory) {
        assembly {
            mstore(0x80, 0x20)
            mstore(0xa0, 0x03)
            mstore(0xc0, "SYM")
            return(0x80, 0x60)
        }
    }

    function owner() external view returns(address a) {
        assembly {
            a := sload(OWN)
        }
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
