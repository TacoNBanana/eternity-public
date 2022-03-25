GM.Config.ServerName = "Eternity: Halo Roleplay"

GM.Config.UIColors = {
	Border = Color(20, 20, 20),
	-- Fills
	FillLight = Color(60, 60, 60),
	FillMedium = Color(40, 40, 40),
	FillDark = Color(30, 30, 30),
	-- Primary color
	Primary = Color(150, 20, 20),
	PrimaryDark = Color(60, 0, 0),
	-- Text color
	TextNormal = Color(200, 200, 200),
	TextHover = Color(255, 255, 255),
	TextPrimary = Color(255, 0, 0),
	TextDisabled = Color(150, 150, 150),
	TextHighlight = Color(40, 40, 40),
	TextBad = Color(200, 0, 0),

	-- Other stuff
	MenuAlt = Color(50, 50, 50),
	MenuHovered = Color(70, 70, 70),
	TextEntry = Color(35, 35, 35)
}

GM.Config.MaxCharacters = 20

GM.Config.MinNameLength = 3
GM.Config.MaxNameLength = 30

GM.Config.MaxDescLength 	= 2048
GM.Config.MaxPropDescLength = 255

GM.Config.AllowedCharacters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ áàâäçéèêëíìîïóòôöúùûüÿÁÀÂÄßÇÉÈÊËÍÌÎÏÓÒÔÖÚÙÛÜŸ.-0123456789'"
GM.Config.AllowedTitleCharacters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ áàâäçéèêëíìîïóòôöúùûüÿÁÀÂÄßÇÉÈÊËÍÌÎÏÓÒÔÖÚÙÛÜŸ.-0123456789'"

-- Used for character creation and other character displays
GM.Config.IdleAnimations = {
	["vortigaunt"] = {Sequence = "idle01", Offset = Vector(0, 3, -10)},
	["soldier.mdl"] = {Sequence = "idle_unarmed"},
	["models/antlion.mdl"] = {Sequence = "distractidle2", Offset = Vector(40, -10, -40)},
	["models/antlion_worker.mdl"] = {Sequence = "distractidle2", Offset = Vector(55, -10, -40)},
	["models/headcrabclassic.mdl"] = {Offset = Vector(0, 0, -55)},
	["models/headcrab.mdl"] = {Offset = Vector(10, 0, -50)},
	["models/headcrabblack.mdl"] = {Sequence = "idle01", Offset = Vector(0, 0, -55)},
	["models/zombie/fast.mdl"] = {Sequence = "idle", Offset = Vector(30, 0, -20)},
	["models/zombie/poison.mdl"] = {Sequence = "idle01", Offset = Vector(20, 0, -20)},
	["models/zombie/classic_torso.mdl"] = {Sequence = "idle02", Offset = Vector(0, 5, -50)},
	["models/antlion_guard.mdl"] = {Sequence = "idle", Offset = Vector(70, 0, 10)}
}

GM.Config.ClothingDefaults = {
	Torso = "models/tnb/halflife2/%s_torso_citizen1.mdl",
	Legs = "models/tnb/halflife2/%s_legs_citizen.mdl"
}

GM.Config.ItemRange = {
	Dist = 1000,
	AimDist = 50
}

GM.Config.PlayerLabel = {
	Fade = 0.05,
	Desc = 64
}

GM.Config.ItemIconSize = 48
GM.Config.ItemIconMargin = 2

GM.Config.ChatSize = {600, 300}
GM.Config.ChatLimit = 500

GM.Config.ChatAliases = {
	["@"] = "/a",
	["//"] = "/ooc",
	["[["] = "/looc",
	[".//"] = "/looc",
	[":"] = "/me"
}

GM.Config.ConsoleAliases = {
	["bring"] = "rpa_bring",
	["goto"] = "rpa_goto",
	["send"] = "rpa_send",
	["tp"] = "rpa_tp",
	["roll"] = "rp_roll",
	["kick"] = "rpa_kick"
}

GM.Config.ScoreboardCommands = {
	{"Kick", "rpa_kick"},
	{"Slap", "rpa_slap"},
	{"Toggle KO", function(ply) return IsValid(ply:GetRagdoll()) and "rpa_wake" or "rpa_ko" end},
	{"Toggle Muted", function(ply) return ply:OOCMuted() and "rpa_unmute" or "rpa_mute" end},
	{"Toggle Hidden", function(ply) return ply:Hidden() and "rpa_unhide" or "rpa_hide" end},
	{"Toggle Infinite ammo", function(ply) return ply:InfiniteAmmo() and "rpa_finiteammo" or "rpa_infiniteammo" end},
	{"Heal", "rpa_heal"},
	{"Kill", "rpa_kill"},
	{"Goto", "rpa_goto"},
	{"Bring", "rpa_bring"},
	{"Teleport", "rpa_tp"},
	{"Edit Inventory", "rpa_editinventory"},
	{"Edit Stash", "rpa_editstash"}
}

