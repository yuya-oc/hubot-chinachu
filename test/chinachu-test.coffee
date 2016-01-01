chai = require 'chai'
sinon = require 'sinon'
chai.use require 'sinon-chai'

expect = chai.expect

describe 'chinachu', ->
  beforeEach ->
    @robot =
      respond: sinon.spy()
      hear: sinon.spy()

    require('../src/chinachu')(@robot)

  it 'registers a respond listener, chinachu now', ->
    expect(@robot.respond).to.have.been.calledWith(/chinachu\s+now$/i)
