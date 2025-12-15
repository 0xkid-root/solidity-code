// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract lottery{

    address public manager;
    address payable[] public participants;

    constructor(){
        manager = msg.sender;
    }

    receive() external payable {
        require(msg.value == 1 ether);
        participants.push(payable(msg.sender));
    }

    function getBalance() public view returns(uint){
        require(msg.sender == manager);
        return address(this).balance;
    }

    function random() public view returns (uint) {
    return uint(
        keccak256(
            abi.encodePacked(
                block.prevrandao, // replacement for difficulty
                block.timestamp,
                participants.length,
                msg.sender
            )
        )
    );
}





}