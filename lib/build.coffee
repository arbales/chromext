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
{exec}   = require 'child_process'

_        = require 'underscore'
_.str    = require 'underscore.string'

module.exports = ->
  buildPath = if process.argv[3] then path.resolve(process.cwd(), process.argv[3]) else process.cwd()

  unless fs.existsSync path.resolve(buildPath, 'manifest.json')
    return logger.error 'error', buildPath + ' was not recognized as a chromext workspace'

  manifest = require path.resolve(buildPath, 'manifest.json')
  destFile = _.str.slugify(manifest.name) + '-' + manifest.version + '.zip'

  logger.log 'zip', 'Packing archive ' + destFile

  cwd = process.cwd()

  process.chdir buildPath
  proc = exec 'zip -0 -r ' + destFile + ' manifest.json js css assets *.html'
  process.chdir cwd

  stderr = ""
  proc.stderr.on 'data', (data) ->
    stderr += data

  proc.on 'exit', (code) ->
    if code is 0
      logger.log 'zip', '.zip has successfully been created: ' + path.resolve(buildPath, destFile)
    else
      logger.error 'zip', destFile + ' could not be created!'
      
      console.log ""
      console.log stderr