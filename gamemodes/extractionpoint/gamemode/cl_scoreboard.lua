include("cl_colors.lua")
surface.CreateFont( "EPScoreboardDefault",
{
	font		= "System",
	size		= 16,
	weight		= 800,
})

surface.CreateFont( "EPScoreboardDefaultTitle",
{
	font		= "System",
	size		= 32,
	weight		= 800,
})

local params = {
	["$basetexture"] = "VGUI/circle.vtf",
	["$nodecal"] = 1,
	["$model"] = 1,
	["$additive"] = 1,
	["$nocull"] = 1,
	["$vertexcolor"] = true,
	["$vertexalpha"] = true
	}
local scoreboard_mat = CreateMaterial("Scoreboard","UnlitGeneric",params)
--
-- This defines a new panel type for the player row. The player row is given a player
-- and then from that point on it pretty much looks after itself. It updates player info
-- in the think function, and removes itself when the player leaves the server.
--
local PLAYER_LINE = 
{
	Init = function( self )

		self.AvatarButton = self:Add( "DButton" )
		self.AvatarButton:Dock( LEFT )
		self.AvatarButton:SetSize( 32,32 )
		self.AvatarButton.DoClick = function() self.Player:ShowProfile() end

		self.Avatar		= vgui.Create( "AvatarImage", self.AvatarButton )
		self.Avatar:SetSize( 32,32 )
		self.Avatar:SetMouseInputEnabled( false )		

		self.Name = self:Add( "DLabel" )
		self.Name:Dock( FILL )
		self.Name:SetFont( "EPScoreboardDefault" )
		self.Name:DockMargin( 8, 0, 0, 0 )

		self.Mute		= self:Add( "DImageButton" )
		self.Mute:SetSize( 20, 20 )
		self.Mute:Dock( RIGHT )

		self.Ping		= self:Add( "DLabel" )
		self.Ping:Dock( RIGHT )
		self.Ping:SetWidth( 50 )
		self.Ping:SetFont( "EPScoreboardDefault" )
		self.Ping:SetContentAlignment( 5 )

		self.Deaths		= self:Add( "DLabel" )
		self.Deaths:Dock( RIGHT )
		self.Deaths:SetWidth( 40 )
		self.Deaths:SetFont( "EPScoreboardDefault" )
		self.Deaths:SetContentAlignment( 5 )

		self.Kills		= self:Add( "DLabel" )
		self.Kills:Dock( RIGHT )
		self.Kills:SetWidth( 40 )
		self.Kills:SetFont( "EPScoreboardDefault" )
		self.Kills:SetContentAlignment( 5 )

		self:Dock( TOP )
		self:DockPadding( 16, 3, 16, 3 )
		self:SetHeight( 20 + 3*2 )
		self:DockMargin( 2, 0, 2, 2 )

	end,

	Setup = function( self, pl )

		self.Player = pl

		self.Avatar:SetPlayer( pl )
		self.Name:SetText( string.upper(pl:Nick()) )

		self:Think( self )

		--local friend = self.Player:GetFriendStatus()
		--MsgN( pl, " Friend: ", friend )

	end,

	Think = function( self )

		if ( !IsValid( self.Player ) ) then
			self:SetZPos( 9999 ) -- Causes a rebuild
			self:Remove()
			return
		end

		if ( self.NumKills == nil || self.NumKills != self.Player:Frags() ) then
			self.NumKills	=	self.Player:Frags()
			self.Kills:SetText( self.NumKills )
		end

		if ( self.NumDeaths == nil || self.NumDeaths != self.Player:Deaths() ) then
			self.NumDeaths	=	self.Player:Deaths()
			self.Deaths:SetText( ""..self.NumDeaths )
		end

		if ( self.NumPing == nil || self.NumPing != self.Player:Ping() ) then
			self.NumPing	=	self.Player:Ping()
			self.Ping:SetText( self.NumPing )
		end
		if ( self.Player:Team() == TEAM_GHOST ) then 
			self.Name:SetTextColor(font_colors.ghost)
			self.Name.Paint = function(self,w,h)
				--draw.SimpleTextOutlined(self:GetText(),  "EPScoreboardDefault" , 22, 18, font_colors.ghost, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 0, highlight_colors.black)
				return
			end
			self.Ping:SetTextColor(font_colors.swat)
			self.Ping.Paint = function(self,w,h)
				--draw.SimpleTextOutlined(self:GetText(),  "EPScoreboardDefault" , 20, 18, font_colors.default, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 0, highlight_colors.black)
				return
			end
			self.Deaths:SetTextColor(font_colors.ghost)
			self.Deaths.Paint = function(self,w,h)
				--draw.SimpleTextOutlined(self:GetText(),  "EPScoreboardDefault" , 20, 18, font_colors.swat, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 0, highlight_colors.black)
				return
			end
			self.Kills:SetTextColor(font_colors.ghost)
			self.Kills.Paint = function(self,w,h)
				--draw.SimpleTextOutlined(self:GetText(),  "EPScoreboardDefault" , 20, 18, font_colors.ghost, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 0, highlight_colors.black)
				return
			end
		end
		if ( self.Player:Team() == TEAM_SWAT ) then 
			--self.Name:SetColor(font_colors.black)
			self.Name.Paint = function(self,w,h)
				--draw.SimpleTextOutlined(self:GetText(),  "EPScoreboardDefault" , 22, 18, font_colors.swat, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, highlight_colors.black)
				return
			end
			--self.Ping:SetColor(font_colors.black)
			self.Ping.Paint = function(self,w,h)
				--draw.SimpleTextOutlined(self:GetText(),  "EPScoreboardDefault" , 20, 18, font_colors.default, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, highlight_colors.black)
				return
			end
			--self.Deaths:SetColor(font_colors.black)
			self.Deaths.Paint = function(self,w,h)
				--draw.SimpleTextOutlined(self:GetText(),  "EPScoreboardDefault" , 20, 18, font_colors.swat, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, highlight_colors.black)
				return
			end
			--self.Kills:SetColor(font_colors.black)
			self.Kills.Paint = function(self,w,h)
				--draw.SimpleTextOutlined(self:GetText(),  "EPScoreboardDefault" , 20, 18, font_colors.ghost, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, highlight_colors.black)
				return
			end
		end

		--
		-- Change the icon of the mute button based on state
		--
		if ( self.Muted == nil || self.Muted != self.Player:IsMuted() ) then

			self.Muted = self.Player:IsMuted()
			if ( self.Muted ) then
				self.Mute:SetImage( "icon32/muted.png" )
			else
				self.Mute:SetImage( "icon32/unmuted.png" )
			end

			self.Mute.DoClick = function() self.Player:SetMuted( !self.Muted ) end

		end

		--
		-- Connecting players go at the very bottom
		--

		--
		-- This is what sorts the list. The panels are docked in the z order, 
		-- so if we set the z order according to kills they'll be ordered that way!
		-- Careful though, it's a signed short internally, so needs to range between -32,768k and +32,767
		--
		if self.Player:Team() == TEAM_GHOST then
			self:SetZPos( 1000 + (self.NumKills) + 1 )
		else
			self:SetZPos( 0 + (self.NumKills) + 1 )
		end
		if ( self.Player:Team() == TEAM_CONNECTING ) then
			self:SetZPos( 2000 )
		end

	end,

	Paint = function( self, w, h )

		if ( !IsValid( self.Player ) ) then
			return
		end
		w = w-1
		h = h-1
		
		--
		-- We draw our background a different colour based on the status of the player
		--
		if ( self.Player:Team() == TEAM_GHOST ) then 
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
		
		end
		if ( self.Player:Team() == TEAM_SWAT ) then 	
			local corner = 6
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
			top[4]= {x = w,				y = 6}
			top[5]= {x = 0,				y = 6}
			top[6]= {x = 0,				y = corner}
			
			bot = {};
			bot[1]= {x = 0,				y = 6}
			bot[2]= {x = w,				y = 6}
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
			for k, v in pairs(outline) do
				if k == table.Count(outline) then
					surface.DrawLine( v.x, v.y, outline[1].x, outline[1].y )
				else
					surface.DrawLine( v.x, v.y, outline[k+1].x, outline[k+1].y )
				end
			end
		end
		if ( self.Player:Team() == TEAM_CONNECTING ) then 
			surface.SetDrawColor( 100,100,100,200 ) --set the additive color
		end
	end,
}

