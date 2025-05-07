const express = require('express')
const app = express()
const port = 3000

const bodyParser = require('body-parser')

// parse application/x-www-form-urlencoded
app.use(bodyParser.urlencoded({extended:false}))
// parse Application/json
app.use(bodyParser.json())

app.get('/',(req,res) => {
    res.send("Hello World!")
})

app.get('/app/sum/:a/:b',(req,res)=>{
    const{a,b} = req.params
    let sum = parseInt(a)+parseInt(b)
    res.send(sum+"")


    // let ans = parseInt(req.params.a)+parseInt(req.params.b)
    // res.send({"addition ":ans})
})



app.get('/app/sub/:a/:b',(req,res)=>{
    // const{a,b} = req.params
    // let sub = parseInt(a)-parseInt(b)
    // res.send(sub+"")

    let ans = parseInt(req.params.a)-parseInt(req.params.b)
    res.send({"Subtraction ":ans})

})

app.get("/app/multiplication",(req,res)=> {
    console.log(JSON.stringify(req.body,null,3))
    const{a,b} = req.body
    let mult = parseInt(a)*parseInt(b)
    res.send({'Multiplication ':mult})
    // res.send("Server Received Request")
})

app.get('/app/calc/:a/:b',(req,res)=>{
    const{a,b} = req.params
    let add = parseInt(a)+parseInt(b)
    let sub = parseInt(a)-parseInt(b)
    let mult = parseInt(a)*parseInt(b)
    let div = parseInt(a)/parseInt(b)

    res.send({'Addition ':add, 'Subtraction ':sub, 'Multiplication ':mult, 'Division ':div})
})

app.listen(port, () => {
    console.log(`Example App Listening on Port ${port}`)
})