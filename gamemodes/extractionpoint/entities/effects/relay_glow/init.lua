

function EFFECT:Init( data )
	
	self.Target = data:GetEntity()
	self.StartTime	= CurTime()
	self.Length		= 0.3
		
end

function EFFECT:Think( )
	if self.Target then 
		return true
	else
		return false
	end
end

function EFFECT:Render()

	if ( !IsValid( self.Target ) ) then return end
	local size = math.Rand(0.5,4)
	local dist = (self.Target:GetPos()-LocalPlayer():GetPos()):Length()
	local alpha = 255-math.Clamp(dist/4,0,255)
	if LocalPlayer():Team() == TEAM_GHOST then
		halo.Add( {self.Target}, Color( 255, 120, 40, alpha), -2, -2, 1, true, false )
	else
		halo.Add( {self.Target}, Color( 120, 120, 240, alpha), -2, -2, 1, true, false )
	end

end
