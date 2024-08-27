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
        require(bytes(section).length > 0, "Section cannot be empty");

        slotCount++;
        slots[slotCount] = Slot(slotCount, section, false);

        emit SlotAdded(slotCount, section);
    }

    function reserveSlot(uint slotId) public {
        Slot storage slot = slots[slotId];

        // Ensure the slot exists
        require(slot.slotId != 0, "Slot does not exist");

        // Ensure the slot is not already reserved
        require(!slot.isOccupied, "Slot is already reserved");

        // Ensure the employee has not reserved this slot
        require(!reservedSlots[msg.sender][slotId], "Slot already reserved by you");

        // Mark the slot as occupied and record the reservation
        slot.isOccupied = true;
        reservedSlots[msg.sender][slotId] = true;

        emit SlotReserved(msg.sender, slotId);
    }

    function freeSlot(uint slotId) public {
        Slot storage slot = slots[slotId];

        // Ensure the slot exists
        require(slot.slotId != 0, "Slot does not exist");

        // Ensure the employee has reserved this slot
        require(reservedSlots[msg.sender][slotId], "Slot was not reserved by you");

        // Mark the slot as free and remove the reservation
        slot.isOccupied = false;
        reservedSlots[msg.sender][slotId] = false;

        emit SlotFreed(msg.sender, slotId);
    }

    function attemptReserveSlot(uint slotId) public {
        Slot storage slot = slots[slotId];

        // Check if the slot exists
        if (slot.slotId == 0) {
            revert("Slot does not exist");
        }

        // Check if the slot is already reserved
        if (slot.isOccupied) {
            revert("Slot is already reserved");
        }

        // Check if the employee has already reserved this slot
        if (reservedSlots[msg.sender][slotId]) {
            revert("Slot already reserved by you");
        }

        // Mark the slot as occupied and record the reservation
        slot.isOccupied = true;
        reservedSlots[msg.sender][slotId] = true;

        emit SlotReserved(msg.sender, slotId);
    }

    function checkSlotAvailability(uint slotId) public view returns (string memory section, bool isOccupied) {
        Slot storage slot = slots[slotId];

        // Ensure the slot exists
        require(slot.slotId != 0, "Slot does not exist");

        // Return the slot details
        return (slot.section, slot.isOccupied);
    }

    // Internal function to ensure slot state consistency
    function internalSlotCheck(uint slotId) internal view {
        Slot storage slot = slots[slotId];
        assert(slot.slotId > 0);  // Assert the slot ID should always be positive
        assert(slot.isOccupied == false || slot.isOccupied == true);  // Assert that isOccupied is either true or false
    }
}
