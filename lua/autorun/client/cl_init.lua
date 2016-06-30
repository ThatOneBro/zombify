local meta = FindMetaTable( "Player" )

function meta:StartZombieTremors( newTeam )	
	hook.Add( "Think", "ZombieTremors", function( )
		local plyTeam = self:Team( )
		local theTime = CurTime( )
		
		if plyTeam ~= TEAM_ZOMBIE and plyTeam ~= TEAM_INFECTED then
			if not newTeam then self:StopZombieTremors( ) return end
		end
		if self:GetNWFloat( "nextShakeTime" ) > theTime then return end
		
		util.ScreenShake( Vector( 0, 0, 0 ), 5, 10, 5, 3000 )
		self:SetNWFloat( "nextShakeTime", theTime + 5 )
	end )
end
	
function meta:StopZombieTremors( )
	hook.Remove( "Think", "ZombieTremors" )
end

net.Receive( "StopZombieTremors", function( )
	local lply = LocalPlayer( )
	lply:StopZombieTremors( )
end )