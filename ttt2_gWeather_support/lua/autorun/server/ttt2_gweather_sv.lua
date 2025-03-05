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

-- convars -----------------------------------------------------------
CreateConVar("ttt2_cv_gweather_chance", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "What percent of rounds will have weather enabled?", 0, 1)
CreateConVar("ttt2_cv_gweather_max_tier", 6, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "The maximum tier of allowed weather. Higher tiers get crazier.", 1, 6)

-- variables -----------------------------------------------------------
ttt2_current_weather = nil
ttt2_tier1_weathers = {"gw_t1_sunny", "gw_t1_warmfront", "gw_t1_cloudy", "gw_t1_partlycloudy", "gw_t1_lightrain", "gw_t1_drought", "gw_t1_quarter_hail", "gw_t1_night", "gw_t1_sleet", "gw_t1_heavyfog", "gw_t1_lightwind", "gw_t1_lightsnow"}
ttt2_tier2_weathers = {"gw_t2_heavysnow", "gw_t2_coldfreeze", "gw_t2_coldfront", "gw_t2_tropicalstorm", "gw_t2_golfball_hail", "gw_t2_ashstorm", "gw_t2_heatwave", "gw_t2_moderatewind", "gw_t2_bloodrain", "gw_t2_heavyrain", "gw_t2_haboob"}
ttt2_tier3_weathers = {"gw_t3_blizzard", "gw_t3_acidrain", "gw_t3_baseball_hail", "gw_t3_extheavyrain", "gw_t3_severewind", "gw_t3_c1hurricane"}
ttt2_tier4_weathers = {"gw_t4_hurricanewind", "gw_t4_c2hurricane", "gw_t4_derecho", "gw_t4_grapefruit_hail", "gw_t4_supercell"}
ttt2_tier5_weathers = {"gw_t5_c3hurricane", "gw_t5_mhurricanewind", "gw_t5_downburst", "gw_t5_radiationstorm"}
ttt2_tier6_weathers = {"gw_t6_firestorm", "gw_t6_c4hurricane", "gw_t6_arcticblast"} -- no unfathomable wind, not fun to play in
-- no tier 7, are you serious

-- functions -----------------------------------------------------------
if SERVER then
	function ttt2_gWeather_getRandomWeather()
		-- get max value for randomNumber
		local randomMax = 100
		if GetConVar( "ttt2_cv_gweather_max_tier" ):GetInt() == 1 then
			randomMax = 40;
		elseif GetConVar( "ttt2_cv_gweather_max_tier" ):GetInt() == 2 then
			randomMax = 65;
		elseif GetConVar( "ttt2_cv_gweather_max_tier" ):GetInt() == 3 then
			randomMax = 80;
		elseif GetConVar( "ttt2_cv_gweather_max_tier" ):GetInt() == 4 then
			randomMax = 90;
		elseif GetConVar( "ttt2_cv_gweather_max_tier" ):GetInt() == 5 then
			randomMax = 96;
		end
		
		-- variables
		local randomNumber = math.random(1, randomMax)
		local selectedWeather = "gw_t1_sunny"
		local selectedTier = 0
		
		-- weather selection
		-- 40%
		if randomNumber >= 1 and randomNumber <= 40 then
			selectedWeather = ttt2_tier1_weathers[math.random(1, #ttt2_tier1_weathers)]
			selectedTier = 1
		-- 25%
		elseif randomNumber >= 41 and randomNumber <= 65 then
			selectedWeather = ttt2_tier2_weathers[math.random(1, #ttt2_tier2_weathers)]
			selectedTier = 2
		-- 15%
		elseif randomNumber >= 66 and randomNumber <= 80 then
			selectedWeather = ttt2_tier3_weathers[math.random(1, #ttt2_tier3_weathers)]
			selectedTier = 3
		-- 10%
		elseif randomNumber >= 81 and randomNumber <= 90 then
			selectedWeather = ttt2_tier4_weathers[math.random(1, #ttt2_tier4_weathers)]
			selectedTier = 4
		-- 6%
		elseif randomNumber >= 91 and randomNumber <= 96 then
			selectedWeather = ttt2_tier5_weathers[math.random(1, #ttt2_tier5_weathers)]
			selectedTier = 5
		-- 4%
		elseif randomNumber >= 97 and randomNumber <= 100 then
			selectedWeather = ttt2_tier6_weathers[math.random(1, #ttt2_tier6_weathers)]
			selectedTier = 6
		end
		
		-- epic return statement
		return selectedWeather, selectedTier
	end
	
	function ttt2_gWeather_addRandomWeather()
		-- get rid of current weather if it exists
		if ttt2_current_weather ~= nil then
			print("[ERROR] Could not add a new weather. Please remove the current weather.")
			return
		end
		
		-- get a random weather
		local randomWeather, weatherTier = ttt2_gWeather_getRandomWeather()
		
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
			net.WriteInt( weatherTier, 4 )
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
			print("Deleted current weather!")
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
if SERVER then
	hook.Add( "TTTPrepareRound", "TTT2_PREPARE_GWEATHER", function()
		-- clear current weather just in case
		ttt2_current_weather = nil
		-- random chance for weather
		local randomChance = math.random(1, 100)
		if randomChance < GetConVar( "ttt2_cv_gweather_chance" ):GetInt() then return end
		-- if we won the random roll, add a weather
		ttt2_gWeather_addRandomWeather()
	end )

	hook.Add( "TTTEndRound", "TTT2_END_GWEATHER", function()
		ttt2_current_weather = nil
	end )
end