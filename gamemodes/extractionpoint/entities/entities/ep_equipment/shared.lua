ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName		= "Equipment"
ENT.Author			= "Cooldown Studios"
ENT.Contact			= "NA"
ENT.Purpose			= "Equipment Visual"
ENT.Instructions	= "Shows what you're wearing"



local rotations = {
	["weapon_ep_knife"] 			= Angle( 90, 270, 0 ), --
	["weapon_ep_dartgun"] 			= Angle( 90, 0, 180 ), --
	["weapon_ep_pincer"] 			= Angle( 105, 0, 0 ), --
	["weapon_ep_lightcannon"] 		= Angle( 105, 0, 0 ), --
	["weapon_ep_pistol"] 			= Angle( 90, 0, 0 ), --
	["weapon_ep_revolver"] 			= Angle( 105, 0, 0 ), --
	["weapon_ep_mpistol"] 			= Angle( 90, 0, 0 ), --
	["weapon_ep_dualmp"] 			= Angle( -60, 0, 0 ), --
	["weapon_ep_mp5"] 				= Angle( 180, 0, 0 ), --
	["weapon_ep_combat"] 			= Angle( 180, 30, 0 ),  --
	["weapon_ep_mg"] 				= Angle( -30, 10, 0 ), --
	["weapon_ep_shotgun"] 			= Angle( 180, 30, 0 ), --
	["weapon_ep_rifle"] 			= Angle( 180, 30, 0 ), --
	["weapon_ep_pulsegun"] 			= Angle( 180, 30, 0 ), --
	["weapon_ep_plasma"] 			= Angle( 90, 180, 0 ), --
	["weapon_ep_sniper"] 			= Angle( 180, 30, 0 ),  --
	["weapon_ep_webcaster"] 		= Angle( 120, 180, 0 ), --
	["weapon_ep_heavycannon"] 		= Angle( 180, 30, 0 ), --
	["weapon_ep_moosekiller"] 		= Angle( 180, 30, 0 ), --
	["weapon_ep_railgun"] 			= Angle( 180, 30, 0 ), --
	["weapon_ep_ricochet"] 			= Angle( 180, 30, 0 ), --
	["weapon_ep_prism"] 			= Angle( 180, 30, 0 ), --
	["weapon_ep_rpg"] 				= Angle( 180, 30, 180 ), --
	["weapon_ep_gren_rpg"] 			= Angle( 180, 30, 180 ), --
	["weapon_ep_swatshield"] 		= Angle( 180, 0, 90 ), --
	["weapon_ep_trip"] 				= Angle( 90, 0, -90 ), --
	["weapon_ep_detpack"] 			= Angle( 0, 220, 0 ), --
	["weapon_ep_caltrop"] 			= Angle( -90, 0, 0 ),
	["weapon_ep_gas"] 				= Angle( -90, 0, 0 ), --
	["weapon_ep_lich_gas"] 				= Angle( -90, 0, 0 ), --
	["weapon_ep_miniturret"] 		= Angle( -90, 0, 0 ),
	["weapon_ep_he"]			 	= Angle( -90, 0, 0 ), --
	["weapon_ep_frag"] 				= Angle( -90, 0, 0 ), --
	["weapon_ep_stun"] 				= Angle( -90, 0, 0 ), --
	["weapon_ep_gren_he"]			= Angle( -90, 0, 0 ), --
	["weapon_ep_gren_frag"] 		= Angle( -90, 0, 0 ), --
	["weapon_ep_gren_stun"] 		= Angle( -90, 0, 0 ), --
	["weapon_ep_healdart"] 			= Angle( 90, 0, 0 ), --
	["weapon_ep_chaff"] 			= Angle( 0, -90, 0 ), --
	["weapon_ep_motion"] 			= Angle( 10, 80, -140 ) --
}

