# DAO Delegate Registry

A global on-chain registry of Governance delegates across various DAOs.

This is a monorepo that contains the following:

### Smart Contracts
It contains the DelegateRegistry contract that is used to store Delegate information. Refer to the schema and examples to see all the data stored in the contract.

### Subgraphs
Data stored in the contracts are indexed using subgraphs. The subgraph is indexing the registry on Optimism chain and can be accessed [here](https://thegraph.com/hosted-service/subgraph/maheshmurthy/dao-delegate-registry).

### Frontend SDK
A library that can be integrated in frontend to let delegates write their info to the registry.


