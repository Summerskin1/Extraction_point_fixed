if SERVER then
   AddCSLuaFile( "shared.lua" )
end
   
SWEP.HoldType			= "grenade"

if CLIENT then
   SWEP.PrintName			= "Motion Detector"			
   SWEP.Author				= "Cooldown Studios"
   SWEP.WeaponDesc			= "Motion detector, picks up nearby movement\nwhile equipped. Toss it to\nthe ground to keep watch over an area"
   SWEP.PrimaryInstruction = "Toss motion detector"
   SWEP.SecondaryInstruction = "N/A"
   
   SWEP.Slot				= 3
   SWEP.SlotPos			= 1

   SWEP.Icon = "VGUI/ep/sample"
   SWEP.CamPos = Vector(30,30,10)
   SWEP.LookPos = Vector(0,0,6)
   SWEP.IconFont = "EP_Wepfont2"
   SWEP.IconLetter = "{ D }"
end

SWEP.Base				= "weapon_ep_nadebase"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

--SWEP.Kind = WEAPON_PISTOL
--SWEP.WeaponID = AMMO_DEAGLE

SWEP.Primary.Ammo = "AlyxGun" -- hijack an ammo type we don't use otherwise
SWEP.Primary.Recoil	= 6
SWEP.Primary.Damage = 43
SWEP.Primary.Delay = 0.6
SWEP.Primary.Cone = 0.02
SWEP.Primary.ClipSize = 1
SWEP.Primary.ClipMax = 1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = false

SWEP.BodyDamage = 43
SWEP.HeadDamage = 90


--SWEP.AmmoEnt = "item_ammo_revolver_ep"
SWEP.Primary.Sound			= Sound( "Weapon_Deagle.Single" )

SWEP.UseHands			= false
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 54
SWEP.ViewModel			= "models/weapons/v_eq_smokegrenade.mdl"
SWEP.WorldModel			= "models/Items/battery.mdl"

SWEP.GrenadeEntity = "ep_motion_detector"
SWEP.HideAmmo = true

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


function SWEP:DrawHUD()
	if self.Primary.Clips > 0 then
	local objects = ents.GetAll()
		if !(self:IsValid()) then return end
		if !(self:GetOwner():IsValid()) then return end
		surface.SetTexture(0) --set the texture of the triangle
		surface.SetDrawColor( Color(50,50,120,50) ) --set the additive color
		local x = ScrW()/2
		local y = ScrH()-(ScrH()/3)
		surface.DrawPoly( GenerateCircle(x,y,100,100 )) --draw the triangle with our triangle table
		-- The functions you are messing around with go here
		local vec = self.Owner:EyeAngles():Forward()
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
				local relpos = (v:GetPos()-self:GetPos())/6
				relpos.z = 0
				if relpos:Length() < 100 then
					local speedmod = v:GetVelocity():Length()/2
					surface.SetDrawColor(  (speedmod*3)-200, 500-speedmod*3, 0, speedmod-30) 
					surface.DrawRect(relpos.y-2+x , relpos.x-8+y, 4, 8 )
					surface.DrawRect(relpos.y-2+x , relpos.x+4+y, 4, 4 )
				end
			end
		end
	end
end

