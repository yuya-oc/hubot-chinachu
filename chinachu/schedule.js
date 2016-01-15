'use strict';

var request = require('./request');

module.exports = function(client) {
  return {
    get: function() {
      return request.get(client, '/schedule.json');
    },
    programs: {
      get: function() {
        return request.get(client, '/schedule/programs.json');
      }
    },
    broadcasting: {
      get: function() {
        return request.get(client, '/schedule/broadcasting.json');
      }
    }
  };
}
