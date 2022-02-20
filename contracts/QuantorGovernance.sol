// SPDX-License-Identifier: MIT
pragma solidity 0.8.12;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

import "./interfaces/IQuantorGovernance.sol";

contract QuantorGovernance is Ownable, IQuantorGovernance {
    using EnumerableSet for EnumerableSet.AddressSet;

    uint256 public mintOptionFeePermille;
    uint256 public burnOptionCallFeePermille;
    uint256 public burnOptionExpiredFeePermille;

    EnumerableSet.AddressSet internal _whitelistedAssets;

    constructor () Ownable() {}

    function whitelistedAssets() external view returns (address[] memory) {
        return _whitelistedAssets.values();
    }

    function isWhitelistedAsset(address _asset) external view returns (bool) {
        return _whitelistedAssets.contains(_asset);
    }

    function addWhitelistedAsset(address _asset) external onlyOwner {
        require(_whitelistedAssets.add(_asset));
    }

    function removeWhitelistedAsset(address _asset) external onlyOwner {
        require(_whitelistedAssets.remove(_asset));
    }

    function setMintOptionFeePermille(uint256 p) external onlyOwner {
        mintOptionFeePermille = p;
    }

    function setBurnOptionCallFeePermille(uint256 p) external onlyOwner {
        burnOptionCallFeePermille = p;
    }

    function setBurnOptionExpiredFeePermille(uint256 p) external onlyOwner {
        burnOptionExpiredFeePermille = p;
    }
}
