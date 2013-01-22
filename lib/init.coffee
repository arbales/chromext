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
prompt   = require 'prompt'
{exec}   = require 'child_process'
_        = require 'underscore'

module.exports = (destination) ->
  destPath = if destination then path.resolve(process.cwd(), destination) else process.cwd()
  pathSplit = destPath.split(path.sep)
  guessedName = pathSplit[pathSplit.length - 1]

  schema =
    properties:
      name:
        pattern: /^[a-zA-Z\s\-]+$/
        description: "Extension Name"
        message: 'Name must be only letters, spaces, or dashes'
        required: true
        default: guessedName
      description:
        description: "Description"
        type: "string"
      version:
        description: "Version"
        type: "string"
        default: "0.1"
  prompt.message = ""
  prompt.start()
  prompt.get schema, (err, result) ->
    if err?
      throw err

    _.extend result,
      background:
        page: "background.html"
      manifest_version: 2

    manifest = JSON.stringify result, null, "  "

    console.log ""

    # Copy bootstrap
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
      # Create manifest.json

      fs.writeFileSync path.resolve(destPath, 'manifest.json'), manifest
      logger.log "create", "manifest.json"
      logger.log "done", ""
