# Description:
#   Allows Hubot to know many languages.
#
# Dependencies:
#   "jsdom": "0.2.15"
#
# Commands:
#   hubot translate me <phrase> - Searches for a translation for the <phrase> and then prints that bad boy out.
#   hubot translate me from <source> into <target> <phrase> - Translates <phrase> from <source> into <target>. Both <source> and <target> are optional

jsdom = require('jsdom')

module.exports = (robot) ->
  robot.respond /alc (.*)/i, (msg) ->
    term  = "#{msg.match[1]}".toLowerCase()

    msg.http("http://eow.alc.co.jp/search").query({q: term}).header('User-Agent', 'Mozilla/5.0')
      .get() (http_err, res, body) ->
        unless http_err

          jsdom.env(
            html: body
            scripts: ['http://code.jquery.com/jquery-1.7.2.min.js']
            done: (jsdom_err, window) ->
              unless jsdom_err
                $ = window.$
                $('#resultsList > ul > li').each ->
                  if $('span.midashi', $(this)).text().toLowerCase() == term
                    msg.send $('div', this).text()
          )
