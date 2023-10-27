// SPDX-License-Identifier: None
pragma solidity 0.8.19;

import {Check} from "../Util/Check.sol";
import {Proxy} from "../Util/Proxy.sol";

contract Governance is Check, Proxy {

    modifier onlyTop5() {
        assembly {
            if and(and(and(and(iszero(eq(sload(ER5), caller())),
                iszero(eq(sload(add(ER5, 0x01)), caller()))),
                iszero(eq(sload(add(ER5, 0x02)), caller()))),
                iszero(eq(sload(add(ER5, 0x03)), caller()))),
                iszero(eq(sload(add(ER5, 0x04)), caller()))) {
                mstore(0x80, ERR)
                mstore(0xa0, STR)
                mstore(0xc0, ER1)
                //revert(0x80, 0x64)
            }
        }
        _;
    }

    function setTop5(address[5] memory tof) external onlyOwner {
        assembly {
            mstore(0x40, tof)
            sstore(ER5, mload(0x80))
            sstore(add(ER5, 0x01), mload(0xa0))
            sstore(add(ER5, 0x02), mload(0xc0))
            sstore(add(ER5, 0x03), mload(0xe0))
            sstore(add(ER5, 0x04), mload(0x0100))
        }
    }

    function setTop5(address[5] memory tof, uint8 v, bytes32 r, bytes32 s) external onlyOwner {
        assembly {
            mstore(0x40, tof)
            sstore(ER5, mload(0x80))
            sstore(add(ER5, 0x01), mload(0xa0))
            sstore(add(ER5, 0x02), mload(0xc0))
            sstore(add(ER5, 0x03), mload(0xe0))
            sstore(add(ER5, 0x04), mload(0x0100))
        }
        isVRS(0, v, r, s);
    }

    function getTop5() external view returns(address[5] memory) {
        assembly {
            mstore(0x80, sload(ER5))
            mstore(0xa0, sload(add(ER5, 0x01)))
            mstore(0xc0, sload(add(ER5, 0x02)))
            mstore(0xe0, sload(add(ER5, 0x03)))
            mstore(0x0100, sload(add(ER5, 0x04)))
            return(0x80, 0xa0)
        }
    }
}
