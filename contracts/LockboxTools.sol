// SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity ^0.8.24;

import "./external/ILockBox.sol";

import "hardhat/console.sol";

contract LockboxTools {
    function getLockups(
        ILockBox boxAddr,
        uint32[] calldata ids,
        string[] calldata kvKeys
    ) public view returns (
        bytes[] memory data,
        bytes[][] memory kvValues
    ) {
        data = new bytes[](ids.length);
        kvValues = new bytes[][](ids.length);

        for (uint256 i = 0; i < ids.length; i++) {
            {
                (
                    uint256 amountAsset,
                    uint256 amountLpToken,
                    uint256 lpTokenValuation,
                    uint256 assetSecondsLocked,
                    uint256 lpSecondsLocked,
                    uint64 createTime,
                    uint64 lastDepositTime,
                    uint64 durationSeconds,
                    bool autoRelock
                ) = boxAddr.lockups(uint256(ids[i]));
                uint256 meta = createTime;
                meta <<= 64; meta |= lastDepositTime;
                meta <<= 64; meta |= durationSeconds;
                meta <<= 1; meta |= autoRelock ? 1 : 0;
                address owner = address(0);
                if (createTime > 0) {
                    owner = boxAddr.ownerOf(ids[i]);
                }
                data[i] = abi.encode(
                    amountAsset,
                    amountLpToken,
                    lpTokenValuation,
                    assetSecondsLocked,
                    lpSecondsLocked,
                    meta,
                    owner
                );
                if (createTime == 0) {
                    continue;
                }
            }
            {
                bytes[] memory kvv = new bytes[](kvKeys.length);
                for (uint256 j = 0; j < kvKeys.length; j++) {
                    kvv[j] = boxAddr.kvStore(ids[i], kvKeys[j]);
                }
                kvValues[i] = kvv;
            }
        }
    }
}
