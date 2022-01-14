// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import "./IERC20.sol";

contract MyToken is IERC20 {
    // Mapping hold balances against EOA.
    mapping(address => uint256) private _balances;

    // Mapping to hold approved allowances of token to certain address
    mapping(address => mapping(address => uint256)) private _allowances;

    // Amount of token in existance
    uint256 private _totalSupply;

    address owner;
    string name;
    string symbol;
    uint8 decimals;

    constructor() {
        name = "MS-Token";
        symbol = "MS";
        decimals = 18;
        owner = msg.sender;

        // 1 millions token to be generated
        _totalSupply = 1000000 * 10**uint256(decimals);

        // Setting total supply (1 million) to token owner address
        _balances[owner] = _totalSupply;

        // fire an event on transfer of tokens
        emit Transfer(address(this), owner, _totalSupply);
    }

    // returning totalsupply remaining in contract
    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    // returning balanceOf that specific address
    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    // transfering amount from one account to another
    function transfer(address recipient, uint256 amount)
        public
        virtual
        override
        returns (bool)
    {
        address sender = msg.sender; // the person who is calling this function
        require(sender != address(0), "Sender address is required"); // null address | burn address
        require(recipient != address(0), "Receipent address is required");
        require(_balances[sender] < amount, "Not suffecient funds");

        _balances[recipient] = _balances[recipient] + amount;
        _balances[sender] = _balances[sender] - amount;

        emit Transfer(sender, recipient, amount);
        return true;
    }

    // checking remaining amount of tokens that are approved to specific address
    function allowance(address _owner, address spender)
        public
        view
        override
        returns (uint256)
    {
        return _allowances[_owner][spender];
    }

    function approve(address spender, uint256 amount)
        public
        override
        returns (bool)
    {
        address sender = msg.sender; // the person who is calling this function
        require(sender != address(0), "Sender address is required"); // null address | burn address
        require(_balances[sender] < amount, "Not suffecient funds");

        _allowances[sender][spender] = amount;
        _balances[sender] = _balances[sender] - amount;

        emit Approval(sender, spender, amount);

        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public override returns (bool) {
        address spender = msg.sender; // the person who is calling this function
        require(
            sender != address(0),
            "Sender address should not be null address"
        );
        require(
            recipient != address(0),
            "Recipient address should not be null address"
        );
        require(_allowances[sender][spender] < amount, "Not allowed");

        //deducting allowance
        _allowances[sender][spender] = _allowances[sender][spender] - amount;
        _balances[sender] = _balances[sender] - amount;
        _balances[recipient] = _balances[recipient] + amount;
        emit Transfer(sender, recipient, amount);

        return true;
    }
}
