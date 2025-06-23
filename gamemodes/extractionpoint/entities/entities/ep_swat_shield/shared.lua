ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName		= "Swat Shield"
ENT.Author			= "Cooldown Studios"
ENT.Contact			= "NA"
ENT.Purpose			= "Used to block choke points and defend the swat squad"
ENT.Instructions	= "Use the GDS to place the shield down"

function ENT:Initialize()
 
	--self:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
	self:SetModel( "models/props_combine/combine_barricade_short01a.mdl" )
	self:SetColor(Color(255,255,255,255))
	
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox

	
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:EnableMotion(false)
	end
end


function ENT:Use( activator, caller )
end

function ENT:Draw()
	if self:GetOwner() != LocalPlayer() then
		self:DrawModel()
	end
end

function ENT:Think()
end

function ENT:OnTakeDamage(damage)
end

function ENT:Pickup()
end

function ENT:Drop()
end

function ENT:SetupDataTables()
	self:NetworkVar( "Int", 0, "Health" );
end

function ENT:OwnerDie()
end


local damageSound = Sound("physics/metal/metal_barrel_impact_hard1.wav")
function ENT:OnTakeDamage(damage)
	self:EmitSound( damageSound, 100, math.random(100,230) )
end