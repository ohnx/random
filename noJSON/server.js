//require the http and url modules
var http = require('http');
var url = require('url');
var cluster = require('cluster');

//Port
const PORT=8080; 

//extract query variable
function getqv(str, variable) {
	var vars = str.split('&');
	for (var i = 0; i < vars.length; i++) {
		var pair = vars[i].split('=');
		if (decodeURIComponent(pair[0]) == variable) {
			return decodeURIComponent(pair[1]);
		}
	}
	return null;
}

//URL regex
var r = new RegExp('^(?:[a-z]+:)?//', 'i');

//request handler function
function handleRequest(request, res){
	if(request.url==='/help') {
		res.end('Send a GET request to / with a url starting with HTTP/HTTPS and a key to get.\nThe key value of the JSON returned will be the only output.\n');
		return null;
	}
	//GET key values
	var furl = request.url.substring(2);
	var urlg = getqv(furl, 'url');
	var key = getqv(furl, 'key');
	if(urlg === null||key === null){
		res.end('Invalid request, see /help for help.\n');
		return null;
	}
	try{
		if(!r.test(urlg.toString())) {
			urlg = 'http://' + urlg.toString();
			//Don't throw an error
			/*res.statusCode = 400;
			res.end('Invalid URL\n');*/
		}
	} catch (e) {
		res.end('Error.');
		return null;
	}
	
	//Enclosed in a try-catch because errors.
	try {
		var urlp = url.parse(urlg.toString());
		var options = {host: urlp.host, path: urlp.pathname};
	} catch (e) {
		res.statusCode = 400;
		res.end('Error parsing URL\n');
	}
	//callback function
	var callback = function(response) {
		var str = '';
		//another chunk of data has been received, so append it to `str`
		response.on('data', function (chunk) {
			str += chunk;
		});
		//the whole response has been received, so we just send it to user
		response.on('end', function () {
			console.log(str);
			//try catch again for json parse
			try {
				var t = JSON.parse(str);
				res.end(t[key]);
			} catch (err) {
				console.log(err.stack);
				res.statusCode = 400;
				res.end('Bad server response\n');
			}
		});
	};
	try {
		//send http request
		http.request(options, callback).end();
	} catch(err) {
		res.statusCode = 400;
		res.end('HTTP Request failed\n');
	}
}

//Check if master
if (cluster.isMaster) {
	//Fork
	cluster.fork();
	//Restart on errors
	cluster.on('exit', function(worker, code, signal) {
		cluster.fork();
	});
}

if (cluster.isWorker) {
	//Server
	var server = http.createServer(handleRequest);
	//Listen
	server.listen(PORT, function(){});
}
