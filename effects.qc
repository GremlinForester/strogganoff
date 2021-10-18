//MrC: Muzzle Flash stuff from http://www.insideqc.com/qctut/qctut-85.shtml
//Thanks Supajoe

.float isdecor;

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

void () SetVModelOverlay_fade =
{
	if (!self.alpha)
		self.alpha = 1;

	self.alpha = self.alpha - 0.04;
	
	if (self.alpha < 0.02){
	//	self.overlay_active_count--;
		self.think = SUB_Remove;
	}
	else{
		self.think = SetVModelOverlay_fade;
	}

	self.nextthink = time + 0.1;
};

void(vector pos, string model, float skinnum, vector ColorMod) SetVModelOverlayOther =
{
	local entity overlay;
	
	//if (other.overlay_active_count >= 2){
	//	return;
	//}

	//other.overlay_active_count++;	
	overlay = spawn();
	overlay.movetype = MOVETYPE_NONE;
	overlay.solid = SOLID_NOT;
	overlay.effects = overlay.effects + EF_ADDITIVE + EF_NOGUNBOB; //EF_NODEPTHTEST
	overlay.viewmodelforclient = other;
	overlay.owner = other;
	overlay.classname = "client_overlay";
	overlay.alpha = 1;
	overlay.colormod = ColorMod;
	overlay.skin = skinnum;
	setmodel(overlay, model);
	setorigin(overlay, pos);
	overlay.think = SetVModelOverlay_fade;
	overlay.nextthink = time + 0.1;
};