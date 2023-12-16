//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {PriceConverter} from "./PriceConverter.sol";

error NotOwner();

contract FundMe {
    using PriceConverter for uint256;

    uint256 public constant MINIMUM_USD = 50*1e18;

    address[] public funders;

    mapping(address funder => uint256 amountFunded) public addressToAmountFunded;

    address public immutable i_owner;

    

    constructor() {
        i_owner = msg.sender;
    }

    function fund() public payable {
        require(msg.value.getConversionRate() > MINIMUM_USD, "Didn't send enough ETH");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }




    function withdraw() public onlyOwner{
        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0);

        // //transfer 
        // //If transfer fails then throws error
        // payable(msg.sender).transfer(address(this).balance);

        // //send
        // //If send fails and return boolean flag
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send Failed");

        //call
        //Lower Level Command, call and call other functions from contract
        //Here we do not wanna call any other function thats why leave empty string.
        //call function is used as a transaction, thats why there is value in {}
        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call Failed");
    }

    modifier onlyOwner {
        // require(msg.sender == i_owner, "Send is not owner");
        if(msg.sender != i_owner) { revert NotOwner(); }
        _;
    }

    //What happens if someone 

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
     }
    
}
