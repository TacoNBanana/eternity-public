module("heartbeat", package.seeall)

local baseline = 0.2

local points = {
	[0.15] = 0,
	[0.2] =  0.1,
	[0.25] = 0,
	[0.35] = 0,
	[0.36] = -0.1,
	[0.40] = 0.7,
	[0.43] = -0.15,
	[0.45] = 0,
	[0.55] = 0,
	[0.65] = 0.1,
	[0.75] = 0
}

local function GetHeightFraction(fraction)
	local k1, v1
	local k2, v2

	for k, v in SortedPairs(points) do
		if k > fraction then
			k2, v2 = k, v

			if not v1 then
				k1, v1 = 0, 0
			end

			break
		end

		k1, v1 = k, v
	end

	if not v2 then
		k2, v2 = 1, 0
	end

	return math.Remap(fraction, k1, k2, v1, v2)
end

local function GetHeightMultiplier(ply)
	return math.Clamp(ply:Health() / ply:GetMaxHealth(), 0, 1)
end

local function GetHeight(ply, x, w, h, pulses)
	if x > w then
		x = x - w
	end

	local fraction = math.fmod(x / (w / pulses), 1)
	local height = GetHeightFraction(fraction) * GetHeightMultiplier(ply)

	return x,  h - ((height + baseline) * h)
end

local function GetPulseColor(ply)
	local fraction = math.Clamp(ply:Health() / ply:GetMaxHealth(), 0, 1)

	return LerpVector(fraction, Vector(1, 0, 0), Vector(0, 1, 0)):ToColor()
end

function Draw(ply, x, y, w, h)
	local rate = 0.3
	local segments = 1
	local pulses = 2
	local tail = 50

	local offset = w / segments
	local start = math.Round(math.fmod(offset + (CurTime() * (rate * w)), w))

	for i = 1, tail do
		local alpha = math.Remap(i, 1, tail, 0, 255)
		local pos = start + i

		local pos1, h1 = GetHeight(ply, pos, w, h, pulses)
		local pos2, h2 = GetHeight(ply, pos + 1, w, h, pulses)

		if pos2 < pos1 then
			pos1 = 0
		end

		surface.SetDrawColor(ColorAlpha(GetPulseColor(ply), alpha))

		for j = 0, 1 do
			surface.DrawLine(x + pos1, y + h1 + j, x + pos2, y + h2 + j)
		end
	end
end