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

    struct Request {
        string description;
        address payable recipient;
        uint value;
        bool completed;
        uint noOfVoters;
        mapping(address=>bool) voters;
    }
    mapping(uint=>Request) public requests;
    uint public numRequest;

    constructor(uint _target,uint _deadline){
        target=_target;
        manager=msg.sender;
        minimumContibution=1 ether;
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

    function refund() public{
        require(block.timestamp>deadline && raisedAmount <target, "you are not eliglibility to transfer your fund");
        require(contributors[msg.sender]>0);
        address payable user =payable(msg.sender);
        user.transfer(contributors[msg.sender]);
        contributors[msg.sender]=0;
    }

    modifier onlyOwner(){
        require(msg.sender == manager,"only manager can call this function");
        _;
    }

    function createRequest(string memory _description,address payable _recipient,uint _value) public onlyOwner{
        Request storage newRequest = requests[numRequest];
        numRequest++;
        newRequest.description=_description;
        newRequest.recipient=_recipient;
        newRequest.value=_value;
        newRequest.completed=false;
        newRequest.noOfVoters=0;


    }

    function voteRequest(uint _requestNo) public{
        require(contributors[msg.sender]>0,"you must be contributors!");
        Request storage thisRequest = requests[_requestNo];
        require(thisRequest.voters[msg.sender]==false,"you have already vote");
        thisRequest.voters[msg.sender]=true;
        thisRequest.noOfVoters++;
    }


}