// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

contract EtherWallet{

    address payable public owner;

    constructor(){
        owner = payable(msg.sender);
    }

    receive() external payable{} // koi v banda direct humare contract par amount send kar sakta hai 

modifier onlyModifier(){
    require(owner == msg.sender,"owner is not correct");
    _;
}
    

    function withdraw() external  onlyModifier{

        payable(owner).transfer(address(this).balance);// yaha hum contract address se hum balance ko owner ke address par transfer kar rh hai 

    }

    function contractbalanceFetch() view public returns(uint){
        return address(this).balance;
    }









}