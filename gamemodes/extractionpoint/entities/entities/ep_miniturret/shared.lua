ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName		= "G.H.O.S.T Defence Shield"
ENT.Author			= "Cooldown Studios"
ENT.Contact			= "NA"
ENT.Purpose			= "Used to block choke points and defend the Ghost"
ENT.Instructions	= "Use the GDS to place the shield down"

ENT.Bounces			= true

ENT.Target = nil
ENT.PingTimer = 1
ENT.TurnSpeed = 1
ENT.Range = 3000
ENT.Active = false
ENT.Burst = 10

function ENT:Initialize()
 
		
	size = 30
	
	self:SetModel("models/combine_helicopter/helicopter_bomb01.mdl")
	
	self:SetModelScale(0.2,0)
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
	--self:PhysicsInitSphere( size/2, "metal_bouncy" )
	--self:SetCollisionBounds( Vector( -size, -size, -size ), Vector( size, size, size ) )
	--self:PhysWake()
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:EnableGravity(true)
		phys:EnableDrag(false)
		phys:AddGameFlag(1024)
		phys:AddGameFlag(32768)
	end
	self:SetLife(200)
	self:SetDead(false)
	
	if SERVER then
		util.SpriteTrail(self, 0, Color(255,200,100), true, 8, 0, 0.2, 1/5*0.5, "trails/laser.vmt");
	end
end

local function RemoveEntity(ent)
	if (ent:IsValid() and SERVER) then
		ent:Remove()
	end
end

function ENT:Use( activator, caller )

end

function ENT:SetBounces(bool)
	self.Bounces = bool
	if bool then
		self:SetLife(1)
	end
end


function ENT:PhysicsCollide( data, physobj )
	if data.HitEntity:IsValid() then
		--self:Explode(45,50)
		return false
	else
		--create out impact thingo
		local dartpos = data.HitPos
		if SERVER then
			self:EmitSound("weapons/crossbow/hit2.wav", 100, 100)
			self:EmitSound("NPC_RollerMine.Taunt", 100, 100)
			
		end

		--remove it
		self:SetLocalVelocity(Vector(0,0,0))
		self:SetPos(dartpos+data.HitNormal*-2)
		self:SetMoveType(MOVETYPE_NONE) 
		self.Active = true
	end
end

function ENT:Explode(dam,radius) --30, 120 by default
	if SERVER then
		if (!self:GetDead()) then
		self:EmitSound("weapons/explode3.wav", 100,math.Rand(150,180))
		self:EmitSound("npc/strider/strider_step1.wav", 100,math.Rand(110,120))
			-- Remove it properly in 1 second
			self:SetDead(true)
			timer.Simple( 1, function() RemoveEntity(self) end )
			
			-- Make it non solid
			self:SetNotSolid(true)
			self:SetNoDraw(true)
			self:SetLocalVelocity(Vector(0,0,0))
			self:SetMoveType(MOVETYPE_NONE)
			-- Send Effect
			local ed = EffectData()
				ed:SetEntity(self)
				ed:SetOrigin(self:GetPos())
			util.Effect( "shell_explode", ed, true, true )			
			local targets = ents.FindInSphere(self:GetPos(),radius)
			for k,v in pairs(targets) do
				if v:IsValid() then
					if SERVER then
						local trace1 = {start = self:GetPos(), endpos = v:GetPos(), mask = MASK_SHOT}
						local traceRes1 = util.TraceLine(trace1)
						
						local vecPos, ang = v:GetBonePosition(v:LookupBone("ValveBiped.Bip01_Head1") or 12)
						local trace2 = {start = self:GetPos(), endpos = vecPos, mask = MASK_SHOT}
						local traceRes2 = util.TraceLine(trace2)
						
						if (traceRes1.Entity == v or traceRes2.Entity == v) then 
							v:TakeDamage( dam, self.Entity:GetOwner(), self.Entity:GetOwner() )
						end
					end
				end
			end
		end
	end
end

function ENT:OnTakeDamage(dmg)
	if dmg:GetAttacker():IsValid() then
		local activator = dmg:GetAttacker()
		if activator:Team() == TEAM_SWAT then
			if !self:GetDead() then
				player_manager.RunClass(activator,"AddPoints",15,"Destroyed a Turret")
			end
		end
	end
	self.Active = false
	self:Explode(25,220)
end

