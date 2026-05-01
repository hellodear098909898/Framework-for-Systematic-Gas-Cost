// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract PaymentModule {

    // Struct packing optimization
    struct Escrow {
        address payer;
        address payee;
        uint128 amount;
        uint64 escrowId;
        bool released;
        bool refunded;
    }

    struct Milestone {
        uint64 milestoneId;
        uint64 escrowId;
        bool completed;
        string description;
    }

    // Mapping replaces arrays (O(1) lookup)
    mapping(uint256 => Escrow) private escrows;
    mapping(uint256 => Milestone) private milestones;

    // Pull payment optimization
    mapping(address => uint256) public pendingWithdrawals;

    uint256 public escrowCounter;
    uint256 public milestoneCounter;

    // Events reduce storage dependence
    event EscrowCreated(uint256 indexed escrowId, address indexed payer, address indexed payee, uint256 amount);
    event MilestoneCreated(uint256 indexed milestoneId, uint256 indexed escrowId);
    event PaymentReleased(uint256 indexed escrowId, address indexed payee, uint256 amount);
    event EscrowRefunded(uint256 indexed escrowId, address indexed payer, uint256 amount);

    // --------------------------------------------------
    // Create Escrow (same function name)
    // --------------------------------------------------
    function createEscrow(address _payee) external payable {

        escrowCounter++;

        escrows[escrowCounter] = Escrow({
            payer: msg.sender,
            payee: _payee,
            amount: uint128(msg.value),
            escrowId: uint64(escrowCounter),
            released: false,
            refunded: false
        });

        emit EscrowCreated(escrowCounter, msg.sender, _payee, msg.value);
    }

    // --------------------------------------------------
    // Create Milestone (same function name)
    // --------------------------------------------------
    function createMilestone(uint256 _escrowId, string calldata _desc) external {

        milestoneCounter++;

        milestones[milestoneCounter] = Milestone({
            milestoneId: uint64(milestoneCounter),
            escrowId: uint64(_escrowId),
            completed: false,
            description: _desc
        });

        emit MilestoneCreated(milestoneCounter, _escrowId);
    }

    // --------------------------------------------------
    // Release Payment (same function name)
    // --------------------------------------------------
    function releasePayment(uint256 _escrowId) external {

        Escrow storage e = escrows[_escrowId];

        require(e.escrowId != 0, "Escrow not found");
        require(!e.released, "Already released");

        e.released = true;

        // Pull payment pattern instead of direct transfer
        pendingWithdrawals[e.payee] += e.amount;

        emit PaymentReleased(_escrowId, e.payee, e.amount);
    }

    // --------------------------------------------------
    // Refund Escrow (same function name)
    // --------------------------------------------------
    function refundEscrow(uint256 _escrowId) external {

        Escrow storage e = escrows[_escrowId];

        require(e.escrowId != 0, "Escrow not found");
        require(!e.refunded, "Already refunded");

        e.refunded = true;

        // Pull payment pattern
        pendingWithdrawals[e.payer] += e.amount;

        emit EscrowRefunded(_escrowId, e.payer, e.amount);
    }

    // --------------------------------------------------
    // Withdraw function (required for pull pattern)
    // --------------------------------------------------
    function withdraw() external {

        uint256 amount = pendingWithdrawals[msg.sender];

        require(amount > 0, "No funds");

        pendingWithdrawals[msg.sender] = 0;

        payable(msg.sender).transfer(amount);
    }
}
