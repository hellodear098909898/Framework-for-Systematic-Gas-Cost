// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract InspectionModule {

    struct Inspection {
        uint256 inspectionId;
        string report;
        bool approved;
    }

    Inspection[] public inspections;
    uint256 public inspectionCounter;

    function submitInspection(string memory _report) public {
        inspectionCounter++;
        inspections.push(Inspection(inspectionCounter, _report, false));
    }

    function updateInspection(uint256 _id, string memory _report) public {
        for (uint i = 0; i < inspections.length; i++) {
            if (inspections[i].inspectionId == _id) {
                inspections[i].report = _report;
            }
        }
    }

    function getInspection(uint256 _id) public view returns (Inspection memory) {
        for (uint i = 0; i < inspections.length; i++) {
            if (inspections[i].inspectionId == _id) {
                return inspections[i];
            }
        }
        revert("Not found");
    }

    function isApproved(uint256 _id) public view returns (bool) {
        for (uint i = 0; i < inspections.length; i++) {
            if (inspections[i].inspectionId == _id) {
                return inspections[i].approved;
            }
        }
        return false;
    }
}
