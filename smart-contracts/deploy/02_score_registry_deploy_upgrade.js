module.exports = async ({ getNamedAccounts, deployments, upgrades }) => {
    const { log } = deployments;

    const ScoreRegistry = await ethers.getContractFactory("ScoreRegistry");
    const currentScoreRegistryContract = await deployments.get("ScoreRegistryArtifact");

    const currentImplAddress = await upgrades.erc1967.getImplementationAddress(currentScoreRegistryContract.address);
    log(
        `Current ScoreRegistry contracts Proxy: ${currentScoreRegistryContract.address}, implementation: ${currentImplAddress}`
    );

    const scoreRegistry = await upgrades.upgradeProxy(currentScoreRegistryContract.address, ScoreRegistry);
    log(`Upgrading ...`);
    await scoreRegistry.waitForDeployment();
    log(`Upgraded ...`);

    const newImplAddress = await upgrades.erc1967.getImplementationAddress(scoreRegistry.target);

    log(
        `ScoreRegistry deployed as Proxy at : ${scoreRegistry.target}, implementation: ${newImplAddress}`
    );

    const ScoreRegistryArtifact = await deployments.getExtendedArtifact('ScoreRegistry');

    const factoryAsDeployment = {
        address: scoreRegistry.target,
        ...ScoreRegistry,
    };
    await deployments.save('ScoreRegistryArtifact', factoryAsDeployment);
};

module.exports.tags = ['score-registry-upgrade'];
