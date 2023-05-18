# Delegate Metadata SDK

This SDK makes it easier to call a (Delegate Metadata Registry contract)[https://github.com/show-karma/dao-delegate-registry]. A Delegate Metadata Registry puts a DAO delegate's profile on-chain, so that frontends like (Tally)[tally.xyz], (Karma)[karmahq.xyz], and (Uniswap Agora)[vote.uniswapfoundation.org] can index it.

## Work in progress

Note that both the contract and the SDK are still in-progress. We don't recommend that you use them yet.

## Usage

To use this SDK, you can create an instance of the DelegateRegistry class by passing in the contract address and a signer or provider object from the ethers library. For example:

```
const contractAddress = "0x123...";
const provider = ethers.getDefaultProvider();
const delegateRegistry = new DelegateRegistry(contractAddress, provider);
```

Then, you can call the methods on the `delegateRegistry` object to interact with the smart contract. For example:

```
const delegate = await delegateRegistry.getDelegate("0x456...", "0x789...", 1);
console.log(delegate);

await delegateRegistry.registerDelegate("0x789...", 1, "Some metadata");

await delegateRegistry.deregisterDelegate();

await delegateRegistry.updateDelegateMetadata("0x789...", 1, "Updated metadata");

```
