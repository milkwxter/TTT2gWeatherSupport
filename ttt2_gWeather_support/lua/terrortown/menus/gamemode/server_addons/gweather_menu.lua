CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"
CLGAMEMODESUBMENU.title = "gWeather Admin Menu"

-- actual menu stuff
function CLGAMEMODESUBMENU:Populate(parent)
    local form = vgui.CreateTTT2Form(parent, "gWeather Menu")
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