// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

contract simpleIterableMap{


// store value for each user
    mapping(address=>uint) public userValue;

    //store lists of all users(to allow interation)

    address[] public users;

    // track if a user has already added a value 

    mapping(address=>bool) public hasAdded;

    // add or update a value for the caller 

    function addOrUpdate(uint _value) public{
        userValue[msg.sender]= _value;

        // if this is first time then save the adresss in users array

        if(!hasAdded[msg.sender]){
            users.push(msg.sender);
            hasAdded[msg.sender]= true;
        }
    }

    //get the total number of user 

    function getTheTotalNum() public view returns(uint){
        return users.length;
    }

    // get a user address by there index  in the array -----

    function getUserAtIndex(uint index) public view returns(address){
        require(index < users.length,'index out of bonds!');
        return users[index];

    }

    //. get user address and their value at a specific index ------

    function getUserAndValue(uint index) public view returns(address,uint){
        require(index<users.length,'index out of bonds!!');
        address user = users[index]; // yaha par hume user ka address mil jaye gaa 0xshjhjhjhghgh
        return (user,userValue[user]);
    }

    // 🔹 Get all users and their values (for frontend/display use)
function getAll() public view returns (address[] memory, uint256[] memory) {
    uint256 len = users.length;
    address[] memory addresses = new address[](len);
    uint256[] memory values = new uint256[](len);

    for (uint256 i = 0; i < len; i++) {
        address user = users[i]; // 0x12324...23123
        addresses[i] = user;
        values[i] = userValue[user];
    }

    return (addresses, values);
}

}