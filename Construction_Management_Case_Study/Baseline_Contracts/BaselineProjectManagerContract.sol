// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ProjectManager {

    struct Contractor {
        address contractorAddress;
        string name;
        bool isRegistered;
    }

    struct Project {
        uint256 projectId;
        string projectName;
        address assignedContractor;
        string status;
        bool exists;
    }

    Contractor[] public contractors;
    Project[] public projects;

    uint256 public projectCounter;

    // Register Contractor
    function registerContractor(string memory _name) public {
        contractors.push(Contractor(msg.sender, _name, true));
    }

    // Check if Contractor Registered (linear search)
    function isContractorRegistered(address _addr) public view returns (bool) {
        for (uint i = 0; i < contractors.length; i++) {
            if (contractors[i].contractorAddress == _addr) {
                return true;
            }
        }
        return false;
    }

    // Create Project
    function createProject(string memory _name) public {
        projectCounter++;
        projects.push(Project(projectCounter, _name, address(0), "Created", true));
    }

    // Assign Contractor (linear search)
    function assignContractor(uint256 _projectId, address _contractor) public {
        require(isContractorRegistered(_contractor), "Not registered");

        for (uint i = 0; i < projects.length; i++) {
            if (projects[i].projectId == _projectId) {
                projects[i].assignedContractor = _contractor;
            }
        }
    }

    // Update Project Status
    function updateProjectStatus(uint256 _projectId, string memory _status) public {
        for (uint i = 0; i < projects.length; i++) {
            if (projects[i].projectId == _projectId) {
                projects[i].status = _status;
            }
        }
    }

    // Find Project
    function findProject(uint256 _projectId) public view returns (Project memory) {
        for (uint i = 0; i < projects.length; i++) {
            if (projects[i].projectId == _projectId) {
                return projects[i];
            }
        }
        revert("Not found");
    }
}
