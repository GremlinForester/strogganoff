/*QUAKED viewthing (0 .5 .8) (-8 -8 -8) (8 8 8)

Just for the debugging level.  Don't use
*/
#ifdef debug

void() viewthing =

{
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	precache_model("progs/player.mdl");
// improved - can set model string in map entity 		- added by No. 6
	if (!self.model)
	setmodel (self, "progs/player.mdl");
	else
		precache_model(self.model);
};

#endif 
