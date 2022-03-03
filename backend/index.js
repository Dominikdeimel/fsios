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
            await fs.readFile(`data/${files[0]}`, ((err, data) => {
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

app.post('/image', async (req, res) => {
    try {
        const userId = req.body.userId

        const data = req.body
        const jsonString = JSON.stringify(data)
        await fs.writeFile(`data/${userId}.json`, jsonString, () =>{
                res.status(200)
                res.send("Image from user " + userId + " saved successfully under data/" + userId )
        })
    } catch (e) {
        res.status(500)
        res.send(e)
    }
})

app.listen(port, () => {
    try {
        fs.opendirSync("data")
    } catch {
        fs.mkdirSync('data')
    }

    console.log(`Example app listening on port ${port}`)
})