if SERVER then
   AddCSLuaFile( "shared.lua" )
end
   
SWEP.HoldType			= "grenade"

if CLIENT then
   SWEP.PrintName			= "HE Grenade"			
   SWEP.Author				= "Cooldown Studios"
   SWEP.WeaponDesc			= "HE Grenade, moderate damage in a large radius."
   SWEP.PrimaryInstruction = "Toss grenade"
   SWEP.SecondaryInstruction = "N/A"
   SWEP.CamPos = Vector(25,25,10)
   SWEP.LookPos = Vector(0,0,0.5)
   
   SWEP.Slot				= 4
   SWEP.SlotPos			= 1

   SWEP.Icon = "VGUI/ep/sample"
   SWEP.IconLetter = "P"
end

SWEP.Base				= "weapon_ep_nadebase"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.Primary.Clips       	= 5
SWEP.Primary.MaxClips       = 5

SWEP.GrenadeEntity = "ep_he_nade"
SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 80
SWEP.ViewModel			= "models/weapons/cstrike/c_eq_flashbang.mdl"
SWEP.WorldModel			= "models/weapons/w_eq_flashbang.mdl"
if CLIENT then
	function SWEP:DrawHUD()
		self:DrawAmmo("")
		self:DrawCross()
	end	
end