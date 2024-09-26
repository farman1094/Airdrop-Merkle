//SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

import {IERC20, SafeERC20} from "@OpenZeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {MerkleProof} from "@OpenZeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract MerkleAirdrop {
    error MerkleAirdrop__InvalidProof();
    error MerkleAirdrop__AlreadyClaimed();

    using SafeERC20 for IERC20;
    // some address in the list
    // allow someone in the list to claim ERC-20 tokens

    mapping(address claimer => bool claimed) private s_hasClaimed;
    address[] claimers;
    bytes32 private immutable i_merkleRoot;
    IERC20 private immutable i_airDropToken;

    event Claim(address account, uint256 amount);

    constructor(bytes32 merkleRoot, IERC20 airDropToken) {
        i_merkleRoot = merkleRoot;
        i_airDropToken = airDropToken;
    }

    function claim(address account, uint256 amount, bytes32[] calldata merkleProof) external {
        if (s_hasClaimed[account]) {
            revert MerkleAirdrop__AlreadyClaimed();
        }
        // Calculate using the account, the amount, the hash => leaf node
        // second pre-image attack (to save from same hash collision) (hash it twice)
        bytes32 leaf = keccak256(bytes.concat(keccak256(abi.encode(account, amount))));
        if (!MerkleProof.verify(merkleProof, i_merkleRoot, leaf)) {
            revert MerkleAirdrop__InvalidProof();
        }
        s_hasClaimed[account] = true;
        emit Claim(account, amount);
        i_airDropToken.safeTransfer(account, amount);
    }

    function getMerkleRoot() external view returns (bytes32) {
        return i_merkleRoot;
    }

    function getAirDropToken() external view returns (IERC20) {
        return i_airDropToken;
    }

    function toCheckClaimed(address account) external view returns (bool) {
        return s_hasClaimed[account];
    }
}
