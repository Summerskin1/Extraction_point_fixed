if SERVER then
   AddCSLuaFile( "shared.lua" )
end
   
SWEP.HoldType			= "grenade"

if CLIENT then
   SWEP.PrintName			= "Mini Turret"			
   SWEP.Author				= "Cooldown Studios"
   SWEP.WeaponDesc			= "Miniturret, sticks to walls.\nHas limited ammunition."   
   SWEP.PrimaryInstruction = "Throw Turret"
   SWEP.SecondaryInstruction = "N/A"
   SWEP.CamPos = Vector(25,25,10)
   SWEP.LookPos = Vector(0,0,0.5)
   
   SWEP.Slot				= 4
   SWEP.SlotPos			= 1

   SWEP.Icon = "VGUI/ep/sample"
   SWEP.IconLetter = "Q"
end

SWEP.Base				= "weapon_ep_nadebase"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.Primary.Clips       	= 2
SWEP.Primary.MaxClips       = 2

SWEP.GrenadeEntity = "ep_miniturret"
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