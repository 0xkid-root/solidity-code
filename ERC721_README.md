# ERC721 NFT Standard - Learning Guide

## Overview
ERC721 is the standard interface for non-fungible tokens (NFTs) on the Ethereum blockchain. Unlike ERC20 tokens which are fungible, each ERC721 token is unique and indivisible.

### Token Identification Differences

- **ERC20**: Identified solely by contract address
- **ERC721**: Identified by contract address + unique token ID

In ERC721, each token ID is always unique within a contract, meaning one contract cannot have two tokens with the same ID.

## Key Differences: ERC20 vs ERC721

| Aspect | ERC20 | ERC721 |
|--------|-------|--------|
| Token Type | Fungible | Non-Fungible |
| Identification | Contract Address | Contract Address + Token ID |
| Uniqueness | All tokens are identical | Each token has a unique ID |

## Core Functions

### 1. safeTransferFrom
**Purpose**: Safely transfers ownership of a specific token ID
**Safety**: Validates recipient can receive NFTs to prevent loss
**Requirements**: Can only be called by owner or approved addresses

### 2. transferFrom
**Purpose**: Transfers ownership of a specific token ID
**Safety**: No validation of recipient capability (risk of token loss)
**Requirements**: Can only be called by owner or approved addresses

### 3. approve
**Purpose**: Grants permission for a specific address to transfer one particular token
**Scope**: Single token approval
**Revocation**: Automatically revoked when transfer occurs

### 4. setApprovalForAll
**Purpose**: Grants or revokes permission to transfer all tokens owned by caller
**Scope**: All tokens owned by caller
**Control**: Boolean flag (true = grant, false = revoke)

## Safety Mechanisms

### IERC721Receiver Interface
Ensures contracts can safely receive NFTs:
```solidity
interface IERC721Receiver {
  function onERC721Received(
    address operator,
    address from,
    uint256 tokenId,
    bytes calldata data
  ) external returns (bytes4);
}
```

### Safe Transfer Validation
After transferring, the function validates the recipient:
```solidity
require(
    to.code.length == 0 ||  // EOA wallet check
    IERC721Receiver(to).onERC721Received(msg.sender, from, id, "") 
        == IERC721Receiver.onERC721Received.selector,
    "unsafe recipient"
);
```

#### Data Parameter in safeTransferFrom

The `safeTransferFrom` function has an overload that accepts a `data` parameter:

```solidity
function safeTransferFrom(
    address from,
    address to,
    uint256 id,
    bytes calldata data
) external {
    // Implementation
}
```

**Purpose**: This version allows sending extra data along with the NFT.

**Common Use Cases**:
- Marketplaces sending extra instructions
- Gaming NFTs sending metadata to contracts
- Smart contracts receiving NFTs with additional logic
- Escrow contracts passing parameters

The `data` parameter is a bytes payload that the receiving contract can read and process in its `onERC721Received` function.

## Key Concepts

### IERC165 Interface Checking
ERC721 implements IERC165 for interface detection. This allows contracts to verify which interfaces are supported by other contracts.

```solidity
ERC721 ==> IERC721 ==> IERC165
```

IERC165 enables interface verification, allowing contracts to check which ERC721 interfaces are implemented.

### Abstract Contracts
Contracts that cannot be deployed due to incomplete implementation:
```solidity
abstract contract Animal {
    function makeSound() public virtual;  // No implementation
}
```

### Minting Events
Minting is represented as a transfer from the zero address:
```solidity
emit Transfer(address(0), to, tokenId);  // Standard mint event
```

#### Why emit Transfer(address(0), to, tokenId)?

Minting is treated as a transfer from the zero address because:
- When minting, an NFT comes from nowhere
- The "from" address is set to `address(0)` (zero address)
- The "to" address is the owner's wallet

This is the official ERC-721 standard rule and applies to other token standards as well:
- **ERC-20 mint event**: `Transfer(address(0), to, amount)`
- **ERC-721 mint event**: `Transfer(address(0), to, tokenId)`
- **ERC-1155 mint event**: Similar pattern

Every mint event in these standards uses `address(0)` as the sender, which is a consistent pattern across all Ethereum token standards.

## Best Practices

1. **Always use safeTransferFrom** when sending NFTs to contracts
2. **Implement IERC721Receiver** in contracts that receive NFTs
3. **Validate approvals** before attempting transfers
4. **Handle data parameter** for advanced use cases (marketplaces, games)

## Common Use Cases

- Digital art and collectibles
- Gaming items and assets
- Real-world asset tokenization
- Identity and certification