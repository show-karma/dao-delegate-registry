import { newMockEvent } from "matchstick-as"
import { ethereum, Address, BigInt } from "@graphprotocol/graph-ts"
import {
  DelegateAdded,
  DelegateMetadataUpdated,
  DelegateRemoved
} from "../generated/DelegateRegistry/DelegateRegistry"

export function createDelegateAddedEvent(
  delegateAddress: Address,
  tokenAddress: Address,
  tokenChainId: BigInt,
  metadata: string
): DelegateAdded {
  let delegateAddedEvent = changetype<DelegateAdded>(newMockEvent())

  delegateAddedEvent.parameters = new Array()

  delegateAddedEvent.parameters.push(
    new ethereum.EventParam(
      "delegateAddress",
      ethereum.Value.fromAddress(delegateAddress)
    )
  )
  delegateAddedEvent.parameters.push(
    new ethereum.EventParam(
      "tokenAddress",
      ethereum.Value.fromAddress(tokenAddress)
    )
  )
  delegateAddedEvent.parameters.push(
    new ethereum.EventParam(
      "tokenChainId",
      ethereum.Value.fromUnsignedBigInt(tokenChainId)
    )
  )
  delegateAddedEvent.parameters.push(
    new ethereum.EventParam("metadata", ethereum.Value.fromString(metadata))
  )

  return delegateAddedEvent
}

export function createDelegateMetadataUpdatedEvent(
  delegateAddress: Address,
  tokenAddress: Address,
  chainId: BigInt,
  metadata: string
): DelegateMetadataUpdated {
  let delegateMetadataUpdatedEvent = changetype<DelegateMetadataUpdated>(
    newMockEvent()
  )

  delegateMetadataUpdatedEvent.parameters = new Array()

  delegateMetadataUpdatedEvent.parameters.push(
    new ethereum.EventParam(
      "delegateAddress",
      ethereum.Value.fromAddress(delegateAddress)
    )
  )
  delegateMetadataUpdatedEvent.parameters.push(
    new ethereum.EventParam(
      "tokenAddress",
      ethereum.Value.fromAddress(tokenAddress)
    )
  )
  delegateMetadataUpdatedEvent.parameters.push(
    new ethereum.EventParam(
      "chainId",
      ethereum.Value.fromUnsignedBigInt(chainId)
    )
  )
  delegateMetadataUpdatedEvent.parameters.push(
    new ethereum.EventParam("metadata", ethereum.Value.fromString(metadata))
  )

  return delegateMetadataUpdatedEvent
}

export function createDelegateRemovedEvent(
  delegateAddress: Address
): DelegateRemoved {
  let delegateRemovedEvent = changetype<DelegateRemoved>(newMockEvent())

  delegateRemovedEvent.parameters = new Array()

  delegateRemovedEvent.parameters.push(
    new ethereum.EventParam(
      "delegateAddress",
      ethereum.Value.fromAddress(delegateAddress)
    )
  )

  return delegateRemovedEvent
}
