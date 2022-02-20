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

    function mintOption(OptionConfig memory optionConfig) external returns (uint256);

    function burnOptionExpired(OptionConfig memory optionConfig) external;

    function burnOptionCall(OptionConfig memory optionConfig) external;
}
