pragma solidity^0.8.13;//SPDX-License-Identifier:None
contract ERC20AC{
    event Transfer(address indexed a,address indexed b,uint c);
    event Approval(address indexed a,address indexed b,uint c);
    mapping(address=>uint)private _balances;
    mapping(address=>mapping(address=>uint256))private _allowances;
    address private _owner;
    uint private _totalSupply;
    constructor(){
        _owner=msg.sender;
    }
    function name()external pure returns(string memory){
        return "Ethereum Request for Command 20 Aloysius Chan";
    }
    function symbol()external pure returns(string memory){
        return "ERC20AC";
    }
    function decimals()external pure returns(uint){
        return 18;
    }
    function totalSupply()external view returns(uint){
        return _totalSupply;
    }
    function balanceOf(address a)external view returns(uint){
        return _balances[a];
    }
    function transfer(address a,uint b)external returns(bool){
        transferFrom(msg.sender,a,b);
        return true;
    }
    function allowance(address a,address b)external view returns(uint){
        return _allowances[a][b];
    }
    function approve(address a,uint b)external returns(bool){
        _allowances[msg.sender][a]=b;
        emit Approval(msg.sender,a,b);
        return true;
    }
    function transferFrom(address a,address b,uint c)public returns(bool){unchecked{
        require(_balances[a]>=c);
        require(a==msg.sender||_allowances[a][b]>=c);
        _balances[a]-=c;
        _balances[b]+=c;
        emit Transfer(a,b,c);
        return true;
    }}
    function MINT(address a,uint b)external{unchecked{
        b*=1e18;
        _totalSupply+=b;
        _balances[a]+=b;
        emit Transfer(address(0),a,b);
    }}
    function BURN(address a,uint b)external{unchecked{
        b*=1e18;
        require(_balances[a]>=b);
        _balances[a]-=b;
        _totalSupply-=b;
        emit Transfer(a,address(0),b);
    }}
}
