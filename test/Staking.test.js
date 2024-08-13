const { expect } = require("chai");


describe("Staking", function () {
  let owner, token, staking;

  beforeEach(async () => {
     [owner] = await ethers.getSigners();
    const Token = await ethers.getContractFactory("Token");
    const Staking = await ethers.getContractFactory("Stakings");

    token = await Token.deploy();
    staking = await Staking.deploy();
    
  });

  it("Should stake 100 token", async()=>{
    
    // approve amount in wei
    let approveAmount = ethers.parseEther("10000", 'ether');
    // create an offer
    let approveTx = await token.approve(staking.target, approveAmount);
    await approveTx.wait();

    // create an offer
    // offer tx 
    let offerTx = await staking.createOffer(
      token.target,
      10,
      3600,
      "Offer - 1",
      approveAmount,
      "",
      "",
      Number(Date.now()/1000 + 10 * 60).toFixed(0) // 10 minutes
    );
    await offerTx.wait();

    let offer = await staking.offers(1);
    expect(offer.rewardPool).to.equal(approveAmount);

    // stake in offer 1
    let stakeAmountInWei = ethers.parseEther("100", 'ether');
    
    
    
    // check is offer started or not
    expect(Number(offer.startDate)).to.be.above(Number(Date.now()/1000));

    try{
      // approve stake amount
    let approveStakeTx = await token.approve(staking.target, stakeAmountInWei);
    await approveStakeTx.wait();
    // stake
    let stakeTx = await staking.stake(1, stakeAmountInWei);
    await stakeTx.wait();

    let stake = await staking.stakings(1)
    }catch(err){
      expect(err.message).to.equal("VM Exception while processing transaction: reverted with reason string 'Staking not started'");
    }

    // fast forward time 10 min
    await network.provider.send("evm_increaseTime", [601]);
    await network.provider.send("evm_mine");

    // check now offer started
    offer = await staking.offers(1);
    expect(Number(offer.startDate)).to.be.below(Number((Date.now()/1000) + 601));

    // approve stake amount
    approveStakeTx = await token.approve(staking.target, stakeAmountInWei);
    await approveStakeTx.wait();
    // stake
    stakeTx = await staking.stake(1, stakeAmountInWei);
    await stakeTx.wait();

    stake = await staking.stakings(1)

    // update daily reward
    let updateDailyRewardTx = await staking.updateDailyReward(1);
    await updateDailyRewardTx.wait();

    // check reward
    let reward = await staking.reward(1);
    expect(reward).to.equal(0);

    // fast forward time 1 day
    await network.provider.send("evm_increaseTime", [86401]);
    await network.provider.send("evm_mine");

    // update daily reward
    updateDailyRewardTx = await staking.updateDailyReward(1);
    await updateDailyRewardTx.wait();

    // check reward

    reward = await staking.reward(1);

    // convert reward in ether
    reward = ethers.formatEther(reward, 'ether');
    expect(reward).to.equal("2.739726027397260273");


    // mint 200 token to owner
    let mintAmount = ethers.parseEther("200", 'ether');

    let mintTx = await token.mint(owner.address, mintAmount);
    await mintTx.wait();

    // approve stake amount

    approveStakeTx = await token.approve(staking.target, mintAmount);
    await approveStakeTx.wait();

    // stake
    stakeTx = await staking.stake(1, mintAmount);
    await stakeTx.wait();

    // fast forward time 1 day
    await network.provider.send("evm_increaseTime", [86401]);
    await network.provider.send("evm_mine");

    // update daily reward
    updateDailyRewardTx = await staking.updateDailyReward(1);
    await updateDailyRewardTx.wait();

    // const offer
    offer = await staking.offers(1);
    console.log(ethers.formatEther(offer.totalStaked, 'ether'));

    // check reward
    reward = await staking.reward(1);
    reward = ethers.formatEther(reward, 'ether');
    console.log(reward);

    reward = await staking.reward(2);
    reward = ethers.formatEther(reward, 'ether');
    console.log(reward);

  });
  
});


