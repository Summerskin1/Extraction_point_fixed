
if SERVER then
   AddCSLuaFile( "shared.lua" )
	util.AddNetworkString("StartReload")
	util.AddNetworkString("ReloadResult")
end

---- Extraction Point Fields


SWEP.HoldTypeAim  = "ar2"

SWEP.BodyDamage = 1
SWEP.HeadDamage = 1

SWEP.ScopeInTime = 1
SWEP.ZoomAmt = 1
SWEP.ZoomCone = 1
SWEP.ZoomMoveSpeed = 150
SWEP.NormalCone = 0
SWEP.ZoomSensitivity = 1

SWEP.SpeedMult = 1

SWEP.RestPos = Vector(-1.5, 1, -1.2)
SWEP.RestRot = Angle(-2,2,-5)
--SWEP.RestPos = Vector(0,0,0)
--SWEP.RestRot = Angle(0,0,0)
SWEP.ZoomPos = Vector(-5.5, -4, 1)
SWEP.ZoomRot = Angle(0,0,-5)

SWEP.DrySound = Sound( "Weapon_Pistol.Empty" )

--Fast reload stuff

SWEP.ReloadDown			= false
SWEP.ReloadStart		= 0
SWEP.Reloading			= false
SWEP.ReloadLength		= 2
SWEP.ReloadCritStart	= 0.2
SWEP.ReloadCritEnd		= 1.8
SWEP.ReloadAnimLength	= 1
SWEP.ReloadFailed		= false

SWEP.SuccessPoint		= 0
SWEP.LastReload			= 2
SWEP.FinishReloadTime		= 0

SWEP.ReloadWidth = 130

SWEP.DrawTime = 0

SWEP.HideAmmo = false

-- This must be set to one of the WEAPON_ types in TTT weapons for weapon
-- carrying limits to work properly. See /gamemode/shared.lua for all possible
-- weapon categories.
SWEP.Kind = WEAPON_NONE


if CLIENT then
   SWEP.PrintName			= "DEBUG"
   SWEP.Icon = "VGUI/ep/sample" -- placeholder
   SWEP.Author = "Cooldown Studios"
   SWEP.WeaponDesc = "Should not see this contact a Dev"
   SWEP.PrimaryInstruction = "Fire bullets"
   SWEP.SecondaryInstruction = "Aim down sights"
   SWEP.CamPos = Vector(60,35,10)
   SWEP.LookPos = Vector(10,0,0)

   surface.CreateFont( "EP_Wepfont", {
	font = "csd",
	size = 60,
	weight = 500,
	blursize = 1.5,
	scanlines = 1,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
	} )
   surface.CreateFont( "EP_Wepfont2", {
	font = "halflife2",
	size = 60,
	weight = 500,
	blursize = 1.5,
	scanlines = 1,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
	} )

   SWEP.IconLetter = "a"
   --grenade h
   --lightpis a
   --knife j
   --scout n
   --p90 m
   --shotgun k
   --ump q
   --awp r
   --dual s
   --comat t
   --pincer u
   --vector w
   --mp5 x
   --mg z
   --HC A
   --Boomer B
   --K +
   --FRAG O
   --other nades P Q

   SWEP.IconFont = "EP_Wepfont"
end

---- Extraction Point SWEP STUFF

SWEP.Base				= "weapon_base"

if CLIENT then
   SWEP.DrawCrosshair   = false
   SWEP.ViewModelFOV    = 82
   SWEP.ViewModelFlip   = true
   SWEP.CSMuzzleFlashes = true
end

SWEP.UseHands			= true
SWEP.ViewModel			= "models/weapons/c_smg1.mdl"
SWEP.WorldModel			= ""
SWEP.Slot				= 0
SWEP.SlotPos			= 0

SWEP.Category           = "ep"
SWEP.Spawnable          = false
SWEP.AdminSpawnable     = false

SWEP.IsGrenade = false

SWEP.Weight             = 5
SWEP.AutoSwitchTo       = false
SWEP.AutoSwitchFrom     = false

SWEP.Primary.Sound          = Sound( "Weapon_Pistol.Empty" )
SWEP.Primary.Recoil         = 15.5
SWEP.Primary.Damage         = 1
SWEP.Primary.NumShots       = 1
SWEP.Primary.Cone           = 0.02
SWEP.Primary.Delay          = 3.15

SWEP.Primary.ClipSize       = -1
SWEP.Primary.Clips       	= 5
SWEP.Primary.MaxClips       = 5
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = false
SWEP.Primary.Ammo           = "none"
SWEP.Primary.ClipMax        = -1
SWEP.Primary.SoundLevel		= 90

SWEP.Secondary.ClipSize     = 1
SWEP.Secondary.DefaultClip  = 1
SWEP.Secondary.Automatic    = false
SWEP.Secondary.Ammo         = "none"
SWEP.Secondary.ClipMax      = -1

SWEP.StoredAmmo = 0
SWEP.IsDropped = false

SWEP.DeploySpeed = 1.4
SWEP.ScopeStart = 0
CROSSHAIR_GHOST = Color( 200, 150, 50, 255 )
CROSSHAIR_SWAT = Color( 150, 150, 200, 255 )

