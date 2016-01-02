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
#   hubot chinachu reserves - Reply reserved programs
#   hubot chinachu reserve <programId> - Reserve the specified program
#
# Notes:
#   <optional notes required for the script>
#
# Author:
#   Yuya Ochiai <yuya0321@gmail.com>

async = require 'async'

format_program_data = (data) -> "#{data.channel.name} - #{data.title} (#{data.id})"

module.exports = (robot) ->
  robot.respond /chinachu\s+now$/i, (msg) ->
    get_programs = (api, callback) ->
      robot.http("#{process.env.HUBOT_CHINACHU_URL}/api/#{api}")
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
        get_programs 'recording.json', (data) ->
          if data.length is 0
            callback()
            return
          message = 'Recording:\n'
          message += data.map(format_program_data).join('\n')
          msg.send message
          callback()
      , (callback) ->
        get_programs 'schedule/broadcasting.json', (data) ->
          if data.length is 0
            callback()
            return
          message = 'Broadcasting:\n'
          message += data.map(format_program_data).join('\n')
          msg.send message
    ]

  robot.respond /chinachu\s+reserves$/i, (msg) ->
    get_programs = (api, callback) ->
      robot.http("#{process.env.HUBOT_CHINACHU_URL}/api/#{api}")
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

    get_programs 'reserves.json', (data) ->
      if data.length is 0
        return
      message = data.map(format_program_data).join('\n')
      msg.send message

  robot.respond /chinachu\s+reserve\s+([^\s]+)$/im, (msg) ->
    id = msg.match[1].trim()
    robot.http("#{process.env.HUBOT_CHINACHU_URL}/api/program/#{id}.json")
      .auth(process.env.HUBOT_CHINACHU_USER, process.env.HUBOT_CHINACHU_PASSWORD)
      .put() (err, res, body) ->
        switch res.statusCode
          when 200
            robot.http("#{process.env.HUBOT_CHINACHU_URL}/api/program/#{id}.json")
              .auth(process.env.HUBOT_CHINACHU_USER, process.env.HUBOT_CHINACHU_PASSWORD)
              .get() (err, res, body) ->
                if res.statusCode isnt 200
                  msg.send "Request didn't come back HTTP 200 :("
                  return
                data = JSON.parse(body)
                msg.send "#{format_program_data(data)} has been reserved"
            break
          when 404
            msg.send "#{id} was not found"
            break
          when 409
            msg.send "#{id} is already reserved"
            break
