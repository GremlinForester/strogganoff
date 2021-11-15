/*======================================================================
MrC: This ladder code is from the Quake 1.5 codebase. Left any comments as-is.
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
#endif
		return;
	}
#else
		objerror ("func_train_activator without a target");					//opgrade protected
#endif


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

	if (self.spawnflags & ESTATE_ON)
	{
		self.nextthink = time + self.delay;
		self.think = func_timer_use;

	}
	
	self.use = func_timer_use;
}

/*QUAKED target_speaker (1 0 0) (-8 -8 -8) (8 8 8) looped-on looped-off reliable changelevel
"noise"		wav file to play
"attenuation"

-1 = none, send to whole level
 1 = normal fighting sounds
 2 = idle sound level
 3 = ambient sound level
"volume"	0.0 to 1.0

Normal sounds play each time the target is used.  The reliable flag can be set for crucial voiceovers.

Looped sounds are always atten 3 / vol 1, and the use function toggles it on/off.
Multiple identical looping sounds will just increase volume without any speed cost.
*/

.float volume;
.float attenuation;

void() target_speaker_think =
{
	local float chan;
	
	if (self.spawnflags & 1)
	{	// looping sound toggles
		if (self.noise) 
		{
			//pointsound(self.origin, self.noise, self.volume, self.attenuation);
			sound7(self, CHAN_VOICE, self.noise, self.volume, self.attenuation, self.speed, self.flags);
			self.nextthink = time + soundlength(self.noise);
		}
		else 
		{
			self.nextthink = -1;
		}
	}
	/*
	bprint("\n"); 
	bprint("target_speaker at "); 
	bprint(vtos(self.origin));
	bprint(", CHAN:"); 
	bprint(ftos(chan));
	bprint(", SOUND:"); 
	bprint(self.noise);
	bprint(", VOL:"); 
	bprint(ftos(self.volume));
	bprint(", ATT:"); 
	bprint(ftos(self.attenuation));
	bprint(", SPEED:"); 
	bprint(ftos(self.speed));
	bprint(", FLG:"); 
	bprint(ftos(self.flags));
	bprint("\n");
	*/	
	self.think = target_speaker_think;
}

void target_speaker_use ()
{
	local float	chan;

	if (self.spawnflags & 3)
	{	// looping sound toggles
		if (self.noise) 
		{
			self.noise = "";	// turn it off
			self.nextthink = -1;
		}
		else 
		{
			self.nextthink = time + soundlength(self.noise);
			self.think = target_speaker_think;
			//self.noise = self.noise;	// start it
		}
	}
	else
	{
		if (self.attenuation == -2) 
		{
			if(self.spawnflags & 4)
				chan = CHAN_VOICE|SOUNDFLAG_RELIABLE;
			else
				chan = CHAN_VOICE;
			//gi.sound (activator, chan, ent->noise_index, 1, ATTN_NORM, 0);
			//void(vector origin, string sample, float volume, float attenuation) pointsound
			//pointsound(self.origin, self.noise, self.volume, self.attenuation);
			sound7(self, chan, self.noise, self.volume, self.attenuation, 0, 0);
		}
		else
		{	// normal sound
			if (self.spawnflags & 4)
				chan = CHAN_VOICE|SOUNDFLAG_RELIABLE;
			else
				chan = CHAN_VOICE;
			// use a positioned_sound, because this entity won't normally be
			// sent to any clients because it is invisible
			//gi.positioned_sound (ent->s.origin, ent, chan, ent->noise_index, ent->volume, ent->attenuation, 0);
			//pointsound(self.origin, self.noise, self.volume, self.attenuation);
			sound7(self, CHAN_VOICE, self.noise, self.volume, self.attenuation, 100, self.flags);
		}
		self.nextthink = time + soundlength(self.noise);
	}
}

