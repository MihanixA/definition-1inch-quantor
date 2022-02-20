// SPDX-License-Identifier: MIT
pragma solidity 0.8.12;

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

    function mintOption(OptionConfig memory optionConfig) external;

    function burnOption(OptionConfig memory optionConfig) external;
}
