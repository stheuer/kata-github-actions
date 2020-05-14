import { assert, asyncProperty, string, fullUnicodeString } from "fast-check"
import { EchoService, createEchoService } from "./EchoService"

const service: EchoService = createEchoService()

describe("echo()", () => {

    test("output equals input", () => assert(asyncProperty(fullUnicodeString(), async message => {

        const result = await service.echo(message)

        const outputEqualsInput = result === message

        return outputEqualsInput
    })))
})

describe("reverse()", () => {

    test("reversing twice returns identity", () => assert(asyncProperty(fullUnicodeString(), async message => {

        const reverse = await service.reverse(message)

        const identity = await service.reverse(reverse)

        const twiceReversedEqualsInput = identity === message

        return twiceReversedEqualsInput
    })))
})
