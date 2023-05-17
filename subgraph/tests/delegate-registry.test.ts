import {
  assert,
  describe,
  test,
  clearStore,
  beforeAll,
  afterAll
} from "matchstick-as/assembly/index"
import { Address, BigInt } from "@graphprotocol/graph-ts"
import { DelegateAdded } from "../generated/schema"
import { DelegateAdded as DelegateAddedEvent } from "../generated/DelegateRegistry/DelegateRegistry"
import { handleDelegateAdded } from "../src/delegate-registry"
import { createDelegateAddedEvent } from "./delegate-registry-utils"

// Tests structure (matchstick-as >=0.5.0)
// https://thegraph.com/docs/en/developer/matchstick/#tests-structure-0-5-0

describe("Describe entity assertions", () => {
  beforeAll(() => {
    let delegateAddress = Address.fromString(
      "0x0000000000000000000000000000000000000001"
    )
    let tokenAddress = Address.fromString(
      "0x0000000000000000000000000000000000000001"
    )
    let tokenChainId = BigInt.fromI32(234)
    let metadata = "Example string value"
    let newDelegateAddedEvent = createDelegateAddedEvent(
      delegateAddress,
      tokenAddress,
      tokenChainId,
      metadata
    )
    handleDelegateAdded(newDelegateAddedEvent)
  })

  afterAll(() => {
    clearStore()
  })

  // For more test scenarios, see:
  // https://thegraph.com/docs/en/developer/matchstick/#write-a-unit-test

  test("DelegateAdded created and stored", () => {
    assert.entityCount("DelegateAdded", 1)

    // 0xa16081f360e3847006db660bae1c6d1b2e17ec2a is the default address used in newMockEvent() function
    assert.fieldEquals(
      "DelegateAdded",
      "0xa16081f360e3847006db660bae1c6d1b2e17ec2a-1",
      "delegateAddress",
      "0x0000000000000000000000000000000000000001"
    )
    assert.fieldEquals(
      "DelegateAdded",
      "0xa16081f360e3847006db660bae1c6d1b2e17ec2a-1",
      "tokenAddress",
      "0x0000000000000000000000000000000000000001"
    )
    assert.fieldEquals(
      "DelegateAdded",
      "0xa16081f360e3847006db660bae1c6d1b2e17ec2a-1",
      "tokenChainId",
      "234"
    )
    assert.fieldEquals(
      "DelegateAdded",
      "0xa16081f360e3847006db660bae1c6d1b2e17ec2a-1",
      "metadata",
      "Example string value"
    )

    // More assert options:
    // https://thegraph.com/docs/en/developer/matchstick/#asserts
  })
})
