AddCSLuaFile()

if CLIENT then
bg_colors = {
	background_main = Color(0, 0, 10, 200),
	default = Color(100,100,100,200),
	ghost = Color(40, 40, 40, 200),
	ghostlight = Color(80, 80, 80, 200),
	swat = Color(80, 80, 110, 200),
	swatlight = Color(160, 160, 220, 200),
	target = Color(80, 80, 200, 255)
}

font_colors = {
	default = Color(255, 255, 255, 255),
	black = Color(0,0,0,255),
	ghost = Color(250, 190, 80, 255),
	swat = Color(200,200,255, 255),
	target = Color(230, 20, 20, 255)
}

line_colors = {
	default = Color(255, 255, 255, 255),
	black = Color(0,0,0,255),
	ghost = Color(250, 190, 80, 255),
	swat = Color(0,0,0, 255),
	target = Color(230, 20, 20, 255)
}

surface.CreateFont("GhostTitle", {font = "Trebuchet24",
                                    size = 22,
                                    weight = 1000})
surface.CreateFont("SWATTitle", {font = "Trebuchet24",
                                    size = 14,
                                    weight = 1000})
end

local PLAYER = {}

PLAYER.DisplayName			= "Default Class"

PLAYER.ClassDescription 	= "DEBUG DEFAULT CLASS"
PLAYER.ClassPros			= {	"SHOULD NOT BE PLAYABLE" }
PLAYER.ClassCons			= { "CONTACT A DEV" }

PLAYER.WalkSpeed 			= 400		-- How fast to move when not running
PLAYER.RunSpeed				= 600		-- How fast to move when running
PLAYER.CrouchedWalkSpeed 	= 0.3		-- Multiply move speed by this when crouching
PLAYER.DuckSpeed			= 0.3		-- How fast to go from not ducking, to ducking
PLAYER.UnDuckSpeed			= 0.3		-- How fast to go from ducking, to not ducking
PLAYER.JumpPower			= 200		-- How powerful our jump should be
PLAYER.CanUseFlashlight     = true		-- Can we use the flashlight
PLAYER.MaxHealth			= 100		-- Max health we can have
PLAYER.StartHealth			= 100		-- How much health we start with
PLAYER.StartArmor			= 0			-- How much armour we start with
PLAYER.DropWeaponOnDie		= true		-- Do we drop our weapon when we die
PLAYER.TeammateNoCollide 	= true		-- Do we collide with teammates or run straight through them
PLAYER.AvoidPlayers			= true		-- Automatically swerves around other players
PLAYER.UseVMHands			= true		-- Uses viewmodel hands

PLAYER.ClassTeam			= 2 -- 1 = ghost 2 = swat
PLAYER.Model				= "models/player/urban.mdl"

PLAYER.MoveMultiplier		= 1
PLAYER.Stunned				= false


swat_primary = {	"weapon_ep_mp5",
					"weapon_ep_combat",
					"weapon_ep_mg",
					"weapon_ep_shotgun",
					"weapon_ep_rifle",
					"weapon_ep_moosekiller"};
swat_secondary = {	"weapon_ep_pistol",
					"weapon_ep_revolver",
					"weapon_ep_mpistol",
					"weapon_ep_dualmp"};
swat_special = {	"weapon_ep_motion",
					"weapon_ep_healdart",
					"weapon_ep_chaff",
					"weapon_ep_swatshield"};
swat_grenade = {	"weapon_ep_frag",
					"weapon_ep_he",
					"weapon_ep_rpg",
					"weapon_ep_stun"};

ghost_primary = {	"weapon_ep_plasma",
					"weapon_ep_sniper",
					"weapon_ep_prism",
					"weapon_ep_railgun",
					"weapon_ep_heavycannon",
					"weapon_ep_webcaster",
					"weapon_ep_pulsegun",
					"weapon_ep_ricochet"};
ghost_secondary = {	"weapon_ep_dartgun",
					"weapon_ep_pincer",
					"weapon_ep_lightcannon"};
