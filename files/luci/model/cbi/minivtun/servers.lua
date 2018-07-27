local m, s, o

m = Map("minivtun", "%s - %s" %{translate("minivtun"), translate("Servers Manage")})

s = m:section(TypedSection, "servers")
s.anonymous = true
s.addremove = true
s.sortable = true
s.template = "cbi/tblsection"
s.extedit = luci.dispatcher.build_url("admin/services/minivtun/servers/%s")
function s.create(...)
	local sid = TypedSection.create(...)
	if sid then
		luci.http.redirect(s.extedit % sid)
		return
	end
end

o = s:option(DummyValue, "alias", translate("Alias"))
function o.cfgvalue(...)
	return Value.cfgvalue(...) or translate("None")
end

o = s:option(DummyValue, "_server_address", translate("Server Address"))
function o.cfgvalue(self, section)
	local server_addr = m.uci:get("minivtun", section, "server_addr") or "?"
	local server_port = m.uci:get("minivtun", section, "server_port") or "1414"
	return "%s:%s" %{server_addr, server_port}
end

o = s:option(DummyValue, "local_family", translate("Subnet Family"))
function o.cfgvalue(...)
	local v = Value.cfgvalue(...)
	return v and v:lower() or "IPv4"
end

o = s:option(DummyValue, "_local_ipaddr", translate("Local Subnet"))
function o.cfgvalue(self, section)
	local local_family = m.uci:get("minivtun", section, "local_family") or "IPv4"
	local local_ipaddr = ""
	
	if local_family == "IPv4" then
		local_ipaddr = m.uci:get("minivtun", section, "local_ipaddr4") or "10.0.7.2/24"
	else
		local_ipaddr = m.uci:get("minivtun", section, "local_ipaddr6") or "fc00::2/64"
	end
	
	return local_ipaddr
end

o = s:option(DummyValue, "intf", translate("Interface"))
function o.cfgvalue(...)
	local v = Value.cfgvalue(...)
	return v and v:lower() or "mv0"
end

return m
