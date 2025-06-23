include('shared.lua')

function ENT:Draw()
  local player = self:GetOwner()
  if player != nil then
    if player:IsPlayer() then
      local wep = player:GetActiveWeapon()
      if player == LocalPlayer() then return end
      if wep == nil or self == nil then return end
      if !wep:IsValid() then return end
      if wep:GetClass() == self:GetWeaponType() then return end
      if player_manager.RunClass(player,"PoltergeistBehaviour") then return end
      if player:GetMaterial() == "models/effects/vol_light001" then return end
    end
    self:DrawModel()
  end
end
