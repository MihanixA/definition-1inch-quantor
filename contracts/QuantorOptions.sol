// SPDX-License-Identifier: MIT
pragma solidity 0.8.12;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";

import "./interfaces/IQuantorOptions.sol";


contract QuantorOptions is IQuantorOptions {

    mapping(bytes32 => uint256) public optionConfigHashToNftId;

    constructor() {}

    function mintOption(OptionConfig memory optionConfig) external {

    }

    function burnOption(OptionConfig memory optionConfig) external {

    }

    function hashOptionConfig(OptionConfig memory optionConfig) public pure returns (bytes32) {
        return keccak256(abi.encode(optionConfig));
    }    
}
