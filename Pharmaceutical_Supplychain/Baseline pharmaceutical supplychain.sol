// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract PharmaceuticalSupplyChain {

    struct Company {
        address companyAddress;
        string name;
        bool approved;
        uint256 createdAt; // extra storage variable (unnecessary but common)
    }

    struct Medicine {
        uint256 medicineId;
        string name;
        address manufacturer;
        bool approved;
        address distributor;
        address owner;
        uint256 createdAt; // extra storage write
        uint256 updatedAt; // extra storage write
    }

    // Arrays instead of mappings (O(n) lookup)
    Company[] public companies;
    Medicine[] public medicines;

    // Additional redundant storage arrays (common inefficient pattern)
    uint256[] public medicineIds;
    address[] public companyAddresses;

    uint256 public medicineCounter;

    // Register Company
    function registerCompany(string memory _name) public {

        // redundant temporary variables
        address sender = msg.sender;
        string memory tempName = _name;

        Company memory newCompany = Company(
            sender,
            tempName,
            false,
            block.timestamp
        );

        companies.push(newCompany);

        // redundant tracking storage
        companyAddresses.push(sender);
    }

    // Add Medicine
    function addMedicine(string memory _name) public {

        // redundant counter increment and storage writes
        medicineCounter = medicineCounter + 1;

        uint256 newId = medicineCounter;
        address sender = msg.sender;

        Medicine memory newMedicine = Medicine(
            newId,
            _name,
            sender,
            false,
            address(0),
            sender,
            block.timestamp,
            block.timestamp
        );

        medicines.push(newMedicine);

        // redundant storage write
        medicineIds.push(newId);
    }

    // Medicine Approval
    function approveMedicine(uint256 _id) public {

        // inefficient loop with repeated storage access
        for (uint256 i = 0; i < medicines.length; i++) {

            Medicine storage med = medicines[i];

            if (med.medicineId == _id) {

                // redundant writes
                med.approved = true;
                med.updatedAt = block.timestamp;

                // unnecessary redundant assignment
                medicines[i] = med;
            }
        }
    }

    // Distributor Approval
    function approveDistributor(uint256 _id, address _dist) public {

        address distributorAddress = _dist;

        for (uint256 i = 0; i < medicines.length; i++) {

            if (medicines[i].medicineId == _id) {

                Medicine storage med = medicines[i];

                med.distributor = distributorAddress;

                // redundant write
                med.updatedAt = block.timestamp;

                medicines[i] = med;
            }
        }
    }

    // Dispatch Medicine
    function dispatchMedicine(uint256 _id) public {

        for (uint256 i = 0; i < medicines.length; i++) {

            Medicine storage med = medicines[i];

            if (med.medicineId == _id) {

                address distributorAddress = med.distributor;

                // redundant condition
                if (distributorAddress != address(0)) {

                    med.owner = distributorAddress;
                    med.updatedAt = block.timestamp;

                    medicines[i] = med;
                }
            }
        }
    }

    // Remove Distributor
    function removeDistributor(uint256 _id) public {

        for (uint256 i = 0; i < medicines.length; i++) {

            Medicine storage med = medicines[i];

            if (med.medicineId == _id) {

                med.distributor = address(0);

                // redundant write
                med.updatedAt = block.timestamp;

                medicines[i] = med;
            }
        }
    }

    // Transfer Ownership
    function transferOwnership(uint256 _id, address _newOwner) public {

        address newOwnerAddress = _newOwner;

        for (uint256 i = 0; i < medicines.length; i++) {

            Medicine storage med = medicines[i];

            if (med.medicineId == _id) {

                med.owner = newOwnerAddress;

                // redundant write
                med.updatedAt = block.timestamp;

                medicines[i] = med;
            }
        }
    }
}
