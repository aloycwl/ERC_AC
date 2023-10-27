// SPDX-License-Identifier: None
pragma solidity 0.8.19;

import {Governance} from "../Util/Governance.sol";

contract Node is Governance {

    event addResource(address indexed usr, address indexed gme, uint amt);

    constructor() {
        assembly {
            sstore(TTF, 0x929336a17aF293b16d025170e310d7C408C5447e) // USD = ERC20 address
            sstore(APP, origin()) // signer = msg.sender
        }
    }
    
    function games(address adr) external view returns(bool) {
        assembly {
            mstore(0x00, sload(shl(0x05, adr)))
            return(0x00, 0x20)
        }
    }

    function checkVoting(uint ind) external view returns(uint, address, bytes32[5] memory) { // 15955
        assembly {
            mstore(0x00, ind)
            let ptr := keccak256(0x00, 0x20)
            for { let i := 0x00 } lt(i, 0x07) { i := add(i, 0x01) } {
                mstore(add(0x80, mul(i, 0x20)), sload(add(ptr, i)))
            }
            return(0x80, 0x0e0)
        }
    }

    function resourceOut(uint amt, uint8 v, bytes32 r, bytes32 s) external {
        assembly { 
            mstore(0x80, TTF) // ERC20(GGC).transfer(msg.sender, amt)
            mstore(0x84, caller())
            mstore(0xa4, amt)
            pop(call(gas(), sload(TTF), 0x00, 0x80, 0x44, 0x00, 0x00))
        }
        isVRS(amt, v, r, s);
    }

    function resourceIn(address adr, uint amt) external {
        assembly { 
            if iszero(sload(shl(0x05, adr))) { // require(games[adr], "not supported");
                mstore(0x80, ERR) 
                mstore(0xa0, STR)
                mstore(0xc0, ER2)
                revert(0x80, 0x64)
            }

            mstore(0x80, TFM)  // require(transferForm(origin(), to, fee))
            mstore(0x84, origin())
            mstore(0xa4, address())
            mstore(0xc4, amt)    
            if iszero(call(gas(), sload(TTF), 0x00, 0x80, 0x64, 0x00, 0x00)) {
                mstore(0x80, ERR) 
                mstore(0xa0, STR)
                mstore(0xc0, ER5)
                revert(0x80, 0x64)
            }

            mstore(0x00, amt) // emit addResource(msg.sender, adr, amt);
            log3(0x00, 0x20, EAR, caller(), adr)
        }
    }

    function createVote(address adr, uint stt) external onlyTop5 returns(uint cnt) { // 139876
        assembly {
            cnt := add(sload(INF), 0x01)
            sstore(INF, cnt) // ++count;

            mstore(0x00, cnt)
            let ptr := keccak256(0x00, 0x20)
            sstore(ptr, stt)
            sstore(add(ptr, 0x01), adr)
            mstore(0x00, caller())
            mstore8(0x00, 0x01)
            sstore(add(ptr, 0x02), mload(0x00))
        }
    }

    function vote(uint ind, bool vot) external onlyTop5 { // 68279 / 107795
        assembly {
            mstore(0x00, ind)
            let ptr := keccak256(0x00, 0x20)
            let up
            let down

            for { let i := add(ptr, 0x02) } lt(i, add(ptr, 0x07)) { i := add(i, 0x01) } {
                let sli := sload(i)
                if iszero(sli) { // 空位
                    ind := i
                    break
                }
                if gt(sli, 0x00) {
                    switch gt(sli, STR) 
                    case 1 { 
                        up := add(up, 0x01)  // ++up;
                        mstore(0x00, sli) // 0x0100... > 0x0000...
                        mstore8(0x00, 0x00)
                        sli := mload(0x00)
                    }
                    default { down := add(down, 0x01) } // ++down;
                }
                if eq(sli, caller()) { // 已投
                    ind := 0x00
                    break
                }
            }

            let sta := sload(ptr)
            if or(iszero(sta), iszero(ind)) { // require(vo.status != 0 && vo.voters[i] != msg.sender);
                mstore(0x80, ERR) 
                mstore(0xa0, STR)
                mstore(0xc0, ER1)
                revert(0x80, 0x64)
            }

            mstore(0x00, caller())
            mstore8(0x00, vot)
            sstore(ind, mload(0x00)) // vo.voters.push(msg.sender);

            if or(eq(up, 0x02), eq(down, 0x02)) { // 投票完毕
                switch vot // 最后一票
                case 0x0 { down := add(down, 0x01) } // ++down;
                default { up := add(up, 0x01) } // ++up;
                if gt(up, 0x02) { 
                    switch gt(sta, 0x02)
                    case 1 { // 提币
                        mstore(0x80, TTF) // ERC20(GGC).transfer(msg.sender, amt)
                        mstore(0x84, sload(add(ptr, 0x01)))
                        mstore(0xa4, sta)
                        pop(call(gas(), sload(TTF), 0x00, 0x80, 0x44, 0x00, 0x00))
                    }
                    default {  // 加/减游戏
                        sstore(shl(0x05, sload(add(ptr, 0x01))), mod(sta, 0x02))
                    }
                }
                sstore(ptr, 0x00) // vo.status = 0;
            }

        }
    }
}
