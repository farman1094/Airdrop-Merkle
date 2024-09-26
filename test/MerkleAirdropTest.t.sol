//SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

import {Test, console} from "forge-std/Test.sol";
import {MerkleAirdrop} from "src/MerkleAirdrop.sol";
import {Bagel} from "src/Bagel.sol";

contract MerkleAirdropTest is Test {


MerkleAirdrop public airdrop;
Bagel public token;

bytes32 public  ROOT = 0x60e74b06a9c89088431304aafb0d418954050f1ef04edc5d77a5c57ab40c5955;
address user;
uint256 userPrivKey;

function setUp() public {
    token = new Bagel();
    airdrop = new MerkleAirdrop( ROOT, token);
    (user, userPrivKey) = makeAddrAndKey("user");
}
    function testUsersCanClaim() public view { 
        console.log("user address:", user);
        console.log("user PrivKey:", userPrivKey);

    }
}
