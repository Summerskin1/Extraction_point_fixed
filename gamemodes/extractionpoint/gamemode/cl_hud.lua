include( "cl_derma.lua" )
include( "cl_colors.lua" )
local table = table
local surface = surface
local draw = draw
local math = math
local string = string


local tips = {	"The HC-45 Heavy Cannon's shells will bounce at shallow angles.\n Use this to deny areas or hit targets around corners.",
	"Technicians can defuse trip mines with the USE key.\nKeep your technicians alive to clear paths.",
	"Remote explosives will explode when shot.\nUse this to clear your path.",
	"Frag grenades deal huge damage in a small area.\nThey are especially useful against revenants!",
	"Plasma balls bounce off walls, they can hit you around corners!",
	"Aiming down sights lowers your movement speed.\nBut it significantly boosts your accuracy.\nIt also decreases your recoil significantly!",
	"Medics can see a teammate's health at a distance.\nSimilarly, Commanders can see them even through walls.",
	"If you're a swat, your teammates can't hear you if you're far away.\nPull out your radio to get your message across.",
	"Caltrop grenades spray tiny energy pellets on the ground.\nThey hurt to step on, so look out for the small orange balls on the ground!",
	"Gas grenades aren't too dangerous if you stay out of the smoke.\nDon't risk it, wait for the grenade to clear up or go around!",
	"The pincer will lock on after a brief period of time.\nBreak line of sight or you're going to be in for a world of hurt!",
	"The SSW.138 Machine Gun will pierce thin walls.\nUse it to hit ghosts hiding in poor cover!",
	"The dual machine pistols don't point at the same place.\nSometimes it's best to only use one machine pistol at a time.",
	"The railgun can hit you right through walls.\nIf you think the enemy has one, don't stand still!",
	"As a swat, your only options to heal are medics or the HP5 Medical dart\nIf there's none of these left on your team, take care to avoid damage!",
	"The HE grenade has a large splash radius but lower damage.\nIt's excellent against the more frail ghosts.\nEspecially Wraiths.",
	"Stun grenades deal light damage.\nBut they also slow movement speed on afflicted enemies.\nIf you land a stun grenade, attack while your foe can't escape!",
	"Fast reloads can let you reload faster than you would normally.\nWhen the white bar hits the light grey section, press reload again!\nDon't miss though.\nbecause failing a reload will double the time it takes to reload!",
	"Motion detectors have a larger radius when thrown to the ground.\nThey're excellent for defending an area.",
	"The prism has firing modes for long and short range.\nBut it is the master of neither.\nUse an appropriate weapon and you'll come out on top!",
	"The vector will shoot faster as you hold the trigger down.\nAt long range it might be better to fire single shots.",
	"Armored swat are surprisingly tough.\nThey can't regenerate though, so attrition tactics work well.",
	"Wraiths regenerate quickly at all times.\nUse every resource you have to kill them as soon as possible.\nA wraith will always win the war of attrition.\nSo don't give him the chance!",
	"Shades have excellent battlefield knowledge.\nThey know your class, your health and even who you are!\nBut they have no advantages in a straight up fight.\nEngage on your terms, not theirs, and you're sure to come out on top!",
	"Eidolon will heal off damage he deals.\nHe'll quickly gain a high health advantage if you let him.\nUnlike revenant however, his head is a significant weakpoint.\nget a headshot to put him down fast!",
	"Grenadiers have lots of grenades.\nBut if you can bait them out he'll be left nearly defenseless.\nDon't get too close or his grenades will drop you in seconds.",
	"Revenants have loads of health, and they're immune to headshots.\nUse your high damage weaponry!",
	"Medics heal themselves and their nearby allies passively.\nKill them first to weaken the group as a whole.",
	"Pointmen carry an additional primary\nThey're excellent at pushing the advantage\nBut after a firefight they need to reload!",
	"Poltergeists are cloaked permanently, but they still leave a shimmer.\nThey don't have any other advantages though.\nSo keep your eyes peeled and you can handle them!",
	"Scouts move quickly.\nBut they slow down just as much as anyone else when they grab the relay.\nJust be careful not to get surprised if one arrives faster than you think!",
	"Technicians have a motion detector at all times.\nDon't try to get too fancy, he'll see you coming.\nLong distances can alleviate this, standing still will also keep you hidden.",
	"You can parry other knife blows when wielding the knife!\nIf you attack at the same time as your foe You'll both parry eachother's blows.\nIt's easier to parry a power swing.\nIf you get parried on a power swing, you'll be temporarily stunned.",
	"The knife deals bonus damage on a backstab.\nA power swing will kill most swat in the back.",
	"The Ghost's SMG will ricochet around corners.\nYou can get a lot of free damage off if you're smart.",
	"The AT RPG is so powerful you can't fire it from the standing position.\nDuck to fire, but make that rocket count!\nYou only get one!",
	"If it bleeds, you can kill it.",
	"Mini Turrets are easily destroyed with explosives\nStun grenades work too.",
	"The SWAT shield can be pierced by the Railgun.",
	"You can't take back a grenade.",
	"Never pet a burning dog.",
	"If it bleeds, you can kill it.",
	"If you doubt your powers, you give power to your doubts.",
	"Operators don't show up through walls\nThey also get massive bonuses for hitting your back!\nStay aware to stay alive!",
	"Wisps deal passive damage to nearby swat\nIt's not that much though so don't freak out\nBe aware that when he dies he will explode!",
	"The webcaster is tricky to use\nKeep in mind it works well as an area denial weapon\nShoot it into doorways swat want to breach\nOr other places they want to go!",
	"Chaff grenades only block the view of ghosts\nUse them as visual cover to advance safely!",
	"The SWAT Pistol deals bonus damage to the head, make those shots count!",
	"The SWAT Revolver is a high powered weapon\nDon't underestimate it!",
	"The dart launcher fires explosives that stick\nDon't stand near your friends if you're hit!",
	"The Light Cannon offers a huge calibre shot\nYou just have to reload after every bullet!",
	"The SWAT SMG is highly accurate\nHowever sustained fire will cause innacuracy\nPace yourself!",
	"The Combat 92 is accurate and powerful\nLearning to manage it's recoil will give you the upper hand!",
	"The Shotgun is more accurate if you aim\nTry to avoid hipfire.",
	"To walljump, press space again while touching a wall.\nThis offers the Ghosts a huge mobility advantage!\nDon't forget it!",
	"To walljump, press space again while touching a wall.\nThis offers the Ghosts a huge mobility advantage!\nDon't forget it!",
	"To walljump, press space again while touching a wall.\nThis offers the Ghosts a huge mobility advantage!\nDon't forget it!",
	"To walljump, press space again while touching a wall.\nThis offers the Ghosts a huge mobility advantage!\nDon't forget it!",
	"To walljump, press space again while touching a wall.\nThis offers the Ghosts a huge mobility advantage!\nDon't forget it!",
	"Carrying the relay will slow you down\nPicking it up is a tactical decision\nSometimes it's best to leave it be.",
	"Thanks for playing\nMake sure you come play again!",
  "The MK-900 fires a huge slug\nTargets struck will be temporarily slowed by the shock.",
  "The Pulse Gun is extremely versatile.\nAccurate primary fire and an explosive alt fire.\nTry shooting down the pulse core!",
  "Liches heal quickly in gas\nThey'll also spawn gas from slain SWAT...\nStay spread out to avoid the area of effect.",
  "Vanguard are tough from the front.\nHowever they are still vulnerable to headshots."
}

local scoreboardmode = false

surface.CreateFont("EPText", {font = "Trebuchet24",
                                    size = 16,
                                    weight = 1000})

surface.CreateFont("EPAmmo", {font = "Tahoma",
                                    size = 32,
                                    weight = 1000})

surface.CreateFont("EPTarget", {font = "Arial Black",
									size = 18,
									weight = 1000})

--Materials
local params = {
	["$basetexture"] = "models/debug/debugwhite",
	["$nodecal"] = 1,
	["$model"] = 1,
	["$additive"] = 1,
	["$nocull"] = 1,
	["$vertexcolor"] = true,
	["$vertexalpha"] = true
	}
local ghost_health = CreateMaterial("GhostHealth","UnlitGeneric",params);

local params = {
	["$basetexture"] = "models/debug/debugwhite",
	["$nodecal"] = 1,
	["$model"] = 1,
	["$additive"] = 1,
	["$nocull"] = 1,
	["$vertexcolor"] = true,
	["$vertexalpha"] = true
	}
local swat_health = CreateMaterial("SWATHealth","UnlitGeneric",params);

