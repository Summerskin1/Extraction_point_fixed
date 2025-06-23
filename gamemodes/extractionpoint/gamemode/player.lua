
punished_table = {} --Table of punished players, stores their steamid so reconnecting shouldn't remove TK points, resets each map. Actually kicking/banning players will always need an admin.

punish_threshold = 3 --How many punish points do you need to miss a round? A player doesn't lose punish points unless he misses out on a round.

swat_death = {
					"npc/combine_soldier/die1.wav",
					"npc/combine_soldier/die2.wav",
					"npc/combine_soldier/die3.wav",
					"npc/combine_soldier/pain1.wav",
					"npc/combine_soldier/pain2.wav",
					"npc/combine_soldier/pain3.wav",
					"npc/combine_soldier/vo/requestmedical.wav" };

ghost_death = {
					"npc/zombie/zombie_die1.wav",
					"npc/zombie/zombie_die2.wav",
					"npc/zombie/zombie_die2.wav",
					"npc/zombie/zombie_pain1.wav",
					"npc/zombie/zombie_pain2.wav",
					"npc/zombie/zombie_pain3.wav",
					"npc/zombie/zombie_pain4.wav",
					"npc/zombie/zombie_pain5.wav",
					"npc/zombie/zombie_pain6.wav"};

ghost_kill_chatter = {

}

ghost_spawn_chatter = {

}

swat_kill_chatter = {
	"npc/combine_soldier/vo/overwatchtarget1sterilized.wav",
	"npc/combine_soldier/vo/overwatchtargetcontained.wav",


}

swat_spawn_chatter = {
					"npc/combine_soldier/vo/prison_soldier_sundown3dead.wav",
					"npc/combine_soldier/vo/prepforcontact.wav",
					"npc/combine_soldier/vo/prison_soldier_prosecuteD7.wav",

};

swat_reload = {
	"npc/metropolice/vo/backmeupImout.wav",

}


function Punish(player, cmd, args)
	if player.Killer and player.CanPunish then
		punished_table[player.Killer:SteamID()] = (punished_table[player.Killer:SteamID()] or 0)+2
		print(player:Nick().." has punished "..player.Killer:Nick())
		player.Killer:PrintMessage( HUD_PRINTTALK, player:Nick().." has punished you for teamkilling!" )
		player.Killer:PrintMessage( HUD_PRINTTALK, "You now have "..punished_table[player.Killer:SteamID()].." points, if you go over "..punish_threshold.." you will sit out a round!" )
		player.CanPunish = false
	end
	if !player.CanPunish then
		--print(player:Nick()..", "..player:SteamID().." has attempted to punish when he isn't allowed to.")
		--print("If this message is spammed, he may be attempting to exploit the system.")
	end
end

function CheckPunish(player)
	local punish = punished_table[player:SteamID()] or 0
	local allowed = true
	if punish > punish_threshold then
		allowed = false
	end
	return allowed
end

function DecrementPunish(player)
	if punished_table[player:SteamID()] then
		if punished_table[player:SteamID()] > 0 then
			punished_table[player:SteamID()] = punished_table[player:SteamID()]-1
		end
		PrintMessage( HUD_PRINTTALK,player:Nick().." has been punished for teamkilling!")
		PrintMessage( HUD_PRINTTALK,"He has "..punished_table[player:SteamID()].." Punishment points remaining.")
	end
end


function GM:PlayerInitialSpawn( ply )
	--MsgN("Player connected. Silently killed!")
	ply:SetTeam(TEAM_SWAT)
	timer.Simple(0.1,function()
	if ply then
		local players = player.GetAll()
		if table.Count(players) > 1 then
			ply:KillSilent()
		end
	end
	end)
end

swat_perks = { 	"player_vanguard",
				"player_armored",
				"player_scout",
				"player_medic",
				"player_tech",
				"player_pointman",
				"player_commander",
				"player_grenadier",
				"player_operator"
				}

