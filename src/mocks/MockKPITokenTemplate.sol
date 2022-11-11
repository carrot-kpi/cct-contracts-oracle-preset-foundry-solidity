pragma solidity 0.8.17;

import {IKPIToken} from "carrot/interfaces/kpi-tokens/IKPIToken.sol";
import {Template} from "carrot/interfaces/IBaseTemplatesManager.sol";
import {IOraclesManager1} from "carrot/interfaces/oracles-managers/IOraclesManager1.sol";
import {InitializeKPITokenParams} from "carrot/commons/Types.sol";

struct OracleData {
    uint256 templateId;
    uint256 value;
    bytes data;
}

/// SPDX-License-Identifier: GPL-3.0-or-later
/// @title Mock KPI token template implementation
/// @dev A mock KPI token template implementation
/// @author Federico Luzzi - <federico.luzzi@protonmail.com>
contract MockKPITokenTemplate is IKPIToken {
    event CreateOracle(address instance);

    function initialize(InitializeKPITokenParams memory _params)
        external
        payable
        override
    {
        (uint256 _templateId, uint256 _value, bytes memory _data) = abi.decode(
            _params.oraclesData,
            (uint256, uint256, bytes)
        );
        address _instance = IOraclesManager1(_params.oraclesManager)
            .instantiate{value: _value}(_params.creator, _templateId, _data);
        emit CreateOracle(_instance);
    }

    function finalize(uint256 _result) external override {}

    function redeem(bytes memory _data) external override {}

    function owner() external view override returns (address) {
        return address(0);
    }

    function transferOwnership(address _newOwner) external override {}

    function template() external view override returns (Template memory) {
        return
            Template({
                id: 1,
                addrezz: address(0),
                version: 1,
                specification: "foo"
            });
    }

    function description() external view override returns (string memory) {
        return "foo";
    }

    function finalized() external view override returns (bool) {
        return true;
    }

    function expiration() external view override returns (uint256) {
        return block.timestamp;
    }

    function data() external view override returns (bytes memory) {
        return abi.encode();
    }

    function oracles() external view override returns (address[] memory) {
        return new address[](0);
    }
}
