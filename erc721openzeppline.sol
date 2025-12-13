// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721URIStorage} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

// ownable.sol hai ye provide karta hai ke khhud ka modifier nhi lagne pade gee ye sab handle karta hai jesse gas coste bachta hai 

// import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol"; ye jo hai erc721 he hai chhaiye he chhaiye 

contract HappyMyNFT is ERC721,ERC721URIStorage,Ownable{


    uint256 private nextTokenId ;

    constructor(address initialOwner)
    ERC721("HappyMyNFT","HMFT")
    Ownable(initialOwner){}

    function safeMint(address to,string memory uri) public onlyOwner returns(uint256 ){
        uint256 _tokenId = nextTokenId++;
        _safeMint(to,_tokenId);
        _setTokenURI(_tokenId,uri);
        return _tokenId; 
    }

    function tokenURI(uint tokenId) public view override(ERC721,ERC721URIStorage) returns(string memory){
        return super.tokenURI(tokenId);

    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC721,ERC721URIStorage) returns(bool){
        return super.supportsInterface(interfaceId);
    }

}