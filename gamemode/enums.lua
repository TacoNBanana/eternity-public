SPECIES_HUMAN 		= 1
SPECIES_SPARTAN 	= 2
SPECIES_GRUNT 		= 4
SPECIES_ELITE 		= 5
SPECIES_JACKAL 		= 6
SPECIES_SKIRMISHER 	= 7
SPECIES_HUNTER 		= 8
SPECIES_BRUTE 		= 9

STORE_NONE 			= 0
STORE_PLAYER 		= 1
STORE_ITEM 			= 2
STORE_CONTAINER 	= 3
STORE_WORLD 		= 4
STORE_STASH 		= 5

EQUIPMENT_TO_TEXT 	= {}

local function AddEquipment(id, var, name)
	var = "EQUIPMENT_" .. var

	_G[var] = id
	_G.EQUIPMENT_TO_TEXT[id] = name
end

AddEquipment(1, "UNDERSUIT", "Undersuit")
AddEquipment(2, "HEAD", "Headgear")

AddEquipment(3, "TORSO", "Armor")

AddEquipment(5, "BACK", "Backpack")

AddEquipment(6, "PRIMARY", "Primary")
AddEquipment(7, "SECONDARY", "Sidearm")

AddEquipment(8, "ID", "ID")
AddEquipment(9, "RADIO", "Radio")

AddEquipment(13, "ARMOR", "Armor")

AddEquipment(14, "MISC", "Misc")

TEAMS = {}

local teams 		= 1

local function AddTeam(var, name, color, hidden)
	var = "TEAM_" .. var

	_G[var] = teams
	_G.TEAMS[teams] = {Name = name, Color = color, Hidden = hidden or false}

	teams = teams + 1
end

AddTeam("UNSC", "UNSC", Color(0, 120, 0))
AddTeam("AI", "Artifical Intelligence", Color(0, 191, 255))
AddTeam("SPARTAN", "SPARTAN-III", Color(33, 106, 196))
AddTeam("INSURRECTION", "Insurrection", Color(255, 0, 0))
AddTeam("COVENANT", "Covenant", Color(110, 76, 170))

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
AddLanguage("covenant", "Sangheili", "an alien language")
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
AddLanguage("hun", "Hungarian")

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

local function AddPermission(id, perm, name)
	local var = "PERMISSION_" .. string.upper(perm)

	_G[var] = id
	_G.PERMISSIONS[id] = {Name = name, Perm = perm}
end

AddPermission(1, "events", "Event")
AddPermission(2, "vehicles_ground", "Ground vehicle spawning")
AddPermission(3, "vehicles_air", "Air vehicle spawning")
AddPermission(4, "permaprops", "Permaprop")

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

AddLicense("qm", "Quartermaster")

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

CHANNELS = {
	{Name = "LONG-RANGE", Frequency = 1000}
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

ARMOR_NONE 		= 0
ARMOR_LIGHT 	= 1
ARMOR_HEAVY 	= 2
ARMOR_MASSIVE 	= 3

-- D_NU: Will only fire if their equipment has ITEM.TriggersNPCs
-- D_LI: Don't fire unless they piss us off first
-- D_HT: Kill

RELATIONSHIP_UNSC = {
	[TEAM_UNSC] = D_LI,
	[TEAM_SPARTAN] = D_LI,
	[TEAM_COVENANT] = D_HT,
}

RELATIONSHIP_COVENANT = {
	[TEAM_UNSC] = D_HT,
	[TEAM_SPARTAN] = D_HT,
	[TEAM_COVENANT] = D_LI,
}

THROW_NORMAL 	= 1
THROW_ROLL 		= 2
THROW_LOB 		= 3

EXPLOSION_SPNKR = 1
EXPLOSION_40MM 	= 2