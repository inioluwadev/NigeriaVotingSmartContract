// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract NigerianElectionVotingSystem {
    uint public voterCount;
    uint public candidateCount;
    bool public votingOpen;

    mapping(address => bool) public registeredVoters;
    mapping(address => bool) public hasVoted;
    mapping(address => uint) public voterIDs;
    mapping(address => uint) public votesForCandidate;
    mapping(address => string) public voterParty;
    mapping(address => string) public candidates;
    mapping(string => uint) public partyVotes;

    struct Candidate {
        string name;
        string party;
        uint votes;
    }

    mapping(uint => Candidate) public candidatesList;

    function registerVoter() public {
        require(!registeredVoters[msg.sender], "Already registered");
        registeredVoters[msg.sender] = true;
        voterCount++;
        voterIDs[msg.sender] = voterCount;
    }

    function registerCandidate(string memory _name, string memory _party) public {
        require(bytes(_name).length > 0, "Candidate name is required");
        require(bytes(_party).length > 0, "Party name is required");

        candidateCount++;
        candidatesList[candidateCount] = Candidate(_name, _party, 0);
        candidates[msg.sender] = _name;
    }

    function startVoting() public {
        votingOpen = true;
    }

    function vote(uint _candidateID) public {
        require(registeredVoters[msg.sender], "Not registered");
        require(votingOpen, "Voting is not open");
        require(!hasVoted[msg.sender], "You have already voted");

        hasVoted[msg.sender] = true;
        Candidate storage candidate = candidatesList[_candidateID];

        votesForCandidate[msg.sender] = _candidateID;
        partyVotes[candidate.party]++;
        candidate.votes++;
        voterParty[msg.sender] = candidate.party;
    }

    function stopVoting() public {
        votingOpen = false;
    }

    function getCandidateResult(uint _candidateID) public view returns (string memory, uint) {
        Candidate storage candidate = candidatesList[_candidateID];
        return (candidate.name, candidate.votes);
    }

    function getPartyResult(string memory _party) public view returns (uint) {
        return partyVotes[_party];
    }

    function getVoterID(address voter) public view returns (uint) {
        require(registeredVoters[voter], "Voter not registered");
        return voterIDs[voter];
    }

    function getCandidateDetails(uint _candidateID) public view returns (string memory name, string memory party, uint votes) {
        Candidate storage candidate = candidatesList[_candidateID];
        return (candidate.name, candidate.party, candidate.votes);
    }
}
