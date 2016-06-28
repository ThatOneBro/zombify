local function PlyFuncInit( )	
	local meta = FindMetaTable( "Player" )

	function meta:AddZombieTremors( )
		net.Start( "StartZombieTremors" )
		net.Send( self )
	end

	function meta:RemoveZombieTremors( )
		net.Start( "StopZombieTremors" )
		net.Send( self )
	end

	function meta:DeZombify( )
		if not IsValid( self ) or not self:getDarkRPVar( "zombifyIsInfected" ) then return end
		
		self:RemoveZombieTremors( )
		
		local last_job = self:getDarkRPVar( "zombifyLastJob" ) or TEAM_CITIZEN
		
		self:changeTeam( last_job, true )
		self:setSelfDarkRPVar( "zombifyIsInfected", false )
	end
end
hook.Add( "Initialize", "ZombifyPlyFuncInit", PlyFuncInit )