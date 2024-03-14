// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// MockErc20 is a mock ERC20 token for testing purposes
contract MockERC20 is ERC20 {
    constructor() ERC20("DAI Token", "DAI") {
        _mint(msg.sender, 1000000000000000000000000);
    }
}
