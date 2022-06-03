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
