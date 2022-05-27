const {v4: uuidv4} = require('uuid');
const express = require('express')
const bodyParser = require('body-parser')
const fs = require("fs");
const apn = require('apn');

const app_bundle_id = "com.th-koeln.deimel.Drawing-io"
const options = {
    token: {
        key: "AuthKey_B7C3P4D8PS.p8",
        keyId: "B7C3P4D8PS",
        teamId: "E5ZZ8MJF58"
    },
    production: false
}
const apnProvider = new apn.Provider(options)

const app = express()
const port = 3000

app.use(bodyParser.json({limit: '50mb'}))

app.get('/image', async (req, res) => {
    await fs.readdir('data', async (err, files) => {
        if (err) {
            res.status(500)
            res.send(err)
        }
        if (files.length > 0) {
            const random = Math.floor(Math.random() * files.length)
            await fs.readFile(`data/${files[random]}`, ((err, data) => {
                let result = JSON.parse(data.toString())
                res.status(200)
                res.send(result)
            }))
        } else {
            res.status(500)
            res.send("No images found!")
        }
    })
})

app.get('/word', async (req, res) => {
    await fs.readFile('words.json', ((err, wordList) => {
        const result = JSON.parse(wordList.toString())
        res.status(200)
        res.send(result[Math.floor(Math.random() * result.length)].toString())
    }))
})

app.get('/game/guessing', async (req, res) => {
    try {
        const userId = req.query.userId
        const gameId = req.query.gameId

        if(gameId === ""){
            let dir = await fs.promises.readdir('data')
            for (const file of dir) {
                let game = await fs.promises.readFile(`data/${file}`)
                const parsedGame = JSON.parse(game.toString())
                if (parsedGame.userId_1 === "" && parsedGame.userId_0 !== userId) {
                    parsedGame.userId_1 = userId
                    parsedGame.userName_1 = await getUserNameForId(userId)
                    parsedGame.activeUser = userId
                    parsedGame.state = 2
                    fs.writeFileSync(`data/${parsedGame.gameId}.json`, JSON.stringify(parsedGame))
                    res.status(200)
                    res.send(parsedGame)
                    break
                }
            }
        } else {
            let game = await fs.promises.readFile(`data/${gameId}.json`)
            const parsedGame = JSON.parse(game.toString())

            res.status(200)
            res.send(parsedGame)
        }
    } catch (e) {
        res.status(500)
        res.send(e)
    }
})

app.get("/game/all", async (req, res) => {
    try {
        const userId = req.query.userId
        const response = []

        let dir = await fs.promises.readdir('data')
        for (const file of dir) {
            let game = await fs.promises.readFile(`data/${file}`)
            const parsedGame = JSON.parse(game.toString())
            if (parsedGame.userId_0 === userId || parsedGame.userId_1 === userId) {
                response.push(parsedGame)
            }
        }
        res.status(200)
        res.send(response)
    } catch (e) {
        res.status(500)
        res.send(e)
    }
})

app.post('/game/drawing', async (req, res) => {
    try {
        const word = req.body.word
        const image = req.body.imageAsBase64
        const gameId = req.body.gameId

        const game = await fs.promises.readFile(`data/${gameId}.json`)
        const parsedGame = JSON.parse(game.toString())

        parsedGame.image = image
        parsedGame.word = word
        parsedGame.state = 2
        parsedGame.activeUser = (parsedGame.activeUser === parsedGame.userId_0) ? parsedGame.userId_1 : parsedGame.userId_0

        const opponent = (parsedGame.activeUser === parsedGame.userId_0) ? parsedGame.userName_1 : parsedGame.userName_0
        await sendPushNotification("Du bist dran",`Spiel gegen ${opponent}`, parsedGame.activeUser)

        const jsonString = JSON.stringify(parsedGame)
        await fs.promises.writeFile(`data/${gameId}.json`, jsonString)

        res.status(200)
        res.send()
    } catch (e) {
        res.status(500)
        console.log(e)
        res.send(e)
    }
})

app.post('/game/initial/drawing', async (req, res) => {
    try {
        const userId = req.body.userId
        const word = req.body.word
        const image = req.body.imageAsBase64
        const current_gameId = req.body.gameId

        if (current_gameId === "") {
            const gameId = uuidv4()
            const gameData = {
                gameId: gameId,
                userId_0: userId,
                userName_0: await getUserNameForId(userId),
                userId_1: "",
                userName_1: "",
                activeUser: "",
                state: 0,
                rounds: 0,
                score: 0,
                word: word,
                image: image
            }
            const jsonString = JSON.stringify(gameData)
            await fs.writeFile(`data/${gameId}.json`, jsonString, () => {
                res.status(200)
                res.send("Image " + word + " from user " + userId + " saved successfully under data/" + gameId)
            })
        }
    } catch (e) {
        res.status(500)
        console.log(e)
        res.send(e)
    }
})

async function getUserNameForId(userId) {
    try {
       const usersBuffer = await fs.promises.readFile('users.json')
        const users = [...JSON.parse(usersBuffer.toString())]
        const user = users.find(u => u.id === userId)

        return user.name
    } catch (e) {
        console.log(e)
        return ""
    }
}

async function sendPushNotification(alert, title, userId){
    const note = new apn.Notification();
    const deviceToken = await getDeviceTokenForId(userId)

    note.expiry = Math.floor(Date.now() / 1000) + 3600; // Expires 1 hour from now.
    note.badge = 3;
    note.sound = "ping.aiff";
    note.alert = alert
    note.title = title
    note.payload = {"sender": "node-apn"};
    note.topic = app_bundle_id;

    if(deviceToken !== "") {
        await apnProvider.send(note, deviceToken)
    }
}

async function getDeviceTokenForId(userId) {
    try {
        const usersBuffer = await fs.promises.readFile('users.json')
        const users = [...JSON.parse(usersBuffer.toString())]
        const user = users.find(u => u.id === userId)

        return user.deviceToken ?? ""
    } catch (e) {
        console.log(e)
        return ""
    }
}

app.post('/id', async (req, res) => {
    const userName = req.body.name
    const deviceToken = req.body.deviceToken
    const userId = uuidv4()

    await fs.readFile('users.json', (async (err, usersBuffer) => {
        const users = [...JSON.parse(usersBuffer.toString()), {
            name: userName,
            id: userId,
            deviceToken: deviceToken
        }]
        await fs.writeFile(`users.json`, JSON.stringify(users), () => {
            res.status(200)
            res.send(userId)
        })
    }))
})

app.post('/game/finishround', async (req, res) => {
    try {
        const roundScore = req.body.roundScore
        const gameId = req.body.gameId
        let game = await fs.promises.readFile(`data/${gameId}.json`)
        const parsedGame = JSON.parse(game.toString())
        parsedGame.state = 1
        parsedGame.rounds += 1
        parsedGame.score += roundScore
        parsedGame.word = ""
        parsedGame.image = ""
        fs.writeFileSync(`data/${gameId}.json`, JSON.stringify(parsedGame))
        res.status(200)
        res.send(parsedGame.score.toString())
    } catch (e) {
        res.status(500)
        res.send(`Runde beenden hat nicht geklappt (${e})`)
    }
})

app.listen(port, async () => {
    try {
        let dir = fs.opendirSync("data")
        dir.closeSync()
    } catch {
        fs.mkdirSync('data')
    }

    try {
        fs.readFileSync('users.json')
    } catch {
        const users = []
        const json = JSON.stringify(users)
        await fs.writeFile(`users.json`, json, () => {
            console.log("users.json created")
        })
    }

    console.log(`Example app listening on port ${port}`)
})
