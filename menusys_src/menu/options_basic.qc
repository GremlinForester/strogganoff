class mitem_playerpreview : mitem_spinnymodel
{
//#if 1//defined(FTE_QC_CUSTOMSKINS)
	virtual void(vector pos) item_draw =
	{
		//if you wanted to get more advanced, you could use q3 skins here.
		if (cvar("noskins"))
			setcustomskin(self, "", sprintf("q1upper \"%s\"\nq1lower \"%s\"\n\n", cvar_string("topcolor"), cvar_string("bottomcolor")));
		else if (cvar_string("cl_teamskin") != "")
			setcustomskin(self, "", sprintf("q1upper \"%s\"\nq1lower \"%s\"\nqwskin \"%s\"\n", cvar_string("topcolor"), cvar_string("bottomcolor"), cvar_string("cl_teamskin")));
		else
			setcustomskin(self, "", sprintf("q1upper \"%s\"\nq1lower \"%s\"\nqwskin \"%s\"\n", cvar_string("topcolor"), cvar_string("bottomcolor"), cvar_string("skin")));
	
		super::item_draw(pos);
	};
//#endif
};
/*
static string() skinopts =
{
	local float s;
	
	string opts = "";
	if (cvar("cl_playertype") == 0){
		float s = search_begin("players/male/*.pcx", TRUE, TRUE);
	}
	else if (cvar("cl_playertype") == 1)
	{
		float s = search_begin("players/female/*.pcx", TRUE, TRUE);	
	}
	else if (cvar("cl_playertype") == 2)
	{
		float s = search_begin("players/cyborg/*.pcx", TRUE, TRUE);	
	}
	
	if (s < 0)
		return opts;
	float n = search_getsize(s);
	for (float i = 0; i < n; i++)
	{
		string f = substring(search_getfilename(s, i), 6, -5);
		opts = strcat(opts, "\"", f, "\" \"", f, "\" ");
	}
	return opts;
};
*/

var float autocvar_m_pitch = 0.022;
class options_basic : mitem_exmenu
{
	virtual float(string key) isvalid =
	{
		if (key == "m_pitchsign")
			return TRUE;
		if (key == "cl_run")
			return TRUE;
		return super::isvalid(key);
	};
	virtual string(string key) get =
	{
		if (key == "m_pitchsign")
			return (autocvar_m_pitch<0)?"1":"0";
		if (key == "cl_run")
			return (stof(super::get("cl_forwardspeed")) > 200)?"1":"0";
		return super::get(key);
	};
	virtual void(string key, string newval) set =
	{
		if (key == "m_pitchsign")
		{
			float invert;
			if (stof(newval))
				invert = autocvar_m_pitch > 0;
			else
				invert = autocvar_m_pitch < 0;
			if (invert)
				cvar_set("m_pitch", ftos(-autocvar_m_pitch));
		}
		else if (key == "cl_run")
		{
			float setbackspeed = (super::get("cl_backspeed") != "");
			if (stof(newval))
			{
				super::set("cl_forwardspeed", "400");
				super::set("cl_sidespeed", "400");
				if (setbackspeed)
					super::set("cl_backspeed", "400");
				super::set("cl_movespeedkey", "0.5");	//makes +speed act like +walk
			}
			else
			{
				//these are the defaults from winquake.
				super::set("cl_forwardspeed", "200");
				super::set("cl_sidespeed", "350");
				if (setbackspeed)
					super::set("cl_backspeed", "200");
				super::set("cl_movespeedkey", "2.0");
			}
		}
		else
			super::set(key, newval);
	};
};

.float playerType;

