const { reset } = require("@nomicfoundation/hardhat-toolbox/network-helpers");
const { ethers } = require('hardhat');

const config = require('../config.js');

const PKT_LOCKBOX = '0x14D15765c66e8f0C7f8757d1D19137B714dfCC60';

const init = async () /*:any*/ => {
  const users = await ethers.getSigners();
  const userAddress = users[0].address;
  if (!config.test.alchemyMainnetKey) {
    throw new Error("config.test.alchemyMainnetKey must be set for testing");
  }
  await reset(`https://base-mainnet.g.alchemy.com/v2/${config.test.alchemyMainnetKey}`, 19287420);
  const lockboxTools = await ethers.deployContract('LockboxTools', []);
  await lockboxTools.waitForDeployment();
  return {
    userAddress,
    lockboxTools,
  };
};

describe("LockboxTools", function () {
  it("Works", async function () {
    const {
      userAddress,
      lockboxTools,
    } = await init();

    const res = await lockboxTools.getLockups(PKT_LOCKBOX, [1,2,3,4,5,6,7,8,9,10], ["NAME", "RES"]);
    console.log(res);
  });
});
