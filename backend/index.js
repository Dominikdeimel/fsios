const express = require('express')
const bodyParser = require('body-parser')
const fs = require("fs");

const app = express()
const port = 3000

app.use(bodyParser.json({limit: '50mb'}))

app.get('/image', (req, res) => {
    let files = fs.readdirSync('data')
    if(files.length > 0){
        fs.readFile(`data/${files[0]}`, ((err, data) => {
            let result = JSON.parse(data.toString())
            res.status(200)
            res.send(result)
        }))
    } else {
        res.status(500)
        res.send("Keine Daten vorhanden")
    }
})

app.post('/image', (req, res) => {
    const data = req.body
    const jsonString = JSON.stringify(data)
    try {
        fs.writeFileSync(`data/${data.userId}.json`, jsonString)
    } catch (e) {
        res.status(500)
        res.send(e)
    }

    res.status(200)
    res.send()
})

app.listen(port, () => {
    try {
        fs.opendirSync("data")
    } catch {
        fs.mkdirSync('data')
    }
    console.log(`Example app listening on port ${port}`)
})