ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName		= "Relay"
ENT.Author			= "Cooldown Studios"
ENT.Contact			= "NA"
ENT.Purpose			= "Contains critical data and security information about the G.H.O.S.T. Project"
ENT.Instructions	= "Retrieve the Relay and bring it to your Extraction Point"

function ENT:Initialize()

	--self:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
	self:SetModel( "models/props_combine/combine_emitter01.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox

    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
	self:SetActive(false)
	local ed = EffectData()
		ed:SetEntity(self.Entity)
		ed:SetOrigin(self.Entity:GetPos())
		ed:SetScale( 1 )
	util.Effect( "relay_glow", ed, true, true )
end


function ENT:Use( activator, caller )
	if !self:GetCarried() and activator:Team() == TEAM_SWAT then
		self:Pickup(activator)
	end
end

function ENT:Think()
	if self:GetCarried() && self:GetOwner():IsValid() then
		--self:SetPos(self.Owner:GetPos()+Vector(0,0,20))
		local BoneIndx = self:GetOwner():LookupBone("ValveBiped.Bip01_Spine")
		local BonePos, BoneAng = self:GetOwner():GetBonePosition( BoneIndx )
		self:SetPos(BonePos)
		self:SetAngles(BoneAng+Angle(0,90,0))
	end
	if self:GetOwnerDead() then
		self:Drop()
	end
end

function ENT:Pickup(ply)
	self:SetMoveType( MOVETYPE_NONE )   -- after all, gmod is a physics
	self.SetParent(ply)
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:EnableMotion(false)
	end
	self:SetCarried(true)
	self:SetActive(true)
	self:SetOwner(ply)
	player_manager.RunClass(self.Owner,"SetMoveSpeed",170)
	player_manager.RunClass(ply,"AddPoints",10,"Picked Up Relay!")
	self:SetTriggerSound(1)
end

function ENT:Drop()
	self:SetOwner(nil)
	self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self:SetParent(nil)
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:EnableMotion(true)
		phys:Wake()
	end
	self:SetOwnerDead(false)
	self:SetCarried(false)
	self:SetTriggerSound(2)
end

function ENT:SetupDataTables()
	self:NetworkVar( "Bool", 0, "Carried" );
	self:NetworkVar( "Bool", 1, "OwnerDead" );
	self:NetworkVar( "Int", 2, "TriggerSound" );
	self:NetworkVar( "Bool", 3, "Active" );

end

function ENT:OwnerDie()
	self:SetOwnerDead(true)
end
