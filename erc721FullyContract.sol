// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

// contract (erc20) :->>> address of the same contract 
// contract (erc720) :->>> contract address + tokenid(tokenid is always unique and one contract always tokenid is not same!!)

interface IERC165 {
    function supportsInterface(bytes4 interfaceID ) external view returns(bool);
}

interface IERC721 is IERC165 {
    /**
     * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
     */
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
     */
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
     */
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    /**
     * @dev Returns the number of tokens in ``owner``'s account.
     */
    function balanceOf(address owner) external view returns (uint256 balance);

    /**
     * @dev Returns the owner of the `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function ownerOf(uint256 tokenId) external view returns (address owner);

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon
     *   a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC-721 protocol to prevent tokens from being forever locked.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or
     *   {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon
     *   a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(address from, address to, uint256 tokenId) external;

    /**
     * @dev Transfers `tokenId` token from `from` to `to`.
     *
     * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC-721
     * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
     * understand this adds an external call which potentially creates a reentrancy vulnerability.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 tokenId) external;

    /**
     * @dev Gives permission to `to` to transfer `tokenId` token to another account.
     * The approval is cleared when the token is transferred.
     *
     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
     *
     * Requirements:
     *
     * - The caller must own the token or be an approved operator.
     * - `tokenId` must exist.
     *
     * Emits an {Approval} event.
     */
    function approve(address to, uint256 tokenId) external;

    /**
     * @dev Approve or remove `operator` as an operator for the caller.
     * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
     *
     * Requirements:
     *
     * - The `operator` cannot be the address zero.
     *
     * Emits an {ApprovalForAll} event.
     */
    function setApprovalForAll(address operator, bool approved) external;

    /**
     * @dev Returns the account approved for `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function getApproved(uint256 tokenId) external view returns (address operator);

    /**
     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
     *
     * See {setApprovalForAll}
     */
    function isApprovedForAll(address owner, address operator) external view returns (bool);
}
interface IERC721Receiver {
    
  function onERC721Received(
    address operator,
     address from,
     uint256 tokenId,
     bytes calldata data
 ) external  returns (bytes4);
}

abstract contract ERC720 is IERC721{

    // event Transfer(address from,address to,uint256 id);
    // mapping from token id to owner address

    mapping(uint256=>address) internal  _ownerOf;

    // mapping owner address to  token count 

    mapping(address=>uint256) internal _balanceOf;

    // mapping from tokenid to approved address 

    mapping(uint256=> address) internal _approvals; 

    // mapping from owner to operator approvals

    mapping(address=>mapping(address=>bool)) internal isApprovedForAll;

    function supportsInterface(bytes4 interfaceId) external pure returns(bool){
        return interfaceId == type(IERC721).interfaceId || interfaceId == type(IERC165).interfaceId;
    }

    function ownerOf(uint256 id) external view returns(address owner){
        owner = _ownerOf[id];
        require(owner != address(0),"token doesn't exists!");
    }

    function balanceOf(address owner) external view returns(uint){
        require(owner != address(0),"owner address not equal to zero!!");
        return _balanceOf[owner];
    }

    function setApprovalForAll(address operator,bool approved) external {
        isApprovedForAll[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender,operator,approved);
    }

    function approve(address spender,uint256 id) external {
        require(spender != address(0),"spender address is not zeero");
        address owner = _ownerOf[id];
        require(owner != address(0),"address not zero!");
        require(msg.sender == owner || isApprovedForAll[owner][msg.sender],"not authorized!");
        _approvals[id] = spender;
        emit Approval(owner,spender,id);
    }


    function getApproveed(uint256 id) external view returns(address){
        require(_ownerOf[id] != address(0),"token doesn't exists !!");
        return _approvals[id];

    }

    function _isApprovedOrOwner(address owner, address spender, uint256 id)
    internal
    view
    returns (bool)
{
    return (
        spender == owner ||
        isApprovedForAll[owner][spender] ||
        spender == _approvals[id]
    );
}

function transferFrom(address from , address to , uint id) public {
    require(from != address(0),"from != zero bhai !!");
    require(to != address(0),"transfer to zero address!!");
    require(_ownerOf[id] == from ,"not from address");
    require(_isApprovedOrOwner(from,msg.sender,id),"not approved");
    _balanceOf[from]--;
    _balanceOf[to]++;
    _ownerOf[id]= to;
    delete _approvals[id];
    emit Transfer(from,to,id);
}

// safeTransferFrom() is used to transfer an NFT safely.

function safeTransferFrom(address from, address to, uint256 id) external {
    transferFrom(from, to, id);

    require(
        to.code.length == 0 ||
        IERC721Receiver(to).onERC721Received(msg.sender, from, id, "") 
            == IERC721Receiver.onERC721Received.selector,
        "unsafe recipient"
    );
}

function safeTransferFrom(
    address from,
    address to,
    uint256 id,
    bytes calldata data
) external {
    transferFrom(from, to, id);

    require(
        to.code.length == 0 ||
        IERC721Receiver(to).onERC721Received(
            msg.sender,
            from,
            id,
            data
        ) == IERC721Receiver.onERC721Received.selector,
        "unsafe recipient"
    );
}

  function _mint(address to,uint id) internal{
    // from addres is alwasy zero in erc721,ec20 and 
    //address(0) means: no one owns this NFT.
   // _ownerOf[id] == address(0)
   //means:This NFT ID is not minted earlier,no one owns it right now,It is safe to mint
   // If this is not zero, that means:Someone already owns it ➡️ so you CANNOT mint again


    require(to != address(0),"mint adddres is not zero!");
    require(_ownerOf[id] == address(0),"already minted!"); //to. address is abcdfff. , id = 1 

    _balanceOf[to]++;
    _ownerOf[id] = to;
   

    emit Transfer(address(0),to,id);
  }


  function _burn(uint256 id) internal {
    address owner = _ownerOf[id];
    require(owner != address(0), "not minted");

    _balanceOf[owner] -= 1;

    delete _ownerOf[id];
    delete _approvals[id];

    emit Transfer(owner, address(0), id);
}






    }




     
 