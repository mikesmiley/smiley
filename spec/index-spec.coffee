describe "findModulePath", ->
  path = require 'path'

  beforeEach ->
    @smiley = require '../'

  it "should return null for non-existent module", ->
    expect(@smiley.findModuleRoot('ejfdsaljfsd')).toBeNull()

  it "should return root of valid module", ->
    expect(@smiley.findModuleRoot('coffee-script')).toBe path.resolve("node_modules/coffee-script")

  it "should convert title case", ->
    expect(@smiley.titleCase("this is a string")).toBe "This Is A String"
  
  it "should parse IEC size", ->
    expect(@smiley.iecToDecimal("4.0KB")).toBe 4096
  
  it "should throw for invalid IEC size", ->
    testIt = =>
      @smiley.iecToDecimal("jjfds")
    expect(testIt).toThrow()