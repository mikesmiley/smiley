
#
# Function pads number with leading zeros up to the specified length
#
exports.zeroPad = (number, totalLength) ->
  Array(Math.max(totalLength - String(number).length + 1, 0)).join(0) + number

#
# Render a sequence of bytes to a hex-editor-style
#
exports.hexDump = (bytes) ->
  output = ""
  for i in [0..bytes.length-1] by 16
    output += "#{exports.zeroPad(i, 5)}  "
    for j in [0..15]
      if i+j < bytes.length
        ch = bytes[i+j]
        if ch < 16
          output += "0"
        output += ch.toString(16).toUpperCase() + " "
      else
        output += "   "
      if j is 7
        output += " "

    output += " "

    for j in [0..15]
      if i+j < bytes.length
        ch = bytes[i+j]
        if ch >= 32
          output += String.fromCharCode(ch)
        else
          output += "."
      else
        output += " "
      if j == 7
        output += "  "
    output += "\n"
  return output

#
# Function uses regex to match UUID style string.
#
exports.isUUID = (str) ->
  # make sure it's a string first
  if typeof str is 'string'
    str.match(/[a-fA-f0-9]{8}\-[a-fA-F0-9]{4}\-[a-fA-F0-9]{4}\-[a-fA-F0-9]{4}\-[a-fA-F0-9]{12}/)?
  else
    false

#
# Function tests the given string (naively) for ASCII-printability
#
exports.isAscii = (bytes, depth=256, ratio=0.3) ->
  # only look at up to 256 bytes
  if bytes.length > depth
    sampleLen = depth
  else
    sampleLen = bytes.length

  # count non-printables
  cnt = 0.0
  for i in [0..sampleLen]
    if (bytes.charCodeAt(i) < 32 or bytes.charCodeAt(i) > 127)
      cnt += 1.0

  # if non-printables are less than the specified ratio of total, return true
  return ((cnt/bytes.length) < ratio)

#
# Function returns an Array of system network interfaces defined by the following object:
# {
#   name:
#   addr:
#   family:
# }
#
# Interfaces with multiple addresses have a repeated name.
#
exports.getNetworkInterfaces = ->
  os = require 'os'
  ret = []
  ifaces = os.networkInterfaces()
  for k,v of ifaces
    for a in v
      ev = {}
      ev.name = k
      ev.addr = a.address
      ev.family = a.family
      ret.push ev
  return ret

#
# Function returns an external IP address for the current machine.
#
exports.getExternalIPAddress = ->
  os = require 'os'
  ifaces = os.networkInterfaces()
  for own dev of ifaces
    for i in ifaces[dev]
      if i.family is 'IPv4' and i.internal is false
        return i.address

#
# Returns a block string containing a smiley face in ascii art.
#
exports.smileyFace = ->
  """    ..::''''::..
    .;''        ``;.
   ::    ::  ::    ::
  ::     ::  ::     ::
  :: .:' ::  :: `:. ::
  ::  :          :  ::
   :: `:.      .:' ::
    `;..``::::''..;'
      ``::,,,,::''"""

#
# Function finds the root directory of a Module defined as the first directory above the
# entry point with a package.json file.
#
exports.findModuleRoot = (mod) ->
  fs = require 'fs'
  path = require 'path'
  # require.resolve yields entrypoint
  try
    p = path.dirname require.resolve(mod)
  catch e # assume this is because module can't be found
    return null
  # only allow twenty levels of traversal for safety
  for i in [0..20]
    if fs.existsSync(path.join(p, "package.json"))
      return p
    else
      # go up one level
      p = path.join(p, "..")
  return null

#
# Function converts string to Title Case. Hyphens and underscores are
# converted to spaces.
#
exports.titleCase = (str) ->
  return str.replace(/[\-_]/g, " ").replace /^.| ./g, (c) ->
    c.toUpperCase()

#
# Function expands an IEC abbreviated size (e.g. 4Kb) into a full decimal number
# by assuming the IEC binary format (1k = 1024)
#
exports.iecToDecimal = (str) ->
    m = str.split /^([0-9\.]+)(\w+)$/
    num = m[1]
    units = m[2]
    mult = null
    switch units
      when 'k', 'K', 'KB', 'Kb', 'KiB'
        mult = 1024
      when 'm', 'M', 'MB', 'Mb', 'MiB'
        mult = 1024 * 1024
      when 'g', 'G', 'GB', 'Gb', 'GiB'
        mult = 1024 * 1024 * 1024
      when 'b', 'B'
        mult = 1

    if mult
      return parseFloat(num) * mult
    else
      throw new Error "iecToDecimal: error parsing #{str}"

#
# Debounce a function call. Subsequent calls to the function provided will be
# ignored until the timer runs out. If immediate is true, the function will be
# given an initial call when this debounce function is called.
# @param func The function
# @param wait The timeout in milliseconds
# @param immediate Boolean if the function should be called initially
#
exports.debounce = (func, wait, immediate) ->
  timeout = undefined
  return ->
    context = this
    args = arguments

    clearTimeout timeout

    timeout = setTimeout ->
      timeout = null
      unless immediate
        func.apply(context, args)
    , wait

    if immediate and not timeout
      func.apply(context, args)

    return