// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

import {IPAssetRegistry} from "@storyprotocol/core/registries/IPAssetRegistry.sol";
import {LicensingModule} from "@storyprotocol/core/modules/licensing/LicensingModule.sol";
import {PILicenseTemplate} from "@storyprotocol/core/modules/licensing/PILicenseTemplate.sol";

/// @dev this is a simple registry to store the item data on Flow, and create ipAssets
contract ExitRegistry is ERC721 {
  
  IPAssetRegistry public immutable IP_ASSET_REGISTRY;
  LicensingModule public immutable LICENSING_MODULE;
  PILicenseTemplate public immutable PIL_TEMPLATE;

  struct Data {
    uint256 chainId;
    address itemAddress;
    address creator;
  }

  uint256 tokenHeight;

  mapping(uint256 => Data) public tokenToData;
  mapping(uint256 => address) public tokenToIpId;


  constructor() ERC721("dextraGame", "deG") {
    LICENSING_MODULE = LicensingModule(0xf49da534215DA7b48E57A41d41dac25C912FCC60);
    IP_ASSET_REGISTRY = IPAssetRegistry(0xe34A78B3d658aF7ad69Ff1EFF9012ECa025a14Be);
    PIL_TEMPLATE = PILicenseTemplate(0x8BB1ADE72E21090Fc891e1d4b88AC5E57b27cB31);
  }


  function mint(address _itemAddress, uint256 _chainId) external {

    Data memory d = Data({
      chainId: _chainId,
      itemAddress: _itemAddress,
      owner: msg.sender
    });

    tokenToData[tokenHeight] = d;
    _safeMint(msg.sender, tokenHeight);

    address ipId = IP_ASSET_REGISTRY.register(block.chainid, address(this), tokenId);
    tokenToIpId[tokenHeight] = ipId;

    // Non Commercial Social Remixing
    LICENSING_MODULE.attachLicenseTerms(ipId, address(PIL_TEMPLATE), 1);

    tokenHeight++;
  }
}