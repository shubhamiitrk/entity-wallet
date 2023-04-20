// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

interface IMasterWallet {
    function executeTransaction(
        address payable target,
        uint256 value,
        bytes calldata data,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;
}

contract ChildWallet {
    address public owner;
    IMasterWallet public masterWallet;

    constructor(address masterWalletAddress) {
        owner = msg.sender;
        masterWallet = IMasterWallet(masterWalletAddress);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    function updateOwner(address newOwner) external onlyOwner {
        owner = newOwner;
    }

    function submitTransaction(
        address payable target,
        uint256 value,
        bytes calldata data,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external onlyOwner {
        masterWallet.executeTransaction(target, value, data, v, r, s);
    }
}
