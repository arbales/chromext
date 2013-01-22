###
# chromext
# chrome extension bootstrap with coffee, jade and stylus
# http://github.com/saschagehlich/chromext
#
# Copyright (c) 2012 FILSH Media GmbH <contact@filshmedia.net>
# MIT Licensed
###

fs      = require 'fs'
path    = require 'path'
watch   = require 'watch'
{exec}  = require 'child_process'
mkdirp  = require 'mkdirp'

# Compilers
cs      = require 'coffee-script'
st      = require 'stylus'
ja      = require 'jade'

class Watcher
  constructor: (@inputDir, @outputDir, next=false) ->
    try
      mkdirp.sync @outputDir
    catch e
      unless e.code is 'EEXIST'
        throw e
    
    if next
      watch.walk @inputDir, { ignoreDotFiles: true, filter: @filter }, (error, files) =>
        for file, info of files
          unless @filter file
            @_compile file
        next()
        
    else
      watch.createMonitor @inputDir, { ignoreDotFiles: true, filter: @filter }, (monitor) =>
        # Compile on startup
        for file, info of monitor.files
          unless @filter file
            @_compile file
  
        monitor.on 'changed', (f, curr, prev) => @compile f
        monitor.on 'created', (f) => unless @filter(f) then @compile f
        
  success: ->
    logger.log @input, "#{@basename} => #{@filename}"
  error: ->
    logger.error @input, f + ': ' + e.message
  
  _compile: (f) ->
    @basename = path.basename f
    @extless = path.basename f, @input
    @filename = "#{@outputDir}/#{@extless}#{@output}"
    @compile arguments...

module.exports =
  vendor: class VendorWatcher extends Watcher
    filter: (file) -> fs.lstatSync(file).isDirectory()
    compile: (f) ->
      exec "cp -f #{f} #{@outputDir}"
      logger.log 'copy', "#{f.replace(@inputDir + '/', '')} => #{@outputDir}/#{f.replace(@inputDir + '/', '')}"

  coffee: class CoffeeWatcher extends Watcher
    input: 'coffee'
    output: 'js'
    filter: (file) -> return !file.match(/\.coffee$/i)
    compile: (f) ->
      try
        js = cs.compile fs.readFileSync(f).toString()
        fs.writeFileSync @filename, js
        @success()
      catch e
        @error(e)

  jade: class JadeWatcher extends Watcher
    input: 'jade'
    output: 'html'
    filter: (file) -> return !file.match(/\.jade$/i)
    compile: (f) ->
      try
        html = ja.compile fs.readFileSync(f).toString()
        fs.writeFileSync @filename, html()
        @success()
      catch e
        @error e.message
        
  stylus: class StylusWatcher extends Watcher
    input: 'styl'
    output: 'css'
    filter: (file) -> return !file.match(/\.styl$/i)
    compile: (f) ->
      st.render fs.readFileSync(f).toString(), (err, css) =>
        @error(err) if err
        fs.writeFileSync @filename, css
        @success()