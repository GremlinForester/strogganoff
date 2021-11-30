//MrC: Muzzle Flash stuff from http://www.insideqc.com/qctut/qctut-85.shtml
//Thanks Supajoe

.float isdecor;

void() make_bubbles;
void() bubble_bob;

vector() wall_velocity =
{
	local vector	vel;
	
	vel = normalize (self.velocity);
	vel = normalize(vel + v_up*(random()- 0.5) + v_right*(random()- 0.5));
	vel = vel + 2*trace_plane_normal;
	vel = vel * 200;
	
	return vel;
};


/*
================
SpawnMeatSpray
================
*/
void(vector org, vector vel) SpawnMeatSpray =
{
#define missile 	newmis
//	local	entity missile;//, mpuff;	// fx_warning
//	local	vector	org;

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
//	missile.solid = SOLID_NOT;

	makevectors (self.angles);

	missile.velocity = vel;
	missile.velocity_z = missile.velocity_z + 250 + 50*random();

	missile.avelocity = '3000 1000 2000';
	
// set missile duration
	missile.nextthink = time + 1;
	missile.think = SUB_Remove;

	setmodel (missile, "progs/zom_gib.mdl");
	setsize (missile, '0 0 0', '0 0 0');		
	setorigin (missile, org);
#undef missile
};

/*
================
SpawnBlood
================
*/
void(vector org, vector vel, float damage) SpawnBlood =
{
	particle (org, vel*0.1, 73, damage*2);
};

/*
================
spawn_touchblood
================
*/
void(float damage) spawn_touchblood =
{
	local vector	vel;

	vel = wall_velocity () * 0.2;
	SpawnBlood (self.origin + vel*0.01, vel, damage);
};


/*
================
SpawnChunk
================
*/
#ifdef unused
void(vector org, vector vel) SpawnChunk =
{
	particle (org, vel*0.02, 0, 10);
};

#endif

void() DeathBubblesSpawn =
{
//local entity	bubble;

#ifndef opgrade
	if (self.owner.health > 1) // was a previous opgrade - not sure of intent, removes spawner after respawn
	if (self.owner.waterlevel != 3)
		{
#ifdef codefix
			remove(self);	// remove bubble spawner
#endif
			return;
		}
#endif
/*
	bubble = spawn();
	setmodel (bubble, "progs/s_bubble.spr");
	setorigin (bubble, self.owner.origin + '0 0 24');
	bubble.movetype = MOVETYPE_NOCLIP;
	bubble.solid = SOLID_NOT;
	bubble.velocity = '0 0 15';
	bubble.nextthink = time + 0.5;
	bubble.think = bubble_bob;
	bubble.classname = "bubble";
	bubble.frame = 0;
	bubble.cnt = 0;
	setsize (bubble, '-8 -8 -8', '8 8 8');
*/
// note: fn sets think - the calling code below always resets it
	make_bubbles();
	nspawn.touch = SUB_Null;
#ifndef opgrade
	setorigin (nspawn, self.owner.origin + '0 0 24'); // can eliminate this step by setting it below
#endif

	self.nextthink = time + 0.1;

	self.think = DeathBubblesSpawn;
	self.air_finished = self.air_finished + 1;
	if (self.air_finished >= self.bubble_count)
		remove(self);
};

void(float num_bubbles) DeathBubbles =
{
#define bubble_spawner newmis
//local entity	bubble_spawner;
	
	bubble_spawner = spawn();
	setorigin (bubble_spawner, self.origin
#ifdef opgrade
																					 + '0 0 24'
#endif
	);
//	bubble_spawner.movetype = MOVETYPE_NONE;
//	bubble_spawner.solid = SOLID_NOT;
	bubble_spawner.nextthink = time
#ifdef opgrade
									 			+ 0.01;
#else
												 + 0.1;
#endif
	bubble_spawner.think = DeathBubblesSpawn;
//	bubble_spawner.air_finished = 0;
	bubble_spawner.owner = self;
	bubble_spawner.bubble_count = num_bubbles;
//	return;

#undef bubble_spawner
};

