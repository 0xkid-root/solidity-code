ERC1155--->(address to, uint256 id, uint256 amount);
ERC20 ---->(address to,uint256 amount);
ERC721 ---->(address to,uint256 tokenId);



ERC1155--->(address to, uint256 id, uint256 amount);
ERC1155 ----> address leta hai and id leta hai and is id ke kiten instence banaye uske liye amount leta hai 

interface in ERC1155

ERC1155 --->IERC1155--->IERC1155TokenReceiver




interface IERC1155 {
    function safeTransferFrom(address from,address to,uint256 id , uint256 value) external;
    function safeBatchTransferFrom(address from,address to,uint256[] calldata ids,uint256[] calldata values, bytes calldata data) external;
    function balanceOf(address owner, uint256 id) external view returns(uint256);
    function balanceOfBatch(
    address[] calldata owners,
    uint256[] calldata ids
) external view returns (uint256[] memory);

function setApprovalForAll(
    address operator,
    bool approved
) external;

function isApprovedForAll(
    address owner,
    address operator
) external view returns (bool);
}


safeBatchTransferFrom
safeBatchTransferFrom(from, to, ids, values, data)


➡ Transfers multiple token IDs in one transaction

Example:

id 1 → 5 units

id 2 → 10 units

id 3 → 1 unit

✅ Gas efficient


balanceOf
balanceOf(owner, id)


➡ Returns how many tokens of id an address owns

Example:

How many token ID 7 does Bob have?

balanceOfBatch
balanceOfBatch(owners, ids)


➡ Returns balances for multiple owners + token IDs


What is ERC-165? (Very basic)

ERC-165 is a standard for interface detection.

Why ERC-1155 NEEDS ERC-165

ERC-1155 interacts with other contracts, especially:

ERC-1155 Receiver contracts

Wallets

Marketplaces (OpenSea, Blur, etc.)

Bridges

ERC-1155 uses ERC-165 so other contracts can safely detect and confirm that the contract supports ERC-1155 before interacting with it.