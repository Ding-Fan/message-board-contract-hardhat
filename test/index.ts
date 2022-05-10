import { expect } from "chai"
import { ethers } from "hardhat"

xdescribe("Greeter", function () {
  it("Should return the new greeting once it's changed", async function () {
    const Greeter = await ethers.getContractFactory("Greeter")
    const greeter = await Greeter.deploy("Hello, world!")
    await greeter.deployed()

    expect(await greeter.greet()).to.equal("Hello, world!")

    const setGreetingTx = await greeter.setGreeting("Hola, mundo!")

    // wait until the transaction is mined
    await setGreetingTx.wait()

    expect(await greeter.greet()).to.equal("Hola, mundo!")
  })
})

describe("MessageBoard", function () {
  it("Should deploy message board contract", async function () {
    const MessageBoard = await ethers.getContractFactory("MessageBoard")
    const messageBoard = await MessageBoard.deploy()
    await messageBoard.deployed()

    await messageBoard.saveMessage("Message 1 is here")
    const messages = await messageBoard.getAllMessages()

    const result = messages[0].content

    expect(result).to.equal("Message 1 is here")

    // const setGreetingTx = await greeter.setGreeting("Hola, mundo!");

    // wait until the transaction is mined
    // await setGreetingTx.wait();

    // expect(await greeter.greet()).to.equal("Hola, mundo!");
  })
})
