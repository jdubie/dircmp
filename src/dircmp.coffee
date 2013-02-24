fs     = require 'fs'
crypto = require 'crypto'
path   = require 'path'
findit = require 'findit'
async  = require 'async'

HASH_FCN = 'sha1'

exports.cmp = (dir1, dir2, callback) ->
  async.map [dir1, dir2], exports.hash, (err, hashes) ->
    return callback(err) if err
    return callback(null, false) unless hashes?.length is 2
    callback(null, hashes[0] is hashes[1])

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
      (callback) -> async.map(files, addPath(dir, shasum, 'file'), callback)
      (callback) -> async.map(links, addPath(dir, shasum, 'link'), callback)
    ], (err) ->
      callback(err, shasum.digest('hex'))

addPath = (dir, shasum, type) ->
  (path, callback) ->
    reader = switch
      when 'file' then fs.readFile
      when 'link' then fs.readLink
    reader path, (err, data) ->
      shasum.update(removeRoot(dir, path) + data)
      callback(err)

removeRoot = (root, dir) ->
  path.relative(root, dir)
