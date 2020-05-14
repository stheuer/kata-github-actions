import { Router } from "express"

import { EchoService, createEchoService } from "./EchoService"

export const createEchoRouter = (): Router => {

    const router = Router()

    const service: EchoService = createEchoService()

    router.post("/echo", async (request, response) => {

        const message = request.body["message"]

        const result = await service.echo(message)

        response.send(result)
    })

    router.post("/reverse", async (request, response) => {

        const message = request.body["message"]

        const result = await service.reverse(message)

        response.send(result)
    })

    return router
}
