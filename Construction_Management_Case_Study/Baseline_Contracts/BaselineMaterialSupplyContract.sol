// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MaterialSupply {

    struct Supplier {
        address supplierAddress;
        string name;
        bool isRegistered;
    }

    struct Material {
        uint256 materialId;
        string name;
        uint256 quantity;
        address supplier;
        bool delivered;
    }

    Supplier[] public suppliers;
    Material[] public materials;

    uint256 public materialCounter;

    // Register Supplier
    function registerSupplier(string memory _name) public {
        suppliers.push(Supplier(msg.sender, _name, true));
    }

    // Add Material
    function addMaterial(string memory _name, uint256 _quantity) public {
        materialCounter++;
        materials.push(Material(materialCounter, _name, _quantity, msg.sender, false));
    }

    // Deliver Material
    function deliverMaterial(uint256 _materialId) public {
        for (uint i = 0; i < materials.length; i++) {
            if (materials[i].materialId == _materialId) {
                materials[i].delivered = true;
            }
        }
    }

    // Find Material
    function findMaterial(uint256 _materialId) public view returns (Material memory) {
        for (uint i = 0; i < materials.length; i++) {
            if (materials[i].materialId == _materialId) {
                return materials[i];
            }
        }
        revert("Material not found");
    }
}