--HUD Materials
if CLIENT then
	local params = {
		["$basetexture"] = "VGUI/ammo_icons/hud_ammo_clip_full",
		["$additive"] = 1,
		["$nocull"] = 1,
		["$translucent"] = 1,
		["$softedges"] = 1,
		["$edgesofsoftnessstart"] = 0.6,
		["$edgesofsoftnessend"] = 0.2,
		["$vertexalpha"] = 1,
		["$vertexcolor"] = 1,
		["$vertexalpha"] = 1
	}
	SWEP.ClipFull 			= CreateMaterial("EP_ClipFull","UnlitGeneric",params)

	local params = {
		["$basetexture"] = "VGUI/ammo_icons/hud_ammo_clip_empty",
		["$additive"] = 1,
		["$nocull"] = 1,
		["$translucent"] = 1,
		["$softedges"] = 1,
		["$edgesofsoftnessstart"] = 0.6,
		["$edgesofsoftnessend"] = 0.2,
		["$vertexalpha"] = 1,
		["$vertexcolor"] = 1,
		["$vertexalpha"] = 1
	}
	SWEP.ClipEmpty 			= CreateMaterial("EP_ClipEmpty","UnlitGeneric",params)
end
SWEP.PrimaryAnim = ACT_VM_PRIMARYATTACK
SWEP.SecondaryAnim = ACT_VM_SECONDARYATTACK
SWEP.ReloadAnim = ACT_VM_RELOAD


