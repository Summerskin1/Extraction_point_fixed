ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName		= "G.H.O.S.T Defence Shield"
ENT.Author			= "Cooldown Studios"
ENT.Contact			= "NA"
ENT.Purpose			= "Used to block choke points and defend the Ghost"
ENT.Instructions	= "Use the GDS to place the shield down"
ENT.hp			= 0

local matLight 				= Material( "sprites/light_glow02_add" )
function ENT:Initialize()
 
	--self:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
	self:SetModel( "models/props_interiors/vendingmachinesoda01a_door.mdl" )
	self:SetMaterial("models/props_combine/com_shield001a")
	self:SetColor(Color(255,255,255,255))
	
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
	
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:EnableMotion(false)
	end
	if SERVER then
		self.hp = 6000
	end
end


function ENT:Use( activator, caller )
end

function ENT:Think()
	if SERVER then
		self.hp = self.hp - 100
		print(self.hp)
		self:SetColor(Color(255,(self.hp/6000)*200,(self.hp/6000)*150,255))
		if self.hp < 0 then
			self:Remove()
		end
		self:SetHealth(self.hp)
		self:NextThink(CurTime()+1)
		return true
	end
end

function ENT:OnTakeDamage(damage)
	self:SetLife(self:GetLife() - damage:GetDamage())
end

function ENT:Pickup()
end

function ENT:Drop()
end

function ENT:SetupDataTables()
	self:NetworkVar( "Int", 0, "Health" );
end

function ENT:OwnerDie()
end

if CLIENT then
local matTripmineLaser 		= Material( "sprites/bluelaser1" )
local matLight 				= Material( "sprites/light_glow02_add" )
local colBeam				= Color( 255, 60, 10, 255 )
local colLaser				= Color( 255, 130, 10, 255 )
function ENT:Draw()
	self:DrawModel()       -- Draw the model.
	local hit = self.Entity:GetPos()+self.Entity:GetForward()*-2

	if !hit then return end
		
	render.SetMaterial( matTripmineLaser )
		
		
	// Make the texture coords relative to distance so they are always a nice size
	local Distance = hit:Distance( self.Entity:GetPos() )
			
	// Draw a quad at the hitpoint to fake the laser hitting it
	render.SetMaterial( matLight )
	local Size = math.Rand( 250, 280 )
	local Normal = (self.Entity:GetPos()-hit):GetNormal() * 0.1
	render.DrawQuadEasy( hit - Normal, -Normal, Size, Size, self:GetColor(), 0 )
	render.DrawQuadEasy( hit - Normal, -Normal, Size, Size, Color(255,255,255), 0 )
		
		
	render.DrawQuadEasy( hit + Normal, Normal, Size, Size, self:GetColor(), 0 )
	render.DrawQuadEasy( hit + Normal, Normal, Size, Size, Color(2550,255,255), 0 )
end
end

local damageSound = Sound("ep/shield_hit.wav")
function ENT:OnTakeDamage(damage)
	self:EmitSound( damageSound, 100, math.random(100,230) )
	if SERVER then
		self.hp = self.hp - damage:GetDamage()
	end
end