/*======================================================================
 Player ladder (originally from Rubicon2 codebase by JohnFitz)
 - This is a very simple system, jump to attach to the ladder brush
 - move up down via jumpping (hook in preplayer code)
 - Added multiple climbing sounds (works with player footsound state)
 - Modified to have on/off/toggle state via triggers
 - Downsides to system, there is no abilty to go down a ladder
/*======================================================================
/*QUAKED trigger_ladder (.5 .5 .5) ? x x x x x x STARTOFF x Not_Easy Not_Normal Not_Hard Not_DM
Invisible brush based ladder (jump key to climb)
-------- KEYS --------
targetname : trigger entity (works with entity state system)
angle    : direction player must be facing to climb ladder (required)
waitmin  : time between climb sound (def = depends on sound type)
speed    : velocity speed to climb ladder (def=160)
sounds   : 1=metal, 2=wood, 3=rope, 4=silent, 5=custom (def=wood)
noise1-4 : custom sounds to play when climbing ladder
-------- SPAWNFLAGS --------
STARTOFF : Starts off and waits for trigger
-------- NOTES --------
Invisible brush based ladder (jump key to climb)
This entity cannot be damaged and is always touchable once activated

======================================================================*/
void() trigger_ladder_fire =
{
	// This is after bmodel _use, _killed and _touch, so any reference
	// to the trigger activator has to go through 'bmodel_act'
	
	// prevent the player "sticking" to a ladder if they are standing on
	// the platform at the top of the ladder with the bottom of their
	// bounding box flush with the top of the trigger -- iw
	if (other.absmin_z + 1 >= self.absmax_z - 1)
		return;	
	
	//hacky targetname workaround because i'm lazy and haven't fully implemented entity states yet from AD
	if (self.spawnflags & ENT_STARTOFF)
		self.touch = trigger_ladder_fire;

	// Ladders ONLY work with players because of client.qc (PlayerPreThink)
	if (self.estate & ESTATE_BLOCK) return;
	if ( !(other.flags & FL_CLIENT) ) return;
	if ( other.health < 1 ) return;

	// Don't stick underwater, or in the middle of a waterjump
	if (other.waterlevel > 1) return;
	if (other.flags & FL_WATERJUMP) return;

	other.onladder = 1;		// Add everytime the player touches volume
	other.entladder = self;	// Link back to play sounds
	
	if (other.flags & FL_ONGROUND)
		other.flags = other.flags - FL_ONGROUND;	//fix for getting stuck on floor inside trigger
};

void() ladder_touch =
{
	// from Copper -- dumptruck_ds
//	if (!CheckValidTouch()) return;

	// prevent the player "sticking" to a ladder if they are standing on
	// the platform at the top of the ladder with the bottom of their
	// bounding box flush with the top of the trigger -- iw
	if (other.absmin_z + 1 >= self.absmax_z - 1)
		return;

	// if the trigger has an angles field, check player's facing direction
	if (self.movedir != '0 0 0')
	{
		makevectors (other.angles);
		if (v_forward * self.movedir < 0)
			return;		// not facing the right way
	}
	other.onladder = 1;
}


void(vector org, float height, vector rot) make_ladderVolume = 
{
	local entity ladderVolume;
	local vector ladderHeight;
	
	ladderVolume = spawn();
	ladderVolume.classname = "ladder_volume";
	ladderVolume.solid = SOLID_TRIGGER;
	ladderVolume.movetype = MOVETYPE_NONE;
	ladderVolume.angles = rot;
	setorigin(ladderVolume, org);
		bprint ("ladder volume created: ");
		bprint (vtos(ladderVolume.origin));
		bprint (vtos(ladderVolume.angles));
		bprint ("\n");
	ladderHeight_x = 0;
	ladderHeight_y = 0;
	ladderHeight_z = height;
	ladderVolume.speed = 160;
	ladderVolume.sounds = 1;
	ladderVolume.waitmin = 0.45;
	ladderVolume.noise1 = "player/clank1.wav";
	ladderVolume.noise2 = "player/clank2.wav";
	ladderVolume.noise3 = "player/clank3.wav";
	ladderVolume.noise4 = "player/clank4.wav";
	ladderVolume.touch = trigger_ladder_fire;
	setsize(ladderVolume, '-16 -16 -24', '16 16 32' + ladderHeight); //'-4 -16 -24', '4 16 32'
};

/*QUAKED misc_banner (1 .5 0) (-4 -4 -4) (4 4 4)
The origin is the bottom of the banner.
The banner is 128 tall.
*/

void() misc_banner_think =
{
	if (self.frame >= 15)
	{
		self.frame = 0;
	}
	else
	{
		self.frame++;
	}
	
	self.think = misc_banner_think;
	self.nextthink = time + 0.1;
}

