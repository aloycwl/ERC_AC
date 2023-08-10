// SPDX-License-Identifier: None
pragma solidity ^0.8.18;
pragma abicoder v1;

contract Access {

    bytes32 constant private ACC = 0xba820cc3887163b837a8768e6a5b186b16a86bdf66a4448502c551f31328f85f;

    constructor() { assembly {
        mstore(0x00, ACC)
        mstore(0x20, caller())
        sstore(keccak256(0x00, 0x40), 0xff)
    }}

    modifier OnlyAccess() { assembly {
        mstore(0x00, ACC)
        mstore(0x20, caller())
        if iszero(sload(keccak256(0x00, 0x40))) {
            revert(0x00, 0x00)
        }}
        _;
    }

    function access(address adr) external view returns(uint val) { assembly {
        mstore(0x00, ACC)
        mstore(0x20, adr)
        val := sload(keccak256(0x00, 0x40))  
    }}

    function setAccess (address adr, uint acl) external OnlyAccess { assembly {
        mstore(0x00, ACC)
        mstore(0x20, adr)
        sstore(keccak256(0x00, 0x40), acl)
    }}

}