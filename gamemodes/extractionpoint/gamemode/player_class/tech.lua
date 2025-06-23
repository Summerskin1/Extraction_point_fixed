DEFINE_BASECLASS( "player_default" )

local PLAYER = {} 

--
-- See gamemodes/base/player_class/player_default.lua for all overridable variables
--
PLAYER.WalkSpeed 			= 170
PLAYER.RunSpeed				= 170

PLAYER.DisplayName			= "TECHNICIAN"

PLAYER.ClassDescription 	= "TECHNICIAN, TECHNOLOGY EXPERT\nNEVER FAIL A FAST RELOAD\nPERMANENT MOTION DETECTOR\nDEFUSE EXPLOSIVES WITH THE USE KEY"
PLAYER.ClassPros			= {	"NEVER FAIL RELOADS",
								"PERMANENT MOTION DETECTOR",
								"DEFUSE EXPLOSIVES"}
PLAYER.ClassCons			= { }
PLAYER.MaxHealth			= 100		-- Max health we can have
PLAYER.StartHealth			= 100		-- How much health we start with

PLAYER.ClassTeam			= 2
PLAYER.Model				= "models/player/riot.mdl"

function PLAYER:Loadout()
	self.Player:SetMaxHealth(self.MaxHealth)
	self.Player:SetHealth(self.StartHealth)
	self.Player:SetRunSpeed(200)
	self.Player:SetWalkSpeed(self.RunSpeed)
	self.Player:SetMaxSpeed(self.RunSpeed)
	self.Player:SetModel("models/player/riot.mdl")
end

function PLAYER:ReloadPenalty()
	return false
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

local sin,cos,rad = math.sin,math.cos,math.rad
local function GenerateCircle(x,y,radius,quality)
    local circle = {};
    local tmp = 0;
	local s,c;
    for i=1,quality do
        tmp = rad(i*360)/quality;
		s = sin(tmp);
		c = cos(tmp);
        circle[i] = {x = x + c*radius,y = y + s*radius,u = (c+1)/2,v = (s+1)/2};
    end
    return circle;
end

	function PLAYER:DrawRadar()
	
		local objects = player.GetAll()
		surface.SetTexture(0) --set the texture of the triangle
		surface.SetDrawColor( Color(50,50,120,50) ) --set the additive color
		local x = ScrW()/2
		local y = (ScrH()/3)
		surface.DrawPoly( GenerateCircle(x,y,100,100 )) --draw the triangle with our triangle table
		-- The functions you are messing around with go here
		local vec = self.Player:EyeAngles():Forward()
		vec.z = 0
		vec:Normalize()
		surface.SetDrawColor( Color(120,120,240,255) ) --set the additive color
		surface.DrawLine( x, y, vec.y*20+x,vec.x*20+y)
		surface.SetDrawColor( Color(120,120,240,200) ) --set the additive color
		surface.DrawLine( vec.y*20+x,vec.x*20+y, vec.y*40+x,vec.x*40+y)
		surface.SetDrawColor( Color(120,120,240,150) ) --set the additive color
		surface.DrawLine( vec.y*40+x,vec.x*40+y, vec.y*60+x,vec.x*60+y)
		surface.SetDrawColor( Color(120,120,240,100) ) --set the additive color
		surface.DrawLine( vec.y*60+x,vec.x*60+y, vec.y*80+x,vec.x*80+y)
		surface.SetDrawColor( Color(120,120,240,50) ) --set the additive color
		surface.DrawLine( vec.y*80+x,vec.x*80+y, vec.y*100+x,vec.x*100+y)
		for k,v in ipairs (objects) do
				--if !v:IsValid() then return end
			if v:IsPlayer() then
				local relpos = (v:GetPos()-self.Player:GetPos())/10
				relpos.z = 0
				if relpos:Length() < 100 then
					local speedmod = v:GetVelocity():Length()/2
					surface.SetDrawColor(  (speedmod*3)-200, 500-speedmod*3, 0, speedmod-30) 
					surface.DrawRect(relpos.y-2+x , relpos.x-8+y, 4, 8 )
					surface.DrawRect(relpos.y-2+x , relpos.x+4+y, 4, 4 )
				end
			end
		end
		
		local width = ScrW()/104
		local height = ScrH()/180
		local offset = width/4
		for k, v in pairs(player.GetAll()) do
			if (v:Team() == TEAM_SWAT and v:Alive()) then
				local src = self.Player:GetShootPos()
				local hit = v:GetShootPos()
				
				local tracedata = {}
				tracedata.start = src
				tracedata.endpos = hit
				tracedata.filter = self.Owner
				tracedata.mask = MASK_SOLID_BRUSHONLY
				local trace = util.TraceLine(tracedata)
				if !trace.HitWorld then
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
					draw.SimpleTextOutlined(string.upper(v:Name()), "EPText", xpos, ypos-20-height, font_colors.swat, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, font_colors.black)
				end
			end
		end
	end
end

function PLAYER:Defuse()
	return true
end
player_manager.RegisterClass( "player_tech", PLAYER, "player_default" )