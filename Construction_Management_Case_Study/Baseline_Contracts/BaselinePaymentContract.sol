// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract PaymentModule {

    struct Escrow {
        uint256 escrowId;
        address payer;
        address payee;
        uint256 amount;
        bool released;
        bool refunded;
    }

    struct Milestone {
        uint256 milestoneId;
        uint256 escrowId;
        string description;
        bool completed;
    }

    Escrow[] public escrows;
    Milestone[] public milestones;

    uint256 public escrowCounter;
    uint256 public milestoneCounter;

    // Create Escrow
    function createEscrow(address _payee) public payable {
        escrowCounter++;
        escrows.push(Escrow(escrowCounter, msg.sender, _payee, msg.value, false, false));
    }

    // Create Milestone
    function createMilestone(uint256 _escrowId, string memory _desc) public {
        milestoneCounter++;
        milestones.push(Milestone(milestoneCounter, _escrowId, _desc, false));
    }

    // Release Payment
    function releasePayment(uint256 _escrowId) public {
        for (uint i = 0; i < escrows.length; i++) {
            if (escrows[i].escrowId == _escrowId) {
                payable(escrows[i].payee).transfer(escrows[i].amount);
                escrows[i].released = true;
            }
        }
    }

    // Refund Escrow
    function refundEscrow(uint256 _escrowId) public {
        for (uint i = 0; i < escrows.length; i++) {
            if (escrows[i].escrowId == _escrowId) {
                payable(escrows[i].payer).transfer(escrows[i].amount);
                escrows[i].refunded = true;
            }
        }
    }
}
