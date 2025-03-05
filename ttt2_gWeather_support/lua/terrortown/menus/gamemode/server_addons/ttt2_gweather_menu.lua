CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"
CLGAMEMODESUBMENU.title = "gWeather"

-- actual menu stuff
function CLGAMEMODESUBMENU:Populate(parent)
    local form = vgui.CreateTTT2Form(parent, "gWeather Server Settings")
	form:MakeHelp({
        label = "General Settings",
    })
	form:MakeCheckBox({
        label = "Enable Weather Damage to Entities (Players/NPCs)",
        serverConvar = "gw_weather_entitydamage",
    })
	form:MakeSlider({
        label = "How long should the weather last for in seconds",
        serverConvar = "gw_weather_lifetime",
        min = 0,
        max = 2000,
        decimal = 0,
    })
	
	form:MakeHelp({
        label = "Wind Settings",
    })
	form:MakeCheckBox({
        label = "Enable custom player gWeather wind physics",
        serverConvar = "gw_windphysics_player",
    })
	form:MakeCheckBox({
        label = "Enable custom prop gWeather wind physics",
        serverConvar = "gw_windphysics_prop",
    })
	form:MakeSlider({
        label = "How often does wind push stuff",
        serverConvar = "gw_nextwind",
        min = 0.1,
        max = 2,
        decimal = 1,
    })
	
	form:MakeHelp({
        label = "Temperature Settings",
    })
	local temperatureEffectsPlayers = form:MakeCheckBox({
        label = "Should the player experience hypo/hyperthermia from the weather",
        serverConvar = "gw_tempaffect",
    })
	
	local form2 = vgui.CreateTTT2Form(parent, "gWeather Compatibility Settings")
	form2:MakeHelp({
        label = "These settings are for the TTT2 compatibility with gWeather.",
    })
	form2:MakeSlider({
        label = "Percent of rounds that have weather enabled",
        serverConvar = "ttt2_cv_gweather_chance",
        min = 0,
        max = 1,
        decimal = 2,
    })
	form2:MakeSlider({
        label = "Maximum tier of weather enabled. Higher = crazier",
        serverConvar = "ttt2_cv_gweather_max_tier",
        min = 1,
        max = 6,
        decimal = 0,
    })
end

function CLGAMEMODESUBMENU:PopulateButtonPanel(parent)
	-- Delete weather
    local buttonDeleteWeather = vgui.Create("DButtonTTT2", parent)
    buttonDeleteWeather:SetText("Delete Current Weather")
    buttonDeleteWeather:SetSize(300, 45)
    buttonDeleteWeather:SetPos(20, 20)
    buttonDeleteWeather.DoClick = function(btn)
		print("Button clicked, sending net message.")
        net.Start("ttt2_delete_weather")
		net.SendToServer()
    end
	
	-- Add random weather
    local buttonAddRandomWeather = vgui.Create("DButtonTTT2", parent)
    buttonAddRandomWeather:SetText("Add Random Weather")
    buttonAddRandomWeather:SetSize(300, 45)
    buttonAddRandomWeather:SetPos(340, 20)
    buttonAddRandomWeather.DoClick = function(btn)
		print("Button clicked, sending net message.")
		net.Start("ttt2_add_random_weather")
		net.SendToServer()
    end
end

function CLGAMEMODESUBMENU:HasButtonPanel()
    return true
end