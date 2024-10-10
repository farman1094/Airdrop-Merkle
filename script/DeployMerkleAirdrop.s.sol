//SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {MerkleAirdrop} from "src/MerkleAirdrop.sol";
import {Bagel} from "src/Bagel.sol";
import {IERC20} from "@OpenZeppelin/contracts/token/ERC20/ERC20.sol";

contract DeployMerkleAirdrop is Script {
    MerkleAirdrop airdrop;
    Bagel token;

    /**
     * @dev Root need to update if data has updated
     */
    bytes32 private s_merkleRoot = 0xb696ac9ecf49e0efb14edcad75ae292115739a8ec97d6e3fbf279668405f310b;
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
