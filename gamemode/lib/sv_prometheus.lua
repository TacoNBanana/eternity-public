hook.Add("OnDBALConnected", "prometheus.OnDBALConnected", function(key)
	if key != "prometheus" then
		return
	end

	timer.Create("CheckDonations", 300, 0, function()
		coroutine.WrapFunc(function()
			prometheus.Update()
		end)
	end)
end)

local function give(ply, price, actions)
	local func = CompileString(actions.custom_action.code_when, "Donation processor: " .. tostring(ply))

	Prometheus = {}
	Prometheus.Temp = {}

	func(ply, price)

	Prometheus = nil
end

local function take(ply, actions)
	if not actions.custom_action.code_after then
		return
	end

	local func = CompileString(actions.custom_action.code_after, "Donation processor: " .. tostring(ply))

	Prometheus = {}
	Prometheus.Temp = {}

	func(ply)

	Prometheus = nil
end

local function process(tab)
	local ply = player.GetBySteamID64(tab.uid)

	if not ply then
		return
	end

	local actions = util.JSONToTable(tab.actions)

	if not actions.custom_action then
		return
	end

	local permanent = string.gsub(tab.expiretime, " 00:00:00", "") == "1000-01-01"
	local update = {}

	if tab.delivered == 0 then
		if tab.active == 0 then
			take(ply, actions)
		elseif tab.active == 1 then
			give(ply, tab.price or 0, actions)
		end

		update.delivered = 1
	elseif tab.active == 1 and tab.expiretime < os.date("%Y-%m-%d" , os.time()) and not permanent then
		take(ply, actions)

		update.active = 0
	end

	if table.Count(update) > 0 then
		dbal.Update("prometheus", "actions", update, "id = ?", tab.id)
	end
end

module("prometheus", package.seeall)

function Update()
	local query = "SELECT actions.id, CAST(actions.uid AS CHAR) AS uid, actions.actions, actions.active, actions.delivered, actions.expiretime, transactions.price FROM actions LEFT JOIN transactions ON actions.transaction = transactions.id WHERE SERVER LIKE '%\"?\"%'"
	local id = GAMEMODE:GetConfig("Prometheus").ID

	for k, v in ipairs(dbal.Query("prometheus", query, id)) do
		process(v)
	end
end