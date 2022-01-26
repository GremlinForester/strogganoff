static string newgameinfo;
class mitem_newgame : mitem_exmenu
{
	virtual string(string key) get =
	{
		return infoget(newgameinfo, key);
	};
	virtual void(string key, string newval) set =
	{
		string old = newgameinfo;
		newgameinfo = strzone(infoadd(newgameinfo, key, newval));
		if (old)
			strunzone(old);
	};
};

var float autocvar_howmanyplayers;
var string autocvar_whatmap;

nonstatic void(mitem_desktop desktop) M_NewGame =
{
	mitem_pic banner;
	string gametype = argv(1);
	local float pos;
	mitem_exmenu m;

	local string s;
	s = strcat("maxplayers ", ftos(autocvar_howmanyplayers), "\n");
	
	float fl = RS_X_MIN_PARENT_MIN|RS_Y_MIN_PARENT_MIN | RS_X_MAX_PARENT_MAX|RS_Y_MAX_OWN_MIN;
	
	if (gametype == "sp")
	{
		//single player has no options. the start map itself gives skill+episode options.
		localcmd("\ndeathmatch 0; coop 0; maxplayers 0; timelimit 0; fraglimit 0; teamplay 0; samelevel 0; startmap_sp\n");
		return;
	}
	if (gametype == "begin")
	{
		cvar_set("hostname", 		infoget(newgameinfo, "hostname"));
		cvar_set("deathmatch", 	infoget(newgameinfo, "deathmatch"));
		cvar_set("coop", 		infoget(newgameinfo, "coop"));
		cvar_set("teamplay", 		infoget(newgameinfo, "teamplay"));
		cvar_set("sv_public", 	infoget(newgameinfo, "sv_public"));
		cvar_set("howmanyplayers", 	infoget(newgameinfo, "howmanyplayers"));
		cvar_set("timelimit", 	infoget(newgameinfo, "timelimit"));
		cvar_set("fraglimit", 	infoget(newgameinfo, "fraglimit"));	
		string whatmap = 			infoget(newgameinfo, "whatmap");
		if (whatmap == "")
			whatmap = sprintf("q2dm%g", floor(random(1, 8)));
		//localcmd ("maxplayers 32\n");
		//localcmd(s);
		localcmd(sprintf("\nmaxplayers \"%s\"\n", ftos(autocvar_howmanyplayers)));
		localcmd(sprintf("\nmap \"%s\"\n", whatmap));
		return;
	}

	if (newgameinfo)
		strunzone(newgameinfo);
	newgameinfo = "";
	newgameinfo = infoadd(newgameinfo, "hostname", cvar_string("hostname"));
	newgameinfo = infoadd(newgameinfo, "deathmatch", cvar_string("deathmatch"));
	newgameinfo = infoadd(newgameinfo, "teamplay", cvar_string("teamplay"));
	newgameinfo = infoadd(newgameinfo, "sv_public", cvar_string("sv_public"));
	newgameinfo = infoadd(newgameinfo, "howmanyplayers", cvar_string("howmanyplayers"));
	newgameinfo = infoadd(newgameinfo, "timelimit", cvar_string("timelimit"));	
	newgameinfo = infoadd(newgameinfo, "fraglimit", cvar_string("fraglimit"));
	newgameinfo = infoadd(newgameinfo, "map", cvar_string("map"));	
	newgameinfo = strzone(newgameinfo);

	m = spawn(mitem_newgame, item_text:_("New Game"), item_flags:IF_SELECTABLE, item_command:"m_main");
	desktop.add(m, RS_X_MIN_PARENT_MIN|RS_Y_MIN_PARENT_MIN | RS_X_MAX_PARENT_MAX|RS_Y_MAX_PARENT_MAX, '0 0', '0 0');
	desktop.item_focuschange(m, IF_KFOCUSED);
	m.totop();

	switch(gametype)
	{
	case "tdm":
	case "dm":
	case "coop":
	case "sp":
		break;
	default:
		//show game type selection
		pos = (16/-2)*(4);
		banner = spawn(mitem_pic, item_text:"gfx/p_option.lmp", item_size_y:24, item_flags:IF_CENTERALIGN);
		m.addm(banner, [(160-banner.item_size_x)*0.5, pos-32], [(160+banner.item_size_x)*0.5, pos-8]);
		m.addm(spawn(mitem_text, item_text:"Single Player", item_command:"m_pop;m_newgame sp", item_scale:16, item_flags:IF_CENTERALIGN), [0, pos], [160, pos+16]);	pos += 16;
		m.addm(spawn(mitem_text, item_text:"Cooperative", item_command:"m_pop;m_newgame coop", item_scale:16, item_flags:IF_CENTERALIGN), [0, pos], [160, pos+16]);	pos += 16;
		m.addm(spawn(mitem_text, item_text:"Deathmatch", item_command:"m_pop;m_newgame dm", item_scale:16, item_flags:IF_CENTERALIGN), [0, pos], [160, pos+16]);	pos += 16;
		m.addm(spawn(mitem_text, item_text:"Team Deathmatch", item_command:"m_pop;m_newgame tdm", item_scale:16, item_flags:IF_CENTERALIGN), [0, pos], [160, pos+16]);	pos += 16;
		return;
	}
	
	pos = (16/-2)*(4);

	banner = spawn(mitem_pic, item_text:"gfx/p_multi.lmp", item_size_y:24, item_flags:IF_CENTERALIGN);
	m.addm(banner, [(160-banner.item_size_x)*0.5, pos-32], [(160+banner.item_size_x)*0.5, pos-8]);

	m.addm(menuitemeditt_spawn(_("Hostname"), 		"hostname", '280 8'), 					[-160, pos], [160, pos+8]); pos += 8;
	m.addm(menuitemcheck_spawn(_("Public"),			"sv_public", 					'280 8'),	[-160, pos], [160, pos+8]); pos += 8;
	
	m.addm(menuitemcombo_spawn(_("Max Players"),	"howmanyplayers",				'280 8', _(
																			"2	\"Two\" "
																			"3	\"Three\" "
																			"4	\"Four\" "
																			"5	\"Five\" "
																			"6	\"Six\" "
																			"7	\"Seven\" "																			
																			"8	\"Eight\" "
																			)),	[-160, pos], [160, pos+8]); pos += 8;

	if (gametype == "dm" || gametype == "tdm")
	{
		if (m.get("deathmatch") == "0")
		{
			m.set("deathmatch", "1");
			m.set("coop", "0");
		}
		m.addm(menuitemcombo_spawn(_("Deathmatch Mode"),	"deathmatch",					'280 8', _(
																			"1	\"Weapons Respawn\" "
																			"2	\"Weapons Stay\" "
																			"3	\"Powerups Respawn\" "
																			"4	\"Start With Weapons\" "
																			)),	[-160, pos], [160, pos+8]); pos += 8;
	}
	else
	{
		if (m.get("coop") == "0")
		{
			m.set("deathmatch", "0");
			m.set("coop", "1");
		}
	}
	if (gametype == "tdm")
	{
		if (m.get("teamplay") == "0")
			m.set("teamplay", "1");
	}
	if (gametype == "dm")
	{
		if (m.get("teamplay") != "0")
			m.set("teamplay", "0");
	}
	if (gametype == "coop")
		m.addm(menuitemcheck_spawn(_("No Friendly Fire"),		"teamplay", 			'280 8'),	[-160, pos], [160, pos+8]); pos += 8;
//	if (gametype == "dm" || gametype == "tdm")

	if (gametype == "coop")
		m.set("map", "start");
	else
	{
		m.addm(menuitemcombo_spawn(_("Time Limit"),	"timelimit",					'280 8', _(
																			"0	\"No Limit\" "
																			"5	\"5 minutes\" "
																			"10	\"10 minutes\" "
																			"15	\"15 minutes\" "
																			"20	\"20 minutes\" "
																			"25	\"25 minutes\" "
																			"30	\"30 minutes\" "
																			"35	\"35 minutes\" "
																			"40	\"40 minutes\" "
																			"45	\"45 minutes\" "
																			"50	\"50 minutes\" "
																			"55	\"55 minutes\" "
																			"60	\"1 hour\" "
																			)),	[-160, pos], [160, pos+8]); pos += 8;
		
		m.addm(menuitemcombo_spawn(_("Frag Limit"),	"fraglimit",					'280 8', _(
																			"0	\"No Limit\" "
																			"10	\"10 frags\" "
																			"20	\"20 frags\" "
																			"30	\"30 frags\" "
																			"40	\"40 frags\" "
																			"50	\"50 frags\" "
																			"60	\"60 frags\" "
																			"70	\"70 frags\" "
																			"80	\"80 frags\" "
																			"90	\"90 frags\" "
																			"100	\"100 frags\" "
																			)),	[-160, pos], [160, pos+8]); pos += 8;
																			
		m.set("whatmap", "");
		m.addm(menuitemcombo_spawn(_("Initial Map"),	"whatmap",					'280 8', _(
																			"q2dm1		\"Q2DM1 (The Edge)\" "
																			"q2dm2		\"Q2DM2 (Tokay's Towers)\" "
																			"q2dm3		\"Q2DM3 (The Frag Pipe)\" "
																			"q2dm4		\"Q2DM4 (Lost Hallways)\" "
																			"q2dm5		\"Q2DM5 (The Pits)\" "
																			"q2dm6		\"Q2DM6 (Lava Tomb)\" "
																			"q2dm7		\"Q2DM7 (The Slimy Place)\" "
																			"q2dm8		\"Q2DM8 (WareHouse)\" "																
																			)),	[-160, pos], [160, pos+8]); pos += 8;																			
																		
	}

	m.addm(spawn(mitem_text, item_text:"BEGIN!", item_command:"m_pop;m_newgame begin", item_scale:16, item_flags:IF_CENTERALIGN), [-160, pos], [160, pos+16]);

	addmenuback(m);
};
