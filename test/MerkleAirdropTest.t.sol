//SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

import {Test, console} from "forge-std/Test.sol";
import {MerkleAirdrop} from "src/MerkleAirdrop.sol";
import {Bagel} from "src/Bagel.sol";

contract MerkleAirdropTest is Test {


MerkleAirdrop public airdrop;
Bagel public token;

bytes32 public  ROOT = 0x5397775ba0b7d0a4c0bbd97205a9b984693b88b9d8bdbd83805ab2d470a3805f;
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
