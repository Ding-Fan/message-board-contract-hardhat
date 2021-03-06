// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
import { ethers } from "hardhat"

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');

  // We get the contract to deploy
  // const Greeter = await ethers.getContractFactory("Greeter");
  // const greeter = await Greeter.deploy("Hello, Hardhat!");

  // await greeter.deployed();

  // console.log("Greeter deployed to:", greeter.address);

  const [deployer] = await ethers.getSigners()
  const accountBalance = await deployer.getBalance()

  console.log("Deploying contracts with account: ", deployer.address)
  console.log("Account balance: ", accountBalance.toString())

  const contractFactory = await ethers.getContractFactory("MessageBoard")
  const contract = await contractFactory.deploy()
  await contract.deployed()

  console.log("MessageBoard address: ", contract.address)

  const nftContractFactory = await ethers.getContractFactory("NftCollection")
  const nftContract = await nftContractFactory.deploy()
  await nftContract.deployed()

  console.log("NFT Contract address:", nftContract.address)
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error)
  process.exitCode = 1
})
