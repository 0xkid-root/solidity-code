// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {simpleCounter} from "../src/simpleCounter.sol";

contract CounterScript is Script {
    simpleCounter public counter;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        counter = new simpleCounter();

        vm.stopBroadcast();
    }
}