--
-- Convert it from a normal table into a Panel Table based on DPanel
--
PLAYER_LINE = vgui.RegisterTable( PLAYER_LINE, "DPanel" );

local TEAM_MARKER = 
{
	Init = function( self )
		self.Name = self:Add( "DLabel" )
		self.Name:Dock( FILL )
		self.Name:SetFont( "EPScoreboardDefault" )
		self.Name:DockMargin( 8, 0, 0, 0 )
		self.Name:SetColor(highlight_colors.swat)
		
		
		
		self:Dock( TOP )
		self:DockPadding( 16, 3, 16, 3 )
		self:SetHeight( 20 + 3*2 )
		self:DockMargin( 50, 0, 500, 2 )
		
		self.Team = 0
	end,

	Setup = function( self, team )
		if team == TEAM_SWAT then
			self.Name:SetText( "S.W.A.T. TEAM" )
			self.Name:SetColor(highlight_colors.swat)
			self:SetZPos( 0 )
			self.Name.Paint = function(self,w,h)
				--draw.SimpleTextOutlined(self:GetText(),  "EPScoreboardDefault" , 12, 18, highlight_colors.swat, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, line_colors.black)
				return
			end
		end
		if team == TEAM_GHOST then
			self.Name:SetText( "GHOST FORCE" )
			self.Name:SetColor(highlight_colors.ghost)
			self:SetZPos( 1000 )
			self.Name.Paint = function(self,w,h)
				--draw.SimpleTextOutlined(self:GetText(),  "EPScoreboardDefault" , 12, 18, highlight_colors.ghost, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, line_colors.black)
				return
			end
		end
		self.Team = team
	end,

	Paint = function( self, w, h )
		w = w-1
		h = h-1
		if ( self.Team == TEAM_GHOST ) then 
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
		
		end
		if ( self.Team == TEAM_SWAT ) then 	
			local corner = 6
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
			top[4]= {x = w,				y = 6}
			top[5]= {x = 0,				y = 6}
			top[6]= {x = 0,				y = corner}
			
			bot = {};
			bot[1]= {x = 0,				y = 6}
			bot[2]= {x = w,				y = 6}
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
			for k, v in pairs(outline) do
				if k == table.Count(outline) then
					surface.DrawLine( v.x, v.y, outline[1].x, outline[1].y )
				else
					surface.DrawLine( v.x, v.y, outline[k+1].x, outline[k+1].y )
				end
			end
		end
	end,
}

