GM.MainFont = "Tahoma"

function surface.FontExists(font)
	local ok = pcall(surface.SetFont, font)

	return ok
end

surface.CreateFont("DefaultBold", {
	font = "Tahoma",
	size = 13,
	weight = 1000
})

surface.CreateFont("eternity.labelworld", {
	font = GM.MainFont,
	size = 2048,
	weight = ScreenScale(7)
})

surface.CreateFont("eternity.labelmassive", {
	font = GM.MainFont,
	size = 30,
	weight = 500
})

surface.CreateFont("eternity.labelgiant", {
	font = GM.MainFont,
	size = 22,
	weight = 500
})

surface.CreateFont("eternity.labelbig", {
	font = GM.MainFont,
	size = 18,
	weight = 500
})

surface.CreateFont("eternity.ammo", {
	font = GM.MainFont,
	size = 50,
	weight = 500
})

surface.CreateFont("eternity.player", {
	font = GM.MainFont,
	size = 17,
	weight = 700
})

surface.CreateFont("eternity.labelmedium", {
	font = GM.MainFont,
	size = 16,
	weight = 500
})

surface.CreateFont("eternity.labelmediumbold", {
	font = GM.MainFont,
	size = 16,
	weight = 1600
})

surface.CreateFont("eternity.labelsmall", {
	font = GM.MainFont,
	size = 14,
	Weight = 500
})

surface.CreateFont("eternity.labelsmallbold", {
	font = GM.MainFont,
	size = 14,
	weight = 1600
})

surface.CreateFont("eternity.labelsmallitalic", {
	font = GM.MainFont,
	size = 14,
	Weight = 500,
	italic = true
})

surface.CreateFont("eternity.labeltiny", {
	font = GM.MainFont,
	size = 12,
	Weight = 500
})

surface.CreateFont("eternity.chat", {
	font = GM.MainFont,
	size = 18,
	weight = 500
})

surface.CreateFont("eternity.chatbold", {
	font = GM.MainFont,
	size = 18,
	weight = 1600
})

surface.CreateFont("eternity.chatitalic", {
	font = GM.MainFont,
	size = 18,
	weight = 500,
	italic = true
})

surface.CreateFont("eternity.chatradio", {
	font = "Lucida Console",
	size = 14,
	weight = 500
})

surface.CreateFont("eternity.chatradiobold", {
	font = "Lucida Console",
	size = 14,
	weight = 1600
})

surface.CreateFont("eternity.chatradioitalic", {
	font = "Lucida Console",
	size = 14,
	weight = 500,
	italic = true
})

surface.CreateFont("eternity.camera", {
	font = GM.MainFont,
	antialias = false,
	outline = true,
	weight = 800,
	size = 18
})

surface.CreateFont("eternity.camera2", {
	font = GM.MainFont,
	antialias = true,
	weight = 1600,
	size = 2048
})

markleft.SetDefaults({
	Font = "eternity.chat"
})

markleft.RegisterTag("tc", {
	Color = function(stack, args)
		local id = tonumber(args)

		if not id then
			return Color(255, 255, 255)
		end

		return GAMEMODE:GetTeamColor(Player(id))
	end
})

markleft.RegisterTag("col", {
	Color = function(stack, args)
		return Color(unpack(string.Explode(",", args)))
	end
})

markleft.RegisterTag("b", {
	Font = function(stack, args)
		return stack .. "bold"
	end
})

markleft.RegisterTag("i", {
	Font = function(stack, args)
		return stack .. "italic"
	end
})

markleft.RegisterTag("icolor", {
	Color = function(stack, args)
		local item = GAMEMODE:GetItem(tonumber(args))

		if not item then
			return Color(255, 255, 255)
		end

		return item:GetOutlineColor()
	end
})

markleft.RegisterTag("tiny", {
	Font = "eternity.labeltiny",
	Outline = 0
})

markleft.RegisterTag("font", {
	Font = function(stack, args)
		return tostring(args)
	end
})

markleft.RegisterTag("chat", {
	Font = "eternity.chat",
	Outline = 1
})

markleft.RegisterTag("ol", {
	Outline = function(stack, args)
		return tonumber(args) or true
	end
})

markleft.RegisterTag("dark", {
	Color = Color(150, 150, 150)
})

markleft.RegisterTag("new", {
	Color = Color(0, 120, 0)
})

markleft.RegisterTag("upd", {
	Color = Color(255, 255, 100)
})

markleft.RegisterTag("fix", {
	Color = Color(0, 191, 255)
})

markleft.RegisterTag("rem", {
	Color = Color(223, 22, 22)
})

markleft.RegisterTag("rainbow", {
	Color = true
})