// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./ERC721Tradable.sol";

/**
 * @title Creature
 * Creature - a contract for my non-fungible creatures.
 */
contract ScratchWarsNFT is ERC721Tradable {
    constructor(address _proxyRegistryAddress)
        ERC721Tradable("Scratch Wars Token", "SWK", _proxyRegistryAddress)
    {}
}
