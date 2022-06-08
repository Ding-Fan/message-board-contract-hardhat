//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

// import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

// import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract NftCollection is ERC721URIStorage {
    using Strings for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // function initialize() initializer public {
    //     __ERC721_init("FinalFantacy", "MK");
    // }

    uint256 limitCount = 20;

    string[] firstWords = [
        unicode"吴",
        unicode"赵",
        unicode"钱",
        unicode"孙",
        unicode"李",
        unicode"周",
        unicode"郑",
        unicode"王",
        unicode"公孙"
    ];
    string[] secondWords = [
        unicode"吴",
        unicode"赵",
        unicode"钱",
        unicode"孙",
        unicode"李",
        unicode"国",
        unicode"郑",
        unicode"王",
        unicode"公孙"
    ];
    string[] thirdWords = [
        unicode"吴",
        unicode"赵",
        unicode"钱",
        unicode"孙",
        unicode"李",
        unicode"黎",
        unicode"郑",
        unicode"王",
        unicode"公孙"
    ];

    string[] colors = ["green", "gold", "blue", "red"];

    constructor() ERC721("FinalFantacy", "MK") {
        console.log("constructor of my NFT contract");
    }

    event NFTMinted(address sender, uint256 tokenId);

    string svgPart1 =
        "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: ";
    string svgPart2 =
        "; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function createNftSvg(string memory _combinedWord, string memory _tokenId)
        internal
        view
        returns (string memory)
    {
        string memory theColor = colors[
            random(string(abi.encodePacked("color", _tokenId))) % colors.length
        ];

        string memory result = string(
            abi.encodePacked(
                svgPart1,
                theColor,
                svgPart2,
                _combinedWord,
                "</text></svg>"
            )
        );

        console.log("\n--------------------");
        console.log(result);
        console.log("--------------------\n");

        return result;
    }

    function createTokenUri(string memory _combinedWord, string memory _tokenId)
        internal
        view
        returns (string memory)
    {
        string memory json = string(
            abi.encodePacked(
                '{"name": "', // solhint-disable-line
                _combinedWord,
                '", "description": "Oh my random generated NFT", "image": "data:image/svg+xml;base64,', // solhint-disable-line
                Base64.encode(
                    abi.encodePacked(createNftSvg(_combinedWord, _tokenId))
                ),
                '"}' // solhint-disable-line
            )
        );

        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(abi.encodePacked(json))
                )
            );
    }

    function makeNft() public {
        uint256 tokenId = _tokenIds.current();

        require(tokenId < limitCount, "No more NFT");

        string memory firstWord = firstWords[
            random(string(abi.encodePacked("First_Word", tokenId.toString()))) %
                firstWords.length
        ];
        string memory secondWord = secondWords[
            random(
                string(abi.encodePacked("Second_Word", tokenId.toString()))
            ) % secondWords.length
        ];
        string memory thirdWord = thirdWords[
            random(string(abi.encodePacked("Third_Word", tokenId.toString()))) %
                thirdWords.length
        ];

        string memory combinedWord = string(
            abi.encodePacked(firstWord, secondWord, thirdWord)
        );

        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, createTokenUri(combinedWord, tokenId.toString()));

        console.log(
            "token uri: ",
            createTokenUri(combinedWord, tokenId.toString()),
            "\n"
        );

        _tokenIds.increment();

        console.log(
            "An NFT w/ ID %s has been minted to %s",
            tokenId,
            msg.sender
        );

        emit NFTMinted(msg.sender, tokenId);
    }

    function getTotalNftMintedSoFar() public view returns (uint256) {
        return _tokenIds.current();
    }
}
