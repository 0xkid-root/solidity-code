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
        return 4;
    }
}


 // if you are deploy this code only f1,f4 function is shwoing because private and internal not calling for outside the world 
 