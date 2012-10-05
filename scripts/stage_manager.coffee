# Description:
#   the stage manager
#
# Commands:
#   hubot staging - Answers who's locking the staging server
#   hubot staging lock - Locks the staging server right now
#   hubot staging unlock - Unlocks the staging server if locked by the user
#   hubot staging force unlock - Unlocks the staging server no matter who's locking

class Stage
  constructor: (@robot) ->
    @cache = {}

    @robot.brain.on 'loaded', =>
      if @robot.brain.data.staging
        @cache = @robot.brain.data.staging

  status: ->
    @cache

  statusMessage: ->
    "stg is locked by #{@cache['locked_by'].name} at #{@cache['locked_at']}."

  lock: (user) ->
    unless @cache['locked_by']
      @cache['locked_by'] = user
      @cache['locked_at'] = new Date()
      @robot.brain.data.staging = @cache
    else
      null

  unlock: (user) ->
    if @cache['locked_by'] == user
      @cache = {}
      @robot.brain.data.staging = @cache
    else
      null

  forceUnlock: ->
    @cache = {}
    @robot.brain.data.staging = @cache

module.exports = (robot) ->
  stg = new Stage robot

  robot.respond /stg$/i, (msg) ->
    msg.send stg.statusMessage()

  robot.respond /stg lock$/i, (msg) ->
    if !!(status = stg.lock(msg.message.user))
      msg.send ":lock: locked stg!"
    else
      msg.send "failed to lock stg..."
      msg.send stg.statusMessage()

  robot.respond /stg unlock$/i, (msg) ->
    if !!(status = stg.unlock(msg.message.user))
      msg.send ":unlock: unlocked stg!"
    else
      msg.send "failed to unlock stg..."
      msg.send stg.statusMessage()

  robot.respond /stg force unlock$/i, (msg) ->
    stg.forceUnlock()
    msg.send ":unlock: unlocked stg!"