ghost_special = {	"weapon_ep_cloak"};
ghost_grenade = {	"weapon_ep_trip",
					"weapon_ep_detpack",
					"weapon_ep_caltrop",
					"weapon_ep_gas",
					"weapon_ep_gds",
					"weapon_ep_miniturret"};

--
-- Name: PLAYER:SetupDataTables
-- Desc: Set up the network table accessors
-- Arg1:
-- Ret1:
--
function PLAYER:SetupDataTables()

end

--
-- Name: PLAYER:Init
-- Desc: Called when the class object is created (shared)
-- Arg1:
-- Ret1:
--
function PLAYER:Init()


end

--
-- Name: PLAYER:Spawn
-- Desc: Called serverside only when the player spawns
-- Arg1:
-- Ret1:
--
function PLAYER:Spawn()
	--self.MoveMultiplier = 1

end

--
-- Name: PLAYER:Loadout
-- Desc: Called on spawn to give the player their default loadout
-- Arg1:
-- Ret1:
--
function PLAYER:Loadout()

	self:GiveWeapon( "weapon_pistol" )
	self:GiveWeaponAmmo( 255, "Pistol", true )
	self.MoveMultiplier = 1
end

local bones = {
	["weapon_ep_knife"] 			= "ValveBiped.Bip01_L_Thigh",
	["weapon_ep_dartgun"] 			= "ValveBiped.Bip01_R_Thigh",
	["weapon_ep_pincer"] 			= "ValveBiped.Bip01_R_Thigh",
	["weapon_ep_lightcannon"] 		= "ValveBiped.Bip01_R_Thigh",
	["weapon_ep_pistol"] 			= "ValveBiped.Bip01_R_Thigh",
	["weapon_ep_revolver"] 			= "ValveBiped.Bip01_R_Thigh",
	["weapon_ep_mpistol"] 			= "ValveBiped.Bip01_R_Thigh",
	["weapon_ep_dualmp"] 			= "ValveBiped.Bip01_R_Thigh",
	["weapon_ep_mp5"] 				= "ValveBiped.Bip01_Spine1",
	["weapon_ep_combat"] 			= "ValveBiped.Bip01_Spine1",
	["weapon_ep_mg"] 				= "ValveBiped.Bip01_Spine1",
	["weapon_ep_shotgun"] 			= "ValveBiped.Bip01_Spine1",
	["weapon_ep_rifle"] 			= "ValveBiped.Bip01_Spine1",
	["weapon_ep_pulsegun"] 			= "ValveBiped.Bip01_Spine1",
	["weapon_ep_plasma"] 			= "ValveBiped.Bip01_Spine1",
	["weapon_ep_sniper"] 			= "ValveBiped.Bip01_Spine1",
	["weapon_ep_webcaster"] 		= "ValveBiped.Bip01_Spine1",
	["weapon_ep_heavycannon"] 		= "ValveBiped.Bip01_Spine1",
	["weapon_ep_moosekiller"] 		= "ValveBiped.Bip01_Spine1",
	["weapon_ep_railgun"] 			= "ValveBiped.Bip01_Spine1",
	["weapon_ep_ricochet"] 			= "ValveBiped.Bip01_Spine1",
	["weapon_ep_prism"] 			= "ValveBiped.Bip01_Spine1",
	["weapon_ep_rpg"] 				= "ValveBiped.Bip01_Spine1",
	["weapon_ep_gren_rpg"] 			= "ValveBiped.Bip01_Spine1",
	["weapon_ep_swatshield"] 		= "ValveBiped.Bip01_Spine1",
	["weapon_ep_trip"] 				= "ValveBiped.Bip01_Pelvis",
	["weapon_ep_detpack"] 			= "ValveBiped.Bip01_Pelvis",
	["weapon_ep_caltrop"] 			= "ValveBiped.Bip01_Pelvis",
	["weapon_ep_gas"] 				= "ValveBiped.Bip01_Pelvis",
	["weapon_ep_lich_gas"] 				= "ValveBiped.Bip01_Pelvis",
	["weapon_ep_miniturret"] 		= "ValveBiped.Bip01_Pelvis",
	["weapon_ep_he"]			 	= "ValveBiped.Bip01_Pelvis",
	["weapon_ep_frag"] 				= "ValveBiped.Bip01_Pelvis",
	["weapon_ep_stun"] 				= "ValveBiped.Bip01_Pelvis",
	["weapon_ep_gren_he"]			= "ValveBiped.Bip01_Pelvis",
	["weapon_ep_gren_frag"] 		= "ValveBiped.Bip01_Pelvis",
	["weapon_ep_gren_stun"] 		= "ValveBiped.Bip01_Pelvis",
	["weapon_ep_healdart"] 			= "ValveBiped.Bip01_R_Calf",
	["weapon_ep_chaff"] 			= "ValveBiped.Bip01_Spine2",
	["weapon_ep_motion"] 			= "ValveBiped.Bip01_Spine2"
}

