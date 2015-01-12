

#
# Function returns an Array of system network interfaces.
#
exports.getInterfaces = (ef) ->
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
  ifaces = os.networkInterfaces()
  for own dev of ifaces
    for i in ifaces[dev]
      if i.family is 'IPv4' and i.internal is false
        return i.address
