pragma solidity ^0.5.0;

import "truffle/Assert.sol";
/* Your assertion functions like Assert.equal() are provided to you by the truffle/Assert.sol library. */

import "truffle/DeployedAddresses.sol";

/* The addresses of your deployed contracts
(i.e., contracts that were deployed as part of your migrations)
 are available through the truffle/DeployedAddresses.sol library */

import "../contracts/SupplyChain.sol";

// All test contracts must start with Test (uppercase T)
// This distinguishes this contract apart from test helpers
// and project contracts.

contract TestSupplyChain {

    // address deployer = 0x41fafFaa11a9b57858ceeF3d371A55dde9ef764f;
    // address buyer = 0x0f155C947D0065fa6CafC7d11963E7bf6E8c7302;
    // address seller = 0xE7E86224567F43b0aDbB78a4B49CC54d694BEd3b;

    // function testSettingAnOwnerDuringCreation() public {
    //   SupplyChain supplyChain = SupplyChain(DeployedAddresses.SupplyChain());
    //   Assert.equal(supplyChain.owner(), deployer, "An owner is different than a deployer");
    // }

    // function testbuyItemInsufficientFunds() public {
    //   SupplyChain supplyChain = SupplyChain(DeployedAddresses.SupplyChain());
    //   //addItem(string memory _name, uint _price
    //   //function buyItem(uint _sku)
    //   supplyChain.addItem("Phone", 100);
    //   supplyChain.buyItem(100);
    // }

    // function testSomething() public {
    //   //supplyChain.buyItem(100);
    // }

    // Test for failing conditions in this contracts:
    // https://truffleframework.com/tutorials/testing-for-throws-in-solidity-tests



    // buyItem


    // test for failure if user does not send enough funds
    // test for purchasing an item that is not for Sale

    // shipItem

    // test for calls that are made by not the seller
    // test for trying to ship an item that is not marked Sold

    // receiveItem

    // test calling the function from an address that is not the buyer
    // test calling the function on an item not marked Shipped

}
