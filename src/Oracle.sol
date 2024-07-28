// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Chainlink, ChainlinkClient} from "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";
import {ConfirmedOwner} from "@chainlink/contracts/src/v0.8/shared/access/ConfirmedOwner.sol";
import {LinkTokenInterface} from "@chainlink/contracts/src/v0.8/shared/interfaces/LinkTokenInterface.sol";

contract WeatherOracle is ChainlinkClient, ConfirmedOwner {
    using Chainlink for Chainlink.Request;

    uint256 public temp;
    bytes32 private jobId;
    uint256 private fee;

    event RequestTemp(bytes32 indexed requestId, uint256 temp);

    constructor() ConfirmedOwner(msg.sender) {
        _setChainlinkToken(0x779877A7B0D9E8603169DdbD7836e478b4624789);
        _setChainlinkOracle(0x6090149792dAAeE9D1D568c9f9a6F6B46AA29eFD);
        jobId = "fcf4140d696d44b687012232948bdd5d";
        fee = 0.1 * 10 ** 3;
    }

    /**
     * Create a Chainlink request to retrieve API response, find the target
     * data, then multiply by 1000 (to remove decimal places from data).
     */
    function requestCurrTemp(string calldata location, string calldata data) public returns (bytes32 requestId) {
        Chainlink.Request memory req = _buildChainlinkRequest(jobId, address(this), this.fulfill.selector);

        // Set the URL to perform the GET request on
        string memory apiLink = string.concat(
            "https://api.weatherapi.com/v1/current.json?key=5d438b53bf2d40378b253430241507&q=", "", location
        );
        req._add("get", apiLink);

        req._add("path", data);

        // Multiply the result by 1000 to remove decimals
        int256 timesAmount = 10 ** 3;
        req._addInt("times", timesAmount);

        // Sends the request
        return _sendChainlinkRequest(req, fee);
    }

    /**
     * Receive the response in the form of int256
     */
    function fulfill(bytes32 _requestId, uint256 _temp) public recordChainlinkFulfillment(_requestId) {
        emit RequestTemp(_requestId, _temp);
        temp = _temp;
    }

    /**
     * Allow withdraw of Link tokens from the contract
     */
    function withdrawLink() public onlyOwner {
        LinkTokenInterface link = LinkTokenInterface(_chainlinkTokenAddress());
        require(link.transfer(msg.sender, link.balanceOf(address(this))), "Unable to transfer");
    }

    /// @notice Get temp from the api
    function getTemp() external view returns (uint256) {
        return temp;
    }
}
