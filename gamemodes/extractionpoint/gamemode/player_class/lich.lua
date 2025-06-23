DEFINE_BASECLASS( "player_wisp" )

local PLAYER = {}

--
-- See gamemodes/base/player_class/player_default.lua for all overridable variables
--
PLAYER.WalkSpeed 			= 280
PLAYER.RunSpeed				= 280

PLAYER.MaxHealth			= 200		-- Max health we can have
PLAYER.StartHealth			= 200		-- How much health we start with

PLAYER.DisplayName			= "LICH"

PLAYER.ClassDescription 	= "LICH, HARASSMENT SPECIALIST\nSPECIALISES IN GAS WEAPONS"
PLAYER.ClassPros			= {	"EXTRA GAS GRENADES",
								"GAS HEALS YOU",
								"DEAD SWAT CREATE TOXIC GAS"}
PLAYER.ClassCons			= { "SLOW" }

PLAYER.ClassTeam			= 1
PLAYER.Model				= "models/player/charple.mdl"

function PLAYER:GiveGuns()
	--No primary.
	self.MoveMultiplier = 1
	self:GiveWeapon(table.Random(ghost_primary)) -- Primary
	self:GiveWeapon(table.Random(ghost_secondary)) -- Secondary
	self:GiveWeapon("weapon_ep_lich_gas") -- grenade
	self:GiveWeapon(table.Random(ghost_special)) -- Special item
	self:GiveWeapon("weapon_ep_knife") -- Melee
end
function PLAYER:Loadout()
	self.Player:SetMaxHealth(self.MaxHealth)
	self.Player:SetHealth(self.StartHealth)
	self.Player:SetRunSpeed(200)
	self.Player:SetWalkSpeed(self.RunSpeed)
	self.Player:SetMaxSpeed(self.RunSpeed)
	self.Player:SetModel(self.Model)
	self.Player.nextPing = 0
end

function PLAYER:Tick()
	self:UpdateSpeed()
end

function PLAYER:LichBehaviour()
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
	ghost = Color(40, 40, 40, 200),
	ghostlight = Color(80, 80, 80, 200),
	swat = Color(80, 80, 110, 200),
	swatlight = Color(160, 160, 220, 200),
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

player_manager.RegisterClass( "player_lich", PLAYER, "player_default" )
