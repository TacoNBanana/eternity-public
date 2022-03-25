SPECIES_HUMAN 		= 1
SPECIES_VORTIGAUNT 	= 2
SPECIES_OVERWATCH 	= 3
SPECIES_XEN 		= 4

STORE_NONE 			= 0
STORE_PLAYER 		= 1
STORE_ITEM 			= 2
STORE_CONTAINER 	= 3
STORE_WORLD 		= 4
STORE_STASH 		= 5

EQUIPMENT_TO_TEXT 	= {}

local equipment 	= 1

local function AddEquipment(var, name)
	var = "EQUIPMENT_" .. var

	_G[var] = equipment
	_G.EQUIPMENT_TO_TEXT[equipment] = name

	equipment = equipment + 1
end

-- !IMPORTANT! Fucking with the ordering WILL break stuff, don't remove slots here, remove them from the species and don't touch them otherwise
AddEquipment("HEAD", "Headgear")
AddEquipment("TORSO", "Torso")
AddEquipment("BACK", "Backpack")
AddEquipment("LEGS", "Legs")

AddEquipment("GLOVES", "Gloves")

AddEquipment("PRIMARY", "Primary")
AddEquipment("SECONDARY", "Sidearm")

AddEquipment("ID", "ID")
AddEquipment("RADIO", "Radio")

AddEquipment("OVERWATCH", "Uniform")

AddEquipment("VORTS", "Clothing")
AddEquipment("BROOM", "Broom")

AddEquipment("XEN", "Species")

AddEquipment("MISC", "Misc")

TEAMS = {}

local teams 		= 1

local function AddTeam(var, name, color, hidden)
	var = "TEAM_" .. var

	_G[var] = teams
	_G.TEAMS[teams] = {Name = name, Color = color, Hidden = hidden or false}

	teams = teams + 1
end

AddTeam("CITIZEN", "Citizens", Color(0, 120, 0))
AddTeam("COMBINE", "Combine", Color(33, 106, 196))
AddTeam("VORTIGAUNT", "Vortigaunt", Color(65, 204, 118))
AddTeam("OVERWATCH", "Overwatch", Color(222, 92, 0))
AddTeam("ADMIN", "Civil Administration", Color(223, 22, 22))
AddTeam("LOYALIST", "Loyalists", Color(0, 191, 255))
AddTeam("XEN", "Xenians", Color(180, 220, 32))
AddTeam("UNKNOWN", "Unknown", Color(182, 182, 182), true)

LANGUAGES = {}

local languages = 1

local function AddLanguage(command, name, unknown)
	local var = "LANG_" .. string.upper(command)

	_G[var] = languages
	_G.LANGUAGES[languages] = {Command = command, Name = name, Unknown = unknown}

	languages = languages + 1
end

LANG_NONE = 0

-- !IMPORTANT! Any changes made to this list will be reflected in-game, e.g. replacing German with something else will convert all existing german speakers to that language
AddLanguage("eng", "English")
AddLanguage("rus", "Russian")
AddLanguage("vort", "Vortigese", "a strange language")
AddLanguage("ger", "German")
AddLanguage("fre", "French")
AddLanguage("spa", "Spanish")
AddLanguage("ita", "Italian")
AddLanguage("kor", "Korean")
AddLanguage("jap", "Japanese")
AddLanguage("chi", "Chinese")
AddLanguage("pol", "Polish")
AddLanguage("ukr", "Ukrainian")
AddLanguage("sca", "Scandinavian")
AddLanguage("tur", "Turkish")
AddLanguage("ara", "Arabic")

GENDER_MALE 		= 1
GENDER_FEMALE 		= 2
GENDER_OTHER 		= 3

DOOR_NOCONFIG 		= 0
DOOR_PUBLIC 		= 1
DOOR_BUYABLE 		= 2
DOOR_COMBINE 		= 3
DOOR_IGNORED 		= 4

DOORS 				= {
	[DOOR_PUBLIC] = "Public",
	[DOOR_BUYABLE] = "Buyable",
	[DOOR_COMBINE] = "Combine",
	[DOOR_IGNORED] = "Ignored"
}

