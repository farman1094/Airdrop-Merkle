//SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {DevOpsTools} from "@Cyfrin/foundry-devops/src/DevOpsTools.sol";
import {Script} from "forge-std/Script.sol";
import {MerkleAirdrop} from "src/MerkleAirdrop.sol";
import {console} from "forge-std/console.sol";


/**
 * @dev 
 * NOTE Things to keep in mind in order to work this correctly
 * 1. Make sure to run the script/GenerateInput.s.sol script first (Chekcing the address available) 
 * 2. Then we need to run script/GenerateInput.s.sol script first
 * 3. The output file will be generated in /script/target/output.json
 * 4. Then we need to run script/DeployMerkleAirdrop.s.sol script After confirming the ROOT @dev
 * 4. Then we need to Update @dev- 
 *      - proof according to the claimin address @param proof
 *      - SIGNATURE of the claiming address signed with private key (DIGEST)
 *      - update @param hex (which come here, make sure to remove the 0x)
 * 5. Then we need to run script/Interact.s.sol script to claim. 
 * NOTE Some useful commands in bottow working with cast 
 */
contract ClaimAirdrop is Script {
    error ClaimAirdropScript__InvalidSignatureLength();
    address CLAIMING_ADDRESS = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
    uint256 CLAIMING_AMOUNT = 25 * 1e18;

    bytes32 PROOF_ONE = 0xd1445c931158119b00449ffcac3c947d028c0c359c34a6646d95962b3b55c6ad;
    bytes32 PROOF_TWO = 0xb621b06988cffb259d6651791d3ac26544384dd014be4e0090d23cd82166b732;

    bytes32[] proof = [PROOF_ONE, PROOF_TWO];

    bytes private SIGNATURE =hex"90af719cf760100338dee64bb83859f1bb9cbc4163bfb188806a3c5f4dc93109130a9695d9c0453d65144899b197fab9d33062f9c1bc7490846250c19e0b077c1c";

    function claimAirdrop(address airdrop) internal {
        vm.startBroadcast();
        (uint8 v, bytes32 r, bytes32 s) = splitSignature(SIGNATURE);
        MerkleAirdrop(airdrop).claim(CLAIMING_ADDRESS, CLAIMING_AMOUNT, proof, v, r, s);
        vm.stopBroadcast();
    }

    function splitSignature(bytes memory sig) public pure returns (uint8 v, bytes32 r, bytes32 s) {
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
        address getMostRecentDeployed = DevOpsTools.get_most_recent_deployment("MerkleAirdrop", block.chainid);
        claimAirdrop(getMostRecentDeployed);
    }
}


// forge script script/GenerateInput.s.sol:GenerateInput --rpc-url $ANVIL_RPC_URL --broadcast --private-key $ANVIL_PKEY
// forge script script/MakeMerkle.s.sol:MakeMerkle --rpc-url $ANVIL_RPC_URL --broadcast --private-key $ANVIL_PKEY
// forge script script/DeployMerkleAirdrop.s.sol:DeployMerkleAirdrop --rpc-url $ANVIL_RPC_URL --broadcast --private-key $ANVIL_PKEY
// forge script script/Interact.s.sol:ClaimAirdrop --rpc-url $ANVIL_RPC_URL --broadcast --private-key $ANVIL_PKEY
// cast call 0xcf27F781841484d5CF7e155b44954D7224caF1dD "getMessageHash(address,uint256)" 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 25000000000000000000 --rpc-url $ANVIL_RPC_URL 

