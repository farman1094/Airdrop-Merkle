//SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {DevOpsTools} from "@Cyfrin/foundry-devops/src/DevOpsTools.sol";
import {Script} from "forge-std/Script.sol";
import {MerkleAirdrop} from "src/MerkleAirdrop.sol";
contract ClaimAirdrop is Script {

    error ClaimAirdropScript__InvalidSignatureLength();

    address CLAIMING_ADDRESS = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
    uint256 CLAIMING_AMOUNT = 25 * 1e18;
    bytes32 PROOF_ONE = 0xd1445c931158119b00449ffcac3c947d028c0c359c34a6646d95962b3b55c6ad; 
    bytes32 PROOF_TWO = 0xb621b06988cffb259d6651791d3ac26544384dd014be4e0090d23cd82166b732;

    bytes32[] proof = [PROOF_ONE, PROOF_TWO];

    // It's needed to correct when the cast call worked in Anvil
        /** NOTE need to be fixed */

    bytes private SIGNATURE = hex"e450f60c6ba27fc571be977d0e0e38611ffe789a305ba02cdb60ec4b0f6f141a66ae92678b889a4c120415a2e42c612b600de9c2e15a48cffb6a8cb07477f8581b";
    

function claimAirdrop(address airdrop) internal { 

    vm.startBroadcast();
    (uint8 v, bytes32 r, bytes32 s) = splitSignature(SIGNATURE);
    MerkleAirdrop(airdrop).claim(CLAIMING_ADDRESS, CLAIMING_AMOUNT, proof, v, r, s);
    vm.stopBroadcast();
}

function splitSignature (bytes memory sig) public pure returns (uint8 v, bytes32 r, bytes32 s) {
    if (sig.length != 65) {
      revert ClaimAirdropScript__InvalidSignatureLength();
    }
    // require(sig.length == 65, "invalid signature length");
    assembly {
        r := mload(add(sig, 32))
        s := mload(add(sig, 64))
        v := byte(0, mload(add(sig, 96)))
    }
}


function run() external {
    /** NOTE need to be fixed */
    // address getMostRecentDeployed = DevOpsTools.get_most_recent_deployment("MerkleAirdrop", block.chainid);
    address getMostRecentDeployed = 0x8A791620dd6260079BF849Dc5567aDC3F2FdC318;
    claimAirdrop(getMostRecentDeployed);
 }

}

// cast call 0xA8452Ec99ce0C64f20701dB7dD3abDb607c00496 "getMessageHash(address,uint256)" 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 25000000000000000000 --rpc-url $ANVIL_RPC_URL
// cast call 0xA8452Ec99ce0C64f20701dB7dD3abDb607c00496 "getAirDropToken()" --rpc-url $ANVIL_RPC_URL
// cast call 0x8607Ed778cceBd514661E84Aee1EA2FA16dA7320 "totalSupply()" --rpc-url $SEPOLIA_RPC_URL
// cast call 0x90193C961A926261B756D1E5bb255e67ff9498A1 "totalSupply()" --rpc-url $ANVIL_RPC_URL
// forge script script/DeployMerkleAirdrop.s.sol:DeployMerkleAirdrop --rpc-url $SEPOLIA_RPC_URL --account farman --broadcast --verify --etherscan-api-key $ESCAN_API_KEY -vvvv

// e450f60c6ba27fc571be977d0e0e38611ffe789a305ba02cdb60ec4b0f6f141a66ae92678b889a4c120415a2e42c612b600de9c2e15a48cffb6a8cb07477f8581b

// forge script script/DeployMerkleAirdrop.s.sol:DeployMerkleAirdrop --rpc-url $ANVIL_RPC_URL --private-key $ANVIL_PKEY --broadcast -vvvv
// forge script script/Interact.s.sol:ClaimAirdrop --rpc-url $ANVIL_RPC_URL --private-key $ANVIL_PKEY --broadcast -vvvv
