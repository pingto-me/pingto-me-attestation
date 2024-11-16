// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { IERC20 } from "@openzeppelin/contracts/interfaces/IERC20.sol";
import { ISPHook } from "@ethsign/sign-protocol-evm/src/interfaces/ISPHook.sol";
import { Attestation } from "@ethsign/sign-protocol-evm/src/models/Attestation.sol";
import { ISP } from "@ethsign/sign-protocol-evm/src/interfaces/ISP.sol";


// @dev This contract manages the whitelist. We are separating the whitelist logic from the hook to make things easier
// to read.
contract NFTHodlManager is Ownable {

    mapping(address hodl => bool enable) public pingtolist;
    mapping(uint64 => CertInfo) public pingCert;

    struct CertInfo {
     uint64 attestid;
     address hodl;
     bool isactive;
    }


    constructor() Ownable(_msgSender()) { }

    function setCert(uint64 attsid_,address hodl_, bool active_) external onlyOwner {
        CertInfo storage cert = pingCert[attsid_];
        cert.hodl= hodl_;
        cert.attestid = attsid_;
        cert.isactive = active_;
    }

    function setPingHodl(address hodl_, bool active_)external onlyOwner{
        pingtolist[hodl_] = active_;
    }

    function _checkCertificate(uint64 attsid_) internal view {
        // solhint-disable-next-line custom-errors
        
         CertInfo storage cert = pingCert[attsid_];
         if(address(cert.hodl)!=address(0))
         {
            require(cert.isactive, "Certificate is invalid");
            require(cert.isactive, "Certificate is invalid");
         }

    }

    function _checkPingtoEnable(address hodl) internal view {
        // solhint-disable-next-line custom-errors
        require(pingtolist[hodl] , "PingTo hasn't enable");
    }
}

// @dev This contract implements the actual schema hook.
contract HodlChallangeHook is ISPHook, NFTHodlManager {
    struct CertSchema {
     address hodladdr;
     address nftaddr;
     uint256 tokenid;
     string nfttype;
     uint256 chainid;
    }
    function didReceiveAttestation(
        address, // attester
        uint64, // schemaId
        uint64 attestationId,
        bytes calldata // extraData

    )
        external
        payable
      {
        Attestation memory attestation = ISP(_msgSender()).getAttestation(attestationId);
        require(!attestation.revoked, " Attestation is revoked");
        _checkCertificate(attestationId);
      }

     function didReceiveAttestation(
        address, // attester
        uint64, // schemaId
        uint64, // attestationId
        IERC20, // resolverFeeERC20Token
        uint256, // resolverFeeERC20Amount
        bytes calldata // extraData
    )
        external
        pure
    {
        revert ("Unsupport");
    }

    function didReceiveRevocation(
        address, // attester
        uint64, // schemaId
        uint64, // attestationId
        bytes calldata // extraData
    )
        external
        payable
    {
        revert ();
    }

    function didReceiveRevocation(
        address, // attester
        uint64, // schemaId
        uint64, // attestationId
        IERC20, // resolverFeeERC20Token
        uint256, // resolverFeeERC20Amount
        bytes calldata // extraData
    )
        external
        pure
    {
        revert ();
    }
}