describe "findModulePath", ->
  path = require 'path'

  beforeEach ->
    @smiley = require '../'

  it "should return null for non-existent module", ->
    expect(@smiley.findModuleRoot('ejfdsaljfsd')).toBeNull()

  it "should return root of valid module", ->
    expect(@smiley.findModuleRoot('coffee-script')).toBe path.resolve("node_modules/coffee-script")
