/*QUAKED path_corner (0.5 0.3 0) (-8 -8 -8) (8 8 8)
Monsters will continue walking towards the next target corner.
*/
void() path_corner =
{
//	movetarget_f ();
	if (!self.targetname)
#ifdef noobjerr
	{
		remove(self);
		return;
	}
#else
		objerror ("monster_movetarget: no targetname");					//opgrade protected
#endif
		
	self.solid = SOLID_TRIGGER;
	self.touch = t_movetarget;
	setsize (self, '-8 -8 -8', '8 8 8');
};
