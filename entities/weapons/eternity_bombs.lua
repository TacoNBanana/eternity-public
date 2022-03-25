AddCSLuaFile()

SWEP.PrintName 				= "Explosives Spawner"
SWEP.Author 				= "TankNut"

SWEP.RenderGroup 			= RENDERGROUP_OPAQUE

SWEP.Slot 					= 5
SWEP.SlotPos 				= 11

SWEP.WorldModel 			= Model("models/vuthakral/halo/weapons/w_mauler.mdl")
SWEP.ViewModel 				= Model("models/vuthakral/halo/weapons/c_hum_mauler.mdl")

SWEP.UseHands 				= true

SWEP.Primary.ClipSize 		= -1
SWEP.Primary.DefaultClip 	= -1
SWEP.Primary.Automatic 		= false
SWEP.Primary.Ammo 			= "none"

SWEP.Secondary.ClipSize 	= -1
SWEP.Secondary.DefaultClip 	= -1
SWEP.Secondary.Automatic 	= false
SWEP.Secondary.Ammo 		= "none"

local doi = {
	Close = {
		Sound("explosions/doi_generic_01_close.wav"),
		Sound("explosions/doi_generic_02_close.wav"),
		Sound("explosions/doi_generic_03_close.wav"),
		Sound("explosions/doi_generic_04_close.wav")
	},
	Med = {
		Sound("explosions/doi_generic_01.wav"),
		Sound("explosions/doi_generic_02.wav"),
		Sound("explosions/doi_generic_03.wav"),
		Sound("explosions/doi_generic_04.wav")
	},
	Far = {
		Sound("^explosions/doi_generic_01_dist.wav"),
		Sound("^explosions/doi_generic_02_dist.wav"),
		Sound("^explosions/doi_generic_03_dist.wav"),
		Sound("^explosions/doi_generic_04_dist.wav")
	}
}

local panzer = {
	Close = {
		Sound("explosions/doi_panzerschreck_01_close.wav"),
		Sound("explosions/doi_panzerschreck_02_close.wav"),
		Sound("explosions/doi_panzerschreck_03_close.wav")
	},
	Med = {
		Sound("explosions/doi_panzerschreck_01.wav"),
		Sound("explosions/doi_panzerschreck_02.wav"),
		Sound("explosions/doi_panzerschreck_03.wav")
	},
	Far = {
		Sound("^explosions/doi_panzerschreck_01_dist.wav"),
		Sound("^explosions/doi_panzerschreck_02_dist.wav"),
		Sound("^explosions/doi_panzerschreck_03_dist.wav")
	}
}

local ty = {
	Close = {
		Sound("explosions/doi_ty_01_close.wav"),
		Sound("explosions/doi_ty_02_close.wav"),
		Sound("explosions/doi_ty_03_close.wav"),
		Sound("explosions/doi_ty_04_close.wav")
	},
	Med = {
		Sound("explosions/doi_ty_01.wav"),
		Sound("explosions/doi_ty_02.wav"),
		Sound("explosions/doi_ty_03.wav"),
		Sound("explosions/doi_ty_04.wav")
	},
	Far = {
		Sound("^explosions/doi_ty_01_dist.wav"),
		Sound("^explosions/doi_ty_02_dist.wav"),
		Sound("^explosions/doi_ty_03_dist.wav"),
		Sound("^explosions/doi_ty_04_dist.wav")
	}
}

