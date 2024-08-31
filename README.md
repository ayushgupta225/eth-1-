# Warehouse Slot Management System

A simple Solidity contract to manage warehouse slots. Employees can add, reserve, and free slots within the warehouse.

## Features

- **Add Slot**: Add a new slot to a specified section.
- **Reserve Slot**: Reserve an available slot.
- **Free Slot**: Release a reserved slot.
- **Check Availability**: View slot details and availability.

## Smart Contract

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract WarehouseSlotManagementSystem {
    struct Slot {
        uint slotId;
        string section;
        bool isOccupied;
    }
    mapping(uint => Slot) public slots;
    mapping(address => mapping(uint => bool)) public reservedSlots;
    uint public slotCount;

    event SlotAdded(uint slotId, string section);
    event SlotReserved(address employee, uint slotId);
    event SlotFreed(address employee, uint slotId);

    function addSlot(string memory section) public {
        slotCount++;
        slots[slotCount] = Slot(slotCount, section, false);
        emit SlotAdded(slotCount, section);
    }

    function reserveSlot(uint slotId) public {
        require(slots[slotId].slotId != 0, "Slot does not exist");
        require(!slots[slotId].isOccupied, "Slot already reserved");

        slots[slotId].isOccupied = true;
        reservedSlots[msg.sender][slotId] = true;

        emit SlotReserved(msg.sender, slotId);
    }

    function freeSlot(uint slotId) public {
        require(slots[slotId].slotId != 0, "Slot does not exist");
        require(reservedSlots[msg.sender][slotId], "Slot not reserved by you");

        slots[slotId].isOccupied = false;
        reservedSlots[msg.sender][slotId] = false;

        emit SlotFreed(msg.sender, slotId);
    }

    function checkSlotAvailability(uint slotId) public view returns (string memory section, bool isOccupied) {
        require(slots[slotId].slotId != 0, "Slot does not exist");
        return (slots[slotId].section, slots[slotId].isOccupied);
    }
}
```


## Author
ayush
