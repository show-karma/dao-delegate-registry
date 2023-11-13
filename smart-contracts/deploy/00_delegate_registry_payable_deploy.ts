import {HardhatRuntimeEnvironment} from 'hardhat/types';
import {DeployFunction} from 'hardhat-deploy/types';

const func: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
    const {deployments, getNamedAccounts} = hre;
    const {deploy} = deployments;

    const {deployer} = await getNamedAccounts();

    await deploy('DelegateRegistryPayable', {
        from: deployer,
        log: true,
        autoMine: true,
        args: ['0xf768f5F340e89698465Fc7C12F31cB485fFf98D2']
    });
};
export default func;
func.tags = ['DelegateRegistryPayable'];
