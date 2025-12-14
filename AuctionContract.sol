// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Auction{
    address payable public auctioneer;
    uint256 public stBlock; // start time
    uint256 public edBlock; // end time 

    enum auction_state {start,running,end,cancle}

    auction_state public auctionState; 
    uint256 public highest_bid;
    uint256 public higest_payable_big;
    uint256 public big_increment;
    
}