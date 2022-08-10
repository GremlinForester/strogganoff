void() teleporterAfterImageFadeOUT =
{
	if (self.alpha <= 0.1){
		remove(self);
		return;
	}

	setorigin (self, self.owner.origin);

	self.alpha -= 0.1;
	self.scale -= 0.1;

	self.think = teleporterAfterImageFadeOUT;
	self.nextthink = time + 0.05;
}

void(entity ent) teleporterAfterImage =
{
	local entity afterImage;
	
	afterImage = spawn();
	afterImage.owner = ent;
	setorigin (afterImage, ent.origin);	
	afterImage.netname = "afterImage";
	setmodel (afterImage, ent.model);
	afterImage.solid = SOLID_NOT;
	afterImage.movetype = MOVETYPE_NONE;
	afterImage.angles = ent.angles;
	afterImage.frame = ent.frame;
	afterImage.scale = 1;
	afterImage.alpha = 1;
	afterImage.effects = EF_LOWPRECISION;	
	afterImage.think = teleporterAfterImageFadeOUT;
	afterImage.nextthink = time;
};

//MrC: Muzzle Flash stuff from http://www.insideqc.com/qctut/qctut-85.shtml
//Thanks Supajoe

.float isdecor;

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
	
	if(self.owner.playerType == PT_MALE)
	{
		setmodel (self, "players/male/tris.md2");
	}
	else if (self.owner.playerType == PT_FEMALE)
	{
		setmodel (self, "players/female/tris.md2");
	}
	else
	{
		setmodel (self, "players/cyborg/tris.md2");
	}

	if ((self.owner.items & IT_QUAD) && (self.owner.items & IT_INVULNERABILITY))
	{
		if(self.owner.playerType == PT_MALE)
		{
			self.skin = 15;		
		}
		else if (self.owner.playerType == PT_FEMALE)
		{
			self.skin = 10;			
		}
		else
		{
			self.skin = 3;			
		}
		
		self.alpha = 0.85;
		self.colormod = '4 1 4';
	}
	else if (self.owner.items & IT_QUAD)
	{
		if(self.owner.playerType == PT_MALE)
		{
			self.skin = 15;	
		}
		else if (self.owner.playerType == PT_FEMALE)
		{
			self.skin = 10;
		}
		else
		{
			self.skin = 3;		
		}
		
		self.alpha = 0.85;
		self.colormod = '1 1 4';
	}
	else if (self.owner.items & IT_INVULNERABILITY)
	{
		if(self.owner.playerType == PT_MALE)
		{
			self.skin = 15;	
		}
		else if (self.owner.playerType == PT_FEMALE)
		{
			self.skin = 10;			
		}
		else
		{
			self.skin = 3;
		}
		self.alpha = 0.85;
		self.colormod = '4 1 1';
	}
	else
	{
		if (autocvar_q2_classicmode >= 1)
		{
			addBitsToEntity(self,effects,EF_FULLBRIGHT);
			self.colormod = (getlight(self.owner.origin + '0 0 22') - '0.1 0.1 0.1');
			self.alpha = 0.7;
		}
		else
		{
			setmodel (self, "");
			self.colormod = '1 1 1'; //Just rest stuff to some default.
			self.alpha = 0;
			removeBitsFromEntity(self,effects,EF_FULLBRIGHT);			
		}

	//	self.alpha = 0.85;	
	//	self.skin = 99;
	//	self.effects = 0;
	//	setmodel (self, "");
	//	self.colormod = '1 1 1';
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

1st person player viewmodel effect mesh THINK and INIT

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
		self.colormod = '1 1 1';	
	}
	
	if ((self.owner.items & IT_QUAD) && (self.owner.items & IT_INVULNERABILITY))
	{
		self.alpha = 0.85;		
		self.skin = 1;
		self.colormod = '4 1 4';
	}
	else if (self.owner.items & IT_QUAD)
	{
		self.alpha = 0.85;		
		self.skin = 1;
		self.colormod = '1 1 4';
	}
	else if (self.owner.items & IT_INVULNERABILITY)
	{
		self.alpha = 0.85;		
		self.skin = 1;
		self.colormod = '4 1 1';
	}
	else
	{
	//	self.alpha = 0.85;	
	//	self.skin = 0;
		if (autocvar_q2_classicmode >= 1)
		{
		//	self.weaponmodel = "";
			self.colormod = (getlight(self.owner.origin + '0 0 22') - '0.1 0.1 0.1');
			self.alpha = 0.75;
		}
		else
		{
			setmodel (self, "");
			self.colormod = '1 1 1'; //Reset stuff?
			self.alpha = 0;
		}
	
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
	local float r = random();
	
	mflashfp = spawn();
	mflashfp.movetype = MOVETYPE_NONE;
	mflashfp.solid = SOLID_NOT;
	mflashfp.viewmodelforclient = self;
	mflashfp.owner = self;
	mflashfp.classname = "flashfp";
	mflashfp.effects = mflashfp.effects + EF_ADDITIVE;
	mflashfp.alpha = trans;
	setmodel(mflashfp, "progs/muzzleflash3.spr"); 
//	setmodel(mflashfp, "progs/combust.spr32");
	setsize(mflashfp, '0 0 0', '0 0 0');
	setorigin(mflashfp, pos);
	mflashfp.scale = mfsize;
	if (r < 1){
		mflashfp.frame = 1;	
	}
	else if (r < 0.7){
		mflashfp.frame = 2;	
	}
	else if (r < 0.4){
		mflashfp.frame = 3;	
	}
	else 
	{
		mflashfp.frame = 4;	
	}	
	mflashfp.think = SUB_Remove;
	mflashfp.nextthink = time + 0.04;

//	effect(pos, "progs/combust.spr32", 1, 5, 30);	
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

void() SetVModelOverlay_hold =
{
	if (self.owner.health <= 0)
	{
		remove(self);
		return;
	}
	
	if (self.owner.waterlevel <= 2){
		self.think = SetVModelOverlay_fade_fast; //SUB_Remove;
		self.owner.numoverlays -= 1;
	}
	else{
		self.think = SetVModelOverlay_hold;
	}
	
//	self.think = SetVModelOverlay_hold;
	self.nextthink = time + 0.1;
};

//MrC: Pass entity to one of these for self/other. TODO: Other self, this is your future self. Pass it an entity like in that tutorial you wrote.
//To future self: what tutorial?
//To past self: like the tutorial you're going to write, anyway you'll figure it out.

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


void(vector pos, string model, float skinnum, vector ColorMod, float tim, float maxoverlays, float watercheck) SetVModelOverlaySelf =
{
	local entity overlay;
	
	if (self.numoverlays >= maxoverlays + 1){
		return;
	}
	
//	FLOG(self.numoverlays);

	overlay = spawn();
	overlay.movetype = MOVETYPE_NONE;
	overlay.solid = SOLID_NOT;
	overlay.alpha = 1;
	if (watercheck = 2){
		if(self.items & IT_SUIT){
			overlay.effects = overlay.effects + EF_NOGUNBOB;// + EF_ADDITIVE;
			overlay.alpha = 0.5;			
		}
		else
		{
			overlay.effects = overlay.effects + EF_NOGUNBOB;
		}
	}
	else{
		overlay.effects = overlay.effects + EF_NOGUNBOB + EF_ADDITIVE;
	}
	overlay.viewmodelforclient = self;
	overlay.owner = self;
	overlay.classname = "client_overlay";
	overlay.colormod = ColorMod;
	overlay.skin = skinnum;
	setmodel(overlay, model);
	setorigin(overlay, pos);
	self.numoverlays++;
	
	if (watercheck >= 1){
	overlay.think = SetVModelOverlay_hold;
	}
	else{
	overlay.think = SetVModelOverlay_fade;
	}
	overlay.nextthink = time + tim;
};