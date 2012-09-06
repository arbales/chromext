###
# chromext
# chrome extension bootstrap with coffee, jade and stylus
# http://github.com/saschagehlich/chromext
#
# Copyright (c) 2012 FILSH Media GmbH <contact@filshmedia.net>
# MIT Licensed
###

chromext = require './chromext'

optparse = require 'optparse'
parser   = new optparse.OptionParser([])

logger = global.logger = require './lib/logger'

parser.banner = 'Usage: chromext <command>\n\nwhere <command> is one of:\n    build, init, watch'

parser.on 2, (opt) ->
  switch opt
    when 'init'
      chromext.init()
    when 'build'
      chromext.build()
    when 'watch'
      chromext.watch()
    else
      console.log parser.toString()

if process.argv.length < 3
  console.log parser.toString()

parser.parse process.argv