void() target_speaker =
{
	if(!(self.spawnflags & 8))
	{
		if(!self.noise)
		{
			dprint("target_speaker with no noise set at "); 
			dprint(vtos(self.origin));
			return;
		}
		// DWH: Use "message" key to store noise for speakers that change levels
		//      via trigger_transition
		/*if (!strstr (st.noise, ".wav"))
		{
			ent->message = gi.TagMalloc(strlen(st.noise)+5,TAG_LEVEL);
			sprintf(ent->message, "%s.wav", st.noise);
		}
		else
		{
			ent->message = gi.TagMalloc(strlen(st.noise)+1,TAG_LEVEL);
			strcpy(ent->message, st.noise);
		}*/
	}

	if (!self.volume)
		self.volume = 1.0;

	if (!self.attenuation)
		self.attenuation = (self.spawnflags & 1) ? 3.0 : 1.0;
	else if (self.attenuation == -1)	// use -1 so 0 defaults to 1
		self.attenuation = 0;

	// check for prestarted looping sound
/*	if (self.spawnflags & 1) {
		self.noise = self.noise;
		self.attenuation = self.attenuation;
	}*/
	
	precache_sound (self.noise);
	self.use = target_speaker_use;
	self.think = target_speaker_think;
	self.nextthink = time + soundlength(self.noise);
}

/*QUAKED func_rotating (0 .5 .8) ? START_ON REVERSE X_AXIS Y_AXIS TOUCH_PAIN STOP ANIMATED ANIMATED_FAST
You need to have an origin brush as part of this entity.  The center of that brush will be
the point around which it is rotated. It will rotate around the Z axis by default.  You can
check either the X_AXIS or Y_AXIS box to change that.

"speed" determines how fast it moves; default value is 100.
"dmg"	damage to inflict when blocked (2 default)

REVERSE will cause the it to rotate in the opposite direction.
STOP mean it will stop moving instead of pushing entities
*/
/*
#define ROTATING_ACCEL	0x2000
void rotating_accel (edict_t *self)
{
	float	current_speed;

	current_speed = VectorLength (self->avelocity);
	if(current_speed >= (self->speed - self->accel))		// done
	{
		VectorScale (self->movedir, self->speed, self->avelocity);
		G_UseTargets (self, self);
	}
	else
	{
		current_speed += self->accel;
		VectorScale (self->movedir, current_speed, self->avelocity);
		self->think = rotating_accel;
		self->nextthink = level.time + FRAMETIME;
	}
}

void rotating_decel (edict_t *self)
{
	float	current_speed;

	current_speed = VectorLength (self->avelocity);
	if(current_speed <= self->decel)		// done
	{
		VectorClear (self->avelocity);
		G_UseTargets (self, self);
		self->touch = NULL;
	}
	else
	{
		current_speed -= self->decel;
		VectorScale (self->movedir, current_speed, self->avelocity);
		self->think = rotating_decel;
		self->nextthink = level.time + FRAMETIME;
	}
}

void rotating_touch (edict_t *self, edict_t *other, cplane_t *plane, csurface_t *surf)
{
	if (self->avelocity[0] || self->avelocity[1] || self->avelocity[2])
		T_Damage (other, self, self, vec3_origin, other->s.origin, vec3_origin, self->dmg, 1, 0, MOD_CRUSH);
}

void rotating_use (edict_t *self, edict_t *other, edict_t *activator)
{
	if (!VectorCompare (self->avelocity, vec3_origin))
	{
		self->s.sound = 0;
		if (self->spawnflags & ROTATING_ACCEL)	// decelerate
			rotating_decel (self);
		else {
			VectorClear (self->avelocity);
			G_UseTargets (self, self);
			self->touch = NULL;
		}
	}
	else
	{
		self->s.sound = self->moveinfo.sound_middle;
#ifdef LOOP_SOUND_ATTENUATION
		self->s.attenuation = self->attenuation;
#endif
		if (self->spawnflags & ROTATING_ACCEL)	// accelerate
			rotating_accel (self);
		else {
			VectorScale (self->movedir, self->speed, self->avelocity);
			G_UseTargets (self, self);
		}
		if (self->spawnflags & 16)
			self->touch = rotating_touch;
	}
}
*/

