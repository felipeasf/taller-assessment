// ## Code Challenge

// ### Task: Develop a Simple Voting Smart Contract

// You are required to create a simple voting smart contract in Solidity that allows users to propose candidates and vote for them. The contract should include the following functionalities:

// 1.  **Add Candidate**: A function to add a candidate to the election.
// 2.  **Vote**: A function to allow users to vote for a candidate.
// 3.  **Get Winner**: A function to determine the candidate with the most votes.
// 4.  **Security**: Ensure that a user can only vote once and that only registered candidates can receive votes.

// ### Requirements:

// *   Use Solidity for the implementation.
// *   Ensure the contract is secure and follows best practices.
// *   Include comments in your code to explain your logic.

/// SPDX-License-Identifier: MIT
pragma solidity 0.8.29;

contract Voting {
    struct Candidate {
        string name;
        uint256 voteCount;
        bool exists;
    }

    uint256 public candidateCount;

    mapping(uint256 => Candidate) public candidates;
    mapping(address => bool) public hasVoted;

    event CandidateAdded(string indexed _name);
    event NewVote(address indexed voter, uint256 candidateId);
    event Winner(string indexed Name, uint256 votes);

    function addCadidate(string memory _name) external {
        require(bytes(_name).length > 0, "Empty candidate name");
        candidates[candidateCount] = Candidate({
            name: _name,
            voteCount: 0,
            exists: true
        });

        candidateCount++;

        emit CandidateAdded(_name);
    }    

    // I would mark this functions a reentrant to avoid an user to fraud the elections
    function vote(uint256 candidateId) external /*nonReentrant*/ {
        require(!hasVoted[msg.sender], "You already voted!");

        hasVoted[msg.sender] = true;
        candidates[candidateId].voteCount++;

        emit NewVote(msg.sender, candidateId);
    }

    function getWinner() external returns(string memory winnerName, uint256 winnerVotes) {
        // ToDo run checks

        uint256 highestVotes;
        uint256 winnerId;

        for(uint256 i; i < candidateCount; i++){
            if(candidates[i].voteCount > highestVotes) {
                highestVotes = candidates[i].voteCount;
                winnerId = i;
            }
        }

        winnerName = candidates[winnerId].name;
        winnerVotes = candidates[winnerId].voteCount;

        emit Winner(winnerName, winnerVotes);
    }

}



