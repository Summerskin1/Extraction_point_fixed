
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

local sndOnline = Sound( "buttons/button3.wav" )


function ENT:Think()
	local trace = {}
	local endpoint = self.Entity:GetNetworkedVector( "endpos" )
	local direction = (endpoint-self.Entity:GetPos())
	direction:Normalize()
	trace.start = self.Entity:GetPos()+direction*10
	trace.endpos = endpoint
	trace.filter = self.Owner --no filter yet...
	trace.mask = CONTENTS_SOLID + CONTENTS_MOVEABLE + CONTENTS_OPAQUE + CONTENTS_DEBRIS + CONTENTS_HITBOX + CONTENTS_MONSTER
	local tr = util.TraceLine(trace)
	if tr.HitNonWorld then
		if tr.Entity:IsValid() then
			if tr.Entity:IsPlayer() then
				if tr.Entity:Team() != TEAM_DEBUG then
					self.Entity:GetOwner():Explode()
					self:Remove()
				end
			end
		end
	end
    self:NextThink(CurTime()+0.01) --'whatever' is time in seconds until next think, adding nothing will cause it to run as fast as possible (from a few test it seemed to be 10-20 times faster than default
    return true --must have this to override think delay
end


function ENT:Touch( ent )
	if ent:IsPlayer() then	
		if ent:Team() != TEAM_DEBUG then
			self.Entity:GetOwner():Explode()
			self:Remove()

			self.Entity:EmitSound( sndOnline )
		end		
	end
end


