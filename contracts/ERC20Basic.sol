// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// Documentation:
// https://eips.ethereum.org/EIPS/eip-20

// References:
// 1.https://ethereum.org/en/developers/tutorials/understand-the-erc-20-token-smart-contract/
// 2. https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol
// 3. https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol

interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend of behalf of `owner` through {transferFrom}.
     * This is zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(
        address owner,
        address spender
    ) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(
        address recipient,
        uint256 amount
    ) external returns (bool);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`)
     * to another (`to`).
     *
     * Note: `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set
     * by a call to {approve}. `value` is the new allowance.
     */
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

contract ERC20Basic is IERC20 {
    string private immutable _name;
    string private immutable _symbol;

    uint256 private _totalSupply;
    mapping(address => uint256) private _balances;
    // { owner : { spender: amount } }
    mapping(address => mapping(address => uint256)) private _allowances;

    /**
     * @dev Sets the values of {name}, {symbol} & {todalSupply}.
     *
     * {name} & {symbol} values are immutable:
     * They can only be set once during construction.
     */
    constructor(string memory name, string memory symbol) {
        _name = name;
        _symbol = symbol;

        balances[msg.sender] = _totalSupply;
    }

    /**
     * @dev Transfer tokens
     * Subtracts `owner` (msg.sender) address amount and add to `recipient` address
     */
    function transfer(
        address recipient,
        uint256 amount
    ) public override returns (bool success) {
        require(amount <= balances[msg.sender]);

        _balances[msg.sender] = _balances[msg.sender] - amount;
        _balances[recipient] = _balances[recipient] + ammount;

        emit Transfer(msg.sender, recipient, amount);

        return true;
    }

    /**
     * @dev Approves `spender` the `amount` of allowences
     */
    function approve(
        address spender,
        uint256 amount
    ) public override returns (bool success) {
        _allowances[msg.sender][spender] = amount;

        emit Approval(msg.sender, spender, amount);

        return true;
    }

    /**
     * @dev Transfers `amount` from `owner` to `recipient`
     */
    function transferFrom(
        address owner,
        address recipient,
        uint256 amount
    ) public override returns (bool success) {
        require(amount <= _balances[owner]);
        // check whether spender (`msg.sender`) is allowed by `owner`
        // to manipulate the `amount`
        require(amount <= _allowances[owner][msg.sender]);

        _balances[owner] = _balances[owner] - amount;
        _allowances[owner][msg.sender] =
            _allowances[owner][msg.sender] -
            amount;

        _balances[recipient] = _balances[recipient] + amount;

        emit Transfer(owner, recipient, amount);

        return true;
    }

    /**
     * @dev see {IERC20-totalSupply}
     */
    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev see {IERC20-allowance}
     */
    function allowance(
        address owner,
        address spender
    ) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev see {IERC20-balanceOf}
     */
    function balanceOf(address owner) public view override returns (uint256) {
        return _balances[owner];
    }
}
