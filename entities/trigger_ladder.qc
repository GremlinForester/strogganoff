/*======================================================================
MrC: Grabbed this ladder code from the Quake 1.5 codebase. Left any comments as-is.
/*======================================================================

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

void() trigger_ladder =
{
	// Default = wood
	if (!self.sounds) self.sounds = 2;
	if (self.sounds == 1) {				// Metal
		if(!self.waitmin) self.waitmin = 0.45;
		self.noise1 = "player/ladmetal1.wav";
		self.noise2 = "player/ladmetal2.wav";
		self.noise3 = "player/ladmetal3.wav";
		self.noise4 = "player/ladmetal4.wav";
	}
	else if (self.sounds == 2) {		// Wood
		if(!self.waitmin) self.waitmin = 0.4;
		self.noise1 = "player/ladwood1.wav";
		self.noise2 = "player/ladwood2.wav";
		self.noise3 = "player/ladwood3.wav";
		self.noise4 = "player/ladwood4.wav";
	}
	else if (self.sounds == 3) {		// Old Rope
		if(!self.waitmin) self.waitmin = 0.7;
		self.noise1 = "player/ladrope1.wav";
		self.noise2 = "player/ladrope2.wav";
		self.noise3 = "player/ladrope3.wav";
		self.noise4 = "player/ladrope4.wav";
	}
	else {
		// Custom or empty
		if (!self.waitmin) self.waitmin = 0.5;
		if (self.noise1 == "") self.noise1 = SOUND_EMPTY;
		if (self.noise2 == "") self.noise2 = SOUND_EMPTY;
		if (self.noise3 == "") self.noise3 = SOUND_EMPTY;
		if (self.noise4 == "") self.noise4 = SOUND_EMPTY;
	}
	precache_sound(self.noise1);
	precache_sound(self.noise2);
	precache_sound(self.noise3);
	precache_sound(self.noise4);
	
//	self.classtype = CT_TRIGLADDER;
	InitTrigger ();
	if (!self.speed) self.speed = 160;
	// No trigger damage functionality and always touchable!
//	self.spawnflags = self.spawnflags | TRIG_ALWAYTOUCH | TRIG_NODAMAGE;

	// Cannot have ladder triggers touched by monsters
//	self.spawnflags = self.spawnflags - (self.spawnflags & TRIG_MONSTERS);

	// Setup Entity State functionality
	//self.estate_fire = trigger_ladder_fire;
	if (self.spawnflags & ENT_STARTOFF) {
		self.touch = SUB_Null;
		self.use = trigger_ladder_fire;
	}
	else
		self.touch = trigger_ladder_fire;
	//trigger_bmodel_setup();
};
