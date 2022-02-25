const main = async () => {
  const [deployer] = await hre.ethers.getSigners();
  const accountBalance = await deployer.getBalance();

  console.log("deploying contracts with account: ", deployer.address);
  console.log("account balance: ", accountBalance.toString());

  const waveContractFactory = await hre.ethers.getContractFactory("WavePortal");
  const waveContract = await waveContractFactory.deploy({
    value: hre.ethers.utils.parseEther("0.001"),
  });
  await waveContract.deployed();

  console.log("WavePortal address: ", waveContract.address);
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

// We deployed the contract, and we also have its address on the blockchain! Our website is going to need this so it knows where to look on the blockchain for your contract.

// Output:
// Solidity compilation finished successfully
// deploying contracts with account:  0x2EdbEC06c9D49F8245775D8BD5e2CCc22384140d
// account balance:  296406250729984634
// WavePortal address:  0xC785411677087C04250ea5aeB77fa9f64DB6cf0a