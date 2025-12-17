// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract EventContract{

    struct Event{
        address  organizer;
        string name;
        uint price;
        uint date;
        uint ticketCount;
        uint ticketRemain;
    }

    mapping(uint=>Event) public events;
    mapping(address => mapping(uint=>uint)) public tickets;
    uint public nextId;

    function createEvent(string memory name,uint price,uint date,uint ticketCount) external  {
        require(date>block.timestamp,"you can organize event in futture date!!");
        require(ticketCount>0,"you are organize event if you are create more than 0 tickets");
        events[nextId] =Event(msg.sender,name,price,date,ticketCount,ticketCount);
        nextId++;

    }

    function buyTicket(uint id,uint quantity) public payable{ 
        require(events[id].date != 0,"Events does not exists");
        require(events[id].date > block.timestamp,"Events has already occured!");
        require(quantity <=events[id].ticketRemain,"not enough token available");
        Event storage _event = events[id];
        require(msg.value == (_event.price*quantity),"Ethers is not enough!");
        _event.ticketRemain -=quantity;
        tickets[msg.sender][id]+=quantity;

    }

    function transferTicket(uint id,uint quantity,address to) external{
        require(events[id].date != 0,"Events does not existts!");
        require(events[id].date > block.timestamp,"Events has already occured!");
        require(tickets[msg.sender][id]>=quantity,"you do not have enough tickets!");
        tickets[msg.sender][id]-=quantity;
        tickets[to][id]+=quantity;
    }
    

}