swat_failed_reload = {
	"npc/metropolice/vo/shit.wav"
}

ghost_failed_reload = {
	"npc/fast_zombie/fz_alert_close1.wav"
}


function PLAYER:GiveWeapon(name)
	local gun = self.Player:Give(name)
	if gun != nil and gun:IsValid() then
		local model = gun:GetWeaponWorldModel()
		if name == "weapon_ep_swatshield" then model = "models/props_combine/combine_barricade_short01a.mdl" end
		if model != nil and model != "" then
			local bone = bones[name]
			if bone != nil then
				local spawn = ents.Create( "ep_equipment" )
				spawn:SetPos( self.Player:GetPos() )
				spawn:Pickup(self.Player, name, model, bone)
				spawn:Spawn()
			end
		end
	end
end


function PLAYER:FailReload()
	local reallyFailed = true --todo call appropriate func to check for technician reload behaviour
	if reallyFailed and self.Player and self.Player:IsValid() then
		if self.Player:Team() == TEAM_SWAT then
			self.Player:EmitSound(table.Random(swat_failed_reload), 100, 100)
		else
			self.Player:EmitSound(table.Random(ghost_failed_reload), 100, 100)
		end
	end
	return reallyFailed
end

function PLAYER:GiveGuns()
	self.MoveMultiplier = 1
	if self.Player:Team() == TEAM_SWAT then
		self:GiveWeapon(table.Random(swat_primary)) -- Primary
		self:GiveWeapon(table.Random(swat_grenade)) -- grenade
		self:GiveWeapon(table.Random(swat_secondary)) -- Secondary
		self:GiveWeapon(table.Random(swat_special)) -- Special gear
		--self:GiveWeapon("weapon_ep_knife") -- Melee
		self:GiveWeapon("weapon_ep_knife") -- Melee
		self:GiveWeapon("weapon_ep_radio") -- All swat get a radio.
	end
	if self.Player:Team() == TEAM_GHOST then
		self:GiveWeapon(table.Random(ghost_primary)) -- Primary
		self:GiveWeapon(table.Random(ghost_secondary)) -- Secondary
		self:GiveWeapon(table.Random(ghost_grenade)) -- grenade
		self:GiveWeapon(table.Random(ghost_special)) -- Special item
		self:GiveWeapon("weapon_ep_knife") -- Melee
	end
	if table.Count(player.GetAll()) == 1 then
		--Give lonely players every gun! Yay!
		for k,v in pairs(swat_primary) do
			self:GiveWeapon(v)
		end
		for k,v in pairs(swat_secondary) do
			self:GiveWeapon(v)
		end
		for k,v in pairs(swat_special) do
			self:GiveWeapon(v)
		end
		for k,v in pairs(swat_grenade) do
			self:GiveWeapon(v)
		end
		for k,v in pairs(ghost_primary) do
			self:GiveWeapon(v)
		end
		for k,v in pairs(ghost_secondary) do
			self:GiveWeapon(v)
		end
		for k,v in pairs(ghost_special) do
			self:GiveWeapon(v)
		end
		for k,v in pairs(ghost_grenade) do
			self:GiveWeapon(v)
		end
		self:GiveWeapon("weapon_ep_moosekiller")
	end
