//SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

import {Test, console} from "forge-std/Test.sol";
import {MerkleAirdrop} from "src/MerkleAirdrop.sol";
import {Bagel} from "src/Bagel.sol";
import {DeployMerkleAirdrop} from "script/DeployMerkleAirdrop.s.sol";

contract MerkleAirdropTest is Test {
    MerkleAirdrop airdrop;
    Bagel token;
    DeployMerkleAirdrop deployer;

    bytes32 public ROOT = 0x5397775ba0b7d0a4c0bbd97205a9b984693b88b9d8bdbd83805ab2d470a3805f;
    uint256 AMOUNT_T0_CLAIM = 25 * 1e18;
    uint256 AMOUNT_TO_MINT = AMOUNT_T0_CLAIM * 4;

    bytes32 proofOne = 0x7cedaefebc981c11f281ea3054c53d54c89caea638607b64875616560f8e914f;
    bytes32 proofTwo = 0xb621b06988cffb259d6651791d3ac26544384dd014be4e0090d23cd82166b732;
    bytes32[] public PROOF = [proofOne, proofTwo];
    address user;
    uint256 userPrivKey;

    function setUp() public {
        deployer = new DeployMerkleAirdrop();
        (airdrop, token) = deployer.run();
        (user, userPrivKey) = makeAddrAndKey("user");
    }

    function testUsersCanClaim() public {
        vm.startPrank(user);
        token.totalSupply();
        uint256 stratingBalance = token.balanceOf(user);

        airdrop.claim(user, AMOUNT_T0_CLAIM, PROOF);

        uint256 expectedAmount = stratingBalance + AMOUNT_T0_CLAIM;
        uint256 actualAmount = token.balanceOf(user);
        assertEq(expectedAmount, actualAmount);
        vm.stopPrank();
    }
}
