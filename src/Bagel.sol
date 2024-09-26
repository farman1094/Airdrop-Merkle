//SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

import {ERC20} from "@OpenZeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@OpenZeppelin/contracts/access/Ownable.sol";

contract Bagel is ERC20, Ownable {
    constructor() ERC20("Bagel", "BAGEL") Ownable(msg.sender) {}
}