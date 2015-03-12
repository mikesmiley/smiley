
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
  # require.resolve yields entrypoint, so go one level above to start
  try
    p = path.join(require.resolve(mod), "..")
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
