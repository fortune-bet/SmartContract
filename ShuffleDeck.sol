// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract PseudoRandomShuffle {
    address public owner;
    uint8[] public deck;
    uint256 public blockHash;
    uint256 public timestamp;
    string public extraString;

    // Constructor function, generates an ordered deck of cards when the contract is deployed
    constructor() {
        // owner = msg.sender; // Set the contract owner as the deployer when the contract is deployed
        deck = generateDeck();
    }

    event DeckShuffled(string deckStr, uint256 blockHash, uint256 timestamp, string input);

    // Modifier, ensures that only the owner of the contract can call a function
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    // Generates an ordered deck of cards
    function generateDeck() internal pure returns (uint8[] memory) {
        uint8[] memory newDeck = new uint8[](52);
        for (uint8 i = 0; i < 52; i++) {
            newDeck[i] = i + 1; // Represent each card with integers, e.g., 1 for Ace of Hearts, 52 for King of Spades
        }
        return newDeck;
    }

    // Gets a pseudo-random number and shuffles the deck
    function getPseudoRandomShuffledDeck(string memory extraData) public {
        for (uint8 i = 0; i < 52; i++) {
            deck[i] = i + 1; // Represent each card with integers, e.g., 1 for Ace of Hearts, 52 for King of Spades
        }
        uint256 n = deck.length;
        blockHash = uint256(blockhash(block.number - 1)); // Get the hash of the previous block
        timestamp = block.timestamp; // Get the current block's timestamp
        extraString = extraData;
        uint256 randomnum = getPseudoRandomNumber(extraData); // Random number
        while (n > 2) {
            n--;
            uint8 randIndex = uint8(randomnum % n);
            (deck[n], deck[randIndex]) = (deck[randIndex], deck[n]);
            if (randomnum > 10000) {
                randomnum = randomnum / 10;
            }
        }
        n = deck.length;
        while (n > 2) {
            n--;
            uint8 randIndex = uint8(randomnum % n);
            (deck[n], deck[randIndex]) = (deck[randIndex], deck[n]);
            if (randomnum > 10000) {
                randomnum = randomnum / 10;
            }
        }
        // Convert the deck array into a string
        string memory deckStr = uint8ArrayToString(deck);

        // Trigger the event
        emit DeckShuffled(deckStr, blockHash, timestamp, extraData);
    }

    // Gets a pseudo-random number
    function getPseudoRandomNumber(string memory extraData) internal view returns (uint256) {
        // Combine the block hash and timestamp into a pseudo-random number
        uint256 pseudoRandomNumber = uint256(keccak256(abi.encodePacked(blockHash, timestamp, extraData)));
        return pseudoRandomNumber;
    }

    // Get the current pseudo-randomly shuffled deck of cards
    function getCurrentDeck() public view returns (uint8[] memory, uint256, uint256, string memory) {
        return (deck, blockHash, timestamp, extraString);
    }

    function uint8ArrayToString(uint8[] memory array) internal pure returns (string memory) {
        if (array.length == 0) {
            return "";
        }
        // Start concatenating the string
        string memory str = uintToString(array[0]);
        for (uint i = 1; i < array.length; i++) {
            str = string(abi.encodePacked(str, ",", uintToString(array[i])));
        }
        return str;
    }    

    function uintToString(uint _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len;
        while (_i != 0) {
            k = k - 1;
            uint8 temp = (48 + uint8(_i - _i / 10 * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }

}
