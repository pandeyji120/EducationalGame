// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EducationalGame {
    struct Player {
        address playerAddress;
        string name;
        uint score;
    }

    mapping(address => Player) public players;
    address[] public playerAddresses;
    address public owner;
    
    event PlayerRegistered(address playerAddress, string name);
    event ScoreUpdated(address playerAddress, uint newScore);
    event RewardIssued(address playerAddress, uint rewardAmount);

    constructor() {
        owner = msg.sender;
    }

    // Modifier to restrict access to the owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action.");
        _;
    }

    // Function to register a new player
    function registerPlayer(string memory _name) public {
        require(bytes(_name).length > 0, "Name cannot be empty.");
        require(players[msg.sender].playerAddress == address(0), "Player is already registered.");
        
        players[msg.sender] = Player(msg.sender, _name, 0);
        playerAddresses.push(msg.sender);
        
        emit PlayerRegistered(msg.sender, _name);
    }

    // Function to update the player's score
    function updateScore(address _playerAddress, uint _score) public onlyOwner {
        require(players[_playerAddress].playerAddress != address(0), "Player is not registered.");
        
        players[_playerAddress].score = _score;
        
        emit ScoreUpdated(_playerAddress, _score);
    }

    // Function to issue a reward to the player
    function issueReward(address _playerAddress, uint _rewardAmount) public onlyOwner {
        require(players[_playerAddress].playerAddress != address(0), "Player is not registered.");
        require(_rewardAmount > 0, "Reward amount must be greater than zero.");

        // Logic to issue reward (e.g., transfer tokens or send ETH) can be added here
        // For simplicity, we are just emitting an event

        emit RewardIssued(_playerAddress, _rewardAmount);
    }

    // Function to get a player's details
    function getPlayerDetails(address _playerAddress) public view returns (string memory, uint) {
        require(players[_playerAddress].playerAddress != address(0), "Player is not registered.");
        
        Player memory player = players[_playerAddress];
        return (player.name, player.score);
    }

    // Function to get the total number of registered players
    function getTotalPlayers() public view returns (uint) {
        return playerAddresses.length;
    }
}

