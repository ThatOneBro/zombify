local meta = FindMetaTable( "Player" )

function meta:RemoveZombieTremors( )

end


function meta:DeZombify( )
	if not IsValid( self ) or not self:getDarkRPVar( "zombifyIsInfected" ) then return end
	
	self:RemoveZombieTremors( )
	
	local last_job = self:getDarkRPVar( "zombifyLastJob" ) or TEAM_CITIZEN
	
	self:changeTeam( last_job, true )
	self:setSelfDarkRPVar( "zombifyIsInfected", false )
end