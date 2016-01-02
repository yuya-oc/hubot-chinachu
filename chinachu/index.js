'use strict'

var url = require('url');

function ChinachuClient(options) {
  var urlObj = url.parse(options.url);
  urlObj.auth = options.user + ':' + options.password;
  if (urlObj.path[urlObj.path.length - 1] !== '/') {
    urlObj.path += '/';
  }
  this.baseUrl = url.resolve(url.format(urlObj), urlObj.path + 'api/');
  this.userAgent = options.userAgent;

  //  this.scheduler = require('./scheduler')(this);
  //  this.rules = require('./rules')(this);
  this.program = require('./program')(this);
  this.schedule = require('./schedule')(this);
  this.reserves = require('./reserves')(this);
  this.recording = require('./recording')(this);
//  this.recorded = require('./recorded')(this);
}

function remote(options) {
  return new ChinachuClient(options);
}

module.exports = {
  remote: remote
};
