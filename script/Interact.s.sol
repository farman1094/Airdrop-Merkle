//SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {DevOpsTools} from "@Cyfrin/foundry-devops/src/DevOpsTools.sol";
import {Script} from "forge-std/Script.sol";
import {MerkleAirdrop} from "src/MerkleAirdrop.sol";
import {console} from "forge-std/console.sol";

contract ClaimAirdrop is Script {
    error ClaimAirdropScript__InvalidSignatureLength();

    /**
     * @dev check or update the address as per usage
     */
    address CLAIMING_ADDRESS = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
    uint256 CLAIMING_AMOUNT = 25 * 1e18;

    bytes32 PROOF_ONE = 0xe876e703ac9dff4b8fb7416f3c78532786b7a80f536386df64c64a9191fa5406;
    bytes32 PROOF_TWO = 0x81f0e530b56872b6fc3e10f8873804230663f8407e21cef901b8aeb06a25e5e2;

    bytes32[] proof = [PROOF_ONE, PROOF_TWO];

    bytes private SIGNATURE =
        hex"f7ca7cdd06e2913a3cf3e80f599d5e377b2eabc8b263bb61e84750ec8b5f43684545429468f4335b14ed414f5aa4d7cfe951f2d0c6fc03fd7023fece9da2ee461c";
    // bytes private SIGNATURE = hex"94132d5e64c585f8759af1ca4a3495199015524592898c38a377dc9ba642c43f4511753c0212474d1b034eeb26d4e0200fa22aea8161271df807f743be8976bb1c";
    // 94132d5e64c585f8759af1ca4a3495199015524592898c38a377dc9ba642c43f4511753c0212474d1b034eeb26d4e0200fa22aea8161271df807f743be8976bb1c

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
        /**
         * NOTE need to be fixed
         */
        /**
         * @dev need to be update every time the contract is deployed. DevOps not working
         */
        // address getMostRecentDeployed = DevOpsTools.get_most_recent_deployment("MerkleAirdrop", block.chainid);
        address getMostRecentDeployed = 0x261D8c5e9742e6f7f1076Fa1F560894524e19cad;
        // address getMostRecentDeployed = 0x4FD97d5E290979bEA948684D12EC14aA08835CaB;
        claimAirdrop(getMostRecentDeployed);
    }
}
