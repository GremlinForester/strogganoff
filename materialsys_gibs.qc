void(vector org, vector vel, float damage) SpawnBlood;

vector(float dm) VelocityForDamage =
{
	local vector v;

	v_x = 100 * crandom();
	v_y = 100 * crandom();
	v_z = 200 + 100 * random();

	if (dm > -50)
	{
//		dprint ("level 1\n");
		v = v * 0.7;
	}
	else if (dm > -200)
	{
//		dprint ("level 3\n");
		v = v * 2;
	}
	else
		v = v * 10;

	return v;
};

//********************************************
//				GIBS
//********************************************


//
// GIB TOUCH EVENTS
//

//void(vector pos, string model, int skinnum, vector ColorMod) SetVModelOverlayOther;

void () GibThinkRemove =
{
	if (self.modelflags == MF_GIB)
	{
		SpawnBlood (self.origin, '0 0 20', 55);
	}
	else
	{
		pointparticles(particleeffectnum("TE_WOODIMPACT"), self.origin, '0 0 0', 1);
	}
	remove(self);
}


void() Glass_Touch =
{
	local float r;

	if (pointcontents(self.origin) == CONTENT_SOLID){
		LOG("Removed stuck debris!");
		remove(self);
		return;
	}
	
	r = random() * 2;
	if (r < 1) 		sound(self, CHAN_BODY, "glass_smash1.wav", 0.75, ATTN_IDLE);
	else if (r < 2) sound(self, CHAN_BODY, "glass_smash2.wav", 0.75, ATTN_IDLE);
	else 			sound(self, CHAN_BODY, "glass_smash3.wav", 0.75, ATTN_IDLE);
		
	pointparticles(particleeffectnum("TE_GLASS_SHATTER"), self.origin, '0 0 0', 1);
	
	remove(self);
}

void() GibPhysicsThinkRemove;

void() Gib_Touch =
{
	if (self.modelflags == MF_GIB){
		SpawnBlood (self.origin, '0 0 20', 55);
	}
	else{
		pointparticles(particleeffectnum("TE_WOODIMPACT"), self.origin, '0 0 0', 1);
	}
}

void() Gib_Touch_Wood =
{
	if (other.classname == "player"){
	remove(self);
	}
	
	if (self.velocity >= '10 10 10'){
	sound (self, CHAN_BODY, "weapons/bounce.wav", 0.3, ATTN_NORM);
	Gib_Touch();
	}
}

void() Gib_Touch_Metal =
{
	if (other.classname == "player"){
	remove(self);
	}
	
	if (self.velocity >= '10 10 10'){
	sound (self, CHAN_BODY, "weapons/bounce.wav", 0.3, ATTN_NORM);
	Gib_Touch();
	}
}

void() Gib_Touch_Flesh =
{
	if (pointcontents(self.origin) == CONTENT_SOLID){
		LOG("Removed stuck debris!");
		remove(self);
		return;
	}
	
	if (other.classname == "player"){
		SpawnBlood (self.origin, '0 0 20', 55);
		
		if (random() < 0.3){
		SetVModelOverlayOther('0 0 0', "models/overlay.md3", OVERLAY_BLOODSPLAT1, '1 0 0', 0);
		}
		else if (random() < 0.5){
		SetVModelOverlayOther('0 0 0', "models/overlay.md3", OVERLAY_BLOODSPLAT2, '1 0 0', 0);
		}
		else if (random() < 0.8){
		SetVModelOverlayOther('0 0 0', "models/overlay.md3", OVERLAY_BLOODSPLAT3, '1 0 0', 0);
		}
		else{
		SetVModelOverlayOther('0 0 0', "models/overlay.md3", OVERLAY_BLOODSPLAT4, '1 0 0', 0);
		}
		
//		SetVModelOverlayOther('0 0 0', "models/overlay.md3", OVERLAY_RAIN, '1 0 0');
	//remove(self);
	}
	else if (self.velocity >= '10 10 10'){
	sound (self, CHAN_BODY, "zombie/z_miss.wav", 0.5, ATTN_NORM);
	}
	else{
	Gib_Touch();
	}
}

//
// GIB THINK
//