ghost_perks = {	"player_lich",
				"player_cyber",
				"player_juggernaut",
				"player_biotic",
				"player_eidolon",
				"player_poltergeist",
				"player_wisp"
				}

function GM:PlayerSpawn(ply)
	local punish = punished_table[ply:SteamID()] or 0
	print(ply:Nick()..": punish level: "..punish)
	ply:UnSpectate()
	MsgN("Player spawned")
	ply:SetMaterial( )
	ply:DrawWorldModel(true)
	ply:AllowFlashlight(true)
	--Set up our player, speed and weapons etc.
	if ply:Team() == TEAM_SWAT then
		local class = table.Random(swat_perks)
		player_manager.SetPlayerClass( ply, class )
		player_manager.RunClass( ply, "GiveGuns" )
		player_manager.RunClass( ply, "Loadout" )
	end
	if ply:Team() == TEAM_GHOST then
		local class = table.Random(ghost_perks)
		player_manager.SetPlayerClass( ply, class )
		ply.jumpboost = 2
		player_manager.RunClass( ply, "GiveGuns" )
		player_manager.RunClass( ply, "Loadout" )
	end

	ply:SetViewOffsetDucked(Vector(0,0,44))
	ply:ConCommand("ep_classinfo")
	ply:ConCommand("ep_cloakfix")
	--ply:UnLock()

	--These arrays store the damage dealt with each weapon.
	ply.gArray = ply.gArray or {}
	ply.sArray = ply.sArray or {}

   local hands = ents.Create( "gmod_hands" )
   if IsValid(hands) then
      ply:SetHands(hands)
      hands:SetOwner(ply)


      -- Find model and attach to vm, currently ours
      ply:SetPlayerHands(ply)
      ply:DeleteOnRemove(hands)
      hands:Spawn()
	  hands:SetColor(255,0,0,255)
   end


end

--Runs while player is dead. Normally this is where the player can click to respawn but respawns are disabled in our game.
function GM:PlayerDeathThink( pl )

end

function GM:PlayerTick( ply, cmd )
		player_manager.RunClass( ply, "Tick" )
end

function GM:OnPlayerHitGround( ply, water, float, speed )
	if ply:Team() == TEAM_GHOST then
		ply.jumpboost = 2
	else
		--Custom falldamage
		local falldamage = 0.2 * (speed - 500)
		if math.floor(falldamage) > 0 then
			local dmg = DamageInfo()
			dmg:SetDamageType(DMG_FALL)
			dmg:SetAttacker(game.GetWorld())
			dmg:SetInflictor(game.GetWorld())
			dmg:SetDamageForce(Vector(0,0,1))
			dmg:SetDamage(falldamage)
			ply:TakeDamageInfo(dmg)
			sound.Play("player/damage1.wav", ply:GetShootPos(), 40 + math.Clamp(falldamage, 0, 80), 100)
		end
	end
end
function GM:KeyPress( ply, key )
	player_manager.RunClass(ply, "KeyPress", ply, key)
	if key == IN_ATTACK and !ply:Alive() then
		ply:Spectate( OBS_MODE_IN_EYE  )
		local ghosts = {}
		local swats = {}
		for k,v in pairs (player.GetAll()) do
			if v:Team() == TEAM_GHOST and v:Alive() and v != ply:GetObserverTarget() then
				table.insert(ghosts,v)
			end
			if v:Team() == TEAM_SWAT and v:Alive() and v != ply:GetObserverTarget() then
				table.insert(swats,v)
			end
		end
		if ply:Team() == TEAM_GHOST then
			ply:SpectateEntity(table.Random(ghosts))
		else
			ply:SpectateEntity(table.Random(swats))
		end
	end