SWEP.Bombs = {
	["CBU-52U"] = {
		Effect = "high_explosive_main_2",
		Sounds = {
			Far = Sound("explosions/gbomb_6.mp3")
		},
		Angle = function(self, ang)
			return ang + Angle(90, 0, 0)
		end,
		Radius = 600,
		Damage = 200
	},
	["1000LB GP"] = {
		Effect = "cloudmaker_ground",
		Sounds = {
			Far = Sound("explosions/gbomb_3.mp3")
		},
		Radius = 3500,
		Damage = 16000
	},
	["2000LB GP"] = {
		Effect = "1000lb_explosion",
		Sounds = {
			Far = Sound("explosions/gbomb_2.mp3")
		},
		Radius = 5000,
		Damage = 20000
	},
	["FAB-250"] = {
		Effect = "doi_artillery_explosion",
		Sounds = doi,
		Radius = 1000,
		Damage = 16000
	},
	["GBU-12 Paveway II"] = {
		Effect = "500lb_ground",
		Sounds = {
			Far = Sound("explosions/gbomb_4.mp3")
		},
		Radius = 1450,
		Damage = 16000
	},
	["GP 250LB"] = {
		Effect = "doi_artillery_explosion",
		Sounds = doi,
		Radius = 500,
		Damage = 16000
	},
	["GP 500LB"] = {
		Effect = "doi_stuka_explosion",
		Sounds = {
			Close = Sound("explosions/doi_stuka_close.wav"),
			Med = Sound("explosions/doi_stuka_far.wav"),
			Far = Sound("^explosions/doi_stuka_dist.wav")
		},
		Radius = 1500,
		Damage = 16000
	},
	["JDAM GBU-38"] = {
		Effect = "500lb_ground",
		Sounds = {
			Far = Sound("explosions/gbomb_4.mp3")
		},
		Radius = 1450,
		Damage = 16000
	},
	["Mark 77 Napalm"] = {
		Effect = "napalm_explosion",
		Sounds = {
			Far = Sound("explosions/gbombs_napalm_1.mp3")
		},
		Angle = function(self, ang)
			return Angle(0, self.Owner:EyeAngles().y + 90, 0)
		end,
		Radius = 950,
		Damage = 750
	},
	["Mark 82 500LB"] = {
		Effect = "500lb_ground",
		Sounds = {
			Far = Sound("explosions/gbomb_4.mp3")
		},
		Radius = 1450,
		Damage = 16000
	},
	["SC100"] = {
		Effect = "doi_artillery_explosion",
		Sounds = doi,
		Radius = 500,
		Damage = 16000
	},
	["SC1000"] = {
		Effect = "1000lb_explosion",
		Sounds = {
			Far = Sound("explosions/gbomb_2.mp3")
		},
		Radius = 5000,
		Damage = 20000
	},
	["SC250"] = {
		Effect = "doi_stuka_explosion",
		Sounds = {
			Close = Sound("explosions/doi_stuka_close.wav"),
			Med = Sound("explosions/doi_stuka_far.wav"),
			Far = Sound("^explosions/doi_stuka_dist.wav")
		},
		Radius = 1500,
		Damage = 16000
	},
	["SC500"] = {
		Effect = "cloudmaker_ground",
		Sounds = {
			Far = Sound("explosions/gbomb_3.mp3")
		},
		Radius = 3500,
		Damage = 16000
	},
	["HVAR"] = {
		Effect = "500lb_air",
		Sounds = panzer,
		Angle = function(self, ang)
			return ang + Angle(90, 0, 0)
		end,
		Radius = 500,
		Damage = 500
	},
	["Hydra 70"] = {
		Effect = "high_explosive_air",
		Sounds = {
			Med = {
				Sound("wac/tank/tank_shell_01.wav"),
				Sound("wac/tank/tank_shell_02.wav"),
				Sound("wac/tank/tank_shell_03.wav"),
				Sound("wac/tank/tank_shell_04.wav"),
				Sound("wac/tank/tank_shell_05.wav")
			}
		},
		Radius = 250,
		Damage = 500
	},
	["Nebelwerfer"] = {
		Effect = "gred_highcal_rocket_explosion",
		Sounds = doi,
		Radius = 600,
		Damage = 1000
	},
	["RP-3"] = {
		Effect = "doi_mortar_explosion",
		Sounds = ty,
		Radius = 350,
		Damage = 500
	},
	["V1"] = {
		Effect = "500lb_ground",
		Sounds = {
			Far = Sound("explosions/gbomb_4.mp3")
		},
		Radius = 1450,
		Damage = 20000
	}
}

for _, v in pairs(SWEP.Bombs) do
	if v.Effect then
		PrecacheParticleSystem(v.Effect)
	end
end

function SWEP:SetupDataTables()
	self:NetworkVar("String", 0, "Selection")
end

function SWEP:Deploy()
	if not self.Owner:IsAdmin() then
		self:Remove()
	end

	local vm = self.Owner:GetViewModel()

	vm:SendViewModelMatchingSequence(vm:LookupSequence("draw"))
	vm:SetPlaybackRate(1)

	self:SetNextPrimaryFire(CurTime() + vm:SequenceDuration())
	self:SetNextSecondaryFire(CurTime() + vm:SequenceDuration())
end

function SWEP:CanPrimaryAttack()
	return true
end

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + 0.4)

	local tr = self.Owner:GetEyeTrace()
	local pos = tr.HitPos + (tr.HitNormal * 5)

	local bomb = self.Bombs[self:GetSelection()]

	if not bomb then
		return
	end

	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)

	self:FireBomb(bomb, pos, tr.HitNormal:Angle())
end

function SWEP:SecondaryAttack()
	self:SendWeaponAnim(ACT_VM_FIDGET)

	if CLIENT then
		local pnl = EternityDermaMenu()

		pnl:AddOption("None", function() self:SetBomb() end)

		for k in SortedPairs(self.Bombs) do
			pnl:AddOption(k, function() self:SetBomb(k) end)
		end

		pnl:Open(ScrW() * 0.5, ScrH() * 0.5)
	end
end