end

function PLAYER:Defuse() --Can we defuse bombs?
	return false
end

function PLAYER:GetMaxHealth()
	return self.MaxHealth
end

	--Changes our base speed.
function PLAYER:SetMoveSpeed(speed)
	self.WalkSpeed = speed
	self.RunSpeed = speed
	self:UpdateSpeed();
end

	--Changes our multiplier.
	--This does NOT set it, it multiplies it, so different bonuses can interact.
	--E.g. if I run: multiplymovespeed(2) then multiplymovespeed(3) the final multiplier will be 6.
	--Hence, when you ADD a speed buff, put in the multiplier
	--When you REMOVE a speed buff, put in 1/yourmult
	--Capiche?
function PLAYER:MultiplyMoveSpeed(mult)
	self.MoveMultiplier = mult
	if SERVER then
		self.Player:SetNWInt( "MoveMult", self.MoveMultiplier*100 )
	end
end

function PLAYER:IgnoreScope() --If return true, scoping in doesn't slow us down.
	return false
end

function PLAYER:KeyPress( ply, key )
	if SERVER && key == IN_USE then
		print(self.MoveMultiplier)
	end
	if ply:Team() == TEAM_GHOST && key == IN_JUMP && ply.jumpboost > 0 then
		if !ply:IsOnGround() then
		fwd = ply:GetAimVector()*90
			local tr1 = util.TraceLine({
			start  = ply:GetShootPos(),
			endpos = ply:GetShootPos() + fwd,
			filter = ply,
			mask   = MASK_SHOT
			});
			fwd:Rotate(Angle(0,90,0))
			local tr2 = util.TraceLine({
			start  = ply:GetShootPos(),
			endpos = ply:GetShootPos() + fwd,
			filter = ply,
			mask   = MASK_SHOT
			});
			fwd:Rotate(Angle(0,90,0))
			local tr3 = util.TraceLine({
			start  = ply:GetShootPos(),
			endpos = ply:GetShootPos() + fwd,
			filter = ply,
			mask   = MASK_SHOT
			});
			fwd:Rotate(Angle(0,90,0))
			local tr4 = util.TraceLine({
			start  = ply:GetShootPos(),
			endpos = ply:GetShootPos() + fwd,
			filter = ply,
			mask   = MASK_SHOT
			});
			if tr1.Hit or tr2.Hit or tr3.Hit or tr4.Hit then
				local punch = Angle(20,0,0)
				local vec = Vector(0,0,200)
				if ply:KeyDown(IN_FORWARD) then
					if tr1.Hit then
						vec = vec+ply:GetAimVector()*200+Vector(0,0,400)
						punch = Angle(20,0,0)
					else
						vec = vec+ply:GetAimVector()*600
						punch = Angle(-10,0,0)
					end
				end
				if ply:KeyDown(IN_MOVERIGHT) then
					nvec = ply:GetAimVector()*600
					ang = Angle(0,-70,0)
					nvec:Rotate(ang)
					vec = vec+nvec
					punch = Angle(-5,-15,0)
				end
				if ply:KeyDown(IN_MOVELEFT) then
					nvec = ply:GetAimVector()*600
					ang = Angle(0,70,0)
					nvec:Rotate(ang)
					vec = vec+nvec
					punch = Angle(-5,15,0)
				end
				if ply:KeyDown(IN_BACK) then
					vec = vec+ply:GetAimVector()*-400 + Vector(0,0,300)
					punch = Angle(20,0,0)
				end

				if vec:Length() > 500 then
					vec = vec:GetNormal()*500
				end
				--ply:SetVelocity( -1*ply:GetVelocity() )
				--timer.Create( "Wallbounce", 0.1, 1, function()  ply:SetVelocity( vec ) end )
				ply:SetLocalVelocity( vec )
				ply:ViewPunch(punch)

				ply:EmitSound("physics/flesh/flesh_impact_hard3.wav", 100, 100)
				ply.jumpboost = ply.jumpboost-1
			end
		else
			vec = ((ply:GetVelocity()*3):Length()*ply:GetAimVector()*10)
			if vec:Length() > 200 then
				vec = vec:GetNormal()*200
				vec.z = math.Clamp(vec.z,10,100)
				vec.x = math.Clamp(vec.x,-10,10)   --No idea why 10 O.o
				vec.y = math.Clamp(vec.y,-10,10)
			end
			ply:SetVelocity( -1*ply:GetVelocity() )
			ply:SetVelocity( vec )
			ply:EmitSound("physics/flesh/flesh_impact_hard2.wav", 40, 100)
		end
	end
