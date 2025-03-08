net.Receive( "ttt2_tell_about_weather", function( len, ply )
	local forecast_name = net.ReadString()
	chat.AddText(Color( 175, 175, 255 ), "[TODAY'S FORECAST]: ", Color(255, 255, 255), forecast_name)
end )

hook.Add("InitPostEntity", "TTT2gWeatherDisableHUD", function()
	RunConsoleCommand("gw_enablehud", "0")
end)