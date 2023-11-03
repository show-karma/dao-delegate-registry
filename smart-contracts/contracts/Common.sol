// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

struct CustomScore {
    string name;
    uint256 value;
}

struct Stats {
    string daoName;
    CustomScore[] customScore;
    uint256 karmaScore;
    uint256 forumActivityScore;
    uint256 forumPostsReadCount;
    uint256 forumLikesReceived;
    uint256 forumPostCount;
    uint256 forumTopicCount;
    uint256 forumPostCountPercentile;
    uint256 forumTopicCountPercentile;
    uint256 forumLikesReceivedPercentile;
    uint256 forumPostsReadCountPercentile;
    uint256 proposalsInitiated;
    uint256 proposalsDiscussed;
    uint256 proposalsOnAragon;
    uint256 proposalsOnSnapshot;
    uint256 proposalsInitiatedPercentile;
    uint256 proposalsDiscussedPercentile;
    uint256 delegatedVotes;
    uint256 onChainVotesPct;
    uint256 offChainVotesPct;
    uint256 aragonVotesPct;
    uint256 avgPostLikes;
    uint256 avgPostLength;
    uint256 avgTopicPostCount;
    uint256 discordMessagesCount;
    uint256 discordMessagesPercentile;
    uint256 percentile;
}
