/*QUAKED misc_eastertank (1 .5 0) (-32 -32 -16) (32 32 32)*/ 
/*QUAKED misc_easterchick (1 .5 0) (-32 -32 0) (32 32 32)*/ 
/*QUAKED misc_easterchick2 (1 .5 0) (-32 -32 0) (32 32 32)*/

void() misc_eastertank_think =
{
	if (self.frame >= 293)
	{
		self.frame = 254;
	}
	else
	{
		self.frame++;
	}
	
	self.think = misc_eastertank_think;
	self.nextthink = time + 0.1;	
}

void() misc_eastertank =
{
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_BBOX;
	setsize (self, '-32 -32 -16', '32 32 32');
	precache_model ("models/monsters/tank/tris.md2");
	setmodel (self, "models/monsters/tank/tris.md2");	
	self.frame = 254;
	self.think = misc_eastertank_think;
	self.nextthink = time + 0.1;
}

void() misc_easterchick_think =
{
	if (self.frame >= 247)
	{
		self.frame = 208;
	}
	else
	{
		self.frame++;
	}
	
	self.think = misc_easterchick_think;
	self.nextthink = time + 0.1;	
}

void() misc_easterchick =
{
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_BBOX;
	setsize (self, '-32 -32 0', '32 32 32');
	precache_model ("models/monsters/bitch/tris.md2");
	setmodel (self, "models/monsters/bitch/tris.md2");		
	self.frame = 208;
	self.think = misc_easterchick_think;
	self.nextthink = time + 0.1;
}

void() misc_easterchick2_think =
{
		if (self.frame >= 287)
	{
		self.frame = 248;
	}
	else
	{
		self.frame++;
	}
	
	self.think = misc_easterchick2_think;
	self.nextthink = time + 0.1;
}

void () misc_easterchick2 =
{
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_BBOX;
	setsize (self, '-32 -32 0', '32 32 32');
	precache_model ("models/monsters/bitch/tris.md2");
	setmodel (self, "models/monsters/bitch/tris.md2");		
	self.frame = 248;
	self.think = misc_easterchick2_think;
	self.nextthink = time + 0.1;
}
 
