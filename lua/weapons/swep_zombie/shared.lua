AddCSLuaFile( )

if CLIENT then
	SWEP.PrintName = "Zombie SWEP"
	SWEP.Slot = 3
	SWEP.SlotPos = 1
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
end

SWEP.Author = "ThatOneBrah"
SWEP.Contact = "derrick.c.farris@gmail.com"
SWEP.Purpose = "For use with ThatOneBrah's Zombify plugin for DarkRP!"
SWEP.Instructions = "LEFT-CLICK to ATTACK for a chance to INFECT target; RIGHT-CLICK for ZOMBIE MOAN!"

SWEP.Category = "DarkRP (SWEP)"

SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.ViewModel = Model( "models/weapons/v_zombiearms.mdl" )
SWEP.WorldModel = ""

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

local attack_sound = Sound( "npc/zombie/zo_attack1.wav" )
local hit_sound = Sound( "npc/zombie/claw_strike2.wav" )
local zombie_moan = Sound( "npc/zombie/zombie_pain2.wav" )

local draw_delay = 1.2
local attack_range = 54
local attack_damage = 10
local attack_delay = 0.74
local moan_delay = 3

function SWEP:Initialize( )
    self:SetHoldType( "fist" )
end

function SWEP:SetupDataTables( )
	self:NetworkVar( "Float", 0, "IdleAnim" )
	self:NetworkVar( "Float", 0, "AttackEndTime" )
	self:NetworkVar( "Float", 1, "NextAttackAnim" )
	self:NetworkVar( "Bool", 0, "AltAnim" )
end

function SWEP:PlayHitSound( )
	self:GetOwner( ):EmitSound( hit_sound )
end

function SWEP:PlayAttackSound( )
	self:GetOwner( ):EmitSound( attack_sound )
end

--[[function SWEP:UpdateIdleAnim( )
	local vm = self:GetOwner( ):GetViewModel( )
	self:SetIdleAnim( CurTime( ) + vm:SequenceDuration( ) )
end]]

function SWEP:CheckIdleAnim( )
	local idleAnim = self:GetIdleAnim( )
	if idleAnim > 0 and idleAnim <= CurTime( ) then
		self:SendWeaponAnim( ACT_VM_IDLE )
		self:SetIdleAnim( 0 )
	end
end

function SWEP:CheckAttackAnim( )
	local next_attack = self:GetNextAttackAnim( )
	if next_attack > 0 and next_attack <= CurTime( ) then
		self:SetNextAttackAnim( 0 )
		self:SendAttackAnim( )
		self:UpdateIdleAnim( )
	end
end

function SWEP:CheckAttacking( )
	local attack_end = self:GetAttackEndTime( )
	if attack_end == 0 or attack_end > CurTime( ) then return end
	self:SetAttackEndTime( 0 )

	if SERVER then
		self:CheckHit( )
	end
end

function SWEP:Think( )
	self:CheckIdleAnim( )
	self:CheckAttackAnim( )
	self:CheckAttacking( )
end

function SWEP:Deploy( )
	local theTime = CurTime( )
	self:SetIdleAnim( theTime + self:SequenceDuration( ) )
	self:SetNextPrimaryFire( theTime + draw_delay )
	return true
end

function SWEP:Holster( )
    return true
end

function SWEP:PrimaryAttack( )
	local theTime = CurTime( )
	if self:GetNextPrimaryFire( ) > theTime then return end
	
	self:SetNextPrimaryFire( theTime + attack_delay )
	self:Attack( )
end

function SWEP:Attack( )
	self:SendAttackAnim( )
	
	local owner = self:GetOwner( )
	local vm = owner:GetViewModel( )
	
	owner:DoAttackEvent( )
	
	local attack_end = CurTime( ) + vm:SequenceDuration( )
	self:SetIdleAnim( attack_end )
	self:SetAttackEndTime( attack_end )
	
	if SERVER then
		self:PlayAttackSound( )
	end
end

function SWEP:CheckHit( )
	local owner = self:GetOwner( )
	local target = owner:GetEyeTrace( ).Entity
	local target_distance = target:GetPos( ):Distance( owner:GetPos( ) )
	
	print(target_distance)
	
	if not IsValid( target ) or not target:IsPlayer( ) or target_distance > attack_range then return end
	
	if SERVER then
		target:TakeDamage( attack_damage, owner, self )
		self:PlayHitSound( )
		self:InfectTarget( target )
	end
end

function SWEP:InfectTarget( target )
	if CLIENT then return end
	
	local owner = self:GetOwner( )
	
	local target_job = target:Team( )
	if target_job == TEAM_INFECTED or target_job == TEAM_ZOMBIE then return end
	
	local infection = math.random( 8 )
	if infection ~= 3 then return end
	
	target:setSelfDarkRPVar( "zombifyLastJob", target_job )
	target:setSelfDarkRPVar( "zombifyIsInfected", true )
	target:changeTeam( TEAM_INFECTED, true )
end

function SWEP:SendAttackAnim( )
	local altAnim = self:GetAltAnim( )
	
	if altAnim then
		self:SendWeaponAnim( ACT_VM_HITCENTER )
	else
		self:SendWeaponAnim( ACT_VM_SECONDARYATTACK )
	end
	self:SetAltAnim( not altAnim )
end

function SWEP:SecondaryAttack( )
	if CLIENT then return end
	self:ZombieMoan( )
end

function SWEP:ZombieMoan( )
	local theTime = CurTime( )
	
	if self:GetNextSecondaryFire( ) > theTime then return end
	local lply = self:GetOwner( )
	
	self:SetNextSecondaryFire( theTime + moan_delay )
	lply:EmitSound( zombie_moan )
end