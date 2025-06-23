AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')


function ENT:StartTripmineMode( hitpos, forward )
	
	if (hitpos) then self:SetPos( hitpos ) end
	self:SetAngles( forward:Angle() + Angle( 90, 0, 0 ) )

	
	local trace = {}
	trace.start = self:GetPos()
	trace.endpos = self:GetPos() + (forward * 4096)
	trace.filter = self
	trace.mask = CONTENTS_SOLID + CONTENTS_MOVEABLE + CONTENTS_OPAQUE + CONTENTS_DEBRIS + CONTENTS_HITBOX + CONTENTS_MONSTER
	local tr = util.TraceLine( trace )

	local ent = ents.Create( "ep_trip_beam" )
	--ent:SetAngles(self:GetAngles())
	ent:SetPos( self:LocalToWorld( Vector( 0, 0, 1) ) )
	ent:GetTable():SetEndPos( tr.HitPos )	
	ent:Spawn()
	ent:Activate()
	ent:SetOwner( self )
		
	self.Laser = ent
	
	self:SetAngles( forward:Angle() + Angle( 180, 0, 180 ) )
	local up = self:GetUp()
	self:SetPos( self:GetPos()-(up*8))
	

end
