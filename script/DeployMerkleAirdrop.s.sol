//SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

import {Script} from "forge-std/Script.sol";
import {MerkleAirdrop} from "src/MerkleAirdrop.sol";
import {Bagel} from "src/Bagel.sol";
import {IERC20} from "@OpenZeppelin/contracts/token/ERC20/ERC20.sol";

contract DeployMerkleAirdrop is Script {
    MerkleAirdrop airdrop;
    Bagel token;

    bytes32 private s_merkleRoot = 0x5397775ba0b7d0a4c0bbd97205a9b984693b88b9d8bdbd83805ab2d470a3805f;
    uint256 private s_amountToMint = 4 * 25 * 1e18;

    function deployMerkleAirdrop() public returns (MerkleAirdrop, Bagel) {
        vm.startBroadcast();
        token = new Bagel();
        airdrop = new MerkleAirdrop(s_merkleRoot, IERC20(address(token)));
        token.mint(token.owner(), s_amountToMint);
        token.transfer(address(airdrop), s_amountToMint);

        vm.stopBroadcast();
        return (airdrop, token);
    }

    function run() public returns (MerkleAirdrop, Bagel) {
        {
            return deployMerkleAirdrop();
        }
    }
}
