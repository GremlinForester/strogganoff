//MrC: Muzzle Flash stuff from http://www.insideqc.com/qctut/qctut-85.shtml
//Thanks Supajoe

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