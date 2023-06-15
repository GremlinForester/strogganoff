void(vector org, vector vec) LaunchLaser;

void() spikeshooter_use =
{
	if (self.spawnflags & SPAWNFLAG_LASER)
	{
		sound (self, CHAN_VOICE, "enforcer/enfire.wav", 1, ATTN_NORM);
		LaunchLaser (self.origin, self.movedir);
	}
	else
	{
		sound (self, CHAN_VOICE, "weapons/spike2.wav", 1, ATTN_NORM);
		launch_spike (self.origin, self.movedir);
		newmis.velocity = self.movedir * 500;
		if (self.spawnflags & SPAWNFLAG_SUPERSPIKE)
		{
			newmis.touch = superspike_touch;
			newmis.dmg = 18;
		}
	}
};

void() shooter_think =
{
	spikeshooter_use ();
	self.nextthink = time + self.wait;
	newmis.velocity = self.movedir * 500;
};

/*QUAKED trap_shooter (0 .5 .8) (-8 -8 -8) (8 8 8) superspike laser
Continuously fires spikes.
"wait" time between spike (1.0 default)
"nextthink" delay before firing first spike, so multiple shooters can be stagered.
*/
void() trap_shooter =
{
	trap_spikeshooter ();
	
	if (! self.wait) // == 0)
		self.wait = 1;
	self.nextthink = self.nextthink + self.wait + self.ltime;
	self.think = shooter_think;
};

/*QUAKED trap_shooter_custom (0 .5 .8) (-8 -8 -8) (8 8 8)
Fires a customized projectile entity.
-------- KEYS --------
<angle key="angle" name="Yaw Angle">angle to fire</angle>
<real key="wait" name="Firing Delay" value="1">time between spawns (1.0 default)</real>
<real key="count" name="Lifetime" value="1">how long the projectile lives in the world (10 default)</real>
<real key="speed" name="Projectile Speed" value="500">the speed of the projectile</real>
<string key="noise" name="Noise">Sound to play.</string>
<real key="nextthink" name="Start Delay">delay before firing first, so multiple shooters can be staggered</real>
<model key="model" name="Model File">Path/name of model to use (e.g. models/mapobjects/teleporter/teleporter.md3).</model>
*/

void() custom_projectile_touch =
{
	if (other == self.owner)
		return;
	
	if (pointcontents(self.origin) == CONTENT_SOLID){
		LOG("Cutom Projectile removed on CONTENT_SOLID");
		remove(self);
	}	

	if (trace_dphitq3surfaceflags & Q3SURFACEFLAG_FORCEFIELD)
	{
		remove(self);
		return;
	}	

	if (other.health)
	{
		T_Damage (other, self, self.owner, self.owner.dmg );
	}
};

void(vector org, vector dir) launch_shooter_custom_projectile =
{
	newmis = spawn ();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_PUSH; //MOVETYPE_FLYMISSILE;
	newmis.solid = SOLID_BSP; //SOLID_BBOX;

	makevectors(self.angles);

	newmis.angles = vectoangles(dir);
	newmis.angles_x = newmis.angles_x * -1; //why come have do this?

	if (self.noise)
		sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);

	newmis.touch = custom_projectile_touch;
	newmis.classname = "custom_projectile";
	newmis.think = SUB_Remove;
	newmis.nextthink = time + self.count;
	setmodel (newmis, self.model);
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);		
	setorigin (newmis, org);

	newmis.velocity = dir * self.speed;
	
	SUB_UseTargets ();
};

void() shooter_custom_use =
{
	launch_shooter_custom_projectile (self.origin, self.movedir);
	newmis.velocity = self.movedir * self.speed;
		
	if (self.noise)
		sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);
};

void() shooter_custom_think =
{
	shooter_custom_use ();
	self.nextthink = time + self.wait;
	newmis.velocity = self.movedir * self.speed;
};

void() trap_shooter_custom_init =
{
	SetMovedir();

	self.use = shooter_custom_use;

	if (self.model)
	precache_model (self.model);

	if (self.noise)
	precache_sound (self.noise);
}

void() trap_shooter_custom =
{
	trap_shooter_custom_init();
	
	if (! self.wait) // == 0)
		self.wait = 1;

	if (! self.speed) // == 0)
		self.speed = 500;
	
	if (! self.count)
		self.count = 10;
	
	if (! self.dmg)
		self.dmg = 200;
	
	self.nextthink = self.nextthink + self.wait + self.ltime;
	
	if (self.spawnflags & IS_RANDOM) //4
	{		
		self.nextthink = self.ltime + (self.wait * random());
	}	
	
	self.think = shooter_custom_think;
};
