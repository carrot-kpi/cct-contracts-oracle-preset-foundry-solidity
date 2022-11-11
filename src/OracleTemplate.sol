pragma solidity 0.8.17;

import {IOracleTemplate} from "./interfaces/IOracleTemplate.sol";
import {IOraclesManager1} from "carrot/interfaces/oracles-managers/IOraclesManager1.sol";
import {Template} from "carrot/interfaces/IBaseTemplatesManager.sol";
import {InitializeOracleParams} from "carrot/commons/Types.sol";

/// SPDX-License-Identifier: GPL-3.0-or-later
/// @title Oracle template implementation
/// @dev An oracle template implementation
/// @author Federico Luzzi - <federico.luzzi@protonmail.com>
contract OracleTemplate is IOracleTemplate {
    address internal oraclesManager;
    uint256 internal templateId;
    uint128 internal templateVersion;

    function initialize(InitializeOracleParams memory _params)
        external
        payable
        override
    {
        oraclesManager = msg.sender;
        templateId = _params.templateId;
        templateVersion = _params.templateVersion;
    }

    function kpiToken() external view override returns (address) {
        return address(0);
    }

    function template() external view override returns (Template memory) {
        return
            IOraclesManager1(oraclesManager).template(
                templateId,
                templateVersion
            );
    }

    function finalized() external view override returns (bool) {
        return true;
    }

    function data() external view override returns (bytes memory) {
        return abi.encode();
    }
}
