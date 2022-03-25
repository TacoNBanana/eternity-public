function GM:CheckInput(subtype, data, value)
	if subtype == "string" then
		if data.Max and #value > data.Max then
			return false
		end
	elseif subtype == "number" then
		if not tonumber(value) then
			return false
		end
	end

	return true
end