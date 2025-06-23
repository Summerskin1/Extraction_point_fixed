ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName		= "Extraction Point"
ENT.Author			= "Cooldown Studios"
ENT.Contact			= "NA"
ENT.Purpose			= "Get the Relay here to win!"
ENT.Instructions	= "Retrieve the Relay and bring it to your Extraction Point"

function ENT:Initialize()
 
	self:SetModel( "" )
	self:SetMoveType( MOVETYPE_NONE )   -- after all, gmod is a physics
	self:SetSolid( SOLID_NONE )         -- Toolbox

end
 
function ENT:Use( activator, caller )

end

function ENT:Think()

end