entity(entity e) newdecor =
{
	if (e == world)
	{
		e = spawn();
		e.classname = "decor";
	}
	if (e.classname == "decor")
		numdecors = numdecors + 1;
	// set up common defaults
	e.isdecor = TRUE;
	//e.createdtime = time;
	e.cnt = 10 * (0.5 + random());
	e.alpha = 1;
	e.effects = EF_LOWPRECISION;
	e.flags = e.flags - (e.flags & FL_ONGROUND);
	e.groundentity = world;
	e.movetype = MOVETYPE_NONE;
	e.solid = SOLID_NOT;
	e.frame = 0;
//	e.havocattack = FALSE;
	e.touch = SUB_Null;
//	e.traileffectnum = particleeffectnum("TE_EXPLOSION");
	return e;
};

/*
============
MUZZLE FLASH EFFECTS
============
*/

void(vector org, float mfsize) SpawnMuzzleFlashTP =
{
	local entity mflashtp;

	mflashtp = spawn();
	mflashtp.movetype = MOVETYPE_NOCLIP;
	mflashtp.classname = "flashtp";
	mflashtp.owner = self;
	setattachment(mflashtp, self, "");
	mflashtp.touch = SUB_Null;
	mflashtp.effects = mflashtp.effects + EF_ADDITIVE;
	setmodel(mflashtp, "progs/muzzleflash3.spr");
	mflashtp.solid = SOLID_NOT;
	mflashtp.scale = mfsize;
	setsize(mflashtp, '0 0 0', '0 0 0');
	setorigin(mflashtp, org);
	mflashtp.exteriormodeltoclient = self;
	mflashtp.think = SUB_Remove;
	mflashtp.angles = self.angles;
	mflashtp.nextthink = time + 0.02;
};

void(vector pos, float mfsize, float trans) SpawnMuzzleFlash =			//Spawns a first person muzzleflash
{
	local entity mflashfp;
	
	mflashfp = spawn();
	mflashfp.movetype = MOVETYPE_NONE;
	mflashfp.solid = SOLID_NOT;
	mflashfp.viewmodelforclient = self;
	mflashfp.owner = self;
	mflashfp.classname = "flashfp";
	mflashfp.effects = mflashfp.effects + EF_ADDITIVE;
	mflashfp.alpha = trans;
	setmodel(mflashfp, "progs/muzzleflash3.spr");
	setsize(mflashfp, '0 0 0', '0 0 0');
	setorigin(mflashfp, pos);
	mflashfp.scale = mfsize;
	mflashfp.think = SUB_Remove;
	mflashfp.nextthink = time + 0.04;
};

.float numoverlays;
float maxoverlays = 4;

void() SetVModelOverlay_fade_fast =
{
	if (self.owner.health <= 0)
	{
		remove(self);
		return;
	}
	
	if (!self.alpha)
		self.alpha = 1;

	self.alpha = self.alpha - 0.04;
	
	if (self.alpha < 0.02){
		self.think = SUB_Remove;
		self.owner.numoverlays -= 1;
	}
	else{
		self.think = SetVModelOverlay_fade_fast;
	}

	self.nextthink = time + 0.01;
};


void() SetVModelOverlay_fade =
{
	if (self.owner.health <= 0)
	{
		remove(self);
		return;
	}
	
	if (!self.alpha)
		self.alpha = 1;

	self.alpha = self.alpha - 0.04;
	
	if (self.alpha < 0.02){
		self.think = SUB_Remove;
		self.owner.numoverlays -= 1;
	}
	else{
		self.think = SetVModelOverlay_fade;
	}

	self.nextthink = time + 0.1;
};

void(vector pos, string model, float skinnum, vector ColorMod, float additive) SetVModelOverlayOther =
{
	local entity overlay;

	if (other.classname != "player")
		return;
		
	if (other.numoverlays >= 4){
		return;
	}
	
	FLOG(other.numoverlays);

	//other.overlay_active_count++;	
	overlay = spawn();
	overlay.movetype = MOVETYPE_NONE;
	overlay.solid = SOLID_NOT;
	overlay.effects = overlay.effects + EF_NOGUNBOB;
	if (additive)
		overlay.effects = overlay.effects + EF_ADDITIVE;
	overlay.viewmodelforclient = other;
	overlay.owner = other;
	overlay.classname = "client_overlay";
	overlay.alpha = 1;
	overlay.colormod = ColorMod;
	overlay.skin = skinnum;
	setmodel(overlay, model);
	setorigin(overlay, pos);
	other.numoverlays++;
	overlay.think = SetVModelOverlay_fade;
	overlay.nextthink = time + 0.1;
};


