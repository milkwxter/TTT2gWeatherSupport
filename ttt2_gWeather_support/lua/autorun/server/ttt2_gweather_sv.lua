if SERVER then
    util.AddNetworkString("ttt2_delete_weather")
    util.AddNetworkString("ttt2_add_random_weather")
	util.AddNetworkString("ttt2_tell_about_weather")
	AddCSLuaFile()
	
	-- net messages
	net.Receive("ttt2_delete_weather", function( len, ply )
		-- check perms
		if not ply:IsAdmin() then return end
		-- run a function
		print("Net message recieved: Trying to delete the weather!")
		ttt2_gWeather_deleteWeather()
	end)
	
	net.Receive("ttt2_add_random_weather", function( len, ply )
		-- check perms
		if not ply:IsAdmin() then return end
		-- run a function
		print("Net message recieved: Trying to add a random weather!")
		ttt2_gWeather_addRandomWeather()
	end)
end

-- variables -----------------------------------------------------------
ttt2_current_weather = nil
ttt2_tier1_weathers = {"gw_t1_sunny", "gw_t1_warmfront", "gw_t1_cloudy", "gw_t1_partlycloudy", "gw_t1_lightrain", "gw_t1_drought", "gw_t1_quarter_hail", "gw_t1_night", "gw_t1_sleet", "gw_t1_heavyfog", "gw_t1_lightwind", "gw_t1_lightsnow"}
ttt2_tier2_weathers = {"gw_t1_sunny"}
ttt2_tier3_weathers = {"gw_t1_sunny"}
ttt2_tier4_weathers = {"gw_t1_sunny"}
ttt2_tier5_weathers = {"gw_t1_sunny"}
ttt2_tier6_weathers = {"gw_t1_sunny"}

-- functions -----------------------------------------------------------
if SERVER then
	function ttt2_gWeather_addRandomWeather()
		-- variables
		local randomNumber = math.random(1, 100)
		local selectedWeather = "gw_t1_sunny"
		-- 40%
		if randomNumber >= 1 and randomNumber <= 40 then
			selectedWeather = ttt2_tier1_weathers[math.random(1, #ttt2_tier1_weathers)]
		-- 25%
		elseif randomNumber >= 41 and randomNumber <= 65 then
			selectedWeather = ttt2_tier2_weathers[math.random(1, #ttt2_tier2_weathers)]
		-- 15%
		elseif randomNumber >= 66 and randomNumber <= 80 then
			selectedWeather = ttt2_tier3_weathers[math.random(1, #ttt2_tier3_weathers)]
		-- 10%
		elseif randomNumber >= 81 and randomNumber <= 90 then
			selectedWeather = ttt2_tier4_weathers[math.random(1, #ttt2_tier4_weathers)]
		-- 6%
		elseif randomNumber >= 91 and randomNumber <= 96 then
			selectedWeather = ttt2_tier5_weathers[math.random(1, #ttt2_tier5_weathers)]
		-- 4%
		elseif randomNumber >= 97 and randomNumber <= 100 then
			selectedWeather = ttt2_tier6_weathers[math.random(1, #ttt2_tier6_weathers)]
		end
		
		-- epic return statement
		return selectedWeather
	end
	
	function ttt2_gWeather_addRandomWeather()
		-- get rid of current weather if it exists
		if ttt2_current_weather ~= nil then
			print("[ERROR] Could not add a new weather. Please remove the current weather.")
			return
		end
		
		-- get a random weather
		-- USE THE FUCKING FUNCTION
		local randomWeather = ttt2_tier1_weathers[math.random(1, #ttt2_tier1_weathers)]
		
		-- spawn ttt2_current_weather on the map
		ttt2_current_weather = ents.Create(randomWeather)
		local spawnPosition = Vector(0, 0, 0)
		local spawnAngle = Angle(0, 0, 0)
		-- make sure its valid
		if IsValid(ttt2_current_weather) then
			ttt2_current_weather:SetPos(spawnPosition)
			ttt2_current_weather:SetAngles(spawnAngle)
			-- spawn it
			ttt2_current_weather:Spawn()
			-- debug
			print("Current weather is now: " .. ttt2_current_weather.PrintName)
			-- inform clients
			net.Start( "ttt2_tell_about_weather" )
			net.WriteString( ttt2_current_weather.PrintName )
			net.Broadcast()
		end
	end

	function ttt2_gWeather_deleteWeather()
		if ttt2_current_weather ~= nil then
			-- gWeather stuff
			gWeather:AtmosphereReset()
			gWeather:RemoveSky()
			gWeather:RemoveFog()
			gWeather:ResetMapLight()
			-- our stuff
			ttt2_current_weather:Remove()
			ttt2_current_weather = nil
			-- debug
			print("Tried to delete current weather!")
			-- inform clients
			net.Start( "ttt2_tell_about_weather" )
			net.WriteString( "Clear" )
			net.Broadcast()
		else
			-- debug
			print("There was no current weather to delete!")
		end
	end
end

-- hooks -----------------------------------------------------------
hook.Add( "TTTPrepareRound", "TTT2_PREPARE_GWEATHER", function()
	ttt2_gWeather_addRandomWeather()
end )

hook.Add( "TTTEndRound", "TTT2_END_GWEATHER", function()
	ttt2_current_weather = nil
end )