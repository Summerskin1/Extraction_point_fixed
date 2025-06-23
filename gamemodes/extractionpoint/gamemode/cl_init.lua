include( "shared.lua" )
include( "cl_scoreboard.lua" )
include( "cl_hud.lua" )


-- custom hands woo
function GM:PostDrawViewModel( vm, ply, weapon )

  if ( weapon.UseHands || !weapon:IsScripted() ) then
    local hands = LocalPlayer():GetHands()
    if ( IsValid( hands ) ) then hands:DrawModel() end

  end

end
