contract ContractTest is Test {
    uint256 a;
    uint256 b;
 
    function beforeTestSetup(
        bytes4 testSelector
    ) public pure returns (bytes[] memory beforeTestCalldata) {
        if (testSelector == this.testC.selector) {
            beforeTestCalldata = new bytes[](2);
            beforeTestCalldata[0] = abi.encodePacked(this.testA.selector);
            beforeTestCalldata[1] = abi.encodeWithSignature("setB(uint256)", 1);
        }
    }
 
    function testA() public {
        require(a == 0);
        a += 1;
    }
 
    function setB(uint256 value) public {
        b = value;
    }
 
    function testC() public {
        assertEq(a, 1);
        assertEq(b, 1);
    }
}