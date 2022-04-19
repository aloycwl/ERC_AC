pragma solidity^0.8.13;// SPDX-License-Identifier:MIT
import "IERC165.sol";
abstract contract ERC165 is IERC165{
    function supportsInterface(bytes4 interfaceId)public view virtual override returns(bool){
        return interfaceId==type(IERC165).interfaceId;
    }
}
