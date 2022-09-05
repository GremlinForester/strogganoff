/*QUAKED misc_explobox (0 .5 .8) (0 0 0) (32 32 64)
TESTING THING
*/

void() barrel_explode =
{
	self.takedamage = DAMAGE_NO;
	self.classname = "explo_box";
	// did say self.owner
	T_RadiusDamage (self, self, 160, world);
	sound (self, CHAN_VOICE, "weapons/r_exp3.wav", 1, ATTN_NORM);
	particle (self.origin, '0 0 0', 75, 255);

	ThrowGib ("models/objects/debris1/tris.md2", self.health, GIB_METAL, 1);
	ThrowGib ("models/objects/debris1/tris.md2", self.health, GIB_METAL, 1);
	ThrowGib ("models/objects/debris1/tris.md2", self.health, GIB_METAL, 1);
	ThrowGib ("models/objects/debris1/tris.md2", self.health, GIB_METAL, 1);
	ThrowGib ("models/objects/debris1/tris.md2", self.health, GIB_METAL, 1);
	ThrowGib ("models/objects/debris2/tris.md2", self.health, GIB_FLAMING, 1);
	ThrowGib ("models/objects/debris2/tris.md2", self.health, GIB_FLAMING, 1);
	ThrowGib ("models/objects/debris2/tris.md2", self.health, GIB_FLAMING, 1);

	self.origin_z = self.origin_z + 32;
	BecomeExplosion ();
};

void() misc_explobox =
{
//	local float	oldz;
	
	self.solid = SOLID_BBOX;
	self.movetype = MOVETYPE_NONE;
	precache_model ("models/objects/barrels/tris.md2");
	setmodel (self, "models/objects/barrels/tris.md2");
	precache_sound ("weapons/r_exp3.wav");
	self.health = 20;
	self.th_die = barrel_explode;
	self.takedamage = DAMAGE_AIM;
	setsize (self, '-16 -16 0', '16 16 40');	

	self.origin_z = self.origin_z + 2;
	self.f__ = self.origin_z;
	droptofloor();
	if (self.f__ - self.origin_z > 250)
	{
#ifndef nodprint
		dprint ("item fell out of level at ");
		dprint (vtos(self.origin));
		dprint ("\n");
#endif
		remove(self);
		self = world;
	}
};
