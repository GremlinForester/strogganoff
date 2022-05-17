/*QUAKED misc_explobox2 (0 .5 .8) (0 0 0) (32 32 64)
Smaller exploding box, REGISTERED ONLY
*/

void() misc_explobox2 =
{	
	precache_model2 ("maps/b_exbox2.bsp");
	precache_sound ("weapons/r_exp3.wav");

	misc_explobox();
	if (self)
	setmodel (self, "maps/b_exbox2.bsp");
};
