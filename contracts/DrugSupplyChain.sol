// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DrugSupplyChain {
    struct Drug {
        uint256 id;
        string name;
        string manufacturer;
        string status;
        address currentOwner;
    }

    uint256 public drugCount;
    mapping(uint256 => Drug) public drugs;

    event DrugRegistered(uint256 id, string name, string manufacturer, address owner);
    event StatusUpdated(uint256 id, string status);
    event OwnershipTransferred(uint256 id, address from, address to);

    function registerDrug(string memory _name, string memory _manufacturer) public {
        drugCount++;
        drugs[drugCount] = Drug(drugCount, _name, _manufacturer, "Registered", msg.sender);
        emit DrugRegistered(drugCount, _name, _manufacturer, msg.sender);
    }

    function updateStatus(uint256 _id, string memory _status) public {
        require(_id > 0 && _id <= drugCount, "Drug does not exist");
        Drug storage drug = drugs[_id];
        require(msg.sender == drug.currentOwner, "Only the current owner can update the status");
        drug.status = _status;
        emit StatusUpdated(_id, _status);
    }

    // Function to transfer ownership of a drug
    function transferOwnership(uint256 _id, address _newOwner) public {
        require(_id > 0 && _id <= drugCount, "Drug does not exist");
        Drug storage drug = drugs[_id];
        require(msg.sender == drug.currentOwner, "Only the current owner can transfer ownership");
        drug.currentOwner = _newOwner;
        emit OwnershipTransferred(_id, msg.sender, _newOwner);
    }
}