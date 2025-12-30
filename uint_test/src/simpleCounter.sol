// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract simpleCounter {
    uint256 public count;

    function increment() public{
        count = _incrementLogic(count);
    }

    function decrement() public{
        count =_decrement(count);
    }
    function setCount(uint256 _value) public{
        count = _value;
    }

    function getCount() public view returns(uint256){
        return count;
    }
    function _incrementLogic(uint256 _count) internal pure returns(uint256){
        return _count+1;
    }
    function _decrement(uint256 _count) internal pure returns(uint256)
{
    require(_count > 0);
    return _count-1;
}
   
}
