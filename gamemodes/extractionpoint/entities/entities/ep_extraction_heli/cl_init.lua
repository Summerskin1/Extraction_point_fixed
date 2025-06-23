include('shared.lua')
 
function ENT:Draw()
	if false then
		self:SetRenderAngles( Angle( 0, 0, 0 ))
	end
    self:DrawModel()       -- Draw the model.
end