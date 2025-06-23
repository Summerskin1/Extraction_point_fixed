ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName		= "Relay"
ENT.Author			= "Cooldown Studios"
ENT.Contact			= "NA"
ENT.Purpose			= "Contains critical data and security information about the G.H.O.S.T. Project"
ENT.Instructions	= "Retrieve the Relay and bring it to your Extraction Point"

function ENT:Initialize()
 
	--self:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
	--self:SetModel( "models/props_combine/combine_emitter01.mdl" )
	--self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_NONE )   -- after all, gmod is a physics
	self:SetSolid( SOLID_NONE )         -- Toolbox
 
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end