end

function PLAYER:UpdateSpeed()
	if self.Stunned then
		self.Player:SetRunSpeed(self.RunSpeed*self.MoveMultiplier*0.3)
		self.Player:SetWalkSpeed(self.RunSpeed*self.MoveMultiplier*0.3)
		self.Player:SetMaxSpeed(self.RunSpeed*self.MoveMultiplier*0.3)
	else
		self.Player:SetRunSpeed(self.RunSpeed*self.MoveMultiplier)
		self.Player:SetWalkSpeed(self.RunSpeed*self.MoveMultiplier)
		self.Player:SetMaxSpeed(self.RunSpeed*self.MoveMultiplier)
	end
end

function PLAYER:Tick()
	self:UpdateSpeed()
end

function PLAYER:Heal(amt)
	if self.Player:Health()+amt <= self.MaxHealth then
		self.Player:SetHealth(self.Player:Health()+amt)
	else
		self.Player:SetHealth(self.MaxHealth)
	end
end

function PLAYER:AddPoints(amt, desc)
	if SERVER then
		if self.Player:Team() == TEAM_GHOST then
			self.Player:AddFrags(amt)
		else
			self.Player:AddDeaths(amt)
		end
		local message = string.upper(desc)
		self.Player:ConCommand("ep_popup "..string.format("%q", message).." "..amt)
	end
end

function PLAYER:ClassName()
	return self.DisplayName
end

--look i'm sure there was a better way to do the individual class behaviour but shut up
--seriously shut upppppp
-- ;_;

function PLAYER:EidolonBehaviour()
	return false
end

function PLAYER:CommanderBehaviour()
	return false
end

function PLAYER:VanguardBehaviour()
	return false
end

function PLAYER:LichBehaviour()
	return false
end

function PLAYER:PoltergeistBehaviour()
	return false
end

function PLAYER:PoltergeistBehaviour()
	return false
end

function PLAYER:RevenantBehaviour()
	return false
end

function PLAYER:WispBehaviour()
	return false
end

function PLAYER:OperatorBehaviour()
	return false
end

function PLAYER:PointmanBehaviour()
	return false
end

function PLAYER:DrawRadar()

end

function PLAYER:DrawClass()
	local offset = 0
	for k,v in pairs (self.ClassCons) do
		draw.SimpleTextOutlined(" -"..v, "EPText", ScrW() / 16, ScrH()-3*(ScrH() / 32)-offset, Color(200,100,100), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, font_colors.black)
		offset = offset+16
	end
	for k,v in pairs (self.ClassPros) do
		draw.SimpleTextOutlined(" +"..v, "EPText", ScrW() / 16, ScrH()-3*(ScrH() / 32)-offset, Color(100,200,100), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, font_colors.black)
		offset = offset+16
	end
	if self.Player:Team() == TEAM_GHOST then
		draw.SimpleTextOutlined(self.DisplayName, "EPText", ScrW() / 16, ScrH()-3*(ScrH() / 32)-offset, font_colors.ghost, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, font_colors.black)
	else
		draw.SimpleTextOutlined(self.DisplayName, "EPText", ScrW() / 16, ScrH()-3*(ScrH() / 32)-offset, font_colors.swat, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, font_colors.black)
	end
	local spd = self.Player:GetNWInt( "MoveMult" )
	draw.SimpleTextOutlined("SPEED: "..(spd).."%", "EPText", ScrW() / 2, ScrH()-3*(ScrH() / 32)-offset, font_colors.default, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, font_colors.black)
