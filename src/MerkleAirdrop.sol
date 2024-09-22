//SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

import {IERC20} from "@OpenZeppelin/contracts/token/ERC20/IERC20.sol";


contract MerkleAirdrop {
    // some address in the list
    // allow someone in the list to claim ERC-20 tokens
    address[] claimers; 
    bytes32 private immutable i_merkleRoot;
    IERC20 private immutable i_airDropToken;

    constructor(bytes32 merkleRoot, IERC20 airDropToken){
        i_merkleRoot = merkleRoot;
        i_airDropToken = airDropToken; 
    }

    function claim (address account, uint256 amount, bytes32[] calldata MerkleProof) external {
        // Calculate using the account, the amount, the hash => leaf node 
        
    }
}