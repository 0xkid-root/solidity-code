// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";


// allowance function checks how much the owner has approved for spending

// transfer function directly transfers tokens

// transferFrom checks if allowance exists before transferring

/* 
If I want to transfer funds to a contract, it can be done with transfer, 
but the best practice is to use approve then transferFrom. 
When I approve an address to use my tokens on behalf of me,
the delegated address needs to call transferFrom to move the tokens.
*/


contract MyToken is ERC20{
    constructor() ERC20("MYTOKEN","MKT"){
        _mint(msg.sender,1e25);
    }
}
