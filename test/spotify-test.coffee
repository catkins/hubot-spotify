chai = require 'chai'
sinon = require 'sinon'
chai.use require 'sinon-chai'

expect = chai.expect

describe 'youtube', ->
  beforeEach ->
    @robot =
      respond: sinon.spy()
      hear: sinon.spy()

    require('../src/spotify')(@robot)

  it 'registers a respond listener', ->
    expect(@robot.respond).to.have.been.calledWith( /spotify (album|track|artist|playlist) (.*)/i)
