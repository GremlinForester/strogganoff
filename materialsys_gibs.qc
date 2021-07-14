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
	
	r = random() * 2;
	if (r < 1) 		sound(self, CHAN_BODY, "glass_smash1.wav", 0.75, ATTN_IDLE);
	else if (r < 2) sound(self, CHAN_BODY, "glass_smash2.wav", 0.75, ATTN_IDLE);
	else 			sound(self, CHAN_BODY, "glass_smash3.wav", 0.75, ATTN_IDLE);
		
	pointparticles(particleeffectnum("TE_GLASS_SHATTER"), self.origin, '0 0 0', 1);
	
	remove(self);
}

void() Gib_Touch =
{
	if (other.classname == "player"){
		remove(self);
	}
	
	if (self.velocity <= 10){
		self.avelocity = '0 0 0';
		self.angles = '0 90 0';
	}
	
	if (self.modelflags == MF_GIB){
		SpawnBlood (self.origin, '0 0 20', 55);
	}
	else{
		pointparticles(particleeffectnum("TE_WOODIMPACT"), self.origin, '0 0 0', 1);
	}
	self.think = GibThinkRemove;
	self.nextthink = time + 0.1;
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
	if (other.classname == "player"){ //MrC: Add a screen effect, blood on the lens.
		SpawnBlood (self.origin, '0 0 20', 55);
//		SetVModelOverlayOther('0 0 0', "models/overlay.md3", OVERLAY_RAIN, '1 0 0');
	remove(self);
	}
	else if (self.velocity >= '10 10 10'){
	sound (self, CHAN_BODY, "zombie/z_miss.wav", 0.8, ATTN_NORM);
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
	self.solid = SOLID_NOT;
	self.think = GibPhysicsThinkRemove;
	self.nextthink = time + GIB_LIFE;
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
/*
void(string gibname, float dm, float GibType, float GibScale) ThrowGib =
{
	local float t;
	local	entity gib;
	local 	vector v;

	v = randompos(self.mins, self.maxs) + self.origin;

	gib = spawn();
	gib.origin = ((v + (random () * '0 50 50')) - (random () * '0 50 50'));
	setmodel (gib, gibname);
	setsize (gib, VEC_ORIGIN, VEC_ORIGIN);
	//setorigin (gib, ((self.origin + (random () * (self.mins + '0 0 100'))) - (random () * self.mins + '0 0 100')));
	gib.velocity = 1.11 * (VelocityForDamage (dm));
	gib.movetype = MOVETYPE_TOSS;
	gib.modelflags = EF_NOMODELFLAGS;
	gib.avelocity_x = ((random()*5) * (VelocityForDamage (dm)));
	gib.avelocity_y = ((random()*7) * (VelocityForDamage (dm)));
	gib.avelocity_z = ((random()*4) * (VelocityForDamage (dm)));
	gib.scale = GibScale; //((random()*1) + (random()*1.1));
	gib.solid = SOLID_TRIGGER;
	gib.bouncefactor = 0.5;
	gib.bouncestop = 0.1;
	gib.mass = 100;
	gib.think = GibPhysicsThink;
	gib.nextthink = time + 0.2;
	
	//	gib.ltime = time;
	switch(GibType)
	{
		case GIB_NONE:
			break;
		case GIB_FLESH:
			gib.modelflags = MF_GIB;
			gib.touch = Gib_Touch_Flesh;
			break;
		case GIB_METAL:
			gib.touch = Gib_Touch_Metal;
			break;
		case GIB_WOOD:
			gib.touch = Gib_Touch_Wood;
			break;
		case GIB_GLASS:
			break;
		case GIB_FLAMING:
			gib.modelflags = MF_ROCKET;
			gib.avelocity_x = random()*900;
			gib.avelocity_y = random()*800;
			gib.avelocity_z = random()*700;
			gib.velocity = 3.11 * (VelocityForDamage (dm));
			gib.touch = GibPhysicsThinkRemove;
			break;
	}
};
*/

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
	new.think = GibPhysicsThink; //SUB_Remove;
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
	new.think = GibPhysicsThink; //SUB_Remove;
	new.ltime = time;
	new.nextthink = time + 0.3 + random()*0.3;
	new.frame = 0;
	new.flags = 0;
	//physics_addforce(new, self.origin * 900000 , '500 600 700');
};

//
//	SPRITE DEBRIS FRAMES
//

/*
void()	smokepuff1	=	[0,	smokepuff2] {};
void()	smokepuff2	=	[1,	smokepuff3] {};
void()	smokepuff3	=	[2,	smokepuff4] {};
void()	smokepuff4	=	[3,	smokepuff5] {};
void()	smokepuff5	=	[4,	smokepuff6] {};
void()	smokepuff6	=	[5,	smokepuff7] {};
void()	smokepuff7	=	[6,	smokepuff8] {};
void()	smokepuff8	=	[7,	smokepuff9] {};
void()	smokepuff9	=	[8,	smokepuff10] {};
void()	smokepuff10	=	[9,	smokepuff11] {};
void()	smokepuff11	=	[10,	smokepuff12] {};
void()	smokepuff12	=	[11,	smokepuff13] {};
void()	smokepuff13	=	[12,	smokepuff14] {};
void()	smokepuff14	=	[13,	smokepuff15] {};
void()	smokepuff15	=	[14,	smokepuff16] {};
void()	smokepuff16	=	[15,	smokepuff17] {};
void()	smokepuff17	=	[16,	smokepuff18] {};
void()	smokepuff18	=	[17,	smokepuff19] {};
void()	smokepuff19	=	[18,	SUB_Remove] {};


void(vector org) SpawnSpriteDebris =	//Spawns a puff of smoke
{
	newmis = spawn();
	newmis.movetype = MOVETYPE_NONE;
	newmis.classname = "smoke";
	newmis.touch = SUB_Null;
	newmis.velocity = '0 0 0';  //Note that you could mess with the movetype and give it a z velocity for rising smoke..
	newmis.effects = newmis.effects | EF_ADDITIVE;
	setmodel(newmis, "progs/smokepuff.spr");
	newmis.solid = SOLID_NOT;
	setsize(newmis, '0 0 0', '0 0 0');
	setorigin(newmis, org);
	newmis.think = smokepuff1;
	newmis.nextthink = time + 0.1;
};
*/

/*
void(float dm, float GibType, float GibScale) SpawnSpriteDebris =
{
	local float t;
	local	entity gib;
	local 	vector v;

	v = randompos(self.mins, self.maxs) + self.origin;

	gib = spawn();
	gib.origin = ((v + (random () * '0 50 50')) - (random () * '0 50 50'));
	setmodel (gib, "");
	newmis.classname = "spritedebris";
	setsize (gib, VEC_ORIGIN, VEC_ORIGIN);
	gib.velocity = 1.11 * (VelocityForDamage (dm));
	gib.movetype = MOVETYPE_TOSS;
	newmis.touch = SUB_Null;
	gib.modelflags = EF_NOMODELFLAGS;
	gib.avelocity_x = ((random()*5) * (VelocityForDamage (dm)));
	gib.avelocity_y = ((random()*7) * (VelocityForDamage (dm)));
	gib.avelocity_z = ((random()*4) * (VelocityForDamage (dm)));
	gib.scale = GibScale; //((random()*1) + (random()*1.1));
	gib.solid = SOLID_NOT;
	gib.think = SUB_Remove; //Default doesn't spawn anything?
	gib.nextthink = time + 0.2;
	
	//	gib.ltime = time;
	switch(GibType)
	{
		case GIB_NONE:
			break;
		case GIB_FLESH:
			setmodel (gib, "progs/smokepuff.spr");
			gib.think = FleshSpriteDebris1;
			gib.modelflags = MF_GIB;
			gib.touch = Gib_Touch_Flesh;
			break;
		case GIB_METAL:
			setmodel (gib, "progs/smokepuff.spr");
			gib.think = MetalSpriteDebris1; //Wood frames
			gib.touch = Gib_Touch_Metal;
			break;
		case GIB_WOOD:
			setmodel (gib, "progs/smokepuff.spr");
			gib.think = WoodSpriteDebris1; //Wood frames
			gib.touch = Gib_Touch_Wood;
			break;
		case GIB_GLASS:
			setmodel (gib, "progs/smokepuff.spr");
			gib.think = GlassSpriteDebris1; //Wood frames
			gib.touch = Gib_Touch_Glass;
			break;
		case GIB_FLAMING:
			setmodel (gib, "progs/smokepuff.spr");
			gib.modelflags = MF_ROCKET;
			gib.avelocity_x = random()*900;
			gib.avelocity_y = random()*800;
			gib.avelocity_z = random()*700;
			gib.velocity = 3.11 * (VelocityForDamage (dm));
			gib.touch = GibPhysicsThinkRemove;
			break;
	}
};
*/
// SpawnSmoke(self.origin + v_forward * 16 + v_right * 4 + '0 0 16');

void(string gibname, float dm, float GibType) ThrowGib =
{
//	local	entity new;

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
	nspawn.think = SUB_Remove;
	nspawn.ltime = time;
	nspawn.nextthink = time + 10 + random()*10;
//	nspawn.frame = 0;
//	nspawn.flags = 0;


		switch(GibType)
		{
		case GIB_NONE:
			nspawn.modelflags = EF_NOMODELFLAGS;
		break;
		
		case GIB_FLESH:
			nspawn.modelflags = MF_GIB;
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
