// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ProjectManager {

    struct Contractor {
        address contractorAddress;
        bool isRegistered;
    }

    struct Project {
        address assignedContractor;
        uint64 projectId;
        bool exists;
        string projectName;
        string status;
    }

    // 🔹 Mapping instead of arrays (O(1) access)
    mapping(address => Contractor) private contractors;
    mapping(uint256 => Project) private projects;

    uint256 public projectCounter;

    // 🔹 Events instead of redundant storage tracking
    event ContractorRegistered(address indexed contractor);
    event ProjectCreated(uint256 indexed projectId);
    event ContractorAssigned(uint256 indexed projectId, address contractor);
    event ProjectStatusUpdated(uint256 indexed projectId, string status);

    // --------------------------------------------------
    // Register Contractor
    // --------------------------------------------------
    function registerContractor(string calldata _name) external {
        contractors[msg.sender] = Contractor({
            contractorAddress: msg.sender,
            isRegistered: true
        });

        emit ContractorRegistered(msg.sender);
    }

    // --------------------------------------------------
    // Check if Contractor Registered
    // --------------------------------------------------
    function isContractorRegistered(address _addr)
        external
        view
        returns (bool)
    {
        return contractors[_addr].isRegistered;
    }

    // --------------------------------------------------
    // Create Project
    // --------------------------------------------------
    function createProject(string calldata _name) external {
        projectCounter++;

        projects[projectCounter] = Project({
            assignedContractor: address(0),
            projectId: uint64(projectCounter),
            exists: true,
            projectName: _name,
            status: "Created"
        });

        emit ProjectCreated(projectCounter);
    }

    // --------------------------------------------------
    // Assign Contractor
    // --------------------------------------------------
    function assignContractor(uint256 _projectId, address _contractor) external {
        require(contractors[_contractor].isRegistered, "Not registered");

        Project storage p = projects[_projectId];
        require(p.exists, "Project not found");

        p.assignedContractor = _contractor;

        emit ContractorAssigned(_projectId, _contractor);
    }

    // --------------------------------------------------
    // Update Project Status
    // --------------------------------------------------
    function updateProjectStatus(uint256 _projectId, string calldata _status) external {
        Project storage p = projects[_projectId];
        require(p.exists, "Project not found");

        p.status = _status;

        emit ProjectStatusUpdated(_projectId, _status);
    }

    // --------------------------------------------------
    // Find Project
    // --------------------------------------------------
    function findProject(uint256 _projectId)
        external
        view
        returns (Project memory)
    {
        require(projects[_projectId].exists, "Not found");
        return projects[_projectId];
    }
}
