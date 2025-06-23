include( "cl_colors.lua" )
--THESE FILES SHOULD NOT BE DIFFERENT FROM THE ONES IN THE DIRECTORY UP ONE
--FOR SOME REASON YOU CAN'T FUCKING INCLUDE UPWARDS SO I HAVE TO DUPLICATE THIS SHIT
--FUCK EVERYTHING
if !CLIENT then return end

surface.CreateFont("GhostTitle", {font = "Trebuchet24",
                                    size = 22,
                                    weight = 1000})
surface.CreateFont("SWATTitle", {font = "Trebuchet24",
                                    size = 14,
                                    weight = 1000})
									
local GFRAME = {}
GFRAME.Title = "#GHOST_TITLE"

function GFRAME:Paint()
	local w = self:GetWide()-1
	local h = self:GetTall()-1
	
	outline = {};
	outline[1]= {x = (h*0.3), 			y = 0}
	outline[2]= {x = w-(h*0.3), y = 0}
	outline[3]= {x = w,			y = h/2}
	outline[4]= {x = w-(h*0.3), 			y = h}
	outline[5]= {x = (h*0.3), 	y = h}
	outline[6]= {x = 0,			y = h/2}
	
	top = {};
	top[1]= {x = (h*0.3), 			y = 0}
	top[2]= {x = w-(h*0.3), y = 0}
	top[3]= {x = w,			y = h/2}
	top[4]= {x = 0,			y = h/2}
	
	bot = {};
	bot[1]= {x = w,			y = h/2}
	bot[2]= {x = w-(h*0.3), 			y = h}
	bot[3]= {x = (h*0.3), 	y = h}
	bot[4]= {x = 0,			y = h/2}
	
	surface.SetTexture(0)
	surface.SetDrawColor( bg_colors.ghostlight ) --set the additive color
	surface.DrawPoly( top ) --draw the triangle with our triangle table
	surface.SetDrawColor( bg_colors.ghost ) --set the additive color
	surface.DrawPoly( bot ) --draw the triangle with our triangle table
	surface.SetDrawColor( line_colors.ghost ) --set the additive color
	for k, v in pairs(outline) do
		if k == table.Count(outline) then
			surface.DrawLine( v.x, v.y, outline[1].x, outline[1].y )
		else
			surface.DrawLine( v.x, v.y, outline[k+1].x, outline[k+1].y )
		end
	end
	
	draw.SimpleTextOutlined(self.Title, "GhostTitle", w/2, 0, font_colors.ghost, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, font_colors.black)
	return true
end

function GFRAME:SetTitle(title)
	self.Title = title
end

derma.DefineControl("GFrame","Ghost GUI frame", GFRAME, "DPanel")
			

			
local SFRAME = {}

SFRAME.Title = "#SWAT_TITLE"

function SFRAME:Paint()
	local w = self:GetWide()-1
	local h = self:GetTall()-1
	local corner = 10
	outline = {};
	outline[1]= {x = corner, 		y = 0}
	outline[2]= {x = w-corner, 	y = 0}
	outline[3]= {x = w,				y = corner}
	outline[4]= {x = w,				y = h-corner}
	outline[5]= {x = w-corner, 		y = h}
	outline[6]= {x = corner, 		y = h}
	outline[7]= {x = 0,				y = h-corner}
	outline[8]= {x = 0,				y = corner}
	
	top = {};
	top[1]= {x = corner, 		y = 0}
	top[2]= {x = w-corner, 	y = 0}
	top[3]= {x = w,				y = corner}
	top[4]= {x = w,				y = 20}
	top[5]= {x = 0,				y = 20}
	top[6]= {x = 0,				y = corner}
	
	bot = {};
	bot[1]= {x = 0,				y = 20}
	bot[2]= {x = w,				y = 20}
	bot[3]= {x = w,				y = h-corner}
	bot[4]= {x = w-corner,		y = h}
	bot[5]= {x = corner,		y = h}
	bot[6]= {x = 0,				y = h-corner}
	
	
	surface.SetTexture(0)
	surface.SetDrawColor( bg_colors.swatlight ) --set the additive color
	surface.DrawPoly( top ) --draw the triangle with our triangle table
	surface.SetDrawColor( bg_colors.swat ) --set the additive color
	surface.DrawPoly( bot ) --draw the triangle with our triangle table
	surface.SetDrawColor( line_colors.swat ) --set the additive color
	surface.DrawLine( 0,20,w,20 )
	for k, v in pairs(outline) do
		if k == table.Count(outline) then
			surface.DrawLine( v.x, v.y, outline[1].x, outline[1].y )
		else
			surface.DrawLine( v.x, v.y, outline[k+1].x, outline[k+1].y )
		end
	end
	
	draw.SimpleTextOutlined(self.Title, "SWATTitle", w/2, 3, font_colors.swat, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, line_colors.swat)
	return true
end

--[[ --SQUARE SWAT PANEL
function SFRAME:Paint()
	local w = self:GetWide()
	local h = self:GetTall()
	
	surface.SetDrawColor( bg_colors.swatlight ) --set the additive color
	surface.DrawRect( 0,0,w,20 )
	surface.SetDrawColor( bg_colors.swat ) --set the additive color
	surface.DrawRect( 0,20,w,h )
	surface.SetDrawColor( line_colors.swat ) --set the additive color
	surface.DrawOutlinedRect( 0,0,w,h )
	surface.DrawLine( 0,20,w,20 )
	
	draw.SimpleTextOutlined(self.Title, "SWATTitle", w/2, 3, font_colors.swat, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, line_colors.swat)
	return true
end
]]--
function SFRAME:SetTitle(title)
	self.Title = title
end

derma.DefineControl("SFrame","Swat GUI frame", SFRAME, "DPanel")

function ep_DermaDefault(panel)
	draw.RoundedBox( 8, 0, 0, panel:GetWide(), panel:GetTall(), Color( 0, 0, 0, 100 ) )
end

function ep_DermaSWAT(panel)
	draw.RoundedBox( 8, 0, 0, panel:GetWide(), panel:GetTall(), bg_colors.swat )
end
