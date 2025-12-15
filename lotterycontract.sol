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

   function selectWinner() public {
    require(msg.sender == manager);
    require(participants.length>3);
    uint r = random();
    address payable winner;
    uint index = r % participants.length;
    winner=participants[index];
    winner.transfer(getBalance());
    participants= new address payable[](0);


   }





}