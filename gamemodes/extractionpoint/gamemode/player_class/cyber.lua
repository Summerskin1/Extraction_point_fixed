DEFINE_BASECLASS( "player_default" )

local PLAYER = {} 

--
-- See gamemodes/base/player_class/player_default.lua for all overridable variables
--
PLAYER.WalkSpeed 			= 350
PLAYER.RunSpeed				= 350

PLAYER.MaxHealth			= 200		-- Max health we can have
PLAYER.StartHealth			= 200		-- How much health we start with

PLAYER.DisplayName			= "SHADE"

PLAYER.ClassDescription 	= "SHADE, ELECTRONIC WARFARE EXPERT\nENEMY AND ALLY POSITIONS AND STATUS\nARE ALWAYS VISIBLE TO YOU"
PLAYER.ClassPros			= {	"PERFECT WALLHACKS"}
PLAYER.ClassCons			= {  }

PLAYER.ClassTeam			= 1
PLAYER.Model				= "models/player/soldier_stripped.mdl"

function PLAYER:Loadout()
	self.Player:SetMaxHealth(self.MaxHealth)
	self.Player:SetHealth(self.StartHealth)
	self.Player:SetRunSpeed(200)
	self.Player:SetWalkSpeed(self.RunSpeed)
	self.Player:SetMaxSpeed(self.RunSpeed)
	self.Player:SetModel("models/player/soldier_stripped.mdl")
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

	function PLAYER:DrawRadar()
		local width = ScrW()/104
		local height = ScrH()/180
		local offset = width/4
		
		for k, v in pairs(player.GetAll()) do
			
			if (v:Team() == TEAM_SWAT and v:Alive() and !player_manager.RunClass(v,"OperatorBehaviour")) then
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
				surface.DrawLine( left,down,left+10,down )
				surface.DrawLine( left,down,left,down-10 )
				surface.DrawLine( left,up,left+10,up )
				surface.DrawLine( left,up,left,up+10 )
				surface.DrawLine( right, up, right-10, up )
				surface.DrawLine( right, up, right, up+10 )
				surface.DrawLine( right,down,right-10,down )
				surface.DrawLine( right,down,right,down-10 )
				
				local xpos = left
				local ypos = up
				local height = ScrH()/96
				local health = v:Health()/100
				surface.SetMaterial(pip)
				for i = 0, v:Health()/25, 1 do
					alpha = (health*4) - (i)
					surface.SetDrawColor( bg_colors.swat.r, bg_colors.swat.g, bg_colors.swat.b, alpha*255 )
					surface.DrawRect( xpos+(height*i*1.1), ypos-height-3, height, height)
					surface.SetDrawColor( 0, 0, 0, alpha*1000 )
					surface.DrawOutlinedRect( xpos+(height*i*1.1), ypos-height-3, height, height)
				end
				draw.SimpleTextOutlined(player_manager.RunClass( v, "ClassName" ), "EPText", xpos, ypos-20-height, font_colors.swat, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, font_colors.black)
				draw.SimpleTextOutlined(string.upper(v:Name()), "EPText", xpos, ypos-34-height, font_colors.swat, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, font_colors.black)
				if v:GetActiveWeapon().DrawDetails then
					--draw.SimpleTextOutlined(string.upper(v:GetActiveWeapon().PrintName), "EPText", xpos, ypos-34-height, font_colors.ghost, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, font_colors.black)
					v:GetActiveWeapon():DrawDetails(xpos+20, ypos-80, 20, 20, 200, true)
				end
					--draw.SimpleTextOutlined(string.upper(v:GetActiveWeapon().PrintName), "EPText", xpos, ypos-34-height, font_colors.swat, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, font_colors.black)
			end		
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
				surface.DrawLine( left,down,left+10,down )
				surface.DrawLine( left,down,left,down-10 )
				surface.DrawLine( left,up,left+10,up )
				surface.DrawLine( left,up,left,up+10 )
				surface.DrawLine( right, up, right-10, up )
				surface.DrawLine( right, up, right, up+10 )
				surface.DrawLine( right,down,right-10,down )
				surface.DrawLine( right,down,right,down-10 )
				
				local xpos = left
				local ypos = up
				local height = ScrH()/64
				local health = v:Health()/100
				surface.SetMaterial(pip)	for i = 0, v:Health()/25, 1 do
			
				local w = height*1.3
				local h = height
				local xb = xpos+i*height*1
				local yb
				if math.mod(i,2) == 1 then
					yb = ypos
				else
					yb = ypos-height/2
				end
				outline = {};
				outline[1]= {x = xb+(h*0.3), 			y = yb+0}
				outline[2]= {x = xb+w-(h*0.3), 			y = yb+0}
				outline[3]= {x = xb+w,					y = yb+h/2}
				outline[4]= {x = xb+w-(h*0.3), 			y = yb+h}
				outline[5]= {x = xb+(h*0.3), 			y = yb+h}
				outline[6]= {x = xb+0,					y = yb+h/2}
				
				top = {};
				top[1]= {x = xb+(h*0.3), 				y = yb+0}
				top[2]= {x = xb+w-(h*0.3), 				y = yb+0}
				top[3]= {x = xb+w,						y = yb+h/2}
				top[4]= {x = xb+0,						y = yb+h/2}
				
				bot = {};
				bot[1]= {x = xb+w,						y = yb+h/2}
				bot[2]= {x = xb+w-(h*0.3), 				y = yb+h}
				bot[3]= {x = xb+(h*0.3), 				y = yb+h}
				bot[4]= {x = xb+0,						y = yb+h/2}
				alpha = (health*4) - (i)
				surface.SetTexture(0)
				local redden = Color(244,0,0,math.Clamp(100-alpha*100,0,255))
				local alp = math.Clamp(alpha*255,0,255)
				if alp > 20 then
				surface.SetDrawColor( bg_colors.ghostlight.r,bg_colors.ghostlight.g,bg_colors.ghostlight.b, alp ) --set the additive color
				surface.DrawPoly( top ) --draw the triangle with our triangle table
				surface.SetDrawColor( bg_colors.ghost.r,bg_colors.ghost.g,bg_colors.ghost.b, alp ) --set the additive color
				surface.DrawPoly( bot ) --draw the triangle with our triangle table
					surface.SetDrawColor( redden ) --set the additive color
				surface.DrawPoly( outline ) --draw the triangle with our triangle table
				surface.SetDrawColor( line_colors.ghost ) --set the additive color
				for k, v in pairs(outline) do
					if k == table.Count(outline) then
						surface.DrawLine( v.x, v.y, outline[1].x, outline[1].y )
					else
						surface.DrawLine( v.x, v.y, outline[k+1].x, outline[k+1].y )
					end
				end
				end
				--surface.SetDrawColor( bg_colors.ghost.r, bg_colors.ghost.g, bg_colors.ghost.b, alpha*255 )
				--surface.DrawRect( xpos+(height*i*1.1), ypos, height, height)
				--surface.SetDrawColor( line_colors.ghost.r,line_colors.ghost.g,line_colors.ghost.b, alpha*1000 )
				--surface.DrawOutlinedRect( xpos+(height*i*1.1), ypos, height, height)
			end
    --surfa
				draw.SimpleTextOutlined(player_manager.RunClass( v, "ClassName" ), "EPText", xpos, ypos-20-height, font_colors.ghost, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, font_colors.black)
				draw.SimpleTextOutlined(string.upper(v:Name()), "EPText", xpos, ypos-34-height, font_colors.ghost, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, font_colors.black)
				if v:GetActiveWeapon().DrawDetails then
					--draw.SimpleTextOutlined(string.upper(v:GetActiveWeapon().PrintName), "EPText", xpos, ypos-34-height, font_colors.ghost, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, font_colors.black)
					v:GetActiveWeapon():DrawDetails(xpos+20, ypos-80, 20, 20, 200, true)
				end
			end
		end
		local items = {}
		items["ep_motion_detector"] = "MOTION DETECTOR"
		items["ep_frag_grenade"] = "FRAG"
		items["ep_he_nade"] = "HE"
		items["ep_stun_nade"] = "STUN"
		items["ep_gas_nade"] = "GAS GRENADE"
		items["ep_shell"] = "SHELL"
		items["ep_mirv"] = "MIRV"
		items["ep_plasma_projectile"] = "PLASMA BALL"
		items["ep_dart"] = "EXPLOSIVE DART"
		items["ep_rocket"] = "ROCKET"
		items["ep_chaff_nade"] = "CHAFF GRENADE"
		items["ep_caltrop_grenade"] = "CALTROP GRENADE"
		items["ep_trip"] = "TRIP MINE"
		items["ep_detpack"] = "DET PACK"
		items["ep_miniturret"] = "MINI TURRET"
		items["ep_ghost_shield"] = "SHIELD"
		for k, v in pairs(ents.GetAll()) do
			local alive = false
			if v.GetDead then
				alive = !v:GetDead()
			else
				alive = true
			end
			surface.SetDrawColor( Color(255,0,0,255) )	
			if (items[v:GetClass()]) and alive then
				local pos = (v:GetPos()):ToScreen()
				local Min = v:GetPos()-v:OBBMins()
				local Max = v:GetPos()-v:OBBMaxs()
				Min,Max = v:GetCollisionBounds()
				Min = v:GetPos() - Min
				Max = v:GetPos() - Max
				local pos = v:GetPos()
				local left,right,up,down
				local height = math.Clamp(math.abs(Max:ToScreen().y-Min:ToScreen().y),15,1000)
				local width = math.Clamp(math.abs(Max:ToScreen().x-Min:ToScreen().x),15,1000)
				local scrpos = pos:ToScreen()
				left = scrpos.x-width
				right = scrpos.x+width
				down = scrpos.y+height
				up = scrpos.y-height
				surface.SetAlphaMultiplier( 1-3*math.abs(-scrpos.x/ScrW()+0.5)) 
				surface.DrawLine( left,down,left+10,down )
				surface.DrawLine( left,down,left,down-10 )
				surface.DrawLine( left,up,left+10,up )
				surface.DrawLine( left,up,left,up+10 )
				surface.DrawLine( right, up, right-10, up )
				surface.DrawLine( right, up, right, up+10 )
				surface.DrawLine( right,down,right-10,down )
				surface.DrawLine( right,down,right,down-10 )
				
				local xpos = left
				local ypos = up
				local height = ScrH()/96
				draw.SimpleTextOutlined(string.upper(items[v:GetClass()]), "EPText", xpos, ypos-8-height, font_colors.ghost, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, font_colors.black)
			end
			if v:GetClass() == "ep_caltrop" then
				local pos = v:GetPos():ToScreen()
				surface.DrawLine( pos.x,pos.y-5,pos.x,pos.y-3 )
				surface.DrawLine( pos.x,pos.y,pos.x,pos.y-1 )
			end
			surface.SetAlphaMultiplier( 1 ) 
		end
	end
end

player_manager.RegisterClass( "player_cyber", PLAYER, "player_default" )