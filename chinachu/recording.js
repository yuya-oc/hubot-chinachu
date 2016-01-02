'use strict';

var request = require('./request');

module.exports = function(client) {
  return {
    get: function() {
      return request.get(client, '/recording.json');
    }
  };
}
