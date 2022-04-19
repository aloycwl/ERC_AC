pragma solidity^0.8.0;// SPDX-License-Identifier: MIT
library Counters {
    struct Counter {
        uint256 _value;
    }
    function current(Counter storage counter)internal view returns(uint256){
        return counter._value;
    }
    function increment(Counter storage counter)internal{
        unchecked {
            counter._value++;
        }
    }
    function decrement(Counter storage counter)internal{
        unchecked {
            counter._value--;
        }
    }
    function reset(Counter storage counter)internal{
        counter._value = 0;
    }
}
