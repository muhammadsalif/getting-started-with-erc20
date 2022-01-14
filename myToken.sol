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
}
