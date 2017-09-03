describe("findModulePath", function() {
  var path = require('path');

  beforeEach(function() {
    this.smiley = require('../');
  });

  it("should pad with zeros up to specified length", function() {
    expect(this.smiley.zeroPad(34, 20)).toBe("00000000000000000034");
  });

  it("should render a hexdump", function() {
    expect(this.smiley.hexDump(new Buffer([2,3,4,5,6,54,43,23,2,3,6,8,4,7,8,65,7,43,4,3,7,88,64,45,234]))).toBe(`00000  02 03 04 05 06 36 2B 17  02 03 06 08 04 07 08 41  .....6+.  .......A
00016  07 2B 04 03 07 58 40 2D  EA                       .+...X@-  ê       
`);
  });

  it("should recognize UUID strings", function() {
    expect(this.smiley.isUUID("9FBF1301-9EA7-4C6C-93D9-E2D476E7665B")).toBe(true);
  })

  it("should check for ASCII-printability", function() {
    expect(this.smiley.isAscii("jklfsdj")).toBe(true);
  })

  it("should check for ASCII-printability failure", function() {
    expect(this.smiley.isAscii("\x88\x44\x73\x98\xa3\c3")).toBe(false);
  })

  it("should return null for non-existent module", function() {
    expect(this.smiley.findModuleRoot('ejfdsaljfsd')).toBeNull()
  })

  it("should return root of valid module", function() {
    expect(this.smiley.findModuleRoot('coffee-script')).toBe(path.resolve("node_modules/coffee-script"));
  })

  it("should convert title case", function() {
    expect(this.smiley.titleCase("this is a string")).toBe("This Is A String");
  })
  
  it("should parse IEC size", function() {
    expect(this.smiley.iecToDecimal("4.0KB")).toBe(4096);
  })
  
  it("should throw for invalid IEC size", function() {
    testIt = () => {
      this.smiley.iecToDecimal("jjfds")
    }
    expect(testIt).toThrow()
  })
})