void () GibPhysicsThinkRemove =
{
	if (self.modelflags == MF_GIB){
		SpawnBlood (self.origin, '0 0 20', 55);
	}
	else{
		pointparticles(particleeffectnum("TE_WOODIMPACT"), self.origin, '0 0 0', 1);
	}
	remove(self);
}


void () GibPhysicsThinkPreRemove =
{
	if (pointcontents(self.origin) == CONTENT_SOLID){
		LOG("Removed stuck debris!");
		remove(self);
		return;
	}
			
	self.solid = SOLID_NOT;
	self.think = GibPhysicsThinkRemove;
	self.nextthink = time + GIB_LIFE + random()*10;;
}

void () GibPhysicsThink =
{
	if (cvar("physics_ode"))
	{
		self.solid = SOLID_BSP;
		self.movetype = MOVETYPE_PHYSICS;
		physics_enable( self, TRUE );
		self.think = GibPhysicsThinkPreRemove; //SUB_Remove;
		self.nextthink = (time + 5) + (random()*0.5);
	}
	//BecomeDPExplosionBounce();
	self.movetype = MOVETYPE_BOUNCE;
	self.think = GibPhysicsThinkPreRemove; //SUB_Remove;
	self.nextthink = time + 0.2;
}

void(string gibname, float dm) ThrowGibFlamingPhysics =
{
	local	entity new;

	new = spawn();
	new.origin = self.origin;
	setmodel (new, gibname);
	setsize (new, '0 0 0', '0 0 0');
	new.velocity = VelocityForDamage (dm);
	new.movetype = MOVETYPE_PHYSICS;
	new.solid = SOLID_BSP;
	new.modelflags = MF_ROCKET;
	new.avelocity_x = random()*1600;
	new.avelocity_y = random()*1600;
	new.avelocity_z = random()*1600;
	new.think = SUB_Remove;
	new.ltime = time;
	new.nextthink = time + 1 + random()*1;
	new.frame = 0;
	new.flags = 0;
	physics_enable( self, TRUE );
	new.bouncefactor = 0.5;
	new.bouncestop = 0.1;
	new.mass = 100;
};

void(string gibname, float dm) ThrowHeadPhysics =
{
	local	entity new;

	new = spawn();
	new.origin = self.origin;
	setmodel (new, gibname);
	setsize (new, '0 0 0', '0 0 0');
	new.velocity = VelocityForDamage (dm);
	new.movetype = MOVETYPE_TOSS;
	new.solid = SOLID_BSP;
	new.avelocity_x = random()*600;
	new.avelocity_y = random()*600;
	new.avelocity_z = random()*600;
	new.think = SUB_Remove; //GibPhysicsThink;
	new.ltime = time;
	new.nextthink = time + 0.3 + random()*0.3;
	new.frame = 0;
	new.flags = 0;
};

void(string gibname, float dm) ThrowGibPhysics =
{
	local	entity new;

	new = spawn();
	new.origin = self.origin;
	setmodel (new, gibname);
	setsize (new, '0 0 0', '0 0 0');
	new.velocity = VelocityForDamage (dm);
	//new.movetype = MOVETYPE_PHYSICS;
	new.movetype = MOVETYPE_TOSS;
	if (cvar("physics_ode"))
	{
		new.solid = SOLID_BSP;
	}
	else
	{
		new.solid = SOLID_NOT;
	}
    new.modelflags = MF_GIB; //MF_ZOMGIB; 
	new.avelocity_x = random()*600;
	new.avelocity_y = random()*600;
	new.avelocity_z = random()*600;
	new.think = SUB_Remove; //GibPhysicsThink;
	new.ltime = time;
	new.nextthink = time + 0.3 + random()*0.3;
	new.frame = 0;
	new.flags = 0;
	//physics_addforce(new, self.origin * 900000 , '500 600 700');
};

