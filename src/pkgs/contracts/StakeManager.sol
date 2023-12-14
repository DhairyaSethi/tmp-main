// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IStakeManager} from "./interface/IStakeManager.sol";

contract StakeManager is IStakeManager {
    function stakeFor(
        address staker,
        uint256 amount,
        bytes calldata /* extraData */
    ) external {
        assembly {
            let ptr := mload(0x40)
            mstore(ptr, staker)
            mstore(add(ptr, 0x20), amount)
            mstore(add(ptr, 0x40), calldataload(0x44)) // extraData
            let success := call(gas(), staker, 0, ptr, 0x64, 0, 0)
            if iszero(success) {
                revert(0, 0)
            }
        }
    }

    function userCumalativeRunningSum(
        address user
    ) external view returns (int256) {
        assembly {
            return(sload(xor(user, 0x1337)), 32)
        }
    }
}