void(vector pos, string model, float skinnum, vector ColorMod, float tim, float maxoverlays) SetVModelOverlaySelf =
{
	local entity overlay;
	
	if (self.numoverlays >= maxoverlays + 1){
		return;
	}
	
//	FLOG(self.numoverlays);

	overlay = spawn();
	overlay.movetype = MOVETYPE_NONE;
	overlay.solid = SOLID_NOT;
	overlay.effects = overlay.effects + EF_ADDITIVE + EF_NOGUNBOB; //EF_NODEPTHTEST
	overlay.viewmodelforclient = self;
	overlay.owner = self;
	overlay.classname = "client_overlay";
	overlay.alpha = 1;
	overlay.colormod = ColorMod;
	overlay.skin = skinnum;
	setmodel(overlay, model);
	setorigin(overlay, pos);
	self.numoverlays++;
	overlay.think = SetVModelOverlay_fade;
	overlay.nextthink = time + tim;
};

void(vector pos, string model, float skinnum, vector ColorMod, float tim, float scl) SetVModelHUDSelf =
{
	local entity overlay;
		
	overlay = spawn();
	overlay.movetype = MOVETYPE_NONE;
	overlay.solid = SOLID_NOT;
	overlay.effects = overlay.effects + EF_NOGUNBOB + EF_NODEPTHTEST + EF_FULLBRIGHT;
	overlay.viewmodelforclient = self;
	overlay.owner = self;
	overlay.classname = "hud_model";
	overlay.alpha = 1;
	overlay.colormod = ColorMod;
	overlay.skin = skinnum;
	overlay.scale = scl;
	setmodel(overlay, model);
	setorigin(overlay, pos);
	overlay.think = SetVModelOverlay_fade_fast;
	overlay.nextthink = time + tim;
};

void() UpdateHUDPowerup =
{
	if (self.owner.health <= 0)
	{
		remove(self);
		return;
	}
	
	switch (self.owner.player_pickup_itemnum){
		case INV_PICKUP_NONE:
				setmodel(self, "");
			break;		
		case INV_PICKUP_QUAD:
				setmodel(self, "models/items/quaddama/tris.md2");
			break;
		case INV_PICKUP_REBREATHER:
				setmodel(self, "models/items/breather/tris.md2");
			break;
		case INV_PICKUP_INVISIBILITY:
				setmodel(self, "models/items/armor/screen/tris.md2");			
			break;
		case INV_PICKUP_SILENCER:
				setmodel(self, "models/items/silencer/tris.md2");		
			break;
		case INV_PICKUP_INVULNERABILITY:
				setmodel(self, "models/items/invulner/tris.md2");			
			break;
		case INV_PICKUP_ENVIROSUIT:
				setmodel(self, "models/items/enviro/tris.md2");			
			break;
	}
	self.avelocity = '0 100 0';
	self.think = UpdateHUDPowerup;
	self.nextthink = time;
};

.float bCreateHUDPowerup;

void(vector pos, string model, float skinnum, vector ColorMod, float tim, float scl) createHUDPowerup =
{
	local entity overlay;
	
	if (self.bCreateHUDPowerup == 1)
		return; //coop bug to remove duplicate hud models
	
	overlay = spawn();
	overlay.movetype = MOVETYPE_NOCLIP;
	overlay.solid = SOLID_NOT;
	overlay.effects = overlay.effects + EF_NOGUNBOB + EF_NODEPTHTEST + EF_FULLBRIGHT;
	overlay.viewmodelforclient = self;
	overlay.owner = self;
	overlay.classname = "hud_model";
	overlay.alpha = 1;
	overlay.colormod = ColorMod;
	overlay.skin = skinnum;
	overlay.scale = scl;
	setmodel(overlay, model);
	setorigin(overlay, pos);
	overlay.think = UpdateHUDPowerup;
	overlay.nextthink = time;
	self.bCreateHUDPowerup = 1;
};