-- crosshair
if CLIENT then

	function SWEP:DrawClips(x, y)
		//CLIPS CODE//
		if self.Owner:Team() == TEAM_GHOST then
			surface.SetDrawColor(CROSSHAIR_GHOST)
		else
			surface.SetDrawColor(CROSSHAIR_SWAT)
		end

		local offset = draw.GetFontHeight("EPAmmo")
		local clipwidth = ScrW()/64
		if self.Primary.Clips > 7 then
			draw.DrawText( "x"..self.Primary.Clips,"EPAmmo", x + offset*1.1, y, Color(220,220,220), TEXT_ALIGN_LEFT )
			surface.SetMaterial( self.ClipFull )
			surface.DrawTexturedRect(x + offset/2 , y+clipwidth/4, clipwidth, clipwidth )
		else
			for i=1,self.Primary.MaxClips do
				if i<=self.Primary.Clips then
					surface.SetMaterial( self.ClipFull )
				else
					surface.SetMaterial( self.ClipEmpty )
				end
				if i <= 7 then
					surface.DrawTexturedRect(x + (math.floor(offset/3))*i , y+clipwidth/4, clipwidth, clipwidth )
				end
			end
		end
	end

	function SWEP:DrawFastReloadBar()
		self.DrawTime = CurTime()

		local critstart = (self.ReloadCritStart/self.ReloadLength)*self.ReloadWidth
		local critlength = ((self.ReloadCritEnd-self.ReloadCritStart)/self.ReloadLength)*self.ReloadWidth*0.8
		local reloadtime = 0
		local point = ((CurTime()-self.ReloadStart+0)/self.ReloadLength)*self.ReloadWidth
		--if self.Owner:Ping() > 120 then --Only do it if our ping is a lot higher than normal, this is a little hacky but it's probably more accurate than when you're running 500 ping
			--point = ((CurTime()-self.ReloadStart+0.07+self.Owner:Ping()/1000)/self.ReloadLength)*self.ReloadWidth
		--end
		local x, y = ScrW() / 2.0, ScrH() / 2.0
		local boxwidth = 143
		//RELOADING BAR//

		if self.Reloading == true then

			x = ScrW()/2 - self.ReloadWidth/2
			y = ScrH()/2 + ScrH()/10

			surface.SetDrawColor( 220, 220, 220, 255)
			surface.DrawRect(x-1, y-1, self.ReloadWidth+2, 22 )
			if self.ReloadFailed == false then
				surface.SetDrawColor( 45, 45, 45, 255)
			else
				surface.SetDrawColor( 100+30*math.sin(CurTime()*20), 45, 45, 255)
				if player_manager.RunClass( self.Owner, "ReloadPenalty" ) then
					point = ((CurTime()-self.ReloadStart+self.ReloadLength)/(self.ReloadLength*2))*self.ReloadWidth
				end
			end
			surface.DrawRect(x , y, self.ReloadWidth, 20 )

			surface.SetDrawColor( 170, 170, 170, 255)
			surface.DrawRect(x+critstart , y+2, critlength, 16 )
			if point < self.ReloadWidth then
				surface.SetDrawColor( 220, 220, 220, 255)
				surface.DrawRect(x+point , y+1, 2, 18 )
			end
		end

		//RELOADEND//
		if self.Reloading == false then

			x = ScrW()/2 - self.ReloadWidth/2
			y = ScrH()/2 + ScrH()/10

			local redmod = 0
			local whitemod = 0
			local alphamod = math.Clamp((self.FinishReloadTime+0.5-CurTime())*2, 0, 255)

			if self.LastReload == 0 then //Crit
				whitemod = 100
			end
			if self.LastReload == 1 then //Fail
				redmod = 55+30*math.sin(CurTime()*20)
			end

			surface.SetDrawColor( (220+redmod+whitemod)*alphamod, (220+whitemod)*alphamod, (220+whitemod)*alphamod, 255*alphamod)
			surface.DrawOutlinedRect(x-1, y-1, self.ReloadWidth+2, 22 )

			surface.SetDrawColor( (45+redmod+whitemod)*alphamod, (45+whitemod)*alphamod, (45+whitemod)*alphamod, 122*alphamod)
			surface.DrawRect(x , y, self.ReloadWidth, 20 )

			surface.SetDrawColor( (80+redmod+whitemod)*alphamod, (80+whitemod)*alphamod, (80+whitemod)*alphamod, 122*alphamod)
			surface.DrawRect(x+critstart , y+2, critlength, 16 )
			if self.LastReload == 0 then
				surface.SetDrawColor( (220+redmod+whitemod)*alphamod, (220+whitemod)*alphamod, (220+whitemod)*alphamod, 122*alphamod)
				surface.DrawRect(x+self.SuccessPoint , y+1, 2, 18 )
			end
		end
	end
	function SWEP:DrawCross()
	--Won't be here forever, just testing.
		self:DrawFastReloadBar()

		--gets the center of the screen
		local x = math.floor(ScrW() / 2)
		local y = math.floor(ScrH() / 2)

		--set the drawcolor
		local gap = 0
		--local gap = self.Primary.Cone*ScrW()/2 + math.Clamp(self.Weapon:GetNextPrimaryFire() - CurTime(), 0, 20)*50
		if self:GetScoped() or player_manager.RunClass(self.Owner, "PointmanBehaviour") then
			gap = self.ZoomCone*ScrW()/(2/self.ZoomAmt)
		else
			gap = self.NormalCone*ScrW()/2
		end
		local length = gap + ScrW()/256

		--Turn them into ints to prevent ugly drawing.
		gap = math.floor(gap)
		length = math.floor(length)

		local dark = Color(80,80,80,255)
		--draw the crosshair
		if self.Owner:Team() == TEAM_GHOST then
			if self:GetScoped( ) or player_manager.RunClass(self.Owner, "PointmanBehaviour") then
				local offset = math.floor(ScrW()/256)
				gap = math.Clamp(gap, offset*2.1, 500)
				local width = math.floor(math.Clamp(gap/2, offset, 500))
				local leftpos = math.floor(x - gap)
				local rightpos = math.floor(x + gap)
				--Left
				draw.RoundedBox( 1, leftpos-offset-1, y - 1, offset+2, 3, CROSSHAIR_GHOST )
				draw.RoundedBox( 1, leftpos-1, y - width - 1, 3, width*2+2, CROSSHAIR_GHOST )
				draw.RoundedBox( 1, leftpos-1, y - width - 1, offset+2, 3, CROSSHAIR_GHOST )
				draw.RoundedBox( 1, leftpos-1, y + width - 1, offset+2, 3, CROSSHAIR_GHOST )

				surface.SetDrawColor( dark )
				surface.DrawLine( leftpos, y, leftpos - offset, y )
				surface.DrawLine( leftpos, y + width, leftpos, y - width )
				surface.DrawLine( leftpos, y + width, leftpos + offset, y + width )
				surface.DrawLine( leftpos, y - width, leftpos + offset, y - width )

				--Right
				draw.RoundedBox( 1, rightpos-1, y - 1, offset+2, 3, CROSSHAIR_GHOST )
				draw.RoundedBox( 1, rightpos-1, y - width - 1, 3, width*2+2, CROSSHAIR_GHOST )
				draw.RoundedBox( 1, rightpos-offset-1, y - width - 1, offset+2, 3, CROSSHAIR_GHOST )
				draw.RoundedBox( 1, rightpos-offset-1, y + width - 1, offset+3, 3, CROSSHAIR_GHOST )

				surface.SetDrawColor( dark )
				surface.DrawLine( rightpos, y, rightpos + offset, y )
				surface.DrawLine( rightpos, y + width, rightpos, y - width )
				surface.DrawLine( rightpos, y + width, rightpos - offset, y + width )
				surface.DrawLine( rightpos, y - width, rightpos - offset, y - width )

				--Centre
				draw.RoundedBox( 2, x-2, y-2, 5, 5, CROSSHAIR_GHOST )
				draw.RoundedBox( 2, x-1, y-1, 3, 3, dark )
			else
				local offset = math.floor(ScrW()/256)
				gap = math.Clamp(gap, offset*2.1, 500)
				local width = math.floor(math.Clamp(gap/2, offset, 500))
				local leftpos = math.floor(x - gap)
				local rightpos = math.floor(x + gap)
				--Left
				draw.RoundedBox( 1, leftpos-offset-1, y - 1, offset+2, 3, CROSSHAIR_GHOST )
				draw.RoundedBox( 1, leftpos-1, y - width - 1, 3, width*2+2, CROSSHAIR_GHOST )
				draw.RoundedBox( 1, leftpos-1, y - width - 1, offset+2, 3, CROSSHAIR_GHOST )
				draw.RoundedBox( 1, leftpos-1, y + width - 1, offset+2, 3, CROSSHAIR_GHOST )

				surface.SetDrawColor( dark )
				surface.DrawLine( leftpos, y, leftpos - offset, y )
				surface.DrawLine( leftpos, y + width, leftpos, y - width )
				surface.DrawLine( leftpos, y + width, leftpos + offset, y + width )
				surface.DrawLine( leftpos, y - width, leftpos + offset, y - width )

				--Right
				draw.RoundedBox( 1, rightpos-1, y - 1, offset+2, 3, CROSSHAIR_GHOST )
				draw.RoundedBox( 1, rightpos-1, y - width - 1, 3, width*2+2, CROSSHAIR_GHOST )
				draw.RoundedBox( 1, rightpos-offset-1, y - width - 1, offset+2, 3, CROSSHAIR_GHOST )
				draw.RoundedBox( 1, rightpos-offset-1, y + width - 1, offset+3, 3, CROSSHAIR_GHOST )

				surface.SetDrawColor( dark )
				surface.DrawLine( rightpos, y, rightpos + offset, y )
				surface.DrawLine( rightpos, y + width, rightpos, y - width )
				surface.DrawLine( rightpos, y + width, rightpos - offset, y + width )
				surface.DrawLine( rightpos, y - width, rightpos - offset, y - width )
			end
		else
			if self:GetScoped( ) or player_manager.RunClass(self.Owner, "PointmanBehaviour") then
				draw.RoundedBox( 1, x - length - 2, y - 1, (length-gap)+5, 3, dark )
				draw.RoundedBox( 1, x + gap - 2, y - 1, (length-gap)+4, 3, dark )
				draw.RoundedBox( 1, x - 1, y + gap - 2, 3, (length-gap)+4, dark )
				draw.RoundedBox( 1, x-2, y-2, 5, 5, dark )
				surface.SetDrawColor( CROSSHAIR_SWAT )
				surface.DrawLine( x - gap, y, x - length, y )
				surface.DrawLine( x, y + gap, x, y + length )
				surface.DrawLine( x + gap, y, x + length, y )
				draw.RoundedBox( 2, x-1, y-1, 3, 3, CROSSHAIR_SWAT )
			else
				draw.RoundedBox( 1, x - length - 2, y - 1, (length-gap)+5, 3, dark )
				draw.RoundedBox( 1, x + gap - 2, y - 1, (length-gap)+4, 3, dark )
				draw.RoundedBox( 1, x - 1, y + gap - 2, 3, (length-gap)+4, dark )
				surface.SetDrawColor( CROSSHAIR_SWAT )
				surface.DrawLine( x - gap, y, x - length, y )
				surface.DrawLine( x, y + gap, x, y + length )
				surface.DrawLine( x + gap, y, x + length, y )
			end
		end

	end

	function SWEP:DrawAmmo(overrideString)
	if self.HideAmmo then return end
		-- Color presets
		bg_colors = {
			background_main = Color(0, 0, 10, 200),
			default = Color(100,100,100,200),
			ghost = Color(40, 40, 40, 200),
			ghostlight = Color(80, 80, 80, 200),
			swat = Color(200, 200, 205, 70),
			swatlight = Color(50, 50, 140, 200),
			target = Color(80, 80, 200, 255)
		}

		font_colors = {
			default = Color(255, 255, 255, 255),
			black = Color(0,0,0,255),
			ghost = Color(250, 190, 80, 255),
			swat = Color(200, 200, 240, 255),
			target = Color(230, 20, 20, 255)
		}

		local clip = self.Weapon:Clip1()
		local ammo = self.Weapon:Ammo1()

		local right = (ScrW() / 13)
		local posx = ScrW() - right
		local posy = ScrH() - (ScrH() / 8)
		local offset = draw.GetFontHeight("EPAmmo")
		if overrideString != nil then clip = overrideString end

		--Draw Ammo
		if self.Owner:Team() == TEAM_GHOST then
			--Draw ghost ammo stuff
			local w = right*2
			local h = offset*2

			outline = {};
			outline[1]= {x = posx+(h*0.3), 			y = posy+0}
			outline[2]= {x = posx+w-(h*0.3), y = posy+0}
			outline[3]= {x = posx+w,			y = posy+h/2}
			outline[4]= {x = posx+w-(h*0.3), 			y = posy+h}
			outline[5]= {x = posx+(h*0.3), 	y = posy+h}
			outline[6]= {x = posx+0,			y = posy+h/2}

			top = {};
			top[1]= {x = posx+(h*0.3), 			y = posy+0}
			top[2]= {x = posx+w-(h*0.3), y = posy+0}
			top[3]= {x = posx+w,			y = posy+h/2}
			top[4]= {x = posx+0,			y = posy+h/2}

			bot = {};
			bot[1]= {x = posx+w,			y = posy+h/2}
			bot[2]= {x = posx+w-(h*0.3), 			y = posy+h}
			bot[3]= {x = posx+(h*0.3), 	y = posy+h}
			bot[4]= {x = posx+0,			y = posy+h/2}

			surface.SetTexture(0)
			surface.SetDrawColor( bg_colors.ghostlight ) --set the additive color
			surface.DrawPoly( top ) --draw the triangle with our triangle table
			surface.SetDrawColor( bg_colors.ghost ) --set the additive color
			surface.DrawPoly( bot ) --draw the triangle with our triangle table
			surface.SetDrawColor( line_colors.ghost ) --set the additive color
			for k, v in pairs(outline) do
				if k == table.Count(outline) then
					surface.DrawLine( v.x, v.y, outline[1].x, outline[1].y )
				else
					surface.DrawLine( v.x, v.y, outline[k+1].x, outline[k+1].y )
				end
			end

			--End of ammo box.
			self:DrawClips(posx + offset/2, posy + offset-8)
			surface.SetDrawColor( bg_colors.ghost )
			draw.SimpleTextOutlined( clip, "EPAmmo", posx + offset/2, posy + offset, font_colors.ghost, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, font_colors.black)
		end
		if self.Owner:Team() == TEAM_SWAT then
			local w = right*2
			local h = offset*2
			local corner = 10
			outline = {};
			outline[1]= {x = posx+corner, 		y = posy+0}
			outline[2]= {x = posx+w-corner, 	y = posy+0}
			outline[3]= {x = posx+w,			y = posy+corner}
			outline[4]= {x = posx+w,			y = posy+h-corner}
			outline[5]= {x = posx+w-corner, 	y = posy+h}
			outline[6]= {x = posx+corner, 		y = posy+h}
			outline[7]= {x = posx+0,			y = posy+h-corner}
			outline[8]= {x = posx+0,			y = posy+corner}

			top = {};
			top[1]= {x = posx+corner, 		y = posy+0}
			top[2]= {x = posx+w-corner, 		y = posy+0}
			top[3]= {x = posx+w,				y = posy+corner}
			top[4]= {x = posx+w,				y = posy+offset}
			top[5]= {x = posx+0,				y = posy+offset}
			top[6]= {x = posx+0,				y = posy+corner}

			bot = {};
			bot[1]= {x = posx+0,				y = posy+offset}
			bot[2]= {x = posx+w,				y = posy+offset}
			bot[3]= {x = posx+w,				y = posy+h-corner}
			bot[4]= {x = posx+w-corner,		y = posy+h}
			bot[5]= {x = posx+corner,		y = posy+h}
			bot[6]= {x = posx+0,				y = posy+h-corner}


			surface.SetTexture(0)
			surface.SetDrawColor( bg_colors.swatlight ) --set the additive color
			surface.DrawPoly( top ) --draw the triangle with our triangle table
			surface.SetDrawColor( bg_colors.swat ) --set the additive color
			surface.DrawPoly( bot ) --draw the triangle with our triangle table
			surface.SetDrawColor( line_colors.swat ) --set the additive color
			surface.DrawLine( 0,offset,w,offset )
			for k, v in pairs(outline) do
				if k == table.Count(outline) then
					surface.DrawLine( v.x, v.y, outline[1].x, outline[1].y )
				else
					surface.DrawLine( v.x, v.y, outline[k+1].x, outline[k+1].y )
				end
			end




			--surface.SetDrawColor( bg_colors.swat )
			--surface.SetAlphaMultiplier(0.6)
			--draw.RoundedBoxEx( 16, posx, posy, right, offset*2, bg_colors.swat,true,false,true,false )
			surface.SetAlphaMultiplier(1)
			self:DrawClips(posx + offset/2, posy + offset-8)
			draw.SimpleTextOutlined( clip, "EPAmmo", posx + offset/2, posy + offset-2, font_colors.swat, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, font_colors.black)
		end

	end

	function SWEP:DrawHUD()
		self:DrawAmmo()
		self:DrawCross()
	end
	function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
		-- Set us up the texture
		if self.Owner:Team() == TEAM_GHOST then
			surface.SetDrawColor( CROSSHAIR_GHOST )
		else
			surface.SetDrawColor( CROSSHAIR_SWAT )
		end
		self:DrawDetails(x, y, wide,tall ,alpha, true)
		--[[surface.SetTexture( self.WepSelectIcon )

		-- Lets get a sin wave to make it bounce
		local fsin = 0

		if ( self.BounceWeaponIcon == true ) then
			fsin = math.sin( CurTime() * 10 ) * 5
		end

		-- Borders
		y = y + 10
		x = x + 10
		wide = wide - 20

		-- Draw that mother
		surface.DrawTexturedRect( x + ( fsin ), y - ( fsin ),  wide-fsin*2 , ( wide / 2 ) + ( fsin ) )

		-- Draw weapon info box
		self:PrintWeaponInfo( x + wide + 20, y + tall * 0.95, alpha )]]--
	end

	function SWEP:DrawDetails(x, y, wide, tall, alpha, selected)
		--local alphamod = math.Rand(0.5,0.8) -- make it flicker.
		local alphamod = 0.7
		local dark, light
		if self.Owner:Team() == TEAM_SWAT then
			dark = Color( 30, 40, 60, alpha/2 )
			if selected then
				light = Color(150, 200, 250, alpha*alphamod)
			else
				light = Color(90, 120, 170, alpha*alphamod)
			end
		else
			dark = Color( 30, 30, 30, alpha/2 )
			if selected then
				light = Color(255, 190, 80, alpha*alphamod)
			else
				light = Color(160, 110, 40, alpha*alphamod)
			end
		end
		surface.SetDrawColor( dark )
		--surface.DrawRect(x, y, wide, tall )
		surface.SetDrawColor( dark )
		--surface.DrawOutlinedRect(x, y, wide, tall)
		local amt = self:Clip1()/self.Primary.ClipSize
		if self.IconFont == "EP_Wepfont2" then
			draw.SimpleText( self.IconLetter, self.IconFont, x + wide*0.5, y-25+tall*0.25, light, TEXT_ALIGN_CENTER )
		else
			draw.SimpleText( self.IconLetter, self.IconFont, x + wide*0.5, y+tall*0.25, light, TEXT_ALIGN_CENTER )
		end

		surface.SetDrawColor(light )
		surface.DrawRect(x+wide*0.1, y+tall*0.7, wide*0.8*amt, tall*0.1 )

		surface.SetDrawColor( dark )
		surface.DrawOutlinedRect(x+wide*0.1, y+tall*0.7, wide*0.8, tall*0.1 )

		if self.Primary.MaxClips < 9 then
			for i=0,(self.Primary.Clips-1) do
				if self.Primary.Clips > i then
					surface.SetDrawColor( light )
					surface.DrawRect(x+tall*(i/10)+wide*0.1, y+tall*0.8, tall*0.1, tall*0.1 )
				end
				surface.SetDrawColor( dark )
				surface.DrawOutlinedRect(x+tall*(i/10)+wide*0.1, y+tall*0.8, tall*0.1, tall*0.1 )
			end
		else

		end

	end

	function SWEP:PrintWeaponInfo( x, y, alpha )

		if ( self.DrawWeaponInfoBox == false ) then return end

		if ( self.InfoMarkup == nil ) then
			local str
			local title_color = "<color=230,230,230,255>"
			local text_color = "<color=150,150,150,255>"

			--str = "<font>"
			str = ""
			if ( self.PrimaryInstruction != "" ) then str = str .. title_color .. "Primary:</color>\n"..text_color..self.PrimaryInstruction.."</color>\n" end
			if ( self.SecondaryInstruction != "" ) then str = str .. title_color .. "Secondary:</color>\n"..text_color..self.SecondaryInstruction.."</color>\n" end
			--str = str .. "</font>"

			self.InfoMarkup = markup.Parse( str, 250 )
		end

		surface.SetDrawColor( 60, 60, 60, alpha )
		surface.SetTexture( self.SpeechBubbleLid )

		surface.DrawTexturedRect( x, y - 64 - 5, 128, 64 )
		draw.RoundedBox( 8, x - 5, y - 6, 260, self.InfoMarkup:GetHeight() + 18, Color( 60, 60, 60, alpha ) )

		self.InfoMarkup:Draw( x+5, y+5, nil, nil, alpha )

	end
