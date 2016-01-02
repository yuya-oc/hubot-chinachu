'use strict';

var request = require('./request');

module.exports = function(client) {
  return {
    get: function(programId) {
      if (programId) {
        return request.get(client, '/reserves/' + programId + '.json');
      } else {
        return request.get(client, '/reserves.json');
      }
    },
    delete: function(programId) {
      return request.delete(client, '/reserves/' + programId + '.json');
    }
  };
}
