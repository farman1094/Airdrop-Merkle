//SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";

import {MerkleAirdrop} from "src/MerkleAirdrop.sol";
import {Bagel} from "src/Bagel.sol";
import {DeployMerkleAirdrop} from "script/DeployMerkleAirdrop.s.sol";

contract MerkleAirdropTest is Test{
    MerkleAirdrop airdrop;
    Bagel token;
    DeployMerkleAirdrop deployer;

    bytes32 public ROOT = 0xb696ac9ecf49e0efb14edcad75ae292115739a8ec97d6e3fbf279668405f310b;
    uint256 AMOUNT_T0_CLAIM = 25 * 1e18;
    uint256 AMOUNT_TO_MINT = AMOUNT_T0_CLAIM * 4;


    bytes32 proofOne = 0xd1445c931158119b00449ffcac3c947d028c0c359c34a6646d95962b3b55c6ad;
    bytes32 proofTwo = 0xb621b06988cffb259d6651791d3ac26544384dd014be4e0090d23cd82166b732;


    address public gasPayer;
    bytes32[] public PROOF = [proofOne, proofTwo];
    address user = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
    uint256 userPrivKey = 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;

    function setUp() public {
        deployer = new DeployMerkleAirdrop();
        (airdrop, token) = deployer.run();
        // (user, userPrivKey) = makeAddrAndKey("user");
        gasPayer = makeAddr("gasPayer");
    }

    function testUsersCanClaim() public {
        uint256 stratingBalance = token.balanceOf(user);
        bytes32 digest = airdrop.getMessageHash(user, AMOUNT_T0_CLAIM);

        // sign the message
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(userPrivKey, digest);

        // To claim the airdrop for the user
        vm.prank(gasPayer);
        airdrop.claim(user, AMOUNT_T0_CLAIM, PROOF, v, r, s);

        uint256 expectedAmount = stratingBalance + AMOUNT_T0_CLAIM;
        uint256 actualAmount = token.balanceOf(user);
        assertEq(expectedAmount, actualAmount);
    }


}
