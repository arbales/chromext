###
# chromext
# chrome extension bootstrap with coffee, jade and stylus
# http://github.com/saschagehlich/chromext
#
# Copyright (c) 2012 FILSH Media GmbH <contact@filshmedia.net>
# MIT Licensed
###

fs    = require 'fs'
path  = require 'path'
watch = require 'watch'

# Compilers
cs    = require 'coffee-script'
st    = require 'stylus'
ja    = require 'jade'

class Watcher
  constructor: (@inputDir, @outputDir) ->
    try
      fs.mkdirSync @outputDir
    catch e
      unless e.code is 'EEXIST'
        throw e

    watch.createMonitor @inputDir, { ignoreDotFiles: true, filter: @filter }, (monitor) =>
      # Compile on startup
      for file, info of monitor.files
        unless @filter file
          @compile file

      monitor.on 'changed', (f, curr, prev) => @compile f
      monitor.on 'created', (f) => @compile f

module.exports =
  coffee: class CoffeeWatcher extends Watcher
    filter: (file) -> return !file.match(/\.coffee$/i)
    compile: (f) ->
      try
        js = cs.compile fs.readFileSync(f).toString()
        jsFilename = @outputDir + '/' + path.basename(f, '.coffee') + '.js'

        fs.writeFileSync jsFilename, js

        logger.log 'coffee', "#{f.replace(@inputDir + '/', '')} => #{jsFilename.replace(@outputDir + '/', '')}"
      catch e
        logger.error 'coffee', f + ': ' + e.message

  jade: class JadeWatcher extends Watcher
    filter: (file) -> return !file.match(/\.jade$/i)
    compile: (f) ->
      try
        html = ja.compile fs.readFileSync(f).toString()
        htmlFilename = @outputDir + '/' + path.basename(f, '.jade') + '.html'

        fs.writeFileSync htmlFilename, html()

        logger.log 'jade', "#{f.replace(@inputDir + '/', '')} => #{htmlFilename.replace(@outputDir + '/', '')}"
      catch e
        logger.error 'jade', f + ': ' + e.message

  stylus: class StylusWatcher extends Watcher
    filter: (file) -> return !file.match(/\.styl$/i)
    compile: (f) ->
        st.render fs.readFileSync(f).toString(), (err, css) =>
          if err?
            return logger.error 'stylus', f + ': ' + err

          cssFilename = @outputDir + '/' + path.basename(f, '.styl') + '.css'
          fs.writeFileSync cssFilename, css

          logger.log 'stylus', "#{f.replace(@inputDir + '/', '')} => #{cssFilename.replace(@outputDir + '/', '')}"