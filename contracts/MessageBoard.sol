//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract MessageBoard {
    constructor() {
        console.log("this is message board contract");
    }

    event NewMessage(address sender, string content);

    struct Message {
        address sender; // The address of the user who waved.
        string content; // The message the user sent.
        // uint256 timestamp; // The timestamp when the user waved.
    }

    Message[] messages;

    function saveMessage(string memory _content) public {
        console.log("%s send message %s", msg.sender, _content);

        /*
         * This is where I actually store the wave data in the array.
         */
        messages.push(Message(msg.sender, _content));

        /*
         * I added some fanciness here, Google it and try to figure out what it is!
         * Let me know what you learn in #general-chill-chat
         */
        emit NewMessage(msg.sender, _content);
    }

    function getAllMessages() public view returns (Message[] memory) {
        return messages;
    }
}
