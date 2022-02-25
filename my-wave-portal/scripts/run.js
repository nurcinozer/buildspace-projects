const main = async () => {
  // In order to deploy something to the blockchain, we need to have a wallet address
  const waveContractFactory = await hre.ethers.getContractFactory("WavePortal");
  // The Hardhat Runtime Environment, or HRE for short, is an object containing all the functionality that Hardhat exposes when running a task, test or script. In reality, Hardhat is the HRE.

  const waveContract = await waveContractFactory.deploy({
    value: hre.ethers.utils.parseEther("0.1"), // go and deploy my contract and fund it with 0.1 ETH
    // This will remove ETH from my wallet, and use it to fund the contract
  });
  // Hardhat will create a local Ethereum network for us, but just for this contract
  await waveContract.deployed();

  console.log("contract deployed to:", waveContract.address);
  // This address is how we can actually find our contract on the blockchain
  // console.log("contract deployed by:", owner.address);
  // doing this just to see the address of the person deploying our contract

  /*
   * Get Contract balance
   */
  let contractBalance = await hre.ethers.provider.getBalance(
    waveContract.address
  );
  console.log(
    "Contract balance:",
    hre.ethers.utils.formatEther(contractBalance)
  );

  // let waveCount;
  // waveCount = await waveContract.getTotalWaves();

  // let waveTxn = await waveContract.wave("a message!");
  // await waveTxn.wait(); // wait for the transaction to be mined

  // contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
  // console.log(
  //   "Contract balance:",
  //   hre.ethers.utils.formatEther(contractBalance)
  // );

  // waveCount = await waveContract.getTotalWaves();

  // const [_, randomPerson] = await hre.ethers.getSigners();
  // waveTxn = await waveContract.connect(randomPerson).wave("another message!");
  // await waveTxn.wait();

  // waveCount = await waveContract.getTotalWaves();

  // let allWaves = await waveContract.getAllWaves();
  // console.log(allWaves);

  const waveTxn = await waveContract.wave("This is wave #1");
  await waveTxn.wait();

  const waveTxn2 = await waveContract.wave("This is wave #2");
  await waveTxn2.wait();

  contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
  console.log(
    "Contract balance:",
    hre.ethers.utils.formatEther(contractBalance)
  );

  let allWaves = await waveContract.getAllWaves();
  console.log(allWaves);
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();
