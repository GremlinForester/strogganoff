/*
==============================================================================

mutant

This version doesn't leap like the demon in Q1.
Right now it works well as a faster moving melee monster like the demon in Doom.
Writing this as an afterthought but I recall there were issues with the frames or something.  
Anyway, a fix for the leap is TODO atm.

==============================================================================
*/

#include "monsterq2_mutant.qh"

#define MUTANT_SOUND_SWING	"mutant/mutatck1.wav"
#define MUTANT_SOUND_HIT	"mutant/mutatck2.wav"
#define MUTANT_SOUND_HIT2	"mutant/mutatck3.wav"
#define MUTANT_SOUND_DEATH	"mutant/mutdeth1.wav"
#define MUTANT_SOUND_IDLE	"mutant/mutidle1.wav"
#define MUTANT_SOUND_PAIN1	"mutant/mutpain1.wav"
#define MUTANT_SOUND_PAIN2	"mutant/mutpain2.wav"
#define MUTANT_SOUND_SIGHT	"mutant/mutsght1.wav"
#define MUTANT_SOUND_SEARCH	"mutant/mutsrch1.wav"
#define MUTANT_SOUND_STEP1	"mutant/step1.wav"
#define MUTANT_SOUND_STEP2	"mutant/step2.wav"
#define MUTANT_SOUND_STEP3	"mutant/step3.wav"
#define MUTANT_SOUND_THUD	"mutant/thud1.wav"

//
// SOUNDS
//

void() q2mutant_step =
{
	if (random() > 0.33)
		sound (self, CHAN_VOICE, MUTANT_SOUND_STEP1, 1, ATTN_NORM);	
	else if (random() > 0.66)
		sound (self, CHAN_VOICE, MUTANT_SOUND_STEP2, 1, ATTN_NORM);	
	else
		sound (self, CHAN_VOICE, MUTANT_SOUND_STEP3, 1, ATTN_NORM);	
}

//
// STAND
//

framerloop($FRAME_stand101, $FRAME_stand164, q2mutant_stand, 0.1, ai_stand());

//
// WALK
//

framerloop($FRAME_walk05, $FRAME_walk16, q2mutant_walk, 0.1,

	frame_arb($FRAME_walk01,if (random() < 0.2) sound(self, CHAN_VOICE, MUTANT_SOUND_SEARCH, 1, ATTN_IDLE));

	ai_rep($FRAME_walk05, ai_walk, 3, 1, 5, 10, 13, 10, 0, 5);
	ai_rep($FRAME_walk13, ai_walk, 6, 16, 15, 6, 0, 0, 0, 0);
);

//
// RUN
//

framerloop($FRAME_run03, $FRAME_run08, q2mutant_run, 0.1,

	frame_arb($FRAME_run04, q2mutant_step(););
	frame_arb($FRAME_run06, q2mutant_step(););

	ai_rep($FRAME_run03, ai_run, 40, 40, 24, 5, 17, 10, 0, 0);
);

//
// MELEE
//

void(float side)	q2mutant_Melee =
{
//	local	float	ldmg;
//	local vector	delta;
	
	ai_face ();
	walkmove (self.ideal_yaw, 12);	// allow a little closing

//	delta = self.enemy.origin - self.origin;

	if (vlen(self.enemy.origin - self.origin) > 100)
		return;
	if (!CanDamage (self.enemy, self))
		return;
		
	//sound (self, CHAN_WEAPON, "demon/dhit2.wav", 1, ATTN_NORM);
	
	if (random() > 0.5)
		sound (self, CHAN_VOICE, MUTANT_SOUND_HIT, 1, ATTN_NORM);	
	else
		sound (self, CHAN_VOICE, MUTANT_SOUND_HIT2, 1, ATTN_NORM);	
	
	self.ldmg_ = 10 + 5*random();
	T_Damage (self.enemy, self, self, self.ldmg_);	

	makevectors (self.angles);
	SpawnMeatSpray (self.origin + v_forward*16, side * v_right);
};

framer($FRAME_attack09, $FRAME_attack15, q2mutant_atta1, q2mutant_run, 0.1,

	frame_arb($FRAME_attack10, sound (self, CHAN_BODY, MUTANT_SOUND_SWING, 1, ATTN_NORM););
	frame_arb($FRAME_attack11, q2mutant_Melee(200));
	frame_arb($FRAME_attack13, sound (self, CHAN_BODY, MUTANT_SOUND_SWING, 1, ATTN_NORM););
	frame_arb($FRAME_attack14, q2mutant_Melee(-200));

	ai_rep($FRAME_attack09, ai_charge, 0, 0, 0, 0, 0, 0, 0, 0);
);

//
// PAIN
//

//PAIN 1

