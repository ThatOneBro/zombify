hook.Add( "Initialize", "ZombifySharedInit", function( )
	DarkRP.registerDarkRPVar( "zombifyLastJob", function( val ) net.WriteInt( val, 16 ) end, function( ) return net.ReadInt( 16 ) end )
	DarkRP.registerDarkRPVar( "zombifyIsInfected", net.WriteBool, net.ReadBool )
end )