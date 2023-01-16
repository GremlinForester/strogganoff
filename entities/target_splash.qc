void() target_splash_use =
{
	local float n;
	local vector vel = self.movedir * self.speed;

	if (self.dmg){
		T_RadiusDamage (self, self.owner, self.dmg, other);
	}

	switch(self.sounds)
	{
		case 1: //SPARKS
			Impact_Spark(self.origin);
		break;
		
		case 2: //WATER
			pointparticles(particleeffectnum("watersplash"), self.origin, vel, 1);
		break;
		
		case 3: //FLIES
			pointparticles(particleeffectnum("monsterfliesbrown"), self.origin, vel, 1);
		break;
		
		case 4: //SLIME
			pointparticles(particleeffectnum("slimesplash_small"), self.origin, vel, 1);		
		break;
		
		case 5: //LAVA
			pointparticles(particleeffectnum("lavasplash"), self.origin, vel, 1);	
		break;    
		
		case 6: //BLOOD
			SpawnBlood (self.origin, self.movedir * self.speed, self.speed * 4);
		break;
	}
}

void() target_splash =
{

/*
"sounds"
  1) sparks
  2) blue water
  3) flies
  4) slime
  5) lava
  6) blood
"speed"
particle velocity (blood)
*/
	
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_NOCLIP;
	setorigin (self, self.origin);
	setmodel (self, "");
	
	if (!self.speed)
		self.speed = 10;

	makevectors(self.angles);
	SetMovedir ();
	
	self.use = target_splash_use;
}

