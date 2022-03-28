pragma solidity 0.8.4;

contract CardCommit {

    mappings(address => bytes32) card1Commit;
    mappings(address => bytes32) card2Commit;

    function commitCard1(bytes32 _card1Commit) external {
        card1Commit[msg.sender] = _card1Commit;
    }

    function commitCard2(bytes32 _card2Commit, bytes proof) external {
        require(card2Commit[msg.sender] != bytes32(0), "already committed");
        
        // Q: Here we need to do the verifier and verify it properly here
        // Now it is just a pseudocode.
        require(verifier.verify(card1Commit[msg.sender], _card2Commit, proof), "proof failed");
        card2Commit[msg.sender] = _card2Commit;
    }
}