void () rotating_blocked =
{
	T_Damage (other, self, self, self.dmg);
}

void() func_rotating =
{
	self.classname = "func_rotating";
	setorigin (self, self.origin);
	setmodel (self, self.model);
	
	self.solid = SOLID_BSP;
	if (self.spawnflags & 32)
		self.movetype = MOVETYPE_NONE;
	else
		self.movetype = MOVETYPE_PUSH;

	// set the axis of rotation
	if (self.spawnflags & 4)
		self.avelocity_z = self.speed;
	else if (self.spawnflags & 8)
		self.avelocity_x = self.speed;
	else // Z_AXIS
		self.avelocity_y = self.speed;

	// check for reverse rotation
	if (self.spawnflags & 2)
		self.avelocity = -self.avelocity;

	if (self.speed)
		self.speed = 100;

//	if (!self.dmg)
		self.dmg = 200;
	
	self.nextthink = 99999999;

	if (self.dmg)
		self.blocked = rotating_blocked;
	
	/*
	ent->use = rotating_use;


	if (ent->spawnflags & 1)
		ent->use (ent, NULL, NULL);

	if (ent->spawnflags & 64)
		ent->s.effects |= EF_ANIM_ALL;
	if (ent->spawnflags & 128)
		ent->s.effects |= EF_ANIM_ALLFAST;

	if(ent->spawnflags & ROTATING_ACCEL) {	// accel/decel
		if (ent->accel == 0) ent->accel = 1;
		else ent->accel = min(ent->accel, ent->speed);
		if (ent->decel == 0) ent->decel = 1;
		else ent->decel = min(ent->decel, ent->speed);
	}

	gi.setmodel (ent, ent->model);
	gi.linkentity (ent);
	*/
}

/*
Adapted from Avirox's code
and doors.qc
*/

