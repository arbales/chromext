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
mkdirp = require 'mkdirp'

module.exports = ->
  # ~/Workspace/extension
  project = if process.argv[3] then path.resolve(process.cwd(), process.argv[3]) else process.cwd()

  # ~/Workspace/extension/build
  buildPath = path.resolve project, 'build'

  # ~/Workspace/extension/dist
  distPath = path.resolve project, 'dist'

  # Ensure the build paths exist
  mkdirp.sync buildPath
  mkdirp.sync distPath

  unless fs.existsSync path.resolve(buildPath, 'manifest.json')
    return logger.error 'error', buildPath + ' was not recognized as a chromext project'

  # Load the Manifest
  manifest = require path.resolve(buildPath, 'manifest.json')

  # Create the package name.
  archiveName = _.str.slugify(manifest.name) + '-' + manifest.version + '.zip'

  logger.log 'zip', 'Packing archive ' + archiveName

  cwd = process.cwd()

  # Compress the build directory to a zip file in dist
  proc = exec "zip -r dist/#{archiveName} build/*"
  process.chdir cwd

  stderr = ""
  proc.stderr.on 'data', (data) ->
    stderr += data

  proc.on 'exit', (code) ->
    if code is 0
      logger.log 'zip', '.zip has successfully been created: ' + path.resolve(distPath, archiveName)
    else
      logger.error 'zip', archiveName + ' could not be created!'
      
      console.log ""
      console.log stderr