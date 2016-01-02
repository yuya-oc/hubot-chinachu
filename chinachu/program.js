'use strict';

var request = require('./request');

module.exports = function(client) {
  return {
    get: function(programId) {
      return request.get(client, '/program/' + programId + '.json');
    },
    put: function(programId) {
      return request.put(client, '/program/' + programId + '.json');
    },
    errorMessage: function(err) {
      switch (err.statusCode) {
        case 404:
          return err.statusCode + ' - NOT FOUND';
        case 409:
          return err.statusCode + ' - CONFLICT (ALREADY RESERVED)';
        default:
          return err.message;
      }
    }
  };
};
