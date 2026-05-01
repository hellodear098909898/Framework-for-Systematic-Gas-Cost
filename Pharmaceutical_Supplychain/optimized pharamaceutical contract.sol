// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract PharmaceuticalSupplyChain {

    // =====================================================
    // STRUCT PACKING OPTIMIZATION
    // =====================================================

    struct Company {

        address companyAddress;   // 20 bytes

        uint64 createdAt;         // packed storage

        bool approved;            // packed storage

        string name;              // dynamic data stored separately
    }

    struct Medicine {

        address manufacturer;
        address distributor;
        address owner;

        uint64 medicineId;
        uint64 createdAt;
        uint64 updatedAt;

        bool approved;

        string name;
    }

    // =====================================================
    // MAPPING STORAGE (O(1) ACCESS, NO LOOPS)
    // =====================================================

    mapping(address => Company) private companies;

    mapping(uint256 => Medicine) private medicines;

    uint256 public medicineCounter;

    // =====================================================
    // EVENT-BASED LOGGING (CHEAPER THAN STORAGE)
    // =====================================================

    event CompanyRegistered(
        address indexed company,
        string name
    );

    event MedicineAdded(
        uint256 indexed medicineId,
        address indexed manufacturer,
        string name
    );

    event MedicineApproved(uint256 indexed medicineId);

    event DistributorApproved(
        uint256 indexed medicineId,
        address indexed distributor
    );

    event MedicineDispatched(
        uint256 indexed medicineId,
        address indexed newOwner
    );

    event DistributorRemoved(uint256 indexed medicineId);

    event OwnershipTransferred(
        uint256 indexed medicineId,
        address indexed newOwner
    );

    // =====================================================
    // REGISTER COMPANY (external + calldata optimization)
    // =====================================================

    function registerCompany(string calldata _name)
        external
    {

        companies[msg.sender] = Company({

            companyAddress: msg.sender,

            createdAt: uint64(block.timestamp),

            approved: false,

            name: _name
        });

        emit CompanyRegistered(msg.sender, _name);
    }

    // =====================================================
    // ADD MEDICINE
    // =====================================================

    function addMedicine(string calldata _name)
        external
    {

        unchecked {
            medicineCounter++;
        }

        medicines[medicineCounter] = Medicine({

            manufacturer: msg.sender,

            distributor: address(0),

            owner: msg.sender,

            medicineId: uint64(medicineCounter),

            createdAt: uint64(block.timestamp),

            updatedAt: uint64(block.timestamp),

            approved: false,

            name: _name
        });

        emit MedicineAdded(
            medicineCounter,
            msg.sender,
            _name
        );
    }

    // =====================================================
    // APPROVE MEDICINE
    // =====================================================

    function approveMedicine(uint256 _id)
        external
    {

        Medicine storage med = medicines[_id];

        require(med.medicineId != 0, "Not found");

        med.approved = true;

        med.updatedAt = uint64(block.timestamp);

        emit MedicineApproved(_id);
    }

    // =====================================================
    // APPROVE DISTRIBUTOR
    // =====================================================

    function approveDistributor(
        uint256 _id,
        address _dist
    )
        external
    {

        Medicine storage med = medicines[_id];

        require(med.medicineId != 0, "Not found");

        med.distributor = _dist;

        med.updatedAt = uint64(block.timestamp);

        emit DistributorApproved(_id, _dist);
    }

    // =====================================================
    // DISPATCH MEDICINE
    // =====================================================

    function dispatchMedicine(uint256 _id)
        external
    {

        Medicine storage med = medicines[_id];

        require(med.medicineId != 0, "Not found");

        require(med.distributor != address(0), "No distributor");

        med.owner = med.distributor;

        med.updatedAt = uint64(block.timestamp);

        emit MedicineDispatched(_id, med.owner);
    }

    // =====================================================
    // REMOVE DISTRIBUTOR
    // =====================================================

    function removeDistributor(uint256 _id)
        external
    {

        Medicine storage med = medicines[_id];

        require(med.medicineId != 0, "Not found");

        med.distributor = address(0);

        med.updatedAt = uint64(block.timestamp);

        emit DistributorRemoved(_id);
    }

    // =====================================================
    // TRANSFER OWNERSHIP
    // =====================================================

    function transferOwnership(
        uint256 _id,
        address _newOwner
    )
        external
    {

        Medicine storage med = medicines[_id];

        require(med.medicineId != 0, "Not found");

        med.owner = _newOwner;

        med.updatedAt = uint64(block.timestamp);

        emit OwnershipTransferred(_id, _newOwner);
    }
}
