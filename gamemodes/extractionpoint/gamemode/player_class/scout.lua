DEFINE_BASECLASS( "player_default" )

local PLAYER = {}

--
-- See gamemodes/base/player_class/player_default.lua for all overridable variables
--
PLAYER.WalkSpeed 			= 250
PLAYER.RunSpeed				= 250

PLAYER.MaxHealth			= 100		-- Max health we can have
PLAYER.StartHealth			= 100		-- How much health we start with

PLAYER.DisplayName			= "SCOUT"

PLAYER.ClassDescription 	= "SCOUT, FAST ASSAULT CLASS\nMOVE FASTER TO CAPTURE \nTHE RELAY AND TAKE POINT"
PLAYER.ClassPros			= {	"BONUS SPEED"}
PLAYER.ClassCons			= { "NO GRENADES" }

PLAYER.ClassTeam			= 2
PLAYER.Model				= "models/player/leet.mdl"

function PLAYER:Loadout()
	self.Player:SetMaxHealth(self.MaxHealth)
	self.Player:SetHealth(self.StartHealth)
	self.Player:SetRunSpeed(200)
	self.Player:SetWalkSpeed(self.RunSpeed)
	self.Player:SetMaxSpeed(self.RunSpeed)
	self.Player:SetModel("models/player/leet.mdl")
end

function PLAYER:GiveGuns()
	self.MoveMultiplier = 1
	self:GiveWeapon(table.Random(swat_primary)) -- prmary
	self:GiveWeapon(table.Random(swat_secondary)) -- Secondary
	self:GiveWeapon(table.Random(swat_special)) -- Special gear
	self:GiveWeapon("weapon_ep_knife") -- Melee
	self:GiveWeapon("weapon_ep_radio") -- All swat get a radio.
end

function PLAYER:ClassName()
	return "SCOUT"
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
	function PLAYER:DrawRadar()
		local width = ScrW()/104
		local height = ScrH()/180
		local offset = width/4
		for k, v in pairs(player.GetAll()) do
			if (v:Team() == TEAM_SWAT and v:Alive()) then
				local src = self.Player:GetShootPos()
				local hit = v:GetShootPos()
				local tracedata = {}

				local tracedata = {}
				tracedata.start = src
				tracedata.endpos = hit
				tracedata.filter = self.Owner
				tracedata.mask =MASK_SOLID_BRUSHONLY
				local trace = util.TraceLine(tracedata)
				if !trace.HitWorld then
					local pos = (v:GetPos()+Vector(0,0,100)):ToScreen()
					
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
					draw.SimpleTextOutlined(string.upper(v:Name()), "EPText", xpos, ypos-20-height, font_colors.swat, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, font_colors.black)
				end
			end
		end
	end
end
player_manager.RegisterClass( "player_scout", PLAYER, "player_default" )
