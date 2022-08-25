// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract AutoUpdateNFT is ERC721,ERC721Enumerable,ERC721URIStorage {

    uint256 public currentPrice;

    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    AggregatorV3Interface public priceFeed;

    string bullImage="https://ipfs.io/ipfs/QmS1v9jRYvgikKQD6RrssSKiBTBH3szDK6wzRWF4QBvunR?filename=gamer_bull.json";
    string bearImage="https://ipfs.io/ipfs/QmQMqVUHjCAxeFNE9eUxf89H1b7LpdzhvQZ8TXnj4FPuX1?filename=beanie_bear.json";

    constructor() ERC721("MarketNFT", "MKRT") {
        priceFeed = AggregatorV3Interface(
            0xECe365B379E1dD183B20fc5f022230C044d51404
        );
        currentPrice = uint256(getLatestPrice());
    }
    function safeMint(address to) public  {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);

        string memory defaultUri = "https://ipfs.io/ipfs/Qmc3ueexsATjqwpSVJNxmdf2hStWuhSByHtHK5fyJ3R2xb?filename=simple_bull.json";
        _setTokenURI(tokenId, defaultUri);
    }

    function UpDateNFT() external{
        uint256 latestPrice=uint256(getLatestPrice());
        if(latestPrice==currentPrice){
            return;
        }
        else if (latestPrice < currentPrice) {
            // bear - DOWN
            updateTokenUris(false);

        } else {
            // bull - UP
            updateTokenUris(true);
        }
        currentPrice = latestPrice;

    }
    function updateTokenUris(bool higherCheck) internal {
        if (higherCheck) {
            for (uint i = 0; i < _tokenIdCounter.current() ; i++) {
                _setTokenURI(i, bullImage);
            }  
        }
        else {
            for (uint i = 0; i < _tokenIdCounter.current() ; i++) {
                _setTokenURI(i,bearImage);
            } 
        }   
    }
    function getLatestPrice() public view returns (int256) {
         (
            /*uint80 roundID*/,
            int price,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = priceFeed.latestRoundData();

        return price;
    }
    /*
    * The following functions are overrides required by Solidity.
    */
    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
