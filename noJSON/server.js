//require the http and url modules
var http = require('http');
var url = require('url');

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

//request handler function
function handleRequest(request, res){
	//GET key values
	var furl = request.url.substring(2);
	var urlg = getqv(furl, 'url');
	var key = getqv(furl, 'key');

	//Enclosed in a try-catch because errors.
	try {
		var urlp = url.parse(urlg.toString());
		var options = {host: urlp.host, path: urlp.pathname};
		//callback function
		var callback = function(response) {
			var str = '';
			//another chunk of data has been received, so append it to `str`
			response.on('data', function (chunk) {
				str += chunk;
			});
			//the whole response has been received, so we just print it out here
			response.on('end', function () {
				//try catch again for json parse
				try {
					var t = JSON.parse(str);
					res.end(t[key]);
				} catch (err) {
					res.statusCode = 400;
					res.end('Invalid response from server\n');
				}
			});
		}
		//send http request
		http.request(options, callback).end();
	} catch(err) {
		res.statusCode = 400;
		res.end('Error\n');
	}
}

//Server
var server = http.createServer(handleRequest);

//Listen
server.listen(PORT, function(){
    console.log("Server listening on port %s", PORT);
});
