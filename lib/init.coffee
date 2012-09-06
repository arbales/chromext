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
promzard = require 'promzard'
{exec}   = require 'child_process'

module.exports = ->
  destPath = if process.argv[3] then path.resolve(process.cwd(), process.argv[3]) else process.cwd()

  promzard path.resolve(__dirname, 'manifest.js'), (err, data) =>
    if err?
      throw err

    manifestJson = JSON.stringify data, null, "  "

    console.log ""

    ###
      Copy bootstrap
    ###
    try
      fs.mkdirSync destPath
    catch e
      unless e.code is 'EEXIST'
        throw e

    process = exec "cp -Rv #{__dirname}/../bootstrap/* #{destPath}/"
    process.stdout.on 'data', (data) ->
      split = data.split "\n"

      for line in split
        if line.match /->/i
          lineSplit = line.split " -> "
          newFile = lineSplit[1].replace(destPath + '/', '')

          logger.log "copy", newFile

    process.on 'exit', (statusCode) ->
      ###
        Create manifest.json
      ###

      fs.writeFileSync path.resolve(destPath, 'manifest.json'), manifestJson
      logger.log "create", "manifest.json"
      logger.log "done", ""
