###
# chromext
# chrome extension bootstrap with coffee, jade and stylus
# http://github.com/saschagehlich/chromext
#
# Copyright (c) 2012 FILSH Media GmbH <contact@filshmedia.net>
# MIT Licensed
###

module.exports =
  log: (prefix, message) ->
    console.log "   \u001b[1;35m#{prefix} \u001b[m#{message}"

  error: (prefix, message) ->
    console.log "   \u001b[1;31m#{prefix} \u001b[m#{message}"