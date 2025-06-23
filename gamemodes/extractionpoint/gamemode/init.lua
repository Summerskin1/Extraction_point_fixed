AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_hud.lua" )
AddCSLuaFile( "cl_scoreboard.lua" )
AddCSLuaFile( "cl_derma.lua" )
AddCSLuaFile( "cl_colors.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "player_class/default.lua" )
AddCSLuaFile( "player_class/juggernaut.lua" )
AddCSLuaFile( "player_class/cyber.lua" )
AddCSLuaFile( "player_class/biotic.lua" )
AddCSLuaFile( "player_class/eidolon.lua" )
AddCSLuaFile( "player_class/scout.lua" )
AddCSLuaFile( "player_class/armored.lua" )
AddCSLuaFile( "player_class/medic.lua" )
AddCSLuaFile( "player_class/tech.lua" )
AddCSLuaFile( "player_class/pointman.lua" )
AddCSLuaFile( "player_class/commander.lua" )
AddCSLuaFile( "player_class/grenadier.lua" )
AddCSLuaFile( "player_class/poltergeist.lua" )
AddCSLuaFile( "player_class/wisp.lua" )
AddCSLuaFile( "player_class/operator.lua" )
AddCSLuaFile( "player_class/lich.lua" )
AddCSLuaFile( "player_class/vanguard.lua" )


--HUD Materials
resource.AddFile( "materials/VGUI/ammo_icons/hud_ammo_clip_empty.vmt" )
resource.AddFile( "materials/VGUI/ammo_icons/hud_ammo_clip_full.vmt" )

--Sounds!
resource.AddFile( "sound/ep/ghost_relay_defend.mp3" )
resource.AddFile( "sound/ep/ghost_relay_dropped.mp3" )
resource.AddFile( "sound/ep/ghost_relay_extracted.mp3" )
resource.AddFile( "sound/ep/ghost_relay_taken.mp3" )
resource.AddFile( "sound/ep/swat_relay_defend.mp3" )
resource.AddFile( "sound/ep/swat_relay_dropped.mp3" )
resource.AddFile( "sound/ep/swat_relay_extracted.mp3" )
resource.AddFile( "sound/ep/swat_relay_taken.mp3" )
resource.AddFile( "sound/ep/swat_relay_moveout.mp3" )

include( "shared.lua" )
include( "player_ext.lua" )
include( "player.lua" )

DEFINE_BASECLASS( "gamemode_base" )

local player = player

local slot1 = 0
local slot2 = 0
local slot3 = 0
local slot4 = 0

ROUND_WAIT = 0
ROUND_PREP = 1
ROUND_PLAY = 2
ROUND_POST = 3

GM.RoundState = ROUND_WAIT

GM.NumRounds = 1
GM.MaxRounds = 16 -- 16 rounds until mapchange, alter this line if you want longer/shorter maps!
GM.RoundTime = 0
GM.MaxTime	= 240
GM.LastTime	= 0

GM.Standard = true

function GM:Initialize()
	MsgN("Initialising Extraction Point")

	--Run initial console commands for setup.
	RunConsoleCommand("mp_friendlyfire", "1")
	GAMEMODE.round_state = ROUND_WAIT
end

function GM:Tick()
	GAMEMODE.RoundTime = GAMEMODE.RoundTime+(CurTime()-GAMEMODE.LastTime)
	GAMEMODE.LastTime = CurTime()
	for k,v in pairs (player.GetAll()) do
		v:ConCommand("ep_roundtimer "..math.floor(GAMEMODE.MaxTime-GAMEMODE.RoundTime).." "..GAMEMODE.NumRounds)
	end
	if GAMEMODE.RoundState == ROUND_WAIT then
		--Once we have >1 player, begin the round.
		if (!timer.Exists("newround") and table.Count(player.GetAll()) > 0) then
			timer.Create( "newround", 2, 1, function()
						PrintMessage( HUD_PRINTTALK,"New round will prep in 2 seconds!")
						PrepRound()
			end)
		end
	end

	if GAMEMODE.RoundState == ROUND_PREP then
		--Do nothing in round prep.
	end

	if GAMEMODE.RoundState == ROUND_PLAY then

	end

	if GAMEMODE.RoundState == ROUND_POST then

	end

end

function UpdateRoundState(state)
	--Eventually we'll send an update to the clients that the round has changed to update hud elements etc.
end

function SetRoundState(state)
	GAMEMODE.round_state = state
	UpdateRoundState(state)
end

function StartRound()
	if GAMEMODE.NumRounds >= GAMEMODE.MaxRounds then
		PrintMessage( HUD_PRINTTALK,"Changing map to ".. game.GetMapNext( ))
		ScoreRound()
		--game.LoadNextMap()
	else
		GAMEMODE.RoundTime = 0
		slot1 = math.random(1,4)
		slot2 = math.random(1,4)
		slot3 = math.random(1,4)
		slot4 = math.random(1,4)

		local players = player.GetAll()
		local goodplayers = {}
		local numplayers = 0
		for k,v in pairs(players) do
			v.gArray = v.gArray or {}
			v.sArray = v.sArray or {}
			print(v.gArray)
			if CheckPunish(v) then
				numplayers = numplayers+1
				if v:Team() != TEAM_SPEC then
					table.insert(goodplayers,v)
				end
			else
				DecrementPunish(v)
				print(v:Nick().." missed a round as punishment.")
			end
		end
		numghosts = math.ceil(numplayers/4)
		for k, ply in RandomPairs(goodplayers) do
			if numghosts > 0 then
				ply:SetTeam(TEAM_GHOST)
				numghosts = numghosts - 1
				ply:SendLua( 'surface.PlaySound("ep/ghost_relay_defend.mp3")' )
				ply.gRounds = (ply.gRounds or 0) + 1
				ply.runTotal = ply:Frags()
			else
				ply:SetTeam(TEAM_SWAT)
				ply:SendLua( 'surface.PlaySound("ep/swat_relay_moveout.mp3")' )
				ply.sRounds = (ply.sRounds or 0) + 1
				ply.runTotal = ply:Deaths()
			end
			ply:KillSilent()
			ply:Spawn()
		end

		GAMEMODE.RoundState = ROUND_PLAY

	end
	timer.Create( "roundover", 1, 0, function()
		if RoundOver() then
			GAMEMODE.RoundState = ROUND_POST
			timer.Create( "postround", 5, 1, function()
				GAMEMODE.RoundState = ROUND_WAIT
				GAMEMODE.NumRounds = GAMEMODE.NumRounds+1
				PrintMessage( HUD_PRINTTALK, "Round "..GAMEMODE.NumRounds.." of "..GAMEMODE.MaxRounds )
			end)
			for k,v in pairs(player.GetAll()) do
				if v:Team() == TEAM_GHOST then
					v.ghostScore = v.ghostScore or 0
					v.ghostClass = v.ghostClass or "player_eidolon"
					if v.runTotal then
						if v:Frags()-v.runTotal > v.ghostScore then
							v.ghostClass = player_manager.GetPlayerClass(v)
							v.ghostScore = v:Frags()-v.runTotal
						end
					end
				end
				if v:Team() == TEAM_SWAT then
					v.swatScore = v.swatScore or 0
					v.swatClass = v.swatClass or "player_armored"
					if v.runTotal then
						if v:Deaths()-v.runTotal > v.swatScore then
							v.swatClass = player_manager.GetPlayerClass(v)
							v.swatScore = v:Deaths()-v.runTotal
						end
					end
				end
			end
		end
	end)
end

function ScoreRound()
	GAMEMODE.RoundState = ROUND_SCORE
	for k,v in pairs (player.GetAll()) do
		v:KillSilent()
		v:ConCommand("r_cleardecals")
	end
	best = nil
	bestscore = -1
	ghost = nil
	ghostscore = -1
	swat = nil
	swatscore = -1
	for k,v in pairs (player.GetAll()) do
		if v:Frags()+v:Deaths() > bestscore then
			bestscore = v:Frags()+v:Deaths()
			best = v
		end
	end
	for k,v in pairs (player.GetAll()) do
		if v != best then
			if v:Frags()/math.Clamp(v.gRounds or 1,1,50000) > ghostscore then
				ghostscore = v:Frags()
				ghost = v
			end
		end
	end
	for k,v in pairs (player.GetAll()) do
		if v != best and v != ghost then
			if v:Deaths()/math.Clamp(v.sRounds or 1,1,50000) > swatscore then
				swatscore = v:Deaths()
				swat = v
			end
		end
	end
	local besttot = best:Frags()+best:Deaths()
	if ghost then
	print (ghostscore)
		ghost:SetTeam(TEAM_GHOST)
		ghost:Spawn()
		player_manager.SetPlayerClass( ghost, ghost.ghostClass or "player_eidolon" )
		ghost:SetMaterial( )
		player_manager.RunClass( ghost, "Loadout" )
		--find best gun
		local bestdmg = 0
		local bestname = "weapon_ep_prism"
		for k,v in pairs (ghost.gArray) do
			if v > bestdmg then
				bestdmg = v
				bestname = k
			end
		end
		ghost:Give(bestname)
		ghost:SetActiveWeapon(ghost:GetWeapon(bestname))
	end

	if swat then
		print (swatscore)
		swat:SetTeam(TEAM_SWAT)
		swat:Spawn()
		player_manager.SetPlayerClass( swat, swat.swatClass or "player_commander" )
		swat:SetMaterial( )
		player_manager.RunClass( swat, "Loadout" )
		--find best gun
		local bestdmg = 0
		local bestname = "weapon_ep_rpg"
		for k,v in pairs(swat.sArray) do
			if v > bestdmg then
				bestdmg = v
				bestname = k
			end
		end
		swat:Give(bestname)
		swat:SetActiveWeapon(swat:GetWeapon(bestname))
	end
	if best:Frags() > best:Deaths() then
		best:SetTeam(TEAM_GHOST)
		best:Spawn()
		player_manager.SetPlayerClass( best, best.ghostClass or "player_eidolon" )
	else
		best:SetTeam(TEAM_SWAT)
		best:Spawn()
		player_manager.SetPlayerClass( best, best.swatClass or "player_commander" )
	end
	best:SetMaterial( )
	player_manager.RunClass( best, "Loadout" )
		--find best gun
	local bestdmg = 0
	local bestname = "weapon_ep_prism"
	local combinedarray = {}
	table.Merge( combinedarray, best.gArray )
	table.Merge( combinedarray, best.sArray )
	PrintTable(combinedarray)
	for k,v in pairs (combinedarray) do
		if v > bestdmg then
			bestdmg = v
			bestname = k
		end
	end
	best:Give(bestname)
	best:SetActiveWeapon(best:GetWeapon(bestname))
	--Spawn the relay
	local objectives = ents.FindByClass( "info_player_counterterrorist" )
	if table.Count(objectives) == 0 then
		objectives = ents.FindByClass( "info_player_terrorist" )
	end
	if table.Count(objectives) == 0 then
		PrintMessage( HUD_PRINTTALK,"WARNING: No objective points found on this map, are you running a CS or DE Map?\nDue to lack of objectives, gamemode has fallen back to last team standing.")
	else

		local objective = table.Random(objectives)
		local mins, maxs = objective:WorldSpaceAABB();
		local pos = ( mins + maxs ) * 0.5;
		best:SetAngles(Angle(0,-90,0)-best:GetAimVector():Angle())
		best:SetPos(pos+Vector(0,0,0))
		if ghost then
			ghost:SetAngles(Angle(0,-90,0)-ghost:GetAimVector():Angle())
			ghost:SetPos(pos+Vector(20,-20,0))
		end
		if swat then
			swat:SetAngles(Angle(0,-90,0)-swat:GetAimVector():Angle())
			swat:SetPos(pos+Vector(-20,-20,0))
		end
	end
	timer.Create( "scoreboard", 0.1, 1, function()
		if ghost then
			ghost:SetAngles(Angle(0,90-40,0))
			ghost:SetEyeAngles(Angle(0,90-20,0))
			ghost:Lock()
			ghost:SetAnimation(ACT_HL2MP_IDLE_CROUCH)
		end
		if swat then
			swat:SetAngles(Angle(0,90+40,0))
			swat:SetEyeAngles(Angle(0,90+20,0))
			swat:Lock()
			swat:SetAnimation(ACT_HL2MP_IDLE_CROUCH)
		end
		best:SetAngles(Angle(0,90,0))
		best:SetEyeAngles(Angle(0,90,0))
		if best:SteamID() != "STEAM_0:0:6123553" && best:SteamID() != "STEAM_0:0:20053069" then
			best:Lock()
		end
		for k,v in pairs (player.GetAll()) do
			if swat and ghost then
				v:ConCommand("ep_finalscoreboard "..best:UniqueID().." "..ghost:UniqueID().." "..swat:UniqueID())
			elseif swat then
			v:ConCommand("ep_finalscoreboard "..best:UniqueID().." "..swat:UniqueID())
			elseif ghost then
			v:ConCommand("ep_finalscoreboard "..best:UniqueID().." "..ghost:UniqueID())
			else
			v:ConCommand("ep_finalscoreboard "..best:UniqueID())
			end
			v:ConCommand("ep_scorecam")
		end
	end)
	timer.Create( "mapover", 10, 1, function()
		for k,v in pairs (player.GetAll()) do
			v:Freeze(false)
		end
		game.LoadNextMap()
	end)
end

function PrepRound()
	--Begin the round
	--Builtin cleanup incase we missed anything..
	game.CleanUpMap()
	--Cleanup relays
	local relays = ents.FindByClass( "ep_relay" )
	for k,v in pairs (relays) do
		v:Remove()
	end
	local relaymarkers = ents.FindByClass( "ep_relay_marker" )
	for k,v in pairs (relaymarkers) do
		v:Remove()
	end

	--Cleanup pesky players
	for k,v in pairs (player.GetAll()) do
		v:KillSilent()
		v:ConCommand("r_cleardecals")

	end

	--Spawn the relay
	GAMEMODE.Standard = true

	local objectives = ents.FindByClass( "func_bomb_target" )
	if table.Count(objectives) == 0 then
		objectives = ents.FindByClass( "func_hostage_rescue" )
		GAMEMODE.Standard = true
		if table.Count(objectives) > 0 then
			GAMEMODE.Standard = false
		end
	end
	if table.Count(objectives) == 0 then
		PrintMessage( HUD_PRINTTALK,"WARNING: No objective points found on this map, are you running a CS or DE Map?\nDue to lack of objectives, gamemode has fallen back to last team standing.")
	else
		if GAMEMODE.Standard then
			local objective = table.Random(objectives)
			local relay = ents.Create("ep_relay")
			local mins, maxs = objective:WorldSpaceAABB();
			local pos = ( mins + maxs ) * 0.5;
			relay:SetPos(pos)
			relay:Spawn()
			for k,v in pairs(objectives) do
				local relaym = ents.Create("ep_relay_marker")
				local mins, maxs = v:WorldSpaceAABB();
				local pos = ( mins + maxs ) * 0.5;
				relaym:SetPos(pos)
				relaym:Spawn()
			end
			--Spawn the extraction point
			local extractions = ents.FindByClass( "info_player_terrorist" )
			local extraction = table.Random(extractions)
			local goal = ents.Create("ep_extraction")
			local mins, maxs = extraction:WorldSpaceAABB();
			local pos = ( mins + maxs ) * 0.5;
			goal:SetPos(pos)
			goal:Spawn()

			--the heli
			local heli = ents.Create("ep_extraction_heli")
			local mins, maxs = extraction:WorldSpaceAABB();
			local pos = ( mins + maxs ) * 0.5;
			heli.hoverpos = pos + Vector(0,0, 356)
			heli:SetPos(pos + Vector(0,0, 356))
			heli:Spawn()
			heli:Activate()
		else
			--Spawn the extraction point
			local extractions = ents.FindByClass( "func_hostage_rescue" )
			local extraction = table.Random(extractions)
			local goal = ents.Create("ep_csextraction")
			local mins, maxs = extraction:WorldSpaceAABB();
			local pos = ( mins + maxs ) * 0.5;
			pos.z = mins.z
			goal:SetPos(pos)
			goal:Spawn()

			--the APC
			--local apc = ents.Create("ep_extraction_apc")
			--local mins, maxs = extraction:WorldSpaceAABB();
			--local pos = ( mins + maxs ) * 0.5;
			--pos.z = mins.z - 10
			--apc:SetPos(pos)
			--apc:SetAngles(Angle(0,math.Rand(-90,90),0))
			--apc:Spawn()
			--apc:Activate()
		end
	end

	GAMEMODE.RoundState = ROUND_PREP
	timer.Create( "startround", 5, 1, function()
		PrintMessage( HUD_PRINTTALK,"New round will start in 5 seconds!")
		StartRound()
		if relay then
			relay:SetTriggerSound(4)
		end
	end)
end


function RoundOver()
	local numswat = 0
	local numghost = 0
	for k, ply in RandomPairs(player.GetAll()) do
		if ply:Team() == TEAM_SWAT && ply:Alive() then
			numswat = numswat+1
		end
		if ply:Team() == TEAM_GHOST && ply:Alive() then
			numghost = numghost+1
		end
	end
	local wincon = false
	local elimination = false
	local relay = nil
	if GAMEMODE.Standard then
		local evacs = ents.FindByClass("ep_extraction")
		local relays = ents.FindByClass("ep_relay")
		local evac = table.GetFirstValue(evacs)
		relay = table.GetFirstValue(relays)
		if relay then
			if evac:GetPos():Distance(relay:GetPos()) < 500 then
				local tracedata = {}
				tracedata.start = relay:GetPos()
				tracedata.endpos = evac:GetPos()
				tracedata.mask = MASK_SOLID_BRUSHONLY
				local trace = util.TraceLine(tracedata)
				if !trace.HitWorld then
					wincon = true end
				end
		end
	else
		local evacs = ents.FindByClass("ep_csextraction")
		local evac = table.GetFirstValue(evacs)
		if evac then
			if evac:TimeLeft() <= 0 then wincon = true end
		end
	end
	if table.Count(player.GetAll()) > 1 then -- Lonely players don't lose :(
		if numghost == 0 then
			PrintMessage( HUD_PRINTTALK,"Ghosts lose! (No ghosts remain)")
			elimination = true
			for k,v in pairs (player.GetAll()) do
				if v:Team() == TEAM_SWAT then
					player_manager.RunClass(v,"AddPoints",100,"Won Round")
				end
			end
		end
		if numswat == 0 then
			PrintMessage( HUD_PRINTTALK,"SWATs lose! (No swats remain)")
			elimination = true
			for k,v in pairs (player.GetAll()) do
				if v:Team() == TEAM_GHOST then
					player_manager.RunClass(v,"AddPoints",100,"Won Round")
				end
			end
		end
	else
		if numswat == 0 and numghost == 0 then
			PrintMessage( HUD_PRINTTALK,"No live players, restarting round for soloplay")
			PrintMessage( HUD_PRINTTALK,"Thanks for seeding this server, hopefully someone joins soon :)")
			elimination = true
		end
	end
	if GAMEMODE.MaxTime < GAMEMODE.RoundTime then
		PrintMessage( HUD_PRINTTALK, "SWATs lose! (Round timed out!)" )
		for k,v in pairs (player.GetAll()) do
			if v:Team() == TEAM_GHOST then
				player_manager.RunClass(v,"AddPoints",100,"Won Round")
			end
		end
	end
	if wincon then
		PrintMessage( HUD_PRINTTALK, "Ghosts lose! (Relay extracted)" )
		for k,v in pairs (player.GetAll()) do
			if v:Team() == TEAM_SWAT then
				player_manager.RunClass(v,"AddPoints",100,"Won Round")
				relays = ents.FindByClass("ep_relay")
				for key,relay in pairs (relays) do
					if v == relay:GetOwner() then
						player_manager.RunClass(v,"AddPoints",30,"Extracted the Relay")
					end
					relay:Remove()
				end
			end
		end
		if GAMEMODE.Standard then
			if relay:IsValid() then
				relay:SetTriggerSound(3)
			end
		end
	end
	if elimination or wincon or GAMEMODE.MaxTime < GAMEMODE.RoundTime then
		timer.Destroy("roundover")
		return true
	else
		return false
	end
end

function GM:ShowHelp( ply )
	ply:ConCommand("ep_showhelp")
end
function GM:ShowTeam( ply )
	ply:ConCommand("ep_hint")
end

function GM:SetupPlayerVisibility( ply, ent )
	objectives = ents.FindByClass( "ep_relay" )
	for k,v in pairs (objectives) do
		AddOriginToPVS( v:GetPos() )
	end
	objectivemarkers = ents.FindByClass( "ep_relay_marker" )
	for k,v in pairs (objectivemarkers) do
		AddOriginToPVS( v:GetPos() )
	end
	objectives = ents.FindByClass( "ep_extraction" )
	for k,v in pairs (objectives) do
		AddOriginToPVS( v:GetPos() )
	end
	players = player.GetAll()
	for k,v in pairs (players) do
		AddOriginToPVS( v:GetPos() )
	end
end

function HackCombo(pl, cmd, args)
	local valid = true
	if !(args[1] and args[2] and args[3] and args[4]) then
		valid = false
	end
	if pl:Team() != TEAM_SWAT then
		valid = false
	end
	--Also check with the hack entity if the hacker is the same as the player hacking.
	--Plus 1s cooldown on check? Something around there to prevent brute force scripts instantly solving.
	if valid then
		local perfectcount = 0 --correct color correct position
		local correctcount = 0 --correct color wrong position
		if math.Round(args[1]) == math.Round(slot1) then
			perfectcount = perfectcount + 1
		end
		if math.Round(args[2]) == math.Round(slot2) then
			perfectcount = perfectcount + 1
		end
		if math.Round(args[3]) == math.Round(slot3) then
			perfectcount = perfectcount + 1
		end
		if math.Round(args[4]) == math.Round(slot4) then
			perfectcount = perfectcount + 1
		end
		--PrintMessage( HUD_PRINTTALK, "Input:"..args[1]..args[2]..args[3]..args[4] )
		--PrintMessage( HUD_PRINTTALK, "Answr:"..slot1..slot2..slot3..slot4 )
		--PrintMessage( HUD_PRINTTALK, "Correct Positions:"..perfectcount )
		--PrintMessage( HUD_PRINTTALK, "Correct Colors:"..correctcount )
		if perfectcount != 4 then
			pl:ConCommand("ep_hackpanel "..perfectcount)
		end
	else
		PrintMessage( HUD_PRINTTALK, "INVALID HACK")
	end
end

concommand.Add( "ep_forcestart", function( pl, cmd, args ) StartRound() end )

concommand.Add( "ep_hack", HackCombo )

function GM.TrackDamage( ent, dmginfo )
	if !ent:IsPlayer() then return end
	if !dmginfo:GetAttacker():IsPlayer() then return end
	local attacker = dmginfo:GetAttacker()
	--tracking best weapon.
	if attacker:Team() != ent:Team() then
		if attacker:Team() == TEAM_GHOST then
			if attacker:Alive() then
				local wepname = attacker:GetActiveWeapon():GetClass()
				if attacker.gArray then
					attacker.gArray[wepname] = (attacker.gArray[wepname] or 0)+dmginfo:GetDamage()
				end
			end
		else
			if attacker:Alive() then
				local wepname = attacker:GetActiveWeapon():GetClass()
				if attacker.sArray then
					attacker.sArray[wepname] = (attacker.sArray[wepname] or 0)+dmginfo:GetDamage()
				end
			end
		end
	end
end
hook.Add( "EntityTakeDamage", "TrackWeaponDamage", GM.TrackDamage )
