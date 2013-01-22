###
# chromext
# chrome extension bootstrap with coffee, jade and stylus
# http://github.com/saschagehlich/chromext
#
# Copyright (c) 2012 FILSH Media GmbH <contact@filshmedia.net>
# MIT Licensed
###

chromext = require './chromext'
options = process.argv.splice(2)


logger = global.logger = require './lib/logger'

banner = "Chromext helps you build Chrome Extensions."
commands =
  create: 'Create a new Chrome Extension'
  build: ' Build a Chrome Extension'
  watch: ' Watch and rebuild an extension when its contents change'

usage = ->
  console.log banner + "\n"
  for command, desc of commands
    console.log "#{command}: #{desc}"

switch options[0]
  when "create"
    chromext.init options[1]
  when "build"
    chromext.watch options[1], ->
      chromext.build options[1]
  when "watch"
    chromext.watch options[1]
  when "-h"
    usage()
  else
    usage()
