// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//import "installed_contracts/zeppelin/contracts/math/Math.sol";

contract erc20token {
    //using SafeMath for uint256;

    // Variable

    string public constant name = "erc20token";
    string public constant symbol = "ESC";
    uint256 public constant decimals = 18;
    uint256 public constant totalSupply = 100000000000000000;

    mapping(address => uint256) public _balances;
    mapping(address => mapping(address => uint256)) public _allowed;

    constructor() public{
        //totalSupply = 1000000 * (10**decimals);
        _balances[msg.sender] = totalSupply;
    }

    // Events
    event Approve(address tokenOwner, address spender, uint256 value);
    event Transfer(address indexed from, address indexed to, uint256 value);

    function approve(address spender, uint256 value) public returns (bool) {
        require(spender != address(0));

        _allowed[msg.sender][spender] = value;
        emit Approve(msg.sender, spender, value);
        return true;
    }

    function transfer(address _to, uint256 _value)
        public
        returns (bool success)
    {
        require(_value <= _balances[msg.sender]);
        require(_to != address(0));

        _balances[msg.sender] = _balances[msg.sender] - (_value);
        _balances[_to] = _balances[_to] + (_value);
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function _totalSupply() public pure returns (uint256) {
        return totalSupply;
    }

    function balanceOf(address tokenOwner) public view returns (uint256) {
        return _balances[tokenOwner];
    }

    function allowance(address owner, address spender)
        public
        view
        returns (uint256)
    {
        return _allowed[owner][spender];
    }

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) public returns (bool) {
        require(value <= _balances[from]);
        require(value <= _allowed[from][msg.sender]);
        require(to != address(0));

        _balances[from] = _balances[from] - (value);
        _balances[to] = _balances[to] + (value);
        _allowed[from][msg.sender] = _allowed[from][msg.sender] - (value);
        emit Transfer(from, to, value);
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue)
        public
        returns (bool)
    {
        require(spender != address(0));

        _allowed[msg.sender][spender] = (_allowed[msg.sender][spender] +
            (addedValue));
        emit Approve(msg.sender, spender, _allowed[msg.sender][spender]);
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue)
        public
        returns (bool)
    {
        require(spender != address(0));

        _allowed[msg.sender][spender] = (_allowed[msg.sender][spender] -
            (subtractedValue));
        emit Approve(msg.sender, spender, _allowed[msg.sender][spender]);
        return true;
    }

    function _mint(address account, uint256 amount) internal {
        require(amount > 0);
        _balances[account] = _balances[account] + (amount);
        emit Transfer(address(0), account, amount);
    }

    function _burn(address account, uint256 amount) internal {
        require(amount > 0);
        require(amount <= _balances[account]);
        _balances[account] = _balances[account] - (amount);
        emit Transfer(account, address(0), amount);
    }

    function _burnFrom(address account, uint256 amount) internal {
        require(amount <= _allowed[account][msg.sender]);

        _allowed[account][msg.sender] =
            _allowed[account][msg.sender] -
            (amount);
        _burn(account, amount);
    }
}
