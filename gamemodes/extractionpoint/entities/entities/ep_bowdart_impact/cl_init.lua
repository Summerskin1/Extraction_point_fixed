include('shared.lua')
 
local Laser = Material( "sprites/bluelaser1" )
local Impact = Material( "Sprites/light_glow02_add_noz" )

function ENT:Draw()
	self:DrawModel() 
end