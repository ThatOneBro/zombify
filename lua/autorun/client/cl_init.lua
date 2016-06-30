local function StartZombieTremors( )
	local function ZombieTremors( )
		local lply = LocalPlayer( )
		local theTime = CurTime( )
		
		if lply:Team( ) ~= TEAM_ZOMBIE or TEAM_INFECTED or lply:GetNWFloat( "nextShakeTime" ) > theTime then return end
		
		lply:SetNWFloat( "nextShakeTime", theTime + 5 )
		util.ScreenShake( Vector( 0, 0, 0 ), 5, 10, 5, 3000 )
	end
	hook.Add( "Think", "ZombieTremors", ZombieTremors )
end
usermessage.Hook( "StartZombieTremors", StartZombieTremors )

local function StopZombieTremors( )
	hook.Remove( "Think", "ZombieTremors" )
end
usermessage.Hook( "StopZombieTremors", StopZombieTremors )