/*@flow*/
const fs = require('fs');
const { ethers, artifacts, web3, run } = require('hardhat');

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log('Deploying contracts with the account:', deployer.address);

  // Check balance first
  const deployerBalance = await ethers.provider.getBalance(deployer.address);
  console.log(`Deployer has ${web3.utils.fromWei(deployerBalance.toString())} ETH`);

  const ds = await ethers.deployContract('LockboxTools', []);
  await ds.waitForDeployment();

  console.log("Uploading for verification");
  await run('verify', {
      address: await ds.getAddress(),
      constructorArgsParams: [],
  });

  await writeOutput("data-deployment.json", deployer.address, await ds.getAddress());
}

const writeOutput = async (
  outFile /*:string*/,
  deployerAddress /*:string*/,
  dumpStakeAddress /*:string*/,
) => {
  const out = JSON.stringify({
    network: process.env.HARDHAT_NETWORK,
    deployer: deployerAddress,
    lockboxTools: {
      addr: dumpStakeAddress,
      abi: (await artifacts.readArtifact('LockboxTools')).abi,
    },
  }, null, '\t');
  fs.writeFileSync(outFile, out);
};

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
