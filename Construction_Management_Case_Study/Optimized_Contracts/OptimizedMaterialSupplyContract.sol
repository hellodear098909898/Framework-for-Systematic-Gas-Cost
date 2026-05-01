// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MaterialSupply {

    // Struct packing optimization
    struct Supplier {
        address supplierAddress;
        bool isRegistered;
        string name;
    }

    struct Material {
        address supplier;
        uint128 quantity;
        uint64 materialId;
        bool delivered;
        string name;
    }

    // Mapping replaces arrays for O(1) lookup
    mapping(address => Supplier) private suppliers;
    mapping(uint256 => Material) private materials;

    uint256 public materialCounter;

    // Events for cheaper logging vs storage tracking
    event SupplierRegistered(address indexed supplier);
    event MaterialAdded(uint256 indexed materialId, address indexed supplier, uint256 quantity);
    event MaterialDelivered(uint256 indexed materialId);

    // --------------------------------------------------
    // Register Supplier (same function name)
    // --------------------------------------------------
    function registerSupplier(string calldata _name) external {

        suppliers[msg.sender] = Supplier({
            supplierAddress: msg.sender,
            isRegistered: true,
            name: _name
        });

        emit SupplierRegistered(msg.sender);
    }

    // --------------------------------------------------
    // Add Material (same function name)
    // --------------------------------------------------
    function addMaterial(string calldata _name, uint256 _quantity) external {

        materialCounter++;

        materials[materialCounter] = Material({
            supplier: msg.sender,
            quantity: uint128(_quantity),
            materialId: uint64(materialCounter),
            delivered: false,
            name: _name
        });

        emit MaterialAdded(materialCounter, msg.sender, _quantity);
    }

    // --------------------------------------------------
    // Deliver Material (same function name)
    // --------------------------------------------------
    function deliverMaterial(uint256 _materialId) external {

        Material storage m = materials[_materialId];

        require(m.materialId != 0, "Material not found");

        m.delivered = true;

        emit MaterialDelivered(_materialId);
    }

    // --------------------------------------------------
    // Find Material (same function name)
    // --------------------------------------------------
    function findMaterial(uint256 _materialId)
        external
        view
        returns (Material memory)
    {
        Material memory m = materials[_materialId];

        require(m.materialId != 0, "Material not found");

        return m;
    }
}
