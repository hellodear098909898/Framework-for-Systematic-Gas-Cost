// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract InspectionModule {

    // Struct packing optimization
    struct Inspection {
        uint64 inspectionId;
        bool approved;
        string report;
    }

    // Mapping replaces array for O(1) lookup
    mapping(uint256 => Inspection) private inspections;

    uint256 public inspectionCounter;

    // Events for efficient logging
    event InspectionSubmitted(uint256 indexed inspectionId);
    event InspectionUpdated(uint256 indexed inspectionId);

    // --------------------------------------------------
    // Submit Inspection (same function name)
    // --------------------------------------------------
    function submitInspection(string calldata _report) external {

        inspectionCounter++;

        inspections[inspectionCounter] = Inspection({
            inspectionId: uint64(inspectionCounter),
            approved: false,
            report: _report
        });

        emit InspectionSubmitted(inspectionCounter);
    }

    // --------------------------------------------------
    // Update Inspection (same function name)
    // --------------------------------------------------
    function updateInspection(uint256 _id, string calldata _report) external {

        Inspection storage ins = inspections[_id];

        require(ins.inspectionId != 0, "Not found");

        ins.report = _report;

        emit InspectionUpdated(_id);
    }

    // --------------------------------------------------
    // Get Inspection (same function name)
    // --------------------------------------------------
    function getInspection(uint256 _id)
        external
        view
        returns (Inspection memory)
    {
        Inspection memory ins = inspections[_id];

        require(ins.inspectionId != 0, "Not found");

        return ins;
    }

    // --------------------------------------------------
    // Is Approved (same function name)
    // --------------------------------------------------
    function isApproved(uint256 _id)
        external
        view
        returns (bool)
    {
        return inspections[_id].approved;
    }
}
