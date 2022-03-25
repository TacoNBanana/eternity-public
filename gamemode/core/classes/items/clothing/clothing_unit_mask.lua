ITEM = class.Create("base_item")

ITEM.Name 				= "Metropolice mask"
ITEM.Description 		= "The trademark Civil Protection mask."

ITEM.Model 				= Model("models/tnb/items/maskcp.mdl")

ITEM.EquipmentSlots 	= {EQUIPMENT_HEAD}

ITEM.ItemGroup 			= "Clothing"

ITEM.Obscuring 			= true
ITEM.Filtered 			= true

ITEM.MaskModel 			= "models/tnb/halflife2/%s_head_metrocop.mdl"
ITEM.EyeColor 			= Color(0, 255, 191.25)

function ITEM:GetName()
	local name = self.Name

	if not self.Obscuring then
		name = name .. " (No faceplate)"
	end

	return name
end

function ITEM:GetOptions(ply)
	local tab = {}

	table.insert(tab, {
		Name = "Toggle faceplate",
		Callback = function()
			self.Obscuring = not self.Obscuring
			self.Filtered = self.Obscuring

			ply:HandlePlayerModel()
			ply:HandleMisc()
		end
	})

	if ply:IsSuperAdmin() then
		table.insert(tab, {
			Name = "Set eye color",
			Client = function()
				local col = self.EyeColor or Color(0, 0, 0)
				local str = string.format("%s %s %s", math.Round(col.r, 2), math.Round(col.g, 2), math.Round(col.b, 2))

				return GAMEMODE:OpenGUI("Input", "string", "Set eye color", {
					Default = str
				})
			end,
			Callback = function(val)
				val = (Vector(val) / 255):ToColor()

				if val == self:GetClass().EyeColor then
					val = nil
				end

				self.EyeColor = val

				ply:HandlePlayerModel()
			end
		})

		table.insert(tab, {
			Name = "Disable eyes",
			Callback = function(val)
				self.EyeColor = false

				ply:HandlePlayerModel()
			end
		})
	end

	for _, v in pairs(self:ParentCall("GetOptions", ply)) do
		table.insert(tab, v)
	end

	return tab
end

function ITEM:GetEyeColor()
	return "metrocop_lens_" .. ColorToHex(self.EyeColor)
end

if CLIENT then
	function ITEM:UpdateEyeColor()
		if not self.EyeColor then
			return
		end

		if not IsColor(self.EyeColor) then
			self.EyeColor = Color(self.EyeColor.r, self.EyeColor.g, self.EyeColor.b)
		end

		local vec = self.EyeColor:ToVector() * 4

		CreateMaterial(self:GetEyeColor(), "VertexLitGeneric", {
			["$baseTexture"] = "models/eternity/combine/metrocop_lens",
			["$nocull"] = 1,
			["$selfillum"] = vec:Length() == 0 and 0 or 1,
			["$selfillumtint"] = string.format("[%s %s %s]", vec.x, vec.y, vec.z)
		})
	end

	function ITEM:OnLoaded()
		self:ParentCall("OnLoaded")
		self:UpdateEyeColor()
	end

	function ITEM:OnUpdated(key, value)
		self:ParentCall("OnUpdated", key, value)

		if key == "EyeColor" then
			self:UpdateEyeColor()
		end
	end
end

if SERVER then
	function ITEM:GetModelData(ply)
		local mdl = self.Obscuring and self.MaskModel or "models/tnb/halflife2/%s_head_metrocop_open.mdl"
		local mat = self.EyeColor and "!" .. self:GetEyeColor() or "vgui/black"

		return {
			_base = {
				HideHead = self.Obscuring
			},
			head = {
				Model = Model(string.format(mdl, GAMEMODE:GetGenderString(ply:CharModel()))),
				Materials = {
					["models/eternity/combine/metrocop_lens1"] = mat,
					["models/tnb/combine/metrocop_gloves"] = "vgui/black"
				}
			}
		}
	end
end

return ITEM