framer($FRAME_pain101, $FRAME_pain105, q2mutant_pain1, q2mutant_run, 0.1,SUB_Null());

//PAIN 2

framer($FRAME_pain201, $FRAME_pain206, q2mutant_pain2, q2mutant_run, 0.1,SUB_Null());

//PAIN 3

framer($FRAME_pain301, $FRAME_pain311, q2mutant_pain3, q2mutant_run, 0.1,SUB_Null());

//framer($FRAME_pain301, $FRAME_pain311, q2mutant_pain3, q2mutant_run, 0.1,SUB_Null());


// PAIN

void(entity attacker, float damage)	q2mutant_pain =
{
	local vector org;
	org = self.origin + '0 0 24';

	if (self.health < (self.max_health / 2))
		self.skin = 1;

	if (self.pain_finished > time)
		return;

	if (random() < 0.33)
	{
		self.pain_finished = time + 1;
		q2mutant_pain1 ();
		sound (self, CHAN_VOICE, MUTANT_SOUND_PAIN1, 1, ATTN_NORM);
	}
	else if (random() < 0.66)
	{
		self.pain_finished = time + 1;
		q2mutant_pain2 ();
		sound (self, CHAN_VOICE, MUTANT_SOUND_PAIN2, 1, ATTN_NORM);
	}
	else
	{
		self.pain_finished = time + 1;
		q2mutant_pain3 ();
		sound (self, CHAN_VOICE, MUTANT_SOUND_PAIN1, 1, ATTN_NORM);
	}
	
	SpawnBlood (org, '0 0 0', 20);
	
	self.bIsWounded = 1;
	self.bleedcount = 0;
};


//
// DEATH
//

//DIE 1
framer($FRAME_death101, $FRAME_death109, q2mutant_die1, SUB_Null, 0.1,

	frame_arb($FRAME_death101, self.solid = SOLID_CORPSE, self.movetype = MOVETYPE_TOSS);
);

//DIE 2
framer($FRAME_death201, $FRAME_death210, q2mutant_die2, SUB_Null, 0.1,

	frame_arb($FRAME_death201,self.solid = SOLID_CORPSE, self.movetype = MOVETYPE_TOSS);
);

void() q2mutant_die =
{
	local float	n;
	
	// check for gib
	if (self.health < -80)
	{
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
		for (n= 0; n < 2; n++)
			ThrowGib ("models/objects/gibs/bone/tris.md2", self.health, GIB_FLESH);
		for (n= 0; n < 4; n++)
			ThrowGib ("models/objects/gibs/sm_meat/tris.md2", self.health, GIB_FLESH);
		
		ThrowHead ("models/objects/gibs/head2/tris.md2", self.health);
		return;
	}

// regular death
	sound (self, CHAN_VOICE, MUTANT_SOUND_DEATH, 1, ATTN_NORM);
	if (random() < 0.5)
		q2mutant_die1 ();
	else
		q2mutant_die2 ();
};

/*QUAKED monster_mutant (1 .5 0) (-32 -32 -24) (32 32 32) Ambush Trigger_Spawn Sight
*/
void() monster_mutant =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model ("models/monsters/mutant/tris.md2");

	precache_sound ("mutant/mutatck1.wav");
	precache_sound ("mutant/mutatck2.wav");
	precache_sound ("mutant/mutatck3.wav");
	precache_sound ("mutant/mutdeth1.wav");
	precache_sound ("mutant/mutidle1.wav");
	precache_sound ("mutant/mutpain1.wav");
	precache_sound ("mutant/mutpain2.wav");
	precache_sound ("mutant/mutsght1.wav");
	precache_sound ("mutant/mutsrch1.wav");
	precache_sound ("mutant/step1.wav");
	precache_sound ("mutant/step2.wav");
	precache_sound ("mutant/step3.wav");
	precache_sound ("mutant/thud1.wav");

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	
	setmodel (self, "models/monsters/mutant/tris.md2");
	self.scale = 0.75;
	setsize (self, '-32 -32 -24', '32 32 48');
	//setsize (self, '-16 -16 -24', '16 16 32');
	//setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
	self.health = 300;
	self.max_health = self.health;

	self.th_stand = q2mutant_stand;
	self.th_walk = q2mutant_walk;
	self.th_run = q2mutant_run;
	self.th_die = q2mutant_die;
	self.th_melee = q2mutant_atta1;		// one of two attacks
//	self.th_missile = SUB_Null;			// jump attack
	self.th_pain = q2mutant_pain;

	self.sightSound = MUTANT_SOUND_SIGHT;

	walkmonster_start;
};

//MrC FixMe: Mutant replacement in E1M2 crashes, seems related to th_missile 

#ifdef q2monster_replace_demon
void() monster_demon1 =
{
	monster_mutant ();
};
#endifdef

