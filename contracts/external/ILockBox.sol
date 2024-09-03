// SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface ILockBox is IERC721 {
    struct Lockup {
        uint256 amountAsset;
        uint256 amountLpToken;
        uint256 lpTokenValuation;
        uint256 assetSecondsLocked;
        uint256 lpSecondsLocked;
        uint64 createTime;
        uint64 lastDepositTime;
        uint64 durationSeconds;
        bool autoRelock;
    }

    struct LpStatsDetail {
        uint112 statsAssetAvg;
        uint112 statsLptAvg;
        uint32 timeLastSample;
    }

    struct KeyVal {
        string key;
        bytes val;
    }

    event LockupCreated(uint256 tokenId, address owner, uint256 amountAsset, uint256 amountLpToken, uint64 durationSeconds, uint256 lpTokenValuation, bool autoRelock);
    event AssetsAdded(uint256 tokenId, address addedBy, bool resetStartTime, uint256 amountAsset, uint256 amountLpToken,  uint64 effectiveDuration, uint256 lpTokenValuation);
    event DurationChanged(uint256 tokenId, uint64 newDuration, bool autoRelock);
    event Unlocked(uint256 tokenId, address owner, uint256 amountAsset, uint256 amountLpToken);
    event KvUpdate(uint256 tokenId, string key, bytes value);

    function lockups(
        uint256 lockupId
    )
        external
        view
        returns (
            uint256 amountAsset,
            uint256 amountLpToken,
            uint256 lpTokenValuation,
            uint256 assetSecondsLocked,
            uint256 lpSecondsLocked,
            uint64 createTime,
            uint64 lastDepositTime,
            uint64 durationSeconds,
            bool autoRelock
        );

    function kvStore(uint256 id, string calldata key) external view returns (bytes memory);

    function totalAssetLocked() external view returns (uint256);
    function totalLpTokenLocked() external view returns (uint256);
}
