module("luci.controller.minivtun", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/minivtun") then
		return
	end

	entry({"admin", "services", "minivtun"},
		firstchild(), _("minivtun")).dependent = false

	entry({"admin", "services", "minivtun", "general"},
		cbi("minivtun/general"), _("Settings"), 1)

	entry({"admin", "services", "minivtun", "servers"},
		arcombine(cbi("minivtun/servers"), cbi("minivtun/servers-details")),
		_("Servers Manage"), 2).leaf = true

	entry({"admin", "services", "minivtun", "status"}, call("action_status"))
end

local function is_running(name)
	return luci.sys.call("pidof %s >/dev/null" %{name}) == 0
end

function action_status()
	luci.http.prepare_content("application/json")
	luci.http.write_json({
		running = is_running("minivtun")
	})
end
