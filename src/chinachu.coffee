# Description
#   A Hubot script for Chinachu
#
# Configuration:
#   HUBOT_CHINACHU_URL
#   HUBOT_CHINACHU_USER
#   HUBOT_CHINACHU_PASSWORD
#
# Commands:
#   hubot chinachu now - Reply current broadcasting and recording programs
#
# Notes:
#   <optional notes required for the script>
#
# Author:
#   Yuya Ochiai <yuya0321@gmail.com>

async = require 'async'

module.exports = (robot) ->
  robot.respond /chinachu\s+now$/i, (msg) ->
    get_programs = (api, callback) ->
      robot.http(process.env.HUBOT_CHINACHU_URL + '/api' + api)
        .auth(process.env.HUBOT_CHINACHU_USER, process.env.HUBOT_CHINACHU_PASSWORD)
        .get() (err, res, body) ->
          if res.statusCode isnt 200
            msg.send "Request didn't come back HTTP 200 :("
            return
          data = null;
          try
            data = JSON.parse body
          catch error
            msg.send "Ran into an error parsin JSON :("
            return
          callback data

    async.series [
      (callback) ->
        get_programs '/recording.json', (data) ->
          if data.length is 0
            callback()
            return
          message = 'Recording:\n'
          data.forEach (d) ->
            message += d.channel.name + ' - ' + d.title + ' (' + d.id + ')\n'
          msg.send message
          callback()
      , (callback) ->
        get_programs '/schedule/broadcasting.json', (data) ->
          if data.length is 0
            callback()
            return
          message = 'Broadcasting:\n'
          data.forEach (d) ->
            message += d.channel.name + ' - ' + d.title + ' (' + d.id + ')\n'
          msg.send message
    ]
