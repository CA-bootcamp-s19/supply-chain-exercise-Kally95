pragma solidity ^0.5.0;

import "truffle/Assert.sol";
/* Your assertion functions like Assert.equal() are provided to you by the truffle/Assert.sol library. */

import "truffle/DeployedAddresses.sol";

/* The addresses of your deployed contracts
(i.e., contracts that were deployed as part of your migrations)
 are available through the truffle/DeployedAddresses.sol library */

import "../contracts/SupplyChain.sol";
import "../contracts/Proxy.sol";
// All test contracts must start with Test (uppercase T)
// This distinguishes this contract apart from test helpers
// and project contracts.

contract TestSupplyChain {
 // Test for failing conditions in this contracts:
    // https://truffleframework.com/tutorials/testing-for-throws-in-solidity-tests

    uint public initialBalance = 1 ether;

    enum State {
        ForSale,
        Sold,
        Shipped,
        Received
    }

    SupplyChain public chain;
    Proxy public proxyseller;
    Proxy public proxybuyer;
    Proxy public proxyrandom;

    string itemName = "testItem";
    uint256 itemPrice = 3;
    uint256 itemSku = 0;

    // allow contract to receive ether
    function () external payable {}

    function beforeEach() public {
        chain = new SupplyChain();
        proxyseller = new Proxy(chain);
        proxybuyer = new Proxy(chain);
        proxyrandom = new Proxy(chain);
        uint256 seedValue = itemPrice + 1;
        address(proxyseller).transfer(seedValue);
        address(proxybuyer).transfer(seedValue);
    }

    function testForFailureIfUserDoesNotSendEnoughFunds() public {
        // Add an item
        bool itemAddedResult = proxyseller.placeItemForSale(itemName, itemPrice);
        Assert.isTrue(itemAddedResult, "placeItemForSale should return true");

        // Try to buy but with less than amount. The sku is 0.
        uint badPrice = itemPrice - 1;
        bool purchaseItemResult = proxybuyer.purchaseItem(itemSku, badPrice);
        Assert.isFalse(purchaseItemResult, "Should not be capable of buying");
    }

    function testPurchasingAnItemThatIsNotForSale() public {
        // Add an item
        bool itemAddedResult = proxyseller.placeItemForSale(itemName, itemPrice);
        Assert.isTrue(itemAddedResult, "placeItemForSale should return true");

        // Buy the item
        uint correctPrice = itemPrice;
        bool purchaseItemResult = proxybuyer.purchaseItem(itemSku, correctPrice);
        Assert.isTrue(purchaseItemResult, "You failed to purchase the item");

        // Since this item was purchased it should no longer exist
        // So if we try to purchase it again, it should return false
        purchaseItemResult = proxybuyer.purchaseItem(itemSku, correctPrice);
        Assert.isFalse(purchaseItemResult, "You failed to purchase the item");

    }

    // shipItem

    function testForCallsThatAreNotMadeBySeller() public {
      bool itemShippedResult = proxyrandom.shipItem(itemSku);
      Assert.isFalse(itemShippedResult, "Only the seller is allowed to ship");
    }

    function testeForTryingToSellAnItemNotMarkedAsSold() public {
      bool itemAddedResult = proxyseller.placeItemForSale(itemName, itemPrice);
      Assert.isTrue(itemAddedResult, "placeItemForSale should return true");

      // Now since it is added, it has been sold let's try to ship it
      bool shipItemResult = proxyseller.shipItem(itemSku);
      Assert.isFalse(shipItemResult, "Should not be allowed to ship");
    }

    // receiveItem

    // test calling the function from an address that is not the buyer
    function testCallingRecieveItemFromAddressThatIsNotTheBuyer() public {
      // Add Item
      bool itemAddedResult = proxyseller.placeItemForSale(itemName, itemPrice);
      Assert.isTrue(itemAddedResult, "placeItemForSale should return true");
      // Buy Item
      uint correctPrice = itemPrice;
      bool purchaseItemResult = proxybuyer.purchaseItem(itemSku, correctPrice);
      Assert.isTrue(purchaseItemResult, "You failed to purchase the item");
      // Ship Item
      bool shipItem = proxyseller.shipItem(itemSku);
      Assert.isTrue(shipItem, "Failed to ship item");
      // Call Recieved from another address
      bool ItemRecievedResult = proxyrandom.receiveItem(itemSku);
      Assert.isFalse(ItemRecievedResult, "Only buyer should be allowed to call");
    }

    // test calling the function on an item not marked Shipped
    function testCallingRecieveItemOnAnItemMarkedNotShipped() public {
      // Add Item
      bool itemAddedResult = proxyseller.placeItemForSale(itemName, itemPrice);
      Assert.isTrue(itemAddedResult, "placeItemForSale should return true");
      // Buy Item
      uint correctPrice = itemPrice;
      bool purchaseItemResult = proxybuyer.purchaseItem(itemSku, correctPrice);
      Assert.isTrue(purchaseItemResult, "You failed to purchase the item");
      // Attempt to recieve item before it is shipped
      bool receiveItemResult = proxybuyer.receiveItem(itemSku);
      Assert.isFalse(receiveItemResult, "recieveItem should fail");
    }
}
