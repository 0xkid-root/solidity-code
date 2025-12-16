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
    
}