/*QUAKED func_door_rotating (0 .5 .8) ? START_OPEN REVERSE CRUSHER NOMONSTER ANIMATED TOGGLE X_AXIS Y_AXIS
TOGGLE causes the door to wait in both the start and end states for a trigger event.

START_OPEN	the door to moves to its destination when spawned, and operate in reverse.  It is used to temporarily or permanently close off an area when triggered (not useful for touch or takedamage doors).
NOMONSTER	monsters will not trigger this door

You need to have an origin brush as part of this entity.  The center of that brush will be
the point around which it is rotated. It will rotate around the Z axis by default.  You can
check either the X_AXIS or Y_AXIS box to change that.

"distance" is how many degrees the door will be rotated.
"speed" determines how fast the door moves; default value is 100.

REVERSE will cause the door to rotate in the opposite direction.

"message"	is printed when the door is touched if it is a trigger door and it hasn't been fired yet
"angle"		determines the opening direction
"targetname" if set, no touch field will be spawned and a remote button or trigger field activates the door.
"health"	if set, door must be shot open
"speed"		movement speed (100 default)
"wait"		wait before returning (3 default, -1 = never return)
"dmg"		damage to inflict when blocked (2 default)
"sounds"
0)		default
1)		silent
2-4		not used
5-99	custom sound- e.g. doors/dr05_strt.wav, doors/dr05_mid.wav, doors/dr05_end.wav
*/
/*
void () func_door_rotating =
{
	self.classname = "func_door_rotating";

	// set the axis of rotation
	if (self.spawnflags & DOOR_X_AXIS)
		self.avelocity_z = 1.0;
	else if (ent->spawnflags & DOOR_Y_AXIS)
		ent->movedir[0] = 1.0;
	else // Z_AXIS
		ent->movedir[1] = 1.0;

	// check for reverse rotation
	if (ent->spawnflags & DOOR_REVERSE)
		VectorNegate (ent->movedir, ent->movedir);

	if (!st.distance)
	{
		gi.dprintf("%s at %s with no distance set\n", ent->classname, vtos(ent->s.origin));
		st.distance = 90;
	}

	VectorCopy (ent->s.angles, ent->pos1);
	VectorMA (ent->s.angles, st.distance, ent->movedir, ent->pos2);
	ent->moveinfo.distance = st.distance;

	ent->movetype = MOVETYPE_PUSH;
	ent->solid = SOLID_BSP;
	gi.setmodel (ent, ent->model);

	ent->blocked = door_blocked;
	ent->use = door_use;

	if (!ent->speed)
		ent->speed = 100;
	if (!ent->accel)
		ent->accel = ent->speed;
	if (!ent->decel)
		ent->decel = ent->speed;

	if (!ent->wait && !(ent->flags & FL_REVOLVING))	// OK for revolving doors to have 0 wait
		ent->wait = 3;
	if (!ent->dmg)
		ent->dmg = 2;

	if (ent->sounds > 4 && ent->sounds < 100) // custom sounds
	{
		ent->moveinfo.sound_start = gi.soundindex  (va("doors/dr%02i_strt.wav", ent->sounds));
		ent->moveinfo.sound_middle = gi.soundindex  (va("doors/dr%02i_mid.wav", ent->sounds));
		ent->moveinfo.sound_end = gi.soundindex  (va("doors/dr%02i_end.wav", ent->sounds));
	}
	else if (ent->sounds != 1)
	{
		ent->moveinfo.sound_start = gi.soundindex  ("doors/dr1_strt.wav");
		ent->moveinfo.sound_middle = gi.soundindex  ("doors/dr1_mid.wav");
		ent->moveinfo.sound_end = gi.soundindex  ("doors/dr1_end.wav");
	}
	else
	{
		ent->moveinfo.sound_start = 0;
		ent->moveinfo.sound_middle = 0;
		ent->moveinfo.sound_end = 0;
	}

	if (ent->attenuation <= 0)
		ent->attenuation = ATTN_STATIC;

	// if it starts open, switch the positions
	if (ent->spawnflags & DOOR_START_OPEN)
	{
		VectorCopy (ent->pos2, ent->s.angles);
		VectorCopy (ent->pos1, ent->pos2);
		VectorCopy (ent->s.angles, ent->pos1);
		VectorNegate (ent->movedir, ent->movedir);
	}

	if (ent->health)
	{
		ent->takedamage = DAMAGE_YES;
		// Lazarus: negative health means "damage kills me" rather than "damage opens me"
		if (ent->health < 0)
		{
			PrecacheDebris(ent->gib_type);
			ent->die = door_destroyed;
			ent->health = -ent->health;
		}
		else
			ent->die = door_killed;
		ent->max_health = ent->health;
	}
	
	if (ent->targetname && ent->message)
	{
		gi.soundindex ("misc/talk.wav");
		ent->touch = door_touch;
	}

	ent->moveinfo.state = STATE_BOTTOM;
	ent->moveinfo.speed = ent->speed;
	ent->moveinfo.accel = ent->accel;
	ent->moveinfo.decel = ent->decel;
	ent->moveinfo.wait = ent->wait;
	VectorCopy (ent->s.origin, ent->moveinfo.start_origin);
	VectorCopy (ent->pos1, ent->moveinfo.start_angles);
	VectorCopy (ent->s.origin, ent->moveinfo.end_origin);
	VectorCopy (ent->pos2, ent->moveinfo.end_angles);

	if (ent->spawnflags & 16)
		ent->s.effects |= EF_ANIM_ALL;

	// to simplify logic elsewhere, make non-teamed doors into a team of one
	if (!ent->team)
		ent->teammaster = ent;

	gi.linkentity (ent);

	ent->nextthink = level.time + FRAMETIME;
	if (ent->health || ent->targetname)
		ent->think = Think_CalcMoveSpeed;
	else
		ent->think = Think_SpawnDoorTrigger;
}
*/

