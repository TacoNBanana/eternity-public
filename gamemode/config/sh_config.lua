GM.Config.ServerName = "Eternity: Half Life 2 Roleplay"

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

GM.Config.AllowedCharacters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ áàâäçéèêëíìîïóòôöúùûüÿÁÀÂÄßÇÉÈÊËÍÌÎÏÓÒÔÖÚÙÛÜŸ'-"
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

GM.Config.OverwatchName = "COTA.UNASSIGNED.$id"
GM.Config.VortigauntName = "UU.C45-SERVITOR.$id"

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

GM.Config.CollectionID 	= 1548600554
GM.Config.Website 		= "https://www.taconbanana.com/"

GM.Config.WorkshopIDs 	= {}

GM.Config.ArmorLevels 	= {
	{Mult = 1, Speed = 1},
	{Mult = 0.9, Speed = 0.9},
	{Mult = 0.8, Speed = 0.9},
	{Mult = 0.75, Speed = 0.8}
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
		"models/props_phx/ww2bomb.mdl"

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
		"weight",
		"streamradio",
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

GM.Config.NPCRelationships = {
	["npc_turret_ceiling"] = RELATIONSHIP_COMBINE_HOSTILE,
	["npc_combinegunship"] = RELATIONSHIP_COMBINE_HOSTILE,
	["npc_hunter"] = RELATIONSHIP_COMBINE_HOSTILE,
	["npc_helicopter"] = RELATIONSHIP_COMBINE_HOSTILE,
	["npc_manhack"] = RELATIONSHIP_COMBINE_HOSTILE,
	["npc_rollermine"] = RELATIONSHIP_COMBINE_HOSTILE,
	["npc_clawscanner"] = RELATIONSHIP_COMBINE_HOSTILE,
	["npc_strider"] = RELATIONSHIP_COMBINE_HOSTILE,
	["npc_turret_floor"] = RELATIONSHIP_COMBINE_HOSTILE,

	["npc_combine_camera"] = RELATIONSHIP_COMBINE,
	["npc_combine_s"] = RELATIONSHIP_COMBINE,
	["npc_cscanner"] = RELATIONSHIP_COMBINE,
	["npc_metropolice"] = RELATIONSHIP_COMBINE,
	["npc_stalker"] = RELATIONSHIP_COMBINE,
	["npc_breen"] = RELATIONSHIP_COMBINE,

	["npc_alyx"] = RELATIONSHIP_REBELS,
	["npc_barney"] = RELATIONSHIP_REBELS,
	["npc_citizen"] = RELATIONSHIP_REBELS,
	["npc_dog"] = RELATIONSHIP_REBELS,
	["npc_magnusson"] = RELATIONSHIP_REBELS,
	["npc_kleiner"] = RELATIONSHIP_REBELS,
	["npc_mossman"] = RELATIONSHIP_REBELS,
	["npc_eli"] = RELATIONSHIP_REBELS,
	["npc_fisherman"] = RELATIONSHIP_REBELS,
	["npc_vortigaunt"] = RELATIONSHIP_REBELS,
	["npc_monk"] = RELATIONSHIP_REBELS,

	["npc_antlion"] = RELATIONSHIP_XEN,
	["npc_antlion_grub"] = RELATIONSHIP_XEN,
	["npc_antlionguard"] = RELATIONSHIP_XEN,
	["npc_antlionguardian"] = RELATIONSHIP_XEN,
	["npc_antlion_worker"] = RELATIONSHIP_XEN,
	["npc_barnacle"] = RELATIONSHIP_XEN,
	["npc_headcrab_fast"] = RELATIONSHIP_XEN,
	["npc_fastzombie"] = RELATIONSHIP_XEN,
	["npc_fastzombie_torso"] = RELATIONSHIP_XEN,
	["npc_headcrab"] = RELATIONSHIP_XEN,
	["npc_headcrab_black"] = RELATIONSHIP_XEN,
	["npc_poisonzombie"] = RELATIONSHIP_XEN,
	["npc_zombie"] = RELATIONSHIP_XEN,
	["npc_zombie_torso"] = RELATIONSHIP_XEN,
	["npc_zombine"] = RELATIONSHIP_XEN
}

GM.Config.RagdollTimeout = 300

GM.Config.BanRealm = "hl2"

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

GM.Config.ItemRemappings = {}

GM.Config.PlayerHulls = {
	["models/headcrabclassic.mdl"] = {Vector(-12, -12, 0), Vector(12, 12, 24), Vector(0, 0, 12)},
	["models/headcrab.mdl"] = {Vector(-12, -12, 0), Vector(12, 12, 24), Vector(0, 0, 12)},
	["models/headcrabblack.mdl"] = {Vector(-12, -12, 0), Vector(12, 12, 24), Vector(0, 0, 10)},
	["models/zombie/classic_torso.mdl"] = {Vector(-12, -12, 0), Vector(12, 12, 24), Vector(0, 0, 18)},
	["models/antlion.mdl"] = {Vector(-18, -18, 0), Vector(18, 18, 36), Vector(0, 0, 32)},
	["models/antlion_worker.mdl"] = {Vector(-18, -18, 0), Vector(18, 18, 36), Vector(0, 0, 32)},
	["models/antlion_guard.mdl"] = {Vector(-40, -40, 0), Vector(40, 40, 100), Vector(0, 0, 80)}
}

GM.Config.DurabilityMultiplier = 5

GM.Config.DropOnDeath = false