GM.Config.ChatRanges = {
	Yell = 800,
	Speak = 400,
	Whisper = 150
}

GM.Config.ChatColors = {
	IC = Color(91, 166, 221),
	Emote = Color(131, 196, 251),
	Radio = Color(72, 118, 255),
	Language = Color(255, 167, 73),
	Yell = Color(255, 50, 50),
	OOC = Color(200, 0, 0),
	LOOC = Color(138, 185, 209),
	Error = Color(200, 0, 0),
	Notice = Color(229, 201, 98),
	AdminName = Color(255, 107, 218),
	AdminText = Color(255, 156, 230),
	Event = Color(0, 191, 255),
	LocalEvent = Color(255, 117, 48),
	PM = Color(160, 255, 160),
	Angry = Color(232, 20, 20)
}

GM.Config.CollectionID 	= 2455349631
GM.Config.Website 		= "https://www.taconbanana.com/"

GM.Config.WorkshopIDs 	= {
	"1557688329",	-- Base Eternity Content
	"1286689434",   -- Base TRP Content
	"760239128",	-- Base TNB Map Textures
	"646312597",	-- Base TNB Map Props
	"193207853",    -- Playermodels (Covenant Jackals)
	"1980598244",   -- Playermodels (Covenant Grunts)
	"1970144865",   -- Playermodels (Covenant Hunters)
	"191109907",    -- Playermodels (Covenant Skirmishers)
	"2089717177",   -- Playermodels (Covenant Elites)
	"803155029",    -- Playermodels (Human Armor Materials)
	"803151001",    -- Playermodels (Human Face Materials)
	"1442193978",   -- Playermodels (Human Insurrectionist)
	"1080572063",   -- Playermodels (Human MilPol/Off-Duty)
	"845272611",    -- Playermodels (Human Marines)
	"850119900",    -- Playermodels (Human ODSTs)
	"1934526858",   -- Playermodels (Human Spartans)
	"173923845",    -- Playermodels (Sci-Fi Citizens Content)
	"173932955",    -- Playermodels (Sci-Fi Citizens Models)
	"842148457",    -- Playermodels (Human New Mombasa Police)
	"842630939",    -- Playermodels (Generic Citizens Czech)
	"323736868",	-- Playermodels (Generic Citizens)
	"1637891551",   -- Props (Covenant Halo 3, Reach)
	"1567705816",   -- Props (UNSC Props)
	"1810299061",   -- Props (UNSC Crows Nest)
	"1810303016",   -- Props (UNSC Halo 3)
	"1832181569",   -- Props (UNSC Halo 3 ODST)
	"1810304039",   -- Props (UNSC Halo 4)
	"1810305449",   -- Props (UNSC Halo Reach)
	"1579080972",   -- Props (Halo Ships)
	"434936477",    -- Props (ODST Drop Pod)
	"284266415",    -- Props (Sci-Fi Megapack)
	"753972615",    -- Props (Halo Reach)
	"1179803937",   -- Props (Halo Reach Tyrant Base)
	"228180741",    -- Props (Halo Reach Tyrant AA Gun)
	"1985215912",   -- Weapons (Human, Covenant)
	"771487490",    -- Simfphys (Base)
	"1640335743",   -- Simfphys (Halo Civilians)
	"831680603",    -- Simfphys (Armed Vehicles)
	"2030882935",   -- Simfphys (Halo Combat Vehicles)
	"2282247789",	-- Simfphys (Halo CE Shared)
	"2439209616",	-- Simfphys (Halo Elephant)
	"1571918906",   -- LFS (Core)
	"1622006977",   -- LFS (VTOL)
	"1637828895",   -- LFS (Halo)
	"1131455085",   -- LFS (Gredwitch's Base)
	"1518144327",   -- WAC (Halo)
	"2137775659",   -- Vehicle (Halo 3 Scarab)
	"242776816",    -- Tools (Advanced Particle Controller)
	"104604943",    -- Tools (Easy Bodygroup Tool)
	"170917418",    -- Tools (Easy Bonemerge Tool)
	"195065185",    -- Tools (Easy Entity Inspector)
	"104603291",    -- Tools (Extended Spawnmenu)
	"264467687",    -- Tools (Improved Stacker)
	"708225419",    -- Tools (Ladder Tool)
	"746600040",    -- Tools (Material Editor)
	"105841291",    -- Tools (More Materials)
	"204771157",    -- Tools (Resurrected Tools GM12)
	"405793043",    -- Tools (Sub-Materials)
	"120629004",    -- Tools (Animated Props)
	"217376234",	-- Tools (Collission Resizer)
}

GM.Config.WorkshopMapIDs = {
	["gm_elongation"] 					= 2040482321,
	["rp_tnb_losangeles"]				= 2079751344,
	["gm_ost"]							= 1770383934,
	["gm_valley"]						= 104483504,
	["rp_clazfort"]						= 2101999243,
	["rp_dust_v2"]						= 478519283,
	["gm_boreas"] 						= 1572373847,
	["rp_ixscifi"] 						= 2057492938,
	["rp_desertfury"] 					= 1423019928,
	["rp_enforcer_cruiser"] 			= 2038392917,
	["rp_ineu_valley_2_v1a"] 			= 232486601,
	["rp_devils_nest_v3_daytime"] 		= 1452350775,
	["rp_devils_nest_v3_nighttime"] 	= 1452350775,
}

GM.Config.ArmorLevels 	= {
	{Mult = 1, Speed = 1},
	{Mult = 0.9, Speed = 1},
	{Mult = 0.8, Speed = 1},
	{Mult = 0.75, Speed = 1}
}

GM.Config.HitGroupMultipliers = {
	[HITGROUP_HEAD] = 1.5,
	[HITGROUP_LEFTLEG] = 0.75,
	[HITGROUP_RIGHTLEG] = 0.75,
	[HITGROUP_GEAR] = 0.75
}

GM.Config.ExamineRange = 1024
GM.Config.InteractRange = 82 -- Source default for +use

GM.Config.EntityRange = {
	Min = 100,
	Max = 256
}

GM.Config.SandboxLimits = {
	[TOOLTRUST_BASIC] = {
		props = 50,
		effects = 10,
		ragdolls = 0
	},
	[TOOLTRUST_ADVANCED] = {
		props = 150,
		effects = 20,
		ragdolls = 3
	}
}

GM.Config.SandboxBlacklist = {
	Props = {
		"models/props_explosive/",
		"models/props_c17/oildrum001_explosive.mdl",
		"models/props_junk/gascan001a.mdl",
		"models/props_junk/propane_tank001a.mdl",
		"models/props_combine/breen_tube.mdl",
		"models/props_combine/combine_bunker01.mdl",
		"models/props_combine/combine_tptimer.mdl",
		"models/props_combine/prison01.mdl",
		"models/props_combine/prison01c.mdl",
		"models/props_combine/prison01b.mdl",
		"models/props_phx/huge/",
		"models/props_phx/misc/",
		"models/props_phx/trains/",
		"models/props_phx/amraam.mdl",
		"models/props_phx/ball.mdl",
		"models/props_phx/mk-82.mdl",
		"models/props_phx/oildrum001_explosive.mdl",
		"models/props_phx/torpedo.mdl",
		"models/props_phx/ww2bomb.mdl",
		"models/valk/h4/unsc/props/landmine/landmine_armed.mdl"

	},
	Entities = {
		"animprop_spawn",
		"item_battery",
		"item_suitcharger"
	}
}

GM.Config.ProtectedEntities = {
	"prop_door_rotating",
	"func_*",
	"prop_dynamic*",
	"class C_BaseEntity"
}

GM.Config.PropRadius = {
	[TOOLTRUST_BASIC] = 200,
	[TOOLTRUST_ADVANCED] = 800
}

GM.Config.ToolTrust = {
	[TOOLTRUST_BASIC] = {
		"weld",
		"camera",
		"physprop",
		"remover",
		"colour",
		"material",
		"submaterial",
		"advmat",
		"nocollideworld"
	},
	[TOOLTRUST_ADVANCED] = {
		"axis",
		"ballsocket",
		"elastic",
		"hydraulic",
		"motor",
		"muscle",
		"pulley",
		"rope",
		"winch",
		"balloon",
		"button",
		"emitter",
		"hoverball",
		"lamp",
		"light",
		"nocollide",
		"thruster",
		"wheel",
		"eyeposer",
		"faceposer",
		"fingerposer",
		"paint",
		"animprop",
		"animprop_gesturizer",
		"particlecontrol",
		"particlecontrol_proj",
		"particlecontrol_tracer",
		"advdupe2",
		"precision",
		"precision_align",
		"weight",
		"stacker_improved"
	}
}

GM.Config.HUDData = {
	Margin = 2,
	Offset = 20
}

GM.Config.NPCSkill = {
	["npc_combine_s"] = WEAPON_PROFICIENCY_VERY_GOOD
}

GM.Config.NPCRelationships = {}

GM.Config.RagdollTimeout = 300

GM.Config.BanRealm = "halo"

GM.Config.StashSize = {4, 3}

GM.Config.DefaultLogs 	= 200
GM.Config.MaxLogs 		= 500

GM.Config.AFKKicker 	= {
	Enabled = false,
	Threshold = 0.90,
	Timer = 600
}

GM.Config.ConsciousnessRate = 0.75

GM.Config.CleanupTimer = 900 -- Seconds

GM.Config.ItemRemappings = {
	-- Insurrection armor
	["armor_insurrection_basic"] = "armor_insurrection",
	["armor_insurrection_bruiser"] = "armor_insurrection",
	["armor_insurrection_marksman"] = "armor_insurrection",
	["armor_insurrection_odst"] = "armor_insurrection",
	["armor_insurrection_recon"] = "armor_insurrection",
	-- Marine armor
	["armor_marine_ax"] = "armor_marine",
	["armor_marine_basic"] = "armor_marine",
	["armor_marine_cqb"] = "armor_marine",
	["armor_marine_recon"] = "armor_marine",
	-- ODST armor
	["armor_odst_ax"] = "armor_odst",
	["armor_odst_basic"] = "armor_odst",
	["armor_odst_bullfrog"] = "armor_odst",
	["armor_odst_cqb"] = "armor_odst",
	["armor_odst_grenadier"] = "armor_odst",
	["armor_odst_recon"] = "armor_odst"
}

GM.Config.PlayerHulls = {
	["models/valk/haloreach/covenant/brute/brute.mdl"] = {
		Standing = {Vector(-20, -20, 0), Vector(20, 20, 86)},
		Crouching = {Vector(-20, -20, 0), Vector(20, 20, 52)},
		ViewOffset = Vector(0, 0, 78),
		DuckedViewOffset = Vector(0, 0, 44)
	},
	["models/valk/haloreach/covenant/characters/grunt/"] = {
		Standing = {Vector(-14, -14, 0), Vector(14, 14, 46)},
		Crouching = {Vector(-14, -14, 0), Vector(14, 14, 36)},
		ViewOffset = Vector(0, 0, 40),
		DuckedViewOffset = Vector(0, 0, 26)
	},
	["models/valk/haloreach/covenant/characters/hunter/hunter_player.mdl"] = {
		Standing = {Vector(-36, -36, 0), Vector(36, 36, 100)},
		Crouching = {Vector(-36, -36, 0), Vector(36, 36, 80)},
		ViewOffset = Vector(0, 0, 80),
		DuckedViewOffset = Vector(0, 0, 64)
	}
}

GM.Config.DropOnDeath = false

GM.Config.PermissionWhitelist = {
	[PERMISSION_VEHICLES_GROUND] = {
		"sim_fphys_halo_mongoosev12", -- H3 goose
		"sim_fphys_halo_mongoosev13", -- Reach goose
		"sim_fphys_halo_warthogh5v6", -- Chaingun hog
		"sim_fphys_halo_warthogh5v11", -- Grenadier hog
		"sim_fphys_halo_warthogh5v1", -- Scout hog
		"sim_fphys_halo_warthogh5_troop", -- Transport hog
		"sim_fphys_halo_eletriccartv2", -- Cart
		"sim_fphys_halo_civilian1", -- Genet
		"sim_fphys_halo_hc1500", -- HC1500
		"sim_fphys_halo_huciv", -- HuCiv HC1500
		"sim_fphys_halo_m850", -- M850
		"sim_fphys_halo_m850cargo", -- M850 cargo
		"sim_fphys_halo_spade", -- Spade
		"sim_fphys_halo_Cart", -- Cart again
		"sim_fphys_halo_CargoTruck", -- HC1500 again
		"sim_fphys_halo_militarytruck", -- Military tractor
		"sim_fphys_halo_militarytruck_Alternate", -- Military tractor (alt)
		"sim_fphys_halo_militarytruck_Cargo", -- Military tractor (cargo)
		"sim_fphys_halo_spade1" -- Spade again
	},
	[PERMISSION_VEHICLES_AIR] = {
		"wac_hc_hornet", -- Gubbins hornet
		"wac_hc_pelican", -- Gubbins pelican
		"wac_hc_falcon", -- Gubbins falcon
		"lunasflightschool_pelicanv1", -- LFS pelican
		"lunasflightschool_hornetv1", -- LFS hornet
		"lunasflightschool_falconv1" -- LFS falcon
	}
}