end
function GM:ScalePlayerDamage(ply, hitgroup, dmginfo)

   if hitgroup == HITGROUP_HEAD then
      -- headshot if it was dealt by a bullet
		local scale = player_manager.RunClass( ply, "HeadShotScale" ) or 2
		if player_manager.RunClass( dmginfo:GetAttacker(), "OperatorBehaviour") then
			if scale > 1 then
				scale = scale*1.5
			end
		end
		if dmginfo:GetAttacker():GetActiveWeapon():GetClass() == "weapon_ep_pistol" then
			if scale > 1 then
				scale = scale*1.5
			end
		end
		if dmginfo:GetAttacker():GetActiveWeapon():GetClass() == "weapon_ep_moosekiller" then
			if scale > 1 then
				scale = scale*2
			end
		end
         dmginfo:ScaleDamage(scale)
		 if player_manager.RunClass( ply, "EidolonBehaviour") then

			local ed = EffectData()
				ed:SetEntity(ply)
				local BoneIndx = ply:LookupBone("ValveBiped.Bip01_Head1")
				local BonePos, BoneAng = ply:GetBonePosition( BoneIndx )
				ed:SetOrigin(BonePos)
				--ed:SetOrigin(dmginfo:GetReportedPosition())
			--util.Effect( "StunstickImpact", ed, true, true )
			util.Effect( "cball_explode", ed, true, true )
		 end

   elseif (hitgroup == HITGROUP_LEFTARM or
           hitgroup == HITGROUP_RIGHTARM or
           hitgroup == HITGROUP_LEFTLEG or
           hitgroup == HITGROUP_RIGHTLEG or
           hitgroup == HITGROUP_GEAR ) then

      dmginfo:ScaleDamage(1)
   end
	local attacker = dmginfo:GetAttacker()
	if attacker:IsPlayer() then
		if hitgroup == HITGROUP_HEAD then
			attacker:SendLua( 'surface.PlaySound("physics/metal/metal_sheet_impact_bullet2.wav")' )
		else
			attacker:SendLua( 'surface.PlaySound("buttons/button16.wav")' )
		end
	end
end


function GM:EntityTakeDamage( ent, dmginfo )
	local attacker = dmginfo:GetAttacker()
	if ent:IsPlayer() then
		if (player_manager.RunClass(ent,"OperatorBehaviour") && dmginfo:GetDamageType() == DMG_ACID) then
			dmginfo:SetDamage(0)
		end
		if (player_manager.RunClass(ent,"LichBehaviour") && dmginfo:GetDamageType() == DMG_ACID) then
			dmginfo:SetDamage(0)
			player_manager.RunClass( ent, "Heal", 10 )
		end
		if (player_manager.RunClass(ent,"VanguardBehaviour")) then

			local src
			if ent != nil then
				if dmginfo:GetInflictor() != nil then
					src = dmginfo:GetInflictor()
				elseif dmginfo:GetAttacker() != nil then
					src = dmginfo:GetAttacker()
				end
			end
			if src != nil and src:IsValid() then
				local dir = ent:GetPos()-src:GetPos()
				dir:Normalize()
				if dir:Dot(ent:GetForward()) < 0 then
					dmginfo:ScaleDamage(0.8)
					print("RESISTED")
				end
			end
		end
		if attacker:IsPlayer() and ent != attacker then
			if player_manager.RunClass(attacker,"EidolonBehaviour") then
				player_manager.RunClass(attacker,"Heal",dmginfo:GetDamage()*0.75)
			end
			if ent:Team() == TEAM_SWAT then
				local boost = false
				for k,v in pairs (player.GetAll()) do
					if player_manager.RunClass(v,"CommanderBehaviour") then
						if (v:GetPos()-ent:GetPos()):Length() < 500 then
							boost = true
						end
					end
				end
				if boost then
					dmginfo:ScaleDamage(0.8)
				end
			end
			if attacker:Team() == TEAM_SWAT then
				local boost = false
				for k,v in pairs (player.GetAll()) do
					if player_manager.RunClass(v,"CommanderBehaviour") then
						if (v:GetPos()-attacker:GetPos()):Length() < 500 then
							boost = true
						end
					end
				end
				if boost then
					dmginfo:ScaleDamage(1.5)
				end
			end
				--Revenants get bonus damage.
			if (player_manager.RunClass(attacker,"RevenantBehaviour") && attacker:GetActiveWeapon():GetClass() == "weapon_ep_knife") then
				dmginfo:ScaleDamage(1.3)
			end
			if (player_manager.RunClass(attacker,"OperatorBehaviour") && attacker:GetActiveWeapon():GetClass() == "weapon_ep_knife") then
				dmginfo:ScaleDamage(1.7)
			end
		end
	end