/*
void() rotatingdoor_touch;
void() rotatingdoor_go_down;
void() rotatingdoor_go_up;
void() rotatingdoor_fire;
void() rotatingdoor_use;

void() rotating_door_blocked =
{
	local entity t;

	if (self.link)
	{
		t = self;
		self = find(world, linkname, self.link);
		self.blocked();
		self = t;
	}

	T_Damage (other, self, self, self.dmg);
	
// if a door has a negative wait, it would never come back if blocked,
// so let it just squash the object to death real fast
	if (self.wait >= 0)
	{
		if (self.state == STATE_DOWN)
			rotatingdoor_go_up ();
		else
			rotatingdoor_go_down ();
	}
};

void() rotatingdoor_killed =
{
	local entity oself;
	
	oself = self;
	self = self.owner;
	self.health = self.max_health;
	self.takedamage = DAMAGE_NO;	// wil be reset upon return
	rotatingdoor_use ();
	self = oself;
};

void() rotatingdoor_hit_top =
{

	sound (self, CHAN_VOICE, self.noise1, 1, ATTN_NORM);
	self.state = STATE_TOP;

	if (self.spawnflags & DOOR_TOGGLE) {
		self.touch = SUB_Null;
		self.th_die = SUB_Null;
		return;		// don't come down automatically
	}
	self.think = rotatingdoor_go_down;
	self.nextthink = self.ltime + self.wait;
	if (self.health)
	{
		self.takedamage = 1;
		self.th_die = rotatingdoor_killed;
	}
};

void() rotatingdoor_hit_bottom =
{
	sound (self, CHAN_VOICE, self.noise1, 1, ATTN_NORM);
	self.state = STATE_BOTTOM;

	self.touch = rotatingdoor_touch;
	if (self.health)
	{
		self.takedamage = 1;
		self.th_die = rotatingdoor_killed;
	}
};

void() rotatingdoor_go_down =
{
	sound (self, CHAN_VOICE, self.noise2, 1, ATTN_NORM);
	if (self.max_health)
	{
		self.takedamage = DAMAGE_YES;
		self.health = self.max_health;
	}
	
	self.state = STATE_DOWN;
	SUB_CalcAngleMove (self.pos1, self.speed, rotatingdoor_hit_bottom);
	SUB_UseTargets();
	self.takedamage = 0;
};

void() rotatingdoor_go_up =
{
	if (self.state == STATE_UP)
		return;		// already going up

	if (self.state == STATE_TOP)
	{	// reset top wait time
		self.nextthink = self.ltime + self.wait;
		return;
	}
	
	sound (self, CHAN_VOICE, self.noise2, 1, ATTN_NORM);
	self.state = STATE_UP;
	SUB_CalcAngleMove (self.pos2, self.speed, rotatingdoor_hit_top);
	self.takedamage = 0;
	SUB_UseTargets();
};


void() rotatingdoor_use =
{
	local entity oself;

	self.enemy = self;
	self.owner = self;
	self.message = "";			// door message are for touch only
	self.owner.message = "";	
	self.enemy.message = "";
	oself = self;
	self = self.owner;
	rotatingdoor_fire ();
	self = oself;
};


void() rotatingdoor_fire =
{
	local entity 	oself;
	local entity	starte;

	if (self.owner != self)
		objerror ("rotatingdoor_fire: self.owner != self");

// play use key sound

	if (self.items)
		sound (self, CHAN_VOICE, self.noise4, 1, ATTN_NORM);

	self.message = string_null;		// no more message
	oself = self;

	if (self.spawnflags & DOOR_TOGGLE)
	{
		if (self.state == STATE_UP || self.state == STATE_TOP)
		{
			starte = self;
			do
			{
				rotatingdoor_go_down ();
				self = self.enemy;
			} while ( (self != starte) && (self != world) );
			self = oself;
			return;
		}
	}
	
// trigger all paired doors
	starte = self;

	do
	{
		self.goalentity = activator;		// Who fired us
		rotatingdoor_go_up ();
		self = self.enemy;
	} while ( (self != starte) && (self != world) );
	self = oself;
};

/*
================
door_touch

Prints messages and opens key doors
================
*/