end

function PLAYER:ReloadPenalty() --Can we fail reloads (technician behaviour)
	return true
end

function PLAYER:HeadShotScale()
	return 2
end

function PLAYER:SlowDebuff(length)
	local debuffname = "slowdebuff_"..self.Player:UniqueID()
	if timer.Exists( debuffname ) then
		timer.Adjust( debuffname, length, 1, function()
			if self.Player and self.Player:IsValid() then
				--self:MultiplyMoveSpeed(1/0.3)
				self.Stunned = false
			end
		end )
	else
		self.Stunned = true
		timer.Create( debuffname, length, 1, function()
			if self.Player and self.Player:IsValid() then
				--self:MultiplyMoveSpeed(1/0.3)
				self.Stunned = false
			end
		end )
	end
end
-- Clientside only
function PLAYER:CalcView( view ) end		-- Setup the player's view
function PLAYER:CreateMove( cmd ) end		-- Creates the user command on the client
function PLAYER:ShouldDrawLocal() end		-- Return true if we should draw the local player

if CLIENT then

	function PLAYER:GetClassInfo()
		local data = {
			tm = self.ClassTeam,
			name = self.DisplayName,
			model = self.Model,
			desc = self.ClassDescription,
			pros = self.ClassPros,
			cons = self.ClassCons
			}
		return data
	end

	function PLAYER:ClassInfo()
	end
end

-- Shared
function PLAYER:StartMove( cmd, mv )
end

function PLAYER:Move( mv ) end				-- Runs the move (can run multiple times for the same client)
function PLAYER:FinishMove( mv ) end		-- Copy the results of the move back to the Player


--
-- Name: PLAYER:ViewModelChanged
-- Desc: Called when the player changes their weapon to another one causing their viewmodel model to change
-- Arg1: Entity|viewmodel|The viewmodel that is changing
-- Arg2: string|old|The old model
-- Arg3: string|new|The new model
-- Ret1:
--
function PLAYER:ViewModelChanged( vm, old, new )


end

--
-- Name: PLAYER:PreDrawViewmodel
-- Desc: Called before the viewmodel is being drawn (clientside)
-- Arg1: Entity|viewmodel|The viewmodel
-- Arg2: Entity|weapon|The weapon
-- Ret1:
--
function PLAYER:PreDrawViewModel( vm, weapon )

end

--
-- Name: PLAYER:PostDrawViewModel
-- Desc: Called after the viewmodel has been drawn (clientside)
-- Arg1: Entity|viewmodel|The viewmodel
-- Arg2: Entity|weapon|The weapon
-- Ret1:
--
function PLAYER:PostDrawViewModel( vm, weapon )

	if ( weapon.UseHands || !weapon:IsScripted() ) then

		local hands = self.Player:GetHands()
		if ( IsValid( hands ) ) then
			hands:DrawModel()
		end

	end

end

--
-- Name: PLAYER:GetHandsModel
-- Desc: Called on player spawn to determine which hand model to use
-- Arg1:
-- Ret1: table|info|A table containing model, skin and body
--
function PLAYER:GetHandsModel()

	-- return { model = "models/weapons/c_arms_cstrike.mdl", skin = 1, body = "0100000" }

	local cl_playermodel = self.Player:GetInfo( "cl_playermodel" )
	return player_manager.TranslatePlayerHands( cl_playermodel )

end

player_manager.RegisterClass( "player_default", PLAYER, nil )