function SWEP:FireBomb(bomb, target, angle)
	if bomb.Angle then
		angle = bomb.Angle(self, angle)
	end

	if bomb.Effect then
		ParticleEffect(bomb.Effect, target, angle)
	end

	if SERVER then
		if bomb.Sounds then
			local close = istable(bomb.Sounds.Close) and table.Random(bomb.Sounds.Close) or bomb.Sounds.Close
			local med = istable(bomb.Sounds.Med) and table.Random(bomb.Sounds.Med) or bomb.Sounds.Med
			local far = istable(bomb.Sounds.Far) and table.Random(bomb.Sounds.Far) or bomb.Sounds.Far

			netstream.Send("BombSound", {
				Pos = target,
				Close = close,
				Med = med,
				Far = far
			})
		end

		if bomb.Radius and bomb.Damage then
			util.BlastDamage(self, self.Owner, target, bomb.Radius, bomb.Damage)
		end
	end
end

if CLIENT then
	function SWEP:SetBomb(bomb)
		netstream.Send("SelectBomb", {
			Ent = self,
			Bomb = bomb
		})
	end

	function SWEP:GetViewModelPosition(pos, ang)
		return LocalToWorld(Vector(-2, -1, -1), Angle(), pos, ang)
	end

	function SWEP:PostDrawViewModel()
		if not GAMEMODE:GetSetting("hud_enabled") then
			return
		end

		local bomb = self.Bombs[self:GetSelection()]

		if not bomb or not bomb.Radius then
			return
		end

		local trace = self.Owner:GetEyeTrace()
		local pos = trace.HitPos + (trace.HitNormal * 5)

		cam.Start3D()
			render.SetColorMaterial()
			render.DrawSphere(pos, bomb.Radius, 50, 50, Color(255, 75, 75, 50))
			render.DrawWireframeSphere(pos, bomb.Radius, 50, 50, Color(255, 75, 75, 255), true)

			render.ClearStencil()
			render.SetStencilEnable(true)
				for _, v in pairs(player.GetAll()) do
					local tab = GAMEMODE:GetVISREntities(v)

					if not tab then
						continue
					end

					if tab[1]:GetPos():Distance(pos) > bomb.Radius then
						continue
					end

					render.SetStencilWriteMask(255)
					render.SetStencilTestMask(255)

					render.SetStencilReferenceValue(15)

					render.SetStencilPassOperation(STENCIL_REPLACE)
					render.SetStencilFailOperation(STENCIL_KEEP)
					render.SetStencilZFailOperation(STENCIL_REPLACE)

					render.SetStencilCompareFunction(STENCIL_ALWAYS)

					render.SetBlend(0)
						for _, ent in pairs(tab) do
							ent:DrawModel()
						end
					render.SetBlend(1)

					render.SetStencilCompareFunction(STENCIL_EQUAL)

					cam.Start2D()
						surface.SetDrawColor(255, 0, 0, 255)
						surface.DrawRect(0, 0, ScrW(), ScrH())
					cam.End2D()

					render.ClearStencil()
				end
			render.SetStencilEnable(false)
		cam.End3D()
	end

	local speed = 13504

	netstream.Hook("BombSound", function(data)
		local pos = data.Pos
		local dist = LocalPlayer():EyePos():Distance(pos)

		local close = data.Close
		local med = data.Med
		local far = data.Far

		local freq = 150
		local amp = math.ClampedRemap(dist, 0, 14000, 14, 0)
		local duration = math.ClampedRemap(dist, 0, 14000, 5, 0)

		local time = dist / speed

		if close and dist <= 5000 then
			local volume = math.Remap(dist, 0, 5000, 1, 0)

			timer.Simple(time, function()
				LocalPlayer():EmitSound(close, 100, 100, volume)
			end)
		end

		if med and dist <= 14000 then
			local volume = math.Remap(dist, 0, 14000, 1, 0)

			timer.Simple(time, function()
				LocalPlayer():EmitSound(med, 100, 100, volume)
			end)
		end

		if far and dist <= 40000 then
			local volume = math.Remap(dist, 5000, 40000, 1, 0)

			timer.Simple(time, function()
				LocalPlayer():EmitSound(far, 100, 100, volume)
			end)
		end

		if duration > 0 then
			timer.Simple(time, function()
				util.ScreenShake(vector_origin, amp, freq, duration, 0)
			end)
		end
	end)
else
	netstream.Hook("SelectBomb", function(ply, data)
		local ent = data.Ent

		if not IsValid(ent) or ent:GetClass() != "eternity_bombs" or ent.Owner != ply then
			return
		end

		ent:SetSelection(data.Bomb or "")
	end, {
		Ent = {Type = TYPE_ENTITY},
		Bomb = {Type = TYPE_STRING, Optional = true}
	})
end