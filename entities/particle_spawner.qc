/*
particle_spawner is the particle spewing version of model_static

Goal: 
Level designers place this and then reference particle effects from effectinfo.txt, set delay, toggle between on/off, make beams, etc...

START_ON
IS_RANDOM
IS_TRAIL

delay - time between firing use IS_RANDOM for delay * random() (delay * 0-1).
dmg (requires IS_TRAIL) will damage anything that gets in the way of the beam/trail.
noise will play this sound consistently if IS_RANDOM in NOT set.
noise1-3 (requires IS_RANDOM) will play these sounds at random when spawning a particle. Will also play noise 5 sounds in total.
myparticle (if using a "trail particle" (requires IS_TRAIL) otherwise will play a point particle at origin)
myendparticle (requires IS_TRAIL)
target (requires IS_TRAIL)

Trigger to toggle between ON/OFF states.

*/

//float ESTATE_ON = 1;		// Switch ON

void() particle_spawner_think =
{
	local vector dir;
	local vector org;	

	makevectors(self.angles);

	/*
	if (self.parent){
		LOG("I have a parent.");
		self.tag_entity = find(world, targetname, self.parent);	
		self.owner = find(world, targetname, self.parent);
		setorigin (self, self.origin - self.owner.origin);

		self.origin = self.origin + self.owner.origin;
	}
	*/
	
	if (self.estate == ESTATE_OFF){
		return;
	}
	else if (self.estate == ESTATE_ON)
	{
		if (self.spawnflags & IS_TRAIL)
		{
			nep_traceline (self.origin, self.origin + v_forward*4096, FALSE, self);
			org = trace_endpos - v_forward*1;
			
			if (self.target)
			{
				self.enemy = find (world, targetname, self.target);
				/*
				if (self.enemy.owner){
					trailparticles(self, particleeffectnum(self.myparticle), self.origin, self.enemy.owner.absmin);
					pointparticles(particleeffectnum(self.myendparticle), self.enemy.owner.absmin, self.angles, 1);
				}
				else
				*/
				nep_traceline (self.origin, self.enemy.absmin, FALSE, self);
				org = trace_endpos - v_forward*1;
			
				{
					trailparticles(self, particleeffectnum(self.myparticle), self.origin, org);
					pointparticles(particleeffectnum(self.myendparticle), org, self.angles, 1);
				}
			}
			else
			{
				trailparticles(self, particleeffectnum(self.myparticle), self.origin, org);
				pointparticles(particleeffectnum(self.myendparticle), org, self.angles, 1);
			}
			
			if (self.dmg){
				if (trace_ent.takedamage)
				{
					T_Damage (trace_ent, self, self, self.dmg);
				}
			}			
			
			if (self.spawnflags & IS_RANDOM){
				
				random4Noise();			
				
				self.nextthink = time + (self.delay * random());
			}
			else
			{
				if (self.spawnflags & FIRE_ONCE)
				{
					self.nextthink = -1;
				}
				else
				{

					self.nextthink = time + self.delay;
				}
				sound (self, CHAN_AUTO, self.noise, 1, ATTN_NORM);	
			}
			sound (self, CHAN_AUTO, self.noise, 1, ATTN_NORM);	
			
			self.think = particle_spawner_think;			
			return;
		}
		
		if (self.spawnflags & IS_RANDOM)
		{
			random4Noise();				
		}
		else
		{
			sound (self, CHAN_AUTO, self.noise, 1, ATTN_NORM);	
		}
		
		pointparticles(particleeffectnum(self.myparticle), self.origin, self.angles, 1);
	}

	if (self.spawnflags & IS_RANDOM){
		self.nextthink = time + (self.delay * random());
	}
	else{
		if (self.spawnflags & FIRE_ONCE){
		self.nextthink = -1;
		}
		else{
		self.nextthink = time + self.delay;
		}
	}
	self.think = particle_spawner_think;
}

void() particle_spawner_use =
{
	if (self.estate == ESTATE_ON){
		self.estate = ESTATE_OFF;
	//	self.nextthink = time + self.delay;
	//	self.think = particle_spawner_think;		
		return;
	}
	
	if (self.estate == ESTATE_OFF){
		self.estate = ESTATE_ON;
	}

	self.nextthink = time + self.delay;
	self.think = particle_spawner_think;	
}
					
void() particle_spawner_init =
{
	if (self.spawnflags & ESTATE_ON){
		self.estate = ESTATE_ON;
	}
	else
	{
		self.estate = ESTATE_OFF;
	}
	
	self.nextthink = time + self.delay;
	self.think = particle_spawner_think;
}

void() particle_spawner =
{
	self.classname = "particle_spawner";
	makevectors(self.angles);
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_NOCLIP;
	setorigin (self, self.origin);
	setmodel (self, "");
	self.effects = self.effects | EF_LOWPRECISION;
	self.avelocity = self.avelocity;
	
	self.use = particle_spawner_use;	

	VLOG(self.target1.origin);

	if (self.parent){
		LOG("I have a parent.");
		self.tag_entity = find(world, targetname, self.parent);	
		self.owner = find(world, targetname, self.parent);
		setorigin (self, self.origin - self.owner.origin);

		self.origin = self.origin + self.owner.origin;
	}

	self.nextthink = time + 0.2;
	self.think = particle_spawner_init;
};