/*QUAKED misc_banner (1 .5 0) (-4 -4 -4) (4 4 4)
The origin is the bottom of the banner.
The banner is 128 tall.
*/

void() misc_banner_think =
{
	if (self.frame >= 15)
	{
		self.frame = 0;
	}
	else
	{
		self.frame++;
	}
	
	self.think = misc_banner_think;
	self.nextthink = time + 0.1;
}

void() misc_banner =
{
	local float r;

	r = random() * 4;
	
	if (r < 1)
	{
		self.frame = 3;
	}
	else if (r < 2)
	{
		self.frame = 7;
	}
	else if (r < 3)
	{
		self.frame = 10;
	}
	else
	{
		self.frame = 0;
	}
		
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_NONE;
	precache_model ("models/objects/banner/tris.md2");
	setmodel (self, "models/objects/banner/tris.md2");

	//self.health = 20;
	//self.th_die = banner_die;
	//self.takedamage = DAMAGE_AIM;
	self.classname = "misc_banner";
	self.think = misc_banner_think;
	self.nextthink = time + 0.1;
};
