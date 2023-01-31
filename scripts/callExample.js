const { ethers } = require("hardhat");
const hre = require("hardhat");
const fs = require("fs");

async function main() {
  const [owner] = await hre.ethers.getSigners();
  const CalledContract = await hre.ethers.getContractFactory(
    "calledContract",
    owner
  );
  const calledContract = await CalledContract.deploy();
  await calledContract.deployed();

  const CalledLibrary = await hre.ethers.getContractFactory(
    "calledLibrary",
    owner
  );
  const calledLibrary = await CalledLibrary.deploy();
  await calledLibrary.deployed();

  const Caller = await hre.ethers.getContractFactory("caller", {
    signer: owner,
    libraries: {
      calledLibrary: calledLibrary.address,
    },
  });
  const caller = await Caller.deploy();
  await caller.deployed();

  const cOwner = await ethers.getContractAt("caller", caller.address, owner);

  const transactionHash = await cOwner.make_calls(calledContract.address);

  const receipt = transactionHash.wait();

  //   let iface = new ethers.utils.Interface(getAbi());
  //   receipts.logs.forEach((log) => {
  //     console.log(iface.parseLog(log));
  //   });
}
const getAbi = () => {
  const dir = "./artifacts/contracts/CallExample.sol/caller.json";
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