nonstatic void(mitem_desktop desktop) M_Options_Basic =
{
	mitem_exmenu m;
	m = spawn(options_basic, item_text:_("Basic Options"), item_flags:IF_SELECTABLE, item_command:"m_options");
	desktop.add(m, RS_X_MIN_PARENT_MIN|RS_Y_MIN_PARENT_MIN | RS_X_MAX_PARENT_MAX|RS_Y_MAX_PARENT_MAX, '0 0', '0 0'); // '0 0'
	desktop.item_focuschange(m, IF_KFOCUSED);
	m.totop();

	float h = 200 * 0.4; //0.5
	//draw title art above the options
	mitem_pic banner = spawn(mitem_pic, item_text:"gfx/ttl_cstm.lmp", item_size_y:24, item_flags:IF_CENTERALIGN);
	m.add(banner, RS_X_MIN_PARENT_MID|RS_Y_MIN_PARENT_MID | RS_X_MAX_OWN_MIN|RS_Y_MAX_PARENT_MID, [(160-160-banner.item_size_x)*0.5, -h-32], [banner.item_size_x, -h-8]);
	
		//draw title art above the options
	mitem_pic playertype = spawn(mitem_pic, item_text:"gfx/hud_gl", item_size_y:24, item_flags:IF_CENTERALIGN);
	m.add(playertype, RS_X_MIN_PARENT_MID|RS_Y_MIN_PARENT_MID | RS_X_MAX_OWN_MIN|RS_Y_MAX_PARENT_MID, [(160-160-playertype.item_size_x)*0.5, -h-32], [playertype.item_size_x, -h-8]);
	
	//spawn a container frame for the actual options. this provides a scrollbar if we have too many items.
	mitem_frame fr = spawn(mitem_frame, item_flags: IF_SELECTABLE, frame_hasscroll:TRUE);
	m.add(fr, RS_X_MIN_PARENT_MID|RS_Y_MIN_PARENT_MID | RS_X_MAX_PARENT_MID|RS_Y_MAX_OWN_MIN, [-160, -h], [160, h*2]);
	float fl = RS_X_MIN_PARENT_MIN|RS_Y_MIN_PARENT_MIN | RS_X_MAX_PARENT_MAX|RS_Y_MAX_OWN_MIN;
	float pos = 0;
	

	fr.add(menuitemeditt_spawn(_("Player Name"), dp("_cl_name", "name"), '280 8'), fl, [0, pos], [0, 8]); pos += 8;
//	fr.add(menuitemeditt_spawn(_("Player Team"), "team", '280 8'), fl, [0, pos], [0, 8]); pos += 8;
//	fr.add(menuitemcombo_spawn(_("Player Skin"), "skin", '280 8', skinopts()), fl, [0, pos], [0, 8]); pos += 8;
//	fr.add(menuitemcolour_spawn(_("Upper Colour"), 	"topcolor", 					'280 8'),	fl, [0, pos], [0, 8]); pos += 8;
//	fr.add(menuitemcolour_spawn(_("Lower Colour"), 	"bottomcolor", 					'280 8'),	fl, [0, pos], [0, 8]); pos += 8;	/*aka: arse colour*/
	pos += 8;
	fr.add(menuitemcheck_spawn (_("Always Run"), "cl_run", '280 8'), fl, [0, pos], [0, 8]); pos += 8;
	fr.add(menuitemcheck_spawn (_("Invert Mouse"), "m_pitchsign", '280 8'),	fl, [0, pos], [0, 8]); pos += 8;
	fr.add(menuitemslider_spawn(_("Sensitivity"), "sensitivity", '3 20 1', '280 8'), fl, [0, pos], [0, 8]); pos += 8;
	fr.add(menuitemslider_spawn(_("Fov"), "fov", '80 130 5', '280 8'), fl, [0, pos], [0, 8]); pos += 8;
//	fr.add(menuitemslider_spawn(_("Viewmodel Fov"),		"r_viewmodel_fov", 		'80 130 5',	'280 8'),	fl, [0, pos], [0, 8]); pos += 8;
	fr.add(menuitemslider_spawn(_("Gamma"), dp("v_gamma", "gamma"), 	'0.4 1.3 0.1',	'280 8'),	fl, [0, pos], [0, 8]); pos += 8;
	fr.add(menuitemslider_spawn(_("Contrast"), dp("v_contrast", "contrast"), 	'0.8 1.8 0.1', 	'280 8'),	fl, [0, pos], [0, 8]); pos += 8;
	fr.add(menuitemslider_spawn(_("Brightness"), dp("v_brightness", "brightness"),'0.0 0.5 0.1', '280 8'),	fl, [0, pos], [0, 8]); pos += 8;
	fr.add(menuitemslider_spawn(_("Crosshair"), "crosshair", '0.0 7 1', '280 8'), fl, [0, pos], [0, 8]); pos += 8;

//	fr.add(menuitemslider_spawn(_("Player Type"), "cl_playertype", '0.0 2 1', '280 8'),	fl, [0, pos], [0, 2]); pos += 8;
//	fr.add(menuitemslider_spawn(_("Skin"), "skin", '0.0 2 1', '280 8'),	fl, [0, pos], [0, 8]); pos += 2;	
	
	fr.add(menuitemcombo_spawn(_("Player Type"),	"set self.playerType", '280 8', _(
																		"0	\"Male\" "
																		"1	\"Female\" "
																		"2	\"Cyborg\" "
																		)),	fl, [0, pos], [0, 8]); pos += 8;

	if (self.playerType == 0){
	fr.add(menuitemcombo_spawn(_("Skin"),	"skin", '280 8', _(
																		"0	\"Grunt\" "
																		"1	\"Cipher\" "
																		"2	\"Claymore\" "
																		"3	\"Flak\" "
																		"4	\"Howitzer\" "
																		"5	\"Major\" "
																		"6	\"Nightops\" "
																		"7	\"Pointman\" "
																		"8	\"Psycho\" "
																		"9	\"Rampage\" "
																		"10	\"Razor\" "
																		"11	\"Recon\" "
																		"12	\"Scout\" "
																		"13	\"Sniper\" "
																		"14	\"Viper\" "
																		)),	fl, [0, pos], [0, 8]); pos += 8;
	}
	if (self.playerType == 1){
	fr.add(menuitemcombo_spawn(_("Skin"),	"skin", '280 8', _(
																		"0	\"Athena\" "
																		"1	\"Brianna\" "
																		"2	\"Cobalt\" "
																		"3	\"Ensign\" "
																		"4	\"Jezebel\" "
																		"5	\"Jungle\" "
																		"6	\"Lotus\" "
																		"7	\"Stiletto\" "
																		"8	\"Venus\" "
																		"9	\"Voodoo\" "																	
																		)),	fl, [0, pos], [0, 8]); pos += 8;
	}
	if (self.playerType == 2){
	fr.add(menuitemcombo_spawn(_("Skin"),	"skin", '280 8', _(
																		"0	\"Oni911\" "
																		"1	\"Ps9000\" "
																		"2	\"Tyr574\" "
																		)),	fl, [0, pos], [0, 8]); pos += 8;
	}	
	
	if (cvar("cl_playertype") == 0)
	{
	switch (cvar("skin"))
		{
		case 0:
			m.adda(menuitempic_spawn ("players/male/grunt_i", 	'64 64'), 	'16 4');
			break;
		case 1:
			m.adda(menuitempic_spawn ("players/male/cipher_i", 	'64 64'), 	'16 4');
			break;
		case 2:
			m.adda(menuitempic_spawn ("players/male/claymore_i", 	'64 64'), 	'16 4');
			break;
		case 3:
			m.adda(menuitempic_spawn ("players/male/flak_i", 	'64 64'), 	'16 4');
			break;
		case 4:
			m.adda(menuitempic_spawn ("players/male/howitzer_i", 	'64 64'), 	'16 4');
			break;
		case 5:
			m.adda(menuitempic_spawn ("players/male/major_i", 	'64 64'), 	'16 4');
			break;
		case 6:
			m.adda(menuitempic_spawn ("players/male/nightops_i", 	'64 64'), 	'16 4');
			break;
		case 7:
			m.adda(menuitempic_spawn ("players/male/pointman_i", 	'64 64'), 	'16 4');
			break;
		case 8:
			m.adda(menuitempic_spawn ("players/male/psycho_i", 	'64 64'), 	'16 4');
			break;
		case 9:
			m.adda(menuitempic_spawn ("players/male/rampage_i", 	'64 64'), 	'16 4');
			break;
		case 10:
			m.adda(menuitempic_spawn ("players/male/razor_i", 	'64 64'), 	'16 4');
			break;
		case 11:
			m.adda(menuitempic_spawn ("players/male/recon_i", 	'64 64'), 	'16 4');
			break;
		case 12:
			m.adda(menuitempic_spawn ("players/male/scout_i", 	'64 64'), 	'16 4');
			break;
		case 13:
			m.adda(menuitempic_spawn ("players/male/sniper_i", 	'64 64'), 	'16 4');
			break;
		case 14:
			m.adda(menuitempic_spawn ("players/male/viper_i", 	'64 64'), 	'16 4');
			break;			
		}
	}
	if (cvar("cl_playertype") == 1)
	{
	switch (cvar("skin"))
		{
		case 0:
			m.adda(menuitempic_spawn ("players/female/athena_i", 	'64 64'), 	'16 4');
			break;
		case 1:
			m.adda(menuitempic_spawn ("players/female/brianna_i", 	'64 64'), 	'16 4');
			break;
		case 2:
			m.adda(menuitempic_spawn ("players/female/cobalt_i", 	'64 64'), 	'16 4');
			break;
		case 3:
			m.adda(menuitempic_spawn ("players/female/ensign_i", 	'64 64'), 	'16 4');
			break;
		case 4:
			m.adda(menuitempic_spawn ("players/female/jezebel_i", 	'64 64'), 	'16 4');
			break;
		case 5:
			m.adda(menuitempic_spawn ("players/female/jungle_i", 	'64 64'), 	'16 4');
			break;
		case 6:
			m.adda(menuitempic_spawn ("players/female/lotus_i", 	'64 64'), 	'16 4');
			break;
		case 7:
			m.adda(menuitempic_spawn ("players/female/stiletto_i", 	'64 64'), 	'16 4');
			break;
		case 8:
			m.adda(menuitempic_spawn ("players/female/venus_i", 	'64 64'), 	'16 4');
			break;
		case 9:
			m.adda(menuitempic_spawn ("players/female/voodoo_i", 	'64 64'), 	'16 4');
			break;			
		}
	}
	if (cvar("cl_playertype") == 2)
	{
	switch (cvar("skin"))
		{
		case 0:
			m.adda(menuitempic_spawn ("players/cyborg/oni911_i", 	'64 64'), 	'16 4');
			break;
		case 1:
			m.adda(menuitempic_spawn ("players/cyborg/ps9000_i", 	'64 64'), 	'16 4');
			break;
		case 2:
			m.adda(menuitempic_spawn ("players/cyborg/tyr574_i", 	'64 64'), 	'16 4');
			break;
		}
	}	

	addmenuback(m);
};