end

-- Shooting functions largely copied from weapon_cs_base
function SWEP:PrimaryAttack(worldsnd)

	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

	if not self:CanPrimaryAttack() then return end

	if not worldsnd then
		self.Weapon:EmitSound( self.Primary.Sound, self.Primary.SoundLevel )
		if self.Primary.Sound2 then
			self.Weapon:EmitSound( self.Primary.Sound2, self.Primary.SoundLevel )
		end
	elseif SERVER then
		sound.Play(self.Primary.Sound, self:GetPos(), self.Primary.SoundLevel)
		if self.Primary.Sound2 then
			sound.Play(self.Primary.Sound2, self:GetPos(), self.Primary.SoundLevel)
		end
	end
	//self.Weapon:EmitSound( self.Primary.Sound )
	self.Owner:LagCompensation( true ) --Commented out for now to test if this is causing lagspikes.
	if self:GetScoped() or player_manager.RunClass(self.Owner, "PointmanBehaviour") then
		self:ShootBullet( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self.ZoomCone )
	else
		self:ShootBullet( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self.NormalCone )
	end
	self.Owner:LagCompensation( false )
	local recoil = self.Primary.Recoil
	if self:GetScoped() or player_manager.RunClass(self.Owner, "PointmanBehaviour") then
		recoil = recoil/2
	end
	if ((not game.SinglePlayer()) and CLIENT and IsFirstTimePredicted()) then
		local eyeang = self.Owner:EyeAngles()
		eyeang.pitch = eyeang.pitch - recoil
		self.Owner:SetEyeAngles( eyeang )
	end
	self.Owner:ViewPunch( Angle( math.Rand(-0.2,-0.1) * recoil, math.Rand(-0.1,0.1) * recoil, 0 ) )
	self:TakePrimaryAmmo( 1 )
