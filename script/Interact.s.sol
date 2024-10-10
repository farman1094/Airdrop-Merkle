//SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {DevOpsTools} from "@Cyfrin/foundry-devops/src/DevOpsTools.sol";
import {Script} from "forge-std/Script.sol";
import {MerkleAirdrop} from "src/MerkleAirdrop.sol";
import {console} from "forge-std/console.sol";

contract ClaimAirdrop is Script {

    error ClaimAirdropScript__InvalidSignatureLength();

    address CLAIMING_ADDRESS = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
    uint256 CLAIMING_AMOUNT = 25 * 1e18;
    
    bytes32 PROOF_ONE = 0xe876e703ac9dff4b8fb7416f3c78532786b7a80f536386df64c64a9191fa5406; 
    bytes32 PROOF_TWO = 0x81f0e530b56872b6fc3e10f8873804230663f8407e21cef901b8aeb06a25e5e2;


    bytes32[] proof = [PROOF_ONE, PROOF_TWO];

    
    bytes private SIGNATURE = hex"f7ca7cdd06e2913a3cf3e80f599d5e377b2eabc8b263bb61e84750ec8b5f43684545429468f4335b14ed414f5aa4d7cfe951f2d0c6fc03fd7023fece9da2ee461c";
    

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
    /** @dev need to be update every time the contract is deployed. DevOps not working */
    // address getMostRecentDeployed = DevOpsTools.get_most_recent_deployment("MerkleAirdrop", block.chainid);
    address getMostRecentDeployed = 0x261D8c5e9742e6f7f1076Fa1F560894524e19cad;
    // address getMostRecentDeployed = 0x90193C961A926261B756D1E5bb255e67ff9498A1;
    claimAirdrop(getMostRecentDeployed);
 }

}

// cast call 0x261D8c5e9742e6f7f1076Fa1F560894524e19cad "getMessageHash(address,uint256)" 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 25000000000000000000 --rpc-url $ANVIL_RPC_URL
// cast call 0xA8452Ec99ce0C64f20701dB7dD3abDb607c00496 "getAirDropToken()" --rpc-url $ANVIL_RPC_URL
// cast call 0x8607Ed778cceBd514661E84Aee1EA2FA16dA7320 "totalSupply()" --rpc-url $SEPOLIA_RPC_URL
// cast call 0x90193C961A926261B756D1E5bb255e67ff9498A1 "totalSupply()" --rpc-url $ANVIL_RPC_URL
// forge script script/DeployMerkleAirdrop.s.sol:DeployMerkleAirdrop --rpc-url $SEPOLIA_RPC_URL --account farman --broadcast --verify --etherscan-api-key $ESCAN_API_KEY -vvvv

// e450f60c6ba27fc571be977d0e0e38611ffe789a305ba02cdb60ec4b0f6f141a66ae92678b889a4c120415a2e42c612b600de9c2e15a48cffb6a8cb07477f8581b

// forge script script/DeployMerkleAirdrop.s.sol:DeployMerkleAirdrop --rpc-url $ANVIL_RPC_URL --private-key $ANVIL_PKEY --broadcast -vvvv
// forge script script/Interact.s.sol:ClaimAirdrop --rpc-url $ANVIL_RPC_URL --private-key $ANVIL_PKEY --broadcast -vvvv

// cast wallet sign --no-hash 0x7df776375713d667a033990e116c1a680ebdf10728d5b2d62e39f5ae401b5b02 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80


// cast wallet sign --no-hash 0x184e30c4b19f5e304a893524210d50346dad61c461e79155b910e73fd856dc72 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
// 0xfbd2270e6f23ff5e9248480c0f4be8a4e9bd77c3ad0b1333cc60b5debc611602a2a06c24085d8d7c038bad84edc1144dc11c