ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName		= "Tripmine"
ENT.Author			= "Cooldown Studios"
ENT.Contact			= "NA"
ENT.Purpose			= "Asplode Swatz"
ENT.Instructions	= "THROW IT ON DA GROUND"


function ENT:Initialize()
 
	self:SetCollisionGroup( COLLISION_GROUP_NPC )
	self:SetModel( "models/Items/battery.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_NONE )   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
	--self:SetAimpos(Vector(0,0,0)) --Sets the laser point to the origin, for now.
	
	local tracedata = {}
	tracedata.start = self:GetPos()
	tracedata.endpos = self:GetAimpos()
	tracedata.filter = {self.Owner, self}
	tracedata.mask = CONTENTS_SOLID + CONTENTS_MOVEABLE + CONTENTS_OPAQUE + CONTENTS_DEBRIS + CONTENTS_HITBOX + CONTENTS_MONSTER
	local trace = util.TraceLine(tracedata)
	self:SetAimpos(trace.HitPos)
	if SERVER then
		self:StartTripmineMode(self:GetPos(), self:GetAimpos() - self:GetPos())
	end
	self.dead = false
end


function ENT:Use( activator, caller )
	if player_manager.RunClass(activator,"Defuse") then
		player_manager.RunClass(activator,"AddPoints",5,"Defused a Trip Mine")
		self.Entity:EmitSound("buttons/button5.wav")
		self.Laser:Remove()
		self:Remove()
	end
end

function ENT:Think()

end


function ENT:SetupDataTables()
	self:NetworkVar( "Vector", 0, "Aimpos" );
	self:NetworkVar( "Bool", 0, "Exploded" );
end

function ENT:Explode()
	local effectdata = EffectData()
	effectdata:SetStart( self:GetPos()+self:GetForward()*-40 )
	effectdata:SetOrigin( self:GetPos()+self:GetForward()*-40 )
	effectdata:SetScale( 1 )
	if !self.dead then
		util.Effect( "trip_explode", effectdata, true, true )	
		self.dead = true
	end
	self:EmitSound("weapons/explode3.wav", 100,math.Rand(70,80))
	util.BlastDamage(self.Owner, self.Owner, self:GetPos(), 200, 300)
	util.BlastDamage(self.Owner, self.Owner, self:GetPos(), 500, 150)
	self:Remove()
end