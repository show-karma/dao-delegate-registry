import {HardhatRuntimeEnvironment} from 'hardhat/types';
import {DeployFunction} from 'hardhat-deploy/types';

const func: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
    const {deployments, getNamedAccounts, network} = hre;
    const {deploy} = deployments;

    const {deployer} = await getNamedAccounts();

    console.log(network.name);

    const addresses = {
      sepolia: "0x17499276cC8117353900fd8458f5DB52fC27E2cA",
      optimism: "0xd17206EC4D268D0E55bb08A369b6864f1178B81d"
    }

    await deploy('ScoreRegistry', {
        from: deployer,
        log: true,
        autoMine: true,
        args: [addresses[network.name]]
    });
};
export default func;
func.tags = ['ScoreRegistry'];
