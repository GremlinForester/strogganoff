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

// MrC: Thanks goes to Quake 1.5 for pointing me in the right direction on this.

/*
===========
Client effects:
3rd person weapon model
3rd person powerup effects shell effects (quad/invul/invis)
1st person viewmodel powerup shell effects (quad/invul/invis)

called in PutClientInServer in client.qc
============
*/

/*
===========

3rd person player model effect entity THINK and INIT

============
*/

void() update_plrpowerupshell_frames =
{
	if (self.owner.health <= 0)
	{
		remove(self);
		return;
	}

	if ((self.owner.items & IT_QUAD) && (self.owner.items & IT_INVULNERABILITY))
	{
		if(self.owner.playerType == PT_MALE)
		{
			setmodel (self, "players/male/tris.md2");
			self.skin = 15;		
		}
		else if (self.owner.playerType == PT_FEMALE)
		{
			setmodel (self, "players/female/tris.md2");
			self.skin = 10;			
		}
		else
		{
			setmodel (self, "players/cyborg/tris.md2");
			self.skin = 3;			
		}
		
		self.alpha = 0.85;
		self.colormod = '4 1 4';
	}
	else if (self.owner.items & IT_QUAD)
	{
		if(self.owner.playerType == PT_MALE)
		{
			setmodel (self, "players/male/tris.md2");
			self.skin = 15;	
		}
		else if (self.owner.playerType == PT_FEMALE)
		{
			setmodel (self, "players/female/tris.md2");
			self.skin = 10;
		}
		else
		{
			setmodel (self, "players/cyborg/tris.md2");
			self.skin = 3;		
		}
		
		self.alpha = 0.85;
		self.colormod = '1 1 4';
	}
	else if (self.owner.items & IT_INVULNERABILITY)
	{
		if(self.owner.playerType == PT_MALE)
		{
			setmodel (self, "players/male/tris.md2");
			self.skin = 15;	
		}
		else if (self.owner.playerType == PT_FEMALE)
		{
			setmodel (self, "players/female/tris.md2");
			self.skin = 10;			
		}
		else
		{
			setmodel (self, "players/cyborg/tris.md2");
			self.skin = 3;
		}
		
		self.alpha = 0.85;
		self.colormod = '4 1 1';
	}
	else
	{
		self.alpha = 0.85;	
		self.skin = 99;
	//	self.effects = 0;
		setmodel (self, "");
		self.colormod = '1 1 1';
	//	remove(self);		
	}
	
	if (self.owner.items & IT_INVISIBILITY){
		removeBitsFromEntity(self,effects,EF_FULLBRIGHT);
		self.alpha = 0.05;		
	}
	else
	{
		if(!self.effects & EF_FULLBRIGHT)
		{
			addBitsToEntity(self,effects,EF_FULLBRIGHT);
		}
		self.alpha = 0.85;	
	}
	
	self.frame = self.owner.frame;	
	self.think = update_plrpowerupshell_frames;
	self.nextthink = time;
};

void() spawnPLRpowerupShell =
{
	local entity plrpowerupShell;	

	plrpowerupShell = spawn();
	setorigin (plrpowerupShell, '0 0 0');
	plrpowerupShell.owner = self;
	plrpowerupShell.netname = "plrpowerupShell";
	plrpowerupShell.solid = SOLID_NOT;
	plrpowerupShell.scale = 1.06;	
	plrpowerupShell.movetype = MOVETYPE_NOCLIP;
	plrpowerupShell.exteriormodeltoclient = self;
	plrpowerupShell.effects = plrpowerupShell.effects | EF_FULLBRIGHT;	
	plrpowerupShell.think = update_plrpowerupshell_frames;
	plrpowerupShell.nextthink = time;
	setattachment(plrpowerupShell, self, "");	
};

/*
===========

3rd person weapon model entity THINK and INIT

============
*/

