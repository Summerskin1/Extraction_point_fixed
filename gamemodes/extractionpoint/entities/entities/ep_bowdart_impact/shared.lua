ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName		= "Tripmine"
ENT.Author			= "Cooldown Studios"
ENT.Contact			= "NA"
ENT.Purpose			= "Asplode Swatz"
ENT.Instructions	= "THROW IT ON DA GROUND"


function ENT:Initialize()
 
	self:SetCollisionGroup( COLLISION_GROUP_NPC )
	self:SetModel( "models/crossbow_bolt.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_NONE )   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
	--self:SetAimpos(Vector(0,0,0)) --Sets the laser point to the origin, for now.
	self.start = CurTime()
	self:SetDead(false)
	self.dead = false
	timer.Simple(4,function()
		if self and self:IsValid() then
			self:Explode(50,200)
		end
	end)
end


function ENT:Use( activator, caller )
end

function ENT:Think()
	self:PassiveDamage(9,150)
	if SERVER then
		for i=0,5 do
			local ed = EffectData()
			ed:SetEntity(self)
			ed:SetStart(self:GetPos())
			ed:SetOrigin(self:GetPos()+AngleRand():Forward()*math.Rand(0,50))
			util.Effect( "wisp_arc", ed, true, true )
		end
	end
	
	self:NextThink(CurTime()+0.3)
	return true
end


function ENT:Explode(dam,radius) --30, 120 by default
	if SERVER then
		if (!self:GetDead()) then
			self:EmitSound("npc/roller/mine/rmine_explode_shock1.wav", 100, 100)
			-- Remove it properly in 1 second
			self:SetDead(true)
			-- Make it non solid
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
							v:TakeDamage( dam, self:GetOwner(), self:GetOwner() )
						end
					end
				end
			end
		end
		self:Remove()
	end
end

function ENT:PassiveDamage(dam,radius) --30, 120 by default
	if SERVER then
		if (!self:GetDead()) then
		--self:EmitSound("weapons/explode3.wav", 100,math.Rand(150,180))
		--self:EmitSound("npc/strider/strider_step1.wav", 100,math.Rand(110,120))
		self:EmitSound("weapons/stunstick/spark2.wav", 90, 70+((CurTime()-self.start)*15))
			-- Send Effect
			local ed = EffectData()
				ed:SetEntity(self)
				ed:SetOrigin(self:GetPos())
			--util.Effect( "shell_explode", ed, true, true )			
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
		end
	end
end

function ENT:SetupDataTables()
	self:NetworkVar( "Bool", 0, "Dead" );
end
