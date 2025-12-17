// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


contract CroudFunding{
    mapping(address=>uint) public contributors;
    uint public raisedAmount;
    uint public noOFContributors;
    address public manager;
    uint public target;
    uint public deadline;
    uint public minimumContibution;

    constructor(uint _target,uint _deadline){
        target=_target;
        manager=msg.sender;
        minimumContibution=100 ether;
        deadline=block.timestamp + _deadline; // block.timestamp provided current block timestamp
    }

    // contributors  send amount function 

    function sendAmount() public payable{
        require(deadline>block.timestamp,"deadline has passed!");
        require(msg.value>0,"amount not equal to zero");
        require(msg.value >= minimumContibution,"minimum contribution not met!");
        
        if(contributors[msg.sender]==0){
            noOFContributors++;
        }
        contributors[msg.sender]=msg.value;
        raisedAmount+=msg.value;

    }

     // contract balance cehck function ----- 

    function getContractBalance() public view returns(uint){
        return address(this).balance;
        
    }


}