include('shared.lua')

local sin,cos,rad = math.sin,math.cos,math.rad
local function GenerateCircle(x,y,radius,quality)
    local circle = {};
    local tmp = 0;
	local s,c;
    for i=1,quality do
        tmp = rad(i*360)/quality;
		s = sin(tmp);
		c = cos(tmp);
        circle[i] = {x = x + c*radius,y = y + s*radius,u = (c+1)/2,v = (s+1)/2};
    end
    return circle;
end

function ENT:Draw()
    self:DrawModel()       -- Draw the model.
	local objects = ents.GetAll()
	function MotionDetector()
		if !(self:IsValid()) then return end
		if !(self:GetOwner():IsValid()) then return end
		if LocalPlayer() != self:GetOwner() then return end
		surface.SetTexture(0) --set the texture of the triangle
		surface.SetDrawColor( Color(50,50,120,50) ) --set the additive color
		local x = ScrW()/2
		local y = ScrH()-(ScrH()/3)
		surface.DrawPoly( GenerateCircle(x,y,100,100 )) --draw the triangle with our triangle table
		-- The functions you are messing around with go here
		local vec = LocalPlayer():EyeAngles():Forward()
		vec.z = 0
		vec:Normalize()
		surface.SetDrawColor( Color(120,120,240,255) ) --set the additive color
		surface.DrawLine( x, y, vec.y*20+x,vec.x*20+y)
		surface.SetDrawColor( Color(120,120,240,200) ) --set the additive color
		surface.DrawLine( vec.y*20+x,vec.x*20+y, vec.y*40+x,vec.x*40+y)
		surface.SetDrawColor( Color(120,120,240,150) ) --set the additive color
		surface.DrawLine( vec.y*40+x,vec.x*40+y, vec.y*60+x,vec.x*60+y)
		surface.SetDrawColor( Color(120,120,240,100) ) --set the additive color
		surface.DrawLine( vec.y*60+x,vec.x*60+y, vec.y*80+x,vec.x*80+y)
		surface.SetDrawColor( Color(120,120,240,50) ) --set the additive color
		surface.DrawLine( vec.y*80+x,vec.x*80+y, vec.y*100+x,vec.x*100+y)
		for k,v in ipairs (objects) do
			--if !v:IsValid() then return end
			if v:IsValid() and v:IsPlayer() and v:Alive() then
				local relpos = (v:GetPos()-self:GetPos())/12
				relpos.z = 0
				if relpos:Length() < 100 then
					local speedmod = v:GetVelocity():Length()/2
					surface.SetDrawColor(  (speedmod*3)-200, 500-speedmod*3, 0, speedmod-30) 
					surface.DrawRect(relpos.y-2+x , relpos.x-8+y, 4, 8 )
					surface.DrawRect(relpos.y-2+x , relpos.x+4+y, 4, 4 )
				end
			end
		end
	end
	if self:GetOwner():IsValid() then
		self.hookname = self:GetOwner():UniqueID() .. "Motion Detector Hud"
		hook.Add("HUDPaint", self.hookname, MotionDetector)
	end
end

function ENT:OnRemove()
	hook.Remove("HUDPaint", self.hookname)
end