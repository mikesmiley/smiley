
//
// Function pads number with leading zeros up to the specified length
//
exports.zeroPad = function (number, totalLength) {
  return Array(Math.max(totalLength - String(number).length + 1, 0)).join(0) + number;
};

//
// Render a sequence of bytes to a hex-editor-style
//
exports.hexDump = function (bytes) {
  var output = "";
  for (let i=0; i<bytes.length-1; i+=16) {
    output += exports.zeroPad(i, 5) + "  ";
    for (let j=0; j<16; j++) {
      if (i+j < bytes.length) {
        var ch = bytes[i+j];
        if (ch < 16) {
          output += "0";
        }
        output += ch.toString(16).toUpperCase() + " ";
      } else {
        output += "   ";
      }
      if (j === 7) {
        output += " ";
      }
    }

    output += " ";

    for (let j=0; j<16; j++) {
      if (i+j < bytes.length) {
        ch = bytes[i+j];
        if (ch >= 32) {
          output += String.fromCharCode(ch);
        } else {
          output += ".";
        }
      } else {
        output += " ";
      }
      if (j === 7) {
        output += "  ";
      }
    }
    output += "\n";
  }
  return output;
};

//
// Function uses regex to match UUID style string.
//
exports.isUUID = function (str) {
  // make sure it's a string first
  if (typeof(str) === 'string') {
    return new RegExp(/^[a-fA-f0-9]{8}\-[a-fA-F0-9]{4}\-[a-fA-F0-9]{4}\-[a-fA-F0-9]{4}\-[a-fA-F0-9]{12}$/).test(str);
  } else {
    return false;
  }
};

//
// Function tests the given string (naively) for ASCII-printability
//
exports.isAscii = function (bytes, depth=256, ratio=0.3) {
  var sampleLen;
  // only look at up to 256 bytes
  if (bytes.length > depth) {
    sampleLen = depth;
  } else {
    sampleLen = bytes.length;
  }

  // count non-printables
  var cnt = 0.0;
  for (let i=0; i<sampleLen; i++) {
    if (bytes.charCodeAt(i) < 32 || bytes.charCodeAt(i) > 127) {
      cnt += 1.0;
    }
  }

  // if non-printables are less than the specified ratio of total, return true
  return ((cnt/bytes.length) < ratio);
};

//
// Function returns an Array of system network interfaces defined by the following object:
// {
//   name:
//   addr:
//   family:
// }
//
// Interfaces with multiple addresses have a repeated name.
//
exports.getNetworkInterfaces = function() {
  var os = require('os');
  var ret = [];
  var ifaces = os.networkInterfaces();
  for (let [key, value] of ifaces) {
    for (let a of value) {
      var ev = {};
      ev.name = key;
      ev.addr = a.address;
      ev.family = a.family;
      ret.push(ev);
    }
  }
  return ret;
};

//
// Function returns an external IP address for the current machine.
//
exports.getExternalIPAddress = function() {
  var os = require('os');
  var ifaces = os.networkInterfaces();
  for (let key of ifaces) {
    for (let i of ifaces[key]) {
      if (i.family === 'IPv4' && i.internal === false) {
        return i.address;
      }
    }
  }
};

//
// Function finds the root directory of a Module defined as the first directory above the
// entry point with a package.json file.
//
exports.findModuleRoot = function(mod) {
  var fs = require('fs');
  var path = require('path');
  // require.resolve yields entrypoint
  try {
    var p = path.dirname(require.resolve(mod));
  } catch(e) { // assume this is because module can't be found
    return null;
  }
  // only allow twenty levels of traversal for safety
  for (let i=0; i<20; i++) {
    if (fs.existsSync(path.join(p, "package.json"))) {
      return p;
    } else {
      // go up one level
      p = path.join(p, "..");
    }
  }
  return null;
};

//
// Function converts string to Title Case
//
exports.titleCase = function(str) {
  return str.replace(/^.| ./g, function(c) {
    return c.toUpperCase();
  });
};

//
// Function expands an IEC abbreviated size (e.g. 4Kb) into a full decimal number
// by assuming the IEC binary format (1k = 1024)
//
exports.iecToDecimal = function(str) {
    var m = str.split(/^([0-9\.]+)(\w+)$/);
    var num = m[1];
    var units = m[2];
    var mult = null;
    switch (units) {
      case 'k':
      case 'K':
      case 'KB':
      case 'Kb':
      case 'KiB':
        mult = 1024;
        break;
      case 'm':
      case 'M':
      case 'MB':
      case 'Mb':
      case 'MiB':
        mult = 1024 * 1024;
        break;
      case 'g':
      case 'G':
      case 'GB':
      case 'Gb':
      case 'GiB':
        mult = 1024 * 1024 * 1024;
        break;
      case 'b':
      case 'B':
        mult = 1;
        break;
    }

    if (mult) {
      return parseFloat(num) * mult;
    } else {
      throw new Error("iecToDecimal: error parsing #{str}");
    }
};

//
// Debounce a function call. Subsequent calls to the function provided will be
// ignored until the timer runs out. If immediate is true, the function will be
// given an initial call when this debounce function is called.
// @param func The function
// @param wait The timeout in milliseconds
// @param immediate Boolean if the function should be called initially
//
exports.debounce = function (func, wait, immediate) {
  var timeout = undefined;
  return () => {
    var context = this;
    var args = arguments;

    clearTimeout(timeout);

    timeout = setTimeout(() => {
      timeout = null;
      if (!immediate) {
        func.apply(context, args);
      }
    }, wait);

    if (immediate && !timeout) {
      func.apply(context, args);
    }

    return;
  };
};