void() UpdateTPWeaponFrames =
{
	if (self.owner.health <= 0)
	{
		remove(self);
		return;
	}

	if (self.owner.playerType == PT_MALE)
	{
		switch (self.owner.weapon)
		{
		case WEP_BLASTER:
			setmodel (self, "players/male/w_blaster.md2");
			break;
		case WEP_SHOTGUN:
			setmodel (self, "players/male/w_shotgun.md2");
			break;
		case WEP_SUPERSHOTGUN:
			setmodel (self, "players/male/w_sshotgun.md2");
			break;
		case WEP_MACHINEGUN:
			setmodel (self, "players/male/w_machinegun.md2");
			break;
		case WEP_CHAINGUN:
			setmodel (self, "players/male/w_chaingun.md2");
			break;
		case WEP_GRENADE_LAUNCHER:
			setmodel (self, "players/male/w_glauncher.md2");
			break;
		case WEP_ROCKET_LAUNCHER:
			setmodel (self, "players/male/w_rlauncher.md2");
			break;
		case WEP_RAILGUN:
			setmodel (self, "players/male/w_railgun.md2");
			break;
		case WEP_HYPERBLASTER:
			setmodel (self, "players/male/w_hyperblaster.md2");
			break;
		case WEP_BFG:
			setmodel (self, "players/male/w_bfg.md2");
			break;
		}	
	}
	
	if (self.owner.playerType == PT_FEMALE)
	{
		switch (self.owner.weapon)
		{
		case WEP_BLASTER:
			setmodel (self, "players/female/w_blaster.md2");
			break;
		case WEP_SHOTGUN:
			setmodel (self, "players/female/w_shotgun.md2");
			break;
		case WEP_SUPERSHOTGUN:
			setmodel (self, "players/female/w_sshotgun.md2");
			break;
		case WEP_MACHINEGUN:
			setmodel (self, "players/female/w_machinegun.md2");
			break;
		case WEP_CHAINGUN:
			setmodel (self, "players/female/w_chaingun.md2");
			break;
		case WEP_GRENADE_LAUNCHER:
			setmodel (self, "players/female/w_glauncher.md2");
			break;
		case WEP_ROCKET_LAUNCHER:
			setmodel (self, "players/female/w_rlauncher.md2");
			break;
		case WEP_RAILGUN:
			setmodel (self, "players/female/w_railgun.md2");
			break;
		case WEP_HYPERBLASTER:
			setmodel (self, "players/female/w_hyperblaster.md2");
			break;
		case WEP_BFG:
			setmodel (self, "players/female/w_bfg.md2");
			break;
		}
	}
	
	if (self.owner.playerType == PT_OTHER)
	{
		switch (self.owner.weapon)
		{
		case WEP_BLASTER:
			setmodel (self, "players/cyborg/w_blaster.md2");
			break;
		case WEP_SHOTGUN:
			setmodel (self, "players/cyborg/w_shotgun.md2");
			break;
		case WEP_SUPERSHOTGUN:
			setmodel (self, "players/cyborg/w_sshotgun.md2");
			break;
		case WEP_MACHINEGUN:
			setmodel (self, "players/cyborg/w_machinegun.md2");
			break;
		case WEP_CHAINGUN:
			setmodel (self, "players/cyborg/w_chaingun.md2");
			break;
		case WEP_GRENADE_LAUNCHER:
			setmodel (self, "players/cyborg/w_glauncher.md2");
			break;
		case WEP_ROCKET_LAUNCHER:
			setmodel (self, "players/cyborg/w_rlauncher.md2");
			break;
		case WEP_RAILGUN:
			setmodel (self, "players/cyborg/w_railgun.md2");
			break;
		case WEP_HYPERBLASTER:
			setmodel (self, "players/cyborg/w_hyperblaster.md2");
			break;
		case WEP_BFG:
			setmodel (self, "players/cyborg/w_bfg.md2");
			break;
		}		
	}

	if (self.owner.items & IT_INVISIBILITY){
		self.alpha = .05;
		self.owner.alpha = 0.05;
	}
	else{
		self.alpha = 1;
		self.owner.alpha = 1; //yea this is sort of dumb putting this here, didn't work in CheckPowerups and I've reached fuckit.
	}
		
	if (self.owner.items & IT_QUAD)
		self.effects = EF_NOSHADOW;
	else
	#ifdef q2model_lighting
			self.effects = EF_FULLBRIGHT;
	#endif
	#ifndef q2model_lighting
			self.effects = 0;
	#endif

	#ifdef q2model_lighting
	self.colormod = getlight(self.owner.origin); //MrC Lightgrid workaround
	#endif
	self.frame = self.owner.frame;
	
	self.think = UpdateTPWeaponFrames;
	self.nextthink = time;
};

void() AttachTPWeapon =
{
	local entity playerTPWeapon;
	
	playerTPWeapon = spawn();
	setorigin (playerTPWeapon, '0 0 0');
	playerTPWeapon.owner = self;
//	setorigin (playerTPWeapon, self.owner.origin);
	playerTPWeapon.netname = "playerTPWeapon";
	playerTPWeapon.solid = SOLID_NOT;
	playerTPWeapon.movetype = MOVETYPE_NOCLIP;
	playerTPWeapon.exteriormodeltoclient = self;
	
	#ifdef q2model_lighting
	playerTPWeapon.effects = EF_FULLBRIGHT; //MrC Lightgrid workaround
	#endif	
	
	playerTPWeapon.think = UpdateTPWeaponFrames;
	playerTPWeapon.nextthink = time;

	setattachment(playerTPWeapon, self, "");
};

