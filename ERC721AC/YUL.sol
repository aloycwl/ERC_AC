//SPDX-License-Identifier:None
pragma solidity ^0.8.18;
pragma abicoder v1;

contract ERC721AC {

    event Transfer(address indexed from, address indexed to, uint indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
    event Approval(address indexed owner, address indexed approved, uint indexed tokenId);
    bytes32 constant private OWN = 0x658a3ae51bffe958a5b16701df6cfe4c3e73eac576c08ff07c35cf359a8a002e;
    bytes32 constant private OOF = 0xe294d98a3e2cd08f1bb43d961cb30f5820d4662f42545ba1c700ec99e8b87c08;
    bytes32 constant private GAP = 0xab52f0256cbcaa24ccad7f5bebbc7ccf47ef4ec9d4c2b354ab0e03d82ebda8b8;
    bytes32 constant private IN7 = 0x80ac58cd00000000000000000000000000000000000000000000000000000000;
    bytes32 constant private INM = 0x5b5e139f00000000000000000000000000000000000000000000000000000000;
    bytes32 constant private APP = 0x8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925;
    bytes32 constant private AFA = 0x17307eab39ab6107e8899845ad3d59bd9653f200f220920489ca2b5937696c31;
    bytes32 constant private TTF = 0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;

    constructor() { assembly {
        sstore(OWN, caller())
    }}

    function supportsInterface(bytes4 a) external pure returns(bool) { assembly {
        mstore(0x00, or(eq(a, IN7), eq(a, INM)))
        return(0x00, 0x20)
    }}

    function name() external pure returns(string memory) { assembly {
        mstore(0x80, 0x20)
        mstore(0xa0, 0x04)
        mstore(0xc0, "Name")
        return(0x80, 0x60)
    }}

    function symbol() external pure returns(string memory) { assembly {
        mstore(0x80, 0x20)
        mstore(0xa0, 0x03)
        mstore(0xc0, "SYM")
        return(0x80, 0x60)
    }}

    function owner() external view returns(address) { assembly {
        mstore(0x00, sload(OWN))
        return(0x00, 0x20)
    }}

    function ownerOf(uint tid) external view returns(address) { assembly {
        mstore(0x00, OOF)
        mstore(0x20, tid)
        mstore(0x00, sload(keccak256(0x00, 0x40)))
        return(0x00, 0x20)
    }}

    function isApprovedForAll(address adr, address ad2) external view returns(address) { assembly {
        mstore(0x00, adr)
        mstore(0x20, ad2)
        mstore(0x00, sload(keccak256(0x00, 0x40)))
        return(0x00, 0x20)
    }}

    function getApproved(uint tid) external view returns(address) { assembly {
        mstore(0x00, GAP)
        mstore(0x20, tid)
        mstore(0x00, sload(keccak256(0x00, 0x40)))
        return(0x00, 0x20)
    }}

    function balanceOf(address adr) external view returns(address) { assembly {
        mstore(0x00, sload(adr))
        return(0x00, 0x20)
    }}
    
    function tokenURI(uint) external pure returns(string memory) { assembly {
        mstore(0x80, 0x20)
        mstore(0xa0, 0x08)
        mstore(0xc0, "IPFS URL")
        return(0x80, 0x60)
    }}

    function approve(address adr, uint tid) external { assembly {
        mstore(0x00, OOF)
        mstore(0x20, tid)
        let oof := sload(keccak256(0x00, 0x40))
        mstore(0x00, caller())
        mstore(0x20, adr)
        if and(iszero(eq(caller(), oof)), iszero(sload(keccak256(0x00, 0x40)))) {
            revert(0x00, 0x00)
        }
        mstore(0x00, GAP)
        mstore(0x20, tid)
        sstore(keccak256(0x00, 0x40), adr)
        log4(0x00, 0x00, APP, oof, adr, tid)
    }}
    
    function setApprovalForAll(address adr, bool bol) external { assembly {
        mstore(0x00, caller())
        mstore(0x20, adr)
        sstore(keccak256(0x00, 0x40), bol)
        mstore(0x00, bol)
        log3(0x00, 0x20, AFA, origin(), adr)
    }}

    function transferFrom(address, address ad2, uint tid) public { assembly {
        mstore(0x00, OOF)
        mstore(0x20, tid)
        let oof := sload(keccak256(0x00, 0x40))
        mstore(0x00, GAP)
        mstore(0x20, tid)
        if and(iszero(eq(caller(), oof)), iszero(eq(sload(keccak256(0x00, 0x40)), ad2))) {
            revert(0x00, 0x00)
        }
        sstore(oof, sub(sload(oof), 0x01))
        sstore(ad2, add(sload(ad2), 0x01))
        mstore(0x00, GAP)
        mstore(0x20, tid)
        sstore(keccak256(0x00, 0x40), 0x00)
        mstore(0x00, OOF)
        mstore(0x20, tid)
        sstore(keccak256(0x00, 0x40), ad2)
        log4(0x00, 0x00, APP, ad2, ad2, tid)
        log4(0x00, 0x00, TTF, oof, ad2, tid)
    }}
    
    function safeTransferFrom(address adr, address ad2, uint tid) external {
        transferFrom(adr, ad2, tid);
    }

    function safeTransferFrom(address adr, address ad2, uint tid, bytes memory) external {
        transferFrom(adr, ad2, tid);
    }
}
