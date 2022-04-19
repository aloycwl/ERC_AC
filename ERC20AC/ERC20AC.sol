pragma solidity^0.8.13;//SPDX-License-Identifier:None
contract ERC20AC{
    event Transfer(address indexed from,address indexed to,uint256 value);
    event Approval(address indexed owner,address indexed spender,uint256 value);
    mapping(address=>uint256)private _balances;
    mapping(address=>bool)private _approvedContracts;
    address private _owner;
    uint256 private _totalSupply;
    constructor(){
        _owner=msg.sender;
    }
    function name()external pure returns(string memory){
        return "test ERC20";
    }
    function symbol()external pure returns(string memory){
        return "TEC20";
    }
    function decimals()external pure returns(uint8){
        return 18;
    }
    function totalSupply()external view returns(uint256){
        return _totalSupply;
    }
    function balanceOf(address account)external view returns(uint256){
        return _balances[account];
    }
    function transfer(address to,uint256 amount)external returns(bool){
        transferFrom(msg.sender,to,amount);
        return true;
    }
    function allowance(address owner,address spender)external pure returns(uint256){
        require(owner!=spender);
        return 0;
    }
    function approve(address spender,uint256 amount)external returns(bool){
        emit Approval(msg.sender,spender,amount);
        return true;
    }
    function transferFrom(address from,address to,uint256 amount)public returns(bool){
        require(_balances[from]>=amount);
        unchecked{
            amount*=1000000000000000000;
            _balances[from]-=amount;
            _balances[to]+=amount;
        }
        emit Transfer(from,to,amount);
        return true;
    }
    function MINT(address account,uint256 amount)external{
        unchecked{
            amount*=1000000000000000000;
            _totalSupply+=amount;
            _balances[account]+=amount;
        }
        emit Transfer(address(0),account,amount);
    }
    function BURN(address account,uint256 amount)external{
        require(_balances[account]>=amount);
        unchecked{
            amount*=1000000000000000000;
            _balances[account]-=amount;
            _totalSupply-=amount;
        }
        emit Transfer(account,address(0),amount);
    }
}