PERMISSIONS = {}

local permissions = 1

local function AddPermission(perm, name)
	local var = "PERMISSION_" .. string.upper(perm)

	_G[var] = permissions
	_G.PERMISSIONS[permissions] = {Name = name}

	permissions = permissions + 1
end

-- !IMPORTANT! Removing entries will shift everyone's permissions
AddPermission("doors_basic", "Primary Access")
AddPermission("edit_records", "Edit Records")
AddPermission("assignment", "Permission Assignment")
AddPermission("security", "Security Assignment")
AddPermission("id", "ID Management")
AddPermission("doors_external", "External Access")
AddPermission("maintenance", "Equipment Maintenance")
AddPermission("surveillance", "Surveillance")
AddPermission("view_records", "External Record Access")
AddPermission("apc_driver", "APC Driver Access")

BADGES = {}

local badges = 1

local function AddBadge(badge, name, material)
	local var = "BADGE_" .. string.upper(badge)

	_G[var] = badges
	_G.BADGES[badges] = {Badge = badge, Name = name, Material = material}

	badges = badges + 1
end

AddBadge("contributor_bronze", "Early Contributor (Bronze)", Material("icon16/award_star_bronze_1.png"))
AddBadge("contributor_silver", "Early Contributor (Silver)", Material("icon16/award_star_silver_1.png"))
AddBadge("contributor_gold", "Early Contributor (Gold)", Material("icon16/award_star_gold_1.png"))

LICENSES = {}

local licenses = 1

local function AddLicense(license, name, price)
	local var = "LICENSE_" .. string.upper(license)

	_G[var] = licenses
	_G.LICENSES[licenses] = {License = license, Name = name, Price = price}

	licenses = licenses + 1
end

AddLicense("food", "Food/Drinks", 500)
AddLicense("clothing", "Clothing", 600)
AddLicense("electronics", "Electronics (WIP)", 1000)
AddLicense("misc", "Miscellaneous (WIP)", 400)
AddLicense("grey", "Grey Market")
AddLicense("black", "Black Market")

SCK_MODEL 	= 1
SCK_SPRITE 	= 2
SCK_QUAD 	= 3
SCK_LASER 	= 4

-- ID's in this list can be created by units
IDTYPES = {
	["id_citizen"] = "Citizen",
	["id_ca"] = "Civil Administration",
	["id_unit"] = "Unit",
	["id_loyalist"] = "Loyalist"
}

TOOLTRUST_BANNED 	= -1
TOOLTRUST_BASIC 	= 0
TOOLTRUST_ADVANCED 	= 1

HPTYPE_BAR 			= 1
HPTYPE_HEARTBEAT 	= 2

ITEMTYPE_LABEL 		= 1
ITEMTYPE_GLOW 		= 2
ITEMTYPE_BOTH 		= 3

AMMOTYPE_SINGLE 	= 1
AMMOTYPE_DOUBLE 	= 2

FIRETYPE_MODE 		= 1
FIRETYPE_AMMO 		= 2
FIRETYPE_BOTH 		= 3

USERGROUP_USER 			= 0
USERGROUP_PLAYER 		= 0
USERGROUP_ADMIN 		= 1
USERGROUP_SA 			= 2
USERGROUP_SUPERADMIN 	= 2
USERGROUP_DEV 			= 3
USERGROUP_DEVELOPER 	= 3

USERGROUPS 				= {
	[USERGROUP_PLAYER] 		= "Player",
	[USERGROUP_ADMIN] 		= "Admin",
	[USERGROUP_SUPERADMIN] 	= "Superadmin",
	[USERGROUP_DEV] 		= "Developer",
}

CFLAG_CHECKIMMUNITY 		= 1
CFLAG_FORCESINGLETARGET 	= 2
CFLAG_NOSELFTARGET 			= 3
CFLAG_FORCENICK 			= 4
CFLAG_NOCONSOLE 			= 5
CFLAG_NOADMIN 				= 6

