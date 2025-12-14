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


// contract ius here:-----

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/*//////////////////////////////////////////////////////////////
                            INTERFACES
//////////////////////////////////////////////////////////////*/

interface IERC165 {
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

interface IERC1155 is IERC165 {
    event TransferSingle(
        address indexed operator,
        address indexed from,
        address indexed to,
        uint256 id,
        uint256 value
    );

    event TransferBatch(
        address indexed operator,
        address indexed from,
        address indexed to,
        uint256[] ids,
        uint256[] values
    );

    event ApprovalForAll(
        address indexed owner,
        address indexed operator,
        bool approved
    );

    function balanceOf(address owner, uint256 id)
        external
        view
        returns (uint256);

    function balanceOfBatch(
        address[] calldata owners,
        uint256[] calldata ids
    ) external view returns (uint256[] memory);

    function setApprovalForAll(address operator, bool approved) external;

    function isApprovedForAll(address owner, address operator)
        external
        view
        returns (bool);

    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 value,
        bytes calldata data
    ) external;

    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] calldata ids,
        uint256[] calldata values,
        bytes calldata data
    ) external;
}

interface IERC1155Receiver is IERC165 {
    function onERC1155Received(
        address operator,
        address from,
        uint256 id,
        uint256 value,
        bytes calldata data
    ) external returns (bytes4);

    function onERC1155BatchReceived(
        address operator,
        address from,
        uint256[] calldata ids,
        uint256[] calldata values,
        bytes calldata data
    ) external returns (bytes4);
}

/*//////////////////////////////////////////////////////////////
                        ERC1155 CONTRACT
//////////////////////////////////////////////////////////////*/

contract MyERC1155 is IERC1155 {
    // balances[owner][id] => amount
    mapping(address => mapping(uint256 => uint256)) internal balances;

    // operator approvals
    mapping(address => mapping(address => bool)) internal operatorApproval;

    /*//////////////////////////////////////////////////////////////
                            ERC165
    //////////////////////////////////////////////////////////////*/

    function supportsInterface(bytes4 interfaceId)
        public
        pure
        override
        returns (bool)
    {
        return
            interfaceId == type(IERC1155).interfaceId ||
            interfaceId == type(IERC165).interfaceId;
    }

    /*//////////////////////////////////////////////////////////////
                        VIEW FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    function balanceOf(address owner, uint256 id)
        public
        view
        override
        returns (uint256)
    {
        require(owner != address(0), "zero address");
        return balances[owner][id];
    }

    function balanceOfBatch(
        address[] calldata owners,
        uint256[] calldata ids
    ) external view override returns (uint256[] memory batchBalances) {
        require(owners.length == ids.length, "length mismatch");

        batchBalances = new uint256[](owners.length);

        for (uint256 i = 0; i < owners.length; i++) {
            batchBalances[i] = balances[owners[i]][ids[i]];
        }
    }

    /*//////////////////////////////////////////////////////////////
                        APPROVALS
    //////////////////////////////////////////////////////////////*/

    function setApprovalForAll(address operator, bool approved)
        external
        override
    {
        operatorApproval[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);
    }

    function isApprovedForAll(address owner, address operator)
        public
        view
        override
        returns (bool)
    {
        return operatorApproval[owner][operator];
    }

    /*//////////////////////////////////////////////////////////////
                        TRANSFERS
    //////////////////////////////////////////////////////////////*/

    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 value,
        bytes calldata data
    ) external override {
        require(
            from == msg.sender || isApprovedForAll(from, msg.sender),
            "not authorized"
        );
        require(to != address(0), "to zero address");

        balances[from][id] -= value;
        balances[to][id] += value;

        emit TransferSingle(msg.sender, from, to, id, value);

        _doSafeTransferAcceptanceCheck(
            msg.sender,
            from,
            to,
            id,
            value,
            data
        );
    }

    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] calldata ids,
        uint256[] calldata values,
        bytes calldata data
    ) external override {
        require(
            from == msg.sender || isApprovedForAll(from, msg.sender),
            "not authorized"
        );
        require(ids.length == values.length, "length mismatch");
        require(to != address(0), "to zero address");

        for (uint256 i = 0; i < ids.length; i++) {
            balances[from][ids[i]] -= values[i];
            balances[to][ids[i]] += values[i];
        }

        emit TransferBatch(msg.sender, from, to, ids, values);

        _doSafeBatchTransferAcceptanceCheck(
            msg.sender,
            from,
            to,
            ids,
            values,
            data
        );
    }

    /*//////////////////////////////////////////////////////////////
                        MINT / BURN
    //////////////////////////////////////////////////////////////*/

    function _mint(
        address to,
        uint256 id,
        uint256 amount
    ) internal {
        require(to != address(0), "to zero");

        balances[to][id] += amount;

        emit TransferSingle(msg.sender, address(0), to, id, amount);
    }

    function _burn(
        address from,
        uint256 id,
        uint256 amount
    ) internal {
        balances[from][id] -= amount;

        emit TransferSingle(msg.sender, from, address(0), id, amount);
    }

    /*//////////////////////////////////////////////////////////////
                    RECEIVER CHECKS
    //////////////////////////////////////////////////////////////*/

    function _doSafeTransferAcceptanceCheck(
        address operator,
        address from,
        address to,
        uint256 id,
        uint256 value,
        bytes calldata data
    ) private {
        if (to.code.length > 0) {
            require(
                IERC1155Receiver(to).onERC1155Received(
                    operator,
                    from,
                    id,
                    value,
                    data
                ) ==
                    IERC1155Receiver.onERC1155Received.selector,
                "unsafe receiver"
            );
        }
    }

    function _doSafeBatchTransferAcceptanceCheck(
        address operator,
        address from,
        address to,
        uint256[] calldata ids,
        uint256[] calldata values,
        bytes calldata data
    ) private {
        if (to.code.length > 0) {
            require(
                IERC1155Receiver(to).onERC1155BatchReceived(
                    operator,
                    from,
                    ids,
                    values,
                    data
                ) ==
                    IERC1155Receiver.onERC1155BatchReceived.selector,
                "unsafe receiver"
            );
        }
    }
}
