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

SWEP.WorldModel = ""

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

--local swing_sound = Sound()
--local hit_sound = Sound()
--local zombie_moan = Sound()

function SWEP:Initialize( )
    self:SetHoldType( "fist" )
end

function SWEP:Holster( )
    return true
end

function SWEP:PrimaryAttack( )
	local target = self:GetOwner( ):GetEyeTrace( )
	
	if not IsValid( target ) or not target:IsPlayer( ) then return end

	if SERVER then
		local target_job = target:getDarkRPVar( "jobs" )
		if target_job == TEAM_INFECTED or target_job == TEAM_ZOMBIE then return end
		
		local infection = math.random( 8 )
		if infection ~= 3 then return end
		
		target.changeTeam( TEAM_INFECTED, true )
	end
end

function SWEP:SecondaryAttack( )
	self:PrimaryAttack( )
end

function SWEP:OnDrop( )
	self:Remove( )
end