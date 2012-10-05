# Description:
#   Github commit link looks for commit:SHA1 and links to that commit for your default
#   repo. Eg. "Hey guys check out commit: cafebabe1326"
#
# Dependencies:
#   "githubot": "0.2.0"
#
# Configuration:
#   HUBOT_GITHUB_REPO
#   HUBOT_GITHUB_TOKEN
#
# Commands:
#   Listens for commit:SHA1 and links to the commit for your default repo on github
#
# Author:
#   tenfef

module.exports = (robot) ->
  github = require("githubot")(robot)
  robot.hear /.*(commit: *([^ ]+))/, (msg) ->
    commit_digest = msg.match[1].replace /commit: */, ""
    if !commit_digest
      return

    bot_github_repo = github.qualified_repo process.env.HUBOT_GITHUB_REPO
    commit_summary = ""
    github.get "https://api.github.com/repos/#{bot_github_repo}/commits/" + commit_digest, (commit_obj) ->
      commit_summary = commit_obj.message
      committer = commit_obj.author.name
      commit_url = "https://github.com/#{bot_github_repo}/commit/#{commit_digest}"
      msg.send "Commit: #{commit_digest} : #{commit_summary} (#{committer}) #{commit_url}"
