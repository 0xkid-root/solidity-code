# Solidity Smart Contract Learning

This repository contains smart contracts developed while learning Solidity and blockchain development.

## Contracts Overview

### 1. EtherWallet.sol
A simple Ethereum wallet contract that allows:
- Owner to deposit and withdraw Ether
- Restricted access to owner-only functions using a custom modifier

### 2. MultiSigWallet.sol
A multi-signature wallet implementation that requires multiple approvals for transactions.

### 3. erc20.sol
An ERC-20 token implementation using OpenZeppelin contracts with custom token creation.

## Learning Objectives

This repository serves as a revision and learning exercise covering:

1. **Basic Solidity Syntax**
   - Contract structure
   - State variables and functions
   - Constructors and modifiers

2. **Ethereum Wallet Development**
   - Ether handling with receive() function
   - Access control with modifiers
   - Owner-only function restrictions

3. **Multi-Signature Wallets**
   - Transaction approval mechanisms
   - Multiple signer validation
   - Security patterns in smart contracts

4. **ERC-20 Token Standard**
   - Token creation and minting
   - Using OpenZeppelin library
   - Allowance and transfer mechanisms
   - Best practices for token transfers

## Key Concepts Practiced

- **Security Patterns**: Using modifiers for access control
- **Error Handling**: Proper use of require() statements
- **Gas Optimization**: Efficient contract design
- **Best Practices**: Code documentation and structure