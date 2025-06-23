DEFINE_BASECLASS( "player_default" )

local PLAYER = {} 

--
-- See gamemodes/base/player_class/player_default.lua for all overridable variables
--
PLAYER.WalkSpeed 			= 280
PLAYER.RunSpeed				= 200
PLAYER.MaxHealth			= 300		-- Max health we can have
PLAYER.StartHealth			= 300		-- How much health we start with

PLAYER.DisplayName			= "REVENANT"

PLAYER.ClassDescription 	= "REVENANT, WALKING TANK\nMASSIVE HEALTH AND IMMUNITY TO HEADSHOTS\nHOWEVER YOU ARE LESS MOBILE\nAND VULNERABLE TO BACKSTABS"
PLAYER.ClassPros			= {	"MASSIVE HEALTH",
								"HEADSHOT IMMUNITY",
								"BONUS MELEE DAMAGE"}
PLAYER.ClassCons			= { "REDUCED MOBILITY",
								"INCREASED DAMAGE FROM BACKSTABS"}

PLAYER.ClassTeam			= 1
PLAYER.Model				= "models/player/zombie_soldier.mdl"

function PLAYER:Loadout()
	local players = 0
	for k,v in pairs (player.GetAll()) do
		players = players+1
	end
	players = players*0.75
	players = math.floor(players)
	self.Player:SetMaxHealth(self.MaxHealth+100*players)
	self.Player:SetHealth(self.StartHealth+100*players)
	self.Player:SetRunSpeed(200)
	self.Player:SetWalkSpeed(self.RunSpeed)
	self.Player:SetMaxSpeed(self.RunSpeed)
	self.Player:SetModel("models/player/zombie_soldier.mdl")
end

function PLAYER:HeadShotScale()
	return 1
end

function PLAYER:RevenantBehaviour()
	return true
end

if CLIENT then	
	surface.CreateFont("EPText", {font = "Trebuchet24",
												size = 16,
												weight = 1000})
												
	surface.CreateFont("EPAmmo", {font = "Tahoma",
												size = 32,
												weight = 1000})
			-- Color presets
	local bg_colors = {
		background_main = Color(0, 0, 10, 200),
		default = Color(100,100,100,200),
		ghost = Color(200, 120, 40, 200),
		swat = Color(80, 80, 200, 200),
		target = Color(80, 80, 200, 255)
		}

	local font_colors = {
		default = Color(255, 255, 255, 255),
		black = Color(0,0,0,255),
		ghost = Color(250, 190, 80, 255),
		swat = Color(150, 150, 250, 255),
		target = Color(230, 20, 20, 255)
	};
	local pipparams = {
		["$basetexture"] = "VGUI/circle.vtf",
		["$nodecal"] = 1,
		["$model"] = 1,
		["$additive"] = 1,
		["$nocull"] = 1,
		["$vertexcolor"] = true,
		["$vertexalpha"] = true
		}
	local pip = CreateMaterial("HealthPip","UnlitGeneric",pipparams)
	local nextScan = 0
	local positions = {}
	
	function PLAYER:DrawRadar()
		local width = ScrW()/104
		local height = ScrH()/180
		local offset = width/4
		if CurTime() > nextScan then
			nextScan = CurTime()+3
			table.Empty(positions)
			for k, v in pairs(player.GetAll()) do
				if (v:Team() == TEAM_SWAT and v:Alive() and !player_manager.RunClass(v,"OperatorBehaviour")) then
					table.insert(positions,v:GetPos())
				end
			end
		end
		for k, v in pairs (positions) do
			local pos = (v+Vector(0,0,80)):ToScreen()
				--Old Chevron wallhacks	
			draw.NoTexture()
			surface.SetDrawColor( bg_colors.swat )	
			surface.DrawTexturedRectRotated( pos.x+offset, pos.y, width, height, 45 )
			surface.DrawTexturedRectRotated( pos.x-offset, pos.y, width, height, 135 )
			surface.DrawTexturedRectRotated( pos.x+offset, pos.y-(offset*3), width, height, 45 )
			surface.DrawTexturedRectRotated( pos.x-offset, pos.y-(offset*3), width, height, 135 )
		end
		for k, v in pairs(player.GetAll()) do
			if (v:Team() == TEAM_GHOST and v:Alive()) then
				local pos = (v:GetPos()+Vector(0,0,100)):ToScreen()
				--Old Chevron wallhacks
				
				--draw.NoTexture()
				--surface.DrawTexturedRectRotated( pos.x+offset, pos.y, width, height, 45 )
				--surface.DrawTexturedRectRotated( pos.x-offset, pos.y, width, height, 135 )
				--surface.DrawTexturedRectRotated( pos.x+offset, pos.y-(offset*3), width, height, 45 )
				--surface.DrawTexturedRectRotated( pos.x-offset, pos.y-(offset*3), width, height, 135 )
				
				surface.SetDrawColor( bg_colors.ghost )	
				local Min,Max = v:GetCollisionBounds()
				local pos = v:GetPos()
				local left,right,up,down
				local scale = (pos+Min):ToScreen().y-(pos+Max):ToScreen().y
				left = (pos):ToScreen().x-0.4*scale
				right = (pos):ToScreen().x+0.4*scale
				down = (pos+Min):ToScreen().y
				up = (pos+Max):ToScreen().y
				
				local xpos = left
				local ypos = up
				local height = ScrH()/96
				local health = v:Health()/100
				draw.SimpleTextOutlined(string.upper(v:Name()), "EPText", xpos, ypos-34-height, font_colors.ghost, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, font_colors.black)
			end
		end
	end
end
function PLAYER:KeyPress( ply, key )
	if ply:Team() == TEAM_GHOST && key == IN_JUMP && ply.jumpboost > 0 then
		if !ply:IsOnGround() then
		fwd = ply:GetAimVector()*70
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
				
				if vec:Length() > 450 then
					vec = vec:GetNormal()*450
				end
				--ply:SetVelocity( -1*ply:GetVelocity() )
				--timer.Create( "Wallbounce", 0.1, 1, function()  ply:SetVelocity( vec ) end )
				ply:SetLocalVelocity( vec )
				ply:ViewPunch(punch)
				
				ply:EmitSound("physics/flesh/flesh_impact_hard3.wav", 100, 100)
				ply.jumpboost = ply.jumpboost-1
			end
		end
	end
end
player_manager.RegisterClass( "player_juggernaut", PLAYER, "player_default" )