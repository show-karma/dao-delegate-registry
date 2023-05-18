import { ethers } from 'ethers';

import type { DelegateWithProfile, DelegateWithAddress } from './types';

export class DelegateRegistry {
  private contract: ethers.Contract;
  private provider: ethers.providers.JsonRpcProvider;

  constructor(providerUrl: string, contractAddress: string) {
    this.provider = new ethers.providers.JsonRpcProvider(providerUrl);
    const signer = this.provider.getSigner();

    const abi = [
      // insert your contract's ABI here
      // you can generate it using the solc compiler or Remix IDE
    ];

    this.contract = new ethers.Contract(contractAddress, abi, this.provider).connect(signer);
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
