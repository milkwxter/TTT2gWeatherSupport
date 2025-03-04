net.Receive( "ttt2_tell_about_weather", function( len, ply )
	local forecast_name = net.ReadString()
	local forecast_tier = net.ReadInt( 4 )
	chat.AddText(Color( 175, 175, 255 ), "[TODAY'S FORECAST]: ", Color(255, 255, 255), forecast_name)
	if forecast_tier == 1 then
		chat.AddText(Color( 175, 175, 255 ), "[METEOROLOGIST SUGGESTION]: ", Color(255, 255, 255), "Play as normal.")
	elseif forecast_tier == 2 then
		chat.AddText(Color( 175, 175, 255 ), "[METEOROLOGIST SUGGESTION]: ", Color(255, 255, 255), "Take caution.")
	elseif forecast_tier == 3 then
		chat.AddText(Color( 175, 175, 255 ), "[METEOROLOGIST SUGGESTION]: ", Color(255, 255, 255), "Staying inside is a great idea.")
	elseif forecast_tier == 4 then
		chat.AddText(Color( 175, 175, 255 ), "[METEOROLOGIST SUGGESTION]: ", Color(255, 255, 255), "You should really stay inside.")
	elseif forecast_tier == 5 then
		chat.AddText(Color( 175, 175, 255 ), "[METEOROLOGIST SUGGESTION]: ", Color(255, 255, 255), "Going outside will result in death.")
	elseif forecast_tier == 6 then
		chat.AddText(Color( 175, 175, 255 ), "[METEOROLOGIST SUGGESTION]: ", Color(255, 255, 255), "Good luck surviving.")
	end
end )