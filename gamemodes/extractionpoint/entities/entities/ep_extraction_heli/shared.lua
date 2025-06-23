ENT.Type = "ai"
ENT.Base = "base_ai"
ENT.AutomaticFrameAdvance = true

ENT.PrintName		= "Helicopter"
ENT.Author			= "Cooldown Studios"
ENT.Contact			= "NA"
ENT.Purpose			= "Contains critical data and security information about the G.H.O.S.T. Project"
ENT.Instructions	= "Retrieve the Relay and bring it to your Extraction Point"


ENT.hoverpos = nil --Vector(0,0,356)
ENT.hovertoggle = true
ENT.idlesound = nil

local helisound = Sound("npc/combine_gunship/engine_rotor_loop1.wav")
function ENT:Initialize()
 
	--self:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
	self:SetModel( "models/combine_helicopter.mdl" )
	if SERVER then
		self:SetHullType( HULL_LARGE ) -- Sets the hull type, used for movement calculations amongst other things.
		self:SetHullSizeNormal( )
	end
	self:SetSolid( SOLID_BBOX )         -- collide
	self:SetAnimation(ACT_IDLE)
	self.idlesound = CreateSound(self, helisound)
	self.idlesound:SetSoundLevel(90)
	self.idlesound:Play()
	
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:EnableMotion(true)
	end
end

function ENT:SetAutomaticFrameAdvance( bUsingAnim ) -- This is called by the game to tell the entity if it should animate itself.
	self.AutomaticFrameAdvance = bUsingAnim
end


function ENT:Use( activator, caller )
	--
end

--[[function ENT:Think()
	
	if self.hovertoggle then
		self:SetPos(self:GetPos() + Vector(0,0,-0.8))
		if self:GetPos().z < self.hoverpos.z-25 then
			self.hovertoggle = false
		end
	else
		self:SetPos(self:GetPos() + Vector(0,0,0.8))
		if self:GetPos().z > self.hoverpos.z+25 then
			self.hovertoggle = true
		end
	end
end]]--


function ENT:SetupDataTables()

end