end
--Disable default falldamage.
function GM:GetFallDamage(ply, speed)
   return 0
end

function GM:PlayerSelectSpawn( pl )

	local SpawnPoints = team.GetSpawnPoints( pl:Team() )
	if ( !SpawnPoints || table.Count( SpawnPoints ) == 0 ) then return end

	local ChosenSpawnPoint = nil

	for i=0, 6 do

		local ChosenSpawnPoint = table.Random( SpawnPoints )
		if ( GAMEMODE:IsSpawnpointSuitable( pl, ChosenSpawnPoint, i==6 ) ) then
			return ChosenSpawnPoint
		end

	end

	return ChosenSpawnPoint
end


function GM:IsSpawnpointSuitable( pl, spawnpointent, bMakeSuitable )

	local Pos = spawnpointent:GetPos()

	-- Note that we're searching the default hull size here for a player in the way of our spawning.
	-- This seems pretty rough, seeing as our player's hull could be different.. but it should do the job
	-- (HL2DM kills everything within a 128 unit radius)
	local Ents = ents.FindInBox( Pos + Vector( -16, -16, 0 ), Pos + Vector( 16, 16, 64 ) )

	if ( pl:Team() == TEAM_SPECTATOR || pl:Team() == TEAM_UNASSIGNED ) then return true end

	local Blockers = 0

	for k, v in pairs( Ents ) do
		if ( IsValid( v ) && v:GetClass() == "player" && v:Alive() ) then

			Blockers = Blockers + 1

			if ( bMakeSuitable ) then
				v:Kill()
			end

		end
	end

	if ( bMakeSuitable ) then return true end
	if ( Blockers > 0 ) then return false end
	return true

end

function GM:PlayerCanHearPlayersVoice( src, rcv )
	canhear = true
	advsound = true
	if src:GetPos():Distance( rcv:GetPos() ) > 1000 then --If the receiver is 1000 or less units away he's audible.
		canhear = false
	end
		--Radio stuff.
	if src:Alive() and (src:GetActiveWeapon():GetClass() == "weapon_ep_radio" or player_manager.RunClass(src,"CommanderBehaviour") ) then
		if src:Team() == rcv:Team() then
			canhear = true
			advsound = false
		end
	end
		--Spectators can't speak by default.
		--Note that dead players can talk for a second or two, before they are automatically put in spectator.
		--This is to let them get out that last word.
	if src:GetObserverMode() != OBS_MODE_NONE then
		canhear = false
	end
		--Spectators can only hear from the perspective of the player they're speccing.
	if rcv:GetObserverMode() != OBS_MODE_NONE then
		canhear = false
		if rcv:GetObserverTarget() then
			if src:GetPos():Distance( rcv:GetObserverTarget():GetPos() ) > 1000 then --If the receiver is 1000 or less units away he's audible.
				canhear = false
			end
		end
	end
		--Dead players can talk to their dead team.
	if src:Team() == rcv:Team() then
		if !src:Alive() and !rcv:Alive() then
			canhear = true
			advsound = false
		end
	end
	return canhear, advsound
end