void() misc_banner =
{
	local float r;

	r = random() * 4;
	
	if (r < 1)
	{
		self.frame = 3;
	}
	else if (r < 2)
	{
		self.frame = 7;
	}
	else if (r < 3)
	{
		self.frame = 10;
	}
	else
	{
		self.frame = 0;
	}
		
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_NONE;
	precache_model ("models/objects/banner/tris.md2");
	setmodel (self, "models/objects/banner/tris.md2");

	//self.health = 20;
	//self.th_die = banner_die;
	//self.takedamage = DAMAGE_AIM;
	self.classname = "misc_banner";
	self.think = misc_banner_think;
	self.nextthink = time + 0.1;
};

void() misc_deadsoldier_die =
{
	local float n;
	
 	if (self.health < -30)
	{
		sound (self, CHAN_VOICE, "misc/udeath.wav", 1, ATTN_NORM);
/* 		for (n= 0; n < 2; n++){
		ThrowGib ("models/objects/gibs/bone/tris.md2", self.health, GIB_FLESH, 1);
		}
		for (n= 0; n < 4; n++){
		ThrowGib ("models/objects/gibs/sm_meat/tris.md2", self.health, GIB_FLESH, 1);
		}
		ThrowGib ("models/objects/gibs/head2/tris.md2", self.health, GIB_FLESH, 1);
		ThrowGib ("progs/gib1.mdl", self.health, GIB_FLAMING);
		ThrowGib ("progs/gib2.mdl", self.health, GIB_FLAMING);
		ThrowGib ("progs/gib3.mdl", self.health, GIB_FLAMING); */
		
		for (n= 0; n < 2; n++)
			ThrowGib ("models/objects/gibs/bone/tris.md2", self.health, GIB_FLESH);
		for (n= 0; n < 4; n++)
			ThrowGib ("models/objects/gibs/sm_meat/tris.md2", self.health, GIB_FLESH);
		
		TossGibs ("models/objects/gibs/bone/tris.md2", self.health, 8, GIB_FLESH);
		
		ThrowHead ("models/objects/gibs/head2/tris.md2", self.health);
		
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
	else
		self.frame = 0;

	self.th_die = misc_deadsoldier_die;
	self.takedamage = DAMAGE_AIM;
};

void() target_activator_touch =
{
}

void() target_activator =
{
	self.classname = "target_activator";
	precache_model(self.model);
	
	activator = self;
	
	self.movetype = MOVETYPE_NOCLIP;
	self.solid = SOLID_TRIGGER;
	setmodel (self, self.model);
	setorigin (self, self.origin);
	self.scale = (self.modelscale);
	self.health = (self.health);
	self.angles = self.angles;
	setsize (self, '-16 -16 0', '16 16 16');
	self.avelocity = self.avelocity;
	self.touch = target_activator_touch;
	if (self.target != "")
	{
		self.tag_entity = find(world, targetname, self.target);
	}
}

/*QUAKED func_train_activator (0 .5 .8) ?
Trigger brushes that can follow a path and activate other triggers. Good for setting off a chain of events.

speed	default 100
dmg		default	2

*/
void() func_train_activator =
{	
	if (!self.speed)
		self.speed = 100;

	activator = self;
	
	self.cnt = 1;
//	self.solid = SOLID_TRIGGER; //SOLID_BBOX;
	self.use = train_use;
	self.classname = "player"; //dumb fix for trigger check
//	self.movetype = MOVETYPE_FLY;
	
	self.solid = SOLID_TRIGGER;
	self.movetype = MOVETYPE_FLY;
	
	setmodel (self, self.model);
	setsize (self, self.mins , self.maxs);
	setorigin (self, self.origin);

// moved because the non-remove option is to leave an inert solid platform
	if (!self.target)
#ifdef noobjerr
	{

#ifdef xvars1
		if (cvar("svx_platdoorfail") < 0) // remove option
		{
			remove(self);
			return;
		}
		else
#endifdef
		return;
	}
#else
		objerror ("func_train_activator without a target");					//opgrade protected
#endifdef


// start trains on the second frame, to make sure their targets have had
// a chance to spawn
	self.nextthink = self.ltime + 0.1;
	self.think = func_train_find;
};

/*QUAKED func_timer (0.3 0.1 0.6) (-8 -8 -8) (8 8 8) START_ON
"wait"			base time between triggering all targets, default is 1
"random"		wait variance, default is 0

so, the basic time between firing is a random time between
(wait - random) and (wait + random)

"delay"			delay before first firing when turned on, default is 0

"pausetime"		additional delay used only the very first time
				and only if spawned with START_ON

These can used but not touched.
*/

void() func_timer_think  =
{
	SUB_UseTargets ();
//	self.nextthink = time + self.wait + crandom() * self.random;
}

void() func_timer_use =
{
	SUB_UseTargets();
}

.float wait;
.float delay;

void() func_timer =
{
	self.classname = "func_timer";

	activator = self;
	
	if (!self.wait)
	{
		self.wait = 1;
	}
	if (!self.delay)
	{
		self.delay = 1;
	}

	if (self.spawnflags & START_ON)
	{
		self.nextthink = time + self.delay;
		self.think = func_timer_use;

	}
	
	self.use = func_timer_use;
}