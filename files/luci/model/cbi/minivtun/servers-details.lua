local m, s, o
local sid = arg[1]

m = Map("minivtun", "%s - %s" %{translate("minivtun"), translate("Edit Server")})
m.redirect = luci.dispatcher.build_url("admin/services/minivtun/servers")
m.sid = sid

if m.uci:get("minivtun", sid) ~= "servers" then
	luci.http.redirect(m.redirect)
	return
end

s = m:section(NamedSection, sid, "servers")
s.anonymous = true
s.addremove = false

o = s:option(Value, "alias", translate("Alias(optional)"))

o = s:option(Value, "server_addr", translate("Server Address"))                                                                                                                                                                                  
o.datatype = "host"                                                                                                                                                                                                                         
o.rmempty = false                                                                                                                                                                                                                           
                                                                                                                                                                                                                                            
o = s:option(Value, "server_port", translate("Server Port"))                                                                                                                                                                                       
o.datatype = "port"                                                                                                                                                                                                                         
o.rmempty = false                                                                                                                                                                                                                           

o = s:option(Value, "password", translate("Password"))
o.password = true
o.rmempty = false

o = s:option(ListValue, "local_family", translate("Subnet Family"))
o:value("IPv4", translate("IPv4"))
o:value("IPv6", translate("IPv6"))
o.rmempty = false

o = s:option(Value, "local_ipaddr4", translate("Local IPv4 Address"))
o:depends("local_family","IPv4")
o.datatype = "ip4addr"
o.default = "10.0.7.2/24"
o.rmempty = true

o = s:option(Value, "local_ipaddr6", translate("Local IPv6 Address"))
o:depends("local_family","IPv6")
o.datatype = "ip6addr"
o.default = "fc00::2/64"
o.rmempty = true

o = s:option(Value, "mtu", translate("Override MTU"))
o.placeholder = 1400
o.datatype = "range(296,1500)"
o.rmempty = false

o = s:option(Value, "keepalive", translate("Heart-Beats Interval"))
o.placeholder = 20
o.datatype = "range(10,30)"
o.rmempty = false

o = s:option(Value, "intf", translate("Interface"))
o.placeholder = "mv0"
o.rmempty = false

return m
