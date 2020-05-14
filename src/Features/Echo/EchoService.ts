
export type EchoService = {
    /** Return input message */
    echo: (message: string) => Promise<string>
    reverse: (message: string) => Promise<string>
}

export const createEchoService = (): EchoService => {

    const service: EchoService = {

        echo: async message => {
            return message
        },

        reverse: async message => {
            return message.split("").reverse().join("")
        },
    }

    return service
}
