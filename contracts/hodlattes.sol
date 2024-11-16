// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { ISP } from "@ethsign/sign-protocol-evm/src/interfaces/ISP.sol";
import { Attestation } from "@ethsign/sign-protocol-evm/src/models/Attestation.sol";
import { DataLocation } from "@ethsign/sign-protocol-evm/src/models/DataLocation.sol";
import {Schema} from "@ethsign/sign-protocol-evm/src/models/Schema.sol";

contract HodlAttester is Ownable {
    ISP public spInstance;
    uint64 public schemaId;
    
    constructor() Ownable(_msgSender()) { }

    function setSPInstance(address instance) external onlyOwner {
        spInstance = ISP(instance);
    }

    function setSchemaID(uint64 schemaId_) external onlyOwner {
        schemaId = schemaId_;
    }

    function attest(address recipient,address  hodladdr,address  nftaddr, uint256 tokenid,string memory  nfttype, uint256  chainid) external onlyOwner returns (uint64) 
    {
        bytes[] memory recipients = new bytes[](1);
        recipients[0] = abi.encode(recipient);
        Attestation memory a = Attestation({
            schemaId: schemaId,
            linkedAttestationId: 0,
            attestTimestamp: 0,
            revokeTimestamp: 0,
            attester: address(this),
            validUntil: 0,
            dataLocation: DataLocation.ONCHAIN,
            revoked: false,
            recipients: recipients,
            data: abi.encode(hodladdr,nftaddr,tokenid,nfttype,chainid)
        });
        return spInstance.attest(a, "", "", "");
    }
        
    function revoke(uint64 attestId) external onlyOwner
    {
        
             spInstance.revoke(attestId, "", "", "");
    }
    
    function getSchema(uint64 schemaId_) external view returns (string memory )
    {
        Schema memory schema = spInstance.getSchema(schemaId_);
        return schema.data;   
    }
    
    function getAttestation(uint64 attestationId) external view returns (Attestation memory)
    {
        Attestation memory attestation = spInstance.getAttestation(attestationId);
        return abi.decode(attestation.data,(Attestation));
    }


}