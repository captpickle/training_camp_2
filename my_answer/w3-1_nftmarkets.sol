//  SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";




contract TwcToken is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    constructor() ERC721("TwcToken", "TTT") {}
    function awardItem(address player, string memory tokenURI)
        public
        returns (uint256)
    {
        uint256 newItemId = _tokenIds.current();
        _mint(player, newItemId);
        _setTokenURI(newItemId, tokenURI);

        _tokenIds.increment();
        return newItemId;
    }
}



import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
contract nftMarckets is ERC20  {
    IERC721 nft;
     constructor(uint256 initialSupply,address nft) ERC20("Gold", "GLD") {
        _mint(msg.sender, initialSupply);
        nft = IERC721(nft);
    }
    struct NFTSku {
        uint256 nftId;
        uint256 price;
        address owner;
    }
     
    mapping(uint256 => NFTSku) public nftSku;
    function createNftSku(uint256 nftId,uint256 price) public {
        //require msg.sender has nft
        require(nft.ownerOf(nftId) == msg.sender,"you don't have this nft") ;
        nftSku[nftId] = NFTSku(nftId,price,msg.sender);
    }
   

    function  buyNft(uint256 price,uint256 nftId) public{
        require(nftSku[nftId].price == price,"price is not correct");
        require(nftSku[nftId].owner != msg.sender,"you are the owner");
        require(balanceOf(msg.sender) >= price,"you don't have enough gold");
        _transfer(msg.sender,nftSku[nftId].owner,price);
        nft.transferFrom(nftSku[nftId].owner,msg.sender,nftId);
        nftSku[nftId].owner = msg.sender;
    }
}