//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

contract FundMe {
    uint256 minimumUSD = 5;

    function fund() public payable {
        require(msg.value > minimumUSD, "Didn't send enough ETH");
    }

    function withdraw() public {}
}