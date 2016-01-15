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
#   hubot chinachu reserve <programId> - Reserve the specified program manually
#   hubot chinachu unreserve <programId> - Unreserve the reserved program manually
#   hubot chinachu search <keyword> - Search programs with the keyword (full title, detail)
#
# Notes:
#   <optional notes required for the script>
#
# Author:
#   Yuya Ochiai <yuya0321@gmail.com>

chinachu = (require '../chinachu/index').remote({
  url: process.env.HUBOT_CHINACHU_URL,
  user: process.env.HUBOT_CHINACHU_USER,
  password: process.env.HUBOT_CHINACHU_PASSWORD
});

format_program_data = (data) -> "#{data.channel.name} - #{data.title} (#{data.id})"

module.exports = (robot) ->
  robot.respond /chinachu\s+now$/i, (msg) ->
    chinachu.recording.get()
      .then (data) ->
        if data.length isnt 0
          message = 'Recording:\n'
          message += data.map(format_program_data).join('\n')
          msg.send message
        return chinachu.schedule.broadcasting.get();
      .then (data) ->
        if data.length isnt 0
          message = 'Broadcasting:\n'
          message += data.map(format_program_data).join('\n')
          msg.send message
      .catch (err) ->
        msg.send err.message

  robot.respond /chinachu\s+reserves$/i, (msg) ->
    chinachu.reserves.get()
      .then (data) ->
        if data.length isnt 0
          message = data.map(format_program_data).join('\n')
          msg.send message
        else
          msg.send "No reserves"
      .catch (err) ->
        msg.send err.message

  robot.respond /chinachu\s+reserve\s+([^\s]+)$/im, (msg) ->
    id = msg.match[1].trim()
    chinachu.program.put(id)
      .then (data) ->
        return chinachu.program.get(id)
      .then (data) ->
        msg.send "#{format_program_data(data)} has been reserved"
      .catch (err) ->
        msg.send chinachu.program.errorMessage(err)

  robot.respond /chinachu\s+unreserve\s+([^\s]+)$/im, (msg) ->
    id = msg.match[1].trim()
    chinachu.reserves.delete(id)
      .then (data) ->
        return chinachu.program.get(id)
      .then (data) ->
        msg.send "#{format_program_data(data)} has been unreserved"
      .catch (err) ->
        msg.send chinachu.program.errorMessage(err)

  robot.respond /chinachu\s+search\s+([^\s]+)$/im, (msg) ->
    keyword = msg.match[1].trim()
    chinachu.schedule.programs.get()
      .then (data) ->
        results = data.filter (program) ->
          return program.fullTitle.indexOf(keyword) != -1 || program.detail.indexOf(keyword) != -1
        if results.length is 0
          msg.send "no results"
        else
          message = results.map(format_program_data).join('\n')
          msg.send message
      .catch (err) ->
        msg.send err.message
