import { Server, createServer } from "./Server"

const run = async () => {

    const port = parseInt(process.env["PORT"] ?? "8080")

    const server: Server = createServer(port)

    process.on("SIGINT", async () => {

        await server.stop()

        process.exit()
    })

    await server.start()
}

run().catch(error => {

    console.error(error)

    process.exit()
})
