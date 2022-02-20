// SPDX-License-Identifier: MIT
pragma solidity 0.8.12;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";
import "@openzeppelin/contracts/utils/introspection/IERC165.sol";

import "./interfaces/external/ILimitOrderProtocol.sol";

import "./interfaces/IQuantorOptions.sol";
import "./interfaces/IQuantorGovernance.sol";


contract QuantorOptions is IQuantorOptions, ERC721, ERC721Burnable {
    using SafeERC20 for ERC20;

    IQuantorGovernance public quantorGovernance;
    ILimitOrderProtocol public limitOrderProtocol;
    mapping(uint256 => bytes32) public optionConfigHashToNftId;
    mapping(uint256 => bytes32) public limitOrderHashToNftId;

    uint256 private _topNft = 1;

    constructor(address quantorGovernance_, address limitOrderProtocol_) ERC721("QOPTS", "Quantor Options Protocol") {
        quantorGovernance = IQuantorGovernance(quantorGovernance_);
        limitOrderProtocol = ILimitOrderProtocol(limitOrderProtocol_);
    }

    function mintOption(OptionConfig memory optionConfig) external {
        require(quantorGovernance.isWhitelistedAsset(optionConfig.makerAssetAddress));
        require(quantorGovernance.isWhitelistedAsset(optionConfig.takerAssetAddress));
        IERC20(optionConfig.makerAssetAddress).safeTransferFrom(msg.sender, address(this), optionConfig.makerAmount);
        ILimitOrderProtocol.Order memory order;
        order.salt = optionConfig.salt;
        order.makerAsset = optionConfig.makerAssetAddress;
        order.takerAsset = optionConfig.takerAssetAddress;
        order.maker = address(this);
        order.allowedSender = address(this);
        order.makingAmount = optionConfig.makerAmount;
        order.takingAmount = 0;
        order.predicate = "";
        order.permit = "";
        order.interaction = "";
        limitOrderProtocol.fillOrderTo(order, "", optionConfig.makerAmount, 0, optionConfig.takerAmount, address(this));
        _safeMint(msg.sender, _topNft);
        optionConfigHashToNftId[_topNft] = hashOptionConfig(optionConfig);
        limitOrderHashToNftId[_topNft] = limitOrderProtocol.hashOrder(order);
    }

    function burnOption(OptionConfig memory optionConfig) external {
        // TODO
    }

    function hashOptionConfig(OptionConfig memory optionConfig) public pure returns (bytes32) {
        return keccak256(abi.encode(optionConfig));
    }

    function supportsInterface(bytes4 interfaceId) public pure override (ERC721) returns(bool) {
        return (
            interfaceId == type(IERC165).interfaceId ||
            interfaceId == type(IERC721).interfaceId ||
            interfaceId == type(IQuantorOptions).interfaceId
        );
    }
}
