// contracts/GLDToken.sol
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DAOCHAT is Ownable,AccessControl {
    string public NAME;
    bytes32 public constant VOTE_ROLE = keccak256("VOTE_ROLE");

    string[] private VOTE_ID;

    // VoteId → タイトル
    mapping (string => string) private VOTE;

    // VoteId → ChoiceId
    mapping (string=>string[]) CHOICE_ID;

    // voteId → choiceId　→　結果
    mapping(string => mapping(string => uint256)) private CHOICE_RESULTS;

    constructor (string memory name) {
        NAME = name;
        _grantRole(VOTE_ROLE, msg.sender);
    }

    function AddMember(address newAdmin) public {
        require(hasRole(VOTE_ROLE,msg.sender));
         _grantRole(VOTE_ROLE, newAdmin);
    }

    function DeleteAdminMember(address AdminAddress) public {
        require(hasRole(VOTE_ROLE,msg.sender));
        require(AdminAddress != msg.sender);
        _revokeRole(VOTE_ROLE,AdminAddress);
    }

    function AddVote(string memory voteId,string memory title,string[] memory choiceId) public {
        require(hasRole(VOTE_ROLE,msg.sender));

        VOTE_ID.push(voteId);
        VOTE[voteId] = title;
        
        for (uint256 index = 0; index < choiceId.length; index++) {
            CHOICE_ID[voteId].push(choiceId[index]);
        }
    }

    function AddAnswer(string memory vote_id,string[] memory choice_id,uint256[] memory count) public {
        require(hasRole(VOTE_ROLE,msg.sender));
        
        for (uint256 index = 0; index < choice_id.length; index++) {
            CHOICE_RESULTS[vote_id][choice_id[index]] = count[index];
        }
    }

    function GetName() public view returns(string memory name) {
        return NAME;
    }

    function GetVotes() public view returns(string[] memory ids,string[] memory titles) {
        string[] memory respIds = new string[](VOTE_ID.length);
        string[] memory respTitles = new string[](VOTE_ID.length);

        for (uint256 index = 0; index < VOTE_ID.length; index++) {
            respIds[index]=VOTE_ID[index];
            respTitles[index] = VOTE[VOTE_ID[index]];
        }
        return (respIds,respTitles);
    }

    function GetChoices(string memory voteId) public view returns (string[] memory ids) {
        return CHOICE_ID[voteId];
    }

    function GetChoiceCount(string memory voteId) public view returns (uint256 ids) {
        return CHOICE_ID[voteId].length;
    }

    function GetResult(string memory voteId,uint256 choice_count) public view returns(string[] memory ids,uint256[] memory results) {
        string[] memory respIds = new string[](choice_count);
        uint256[] memory respResults = new uint256[](choice_count);

        for (uint256 index = 0; index < CHOICE_ID[voteId].length; index++) {
            respIds[index] = CHOICE_ID[voteId][index];
            respResults[index]=CHOICE_RESULTS[voteId][CHOICE_ID[voteId][index]];
        }
        return (respIds,respResults);
    }
}