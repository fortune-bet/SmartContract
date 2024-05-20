// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract PseudoRandomShuffle {
    address public owner;

    uint8[] public deckVerify;
    uint256 public blockHashVerify;
    uint256 public timestampVerify;
    string public extraStringVerify;

    // Constructor function, generates an ordered deck of cards when the contract is deployed
    constructor() {
        owner = msg.sender; // Set the contract owner to the deployer upon contract deployment
        deckVerify = generateDeck();
    }
    
    // Generates an ordered deck of cards
    function generateDeck() internal pure returns (uint8[] memory) {
        uint8[] memory newDeck = new uint8[](52);
        for (uint8 i = 0; i < 52; i++) {
            newDeck[i] = i + 1; // Represent each card with an integer, e.g., 1 for Ace of Hearts, 52 for King of Spades
        }
        return newDeck;
    }
    
    // Modifier to ensure only the contract's owner can call certain functions
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    // Verify the order of cards
    function verification(uint256 blockHashInput, uint256 timestampInput, string memory extraData) public {
        // Combine block hash and timestamp into a pseudo-random number
        blockHashVerify = blockHashInput;
        timestampVerify = timestampInput;
        extraStringVerify = extraData;
        uint256 pseudoRandomNumber = uint256(keccak256(abi.encodePacked(blockHashVerify, timestampVerify, extraStringVerify)));
        for (uint8 i = 0; i < 52; i++) {
            deckVerify[i] = i + 1; // Represent each card with an integer, e.g., 1 for Ace of Hearts, 52 for King of Spades
        }

        uint256 n = deckVerify.length;
        while (n > 2) {
            n--;
            uint8 randIndex = uint8(pseudoRandomNumber % n);
            (deckVerify[n], deckVerify[randIndex]) = (deckVerify[randIndex], deckVerify[n]);
            if (pseudoRandomNumber > 10000) {
                pseudoRandomNumber = pseudoRandomNumber / 10;
            } 
        }
        n = deckVerify.length;
        while (n > 2) {
            n--;
            uint8 randIndex = uint8(pseudoRandomNumber % n);
            (deckVerify[n], deckVerify[randIndex]) = (deckVerify[randIndex], deckVerify[n]);
            if (pseudoRandomNumber > 10000) {
                pseudoRandomNumber = pseudoRandomNumber / 10;
            } 
        }
    }
    // Retrieves the verified deck of cards
    function getVerifyDeck() public view returns (uint8[] memory, uint256, uint256, string memory) {
        return (deckVerify, blockHashVerify, timestampVerify, extraStringVerify);
    }

}
