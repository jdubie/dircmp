fs = require 'fs'
{print} = require 'sys'
{exec, spawn} = require 'child_process'

REPORTER = "min"

task "test", "run tests", ->
  test()

task 'clean', 'Remove lib/', ->
  clean()

task 'build', 'Build lib/ from src/', ->
  build()

build = (callback) ->
  coffee = spawn 'coffee', ['-c', '-o', 'lib', 'src']
  coffee.stderr.on 'data', (data) ->
    process.stderr.write data.toString()
  coffee.stdout.on 'data', (data) ->
    print data.toString()
  coffee.on 'exit', (code) ->
    callback?() if code is 0

clean = (callback) ->
  rm = spawn 'rm', ['-rf', 'lib']
  rm.on 'exit', (code) ->
    callback?() if code is 0

test = () ->
  exec "NODE_ENV=test NODE_PATH=.
    ./node_modules/.bin/mocha 
    --compilers coffee:coffee-script
    --reporter #{REPORTER}
    --colors
  ", (err, output) ->
    throw err if err
    console.log output
