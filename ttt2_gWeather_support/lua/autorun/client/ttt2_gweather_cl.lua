local COLOR_FORECAST = Color(175, 175, 255)
local COLOR_WHITE = Color(255, 255, 255)

net.Receive("ttt2_tell_about_weather", function()
	local forecastName = net.ReadString()
	chat.AddText(
		COLOR_FORECAST, "[" .. LANG.GetTranslation("ttt2_gweather_todays_forecast") .. "]: ",
		COLOR_WHITE, forecastName
	)
end)