function GM:DoPlayerDeath(ply, attacker, dmginfo)
	if ply:IsPlayer() and ply ~= attacker and IsValid(attacker) then
		if ply:Team() == attacker:Team() then
			ply.Killer = attacker
			ply.CanPunish = true --Change this to false to disable FF kickmode blah blah.
			ply:ConCommand("ep_punishmenu".." "..attacker:Nick()) --punish window!
			--ply:ConCommand("ep_punish") --always punish for now
		end
	end
	--If we're carrying the relay, drop it.
	relays = ents.FindByClass("ep_relay")
	for k,v in pairs (relays) do
		if ply == v:GetOwner() then
			v:Drop()
			if attacker:Team() == TEAM_GHOST then
				player_manager.RunClass(attacker,"AddPoints",5,"Killed a Relay Carrier")
			end
		end
	end
	if ply:GetActiveWeapon() and ply:GetActiveWeapon().OwnerDie then
		ply:GetActiveWeapon():OwnerDie()
	end
	if player_manager.RunClass(attacker,"EidolonBehaviour") then
			local ed = EffectData()
				ed:SetOrigin(ply:GetPos())
			util.Effect( "eidolon_frag", ed, true, true )
	else
		ply:CreateRagdoll()
	end
	if player_manager.RunClass(attacker,"LichBehaviour") then
			local gas = ents.Create("ep_gas_nade")
			gas:SetPos(ply:GetPos())
			gas:SetOwner(attacker)
			gas:Spawn()
	end
	if player_manager.RunClass(ply,"WispBehaviour") then
		if SERVER then
			local bomb = ents.Create("ep_wisp_bomb")
			bomb:SetOwner(ply)
			bomb:SetPos(ply:GetShootPos())
			bomb:SetFriction(0.3)
			bomb:Spawn()
			bomb:PhysWake()
			local phys = bomb:GetPhysicsObject()
			if IsValid(phys) then
				phys:SetVelocity(ply:GetVelocity())
			end
		end
	end
	if ply:Team() == TEAM_SWAT then
		ply:EmitSound(table.Random(swat_death), 100, 100)
	else
		ply:EmitSound(table.Random(ghost_death), 100, 100)
	end
	if attacker != ply and player_manager.RunClass(attacker,"EidolonBehaviour") then
		attacker:SetPos(ply:GetPos())
		attacker:SetEyeAngles(ply:EyeAngles())
	end
	if attacker:Team() != ply:Team() then
		if attacker:Team() == TEAM_GHOST then
			player_manager.RunClass(attacker,"AddPoints",10,"Killed an enemy SWAT")
		else
			player_manager.RunClass(attacker,"AddPoints",30,"Killed an enemy Ghost")
		end
	else
		--attacker:AddFrags(10)
	end
	ply:ConCommand("ep_hint") --death hint!
	timer.Simple( 4, function()
		if ply != nil or ply != NULL or !ply:IsValid() then
			ply:Spectate( OBS_MODE_IN_EYE  )
			local ghosts = {}
			local swats = {}
			for k,v in pairs (player.GetAll()) do
				if v:Team() == TEAM_GHOST and v:Alive() and v != ply:GetObserverTarget() then
					table.insert(ghosts,v)
				end
				if v:Team() == TEAM_SWAT and v:Alive() and v != ply:GetObserverTarget() then
					table.insert(swats,v)
				end
			end
			if ply:Team() == TEAM_GHOST then
				ply:SpectateEntity(table.Random(ghosts))
			else
				ply:SpectateEntity(table.Random(swats))
			end
		end
	end)
end

function GM:PlayerDeathSound()
	return true
end

function GM:FinishMove( ply, moveData )
	/* if moveing change the crouched view height
	if moveData:GetVelocity() == Vector(0,0,0) then
		ply:SetViewOffsetDucked(Vector(0,0,44))
	elseif moveData:GetVelocity().z > 0 then
		ply:SetViewOffsetDucked(Vector(0,0,44))
	else
		ply:SetViewOffsetDucked(Vector(0,0,44))
	end
	*/
end

function Optout(player, cmd, args)
	if player:Alive() then
		player:KillSilent()
	end
	player:SetTeam(TEAM_SPEC)
	player:Spectate( OBS_MODE_IN_EYE  )
end

function Optin(player, cmd, args)
	player:SetTeam(TEAM_SWAT)
	player:UnSpectate()
end

concommand.Add( "ep_punish", Punish )
concommand.Add( "ep_optin", Optin )
concommand.Add( "ep_optout", Optout )
