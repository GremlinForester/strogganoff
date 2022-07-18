.string brokenModel;

/*
The breakable glass switches models becuase for some reason skins weren't working.

Eventually this special case will be moved to a more general purpose model_static_breakable entity with damage states or something.
*/

//********************************************
// BREAKABLE GLASS
//********************************************

/*QUAKED misc_breakable_glass (1 .5 0) (-4 -4 -4) (4 4 4)
*/

void() GrenadeExplode;

void() breakable_glass_die =
{
	local float n;

 	if (self.health < self.max_health)
	{
		sound (self, CHAN_VOICE, "world/brkglas.wav", 1, ATTN_NORM);
		//sound (self, CHAN_VOICE, "glass_shatter.wav", 1, ATTN_NORM);
		setmodel (self, "models/glass64_broke.MD3");
		//self.skin = 2;
		
		for (n= 0; n < 6; n++)
			ThrowGib ("models/glass_debris_shard2.md3", self.health, GIB_GLASS, 1);
		for (n= 0; n < 4; n++)
			ThrowGib ("models/glass_debris_shard1.md3", self.health, GIB_GLASS, 1);
		for (n= 0; n < 2; n++)
			ThrowGib ("models/glass_debris1.md3", self.health, GIB_GLASS, 1);
		
		self.solid = SOLID_NOT;
		self.takedamage = DAMAGE_NO;
		pointparticles(particleeffectnum("TE_GLASS_SHATTER"), self.origin, '0 0 0', 1);
		pointparticles(particleeffectnum("glass_break"), (self.origin + '0 32 0'), '0 32 0', 1);
		pointparticles(particleeffectnum("TE_GLASS_SHATTER"), (self.origin + '0 -32 0'), '0 -32 0', 1);
		pointparticles(particleeffectnum("glass_break"), (self.origin + '0 32 -32'), '0 32 0', 1);
		pointparticles(particleeffectnum("TE_GLASS_SHATTER"), (self.origin + '0 -32 20'), '0 -32 0', 1);			
	}
	SUB_UseTargets();
	bprint (ftos(self.health));
	bprint ("\n");
}

void(entity inflictor, entity attacker, float damage, entity ignore) T_RadiusDamage;

void() breakable_glass_touch =
{
	if (other.classname == "grenade")
	{
	//	self.health = 0;
		other.think = GrenadeExplode; //SUB_Remove;
		other.nextthink = time + 0.02;
		T_RadiusDamage (self, other, 60, world); //blowback from grenade
	//	breakable_glass_die();
	}
	
	if (other.classname == "player" && self.health < (self.max_health / 2))
	{
		self.health = 0;
		breakable_glass_die();
	}
}

void(entity attacker, float damage)	breakable_glass_pain =
{
	if (self.health < (self.max_health / 2))
	{
		setmodel (self, "models/glass64_cracked.MD3");
		sound (self, CHAN_VOICE, "glass_crack.wav", 1, ATTN_NORM);
		self.touch = breakable_glass_touch;
	}
	bprint (ftos(self.health));
	bprint ("\n");
};

void() misc_breakable_glass =
{
	self.solid = SOLID_BSP;
	self.movetype = MOVETYPE_NONE;
	precache_model(self.model);
	setorigin (self, self.origin);
	setmodel (self, self.model);
	
	if (!self.health)
	{
		self.health = 20;
	}
	
	self.max_health = self.health;
	self.takedamage = DAMAGE_YES;
//	self.effects = EF_DOUBLESIDED;
	self.classname = "breakable_glass";
//	self.skin = 0;
	
	self.touch = breakable_glass_touch;
	
	self.th_die = breakable_glass_die;
	self.th_pain = breakable_glass_pain;
}; 
