ENT.Type = "anim"
ENT.PrintName = ""
ENT.Author = "Cooldown Studios" -- Code based on trip mine from The Stalker made by Rambo_6 (aka Sechs)
ENT.Purpose	= ""
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
local sndOnline = Sound( "buttons/button3.wav" )

function ENT:Initialize()
	if SERVER then 	
		self.Entity:DrawShadow( false )	
	end
end

function ENT:SetEndPos( endpos )
	self.Entity:SetNetworkedVector( "endpos", endpos )	
	if false then --Old custom collision code.
		local VERTICES = {}
			--Cubes at either end and initconvex should fill in the space in between.
			--Could probably do this better but look at the fucks i'm giving
		start = self.Entity:GetPos()
		finish = endpos
		VERTICES[1] = { start }
		VERTICES[2] = { finish  }
		self.Entity:EnableCustomCollisions( true )
		self.Entity:PhysicsInitConvex( VERTICES )
		self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
		--self.Entity:SetMoveType( MOVETYPE_NONE )
		--self.Entity:SetSolid( SOLID_CUSTOM  )
		self.Entity:SetTrigger( true )
	end
	self.Entity:EmitSound( sndOnline )
end

function ENT:GetEndPos()
	return self.Entity:GetNetworkedVector( "endpos" )
end