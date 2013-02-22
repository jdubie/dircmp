fs     = require 'fs'
crypto = require 'crypto'
findit = require 'findit'
async  = require 'async'

HASH_FCN = 'sha1'

# TODO worry about max number of file descriptors
# TODO make more streaming, currently: 1) get all files, 2) hash and return
#
exports.hash = (dir, callback) ->
  shasum = crypto.createHash('sha1')
  finder = findit.find(dir)

  files = []
  links = []

  finder.on 'file', (file, stat) ->
    files.push(file)

  finder.on 'link', (link, stat) ->
    links.push(link)

  finder.on 'end', () ->
    async.parallel [
      (callback) -> async.map(files, addPath(shasum, fs.readFile), callback)
      (callback) -> async.map(links, addPath(shasum, fs.readLink), callback)
    ], (err) ->
      callback(err, shasum.digest('hex'))

addPath = (shasum, reader) ->
  (path, callback) ->
    reader path, (err, data) ->
      shasum.update(path + data)
      callback(err)
