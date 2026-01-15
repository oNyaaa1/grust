hook.Add( "GetFallDamage", "CSSFallDamage", function( ply, speed )
	return math.max( 0, math.ceil( 0.2418 * speed - 141.75 ) )
end )