void(string gibname, float dm, float GibType) ThrowGib =
{
	nspawn = spawn();
	nspawn.origin = self.origin;
	setmodel (nspawn, gibname);
	setsize (nspawn, '0 0 0', '0 0 0');
	nspawn.velocity = VelocityForDamage (dm);
	nspawn.movetype = MOVETYPE_BOUNCE;
	nspawn.solid = SOLID_BBOX;
	nspawn.avelocity_x = random()*600;
	nspawn.avelocity_y = random()*600;
	nspawn.avelocity_z = random()*600;
	nspawn.think = GibPhysicsThinkPreRemove;
	nspawn.ltime = time;
	nspawn.nextthink = time + 10 + random()*10;

	switch(GibType)
	{
	case GIB_NONE:
		nspawn.modelflags = EF_NOMODELFLAGS;
	break;
		
	case GIB_FLESH:
		nspawn.solid = SOLID_TRIGGER;
		nspawn.modelflags = MF_GIB;
		nspawn.touch = Gib_Touch_Flesh;
		nspawn.nextthink = time + 1;
	break;
	
	case GIB_METAL:
	break;
		
	case GIB_FLAMING:
		nspawn.modelflags = MF_ROCKET;
		nspawn.avelocity_x = random()*900;
		nspawn.avelocity_y = random()*800;
		nspawn.avelocity_z = random()*700;
		nspawn.velocity = 3.11 * (VelocityForDamage (dm));
		nspawn.touch = SUB_Remove;
	break;
		
	case GIB_GLASS:
		nspawn.modelflags = EF_NOMODELFLAGS;
		nspawn.effects = EF_ADDITIVE;
		nspawn.touch = Glass_Touch;
	break;
	}
}

.float isdecor;
void(entity e, vector org, vector vel, string gibname, float GibType) ThrowDebris =
{
	if (e)
		e = newdecor(e);
	else
	{
		// if in danger of running out of entities, don't spawn any new ones
		if (numdecors >= 16384)
			return;
		e = newdecor(world);
		e.angles = randomvec() * 360;
	}
	e.classname = "gib";
	e.cnt = 30 * (0.5 + random());
	setorigin(e, org);
	setmodel (e, gibname);
	setsize (e, '0 0 -2', '0 0 -2');
	e.velocity = vel + randomvec() * 150;
	e.movetype = MOVETYPE_BOUNCE;
	e.avelocity = randomvec()*300;
	e.takedamage = DAMAGE_YES;
	e.touch = Gib_Touch;
	e.th_die = SUB_Null;
	e.th_pain = SUB_Null;
	e.think = GibPhysicsThinkPreRemove;
	e.solid = SOLID_BBOX;
	e.nextthink = time;

	switch(GibType)
	{
	case GIB_NONE:
		e.modelflags = EF_NOMODELFLAGS;
	break;
		
	case GIB_FLESH:
		e.solid = SOLID_TRIGGER;
		e.modelflags = MF_GIB;
		e.touch = Gib_Touch_Flesh;
		e.nextthink = time + 1;
	break;
		
	case GIB_METAL:
	break;
	
	case GIB_FLAMING:
		e.modelflags = MF_ROCKET;
		e.avelocity_x = random()*900;
		e.avelocity_y = random()*800;
		e.avelocity_z = random()*700;
		e.velocity = VelocityForDamage(100);
		e.touch = SUB_Remove;
	break;
		
	case GIB_GLASS:
		e.modelflags = EF_NOMODELFLAGS;
		e.effects = EF_ADDITIVE;
		e.think = SUB_Null;
		e.touch = Glass_Touch;
	break;
	}
	
	if (cvar("dpmod_odephysics"))
	{
		e.movetype = MOVETYPE_PHYSICS;
		e.solid = SOLID_PHYSICS_BOX;
		e.mass = 5;
		setmodel(e, e.model); // setmodel sets mins/maxs
	}
};

void(string gibname, float dm) ThrowHead =
{
	setmodel (self, gibname);
	self.frame = 0;
	self.nextthink = -1;
	self.movetype = MOVETYPE_BOUNCE;
	self.takedamage = DAMAGE_NO;
	self.solid = SOLID_NOT;
	self.view_ofs = '0 0 8';
	setsize (self, '-16 -16 0', '16 16 56');
	self.velocity = VelocityForDamage (dm);
	self.origin_z = self.origin_z - 24;
	self.flags = self.flags - (self.flags & FL_ONGROUND);
	self.avelocity = crandom() * '0 600 0';
}

void(string model, float dmg, float amt, float gibtype) TossGibs
{
		local float n;
	
		for (n = 1; n < amt; n++)
		ThrowGib (model, dmg, gibtype);
}
