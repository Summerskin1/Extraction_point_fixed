DEFINE_BASECLASS( "player_wisp" )

local PLAYER = {} 

--
-- See gamemodes/base/player_class/player_default.lua for all overridable variables
--
PLAYER.WalkSpeed 			= 350
PLAYER.RunSpeed				= 350

PLAYER.MaxHealth			= 200		-- Max health we can have
PLAYER.StartHealth			= 200		-- How much health we start with

PLAYER.DisplayName			= "WILL O WISP"

PLAYER.ClassDescription 	= "WILL O WISP, PASSIVE DAMAGE DEALER\nDEALS DAMAGE TO NEARBY SWAT\nUPON HIS DEATH, HE DETONATES VIOLENTLY.\nTOO VISIBLE TO CLOAK"
PLAYER.ClassPros			= {	"PASSIVE DAMAGE TO NEARBY FOES",
								"EXPLODES ON DEATH" }
PLAYER.ClassCons			= { "HIGH VISIBILITY",
								"CLOAKING WON'T HIDE YOUR TRAIL"}

PLAYER.ClassTeam			= 1
PLAYER.Model				= "models/player/combine_soldier_prisonguard.mdl"

function PLAYER:Loadout()
	self.Player:SetMaxHealth(self.MaxHealth)
	self.Player:SetHealth(self.StartHealth)
	self.Player:SetRunSpeed(200)
	self.Player:SetWalkSpeed(self.RunSpeed)
	self.Player:SetMaxSpeed(self.RunSpeed)
	self.Player:SetModel(self.Model)
	if SERVER then
		util.SpriteTrail(self.Player:GetWeapon("weapon_ep_knife"), 0, Color(200, 180, 110), false, 40, 20, 1, 1/5*0.5, "trails/laser.vmt");
	end
	self.Player.nextPing = 0
end

function PLAYER:WispBehaviour()
	return true
end


function PLAYER:Tick()
	self:UpdateSpeed()
	if self.Player.nextPing < CurTime() and self.Player:Alive() then
		local ed = EffectData()
		ed:SetEntity(self.Player)
		ed:SetOrigin(self.Player:GetPos() + Vector(0,0,10))
		util.Effect( "wisp_aura", ed, true, true )	
		ed:SetStart(self.Player:GetPos() + Vector(0,0,30))
		ed:SetOrigin(self.Player:GetPos()+VectorRand()*300)
		util.Effect( "wisp_arc", ed, true, true )
		ed:SetOrigin(self.Player:GetPos()+VectorRand()*300)
		util.Effect( "wisp_arc", ed, true, true )
		ed:SetOrigin(self.Player:GetPos()+VectorRand()*300)
		util.Effect( "wisp_arc", ed, true, true )
		if math.random(0,5) == 5 then
			self.Player:EmitSound("weapons/stunstick/stunstick_impact2.wav", self.Player:GetPos(), 10, math.Rand(40,110))
		end
		local players = player.GetAll()
		for k,v in pairs (players) do
			if v:Team() == TEAM_SWAT and (v:GetPos() - self.Player:GetPos()):Length() < 600 and v != self.Player and v:Alive() then
				local src = self.Player:GetShootPos()
				local hit = v:GetShootPos()
				local tracedata = {}
				
				local tracedata = {}
				tracedata.start = src
				tracedata.endpos = hit
				tracedata.filter = self.Owner
				tracedata.mask = MASK_VISIBLE
				local trace = util.TraceLine(tracedata)
				--print(trace.Entity:GetClass())
				if !(trace.HitWorld) then
					if !trace.Hit or trace.Entity:IsPlayer() then
						v:TakeDamage( 5, self.Player, self.Player )
						local ed = EffectData()
						ed:SetStart(self.Player:GetShootPos())
						ed:SetOrigin(v:GetPos()+Vector(0,0,30))
						ed:SetEntity(self.Player)
						util.Effect( "wisp_arc", ed, true, true )
						self.Player:EmitSound("weapons/stunstick/spark3.wav", self.Player:GetPos(), 70, math.Rand(70,110))
					end
				end
			end
		end
		self.Player.nextPing = CurTime()+0.4
	end
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

player_manager.RegisterClass( "player_wisp", PLAYER, "player_default" )