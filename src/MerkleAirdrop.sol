//SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {IERC20, SafeERC20} from "@OpenZeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {MerkleProof} from "@OpenZeppelin/contracts/utils/cryptography/MerkleProof.sol";
import {EIP712} from "@OpenZeppelin/contracts/utils/cryptography/EIP712.sol";
import {ECDSA} from "@OpenZeppelin/contracts/utils/cryptography/ECDSA.sol";

contract MerkleAirdrop is EIP712 {
    error MerkleAirdrop__InvalidProof();
    error MerkleAirdrop__AlreadyClaimed();
    error MerkleAirdrop__InvalidSignature();

    using SafeERC20 for IERC20;
    // some address in the list
    // allow someone in the list to claim ERC-20 tokens

    mapping(address claimer => bool claimed) private s_hasClaimed;
    address[] claimers;
    bytes32 private immutable i_merkleRoot;
    IERC20 private immutable i_airDropToken;

    bytes32 private constant MESSAGE_TYPEHASH = keccak256("AirDropClaim(address account, uint256 amount)");

    struct AirDropClaim {
        address account;
        uint256 amount;
    }

    event Claim(address account, uint256 amount);

    constructor(bytes32 merkleRoot, IERC20 airDropToken) EIP712("MerkleAirdrop", "1") {
        i_merkleRoot = merkleRoot;
        i_airDropToken = airDropToken;
    }

    function claim(address account, uint256 amount, bytes32[] calldata merkleProof, uint8 v, bytes32 r, bytes32 s)
        external
    {
        if (s_hasClaimed[account]) {
            revert MerkleAirdrop__AlreadyClaimed();
        }

        // Check the signature
        if (!_isValidSignature(account, getMessageHash(account, amount), v, r, s)) {
            revert MerkleAirdrop__InvalidSignature();
        }
        // Calculate using the account, the amount, the hash ==> leaf node
        // second pre-image attack (to save from same hash collision) (hash it twice)
        bytes32 leaf = keccak256(bytes.concat(keccak256(abi.encode(account, amount))));
        if (!MerkleProof.verify(merkleProof, i_merkleRoot, leaf)) {
            revert MerkleAirdrop__InvalidProof();
        }
        s_hasClaimed[account] = true;
        emit Claim(account, amount);
        i_airDropToken.safeTransfer(account, amount);
    }

    function getMessageHash(address account, uint256 amount) public view returns (bytes32) {
        return
            _hashTypedDataV4(keccak256(abi.encode(MESSAGE_TYPEHASH, AirDropClaim({account: account, amount: amount}))));
    }

    function _isValidSignature(address account, bytes32 digest, uint8 v, bytes32 r, bytes32 s)
        internal
        pure
        returns (bool)
    {
        (address actualSigner,,) = ECDSA.tryRecover(digest, v, r, s);
        return actualSigner == account;
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
