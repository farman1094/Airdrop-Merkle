// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {stdJson} from "forge-std/StdJson.sol";
import {console} from "forge-std/console.sol";

// Merkle tree input file generator script
contract GenerateInput is Script {
    uint256 private constant AMOUNT = 25 * 1e18;
    string[] types = new string[](2);
    uint256 count;
    string[] whitelist = new string[](4);
    // string private constant  INPUT_PATH = "/script/target/input.json";
    string private constant INPUT_PATH = "./script/target/input.json";

    function run() public {
        types[0] = "address";
        types[1] = "uint";
        whitelist[0] = "0x264F7948c23da2233D3458F1B4e2554f0e56c9Ca";
        whitelist[1] = "0x701477467321474712bACA6779FE8926528B3c93";
        whitelist[2] = "0xCe424b67cD1e7dA659e00dEe1C088eC9F370113B";
        whitelist[3] = "0x6CA6d1e2D5347Bfab1d91e883F1915560e09129D";
        count = whitelist.length;
        string memory input = _createJSON();
        // write to the output file the stringified output json tree dumpus
        vm.writeFile(string.concat(vm.projectRoot(), INPUT_PATH), input);

        console.log("DONE: The output is found at %s", INPUT_PATH);
    }

    function _createJSON() internal view returns (string memory) {
        string memory countString = vm.toString(count); // convert count to string
        string memory amountString = vm.toString(AMOUNT); // convert amount to string
        string memory json = string.concat('{ "types": ["address", "uint"], "count":', countString, ',"values": {');
        for (uint256 i = 0; i < whitelist.length; i++) {
            if (i == whitelist.length - 1) {
                json = string.concat(
                    json,
                    '"',
                    vm.toString(i),
                    '"',
                    ': { "0":',
                    '"',
                    whitelist[i],
                    '"',
                    ', "1":',
                    '"',
                    amountString,
                    '"',
                    " }"
                );
            } else {
                json = string.concat(
                    json,
                    '"',
                    vm.toString(i),
                    '"',
                    ': { "0":',
                    '"',
                    whitelist[i],
                    '"',
                    ', "1":',
                    '"',
                    amountString,
                    '"',
                    " },"
                );
            }
        }
        json = string.concat(json, "} }");

        return json;
    }
}
