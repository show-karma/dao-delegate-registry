import {
  DelegateAdded as DelegateAddedEvent,
  DelegateRemoved as DelegateRemovedEvent,
} from "../generated/DelegateRegistry/DelegateRegistry";
import { Delegate } from "../generated/schema";
import { ipfs, store, log, json } from "@graphprotocol/graph-ts";
import { JSON } from "assemblyscript-json";

export function getDelegateKey(
  delegateAddress: string,
  tokenAddress: string,
  tokenChainId: string
): string {
  return delegateAddress + tokenAddress + tokenChainId;
}
export function handleDelegateAdded(event: DelegateAddedEvent): void {
  let entity = new Delegate(
    getDelegateKey(
      event.params.delegateAddress.toHexString(),
      event.params.tokenAddress.toHexString(),
      event.params.tokenChainId.toString()
    )
  );
  entity.delegateAddress = event.params.delegateAddress;
  entity.tokenAddress = event.params.tokenAddress;
  entity.tokenChainId = event.params.tokenChainId;

  let jsonObj: JSON.Obj = <JSON.Obj>JSON.parse(event.params.metadata);

  let ipfsMetadataCid: JSON.Str | null = jsonObj.getString("ipfsMetadata");

  if (ipfsMetadataCid != null) {
    entity.ipfsMetadata = ipfsMetadataCid.valueOf();
    parseIpfsMetadata(entity, ipfsMetadataCid.valueOf());
  } else {
    let statusOrNull: JSON.Str | null = jsonObj.getString("status");

    if (statusOrNull != null) {
      entity.status = statusOrNull.valueOf();
    }

    let nameOrNull: JSON.Str | null = jsonObj.getString("name");

    if (nameOrNull != null) {
      entity.name = nameOrNull.valueOf();
    }

    let statementOrNull: JSON.Str | null = jsonObj.getString("statement");

    if (statementOrNull != null) {
      entity.statement = statementOrNull.valueOf();
    }

    let profilePictureUrlOrNull: JSON.Str | null = jsonObj.getString(
      "profilePictureUrl"
    );

    if (profilePictureUrlOrNull != null) {
      entity.profilePictureUrl = profilePictureUrlOrNull.valueOf();
    }

    let acceptedCoCOrNull: JSON.Str | null = jsonObj.getString("acceptedCoC");

    if (acceptedCoCOrNull != null) {
      entity.acceptedCoC = acceptedCoCOrNull.valueOf();
    }

    let interestsOrNull: JSON.Str | null = jsonObj.getString("interests");

    if (interestsOrNull != null) {
      entity.interests = interestsOrNull.valueOf();
    }
  }

  entity.blockNumber = event.block.number;
  entity.blockTimestamp = event.block.timestamp;
  entity.transactionHash = event.transaction.hash;

  entity.save();
}

export function parseIpfsMetadata(
  entity: Delegate,
  ipfsMetadataCid: string
): void {
  let data = ipfs.cat(ipfsMetadataCid);

  if (data) {
    const ipfsMetadata = json.fromBytes(data).toObject();
    if (ipfsMetadata) {
      let statusOrNull = ipfsMetadata.get("status");
      if (statusOrNull != null) {
        entity.status = statusOrNull.toString();
      }

      let nameOrNull = ipfsMetadata.get("name");
      if (nameOrNull != null) {
        entity.name = nameOrNull.toString();
      }

      let statementOrNull = ipfsMetadata.get("statement");
      if (statementOrNull != null) {
        entity.statement = statementOrNull.toString();
      }

      let profilePictureUrlOrNull = ipfsMetadata.get("profilePictureUrl");
      if (profilePictureUrlOrNull != null) {
        entity.profilePictureUrl = profilePictureUrlOrNull.toString();
      }

      let acceptedCoC = ipfsMetadata.get("acceptedCoC");
      if (acceptedCoC != null) {
        entity.acceptedCoC = acceptedCoC.toString();
      }
    }
  }
}

export function handleDelegateRemoved(event: DelegateRemovedEvent): void {
  let id = getDelegateKey(
    event.params.delegateAddress.toHexString(),
    event.params.tokenAddress.toHexString(),
    event.params.tokenChainId.toString()
  );
  store.remove("Delegate", id);
}
