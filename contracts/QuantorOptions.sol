// SPDX-License-Identifier: MIT
pragma solidity 0.8.12;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";
import "@openzeppelin/contracts/utils/introspection/IERC165.sol";
import "@openzeppelin/contracts/utils/cryptography/SignatureChecker.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

import "./interfaces/external/ILimitOrderProtocol.sol";

import "./interfaces/IQuantorOptions.sol";
import "./interfaces/IQuantorGovernance.sol";


contract QuantorOptions is IQuantorOptions, ERC721, ERC721Burnable, ReentrancyGuard {
    using SafeERC20 for IERC20;

    IQuantorGovernance public quantorGovernance;
    ILimitOrderProtocol public limitOrderProtocol;

    mapping(uint256 => bytes32) public optionConfigHashToNftId;
    mapping(bytes32 => uint256) public nftIdToOptionConfigHash;
    mapping(uint256 => bytes32) public limitOrderHashToNftId;
    mapping(uint256 => address) public optionProviderToNftId;

    uint256 private _topNft = 1;

    constructor(address quantorGovernance_, address limitOrderProtocol_)
        ERC721("QOPTS", "Quantor Options Protocol") 
    {
        quantorGovernance = IQuantorGovernance(quantorGovernance_);
        limitOrderProtocol = ILimitOrderProtocol(limitOrderProtocol_);
    }

    function mintOption(OptionConfig memory optionConfig) external nonReentrant {
        _validateOptionConfig(optionConfig);


        IERC20(optionConfig.makerAssetAddress).safeTransferFrom(msg.sender, address(this), optionConfig.makerAmount);
        IERC20(optionConfig.makerAssetAddress).safeIncreaseAllowance(address(limitOrderProtocol), optionConfig.makerAmount);

        ILimitOrderProtocol.Order memory order = _constructOrderPart(optionConfig);

        _safeMint(msg.sender, _topNft);
        limitOrderProtocol.fillOrder(order, "", optionConfig.makerAmount, 0, optionConfig.takerAmount);

        bytes32 hashOptionConfig = _hashOptionConfig(optionConfig);
        nftIdToOptionConfigHash[hashOptionConfig] = _topNft;
        limitOrderHashToNftId[_topNft] = limitOrderProtocol.hashOrder(order);
        ++_topNft;
    }

    function burnOptionCall(OptionConfig memory optionConfig) external nonReentrant {
        require(block.timestamp > optionConfig.beginTimestamp);
        bytes32 hashOptionConfig = _hashOptionConfig(optionConfig);
        uint256 nftId = nftIdToOptionConfigHash[hashOptionConfig];
        require(msg.sender == ownerOf(nftId), "not option owner");
        IERC20(optionConfig.takerAssetAddress).safeTransferFrom(msg.sender, address(this), optionConfig.takerAmount);
        ILimitOrderProtcol.Order memory order = _constructOrderPart(optionConfig);
        limitOrderProtocol.fillOrderTo(order);
    }

    function burnOptionExpired(OptionConfig memory optionConfig) external nonReentrant {
        require(block.timestamp > optionConfig.endTimestamp);
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

    function _validateOptionConfig(OptionConfig memory optionConfig) private view {
        require(quantorGovernance.isWhitelistedAsset(optionConfig.makerAssetAddress));
        require(quantorGovernance.isWhitelistedAsset(optionConfig.takerAssetAddress));
        require(optionConfig.beginTimestamp > block.timestamp);
        require(optionConfig.endTimestamp > optionConfig.beginTimestamp);
    }

    function _constructOrderPart(OptionConfig memory optionConfig) 
        private view 
        returns (ILimitOrderProtocol.Order memory order) 
    {
        order.salt = optionConfig.salt;
        order.maker = address(this);
        order.allowedSender = address(this);
        order.makerAsset = optionConfig.makerAssetAddress;
        order.takerAsset = optionConfig.takerAssetAddress;
        order.receiver = address(this);
        order.makerAssetData = "";
        order.takerAssetData = "";
        order.interaction = "";
        order.predicate = "";
        order.permit = "";
    }
}
