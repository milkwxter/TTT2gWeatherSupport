-- 1. Addon Namespace (autorefresh-safe)
TTT2GWeather = TTT2GWeather or {}

-- Networking setup
util.AddNetworkString("ttt2_delete_weather")
util.AddNetworkString("ttt2_add_random_weather")
util.AddNetworkString("ttt2_tell_about_weather")
AddCSLuaFile("autorun/client/ttt2_gweather_cl.lua")

-- ConVar
local cvChance = CreateConVar("ttt2_cv_gweather_chance", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "What percent of rounds will have weather enabled?", 0, 1)
local cvMaxTier = CreateConVar("ttt2_cv_gweather_max_tier", 6, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "The maximum tier of allowed weather. Higher tiers get crazier.", 1, 6)

-- Weather tier tables
local TIER_WEATHERS = {
	{"gw_t1_sunny", "gw_t1_warmfront", "gw_t1_cloudy", "gw_t1_partlycloudy", "gw_t1_lightrain", "gw_t1_drought", "gw_t1_quarter_hail", "gw_t1_night", "gw_t1_sleet", "gw_t1_heavyfog", "gw_t1_lightwind", "gw_t1_lightsnow"},
	{"gw_t2_heavysnow", "gw_t2_coldfreeze", "gw_t2_coldfront", "gw_t2_tropicalstorm", "gw_t2_golfball_hail", "gw_t2_ashstorm", "gw_t2_heatwave", "gw_t2_moderatewind", "gw_t2_bloodrain", "gw_t2_heavyrain", "gw_t2_haboob"},
	{"gw_t3_blizzard", "gw_t3_acidrain", "gw_t3_baseball_hail", "gw_t3_extheavyrain", "gw_t3_severewind", "gw_t3_c1hurricane"},
	{"gw_t4_hurricanewind", "gw_t4_c2hurricane", "gw_t4_derecho", "gw_t4_grapefruit_hail", "gw_t4_supercell"},
	{"gw_t5_c3hurricane", "gw_t5_mhurricanewind", "gw_t5_downburst", "gw_t5_radiationstorm"},
	{"gw_t6_firestorm", "gw_t6_c4hurricane", "gw_t6_arcticblast"}, -- no unfathomable wind, not fun to play in
}

-- Tier probability upper bounds (cumulative)
-- Tier 1: 40% | Tier 2: 25% | Tier 3: 15% | Tier 4: 10% | Tier 5: 6% | Tier 6: 4%
local TIER_UPPER_BOUNDS = {40, 65, 80, 90, 96, 100}

-- 2. Local helper functions ---------------------------------------------------
local function broadcastForecast(name)
	net.Start("ttt2_tell_about_weather")
	net.WriteString(name)
	net.Broadcast()
end

local function removeWeatherEntity()
	if IsValid(TTT2GWeather.currentWeather) then
		TTT2GWeather.currentWeather:Remove()
	end

	TTT2GWeather.currentWeather = nil
end

local function resetAtmosphere()
	gWeather:AtmosphereReset()
	gWeather:RemoveSky()
	gWeather:RemoveFog()
	gWeather:ResetMapLight()
end

local function getRandomWeather()
	local maxTier = cvMaxTier:GetInt()
	local clampedTier = math.min(maxTier, #TIER_UPPER_BOUNDS)
	local randomMax = TIER_UPPER_BOUNDS[clampedTier]
	local roll = math.random(1, randomMax)

	for tier = 1, clampedTier do
		if roll <= TIER_UPPER_BOUNDS[tier] then
			local weatherList = TIER_WEATHERS[tier]
			return weatherList[math.random(1, #weatherList)], tier
		end
	end

	-- Fallback (should never reach)
	return "gw_t1_sunny", 1
end

-- 3. Public API functions -----------------------------------------------------

function TTT2GWeather:AddRandomWeather()
	if IsValid(self.currentWeather) then
		print("[TTT2GWeather] Could not add weather: remove current weather first.")
		return
	end

	local weatherClass, weatherTier = getRandomWeather()

	self.currentWeather = ents.Create(weatherClass)

	if not IsValid(self.currentWeather) then return end

	self.currentWeather:SetPos(vector_origin)
	self.currentWeather:SetAngles(angle_zero)
	self.currentWeather:Spawn()

	print("[TTT2GWeather] Weather set to: " .. self.currentWeather.PrintName .. " (Tier " .. weatherTier .. ")")
	broadcastForecast(self.currentWeather.PrintName)
end

function TTT2GWeather:DeleteWeather()
	if not IsValid(self.currentWeather) then
		print("[TTT2GWeather] No weather to remove.")
		return
	end

	resetAtmosphere()
	removeWeatherEntity()

	print("[TTT2GWeather] Weather removed.")
	broadcastForecast("Map Standard")
end

-- 4. Net Receives & Hooks -----------------------------------------------------

net.Receive("ttt2_delete_weather", function(len, ply)
	if not IsValid(ply) or not ply:IsAdmin() then return end

	TTT2GWeather:DeleteWeather()
end)

net.Receive("ttt2_add_random_weather", function(len, ply)
	if not IsValid(ply) or not ply:IsAdmin() then return end

	TTT2GWeather:AddRandomWeather()
end)

hook.Add("TTTPrepareRound", "TTT2GWeather_PrepareRound", function()
	removeWeatherEntity()
	local roll = math.random(1, 100)

	if roll < (cvChance:GetFloat() * 100) then
		TTT2GWeather:AddRandomWeather()
	else
		broadcastForecast("Map Standard")
	end
end)

hook.Add("TTTEndRound", "TTT2GWeather_EndRound", function()
	removeWeatherEntity()
end)