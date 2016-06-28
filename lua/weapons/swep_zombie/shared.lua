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

--local swing_sound = Sound( )
--local hit_sound = Sound( )
local zombie_moan = Sound( "npc/zombie/zombie_pain2.wav" )

local attack_distance = 54

function SWEP:Initialize( )
    self:SetHoldType( "fist" )
end

function SWEP:Holster( )
    return true
end

function SWEP:PrimaryAttack( )
	local owner = self:GetOwner( )
	local target = owner:GetEyeTrace( ).Entity
	
	if not IsValid( target ) or not target:IsPlayer( ) or target:GetPos( ):Distance( owner:GetPos( ) ) > attack_distance then return end
		
	if SERVER then
		local target_job = target:Team( )
		if target_job == TEAM_INFECTED or target_job == TEAM_ZOMBIE then return end
		
		local infection = math.random( 8 )
		if infection ~= 3 then return end
		
		target:setSelfDarkRPVar( "zombifyLastJob", target_job )
		target:setSelfDarkRPVar( "zombifyIsInfected", true )
		target:changeTeam( TEAM_INFECTED, true )
	end
end

function SWEP:SecondaryAttack( )
	self:ZombieMoan( )
end

function SWEP:ZombieMoan( )
	local lply = self:GetOwner( )
	
	if lply:getDarkRPVar( "zombifyNextMoanTime" ) and lply:getDarkRPVar( "zombifyNextMoanTime" ) > CurTime( ) then return end
	
	if SERVER then
		local next_moan = CurTime( ) + 5
		lply:setSelfDarkRPVar( "zombifyNextMoanTime", next_moan )
		lply:EmitSound( zombie_moan )
	end	
end

function SWEP:Reload( )
	local lply = self:GetOwner( )
	if SERVER then
		lply:setSelfDarkRPVar( "zombifyIsInfected", true )
	end
end
