local function ZombifyNetInit( )
	util.AddNetworkString( "StartZombieTremors" )
	util.AddNetworkString( "StopZombieTremors" )
end
hook.Add( "Initialize", "ZombifyNetInit", ZombifyNetInit )