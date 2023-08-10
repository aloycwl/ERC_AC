//SPDX-License-Identifier:None
pragma solidity ^0.8.18;
pragma abicoder v1;

contract ERC20AC{

    event Transfer(address indexed from, address indexed to, uint);
    event Approval(address indexed owner, address indexed spender, uint);
    bytes32 constant private TTS = 0x37a831c0f5b7923496e8c771dd27d3c61d195f75312929773a24c59604283ed2;
    bytes32 constant private APP = 0x8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925;
    bytes32 constant private TTF = 0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;

    constructor() {
        assembly {
            sstore(caller(), 0x084595161401484a000000)
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

    function decimals() external pure returns(uint) {
        assembly {
            mstore(0x00, 0x12)
            return(0x00, 0x20)
        }
    }

    function allowance(address adr, address ad2) external view returns(uint) {
        assembly {
            mstore(0x00, adr)
            mstore(0x20, ad2)
            mstore(0x00, sload(keccak256(0x00, 0x40)))
            return(0x00, 0x20)
        }
    }

    function balanceOf(address adr) external view returns(uint) {
        assembly {
            mstore(0x00, sload(adr))
            return(0x00, 0x20)
        }
    }

    function totalSupply() external view returns(uint) {
        assembly {
            mstore(0x00, sload(TTS))
            return(0x00, 0x20)
        }
    }

    function approve(address adr, uint amt) external returns(bool) {
        assembly {
            mstore(0x00, caller())
            mstore(0x20, adr)
            sstore(keccak256(0x00, 0x40), amt)
            mstore(0x00, amt)
            log3(0x00, 0x20, APP, caller(), adr)
            mstore(0x00, 0x01)
            return(0x00, 0x20)
        }
    }

    function transfer(address adr, uint amt) external returns(bool) {
        assembly {
            let bal := sload(caller())
            if gt(amt, bal) {
                revert(0x00, 0x00)
            }
            sstore(caller(), sub(bal, amt))
            sstore(adr, add(sload(adr), amt))
            mstore(0x00, amt)
            log3(0x00, 0x20, TTF, caller(), adr)
            mstore(0x00, 0x01)
            return(0x00, 0x20)
        }
    }
    
    function transferFrom(address adr, address ad2, uint amt) public returns (bool) {
        assembly {
            let bal := sload(adr)
            mstore(0x00, adr)
            mstore(0x20, ad2)
            let ptr := keccak256(0x00, 0x40)
            let alw := sload(ptr)
            if or(gt(amt, bal), gt(amt, alw)) {
                revert(0x00, 0x00)
            }
            sstore(ptr, sub(alw, amt))
            sstore(adr, sub(bal, amt))
            sstore(ad2, add(sload(ad2), amt))
            mstore(0x00, amt)
            log3(0x00, 0x20, TTF, caller(), adr)
            mstore(0x00, 0x01)
            return(0x00, 0x20)
        }
    }
}
