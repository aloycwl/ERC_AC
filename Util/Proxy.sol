// ERC-897: DelegateProxy
// SPDX-License-Identifier: None
pragma solidity ^0.8.0;

import {Ownable} from "../Util/Ownable.sol";

contract Proxy is Ownable {
    
    address private imp;

    fallback() external payable {
        _delegate();
    }

    receive() external payable {
        _delegate();
    }

    function _delegate() private {
        assembly {
            calldatacopy(0x00, 0x00, calldatasize())
            pop(delegatecall(gas(), sload(IN2), 0x00, calldatasize(), 0x00, 0x00))
            returndatacopy(0x00, 0x00, returndatasize())
            return(0x00, returndatasize())
        }
    }

    function implementation() external view returns(address) {
        assembly {
            mstore(0x00, sload(IN2))
            return(0x00, 0x20)
        }
    }

    function mem(bytes32 byt, bytes32 val) external onlyOwner {
        assembly {
            sstore(byt, val)
        }
    }

    function mem(bytes32 byt) public view returns(bytes32) {
        assembly {
            mstore(0x00, sload(byt))
            return(0x00, 0x20)
        }
    }
}
