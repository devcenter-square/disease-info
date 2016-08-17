 // get the things we need
 var express = require('express');
 var app = express();
 var path = require('path');

 app.set('port', (process.env.PORT || 8080));

 // set the public folder to serve public assets
 app.use(express.static(__dirname + '/client'));

 // set up our one route to the index.html file
 app.get('*', function(req, res) {
 res.sendFile(path.join(__dirname + '/client/views/index.html'));
 });

 app.listen(app.get('port'), function() {
  console.log('Node app is running on port', app.get('port'));
});