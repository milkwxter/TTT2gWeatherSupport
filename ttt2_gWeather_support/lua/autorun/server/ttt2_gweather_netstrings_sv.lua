if SERVER then
    util.AddNetworkString("ttt2_delete_weather")
    util.AddNetworkString("ttt2_add_random_weather")
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
ttt2_tier1_weathers = {"gw_t1_sunny", "gw_t1_heavyfog"}

-- functions -----------------------------------------------------------
if SERVER then
	function ttt2_gWeather_addRandomWeather()
		-- get rid of current weather if it exists
		if ttt2_current_weather == nil then
			ttt2_gWeather_deleteWeather()
		end
		
		-- get a random tier 1 weather
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
			print("Current weather is now: " .. randomWeather)
		end
	end

	function ttt2_gWeather_deleteWeather()
		if ttt2_current_weather ~= nil then
			ttt2_current_weather:Remove()
			ttt2_current_weather = nil
			print("Deleted current weather!")
		else
			print("There was no current weather to delete!")
		end
	end
end