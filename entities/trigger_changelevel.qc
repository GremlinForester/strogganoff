/*QUAKED trigger_changelevel (0.5 0.5 0.5) ? NO_INTERMISSION
When the player touches this, he gets sent to the map listed in the "map" variable.  Unless the NO_INTERMISSION flag is set, the view will go to the info_intermission spot and display stats.
*/
void() trigger_changelevel =
{
	if (!self.map)
#ifdef noobjerr
	{
		self.map = "start"; // DM or SP - we default here if a mapper forgot a map link

#ifdef xvars1
// future add cvar_string("svx_tc_rndmap") - random map selected from list
		if (cvar_string("svx_tc_defmap")) self.map = cvar_string("svx_tc_defmap");
#endif
	}
#else
		objerror ("changelevel trigger doesn't have map");					//opgrade protected
#endif
	
	InitTrigger ();
	self.touch = changelevel_touch;
};

void() changelevel_use =
{
//	local entity	pos;	// fx_warning

	if (activator.classname != "player")
		return;

	if ((cvar("noexit") == 1) || ((cvar("noexit") == 2) && (mapname != "start")))
	{
		T_Damage (other, self, self, 50000);
		return;
	}

	if (coop || deathmatch)
	{
		bprint (other.netname);
		bprint (" exited the level\n");
	}
	
	if (!self.map)
	{
		objerror ("target_changelevel with no map");
	//	self.map = "start"; // DM or SP - we default here if a mapper forgot a map link
	}	
	
	tokenizebyseparator(self.map,"$");
	
	LOG(argv(0)); //map name
	LOG(argv(1)); //player start position(TBD)
	
	local string t = strcat("q2_spawnspot ", argv(1), "\n");
	
	localcmd(t);
	
	local string s = strcat("changelevel ", argv(0), "\n");
	
	localcmd(s);
};

void() target_changelevel =
{
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_NOCLIP;
	self.effects = 	self.effects | EF_FULLBRIGHT | EF_NODEPTHTEST;
	setsize (self, '-24 -24 -24', '24 24 24');	
	self.use = changelevel_use;

	//LOG(nextmap);	
};
