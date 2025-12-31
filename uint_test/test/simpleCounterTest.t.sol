// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {simpleCounter} from "../src/simpleCounter.sol";

contract CounterTest is Test {
    simpleCounter public counter;

    function setUp() public {
        counter = new simpleCounter();
        counter.setCount(0);
    }

    function test_Increment() public {
        counter.increment();
        assertEq(counter.getCount(), 1);
    }

    function testFuzz_SetNumber(uint256 x) public {
        counter.setCount(x);
        assertEq(counter.getCount(), x);
    }
}
