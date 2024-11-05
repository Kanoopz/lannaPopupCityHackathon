// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");
const {ethers} = require("hardhat");

async function main() 
{
  const contractFactory = await ethers.getContractFactory("Lock");
  const contractInstance = await contractFactory.deploy("0x469449f251692e0779667583026b5a1e99512157", "app_staging_95a25cfa91863888a8b00d500786fa53", "verify-humanity");
  await contractInstance.waitForDeployment();
  
  console.log("Contract deploy at address:", await contractInstance.getAddress());
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