end

function SWEP:SecondaryAttack()
	if !IsFirstTimePredicted() then return end
	if self.Reloading then return end
	if self:GetScoped( ) then
		self.Owner:SetFOV(0, self.ScopeInTime)
		if !player_manager.RunClass(self.Owner, "PointmanBehaviour") then
			player_manager.RunClass(self.Owner,"MultiplyMoveSpeed",1)
		end
		--self.ScopeStart = CurTime()
		self:SetScoped( false )
  	self:SetHoldType(self.HoldType)
    print(self.HoldType)
	else
		self.Owner:SetFOV(math.floor(90/self.ZoomAmt), self.ScopeInTime)
		if !player_manager.RunClass(self.Owner, "PointmanBehaviour") then
			player_manager.RunClass(self.Owner,"MultiplyMoveSpeed",0.7)
		end
		--self.ScopeStart = CurTime()
		self:SetScoped( true )
  	self:SetHoldType(self.HoldTypeAim)
    print(self.HoldTypeAim)
	end
	self.Weapon:SetNextSecondaryFire( CurTime() + self.ScopeInTime)
end

function SWEP:AdjustMouseSensitivity()
	if self:GetScoped( ) then
		return 1/(self.ZoomAmt*self.ZoomSensitivity)
	else
		return 1
	end
