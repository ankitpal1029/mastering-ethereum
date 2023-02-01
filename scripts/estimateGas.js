const { ethers } = require("hardhat");
const hre = require("hardhat");
const fs = require("fs");

async function main() {
  const [owner] = await hre.ethers.getSigners();
  const Faucet = await hre.ethers.getContractFactory("Faucet", owner);
  const faucet = await Faucet.deploy();
  await faucet.deployed();

  const fOwner = await ethers.getContractAt("Faucet", faucet.address, owner);
  const transactionHash = await owner.sendTransaction({
    to: faucet.address,
    value: ethers.utils.parseEther("1"),
  });
  const receipt = await transactionHash.wait();

  const transferEventId = ethers.utils.id("Deposit(address,uint)");
  let iface = new ethers.utils.Interface(getAbi());
  receipt.logs.forEach((log) => {
    console.log(iface.parseLog(log));
  });
}
const getAbi = () => {
  const dir = "./artifacts/contracts/Faucet.sol/Faucet.json";
  const file = fs.readFileSync(dir, "utf8");
  const json = JSON.parse(file);
  const abi = json.abi;
  return abi;
};

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