/*
void() rotatingdoor_touch =
{
	local entity finder_ent, te;
	if (other.classname != "player")
		return;
	if (self.owner.attack_finished > time)
		return;

		
	self.owner.attack_finished = time + 2;

	if (self.owner.message != "")
	{
		centerprint (other, self.owner.message);
		sound (other, CHAN_VOICE, "misc/talk.wav", 1, ATTN_NORM);
	}

	if (self.spawnflags & 16)
		return;
	if (!(self.spawnflags & 87907))
	{
		self.touch = SUB_Null;
		if (self.enemy)
		{
			self.enemy.touch = SUB_Null;
		}
		rotatingdoor_use();
		// linking rotating doors is fubar'd.. now we do it my way ;o
		finder_ent = find (world,targetname,self.targetname);
		while (finder_ent)
		{
			if ( finder_ent != self && finder_ent.classname == "door_rotating" && finder_ent.touch != SUB_Null )
			{
				te = self;
				self = finder_ent;
				self.touch();
				self = te;
			}
			finder_ent = find (finder_ent, targetname, self.targetname);
		}
	}
};
*/
float DOOR_REVERSE		= 2;
float DOOR_X_AXIS		= 64;
float DOOR_Y_AXIS		= 128;

void() func_door_rotating =
{
	if (world.worldtype == 0)
	{
		precache_sound ("doors/medtry.wav");
		precache_sound ("doors/meduse.wav");
		self.noise3 = "doors/medtry.wav";
		self.noise4 = "doors/meduse.wav";
	}
	else if (world.worldtype == 1)
	{
		precache_sound ("doors/runetry.wav");
		precache_sound ("doors/runeuse.wav");
		self.noise3 = "doors/runetry.wav";
		self.noise4 = "doors/runeuse.wav";
	}
	else if (world.worldtype == 2)
	{
		precache_sound ("doors/basetry.wav");
		precache_sound ("doors/baseuse.wav");
		self.noise3 = "doors/basetry.wav";
		self.noise4 = "doors/baseuse.wav";
	}
	else
	{
		dprint ("no worldtype set!\n");
	}
	if (self.sounds == 0)
	{
		precache_sound ("misc/null.wav");
		precache_sound ("misc/null.wav");
		self.noise1 = "misc/null.wav";
		self.noise2 = "misc/null.wav";
	}
	if (self.sounds == 1)
	{
		precache_sound ("doors/drclos4.wav");
		precache_sound ("doors/doormv1.wav");
		self.noise1 = "doors/drclos4.wav";
		self.noise2 = "doors/doormv1.wav";
	}
	if (self.sounds == 2)
	{
		precache_sound ("doors/hydro1.wav");
		precache_sound ("doors/hydro2.wav");
		self.noise2 = "doors/hydro1.wav";
		self.noise1 = "doors/hydro2.wav";
	}
	if (self.sounds == 3)
	{
		precache_sound ("doors/stndr1.wav");
		precache_sound ("doors/stndr2.wav");
		self.noise2 = "doors/stndr1.wav";
		self.noise1 = "doors/stndr2.wav";
	}
	if (self.sounds == 4)
	{
		precache_sound ("doors/ddoor1.wav");
		precache_sound ("doors/ddoor2.wav");
		self.noise1 = "doors/ddoor2.wav";
		self.noise2 = "doors/ddoor1.wav";
	}


	if (self.spawnflags & DOOR_X_AXIS)
		self.movedir_z = 1.0;
	else if (self.spawnflags & DOOR_Y_AXIS)
		self.movedir_x = 1.0;
	else // Z_AXIS
		self.movedir_y = 1.0;

	// check for reverse rotation
	if (self.spawnflags & DOOR_REVERSE)
		self.movedir = '0 0 0' - self.movedir;



	self.max_health = self.health;
	self.solid = SOLID_BSP;
	self.movetype = MOVETYPE_PUSH;
	setorigin (self, self.origin);  
	setmodel (self, self.model);
	
	self.classname = "door_rotating";

//	self.blocked = rotating_door_blocked;
//	self.use = rotatingdoor_use;
	
	if (self.spawnflags & DOOR_SILVER_KEY)
		self.items = IT_KEY1;
	if (self.spawnflags & DOOR_GOLD_KEY)
		self.items = IT_KEY2;
	
	if (!self.speed)
		self.speed = 100;
	if (!self.wait)
		self.wait = 3;
	if (!self.lip)
		self.lip = 8;
	if (!self.dmg)
		self.dmg = 2;

/*
	self.pos1 = self.angles;
	self.pos2 = self.angles + self.movedir * self.distance;
*/
// DOOR_START_OPEN is to allow an entity to be lighted in the closed position
// but spawn in the open position
	if (self.spawnflags & DOOR_START_OPEN)
	{
		self.pos1 = self.angles;
	}

	self.state = STATE_BOTTOM;

	if (self.health)
	{
		self.takedamage = DAMAGE_YES;
//		self.th_die = rotatingdoor_killed;
	}
	
	if (self.items)
		self.wait = -1;
		
//	self.touch = rotatingdoor_touch;

	if (self.targetname) {		// Door is locked if it must be triggered
		self.touch = SUB_Null;
		self.th_die = SUB_Null;
	}
	self.owner = self.enemy = self;
};


