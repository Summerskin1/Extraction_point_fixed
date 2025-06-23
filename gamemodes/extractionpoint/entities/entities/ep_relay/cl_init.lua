include('shared.lua')
 
function ENT:Draw()
	if self:GetCarried() && self:GetOwner():IsValid() then
		local BoneIndx = self:GetOwner():LookupBone("ValveBiped.Bip01_Spine")
		local BonePos, BoneAng = self:GetOwner():GetBonePosition( BoneIndx )
		self:SetRenderOrigin(BonePos)
		self:SetRenderAngles( Angle( 0, 90, 0 ) + BoneAng)
	else
		self:SetRenderOrigin()
		self:SetRenderAngles()
	end
    self:DrawModel()       -- Draw the model.
end
 