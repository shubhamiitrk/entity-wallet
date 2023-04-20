pragma solidity ^0.8.0;

// SPDX-License-Identifier: UNLICENSED


contract MasterWallet {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    function updateOwner(address newOwner) external onlyOwner {
        owner = newOwner;
    }

    function executeTransaction(
        address payable target,
        uint256 value,
        bytes calldata data,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external onlyOwner {
        bytes32 hash = keccak256(abi.encodePacked(target, value, data));
        address signer = ecrecover(hash, v, r, s);

        // Check if the signer is a valid child wallet (you'll need a function or mapping to register and validate child wallets)
        require(isValidChildWallet(signer), "Invalid signer");

        (bool success,) = target.call{value: value}(data);
        require(success, "Transaction execution failed");
    }

    function isValidChildWallet(address wallet) internal view returns (bool) {
        // Implement your logic here to validate if the given wallet is a registered child wallet.
        // This could involve checking against a list of registered child wallet addresses or querying child wallet contracts.
    }
}