end

function SWEP:Deploy()
	self:SetScoped( false )
  self:SetWeaponHoldType(self.HoldType)
	self.ReloadFailed = false
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	if IsFirstTimePredicted() then
		player_manager.RunClass(self.Owner,"MultiplyMoveSpeed",self.SpeedMult)
		if CLIENT then
			self:WeaponInfo()
		end
	end
end

function SWEP:Initialize()
	if self.Owner:IsValid() then
		if self.Owner:GetActiveWeapon() == self then
			player_manager.RunClass(self.Owner,"MultiplyMoveSpeed",self.SpeedMult)
		end
	end
	self:SetScoped( false )
	self:SetWeaponHoldType(self.HoldType)
end

function SWEP:Reload()
	if self:GetScoped( ) then
		self:SecondaryAttack()
	end
	if IsFirstTimePredicted() then
		if self.Primary.Clips <= 0 then return end
		if self:Clip1() == self.Primary.ClipSize then return end
		if self.ReloadDown == false && self.Reloading == true && self.ReloadFailed == false then
			self.ReloadDown = true
			if CLIENT then
				--We use the time that drawhud specifies here as well because it seems to be desynced.
				--Basically if it 'looks' right on the clients end, we fast reload
				--There's likely a better way to do this (a more secure way too to prevent people always fast reloading with a script)
				--But honestly, this is gmod. If people want to break our game they just need to spend 5 minutes on an aimbot, so fuck making shit secure.
				local reloadpoint = self.DrawTime - self.ReloadStart
				if reloadpoint < self.ReloadCritStart || reloadpoint > self.ReloadCritEnd then
					net.Start("ReloadResult")
					net.WriteEntity(self.Weapon)
					net.WriteBit(false)
					net.SendToServer()
					self.Weapon:FailReload()

				else
					net.Start("ReloadResult")
					net.WriteEntity(self.Weapon)
					net.WriteBit(true)
					net.SendToServer()
					self.Weapon:CritReload()
				end
			end
		end
		if self.ReloadDown == false && self.Reloading == false then
			self.Weapon:StartReload()
		end
	end
	self.ReloadDown = true
