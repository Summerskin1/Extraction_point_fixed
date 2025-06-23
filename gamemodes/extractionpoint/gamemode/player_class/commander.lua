DEFINE_BASECLASS( "player_default" )

local PLAYER = {} 

--
-- See gamemodes/base/player_class/player_default.lua for all overridable variables
--
PLAYER.WalkSpeed 			= 170
PLAYER.RunSpeed				= 170

PLAYER.MaxHealth			= 75		-- Max health we can have
PLAYER.StartHealth			= 75		-- How much health we start with

PLAYER.DisplayName			= "COMMANDER"

PLAYER.ClassDescription 	= "COMMANDER, SQUAD LEADER\nYOUR VOICE IS ALWAYS RADIO\nNEARBY ALLIES HAVE BONUS DAMAGE AND RESISTANCE\nYOU CAN ALSO SEE ALL TEAMMATES THROUGH WALLS"
PLAYER.ClassPros			= {	"VOICE COMMUNICATION ALWAYS RADIO",
								"NEARBY ALLIES HAVE INCREASED DAMAGE AND RESISTANCE",
								"SEE TEAMMATES THROUGH WALLS"}
PLAYER.ClassCons			= { "LOW HEALTH" }

PLAYER.ClassTeam			= 2
PLAYER.Model				= "models/player/swat.mdl"

function PLAYER:Loadout()
	self.Player:SetMaxHealth(self.MaxHealth)
	self.Player:SetHealth(self.StartHealth)
	self.Player:SetRunSpeed(200)
	self.Player:SetWalkSpeed(self.RunSpeed)
	self.Player:SetMaxSpeed(self.RunSpeed)
	self.Player:SetModel("models/player/swat.mdl")
end

function PLAYER:GiveGuns()	
	self.MoveMultiplier = 1
	self:GiveWeapon(table.Random(swat_primary)) -- Primary
	self:GiveWeapon(table.Random(swat_grenade)) -- grenade
	self:GiveWeapon(table.Random(swat_secondary)) -- Secondary
	self:GiveWeapon(table.Random(swat_special)) -- Special gear
	self:GiveWeapon("weapon_ep_knife") -- Melee
	--self:GiveWeapon("weapon_ep_knife") -- Melee
	--ply:Give("weapon_ep_radio") -- Commanders don't need a radio.
end

local nextRegen = 0

function PLAYER:CommanderBehaviour()
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

	function PLAYER:DrawRadar()
		local width = ScrW()/104
		local height = ScrH()/180
		local offset = width/4
		for k, v in pairs(player.GetAll()) do
			if (v:Team() == TEAM_SWAT and v:Alive()) then
				local pos = (v:GetPos()+Vector(0,0,100)):ToScreen()
				--Old Chevron wallhacks
				
				--draw.NoTexture()
				--surface.DrawTexturedRectRotated( pos.x+offset, pos.y, width, height, 45 )
				--surface.DrawTexturedRectRotated( pos.x-offset, pos.y, width, height, 135 )
				--surface.DrawTexturedRectRotated( pos.x+offset, pos.y-(offset*3), width, height, 45 )
				--surface.DrawTexturedRectRotated( pos.x-offset, pos.y-(offset*3), width, height, 135 )
				
				surface.SetDrawColor( bg_colors.swat )	
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
				draw.SimpleTextOutlined(player_manager.RunClass( v, "ClassName" ), "EPText", xpos, ypos-20-height, font_colors.swat, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, font_colors.black)
				draw.SimpleTextOutlined(string.upper(v:Name()), "EPText", xpos, ypos-34-height, font_colors.swat, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, font_colors.black)
			end
		end
	end
end

player_manager.RegisterClass( "player_commander", PLAYER, "player_default" )