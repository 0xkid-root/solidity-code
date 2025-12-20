// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract A{
    function f1() public pure returns(uint){
        return 1;
    }
    function f2() private pure returns(uint){
        return 2;
    }
    function f3() internal pure returns(uint){
        
        return 3;
    }
    function f4() external pure returns(uint){
        // uint x =f3();
        return 4;
    }
}

contract B is A{
    // uint public bx=f2();// f2 is private function and private function have no identifier to access drived conract 

    // uint public bx=f4();// same issue external identifier cant access in within the contract 

    uint public bz=f3(); // f3 function easily access because of internal within the contract access 

}

// here i m creatting object in contract 

contract C{
    A obj = new A();
    uint vx = obj.f4();a

}