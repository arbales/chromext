###
# chromext
# chrome extension bootstrap with coffee, jade and stylus
# http://github.com/saschagehlich/chromext
#
# Copyright (c) 2012 FILSH Media GmbH <contact@filshmedia.net>
# MIT Licensed
###

fs       = require 'fs'
path     = require 'path'
watcher  = require './watcher'

module.exports = ->
  watchPath = if process.argv[3] then path.resolve(process.cwd(), process.argv[3]) else process.cwd()

  unless fs.existsSync path.resolve(watchPath, 'manifest.json')
    return logger.error 'error', watchPath + ' was not recognized as a chromext workspace'

  logger.log 'info', 'Initializing watchers...'

  coffeeWatcher = new watcher.coffee   path.resolve(watchPath, 'coffee'), path.resolve(watchPath, 'js')
  jadeWatcher   = new watcher.jade     watchPath, watchPath
  stylusWatcher = new watcher.stylus   path.resolve(watchPath, 'stylus'), path.resolve(watchPath, 'css')