/*
===========

1st person player model effect mesh THINK and INIT

============
*/

void() updatePowerupShellFrames =
{
	if (self.owner.health <= 0)
	{
		remove(self);
		return;
	}
	
	switch (self.owner.weapon)
	{
	case WEP_BLASTER:
		setmodel (self, "models/weapons/v_blast/tris.md2");
		break;
	case WEP_SHOTGUN:
		setmodel (self, "models/weapons/v_shotg/tris.md2");
		break;
	case WEP_SUPERSHOTGUN:
		setmodel (self, "models/weapons/v_shotg2/tris.md2");
		break;
	case WEP_MACHINEGUN:
		setmodel (self, "models/weapons/v_machn/tris.md2");
		break;
	case WEP_CHAINGUN:
		setmodel (self, "models/weapons/v_chain/tris.md2");
		break;
	case WEP_GRENADE_LAUNCHER:
		setmodel (self, "models/weapons/v_launch/tris.md2");
		break;
	case WEP_ROCKET_LAUNCHER:
		setmodel (self, "models/weapons/v_rocket/tris.md2");
		break;
	case WEP_RAILGUN:
		setmodel (self, "models/weapons/v_rail/tris.md2");
		break;
	case WEP_HYPERBLASTER:
		setmodel (self, "models/weapons/v_hyperb/tris.md2");
		break;
	case WEP_BFG:
		setmodel (self, "models/weapons/v_bfg/tris.md2");
		break;
	}	

	//this needs work!

	if (self.owner.items & IT_INVISIBILITY)
	{
		self.skin = 0;
		self.alpha = 0.2;
		removeBitsFromEntity(self,effects,EF_FULLBRIGHT);		
		//	self.colormod = '1 1 1';	
	}
	
	if ((self.owner.items & IT_QUAD) && (self.owner.items & IT_INVULNERABILITY))
	{
		self.alpha = 0.85;		
		self.skin = 1;
		self.colormod = '4 1 4';
	}
	else if (self.owner.items & IT_QUAD)
	{
		if(!self.effects & EF_FULLBRIGHT)
		{
			addBitsToEntity(self,effects,EF_FULLBRIGHT);
		}		
		self.alpha = 0.85;		
		self.skin = 1;
		self.colormod = '1 1 4';
	}
	else if (self.owner.items & IT_INVULNERABILITY)
	{
		if(!self.effects & EF_FULLBRIGHT)
		{
			addBitsToEntity(self,effects,EF_FULLBRIGHT);
		}		
		self.alpha = 0.85;		
		self.skin = 1;
		self.colormod = '4 1 1';
	}
	else
	{
		if(!self.effects & EF_FULLBRIGHT)
		{
			addBitsToEntity(self,effects,EF_FULLBRIGHT);
		}
		self.alpha = 0.85;	
		self.skin = 0;
	//	self.effects = 0;
		setmodel (self, "");
		self.colormod = '1 1 1';		
	}
	
	self.frame = self.owner.weaponframe;	
	self.think = updatePowerupShellFrames;
	self.nextthink = time;
};

void() spawnPowerupShell =
{
	local entity powerupShell;

	powerupShell = spawn();
	powerupShell.movetype = MOVETYPE_NONE;
	powerupShell.solid = SOLID_NOT;
	powerupShell.viewmodelforclient = self;
	powerupShell.owner = self;
	powerupShell.classname = "powerupShell";
	powerupShell.alpha = 0.85;
	setsize(powerupShell, '0 0 0', '0 0 0');
	setorigin(powerupShell, '-0.1 0.1 0.1');
	powerupShell.scale = 1.06;
	powerupShell.effects = powerupShell.effects | EF_FULLBRIGHT;	
	powerupShell.think = updatePowerupShellFrames;
	powerupShell.nextthink = time + 0.1;	
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

//MrC: TODO: deathbubbles and other built-in particle effects should be replaced by a generic particle spawner that uses effectinfo
//need particle spawner like particle_spawner for level designers

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

//Thanks to LadyHavoc for DPMOD from which the newdecor/breakable stuff is based. 

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
float maxoverlays = 4; //FIXME: should be field not global?

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

//MrC: Pass entity to one of these for self/other.

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