local offsets = {
	["weapon_ep_knife"] 			= Vector(0,6,5),
	["weapon_ep_dartgun"] 			= Vector(0,5,0),
	["weapon_ep_pincer"] 			= Vector(4,-5,-6),
	["weapon_ep_lightcannon"] 		= Vector(12,-5,-6),
	["weapon_ep_pistol"] 			= Vector(4,-5,-6),
	["weapon_ep_revolver"] 			= Vector(-1,-5,-1),
	["weapon_ep_mpistol"] 			= Vector(4,-5,-7),
	["weapon_ep_dualmp"] 			= Vector(4,-1,-6),
	["weapon_ep_mp5"] 				= Vector(0,5,-7),
	["weapon_ep_combat"] 			= Vector(10,5,-7),
	["weapon_ep_mg"] 				= Vector(3,-7,-9),
	["weapon_ep_shotgun"] 			= Vector(10,5,-7),
	["weapon_ep_rifle"] 			= Vector(10,5,-7),
	["weapon_ep_pulsegun"] 			= Vector(10,5,-7),
	["weapon_ep_plasma"] 			= Vector(-12,0,-5),
	["weapon_ep_sniper"] 			= Vector(4,6,-7),
	["weapon_ep_webcaster"] 		= Vector(-15,5,-8),
	["weapon_ep_heavycannon"] 		= Vector(10,5,-7),
	["weapon_ep_moosekiller"] 		= Vector(0,5,0),
	["weapon_ep_railgun"] 			= Vector(10,5,-7),
	["weapon_ep_ricochet"] 			= Vector(5,6,-9),
	["weapon_ep_prism"] 			= Vector(0,5,0),
	["weapon_ep_rpg"] 				= Vector(-20,-4,-12),
	["weapon_ep_gren_rpg"] 			= Vector(-20,-4,-12),
	["weapon_ep_swatshield"] 		= Vector(0,0,5), --5
	["weapon_ep_trip"] 				= Vector(5,-5,-12),
	["weapon_ep_detpack"] 			= Vector(0,0,7),
	["weapon_ep_caltrop"] 			= Vector(9,3,-2),
	["weapon_ep_lich_gas"] 				= Vector(9,3,-2),
	["weapon_ep_gas"] 				= Vector(9,3,-2),
	["weapon_ep_miniturret"] 		= Vector(9,3,-2),
	["weapon_ep_he"]			 	= Vector(9,3,-2),
	["weapon_ep_frag"] 				= Vector(9,3,-2),
	["weapon_ep_stun"] 				= Vector(9,3,-2),
	["weapon_ep_gren_he"]			= Vector(9,3,-2),
	["weapon_ep_gren_frag"] 		= Vector(9,3,-2),
	["weapon_ep_gren_stun"] 		= Vector(9,3,-2),
	["weapon_ep_healdart"] 			= Vector(6,-6,-2),
	["weapon_ep_chaff"] 			= Vector(5,12,-2),
	["weapon_ep_motion"] 			= Vector(5,-5,-2)
}


function ENT:Initialize()
	self:SetMoveType( MOVETYPE_NONE )
end

function ENT:Pickup(ply, weapontype, model, bonename)
	self:SetModel( model )
	self:SetMoveType( MOVETYPE_NONE )
	self.SetParent(ply)
	self:SetWeaponType(weapontype)
	self:SetWeaponBone(bonename)
	self:SetWeaponModel(model)
	self:SetOwner(ply)

  if (weapontype == "weapon_ep_swatshield") then
    self:PhysicsInit( SOLID_VPHYSICS )
    self:SetSolid( SOLID_VPHYSICS )
    self:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
    self.CollisionOn = true
  else
    self:PhysicsInit( SOLID_NONE )
    self:SetSolid( SOLID_NONE )
    self:SetCollisionGroup( COLLISION_GROUP_NONE )
  end
end


function ENT:Think()
	local player = self:GetOwner()

	if player != nil and player:IsValid() then
		self:SetPos(self:GetOwner():GetPos() + Vector(0,0,50))
		self:NextThink( CurTime() ) --force updating every gametick to ensure the hitboxes match up with player anim positions.

		if player:IsPlayer() then
      //ensure we delete ourselves on player dead
      if !player:Alive() and SERVER then
        self:Remove()
      end

      //perform sanity checks
			local wep = player:GetActiveWeapon()
			if self == nil then return end
      if wep == nil then return end
      if !wep:IsValid() then return end

      //delete ourselves if the player has used us up (grenades)
      local weapons = player:GetWeapons()
      local isDropped = true
      if SERVER then
        for k,v in pairs(weapons) do
          if v != nil and v:IsValid() and v:GetClass() == self:GetWeaponType() then
            isDropped = false
          end
        end
        if isDropped then self:Remove() end
      end

      //special shield behaviour
      if self:GetWeaponType() == "weapon_ep_swatshield" then
        if wep:GetClass() == self:GetWeaponType() then
          if self.CollisionOn then
            self:PhysicsInit( SOLID_NONE )
            self:SetSolid( SOLID_NONE )
            self:SetCollisionGroup( COLLISION_GROUP_NONE )
            self.CollisionOn = false
            print("collision off")
          end
        else
          if not self.CollisionOn then
            self:PhysicsInit( SOLID_VPHYSICS )
            self:SetSolid( SOLID_VPHYSICS )
            self:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
            self.CollisionOn = true
            print("collision on")
          end
        end
      end

      //position ourselves nicely
			local BoneIndx = self:GetOwner():LookupBone(self:GetWeaponBone())
			if BoneIndx != nil then
				local BonePos, BoneAng = player:GetBonePosition( BoneIndx )
				local rotOffset = rotations[self:GetWeaponType()]
				BoneAng:RotateAroundAxis(BoneAng:Forward(),rotOffset.x)
				BoneAng:RotateAroundAxis(BoneAng:Right(),rotOffset.y)
				BoneAng:RotateAroundAxis(BoneAng:Up(),rotOffset.z)
				local offset = Vector(offsets[self:GetWeaponType()])
				offset:Rotate(BoneAng)
				self:SetPos(BonePos + offset)
				self:SetAngles( BoneAng )
			end

		end
	end
  return true
end



function ENT:SetupDataTables()
	self:NetworkVar( "String", 0, "WeaponType" );
	self:NetworkVar( "String", 1, "WeaponBone" );
end
