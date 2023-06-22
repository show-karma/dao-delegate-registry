import { ethers } from 'ethers';
import delegateRegistry from '../../smart-contracts/deployments/optimism/DelegateRegistry.json';

import type { DelegateWithProfile, DelegateWithAddress } from './types';

export class DelegateRegistry {
  private contract: ethers.Contract;
  private provider: ethers.JsonRpcProvider;
  private signer: ethers.Signer;

  constructor(signer: ethers.Signer, contractAddress: string, jsonRPCUrl: string) {
    this.provider = new ethers.JsonRpcProvider(jsonRPCUrl);
    this.signer = signer;

    const readContract = new ethers.Contract(contractAddress, delegateRegistry.abi, this.provider);
    this.contract = readContract.connect(this.signer) as ethers.Contract;
  }

  public async registerDelegate(delegate: DelegateWithProfile): Promise<void> {
    await this.contract.registerDelegate(
      delegate.tokenAddress,
      delegate.tokenChainId,
      JSON.stringify(delegate.profile)
    );
  }

  public async deregisterDelegate(tokenAddress: string, tokenChainId: number): Promise<void> {
    await this.contract.deregisterDelegate(tokenAddress, tokenChainId);
  }

  public async getDelegate(
    delegateAddress: string,
    tokenAddress: string,
    tokenChainId: number
  ): Promise<DelegateWithAddress> {
    const delegate = await this.contract.getDelegate(delegateAddress, tokenAddress, tokenChainId);
    return {
      delegateAddress: delegate.delegateAddress,
      tokenAddress: delegate.tokenAddress,
      tokenChainId: delegate.tokenChainId,
    };
  }
}
