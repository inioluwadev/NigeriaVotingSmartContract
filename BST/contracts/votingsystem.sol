// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract voting {

    mapping (address=> bool) public voters;

    uint public yesVotes; // Count of Yes Votes
    uint public noVotes ;// Count of No Votes

    // Function to Vote
    function vote(bool _vote) public  {
        require(!voters[msg.sender], "You hvae already Voted!");
        voters[msg.sender] = true;
        
        if (_vote) {
            yesVotes++;
        } else {
            noVotes++;
        }
    }
    
    function getResults() public view returns (string memory) {
        if (yesVotes > noVotes){
            return "Yes Wins!";
        } else if (noVotes > yesVotes) {
            return "No Wins";

        } else {
            return "It is a Tie!";
        }
    }
}