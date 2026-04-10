CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"
CLGAMEMODESUBMENU.title = "ttt2_gweather_title"

function CLGAMEMODESUBMENU:Populate(parent)
	local form = vgui.CreateTTT2Form(parent, "ttt2_gweather_form3")

	form:MakeHelp({
		label = "ttt2_gweather_volume_help"
	})

	form:MakeSlider({
		convar = "gw_windvolume",
		label = "ttt2_gweather_windvolume_label",
		min = 0,
		max = 1,
		decimal = 2,
		default = 1,
	})

	form:MakeSlider({
		convar = "gw_weathervolume",
		label = "ttt2_gweather_weathervolume_label",
		min = 0,
		max = 1,
		decimal = 2,
		default = 1,
	})

	form:MakeHelp({
		label = "ttt2_gweather_hud_help"
	})

	form:MakeCheckBox({
		convar = "gw_enablehud",
		label = "ttt2_gweather_enablehud_label",
		default = 0,
	})

	form:MakeHelp({
		label = "ttt2_gweather_particle_help"
	})

	form:MakeComboBox({
		convar = "gw_particle_level",
		label = "ttt2_gweather_particlelevel_label",
		choices = {"extreme", "high", "low"},
		selectName = "extreme",
		default = "extreme",
	})
end