
local plymeta = FindMetaTable( "Player" )
if not plymeta then Error("FAILED TO FIND PLAYER TABLE") return end


-- Sets hands to be the correct model for given player and attaches to their
-- viewmodel. Note that the player is not necessarily *self*, but can be a
-- spectated player.
function plymeta:SetPlayerHands(ply)
   local hands = self:GetHands()
   if not IsValid(hands) or not IsValid(ply) then return end

   -- Find hands model
   local simplemodel = GetSimpleModelName(ply:GetModel())
   local info = player_manager.TranslatePlayerHands(simplemodel)
   if info then
      hands:SetModel(info.model)
      hands:SetSkin(info.skin)
      hands:SetBodyGroups(info.body)
   end
   if ply:GetMaterial() == "models/shadertest/predator" then
		hands:SetMaterial("models/shadertest/predator" ) 	
   else
		hands:SetMaterial( ) 	
   end

   -- Attach to vm
   local vm = ply:GetViewModel(0)
   if vm then
      hands:AttachToViewmodel(vm)
      vm:DeleteOnRemove(hands)
   end
end

local simplemodel_cache = {}
function GetSimpleModelName(model)
   local cached = simplemodel_cache[model]
   if cached then return cached end

   local lst = player_manager.AllValidModels()
   for simple, mdl in pairs(lst) do
      if mdl == model then
         simplemodel_cache[mdl] = simple
         return simple
      end
   end
   return "css_phoenix"
end