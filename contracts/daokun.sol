// contracts/GLDToken.sol
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DAOCHAT is Ownable,AccessControl {
    string public NAME;
    string public constant VOTE_ROLE = keccak256("VOTE_ROKE");

    string[] private VOTE_ID;

    // VoteId → タイトル
    mapping (string => string) private VOTE;

    // VoteId → ChoiceId
    mapping (string=>string[]) CHOICE_ID;

    // voteId → choiceId　→　結果
    mapping(string => mapping(string => uint256)) private CHOICE_RESULTS;

    constructor (string name) {
        NAME = name;
        _grantRole(VOTE_ROLE, msg.sender);
    }

    function AddAdminMember(address AdminAddress) public {
        grantRole(VOTE_ROLE,AdminAddress);
    }

    function DeleteAdminMember(address AdminAddress) public {
        require(AdminAddress != msg.sender);
        revokeRole(VOTE_ROLE,AdminAddress);
    }

    function AddAnswer(string memory vote_id,string[] memory choice_id,uint256[] count) public {
        require(hasRole(VOTE_ROLE,msg.sender));
        
        for (uint256 index = 0; index < choice_id.length; index++) {
            CHOICE_RESULTS[vote_id][choice_id[index]] = count;
        }
    }

    function GetName() public view returns(string) {
        return NAME;
    }

    function GetVotes() public view returns(string[] memory ids,string[] memory titles) {
        string[] respIds;
        string[] respTitles;

        for (uint256 index = 0; index < VoteId.length; index++) {
            respIds.push(VOTE_ID[index]);
            respTitles.push(VOTE[VOTE_ID[index]]);
        }
        return (respIds,respTitles);
    }

    function GetChoices(string memory voteId) public view returns (string[] ids) {
        return CHOICE_ID[voteId];
    }

    function GetResult(string memory voteId) public view returns(string memory ids,uint256 memory results) {
        string[] respIds;
        uint256[] respResults;

        for (uint256 index = 0; index < CHOICE_ID[voteId].length; index++) {
            respIds.push(CHOICE_ID[voteId][index]);
            respResults.push(CHOICE_RESULTS[CHOICE_ID[voteId][index]]);
        }
        return (respIds,respResults);
    }
}