TEAM_MARKER = vgui.RegisterTable( TEAM_MARKER, "DPanel" );

--
-- Here we define a new panel table for the scoreboard. It basically consists 
-- of a header and a scrollpanel - into which the player lines are placed.
--
local SCORE_BOARD = 
{
	Init = function( self )

		self.Header = self:Add( "Panel" )
		self.Header:Dock( TOP )
		self.Header:SetHeight( 100 )

		self.Name = self.Header:Add( "DLabel" )
		self.Name:SetFont( "EPScoreboardDefaultTitle" )
		self.Name:SetTextColor( Color( 255, 255, 255, 255 ) )
		self.Name:Dock( TOP )
		self.Name:SetHeight( 40 )
		self.Name:SetContentAlignment( 5 )

		--self.NumPlayers = self.Header:Add( "DLabel" )
		--self.NumPlayers:SetFont( "EPScoreboardDefault" )
		--self.NumPlayers:SetTextColor( Color( 255, 255, 255, 255 ) )
		--self.NumPlayers:SetPos( 0, 100 - 30 )
		--self.NumPlayers:SetSize( 300, 30 )
		--self.NumPlayers:SetContentAlignment( 4 )

		self.Scores = self:Add( "DScrollPanel" )
		self.Scores:Dock( FILL )
		GhostMarker = vgui.CreateFromTable(TEAM_MARKER)
		GhostMarker:Setup(TEAM_GHOST)
		SwatMarker = vgui.CreateFromTable(TEAM_MARKER)
		SwatMarker:Setup(TEAM_SWAT)
		self.Scores:AddItem( GhostMarker )
		self.Scores:AddItem( SwatMarker )

	end,

	PerformLayout = function( self )

		self:SetSize( 700, ScrH() - 200 )
		self:SetPos( ScrW() / 2 - 350, 100 )

	end,

	Paint = function( self, w, h )

		--draw.RoundedBox( 4, 0, 0, w, h, Color( 0, 0, 0, 200 ) )

	end,

	Think = function( self, w, h )

		self.Name:SetText( GetHostName() )

		--
		-- Loop through each player, and if one doesn't have a score entry - create it.
		--
		local plyrs = player.GetAll()
		for id, pl in pairs( plyrs ) do

			if ( IsValid( pl.ScoreEntry ) ) then continue end

			pl.ScoreEntry = vgui.CreateFromTable( PLAYER_LINE, pl.ScoreEntry )
			pl.ScoreEntry:Setup( pl )

			self.Scores:AddItem( pl.ScoreEntry )

		end		

	end,
}

SCORE_BOARD = vgui.RegisterTable( SCORE_BOARD, "EditablePanel" );

--[[---------------------------------------------------------
   Name: gamemode:ScoreboardShow( )
   Desc: Sets the scoreboard to visible
-----------------------------------------------------------]]
function GM:ScoreboardShow()

	if ( !IsValid( g_Scoreboard ) ) then
		g_Scoreboard = vgui.CreateFromTable( SCORE_BOARD )
	end

	if ( IsValid( g_Scoreboard ) ) then
		g_Scoreboard:Show()
		g_Scoreboard:MakePopup()
		g_Scoreboard:SetKeyboardInputEnabled( false )
	end

end

--[[---------------------------------------------------------
   Name: gamemode:ScoreboardHide( )
   Desc: Hides the scoreboard
-----------------------------------------------------------]]
function GM:ScoreboardHide()

	if ( IsValid( g_Scoreboard ) ) then
		g_Scoreboard:Hide()
	end

end


--[[---------------------------------------------------------
   Name: gamemode:HUDDrawScoreBoard( )
   Desc: If you prefer to draw your scoreboard the stupid way (without vgui)
-----------------------------------------------------------]]
function GM:HUDDrawScoreBoard()

end