-- Clear indicates that the channel can be used without a biosignal active
CHANNELS = {
	{Name = "GLOBAL", Frequency = 1000},
	{Name = "TAC-1", Frequency = 1001},
	{Name = "TAC-2", Frequency = 1002},
	{Name = "TAC-3", Frequency = 1003},
	{Name = "TAC-4", Frequency = 1004},
	{Name = "EXT-CA", Frequency = 1005, Clear = true}
}

CHATINDICATOR_NONE = 0
CHATINDICATOR_TYPING = 1
CHATINDICATOR_RADIOING = 2

-- These indexes map to the enums just above
CHATINDICATORS = {
	"Typing...",
	"Radioing..."
}

LOG_NONE 		= 0
LOG_SECURITY 	= 1
LOG_SANDBOX 	= 2
LOG_ITEMS 		= 3
LOG_CHARACTER 	= 4
LOG_CHAT 		= 5
LOG_ADMIN 		= 6
LOG_DEVELOPER 	= 7

META_CHAR 	= 1
META_ITEM 	= 2
META_PLY 	= 3

PERMAPROP_CLASSES = {
	["prop_physics"] = true,
	["prop_effect"] = true
}

SEEALL_PROPS_NEVER 	= 1
SEEALL_PROPS_PHYS 	= 2
SEEALL_PROPS_ALWAYS = 3

PHYSGUNMODE_DEFAULT 			= 1
PHYSGUNMODE_CUSTOM 				= 2
PHYSGUNMODE_RAINBOW_CLASSIC 	= 3
PHYSGUNMODE_RAINBOW_NEW 		= 4

PROPOWNER_NAME 		= 1
PROPOWNER_STEAMID 	= 2
PROPOWNER_BOTH 		= 3

TAB_LOOC 	= 2^1
TAB_OOC 	= 2^2
TAB_IC 		= 2^3
TAB_ADMIN 	= 2^4
TAB_PM 		= 2^5
TAB_RADIO 	= 2^6

ARMOR_NONE 	= 0
ARMOR_LIGHT = 1
ARMOR_HEAVY = 2
ARMOR_COTA 	= 3

-- D_NU: Will only fire if their equipment has ITEM.TriggersNPCs
-- D_LI: Don't fire unless they piss us off first
-- D_HT: Kill

RELATIONSHIP_COMBINE = {
	[TEAM_CITIZEN] = D_NU,
	[TEAM_COMBINE] = D_LI,
	[TEAM_VORTIGAUNT] = D_NU,
	[TEAM_OVERWATCH] = D_LI,
	[TEAM_ADMIN] = D_NU,
	[TEAM_LOYALIST] = D_NU,
	[TEAM_XEN] = D_HT
}

RELATIONSHIP_COMBINE_HOSTILE = {
	[TEAM_CITIZEN] = D_HT,
	[TEAM_COMBINE] = D_LI,
	[TEAM_VORTIGAUNT] = D_HT,
	[TEAM_OVERWATCH] = D_LI,
	[TEAM_ADMIN] = D_HT,
	[TEAM_LOYALIST] = D_HT,
	[TEAM_XEN] = D_HT
}

RELATIONSHIP_REBELS = {
	[TEAM_CITIZEN] = D_LI,
	[TEAM_COMBINE] = D_HT,
	[TEAM_VORTIGAUNT] = D_LI,
	[TEAM_OVERWATCH] = D_HT,
	[TEAM_ADMIN] = D_NU,
	[TEAM_LOYALIST] = D_NU,
	[TEAM_XEN] = D_HT
}

RELATIONSHIP_XEN = {
	[TEAM_CITIZEN] = D_HT,
	[TEAM_COMBINE] = D_HT,
	[TEAM_VORTIGAUNT] = D_HT,
	[TEAM_OVERWATCH] = D_HT,
	[TEAM_ADMIN] = D_HT,
	[TEAM_LOYALIST] = D_HT,
	[TEAM_XEN] = D_LI
}

THROW_NORMAL 	= 1
THROW_ROLL 		= 2
THROW_LOB 		= 3