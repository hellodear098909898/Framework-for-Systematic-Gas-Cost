# Framework for Systematic Gas Cost Optimization of Ethereum Smart Contracts

This repository contains the official implementation of a systematic gas optimization framework for Ethereum smart contracts. 

The effectiveness of this approach is validated through two domain-specific case studies: **Pharmaceutical Supply Chain** and **Construction Management**.

---

##  1. System Framework Architecture
Following the methodology proposed in the research, the system is organized into three distinct layers:
*   **User Profile Layer (U):** Role-based access control for stakeholders (Admins, Regulatory Authorities, Contractors).
*   **Interface & Wallet Layer (I):** Seamless interaction via **MetaMask** and **Remix IDE**.
*   **Ethereum Blockchain Layer (E):** A distributed private network of **11 nodes** running the optimized smart contracts.

---

##  2. Environment Setup (11-Node Private PoA)
To ensure reliable, non-volatile gas measurements, the experiments are conducted on a private Ethereum network using the **Proof of Authority (PoA)** consensus mechanism (Clique).

### A. Geth Cluster Configuration
The "Blockchain Layer" is simulated using a distributed cluster of **11 nodes** to ensure state consistency across a P2P mesh.
1.  **Initialize Nodes:** Each node is initialized with a shared `genesis.json`.
    ```bash
    geth --datadir node1 init genesis.json
    # Repeat for all 11 nodes (node1 through node11)
    ```
2.  **Launch Cluster:** Nodes are connected via a bootnode. At least one node acts as the RPC gateway:
    ```bash
    geth --datadir node1 --networkid 1234 --port 30303 --http --http.addr "127.0.0.1" --http.port 8545 --http.corsdomain "*" --http.api "eth,net,web3,personal,miner" --allow-insecure-unlock
    ```

### B. MetaMask Integration
To facilitate the "Interface & Wallet Layer (I)":
1.  Add a **Custom RPC Network** in MetaMask.
2.  **RPC URL:** `http://127.0.0.1:8545`
3.  **Chain ID:** `1234` (or your specific network ID).
4.  Import the account created during the Geth node initialization.

---

## 3. Execution on Remix IDE
1.  **Environment Setup:** In the Remix **"Deploy & Run Transactions"** tab, set the Environment to **Injected Provider - MetaMask**. This links Remix directly to your 11-node private network.
2.  **Configurations:**
    *   **Baseline:** Standard implementation used as a control group.
    *   **Full Architectural Optimization:** Code implementing the refinements detailed in **Section 4** of the paper.
3.  **Validation:** Deploy the contracts and record the transaction/execution gas costs from the Remix console.


