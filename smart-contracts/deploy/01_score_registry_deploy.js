import ethers from 'ethers';
const { contractAddresses } = require('../util/contract-addresses');

module.exports = async ({
  getNamedAccounts,
  deployments,
  upgrades,
  network,
}) => {
  const { log } = deployments;
  const ScoreRegistry = await ethers.getContractFactory('ScoreRegistry');

  const scoreRegistry = await upgrades.deployProxy(ScoreRegistry, [
    contractAddresses[network.name].easContract,
  ]);
  await scoreRegistry.waitForDeployment();

  const currentImplAddress = await upgrades.erc1967.getImplementationAddress(
    scoreRegistry.target
  );

  log(
    `ScoreRegistry deployed as Proxy at : ${scoreRegistry.target}, implementation: ${currentImplAddress}`
  );

  const GapArtifact = await deployments.getExtendedArtifact('ScoreRegistry');

  const factoryAsDeployment = {
    address: scoreRegistry.target,
    ...ScoreRegistry,
  };
  await deployments.save('ScoreRegistryArtifact', factoryAsDeployment);
};

module.exports.tags = ['score-registry'];
