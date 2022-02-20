// SPDX-License-Identifier: MIT
pragma solidity 0.8.12;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";
import "@openzeppelin/contracts/utils/introspection/IERC165.sol";

import "./interfaces/IQuantorOptions.sol";
import "./interfaces/IQuantorGovernance.sol";


contract QuantorOptions is IQuantorOptions, ERC721, ERC721Burnable {

    IQuantorGovernance public quantorGovernance;
    mapping(bytes32 => uint256) public optionConfigHashToNftId;

    constructor(address quantorGovernance_) ERC721("QOPTS", "Quantor Options Protocol") {
        quantorGovernance = IQuantorGovernance(quantorGovernance_);
    }

    function mintOption(OptionConfig memory optionConfig) external {
        
    }

    function burnOption(OptionConfig memory optionConfig) external {

    }

    function hashOptionConfig(OptionConfig memory optionConfig) public pure returns (bytes32) {
        return keccak256(abi.encode(optionConfig));
    }

    function supportsInterface(bytes4 interfaceId) public view override (ERC721, ERC721Enumerable) returns(bool) {
        return (
            interfaceId == type(IERC165).interfaceId ||
            interfaceId == type(IERC721).interfaceId ||
            interfaceId == type(IQuantorOptions).interfaceId
        );
    }
}
