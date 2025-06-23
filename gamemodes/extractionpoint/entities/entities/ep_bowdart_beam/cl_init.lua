-- Draw code is based on that of the tripmine laser in The Stalker gamemode
-- Credit to Sechs for that!

include('shared.lua')

local matTripmineLaser 		= Material( "sprites/bluelaser1" )
local matLight 				= Material( "sprites/light_glow02_add" )
local colBeam				= Color( 255, 60, 10, 250 )
local colLaser				= Color( 255, 130, 10, 250 )

function ENT:Think()
	self.Entity:SetRenderBoundsWS( self.Entity:GetNetworkedVector( "endpos" ), self.Entity:GetPos(), Vector()*8 )
	
end

function ENT:Draw()

	local hit = self.Entity:GetNetworkedVector( "endpos" )

	if !hit then return end
	
	render.SetMaterial( matTripmineLaser )
	
	// offset the texture coords so it looks like it is scrolling
	local TexOffset = CurTime() * 3
	
	// Make the texture coords relative to distance so they are always a nice size
	local Distance = hit:Distance( self.Entity:GetPos() )
		
	// Draw the beam
	render.DrawBeam( hit, self.Entity:GetPos(), 6, TexOffset, TexOffset+Distance/8, colBeam )
	render.DrawBeam( hit, self.Entity:GetPos(), 3, TexOffset, TexOffset+Distance/8, colBeam )
	
	// Draw a quad at the hitpoint to fake the laser hitting it
	render.SetMaterial( matLight )
	local Size = math.Rand( 3, 5 )
	local Normal = (self.Entity:GetPos()-hit):GetNormal() * 0.1
	render.DrawQuadEasy( hit + Normal, Normal, Size, Size, colLaser, 0 )
	render.DrawQuadEasy( hit + Normal, Normal, Size/2, Size/2, Color(255,255,255), 0 )
	 
end

function ENT:IsTranslucent()
	return true
end
