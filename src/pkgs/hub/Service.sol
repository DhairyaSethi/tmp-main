// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IService} from "./interface/IService.sol";

contract Service is IService {
    function onSubscribe(address subscriber, bytes32 topic) external {
        assembly {
            let ptr := mload(0x40)
            mstore(ptr, subscriber)
            mstore(add(ptr, 0x20), topic)
            let success := call(gas(), subscriber, 0, ptr, 0x40, 0, 0)
            if iszero(success) {
                revert(0, 0)
            }
        }
    }

    function onUnsubscribe(address subscriber, bytes32 topic) external {
        assembly {
            let ptr := mload(0x40)
            mstore(ptr, subscriber)
            mstore(add(ptr, 0x20), topic)
            let success := call(gas(), subscriber, 0, ptr, 0x40, 0, 0)
            if iszero(success) {
                revert(0, 0)
            }
        }
    }
}
