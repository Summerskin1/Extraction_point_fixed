ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName		= "G.H.O.S.T Defence Shield"
ENT.Author			= "Cooldown Studios"
ENT.Contact			= "NA"
ENT.Purpose			= "Used to block choke points and defend the Ghost"
ENT.Instructions	= "Use the GDS to place the shield down"

function ENT:OnTakeDamage()
	self:SetLife(0)
end

function ENT:Initialize()

	self.Glow		= Material( "sprites/light_glow02_add" )

	self:SetModel("models/combine_helicopter/helicopter_bomb01.mdl")

	--self:SetModelScale(0.2,0)
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox

	self:SetElasticity(40)

	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:EnableGravity(false)
		phys:EnableDrag(true)
	end

	self:SetLife(6)
	self:SetDead(false)
	self:EmitSound("ep/railgun_fire_charge.wav", 80,math.Rand(120,140))

	local ed = EffectData()
	ed:SetEntity(self.Entity)
	ed:SetOrigin(self.Entity:GetPos())
	ed:SetScale( 1 )
	util.Effect( "pulse_core", ed, true, true )

	if SERVER then
		util.SpriteTrail(self, 0, Color(255,155,100), false, 4, 1, 0.2, 1/5*0.5, "trails/physbeam.vmt");
		self.nextPing = CurTime()+0.2
	end
end

local function RemoveEntity(ent)
	if (ent:IsValid() and SERVER) then
		ent:Remove()
	end
end

function ENT:Think()
	if SERVER then
		if (self:GetLife() <= 0 and !self:GetDead()) then
			-- Remove it properly in 1 second
			self:SetDead(true)
			RemoveEntity(self)
			-- Make it non solid
			self:SetNotSolid(true)
			self:SetNoDraw(true)
			--self:SetLocalVelocity(Vector(0,0,0))
			self:SetMoveType(MOVETYPE_NONE)
			-- Send Effect
			local ed = EffectData()
			ed:SetEntity(self.Entity)
			ed:SetOrigin(self.Entity:GetPos())
			ed:SetScale( 1 )
			util.Effect( "pulse_core_explode", ed, true, true )
			--self:EmitSound("weapons/explode4.wav", 80,math.Rand(120,140))
			self:EmitSound("weapons/explode5.wav", 140,math.Rand(100,130))
			local owner = self.Entity:GetCreator()
			self.Entity:SetOwner(nil)


			local targets = ents.FindInSphere(self:GetPos(),350)
			for k,v in pairs(targets) do
				if v:IsValid() and v:IsPlayer() then
					if SERVER then
						local trace1 = {start = self:GetPos(), endpos = v:GetPos(), mask = MASK_SHOT}
						local traceRes1 = util.TraceLine(trace1)

						local vecPos, ang = v:GetBonePosition(v:LookupBone("ValveBiped.Bip01_Head1") or 12)
						local trace2 = {start = self:GetPos(), endpos = vecPos, mask = MASK_SHOT}
						local traceRes2 = util.TraceLine(trace2)

						if (traceRes1.Entity == v or traceRes2.Entity == v) then
							v:TakeDamage( 30, owner, owner )
						end
					end
				end
			end
			util.BlastDamage(owner, owner, self:GetPos(), 350, 15)
		end


	if self.nextPing < CurTime() then
		self:SetOwner(nil) --clear owner so owner can shoot us
		local ed = EffectData()
		ed:SetEntity(self)
		ed:SetStart(self:GetPos())
		ed:SetOrigin(self:GetPos()+VectorRand()*300)
		util.Effect( "pulse_core_arc", ed, true, true )
		ed:SetOrigin(self:GetPos()+VectorRand()*300)
		util.Effect( "pulse_core_arc", ed, true, true )
		ed:SetOrigin(self:GetPos()+VectorRand()*300)
		util.Effect( "pulse_core_arc", ed, true, true )
		if math.random(0,5) == 5 then
			self:EmitSound("weapons/stunstick/stunstick_impact2.wav", self:GetPos(), 10, math.Rand(40,110))
		end
		local players = player.GetAll()
		for k,v in pairs (players) do
			if v != self.Entity:GetCreator() && v:Team() == TEAM_SWAT and (v:GetPos() - self:GetPos()):Length() < 600 and v:Alive() then
				local src = self:GetPos()
				local hit = v:GetShootPos()
				local tracedata = {}

				local tracedata = {}
				tracedata.start = src
				tracedata.endpos = hit
				tracedata.filter = self.Entity:GetCreator()
				tracedata.mask = MASK_VISIBLE
				local trace = util.TraceLine(tracedata)
				--print(trace.Entity:GetClass())
				if !(trace.HitWorld) then
					if !trace.Hit or trace.Entity:IsPlayer() then
						v:TakeDamage( 5, self.Entity:GetCreator(), self.Entity:GetCreator() )
						local ed = EffectData()
						ed:SetStart(self:GetPos())
						ed:SetOrigin(v:GetPos()+Vector(0,0,30))
						ed:SetEntity(self)
						util.Effect( "wisp_arc", ed, true, true )
						self:EmitSound("weapons/stunstick/spark3.wav", self:GetPos(), 70, math.Rand(70,110))
					end
				end
			end
		end
		self.nextPing = CurTime()+0.1
	end

	end
end


function ENT:Explode(dam,radius) --30, 120 by default
	if SERVER then
		if (!self:GetDead()) then
		self:EmitSound("weapons/explode3.wav", 100,math.Rand(150,180))
		self:EmitSound("npc/strider/strider_step1.wav", 100,math.Rand(110,120))
			-- Remove it properly in 1 second
			self:SetDead(true)
			timer.Simple( 0.1, function() RemoveEntity(self) end )

			-- Make it non solid
			self:SetNotSolid(true)
			self:SetNoDraw(true)
			self:SetLocalVelocity(Vector(0,0,0))
			self:SetMoveType(MOVETYPE_NONE)
			-- Send Effect
			local ed = EffectData()
				ed:SetEntity(self)
				ed:SetOrigin(self:GetPos())
			util.Effect( "pulse_core_explode_sml", ed, true, true )
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
							v:TakeDamage( dam, self.Entity:GetCreator(), self.Entity:GetCreator() )
						end
					end
				end
			end
		end
	end
end

function ENT:Touch(ent)
	--self:Explode(45,50)
end



function ENT:PhysicsCollide( data, physobj )
	self:Explode(45,50)
end

function ENT:SetupDataTables()
	self:NetworkVar( "Int", 0, "Life" );
	self:NetworkVar( "Bool", 0, "Dead" );
end

function ENT:OwnerDie()
end
