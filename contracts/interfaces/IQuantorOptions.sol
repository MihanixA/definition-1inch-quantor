// SPDX-License-Identifier: MIT
pragma solidity 0.8.12;

import "./IQuantorGovernance.sol";

interface IQuantorOptions {
    struct OptionConfig {
        uint256 salt;
        uint256 makerAmount;
        uint256 takerAmount;
        uint256 beginTimestamp;
        uint256 endTimestamp;
        address makerAssetAddress;
        address takerAssetAddress;
    }

    function quantorGovernance() external view returns (IQuantorGovernance);

    function nftIdToOptionConfigHash(uint256 nftId) external returns (bytes32);

    function mintOption(OptionConfig memory optionConfig, bytes calldata signature) returns (uint256) external;

    function burnOptionExpired(OptionConfig memory optionConfig, bytes calldata signature) external;

    function burnOptionCall(OptionConfig memory optionConfig, bytes calldata signature) external;

    function hashOptionConfig(OptionConfig memory optionConfig) external pure returns (bytes32);
}
