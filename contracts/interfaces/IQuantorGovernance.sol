// SPDX-License-Identifier: MIT
pragma solidity 0.8.12;

interface IQuantorGovernance {
    function isWhitelistedAsset(address) external view returns (bool);

    function mintOptionFeePermille() external view returns (uint256);

    function burnOptionCallFeePermille() external view returns (uint256);

    function burnOptionExpiredFeePermille() external view returns (uint256);
}