end

function SWEP:StartReload()
	self.LastReload = 2
	self.ReloadDown = true
	self.Reloading = true
	self.ReloadFailed = false
	if SERVER then
		--self.ReloadStart = CurTime()

		--print(CurTime())
	end
	if CLIENT then
		--For some reason the draw time desyncs with lag, I do not know why, I believe it's to do with the reload function being predicted somehow, but I honestly don't know.
		--So we use the last time that drawhud specified on the client.
		--This means the bar shouldn't desync.
		self.ReloadStart = self.DrawTime
	end
	if false then
	--Send the time of the reload start to the client...
		net.Start("StartReload")
		net.WriteEntity(self.Weapon)
		net.WriteFloat(CurTime())
		net.Send(self.Owner)
	end

	self.Weapon:SendWeaponAnim( self.ReloadAnim )
	self.Owner:GetViewModel():SetPlaybackRate(self.ReloadAnimLength/self.ReloadLength)

end

function SWEP:CritReload()
	if !self.Reloading then return end
	self.Owner:GetViewModel():SetPlaybackRate(1.4*(self.ReloadAnimLength/self.ReloadLength))
	if CLIENT then
		self.Weapon:EmitSound( Sound( "buttons/button14.wav" ))
	end
	self:FinishReload()
	self.LastReload = 0
end

function SWEP:FailReload()
	if !self.Reloading then return end
	self.ReloadFailed = true
	if CLIENT then
		self.Weapon:EmitSound( Sound( "buttons/button10.wav" ))
	end
	if player_manager.RunClass( self.Owner, "ReloadPenalty" ) then
    player_manager.RunClass( self.Owner, "FailReload" )
		self.ReloadStart = CurTime()+self.ReloadLength
		self.Weapon:SendWeaponAnim( self.ReloadAnim )
		self.Owner:GetViewModel():SetPlaybackRate(0.5*(self.ReloadAnimLength/self.ReloadLength))
	end
	self.LastReload = 1
end

function SWEP:FinishReload()
	self.Reloading = false
	self:SetClip1(self.Primary.ClipSize)
	self.ReloadFailed = false
	self.Primary.Clips = self.Primary.Clips - 1
	self.FinishReloadTime = CurTime()
end

function SWEP:Think()
	if !self.Owner:KeyDown( IN_RELOAD ) then
		self.ReloadDown = false
	end
	if self.Reloading == true then
		if CLIENT then
			if self.ReloadLength < self.DrawTime - self.ReloadStart then
				net.Start("ReloadResult")
				net.WriteEntity(self.Weapon)
				net.WriteBit(true)
				net.SendToServer()
				self.Weapon:CritReload()
			end
		end
	end
end

function SWEP:ShootBullet( dmg, recoil, numbul, cone )

   self.Weapon:SendWeaponAnim(self.PrimaryAnim)

   self.Owner:MuzzleFlash()
   self.Owner:SetAnimation( PLAYER_ATTACK1 )

   if not IsFirstTimePredicted() then return end

   numbul = numbul or 1
   cone   = cone   or 0.01

   local bullet = {}
   bullet.Num    = numbul


   bullet.Src    = self.Owner:GetShootPos()
   bullet.Dir    = self.Owner:GetAimVector()
   bullet.Spread = Vector( cone, cone, 0 )
   bullet.Tracer = 1
   bullet.TracerName = self.Tracer or "Tracer"
   bullet.Force  = 1
   bullet.Damage = dmg

   self.Owner:FireBullets( bullet )
end

function SWEP:DryFire(setnext)
   if CLIENT and LocalPlayer() == self.Owner then
      self:EmitSound( self.DrySound )
   end

   setnext(self, CurTime() + 0.2)

end


function SWEP:CanPrimaryAttack()

   if self.Weapon:Clip1() <= 0 then
      self:DryFire(self.SetNextPrimaryFire)
      return false
   end
   if self.Reloading then
      return false
	 end
   return true
end

function SWEP:CanSecondaryAttack()
   if not IsValid(self.Owner) then return end

   if self.Weapon:Clip2() <= 0 then
      self:DryFire(self.SetNextSecondaryFire)
      return false
   end
   return true
end

function SWEP:DoImpactEffect( trace, damageType )
	if (trace.Entity:GetClass() == "ep_ghost_shield") then
		return true
	else
		return false


	end
end

function SWEP:SmoothLerp(t)
	return t*t * (3 - 2*t)
end

