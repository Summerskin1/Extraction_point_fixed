
if CLIENT then
	include( "cl_derma.lua" )
	include( "cl_colors.lua" )
end
include( "player_class/default.lua" )
include( "player_class/juggernaut.lua" )
include( "player_class/cyber.lua" )
include( "player_class/biotic.lua" )
include( "player_class/eidolon.lua" )
include( "player_class/armored.lua" )
include( "player_class/scout.lua" )
include( "player_class/medic.lua" )
include( "player_class/pointman.lua" )
include( "player_class/commander.lua" )
include( "player_class/tech.lua" )
include( "player_class/grenadier.lua" )
include( "player_class/poltergeist.lua" )
include( "player_class/wisp.lua" )
include( "player_class/operator.lua" )
include( "player_class/lich.lua" )
include( "player_class/vanguard.lua" )

GM.Name = "Extraction Point"
GM.Author = "Cooldown Studios"
GM.Email = "N/A"
GM.Website = "N/A"

GM.TeamBased = True

TEAM_SWAT = 2
TEAM_GHOST = 1
TEAM_SPEC = 3

WIN_UNKNOWN      = 1
WIN_GHOST   = 2
WIN_SWAT  = 3

function GM:CreateTeams()
	team.SetUp(TEAM_SWAT, "SWAT Team", Color(50, 50, 150, 255), true)
	team.SetUp(TEAM_GHOST, "Ghosts", Color(200, 150, 50, 255), true)
	team.SetUp(TEAM_SPEC, "Spectators", Color(200, 200, 200, 255), true)

	team.SetSpawnPoint(TEAM_SWAT,  {"info_player_terrorist"})
	team.SetSpawnPoint(TEAM_GHOST, {"info_player_counterterrorist"})
	--team.SetSpawnPoint(TEAM_SPEC, {"info_player_deathmatch", "info_player_terrorist", "info_player_counterterrorist"})
end