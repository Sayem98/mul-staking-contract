const main = async () => {
  // get the provider
  const [deployer] = await ethers.getSigners();
  //   console.log(deployer);
  console.log("Deploying contracts with the account:", deployer.address);
  // get account balance
  const Stakings = await ethers.getContractFactory("Stakings");
  const Staking = await Stakings.deploy();
  console.log("Contract deployed to:", Staking);

  console.log("Contract address:", Staking.target);
};

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
  });