function ENT:Think()
	if SERVER then
		if (self:GetLife() <= 0) then
			self:Explode(25,220)
			self.Active = false
		end
	end
	if self.Active then
		--Do a check for nearby players.
		if self.PingTimer < 0 then
			self.PingTimer = self.PingTimer + 1
			local closest = self.Range
			self.Target = nil
			for k,v in pairs (player.GetAll()) do
				if v:Alive() then
					local dist = (self:GetPos() - v:GetPos()):Length()
					if self.Target != nil && self.Target:IsValid() then
						if self.Target:Team() != TEAM_SWAT && dist < self.Range && v:Team() == TEAM_GHOST then
							self.Target = v
						end
						if self.Target:Team() == TEAM_GHOST && v:Team() == TEAM_SWAT && dist < self.Range then
							local tr = util.TraceLine( {
								start = self:GetPos()+self:GetUp()*5,
								endpos = v:GetPos()+Vector(0,0,30),
								filter = function( ent ) if ( ent:IsPlayer() ) then return true end end
							} )
							if tr.Entity == v then
								self.Target = v
								closest = dist
							end
						end
						if self.Target:Team() == TEAM_SWAT && v:Team() == TEAM_SWAT && dist < closest then
							local tr = util.TraceLine( {
								start = self:GetPos()+self:GetUp()*5,
								endpos = v:GetPos()+Vector(0,0,30),
								filter = function( ent ) if ( ent:IsPlayer() ) then return true end end
							} )
							if tr.Entity == v then
								self.Target = v
								closest = dist
							end
						end
					else
						if v:Team() == TEAM_SWAT && dist < self.Range then
							local tr = util.TraceLine( {
								start = self:GetPos()+self:GetUp()*5,
								endpos = v:GetPos()+Vector(0,0,30),
								filter = function( ent ) if ( ent:IsPlayer() ) then return true end end
							} )
							if tr.Entity == v then
								self.Target = v
								closest = dist
							end
						end
						if v:Team() == TEAM_GHOST then
							self.Target = v
							closest = dist
						end
					end
				end
			end
			if self.Target != nil && self.Target:IsValid() then
				if self.Target:Team() == TEAM_SWAT then
					self:EmitSound("NPC_RollerMine.Held", 100, 100)
				elseif self.Target:Team() == TEAM_GHOST then
					self:EmitSound("NPC_RollerMine.Warn", 100, 100)
				end
			else
				self:EmitSound("NPC_RollerMine.Chirp", 100, 100)
			end
		end
		if self.Target != nil && self.Target:IsValid() then
			local offset = self.Target:GetPos()+Vector(0,0,40) - self:GetPos()
			if SERVER then
				if self.Burst > 0 && self.Target:Team() == TEAM_SWAT then
					self:SetAngles(LerpAngle(.3,self:GetAngles(),offset:Angle()+Angle(90,0,0)))
					local tr = util.TraceLine( {
						start = self:GetPos(),
						endpos = self.Target:GetPos()+Vector(0,0,30),
						filter = function( ent ) if ( ent:IsPlayer() ) then return true end end
					} )
					if tr.Entity:IsPlayer() then
						self:SetLife(self:GetLife() - 1)
						
						local bullet = {}
						bullet.Num    = numbul
						   
						bullet.Attacker = self.Owner
						bullet.Src    = self:GetPos()+self:GetUp()*5
						bullet.Dir    = self:GetUp()
						bullet.Spread = Vector( 0.02, 0.02, 0 )
						bullet.Tracer = 1
						bullet.TracerName = "AR2Tracer"
						bullet.Force  = 1
						bullet.Damage = 8
						self:FireBullets( bullet )
						self:EmitSound("Weapon_Pistol.NPC_Single", 100, 100)
						self.Burst = self.Burst -1
						local effectdata = EffectData()
						effectdata:SetOrigin( bullet.Src )
						effectdata:SetAngles( self:GetUp():Angle())
						effectdata:SetNormal( self:GetUp())
						util.Effect( "AR2Impact", effectdata )
					end
				else
					self:SetAngles(LerpAngle(.1,self:GetAngles(),AngleRand()))
				end
			end
			
			if !self.Target:Alive() then
				self.Target = nil
			end
		end
	end
	if self.Burst <= 0 then
		self.Burst = 10
		self:NextThink(CurTime()+1.3)
		self.PingTimer = self.PingTimer - 1.3
		self:EmitSound("Weapon_StunStick.Deactivate", 100, 100)

	else
		self:NextThink(CurTime()+0.08)
		self.PingTimer = self.PingTimer - 0.08
	end
	return true
end

function ENT:GetEmitter( Pos, b3D ) 
	if ( self.Emitter ) then	 
		if ( self.EmitterIs3D == b3D && self.EmitterTime > CurTime() ) then 
			return self.Emitter 
		end 
		end 
	self.Emitter = ParticleEmitter( Pos, b3D ) 
	self.EmitterIs3D = b3D 
	self.EmitterTime = CurTime() + 2 
	return self.Emitter 
end  
	
function ENT:Touch(ent)

end

function ENT:Draw()
	
end

function ENT:Pickup()
end

function ENT:Drop()
end

function ENT:SetupDataTables()
	self:NetworkVar( "Int", 0, "Life" );
	self:NetworkVar( "Bool", 0, "Dead" );
end

function ENT:OwnerDie()
end