/*QUAKED misc_eastertank (1 .5 0) (-32 -32 -16) (32 32 32)
*/

void() misc_eastertank_think =
{
	if (self.frame >= 293)
	{
		self.frame = 254;
	}
	else
	{
		self.frame++;
	}
	
	self.think = misc_eastertank_think;
	self.nextthink = time + 0.1;	
}

void() misc_eastertank =
{
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_BBOX;
	setsize (self, '-32 -32 -16', '32 32 32');
	precache_model ("models/monsters/tank/tris.md2");
	setmodel (self, "models/monsters/tank/tris.md2");	
	self.frame = 254;
	self.think = misc_eastertank_think;
	self.nextthink = time + 0.1;
}

/*QUAKED misc_easterchick (1 .5 0) (-32 -32 0) (32 32 32)
*/


void() misc_easterchick_think =
{
	if (self.frame >= 247)
	{
		self.frame = 208;
	}
	else
	{
		self.frame++;
	}
	
	self.think = misc_easterchick_think;
	self.nextthink = time + 0.1;	
}

void() misc_easterchick =
{
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_BBOX;
	setsize (self, '-32 -32 0', '32 32 32');
	precache_model ("models/monsters/bitch/tris.md2");
	setmodel (self, "models/monsters/bitch/tris.md2");		
	self.frame = 208;
	self.think = misc_easterchick_think;
	self.nextthink = time + 0.1;
}

/*QUAKED misc_easterchick2 (1 .5 0) (-32 -32 0) (32 32 32)
*/
void() misc_easterchick2_think =
{
		if (self.frame >= 287)
	{
		self.frame = 248;
	}
	else
	{
		self.frame++;
	}
	
	self.think = misc_easterchick2_think;
	self.nextthink = time + 0.1;
}

void () misc_easterchick2 =
{
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_BBOX;
	setsize (self, '-32 -32 0', '32 32 32');
	precache_model ("models/monsters/bitch/tris.md2");
	setmodel (self, "models/monsters/bitch/tris.md2");		
	self.frame = 248;
	self.think = misc_easterchick2_think;
	self.nextthink = time + 0.1;
}