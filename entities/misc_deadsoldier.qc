void() misc_deadsoldier_die =
{
	local float n;
	
 	if (self.health < -30)
	{
		sound (self, CHAN_VOICE, "misc/udeath.wav", 1, ATTN_NORM);

		TossGibs ("models/objects/gibs/bone/tris.md2", self.health, 5, GIB_FLESH, 1);		
		TossGibs ("models/objects/gibs/arm/tris.md2", self.health, 2, GIB_FLESH, 1);
		TossGibs ("models/objects/gibs/leg/tris.md2", self.health, 2, GIB_FLESH, 1);
		ThrowGib ("models/objects/gibs/sm_meat/tris.md2", self.health, GIB_FLESH, 1);
		ThrowGib ("models/objects/gibs/head/tris.md2", self.health, GIB_FLESH, 1);
		
		remove(self);
		return;
	} 
};

float ON_BACK = 1;
float ON_STOMACH= 2;
float BACK_DECAP = 4;
float FETAL_POS = 8;
float SIT_DECAP = 16;
float IMPALED = 32;

/*QUAKED misc_deadsoldier (1 .5 0) (-16 -16 0) (16 16 16) ON_BACK ON_STOMACH BACK_DECAP FETAL_POS SIT_DECAP IMPALED
This is the dead player model. Comes in 6 exciting different poses!
*/
void() misc_deadsoldier =
{
	self.classname = "misc_deadsoldier";
	
	self.solid = SOLID_CORPSE;
	self.movetype = MOVETYPE_NONE;
	precache_model ("models/deadbods/dude/tris.md2");
	setmodel (self, "models/deadbods/dude/tris.md2");
	//makestatic (self);
	setsize (self, '-16 -16 0', '16 16 16');
	self.health = 20;

	// Defaults to frame 0
	if (self.spawnflags & ON_STOMACH){
	self.frame = 1;
	}
	else if (self.spawnflags & BACK_DECAP){
		self.frame = 2;
	}
	else if (self.spawnflags & FETAL_POS){
		self.frame = 3;
	}
	else if (self.spawnflags & SIT_DECAP){
		self.frame = 4;
	}
	else if (self.spawnflags & IMPALED){
		self.frame = 5;
	}
	else{
		self.frame = 0;
	}

	self.th_die = misc_deadsoldier_die;
	self.takedamage = DAMAGE_AIM;
};
