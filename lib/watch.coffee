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
_        = require 'underscore'
{exec}   = require 'child_process'

module.exports = (project, next=false) ->
  # ~/Workspace/extension/build
  buildPath = path.resolve project, 'build'
  manifest = path.resolve(project, 'manifest.json')
  dirs = [
    buildPath,
    jsPath = path.resolve(buildPath, 'javascripts'),
    cssPath = path.resolve(buildPath, 'stylesheets'),
    vendorPath = path.resolve(buildPath, 'vendor')
  ]

  # Ensure the build paths exist
  fs.mkdirSync for dir in dirs

  unless fs.existsSync manifest
    return logger.error 'error', project + ' was not recognized as a chromext workspace'
  logger.log 'copy', 'Copying Manifest...'
  exec "cp -f #{manifest} #{buildPath}"

  logger.log 'info', 'Initializing compilers...'

  # Poor man's flow control
  next = _.after 4, next

  coffeeWatcher = new watcher.coffee   path.resolve(project, 'scripts'), jsPath, next
  jadeWatcher   = new watcher.jade     path.resolve(project, 'pages'), buildPath, next
  stylusWatcher = new watcher.stylus   path.resolve(project, 'stylesheets'), cssPath, next
  vendorWatcher = new watcher.vendor   path.resolve(project, 'vendor'), vendorPath, next