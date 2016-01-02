'use strict';

var rp = require('request-promise');
var url = require('url');

function request_options(client, method, api) {
  return {
    method: method,
    uri: url.resolve(client.baseUrl, '.' + api),
    headers: {
      'User-Agent': client.userAgent ? client.userAgent : 'node-chinachu'
    }
  };
}

module.exports = {
  get: function(client, api) {
    var options = request_options(client, 'GET', api);
    if (api.endsWith('json')) {
      options.json = true;
    }
    return rp(options);
  },
  put: function(client, api) {
    var options = request_options(client, 'PUT', api);
    if (api.endsWith('json')) {
      options.json = true;
    }
    return rp(options);
  },
  delete: function(client, api) {
    var options = request_options(client, 'DELETE', api);
    if (api.endsWith('json')) {
      options.json = true;
    }
    return rp(options);
  }
};
