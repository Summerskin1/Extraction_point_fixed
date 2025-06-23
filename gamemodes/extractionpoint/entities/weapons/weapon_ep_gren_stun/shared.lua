if SERVER then
   AddCSLuaFile( "shared.lua" )
end
   
SWEP.HoldType			= "grenade"

if CLIENT then
   SWEP.PrintName			= "Stun Grenade"			
   SWEP.Author				= "Cooldown Studios"
   
   SWEP.Slot				= 4
   SWEP.SlotPos			= 1

   SWEP.Icon = "VGUI/ep/sample"
   SWEP.WeaponDesc = "A stun grenade that stops\npeople in their tracks!"
   SWEP.PrimaryInstruction = "Toss grenade"
   SWEP.SecondaryInstruction = "N/A"
   SWEP.CamPos = Vector(30,30,10)
   SWEP.LookPos = Vector(0,0,0)
   SWEP.IconLetter = "O"
end

SWEP.Base				= "weapon_ep_nadebase"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.Primary.Clips       	= 8
SWEP.Primary.MaxClips       = 8

SWEP.GrenadeEntity = "ep_stun_nade"
SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 80
SWEP.ViewModel			= "models/weapons/cstrike/c_eq_fraggrenade.mdl"
SWEP.WorldModel			= "models/weapons/w_eq_fraggrenade.mdl"
if CLIENT then
	function SWEP:DrawHUD()
		self:DrawAmmo("")
		self:DrawCross()
	end	
end