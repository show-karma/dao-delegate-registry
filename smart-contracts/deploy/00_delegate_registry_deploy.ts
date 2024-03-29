import {HardhatRuntimeEnvironment} from 'hardhat/types';
import {DeployFunction} from 'hardhat-deploy/types';
  
const func: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
    const {deployments, getNamedAccounts} = hre;
    const {deploy} = deployments;

    const {deployer} = await getNamedAccounts();

    await deploy('DelegateRegistry', {
        from: deployer,
        log: true,
        autoMine: true,
        args: ["<Admin Address>"]
    });
};
export default func;
func.tags = ['DelegateRegistry'];
