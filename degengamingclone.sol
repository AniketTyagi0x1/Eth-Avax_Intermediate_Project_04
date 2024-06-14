// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract DegenGamingClone {

    address public owner;
    string public name;
    string public symbol;
    uint8 public decimals = 10;
    uint256 public totalSupply = 0;

    mapping(uint256 => string) public itemName;
    mapping(uint256 => uint256) public itemPrice;
    mapping(address => uint256) public balance;
    mapping(address => mapping(uint256 => bool)) public redeemedItems;
    mapping(address => uint256) public redeemedItemCount;

    constructor() {
        owner = msg.sender;
        name = "CU Gaming";
        symbol = "CUG";
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "This function can only be used by the owner.");
        _;
    }

    event Mint(address indexed to, uint256 value);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Burn(address indexed from, uint256 value);
    event Redeem(address indexed user, string itemName);

    function initializeStoreItems() external onlyOwner {
        _addItemToStore(0, "CU Summer Internship Bag", 500);
        _addItemToStore(1, "CU Summer Internship Stickers", 1005);
        _addItemToStore(2, "CU Summer Internship Swags", 20000);
        _addItemToStore(3, "CU summer special", 100000);
    }

    function _addItemToStore(uint256 itemId, string memory _itemName, uint256 _itemPrice) internal {
        itemName[itemId] = _itemName;
        itemPrice[itemId] = _itemPrice;
    }

    function mint(address to, uint256 amount) external onlyOwner {
        totalSupply += amount;
        balance[to] += amount;
        emit Mint(to, amount);
        emit Transfer(address(0), to, amount);
    }

    function balanceOf(address accountAddress) external view returns (uint256) {
        return balance[accountAddress];
    }

    function transfer(address receiver, uint256 amount) external returns (bool) {
        require(balance[msg.sender] >= amount, "Low balance.");
        balance[msg.sender] -= amount;
        balance[receiver] += amount;
        emit Transfer(msg.sender, receiver, amount);
        return true;
    }


    function burn(uint256 amount) external {
        require(amount <= balance[msg.sender], "Low balance.");
        balance[msg.sender] -= amount;
        totalSupply -= amount;
        emit Burn(msg.sender, amount);
        emit Transfer(msg.sender, address(0), amount);
    }

    function redeemItem(uint256 itemId) external returns (string memory) {
        require(itemPrice[itemId] > 0, "Wrong item ID.");
        uint256 redemptionAmount = itemPrice[itemId];
        require(balance[msg.sender] >= redemptionAmount, "Low balance to redeem the item.");

        balance[msg.sender] -= redemptionAmount;
        redeemedItems[msg.sender][itemId] = true;
        redeemedItemCount[msg.sender]++;
        emit Redeem(msg.sender, itemName[itemId]);

        return itemName[itemId];
    }

    function getRedeemedItemCount(address user) external view returns (uint256) {
        return redeemedItemCount[user];
    }

    function getContractDescription() external pure returns (string memory) {
        return "This Contract is a clone of degen gaming ERC20 Contract deployed on a avalanche testnet.";
    }
}