local pipparams = {
	["$basetexture"] = "VGUI/circle.vtf",
	["$nodecal"] = 1,
	["$model"] = 1,
	["$additive"] = 1,
	["$nocull"] = 1,
	["$vertexcolor"] = true,
	["$vertexalpha"] = true
	}
local pip = CreateMaterial("HealthPip","UnlitGeneric",pipparams)

local function GetAmmo(ply)
	local weap = ply:GetActiveWeapon()
	if not weap or not ply:Alive() then return -1 end

	local ammo_inv = weap:Ammo1() or 0
	local ammo_clip = weap:Clip1() or 0
	local ammo_max = weap.Primary.ClipSize or 0

	return ammo_clip, ammo_max, ammo_inv
end

--Wallhacks for the ghost team
local function DrawRadar(ply)
	if scoreboardmode then return end
	player_manager.RunClass( ply, "DrawRadar" )
end

--Ghost's HUD
local function DrawGhostHUD(ply)
	local targ = ply
	if !ply:Alive() then
		local ptarg = ply:GetObserverTarget()
		if targ and targ:IsValid() and targ:Alive() then
			targ = ptarg
		end
	end
	if scoreboardmode then return end

	--Weapon overview yay.
	local offsets = {}
	for k,v in pairs (targ:GetWeapons()) do
		if v.DrawDetails then
			offsets[v.Slot] = offsets[v.Slot] or 0
			if v == targ:GetActiveWeapon() then
				v:DrawDetails(ScrW()-80-offsets[v.Slot], v.Slot*60+ScrH()/2-180,80,80,255, true)
			else
				v:DrawDetails(ScrW()-80-offsets[v.Slot], v.Slot*60+ScrH()/2-180,80,80,255, false)
			end
			offsets[v.Slot] = offsets[v.Slot]+80
		end
	end

	local x = ScrW()/2
	local y = ScrH()/2

	--Healthbar
	local xpos = (y/8)
	local ypos = ScrH()-(y/8)
	local width = x/4
	local height = y/24
	local health = targ:Health()/100 --Can't check the players max health from client. This may cause issues if ghosts end up with more than 100hp.
	--surface.SetMaterial(ghost_health)
	surface.SetMaterial(pip)
	for i = 0, targ:Health()/25, 1 do
		local w = height*1.3
		local h = height
		local xb = xpos+i*height*1
		local yb
		if math.mod(i,2) == 1 then
			yb = ypos
		else
			yb = ypos+height/2
		end
		outline = {};
		outline[1]= {x = xb+(h*0.3), 			y = yb+0}
		outline[2]= {x = xb+w-(h*0.3), 			y = yb+0}
		outline[3]= {x = xb+w,					y = yb+h/2}
		outline[4]= {x = xb+w-(h*0.3), 			y = yb+h}
		outline[5]= {x = xb+(h*0.3), 			y = yb+h}
		outline[6]= {x = xb+0,					y = yb+h/2}

		top = {};
		top[1]= {x = xb+(h*0.3), 				y = yb+0}
		top[2]= {x = xb+w-(h*0.3), 				y = yb+0}
		top[3]= {x = xb+w,						y = yb+h/2}
		top[4]= {x = xb+0,						y = yb+h/2}

		bot = {};
		bot[1]= {x = xb+w,						y = yb+h/2}
		bot[2]= {x = xb+w-(h*0.3), 				y = yb+h}
		bot[3]= {x = xb+(h*0.3), 				y = yb+h}
		bot[4]= {x = xb+0,						y = yb+h/2}
		alpha = (health*4) - (i)
		surface.SetTexture(0)
		local redden = Color(244,0,0,math.Clamp(100-alpha*100,0,255))
		local alp = math.Clamp(alpha*255,0,255)
		if alp > 20 then
		surface.SetDrawColor( bg_colors.ghostlight.r,bg_colors.ghostlight.g,bg_colors.ghostlight.b, alp ) --set the additive color
		surface.DrawPoly( top ) --draw the triangle with our triangle table
		surface.SetDrawColor( bg_colors.ghost.r,bg_colors.ghost.g,bg_colors.ghost.b, alp ) --set the additive color
		surface.DrawPoly( bot ) --draw the triangle with our triangle table
			surface.SetDrawColor( redden ) --set the additive color
		surface.DrawPoly( outline ) --draw the triangle with our triangle table
		surface.SetDrawColor( line_colors.ghost ) --set the additive color
		for k, v in pairs(outline) do
			if k == table.Count(outline) then
				surface.DrawLine( v.x, v.y, outline[1].x, outline[1].y )
			else
				surface.DrawLine( v.x, v.y, outline[k+1].x, outline[k+1].y )
			end
		end
		end
		--surface.SetDrawColor( bg_colors.ghost.r, bg_colors.ghost.g, bg_colors.ghost.b, alpha*255 )
		--surface.DrawRect( xpos+(height*i*1.1), ypos, height, height)
		--surface.SetDrawColor( line_colors.ghost.r,line_colors.ghost.g,line_colors.ghost.b, alpha*1000 )
		--surface.DrawOutlinedRect( xpos+(height*i*1.1), ypos, height, height)
	end
    --surface.SetDrawColor( 50, 50, 150, 200 )
    --surface.DrawTexturedRect( xpos, ypos, width*health, height)
	--Ammo (Maybe do this inside the SWEP Drawhud() function instead?

end

--SWATs HUD
local function DrawSWATHUD(ply)
	if scoreboardmode then return end
	local targ = ply
	if !ply:Alive() then
		local ptarg = ply:GetObserverTarget()
		if targ and targ:IsValid() and targ:Alive() then
			targ = ptarg
		end
	end

	--Weapon overview yay.
	local offsets = {}
	for k,v in pairs (targ:GetWeapons()) do
		if v.DrawDetails then
			offsets[v.Slot] = offsets[v.Slot] or 0
			if v == targ:GetActiveWeapon() then
				v:DrawDetails(ScrW()-80-offsets[v.Slot], v.Slot*60+ScrH()/2-180,80,80,255, true)
			else
				v:DrawDetails(ScrW()-80-offsets[v.Slot], v.Slot*60+ScrH()/2-180,80,80,255, false)
			end
			offsets[v.Slot] = offsets[v.Slot]+80
		end
	end
	local x = ScrW()/2
	local y = ScrH()/2

	--Healthbar
	local xpos = (y/8)
	local ypos = ScrH()-(y/8)
	local width = x/4
	local height = y/24
	local health = targ:Health()/100 --Can't check the players max health from client. This may cause issues if ghosts end up with more than 100hp.
	--surface.SetMaterial(ghost_health)
	surface.SetMaterial(pip)
	for i = 0, targ:Health()/25, 1 do
		alpha = (health*4) - (i)
		surface.SetDrawColor( bg_colors.swat.r, bg_colors.swat.g, bg_colors.swat.b, alpha*255 )
		surface.DrawRect( xpos+(height*i*1.1), ypos+height*(math.Clamp(1-alpha,0,1)), height, height*math.Clamp(alpha,0,1))
		surface.SetDrawColor( line_colors.swat.r,line_colors.swat.g,line_colors.swat.b, alpha*1000 )
		surface.DrawOutlinedRect( xpos+(height*i*1.1), ypos+height*(math.Clamp(1-alpha,0,1)), height, height*math.Clamp(alpha,0,1))
	end
    --surface.SetDrawColor( 50, 50, 150, 200 )
    --surface.DrawTexturedRect( xpos, ypos, width*health, height)
	--Ammo (Maybe do this inside the SWEP Drawhud() function instead?
	for k,v in pairs (player.GetAll()) do
		if player_manager.RunClass(v,"CommanderBehaviour") then
			if (v:GetPos()-LocalPlayer():GetPos()):Length() < 500 then
				local color =  font_colors.swat
				surface.SetAlphaMultiplier( 5-(v:GetPos()-LocalPlayer():GetPos()):Length()/100)
				draw.SimpleTextOutlined("COMMANDER BOOST!", "EPText", ScrW() / 2, ScrH()-ScrH()/4-20, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, font_colors.black)
				draw.SimpleTextOutlined("+50% DAMAGE +20% DAMAGE RESISTANCE", "EPText", ScrW()/2, ScrH()-ScrH() / 4, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, font_colors.black)
				surface.SetAlphaMultiplier( 1 )
				break
			end
		end
	end
end

--Spectator HUD
local function DrawSpecHUD()

end

local function DrawObjectiveIcon(posx, posy, text, color)
	--Icon
	local offset = ScrW()/20
	posx = math.Clamp(posx, 0+offset,ScrW()-offset)
	posy = math.Clamp(posy, 0+offset,ScrH()-offset)
	surface.SetDrawColor(color)
	local width = ScrW()/150
	surface.DrawRect( posx-width/2, posy-width*5, width, width*3)
	surface.DrawRect( posx-width/2, posy-width, width, width)
	surface.SetDrawColor( 0, 0, 0, 255 )
	surface.DrawOutlinedRect( posx-width/2, posy-width*5, width, width*3)
	surface.DrawOutlinedRect( posx-width/2, posy-width, width, width)

	--Text
	surface.SetAlphaMultiplier( 1-6*math.abs(-posx/ScrW()+0.5))
	draw.SimpleTextOutlined(text, "EPText", posx, posy-width*7, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, font_colors.black)
	surface.SetAlphaMultiplier( 1 )
end

local function DrawObjectiveText(posx, posy, text, color)
	--Icon
	local offset = ScrW()/20
	posx = math.Clamp(posx, 0+offset,ScrW()-offset)
	posy = math.Clamp(posy, 0+offset,ScrH()-offset)
	surface.SetDrawColor(color)
	local width = ScrW()/150
	--Text
	draw.SimpleTextOutlined(text, "EPTarget", posx, posy-width*7, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, font_colors.black)
end

local function DrawObjectiveList(objectives, color)
	local offset = 0
	local width = ScrW()/150
	draw.SimpleTextOutlined("OBJECTIVES:", "EPText", ScrW() / 16, ScrW() / 16, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, font_colors.black)
	offset = offset+draw.GetFontHeight("EPText")
	for k,v in pairs(objectives) do
		draw.SimpleTextOutlined(v, "EPText", ScrW() / 16 + width, ScrW() / 16 + offset, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, font_colors.black)
		offset = offset+draw.GetFontHeight("EPText")
	end
end

--Draws the objective icon for when the relay is on the ground for the SWAT team
local function DrawObjectiveSWATGround(ply, relay)
	local objectives = {}
	if relay:GetClass() == "ep_relay" then
		objectives[1] = "ELMINATE GHOST AGENTS"
		objectives[2] = "SECURE AND RETRIEVE THE RELAY"
		DrawObjectiveList(objectives, font_colors.swat)

		local target = (relay:GetPos()+Vector(0,0,30)):ToScreen()
		DrawObjectiveIcon(target.x, target.y, "SECURE RELAY", font_colors.swat)
	else
		objectives[1] = "ELMINATE GHOST AGENTS"
		objectives[2] = "LOCATE AND RETRIEVE THE RELAY"
		DrawObjectiveList(objectives, font_colors.swat)

		local target = (relay:GetPos()+Vector(0,0,30)):ToScreen()
		DrawObjectiveIcon(target.x, target.y, "POTENTIAL RELAY LOCATION", font_colors.swat)
	end
end

--Draws the objective icon for when the relay is on the ground for the Ghost team
local function DrawObjectiveGhostGround(ply, relay)
	local objectives = {}
	objectives[1] = "ELMINATE SWAT UNITS"
	objectives[2] = "PREVENT SWAT UNITS FROM SECURING THE RELAY"
	DrawObjectiveList(objectives, font_colors.ghost)

	local target = (relay:GetPos()+Vector(0,0,30)):ToScreen()
	DrawObjectiveIcon(target.x, target.y, "DEFEND RELAY", font_colors.ghost)
end
--Draws the objective icon for when the relay is being carried for the SWAT team
local function DrawObjectiveSWATTransit(ply, relay)
	local objectives = {}
	objectives[1] = "ELMINATE GHOST AGENTS"
	if relay:GetOwner() == LocalPlayer() then
		objectives[2] = "BRING THE RELAY TO THE EXTRACTION POINT"
	else
		objectives[2] = "ESCORT THE RELAY CARRIER TO THE EXTRACTION POINT"
	end
	DrawObjectiveList(objectives, font_colors.swat)

	if relay:GetOwner() == LocalPlayer() then
		extraction = ents.FindByClass("ep_extraction")
		if table.Count(extraction) == 0 then return end
		ep = table.GetFirstValue(extraction)
		local target = (ep:GetPos()+Vector(0,0,30)):ToScreen()
		DrawObjectiveIcon(target.x, target.y, "EXTRACTION POINT", font_colors.swat)
	else
		local target = (relay:GetPos()+Vector(0,0,30)):ToScreen()
		DrawObjectiveIcon(target.x, target.y, "RELAY CARRIER", font_colors.swat)
		extraction = ents.FindByClass("ep_extraction")
		if table.Count(extraction) == 0 then return end
		ep = table.GetFirstValue(extraction)
		local target = (ep:GetPos()+Vector(0,0,30)):ToScreen()
		DrawObjectiveIcon(target.x, target.y, "EXTRACTION POINT", font_colors.swat)
	end
end

--Draws the objective icon for when the relay is being carried for the Ghost team
local function DrawObjectiveGhostTransit(ply, relay)
	local objectives = {}
	objectives[1] = "ELMINATE SWAT UNITS"
	objectives[2] = "PREVENT SWAT UNITS FROM REACHING THE EXTRACTION POINT"
	DrawObjectiveList(objectives, font_colors.ghost)

	local target = (relay:GetPos()+Vector(0,0,30)):ToScreen()
	DrawObjectiveIcon(target.x, target.y, "RELAY CARRIER", font_colors.ghost)
	extraction = ents.FindByClass("ep_extraction")
	if table.Count(extraction) == 0 then return end
	ep = table.GetFirstValue(extraction)
	local target = (ep:GetPos()+Vector(0,0,30)):ToScreen()
	DrawObjectiveIcon(target.x, target.y, "EXTRACTION POINT", font_colors.ghost)
end

local function DrawObjectiveSWATCS(ply)
	local objectives = {}
	objectives[1] = "ELMINATE GHOST AGENTS"
	objectives[2] = "GET TO AND HOLD THE EXTRACTION POINT"

	DrawObjectiveList(objectives, font_colors.swat)

	local extraction = ents.FindByClass("ep_csextraction")
	if table.Count(extraction) == 0 then return end
	ep = table.GetFirstValue(extraction)
	local target = (ep:GetPos()+Vector(0,0,30)):ToScreen()
	DrawObjectiveIcon(target.x, target.y, "EXTRACTION POINT", font_colors.swat)
	local target = (ep:GetPos()+Vector(0,0,50)):ToScreen()
	DrawObjectiveText(target.x, target.y, ep:TimeLeft(), font_colors.swat)
end

local function DrawObjectiveGHOSTCS(ply)
	local objectives = {}
	objectives[1] = "ELMINATE SWAT UNITS"
	objectives[2] = "DEFEND THE SWAT'S EXTRACTION ZONE"

	DrawObjectiveList(objectives, font_colors.ghost)

	local extraction = ents.FindByClass("ep_csextraction")
	if table.Count(extraction) == 0 then return end
	ep = table.GetFirstValue(extraction)
	local target = (ep:GetPos()+Vector(0,0,30)):ToScreen()
	DrawObjectiveIcon(target.x, target.y, "EXTRACTION POINT", font_colors.ghost)
	local target = (ep:GetPos()+Vector(0,0,50)):ToScreen()
	local tmleft = ep:TimeLeft()
	DrawObjectiveText(target.x, target.y, tmleft, Color(255,(tmleft/30)*190,(tmleft/30)*80,255))
end

--Draw the positions of the SWAT team's objectives.
local function DrawObjectiveIndicators(ply)
	local flags = ents.FindByClass("ep_relay")
	if table.Count(flags) == 0 then
		if ply:Team() == TEAM_SWAT then
			DrawObjectiveSWATCS(ply)
		end
		if ply:Team() == TEAM_GHOST then
			DrawObjectiveGHOSTCS(ply)
		end
	else
		local flag = table.GetFirstValue(flags)
		if flag:GetCarried() then
			if ply:Team() == TEAM_GHOST then
				DrawObjectiveGhostTransit(ply, flag)
			end
			if ply:Team() == TEAM_SWAT then
				DrawObjectiveSWATTransit(ply, flag)
			end
		else
			if ply:Team() == TEAM_SWAT then
				if flag:GetActive() then
					DrawObjectiveSWATGround(ply, flag)
				else
					local objectives = ents.FindByClass( "ep_relay_marker" )
					for k,v in pairs( objectives )do
							DrawObjectiveSWATGround(ply, v)
					end
				end
			end
			if ply:Team() == TEAM_GHOST then
				DrawObjectiveGhostGround(ply, flag)
			end
		end
	end
end

local swatPickup = Sound("ep/swat_relay_taken.mp3")
local ghostPickup = Sound("ep/ghost_relay_taken.mp3")
local swatDropped = Sound("ep/swat_relay_dropped.mp3")
local ghostDropped = Sound("ep/ghost_relay_dropped.mp3")
local swatExtracted = Sound("ep/swat_relay_extracted.mp3")
local ghostExtracted = Sound("ep/ghost_relay_extracted.mp3")
local swatRoundstart = Sound("ep/swat_relay_moveout.mp3")
local ghostRoundstart = Sound("ep/ghost_relay_defend.mp3")

--Plays the Gamemode Sounds
local function CheckSoundEvents(ply)
	local flags = ents.FindByClass("ep_relay")
	if table.Count(flags) == 0 then return end
	local flag = table.GetFirstValue(flags)

	if flag:GetTriggerSound() > 0 then
		if flag:GetTriggerSound() == 1 then
			if ply:Team() == TEAM_GHOST then
				surface.PlaySound(ghostPickup)
			end
			if ply:Team() == TEAM_SWAT then
				surface.PlaySound(swatPickup)
			end
		elseif flag:GetTriggerSound() == 2 then
			if ply:Team() == TEAM_GHOST then
				surface.PlaySound(ghostDropped)
			end
			if ply:Team() == TEAM_SWAT then
				surface.PlaySound(swatDropped)
			end
		elseif flag:GetTriggerSound() == 3 then
			if ply:Team() == TEAM_GHOST then
				surface.PlaySound(ghostExtracted)
			end
			if ply:Team() == TEAM_SWAT then
				surface.PlaySound(swatExtracted)
			end
		elseif flag:GetTriggerSound() == 4 then
			if ply:Team() == TEAM_GHOST then
				--surface.PlaySound(ghostRoundstart)
			end
			if ply:Team() == TEAM_SWAT then
				--surface.PlaySound(swatRoundstart)
			end
		end
		flag:SetTriggerSound(0)
	end
end

local function DrawPerk(ply)
	if scoreboardmode then return end
	if ply:Alive() then
		player_manager.RunClass( ply, "DrawClass" )
	else
		local targ = ply:GetObserverTarget()
		if targ and targ:IsValid() and targ:Alive() then
			player_manager.RunClass( targ, "DrawClass" )
		end
	end
end

local function DrawSpecName(ply)
	local targ = ply:GetObserverTarget()
	if targ and targ:IsValid() and targ:Alive() then
		local color =  font_colors.default
		draw.SimpleTextOutlined("CURRENTLY SPECTATING:", "EPText", ScrW() / 2, ScrH()/2-90, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, font_colors.black)
		draw.SimpleTextOutlined(targ:Nick(), "EPText", ScrW()/2, ScrH()/2-70, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, font_colors.black)
	end
end



local winner = nil
-- Paints player status HUD element in the bottom left
function GM:HUDPaint()
	if scoreboardmode then
		if winner != nil and winner:IsValid() then
			local CamData = {}
			CamData.angles = (winner:GetPos()-(winner:GetPos()+Vector(5,60,10))):Angle()
			CamData.origin = winner:GetPos()+Vector(5,60,70)
			CamData.x = 0
			CamData.y = 0
			CamData.w = ScrW()
			CamData.h = ScrH()
			render.RenderView( CamData )
			--LocalPlayer():DrawModel()
		end
	end
	local ply = player.GetAll()
	local client = LocalPlayer()
	if client:Team() == TEAM_GHOST then
		DrawObjectiveIndicators(client)
		DrawGhostHUD(client)
	end
	if client:Team() == TEAM_SWAT then
		DrawObjectiveIndicators(client)
		DrawSWATHUD(client)
	end
	if !client:Alive() then
		DrawSpecName(client)
	end
	DrawRadar(client)
	DrawPerk(client)

	CheckSoundEvents(client)
	if table.Count(ply) == 1 and client:Alive() then
		local color =  font_colors.default
		draw.SimpleTextOutlined("SOLO PLAY (ALL WEAPONS AVAILABLE)", "EPText", ScrW() / 2, ScrH()/2-110, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, font_colors.black)
	end
end

function GM:ShouldDrawLocalPlayer()
	return scoreboardmode
end
function ScoreBoardCamera(player, command, args)
	scoreboardmode = true
end

concommand.Add( "ep_scorecam", ScoreBoardCamera )

function FinalScoreBoard(ply, cmd, args)
	CloseDermaMenus()

		local ghostscore, swatscore, ghostaverage, swataverage, ghostbest, swatbest, ghostclass, swatclass, ghostgun, swatgun
		local plyWin = player.GetByUniqueID(args[1]) or LocalPlayer()
		local plyGho = player.GetByUniqueID(args[2]) or nil
		local plySWA = player.GetByUniqueID(args[3]) or nil


		winner = plyWin
		winghost = winner:Frags()
		winswat = winner:Deaths()
		winbest = 100
		ghostbest = 100
		swatbest = 100
		winclass = string.upper(player_manager.RunClass(plyWin,"ClassName"))
		wingun = string.upper(plyWin:GetActiveWeapon().PrintName)

		wid = 400
		hgt = 90
		winPanel = nil
		if plyWin:Team() == TEAM_SWAT then
			winPanel = vgui.Create( "SFrame" ) -- Creates the frame itself
			winPanel:SetSize( wid,hgt ) -- Size of the frame
			winPanel:SetTitle( "BEST PLAYER: "..string.upper(plyWin:GetName()) ) -- Title of the frame
			winPanel:SetVisible( true )
		else
			winPanel = vgui.Create( "GFrame" ) -- Creates the frame itself
			winPanel:SetSize( wid,hgt ) -- Size of the frame
			winPanel:SetTitle( "BEST PLAYER: "..string.upper(plyWin:GetName()) ) -- Title of the frame
			winPanel:SetVisible( true )
		end

		local winLabel = vgui.Create( "DLabel", winPanel)
		winLabel:SetColor(Color(255,255,255,255)) // Color
		winLabel:SetFont("default")
		winLabel:SetText("TOTAL SCORE: "..(winghost+winswat).."\nBEST CLASS: "..winclass.."\nBEST GUN: "..wingun) // Text
		winLabel:SizeToContents() // make the control the same size as the text
		winLabel:Dock(TOP)

		local winavatar		= vgui.Create( "AvatarImage", winPanel )
		winavatar:SetSize( 64,64)
		winavatar:SetPlayer( plyWin )


		if plyWin:Team() == TEAM_GHOST then
			winPanel:DockPadding(-5+(winPanel:GetTall()*0.3),21,5+(winPanel:GetTall()*0.3),10)
			winPanel:SetPos( ScrW()/2-winPanel:GetWide()/2,ScrH()*5/6-winPanel:GetTall()/2 ) -- Position on the players screen
			winavatar:SetPos( winPanel:GetWide()-72-winPanel:GetTall()*0.3, 11)
		else
			winPanel:DockPadding(3,21,0,2)
			winPanel:SetPos( ScrW()/2-winPanel:GetWide()/2,ScrH()*5/6-winPanel:GetTall()/2 ) -- Position on the players screen
			winavatar:SetPos( winPanel:GetWide()-12-64, 22)
		end



		if plyGho then
			ghostscore = plyGho:Frags()
			ghostclass = string.upper(player_manager.RunClass(plyGho,"ClassName"))
			ghostgun = string.upper(plyGho:GetActiveWeapon().PrintName)
			ghostPanel = vgui.Create( "GFrame" ) -- Creates the frame itself
			ghostPanel:SetSize( wid,hgt ) -- Size of the frame
			ghostPanel:SetTitle( "BEST GHOST: "..string.upper(plyGho:GetName()) ) -- Title of the frame
			ghostPanel:SetVisible( true )

			local ghostLabel = vgui.Create( "DLabel", ghostPanel)
			ghostLabel:SetColor(Color(255,255,255,255)) // Color
			ghostLabel:SetFont("default")
			ghostLabel:SetText("SCORE: "..ghostscore.."\nBEST CLASS: "..ghostclass.."\nBEST GUN: "..ghostgun) // Text
			ghostLabel:SizeToContents() // make the control the same size as the text
			ghostLabel:Dock(TOP)

			local ghostavatar		= vgui.Create( "AvatarImage", ghostPanel )
			ghostavatar:SetSize( 64,64)
			ghostavatar:SetPos( ghostPanel:GetWide()-72-ghostPanel:GetTall()*0.3, 11)
			ghostavatar:SetPlayer( plyGho )

			ghostPanel:DockPadding(-5+(ghostPanel:GetTall()*0.3),21,5+(ghostPanel:GetTall()*0.3),10)
			ghostPanel:SetPos( ScrW()/2-ghostPanel:GetWide()*1.6,ScrH()*2/3-ghostPanel:GetTall()/2 ) -- Position on the players screen
		end

		if plySWA then
			swatscore = plySWA:Deaths()
			swatclass = string.upper(player_manager.RunClass(plySWA,"ClassName"))
			swatgun = string.upper(plySWA:GetActiveWeapon().PrintName)
			swatPanel = vgui.Create( "SFrame" ) -- Creates the frame itself
			swatPanel:SetSize( wid,hgt ) -- Size of the frame
			swatPanel:SetTitle( "BEST SWAT: "..string.upper(plySWA:GetName()) ) -- Title of the frame
			swatPanel:SetVisible( true )

			local swatLabel = vgui.Create( "DLabel", swatPanel)
			swatLabel:SetColor(Color(255,255,255,255)) // Color
			swatLabel:SetFont("default")
			swatLabel:SetText("SCORE: "..swatscore.."\nBEST CLASS: "..swatclass.."\nBEST GUN: "..swatgun) // Text
			swatLabel:SizeToContents() // make the control the same size as the text
			swatLabel:Dock(TOP)

			local swatavatar		= vgui.Create( "AvatarImage", swatPanel )
			swatavatar:SetSize( 64,64 )
			swatavatar:SetPos( swatPanel:GetWide()-12-64, 22)
			swatavatar:SetPlayer( plySWA )

			swatPanel:DockPadding(3,21,0,2)
			swatPanel:SetPos( ScrW()/2+swatPanel:GetWide()*0.6,ScrH()*2/3-ghostPanel:GetTall()/2 ) -- Position on the players screen
		end
end


-- Hide the standard HUD stuff
local hud = {"CHudHealth", "CHudBattery", "CHudAmmo", "CHudSecondaryAmmo"}
function GM:HUDShouldDraw(name)
	for k, v in pairs(hud) do
		if name == v then return false end
	end

	return true
end

			--[[ Class data table.
			team = self.ClassTeam
			name = self.DisplayName
			model = self.Model
			desc = self.ClassDescription
			pros = self.ClassPros
			cons = self.ClassCons
			]]--


local classPanel = vgui.Create( "DFrame" )
classPanel:SetVisible( false )
function ClassInfo( ply, command, arguments )
	if scoreboardmode then return end
	local data = player_manager.RunClass( ply, "GetClassInfo" )
	if !data then return end
		print(data.tm)
		local wid,hgt
		local lifetime = 3 -- 2 seconds
		classPanel:Remove()
		local opened = CurTime()
		if data.tm == 1 then
			wid = 500
			hgt = 200
			classPanel = vgui.Create( "GFrame" ) -- Creates the frame itself
		elseif data.tm == 2 then
			wid = 400
			hgt = 200
			classPanel = vgui.Create( "SFrame" ) -- Creates the frame itself
		else
			wid = 500
			hgt = 200
			classPanel = vgui.Create( "GFrame" ) -- Creates the frame itself
		end
		classPanel:SetPos( ScrW()/2-wid/2,ScrH()/2+hgt/2 ) -- Position on the players screen
		classPanel:SetSize( wid,hgt ) -- Size of the frame
		classPanel:SetTitle( data.name ) -- Title of the frame
		classPanel:SetVisible( true )
		classPanel.Think = function()
			classPanel:SetAlpha(math.Clamp(-(math.abs(CurTime()-opened-lifetime)-lifetime)*1000,0,255))
			if scoreboardmode then
				classPanel:SetAlpha(0)
			end
		end

		if data.tm == 1 then
			classPanel:DockPadding(5+(classPanel:GetTall()*0.3),21,5+(classPanel:GetTall()*0.3),3)
		elseif data.tm == 2 then
			classPanel:DockPadding(4,21,0,2)
		else
			classPanel:DockPadding(0,10,0,2)
		end
		local icon = vgui.Create( "DModelPanel", classPanel )
		icon:SetModel( data.model )

		function icon:LayoutEntity( )

			self:RunAnimation()

		end
		if data.tm == 1 then
			icon:SetPos(255,5)
		elseif data.tm == 2 then
			icon:SetPos(205,5)
		else
			icon:SetPos(205,5)
		end
		icon:SetSize( 190, 190 )
		icon:SetCamPos( Vector( 30, 20, 65 ) )
		icon:SetLookAt( Vector( 0, 0, 65 ) )
		icon:SetFOV(40)
		icon.Think = function()
			local val = math.Clamp(-(math.abs(CurTime()-opened-lifetime)-lifetime)*1000,0,190)
			icon:SetSize( val, val )
			if data.tm == 1 then
				icon:SetPos(350-icon:GetWide()/2,100-icon:GetTall()/2)
			elseif data.tm == 2 then
				icon:SetPos(300-icon:GetWide()/2,100-icon:GetTall()/2)
			else
				icon:SetPos(300-icon:GetWide()/2,100-icon:GetTall()/2)
			end
			if scoreboardmode then
			icon:SetSize( 0,0 )
			end
		end

		local classDesc = vgui.Create( "DLabel", classPanel )
		classDesc:SetColor(Color(255,255,255,255)) // Color
		classDesc:SetFont("default")
		classDesc:SetText(data.desc) // Text
		classDesc:SizeToContents() // make the control the same size as the text
		classDesc:Dock(TOP)

		local protag = vgui.Create( "DLabel", classPanel)
		protag:SetColor(Color(255,255,255,255)) // Color
		protag:SetFont("default")
		protag:SetText("\nPros:") // Text
		protag:SizeToContents() // make the control the same size as the text
		protag:Dock(TOP)

		for k,v in pairs (data.pros) do
			local pro = vgui.Create( "DLabel", classPanel )
			pro:SetColor(Color(100,255,100,255)) // Color
			pro:SetFont("default")
			pro:SetText(v) // Text
			pro:SizeToContents() // make the control the same size as the text
			pro:Dock(TOP)
		end

		local contag = vgui.Create( "DLabel", classPanel)
		contag:SetColor(Color(255,255,255,255)) // Color
		contag:SetFont("default")
		contag:SetText("\nCons:") // Text
		contag:SizeToContents() // make the control the same size as the text
		contag:Dock(TOP)

		for k,v in pairs (data.cons) do
			local con = vgui.Create( "DLabel", classPanel )
			con:SetColor(Color(255,100,100,255)) // Color
			con:SetFont("default")
			con:SetText(v) // Text
			con:SizeToContents() // make the control the same size as the text
			con:Dock(TOP)
		end
end

function PunishMenu(player, command, args)
	local wid = 400
	local offset = 25
	local hgt = 200

	local punishPanel
	if player:Team() == TEAM_GHOST then
		punishPanel = vgui.Create( "GFrame" ) -- Creates the frame itself
		wid = 600
		offset = 70
	else
		punishPanel = vgui.Create( "SFrame" ) -- Creates the frame itself
	end
	punishPanel:SetPos( ScrW()/2-wid/2,ScrH()/2 ) -- Position on the players screen
	punishPanel:SetSize( wid,hgt ) -- Size of the frame
	punishPanel:SetTitle( "PUNISHMENT PANEL" ) -- Title of the frame
	punishPanel:SetVisible( true )
	--punishPanel:SetDraggable( false ) -- Draggable by mouse?
	--punishPanel:ShowCloseButton( true ) -- Show the close button?
	punishPanel:MakePopup() -- Show the close button?


	--First button combo
	local info = vgui.Create("DLabel", punishPanel)
	info:SetPos( offset,0 )
	info:SetSize( wid-offset,150 )
	--make sure we grab the punished players name.
	info:SetColor(Color(255,255,255,255)) // Color
	info:SetFont("default")
	if args[1] then
		info:SetText(string.upper(args[1].." has teamkilled you!\nDo you wish to punish him for his teamkill?\n\nPLEASE NOTE:\nWhen a player is punished, they will sit out a round.\nYou shouldn't punish someone unless\nyou believe they purposefully teamkilled you!"))
	end

	local punish = vgui.Create("DButton", punishPanel)
	punish:SetPos( offset+15,150 )
	punish:SetSize( 80, 30 )
	punish:SetText("PUNISH")

	punish.OnMousePressed = function()
		player:ConCommand("ep_punish")
		punishPanel:Remove()
	end

	local forgive = vgui.Create("DButton", punishPanel)
	forgive:SetPos( wid-offset-80-15,150 )
	forgive:SetSize( 80, 30 )
	forgive:SetText("FORGIVE")

	forgive.OnMousePressed = function()
		punishPanel:Remove()
	end
end

local hackcolors = {}
local red = Color(200,50,50,200)
local grn = Color(50,200,50,200)
local blu = Color(50,50,200,200)
local ylw = Color(200,200,50,200)
local wht = Color(255,255,255,200)
hackcolors[1] = blu
hackcolors[2] = ylw
hackcolors[3] = grn
hackcolors[4] = red


function makeButton(color,label,parent,x,y,val)
	local button = vgui.Create("DButton", parent)
	button:SetPos( x,y )
	button:SetSize( 30, 30 )
	button:SetText("")
	button.Color = color

	button.OnMouseReleased = function()
		button.Color = color
	end
	button.OnCursorExited = function()
		button.Color = color
	end
	button.Paint = function() -- The paint function
		draw.RoundedBox( 4, 0, 0, button:GetWide(), button:GetTall(), Color(0,0,0,255))
		draw.RoundedBox( 4, 1, 1, button:GetWide()-2, button:GetTall()-2, button.Color)
	end
	return button
end

local num1 = 1
local num2 = 1
local num3 = 1
local num4 = 1

function HackPanel(player, command, args)
	if scoreboardmode then return end
	local wid = 260
	local hgt = 200

	local hackPanel = vgui.Create( "DFrame" ) -- Creates the frame itself
	hackPanel:SetPos( ScrW()/2-wid/2,ScrH()/2-hgt/2 ) -- Position on the players screen
	hackPanel:SetSize( wid,hgt ) -- Size of the frame
	hackPanel:SetTitle( "Hack Panel" ) -- Title of the frame
	hackPanel:SetVisible( true )
	hackPanel:SetDraggable( true ) -- Draggable by mouse?
	hackPanel:ShowCloseButton( true ) -- Show the close button?
	hackPanel:MakePopup() -- Show the close button?
	hackPanel.Paint = function()
		draw.RoundedBox( 8, 0, 0, hackPanel:GetWide(), hackPanel:GetTall(), Color( 0, 0, 0, 100 ) )
	end

	--THIS IS REALLY ANNOYING TO TWEAK, BUT I DONT REALLY KNOW HOW TO DO IT ANY BETTER
	--SO FUCK.


	--First button combo
	local color1 = vgui.Create("DLabel", hackPanel)
	color1:SetPos( 25,105 )
	color1:SetSize( 30, 30 )
	color1.Color = blu
	color1:SetText("")
	color1.Paint = function() -- The paint function
		draw.RoundedBox( 4, 0, 0, color1:GetWide(), color1:GetTall(), Color(0,0,0,255))
		draw.RoundedBox( 4, 1, 1, color1:GetWide()-2, color1:GetTall()-2, hackcolors[num1])
	end

	local color1blu = makeButton(blu,color1,hackPanel,10,30,1)
	color1blu.OnMousePressed = function()
		color1blu.Color = wht -- give the variable this green colour, because the Paint function is updated every frame, the button will change to green
		num1 = 1
		color1.Color = blu
	end
	local color1ylw = makeButton(ylw,color1,hackPanel,40,30,1)
	color1ylw.OnMousePressed = function()
		color1ylw.Color = wht -- give the variable this green colour, because the Paint function is updated every frame, the button will change to green
		num1 = 2
		color1.Color = ylw
	end
	local color1grn = makeButton(grn,color1,hackPanel,10,60,1)
	color1grn.OnMousePressed = function()
		color1grn.Color = wht -- give the variable this green colour, because the Paint function is updated every frame, the button will change to green
		num1 = 3
		color1.Color = grn
	end
	local color1red = makeButton(red,color1,hackPanel,40,60,1)
	color1red.OnMousePressed = function()
		color1red.Color = wht -- give the variable this green colour, because the Paint function is updated every frame, the button will change to green
		num1 = 4
		color1.Color = red
	end


	--Second button combo
	local color2 = vgui.Create("DLabel", hackPanel)
	color2:SetPos( 85,105 )
	color2:SetSize( 30, 30 )
	color2.Color = blu
	color2:SetText("")
	color2.Paint = function() -- The paint function
		draw.RoundedBox( 4, 0, 0, color2:GetWide(), color2:GetTall(), Color(0,0,0,255))
		draw.RoundedBox( 4, 1, 1, color2:GetWide()-2, color2:GetTall()-2, hackcolors[num2])
	end

	local color2blu = makeButton(blu,color2,hackPanel,70,30,1)
	color2blu.OnMousePressed = function()
		color2blu.Color = wht -- give the variable this green colour, because the Paint function is updated every frame, the button will change to green
		num2 = 1
		color2.Color = blu
	end
	local color2ylw = makeButton(ylw,color2,hackPanel,100,30,1)
	color2ylw.OnMousePressed = function()
		color2ylw.Color = wht -- give the variable this green colour, because the Paint function is updated every frame, the button will change to green
		num2 = 2
		color2.Color = ylw
	end
	local color2grn = makeButton(grn,color2,hackPanel,70,60,1)
	color2grn.OnMousePressed = function()
		color2grn.Color = wht -- give the variable this green colour, because the Paint function is updated every frame, the button will change to green
		num2 = 3
		color2.Color = grn
	end
	local color2red = makeButton(red,color2,hackPanel,100,60,1)
	color2red.OnMousePressed = function()
		color2red.Color = wht -- give the variable this green colour, because the Paint function is updated every frame, the button will change to green
		num2 = 4
		color2.Color = red
	end

	--THIRD BUTTON COMBO ARGH KILL ME
	local color3 = vgui.Create("DLabel", hackPanel)
	color3:SetPos( 145,105 )
	color3:SetSize( 30, 30 )
	color3.Color = blu
	color3:SetText("")
	color3.Paint = function() -- The paint function
		draw.RoundedBox( 4, 0, 0, color3:GetWide(), color3:GetTall(), Color(0,0,0,255))
		draw.RoundedBox( 4, 1, 1, color3:GetWide()-2, color3:GetTall()-2, hackcolors[num3])
	end

	local color3blu = makeButton(blu,color3,hackPanel,130,30,1)
	color3blu.OnMousePressed = function()
		color3blu.Color = wht -- give the variable this green colour, because the Paint function is updated every frame, the button will change to green
		num3 = 1
		color3.Color = blu
	end
	local color3ylw = makeButton(ylw,color3,hackPanel,160,30,1)
	color3ylw.OnMousePressed = function()
		color3ylw.Color = wht -- give the variable this green colour, because the Paint function is updated every frame, the button will change to green
		num3 = 2
		color3.Color = ylw
	end
	local color3grn = makeButton(grn,color3,hackPanel,130,60,1)
	color3grn.OnMousePressed = function()
		color3grn.Color = wht -- give the variable this green colour, because the Paint function is updated every frame, the button will change to green
		num3 = 3
		color3.Color = grn
	end
	local color3red = makeButton(red,color3,hackPanel,160,60,1)
	color3red.OnMousePressed = function()
		color3red.Color = wht -- give the variable this green colour, because the Paint function is updated every frame, the button will change to green
		num3 = 4
		color3.Color = red
	end

	--Final buttons. Thank fuck. Even with the automated function this is tedious as fuck.
	--Never hire me to do GUI.
	local color4 = vgui.Create("DLabel", hackPanel)
	color4:SetPos( 205,105 )
	color4:SetSize( 30, 30 )
	color4.Color = blu
	color4:SetText("")
	color4.Paint = function() -- The paint function
		draw.RoundedBox( 4, 0, 0, color4:GetWide(), color4:GetTall(), Color(0,0,0,255))
		draw.RoundedBox( 4, 1, 1, color4:GetWide()-2, color4:GetTall()-2, hackcolors[num4])
	end
	local color4blu = makeButton(blu,color4,hackPanel,190,30,1)
	color4blu.OnMousePressed = function()
		color4blu.Color = wht -- give the variable this green colour, because the Paint function is updated every frame, the button will change to green
		num4 = 1
		color4.Color = blu
	end
	local color4ylw = makeButton(ylw,color4,hackPanel,220,30,1)
	color4ylw.OnMousePressed = function()
		color4ylw.Color = wht -- give the variable this green colour, because the Paint function is updated every frame, the button will change to green
		num4 = 2
		color4.Color = ylw
	end
	local color4grn = makeButton(grn,color4,hackPanel,190,60,1)
	color4grn.OnMousePressed = function()
		color4grn.Color = wht -- give the variable this green colour, because the Paint function is updated every frame, the button will change to green
		num4 = 3
		color4.Color = grn
	end
	local color4red = makeButton(red,color4,hackPanel,220,60,1)
	color4red.OnMousePressed = function()
		color4red.Color = wht -- give the variable this green colour, because the Paint function is updated every frame, the button will change to green
		num4 = 4
		color4.Color = red
	end

	local button = vgui.Create("DButton", hackPanel)
	button:SetPos( wid/2-40,hgt-50 )
	button:SetSize( 80, 20 )
	button:SetText("TEST")
	button.Color = wht
	--button:Center()

	button.OnMousePressed = function()
		RunConsoleCommand("ep_hack", num1,num2,num3,num4);
		hackPanel:Remove()
	end
	button.OnMouseReleased = function()
		button.Color = wht
	end
	button.OnCursorExited = function()
		button.Color = wht
	end
	button.Paint = function() -- The paint function
		draw.RoundedBox( 4, 0, 0, button:GetWide(), button:GetTall(), Color(0,0,0,255))
		draw.RoundedBox( 4, 1, 1, button:GetWide()-2, button:GetTall()-2, button.Color)
	end

	if args[1] then
		local color4 = vgui.Create("DLabel", hackPanel)
		color4:SetPos( wid/2-40,hgt-30 )
		color4:SetText("Correct Colors: "..args[1])
		color4:SizeToContents()
	end

end

function ClearBuffer()
	num1 = 1
	num2 = 1
	num3 = 1
	num4 = 1
end


local hintPanel = vgui.Create( "DFrame" )
hintPanel:SetVisible( false )
function ShowHint(player, cmd, args)
	if scoreboardmode then return end
		local wid = 600
		local hgt = 24
		local opened = CurTime()
		hintPanel:Remove()
		if player:Team() == TEAM_GHOST then
			hintPanel = vgui.Create( "GFrame" ) -- Creates the frame itself
		elseif player:Team() == TEAM_SWAT then
			hintPanel = vgui.Create( "SFrame" ) -- Creates the frame itself
		else
			hintPanel = vgui.Create( "DFrame" ) -- Creates the frame itself
		end
		hintPanel:SetPos( ScrW()/2-wid/2,ScrH()/4 ) -- Position on the players screen
		hintPanel:SetSize( wid,hgt ) -- Size of the frame
		hintPanel:SetTitle( "PROTIP!" ) -- Title of the frame
		hintPanel:SetVisible( true )
		hintPanel.Think = function()
			local lifetime = 6 -- 10 seconds
			hintPanel:SetAlpha(math.Clamp(-(math.abs(CurTime()-opened-lifetime)-lifetime)*1000,0,255))
		end

		local hintText = vgui.Create( "DLabel", hintPanel )
		hintText:SetColor(Color(255,255,255,255)) // Color
		hintText:SetFont("default")
		hintText:SetText(string.upper(table.Random(tips))) // Text
		--hintText:SetWrap(true)
		hintText:SetWidth(600)
		hintText:SetContentAlignment(1)
		hintText:SizeToContentsY() // make the control the same size as the text
		hintText:Center()
		hintText:Dock(TOP)

		hintPanel:SetSize( hintText:GetWide(),hgt+hintText:GetTall() ) -- Size of the frame

		if player:Team() == TEAM_GHOST then
			hintPanel:DockPadding(5+(hintPanel:GetTall()*0.3),21,5+(hintPanel:GetTall()*0.3),3)
		elseif player:Team() == TEAM_SWAT then
			hintPanel:DockPadding(20,21,0,2)
		else
			hintPanel:DockPadding(0,10,0,2)
		end
		hintPanel:CenterHorizontal()

end

local timePanel = vgui.Create( "DFrame" )
timePanel:SetVisible( false )
function ShowTimer(player, cmd, args)
	if scoreboardmode then return end
		local wid = 180
		local hgt = 50
		local opened = CurTime()
		timePanel:Remove()
		if player:Team() == TEAM_GHOST then
			timePanel = vgui.Create( "GFrame" ) -- Creates the frame itself
		elseif player:Team() == TEAM_SWAT then
			timePanel = vgui.Create( "SFrame" ) -- Creates the frame itself
		else
			timePanel = vgui.Create( "DFrame" ) -- Creates the frame itself
		end
		timePanel:SetPos( ScrW()/2-wid/2,ScrH()-ScrH()/32-hgt ) -- Position on the players screen
		timePanel:SetSize( wid,hgt ) -- Size of the frame
		timePanel:SetTitle( "ROUND TIMER" ) -- Title of the frame
		timePanel:SetVisible( true )

		local timeText = vgui.Create( "DLabel", timePanel )
		timeText:SetColor(Color(255,255,255,255)) // Color
		timeText:SetFont("EPText")
		local rndtime = args[1]
		--rndtime = math.Clamp(rndtime,0,10000000)
		if tonumber(rndtime) < 0 then
			rndtime = 0
		end
		local minutes = math.floor(rndtime/60)
		local seconds = math.mod(rndtime,60)
		local counter = string.format("%02i:%02i",minutes,seconds)
		timeText:SetText(counter) // Text
		timeText:SizeToContents() // make the control the same size as the text
		timeText:SetPos( 25, 25) -- Position on the players screen
		--timeText:CenterHorizontal()

		local roundText = vgui.Create( "DLabel", timePanel )
		roundText:SetColor(Color(255,255,255,255)) // Color
		roundText:SetFont("EPText")
		local roundcounter = string.format("%02i/16",args[2])
		roundText:SetText(roundcounter) // Text
		roundText:SizeToContents() // make the control the same size as the text
		roundText:SetPos( timePanel:GetWide()-roundText:GetWide()-25, 25) -- Position on the players screen
		--roundText:CenterHorizontal()

		timePanel:CenterHorizontal()

end
local wepPanel = vgui.Create( "DFrame" )
wepPanel:SetVisible( false )

function WeaponInfo(player, cmd, args)
	if scoreboardmode then return end
	local gun = player:GetActiveWeapon()
	if !gun or !gun:IsValid() then return end
	if !gun.GetWeaponInfo then return end
	local data = gun:GetWeaponInfo()
		--[[data = {
		name = self.PrintName,
		desc = self.WeaponDesc,
		pri = self.PrimaryInstruction,
		sec = self.SecondaryInstruction
		}]]--
	if !data then return end
		local opened = CurTime()
		wid = 300
		hgt = 40
		wepPanel:Remove()
		if player:Team() == TEAM_GHOST then
			wepPanel = vgui.Create( "GFrame" ) -- Creates the frame itself
			wid = 390
			hgt = 40
		elseif player:Team() == TEAM_SWAT then
			wepPanel = vgui.Create( "SFrame" ) -- Creates the frame itself
		else
			wepPanel = vgui.Create( "DFrame" ) -- Creates the frame itself
		end
		wepPanel:SetSize( wid,hgt ) -- Size of the frame
		wepPanel:SetTitle( string.upper(data.name) ) -- Title of the frame
		wepPanel:SetVisible( true )
		wepPanel.Think = function()
			local lifetime = 1 -- 10 seconds
			wepPanel:SetAlpha(math.Clamp(-(math.abs(CurTime()-opened-lifetime)-lifetime)*1000,0,255))
		end

		local icon = vgui.Create( "DModelPanel", wepPanel )
		icon:SetModel( data.model )

		icon:SetSize( 200, 100 )
		local position = data.campos or Vector(70,40,10)
		icon:SetCamPos( position )
		local look = data.lookpos or Vector(10,0,0)
		icon:SetLookAt( look )
		icon:SetFOV(30)
		function icon:LayoutEntity( )

			self:RunAnimation()

		end
		icon.Think = function()
			local lifetime = 1 -- 10 seconds
			local val = math.Clamp(-(math.abs(CurTime()-opened-lifetime)-lifetime)*1000,0,200)
			icon:SetSize( val, val/2 )
			icon:SetSize( val, val/2 )
			if player:Team() == TEAM_GHOST then
				icon:SetPos(265-icon:GetWide()/2,65-icon:GetTall()/2)
			elseif player:Team() == TEAM_SWAT then
				icon:SetPos(225-icon:GetWide()/2,65-icon:GetTall()/2)
			else
				icon:SetPos(225-icon:GetWide()/2,65-icon:GetTall()/2)
			end
		end

		local wepDesc = vgui.Create( "DLabel", wepPanel )
		wepDesc:SetColor(Color(255,255,255,255)) // Color
		wepDesc:SetFont("default")
		wepDesc:SetText(string.upper(data.desc)) // Text
		wepDesc:SizeToContents() // make the control the same size as the text
		wepDesc:Dock(TOP)

		local priLabel = vgui.Create( "DLabel", wepPanel)
		priLabel:SetColor(Color(255,255,255,255)) // Color
		priLabel:SetFont("default")
		priLabel:SetText("\nPrimary:") // Text
		priLabel:SizeToContents() // make the control the same size as the text
		priLabel:Dock(TOP)

		local priDesc = vgui.Create( "DLabel", wepPanel )
		priDesc:SetColor(Color(100,255,100,255)) // Color
		priDesc:SetFont("default")
		priDesc:SetText(string.upper(data.pri)) // Text
		priDesc:SizeToContents() // make the control the same size as the text
		priDesc:Dock(TOP)

		local secLabel = vgui.Create( "DLabel", wepPanel)
		secLabel:SetColor(Color(255,255,255,255)) // Color
		secLabel:SetFont("default")
		secLabel:SetText("\nSecondary:") // Text
		secLabel:SizeToContents() // make the control the same size as the text
		secLabel:Dock(TOP)

		local secDesc = vgui.Create( "DLabel", wepPanel )
		secDesc:SetColor(Color(100,255,100,255)) // Color
		secDesc:SetFont("default")
		secDesc:SetText(string.upper(data.sec)) // Text
		secDesc:SizeToContents() // make the control the same size as the text
		secDesc:Dock(TOP)

		wepPanel:SizeToContentsY()
		wepPanel:SetSize( wepPanel:GetWide(),hgt+wepDesc:GetTall()+priLabel:GetTall()+priDesc:GetTall()+secLabel:GetTall()+secDesc:GetTall() ) -- Size of the frame
		if player:Team() == TEAM_GHOST then
			wepPanel:DockPadding(-5+(wepPanel:GetTall()*0.3),21,5+(wepPanel:GetTall()*0.3),10)
		else
			wepPanel:DockPadding(3,21,0,2)
		end
		wepPanel:SetPos( ScrW()/2+wepPanel:GetWide()/2,ScrH()/2-wepPanel:GetTall()/2 ) -- Position on the players screen


end

local msgs = {}

function Popup(player, cmd, args)
	if !(args[1] and args[2]) then return end
	local mesgpos = Vector(0,0,0)
	local tr = LocalPlayer():GetEyeTrace()
	local pos = tr.HitPos
	local offset = tr.HitNormal*50
	local maxdist = math.Rand(150,300)
	if (tr.HitPos-tr.StartPos):Length() > maxdist then
		mesgpos = LocalPlayer():GetShootPos()+LocalPlayer():GetForward()*maxdist
	else
		mesgpos = pos + offset
	end
	local aimdir = LocalPlayer():EyeAngles():Forward()
	local randangle = math.Rand(0,360)
	mesgpos = mesgpos + VectorRand()*50 + Vector(0,0,15)
	table.insert(msgs,
	{	txt = args[1],
		pos = mesgpos,
		life = CurTime()+5,
		scale = args[2]}
	)
end

function popup_draw()
	for k,v in pairs (msgs) do
		local mesgpos = v.pos + Vector(0,0,(v.life- CurTime())*-5)
		local tr = LocalPlayer():GetEyeTrace()
		--local angles = tr.HitNormal:Angle()
		local angles = Angle(0,0,0)
		local offset = tr.HitNormal*100
		angles.y = LocalPlayer():GetAngles().y-90
		angles.r = 90
		angles.r = 90-LocalPlayer():GetAngles().p
		cam.IgnoreZ(true)
		cam.Start3D2D(mesgpos, angles, math.Clamp(v.scale/200,0.2,0.4))
			if LocalPlayer():Team() == TEAM_GHOST then
				draw.SimpleTextOutlined(v.txt, "EPAmmo", 0,0, Color(250, 190, 80, (v.life- CurTime())*200), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, Color(0,0,0, (v.life- CurTime())*200))
				draw.SimpleTextOutlined("+"..v.scale, "EPAmmo", 0,30, Color(250, 190, 80, (v.life- CurTime())*200), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, Color(0,0,0, (v.life- CurTime())*200))
			else
				draw.SimpleTextOutlined(v.txt, "EPAmmo", 0,0, Color(200,200,250, (v.life- CurTime())*200), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, Color(0,0,0, (v.life- CurTime())*200))
				draw.SimpleTextOutlined("+"..v.scale, "EPAmmo", 0,30, Color(200,200,250, (v.life- CurTime())*200), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, Color(0,0,0, (v.life- CurTime())*200))
			end
			--draw.SimpleText("KILLED THE RELAY CARRIER - 30 POINTS", "EPText", 0, 0, Color(255, 255, 255, (mesglife- CurTime())*255), 1, 1);
		cam.End3D2D();
		cam.IgnoreZ(false)
		if v.life < CurTime() then table.remove(msgs,k) end
	end
end
hook.Add("PostDrawTranslucentRenderables", "popup_draw", popup_draw)

function ShowHelp(player, command, args)
	local wid = 400
	local offset = 25
	local hgt = 300

	local helpPanel
	if player:Team() == TEAM_GHOST then
		helpPanel = vgui.Create( "GFrame" ) -- Creates the frame itself
		wid = 600
		offset = 100
	else
		helpPanel = vgui.Create( "SFrame" ) -- Creates the frame itself
	end
	helpPanel:SetPos( ScrW()/2-wid/2,ScrH()/2-hgt/2 ) -- Position on the players screen
	helpPanel:SetSize( wid,hgt ) -- Size of the frame
	helpPanel:SetTitle( "HELP" ) -- Title of the frame
	helpPanel:SetVisible( true )
	--punishPanel:SetDraggable( false ) -- Draggable by mouse?
	--punishPanel:ShowCloseButton( true ) -- Show the close button?
	helpPanel:MakePopup() -- Show the close button?


	--First button combo
	local info = vgui.Create("DLabel", helpPanel)
	info:SetPos( offset,20 )
	info:SetSize( wid-offset,200 )
	--make sure we grab the punished players name.
	info:SetColor(Color(255,255,255,255)) // Color
	info:SetFont("default")
	info:SetText(string.upper("Welcome to Extraction Point!\n\nExtraction Point is a competitive team based gamemode\nThere are two teams, the SWAT and Ghosts\nDefeating the enemy team will win the round\nThere are also objectives (displayed top left) depending on the map\n\nYou will spawn as a random team with a random class\nand random weapons\nSo you need to work out how to best use your gear!\n\nPay attention to your classes perks and downsides\nStick with your team\nand be careful of friendly fire!\nHappy fragging!"))


	local spectate = vgui.Create("DButton", helpPanel)
	spectate:SetPos( wid/2-40,hgt-40 )
	spectate:SetSize( 80, 30 )
	spectate:SetText("SPECTATE!")

	spectate.OnMousePressed = function()
		player:ConCommand("ep_optout")
		helpPanel:Remove()
	end

	local optin = vgui.Create("DButton", helpPanel)
	optin:SetPos(  wid/2-40-100,hgt-40 )
	optin:SetSize( 80, 30 )
	optin:SetText("JOIN IN!")

	optin.OnMousePressed = function()
		player:ConCommand("ep_optin")
		helpPanel:Remove()
	end

	local closehelp = vgui.Create("DButton", helpPanel)
	closehelp:SetPos( wid/2-40+100,hgt-40 )
	closehelp:SetSize( 80, 30 )
	closehelp:SetText("CLOSE")

	closehelp.OnMousePressed = function()
		helpPanel:Remove()
	end

end
function CloakFix(player, command, args)
	mdl = player:GetViewModel()
	if mdl:IsValid() then
		mdl:SetMaterial("")
	end
end

concommand.Add( "ep_classinfo", ClassInfo )
concommand.Add( "ep_hackpanel", HackPanel )
concommand.Add( "ep_punishmenu", PunishMenu)
concommand.Add( "ep_clearhackbuffer", ClearBuffer )
concommand.Add( "ep_hint", ShowHint )
concommand.Add( "ep_roundtimer", ShowTimer)
concommand.Add( "ep_weaponinfo", WeaponInfo)
concommand.Add( "ep_finalscoreboard", FinalScoreBoard)
concommand.Add( "ep_popup", Popup)
concommand.Add( "ep_showhelp", ShowHelp)
concommand.Add( "ep_cloakfix", CloakFix )
