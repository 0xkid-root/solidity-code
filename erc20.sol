// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";


// allowance function check karta hai ke owner ne kitne spend krne ka limit diya hai 

// transfer function direct transfer kar deta hai 
// transferform check karta. hai phale allowance hai ke nhi 


contract MyToken is ERC20{
    constructor() ERC20("MYTOKWN","MKT"){
        _mint(msg.sender,1e25);
    }

}