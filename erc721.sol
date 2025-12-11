// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;


// contract (erc20) :->>> address of the same contract 
// contract (erc721) :->>> contract address + tokenid(tokenid is always unique and one contract always tokenid is not same!!)

ERC 721 ==>IERC721 ==>IERC165

IERC165 ---> ierc165 cehcking interface verification , only check erc721 which interface are using.


//safeTransferFrom
// Safely transfers the ownership of a given token ID to another address.
// Validates that the recipient is capable of receiving NFTs to prevent loss.
// Can only be called by the current owner or an approved address.

//transferFrom
// Transfers the ownership of a given token ID to another address.
// Does not check if the recipient can handle NFTs, so may result in token loss if sent to incompatible contracts.
// Can only be called by the current owner or an approved address.

//approve
// Grants permission for a specific address to transfer a particular token.
// Allows an operator to transfer one specific token on behalf of the owner.
// Only the owner or an authorized operator can call this function.

//setApprovalForAll
// Grants or revokes permission for an operator to transfer all tokens owned by the caller.
// When set to true, the operator can transfer any/all NFTs owned by the caller.
// When set to false, the operator loses the ability to transfer any of the caller's NFTs.
