###
# chromext
# chrome extension bootstrap with coffee, jade and stylus
# http://github.com/saschagehlich/chromext
#
# Copyright (c) 2012 FILSH Media GmbH <contact@filshmedia.net>
# MIT Licensed
###

path = require 'path'
if process.argv[3]
  pathSplit = path.resolve(process.cwd(), process.argv[3]).split(path.sep)
else
  pathSplit = process.cwd().split(path.sep)

module.exports = 
  name: prompt "Extension name", pathSplit[pathSplit.length - 1]
  description: prompt "Description"
  version: prompt "Version", "0.1"
  background:
    page: "background.html"