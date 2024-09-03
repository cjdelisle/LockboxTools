const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("LockboxTools", (m) => {
  const lbt = m.contract("LockboxTools", []);
  return { lbt };
});
