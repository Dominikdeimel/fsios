const { v4: uuidv4 } = require('uuid');
const express = require('express')
const bodyParser = require('body-parser')
const fs = require("fs");

const app = express()
const port = 3000

app.use(bodyParser.json({limit: '50mb'}))

app.get('/image', async (req, res) => {
    await fs.readdir('data', async ( err, files) => {
        if(err){
            res.status(500)
            res.send(err)
        }
        if(files.length > 0){
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

app.get('/game/initial', async (req, res) => {
    try {
        const userId = req.query.userId
        let dir = await fs.promises.readdir('data')
        for (const file of dir) {
            let game = await fs.promises.readFile(`data/${file}`)
            const parsedGame = JSON.parse(game.toString())
            if (parsedGame.userId_1 === "") {
                parsedGame.userId_1 = userId
                parsedGame.activeUser = userId
                parsedGame.state = 2
                fs.writeFileSync(`data/${parsedGame.gameId}.json`, JSON.stringify(parsedGame))
                res.status(200)
                res.send(parsedGame)
                break
            }
        }
        // todo abcatchen file da
    } catch (e) {
        res.status(500)
        res.send(e)
    }
})

app.post('/image', async (req, res) => {
    try {
        const userId = req.body.userId
        const word = req.body.word
        const image = req.body.imageAsBase64
        const current_gameId = req.body.gameId

        if(current_gameId === ""){
            const gameId = uuidv4()
            const gameData = {
                gameId: gameId,
                userId_0: userId,
                userId_1: "",
                activeUser: "",
                state: 0,
                rounds: 0,
                score: 0,
                word: word,
                image: image
            }
            const jsonString = JSON.stringify(gameData)
            await fs.writeFile(`data/${gameId}.json`, jsonString, () =>{
                res.status(200)
                res.send("Image " + word + " from user " + userId + " saved successfully under data/" + gameId )
            })
        } else {
            //Todo falls game schon besteht
        }
    } catch (e) {
        res.status(500)
        res.send(e)
    }
})

app.post('/id', async (req, res) => {
    const userName = req.body.name
    const userId = uuidv4()

    await fs.readFile('users.json', (async (err, usersBuffer) => {
        const users = [...JSON.parse(usersBuffer.toString()), {
            name: userName,
            id: userId
        }]
        await fs.writeFile(`users.json`, JSON.stringify(users), () =>{
            res.status(200)
            res.send(userId)
        })
    }))
})

app.listen(port, async () => {
    try {
        let dir = fs.opendirSync("data")
        dir.closeSync()
    } catch {
        fs.mkdirSync('data')
    }

    try{
        fs.readFileSync('users.json')
    } catch {
        const users = []
        const json = JSON.stringify(users)
        await fs.writeFile(`users.json`, json, () =>{
            console.log("users.json created")
        })
    }

    console.log(`Example app listening on port ${port}`)
})
