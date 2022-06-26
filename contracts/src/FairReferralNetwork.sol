// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import { IWorldID } from 'world-id-contracts/interfaces/IWorldID.sol';
import { ByteHasher } from 'world-id-contracts/libraries/ByteHasher.sol';

contract FairReferralNetwork {
    using ByteHasher for bytes;

    /// @notice Thrown when attempting to reuse a nullifier
    error InvalidNullifier();
    
    /// @notice Emitted when an referral is successfully claimed
    /// @param claimer The address that claimed the referral
    event ReferralClaimed(address claimer);

    /// @dev The WorldID instance that will be used for managing groups and verifying proofs
    IWorldID internal immutable worldId;

    /// @dev The World ID group whose participants can claim this airdrop
    uint256 internal immutable groupId;

    /// @dev Whether a nullifier hash has been used already. Used to prevent double-signaling
    mapping(uint256 => bool) internal nullifierHashes;

    /// @dev Denominator for fees
    uint256 public constant FEE_DENOM = 10000;

    /// @dev Array of referral fees for each level up
    uint256[] public referralFees;

    /// @notice Deploys a FairReferralNetwork instance
    /// @param _worldId The WorldID instance that will manage groups and verify proofs
    /// @param _groupId The ID of the Semaphore group World ID is using (`1`)
    constructor(
        IWorldID _worldId,
        uint256 _groupId,
        uint256[] memory _referralFees
    ) {
        worldId = _worldId;
        groupId = _groupId;
        for (uint i; i < _referralFees.length; i++) referralFees.push(_referralFees[i]);
    }

    mapping (address => address) referrerOf;

    function unsignedReferral(address claimer) public pure returns (bytes32) {
        return keccak256(abi.encodePacked("Referral", claimer));
    }

    function checkReferral(uint8 v, bytes32 r, bytes32 s, address claimer) public pure returns (address referrer) {
        bytes32 toCheck = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", unsignedReferral(claimer)));
        referrer = ecrecover(toCheck, v, r, s); // Could be 0-address
    }

    /// @notice Claim the referral
    /// @param v Signature part
    /// @param r Signature part
    /// @param s Signature part
    /// @param root The of the Merkle tree
    /// @param nullifierHash The nullifier for this proof, preventing double signaling
    /// @param proof The zero knowledge proof that demostrates the claimer has been onboarded to World ID
    function claimReferral(
        uint8 v, bytes32 r, bytes32 s,
        uint256 root,
        uint256 nullifierHash,
        uint256[8] calldata proof
    ) public {
        address referrer = checkReferral(v, r, s, msg.sender);

        if (nullifierHashes[nullifierHash]) revert InvalidNullifier();
        worldId.verifyProof(
            root,
            groupId,
            abi.encodePacked(msg.sender).hashToField(),
            nullifierHash,
            abi.encodePacked(address(this)).hashToField(),
            proof
        );

        nullifierHashes[nullifierHash] = true;
        referrerOf[msg.sender] = referrer;
    }

    /// @dev propagate the payout to referrers
    function payUs(address payable recipient) external payable {
        require(address(0) != referrerOf[msg.sender], "ERROR: Must have a referrer"); // To avoid circumventing everyone

        // Reentrancy protected by payable function having to receive more than paying out

        // pay referrers first
        address payable nextReferrer = recipient;
        for (uint i; i < referralFees.length; i++) {
            nextReferrer = payable(referrerOf[nextReferrer]);
            if (address(0) == nextReferrer) break; // no more referrers
            nextReferrer.transfer(msg.value * referralFees[i] / FEE_DENOM);
        }
        // by now all referrers are paid
        recipient.transfer(payable(address(this)).balance);
    }
}