function SWEP:GetViewModelPosition( pos, ang )
   --if not self:GetScoped() then return pos, ang end

   local mul = 1.0

	if self:GetScoped() then
		self.ScopeStart = self.ScopeStart + FrameTime() / self.ScopeInTime / 4
	else
		self.ScopeStart = self.ScopeStart - FrameTime() / self.ScopeInTime / 4
	end

	self.ScopeStart = math.Clamp( self.ScopeStart, 0, 1 )

	mul = self:SmoothLerp(self.ScopeStart)

	pos = pos + (self.ZoomPos.x * ang:Right() * mul) + 		(self.RestPos.x * ang:Right() * (1-mul))
	pos = pos + (self.ZoomPos.y * ang:Forward() * mul) + 	(self.RestPos.y * ang:Forward() * (1-mul))
	pos = pos + (self.ZoomPos.z * ang:Up() * mul) + 		(self.RestPos.z * ang:Up() * (1-mul))
	ang.x = (ang.x + self.ZoomRot.x * mul) + 				(self.RestRot.x * (1-mul))
	ang.y = (ang.y + self.ZoomRot.y * mul) + 				(self.RestRot.y * (1-mul))
	ang.z = (ang.z + self.ZoomRot.z * mul) + 				(self.RestRot.z * (1-mul))

	return pos, ang
end

function SWEP:SetupDataTables()
	self:NetworkVar( "Bool", 0, "Scoped" )
end

function SWEP:Holster()
	if self.Reloading then
		return false
	else
		if self:GetScoped( ) then
			self:SecondaryAttack()
		end
		return true
	end
end

function SWEP:SetReloadStart(t)
	self.ReloadStart = t
end

--Set the curtime stuff on the clients end.
function ClientStart()
	local wep = net.ReadEntity()
	local servtime = net.ReadFloat()
	wep:SetReloadStart(servtime)
end
net.Receive("StartReload",ClientStart)

function Result()
	local wep = net.ReadEntity()
	local success = net.ReadBit()
	if success == 1 then
		wep:CritReload()
	else
		wep:FailReload()
	end
end
net.Receive("ReloadResult",Result)

if CLIENT then
	function SWEP:GetWeaponInfo()
		info = {
		name = self.PrintName,
		desc = self.WeaponDesc,
		pri = self.PrimaryInstruction,
		sec = self.SecondaryInstruction,
		model = self.WorldModel,
		campos = self.CamPos,
		lookpos = self.LookPos
		}
		return info
	end
	function SWEP:WeaponInfo()
		self.Owner:ConCommand("ep_weaponinfo")
	end

	--Old code
	--[[function SWEP:WeaponInfo()
		local wid = 300
		local hgt = 32
		local wepPanel
		if self.Owner:Team() == TEAM_GHOST then
			wepPanel = vgui.Create( "GFrame" ) -- Creates the frame itself
			wid = 390
			hgt = 40
		elseif self.Owner:Team() == TEAM_SWAT then
			wepPanel = vgui.Create( "SFrame" ) -- Creates the frame itself
		else
			wepPanel = vgui.Create( "DFrame" ) -- Creates the frame itself
		end
		wepPanel:SetSize( wid,hgt ) -- Size of the frame
		wepPanel:SetTitle( string.upper(self.PrintName) ) -- Title of the frame
		wepPanel:SetVisible( true )

		local wepDesc = vgui.Create( "DLabel", wepPanel )
		wepDesc:SetColor(Color(255,255,255,255)) // Color
		wepDesc:SetFont("default")
		wepDesc:SetText(string.upper(self.WeaponDesc)) // Text
		wepDesc:SizeToContents() // make the control the same size as the text
		wepDesc:Dock(TOP)

		local priLabel = vgui.Create( "DLabel", wepPanel)
		priLabel:SetColor(Color(255,255,255,255)) // Color
		priLabel:SetFont("default")
		priLabel:SetText("\nPrimary:") // Text
		priLabel:SizeToContents() // make the control the same size as the text
		priLabel:Dock(TOP)

		local priDesc = vgui.Create( "DLabel", wepPanel )
		priDesc:SetColor(Color(100,255,100,255)) // Color
		priDesc:SetFont("default")
		priDesc:SetText(string.upper(self.PrimaryInstruction)) // Text
		priDesc:SizeToContents() // make the control the same size as the text
		priDesc:Dock(TOP)

		local secLabel = vgui.Create( "DLabel", wepPanel)
		secLabel:SetColor(Color(255,255,255,255)) // Color
		secLabel:SetFont("default")
		secLabel:SetText("\nSecondary:") // Text
		secLabel:SizeToContents() // make the control the same size as the text
		secLabel:Dock(TOP)

		local secDesc = vgui.Create( "DLabel", wepPanel )
		secDesc:SetColor(Color(100,255,100,255)) // Color
		secDesc:SetFont("default")
		secDesc:SetText(string.upper(self.SecondaryInstruction)) // Text
		secDesc:SizeToContents() // make the control the same size as the text
		secDesc:Dock(TOP)

		wepPanel:SizeToContentsY()
		wepPanel:SetSize( wepPanel:GetWide(),hgt+wepDesc:GetTall()+priLabel:GetTall()+priDesc:GetTall()+secLabel:GetTall()+secDesc:GetTall() ) -- Size of the frame
		if self.Owner:Team() == TEAM_GHOST then
			wepPanel:DockPadding(-5+(wepPanel:GetTall()*0.3),21,5+(wepPanel:GetTall()*0.3),10)
		elseif self.Owner:Team() == TEAM_SWAT then
			wepPanel:DockPadding(3,21,0,2)
		else
			wepPanel:DockPadding(0,10,0,2)
		end
		wepPanel:SetPos( ScrW()/2+wid/2,ScrH()/2+hgt/2 ) -- Position on the players screen
		timer.Simple(2.5, function()
			wepPanel:Remove()
		end)

	end]]--
end
