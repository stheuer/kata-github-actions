import { Server as HttpServer } from "http"
import express, { Router } from "express"
import logger from "morgan"
import { json } from "body-parser"

import { createEchoRouter } from "./Features/Echo/EchoRouter"

export type Server = {
    /** Starts the server instance */
    start: () => Promise<void>
    /** Stops the server instance */
    stop: () => Promise<void>
}

export const createServer = (port: number): Server => {

    const app = express()

    app.use(logger("combined"))
    app.use(json())

    const echoRouter: Router = createEchoRouter()

    app.use(echoRouter)

    let instance: HttpServer | undefined

    const server: Server = {

        start: () => {

            return new Promise((resolve, reject) => {

                instance = app.listen(port, () => {
                    console.log(`Server started on port '${port}'`)
                    resolve()
                })

                instance.on("error", error => {
                    reject(error)
                })
            })
        },

        stop: () => {

            if (typeof instance === "undefined") {
                return Promise.reject("Server not started")
            }

            let currentInstance = instance

            return new Promise((resolve, reject) => {

                currentInstance.close(error => {

                    if (error) {
                        return reject(error)
                    }

                    console.log("Server stopped")
                    resolve()
                })
            })
        }
    }

    return server
}
