// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract PriceConsume {
    AggregatorV3Interface internal priceFeed;

    constructor() {
        /**
         * Network: Rinkeby TestNet
         * Currency:Ethereum,
         * Price in:USD
         * Address: 0x8A753747A1Fa494EC906cE90E9f37563A8AF630e
         */
        priceFeed = AggregatorV3Interface(
            0x8A753747A1Fa494EC906cE90E9f37563A8AF630e
        );
    }

    function getLatestPrice() public view returns (int) {
        (
            ,
            /*uint80 roundID*/
            int price, /*uint startedAt*/ /*uint timeStamp*/ /*uint80 answeredInRound*/
            ,
            ,

        ) = priceFeed.latestRoundData();
        return price;
    }
}
