/*
==============================================================================

GUNNER

==============================================================================
*/

#include "monsterq2_gunner.qh"

#define GUNNER_SOUND_PAIN 	"gunner/gunpain2.wav"
#define GUNNER_SOUND_PAIN2	"gunner/gunpain1.wav"
#define GUNNER_SOUND_DEATH	"gunner/death1.wav"
#define GUNNER_SOUND_IDLE	"gunner/gunidle1.wav"
#define GUNNER_SOUND_OPEN	"gunner/gunatck1.wav"
#define GUNNER_SOUND_SEARCH	"gunner/gunsrch1.wav"
#define GUNNER_SOUND_SIGHT	"gunner/sight1.wav"

#define GUNNER_SOUND_ATTACK2	"gunner/gunatck2.wav"
#define GUNNER_SOUND_ATTACK3	"gunner/gunatck3.wav"

void() q2gunner_select_stand;

/*

STAND1

*/

framerloop($FRAME_stand01, $FRAME_stand30, q2gunner_frames_stand, 0.135,

	frame_arb($FRAME_stand30, q2gunner_select_stand(););

	ai_rep($FRAME_stand01, ai_stand, 0, 0, 0, 0, 0, 0, 0, 0);
	ai_rep($FRAME_stand09, ai_stand, 0, 0, 0, 0, 0, 0, 0, 0);
	ai_rep($FRAME_stand17, ai_stand, 0, 0, 0, 0, 0, 0, 0, 0);
	ai_rep($FRAME_stand25, ai_stand, 0, 0, 0, 0, 0, 0, 0, 0);
);

/*

STAND FIDGET

*/

framerloop($FRAME_stand31, $FRAME_stand70, q2gunner_frames_fidget, 0.1,

	frame_arb($FRAME_stand70, q2gunner_select_stand(););

	frame_arb($FRAME_stand38, sound(self, CHAN_WEAPON, GUNNER_SOUND_IDLE, 1, ATTN_NORM););

	ai_rep($FRAME_stand31, ai_stand, 0, 0, 0, 0, 0, 0, 0, 0);
	ai_rep($FRAME_stand39, ai_stand, 0, 0, 0, 0, 0, 0, 0, 0);
	ai_rep($FRAME_stand47, ai_stand, 0, 0, 0, 0, 0, 0, 0, 0);
	ai_rep($FRAME_stand55, ai_stand, 0, 0, 0, 0, 0, 0, 0, 0);
	ai_rep($FRAME_stand63, ai_stand, 0, 0, 0, 0, 0, 0, 0, 0);
);

/*
STAND SELECTOR

Chooses between regular idle and randomly playing a fidget animation

*/

void()	q2gunner_select_stand =
{
	if (self.health <= 0)
		return;
	
	if (random() > 0.1)
	{
		q2gunner_frames_stand ();
		return;
	}
	else
	{
		q2gunner_frames_fidget ();
		return;
	}
};

/*

WALK

*/

framerloop($FRAME_walk07, $FRAME_walk19, q2gunner_frames_walk, 0.1,

//	frame_arb(FRAME_walkc5, footsetp(););
//	frame_arb(FRAME_walkc10, footstep(););
	frame_arb($FRAME_walk08,

	if (self.bIsWounded && self.bleedcount < MAX_BLEED)
	{
		local	vector	org;
		org = self.origin + '0 0 24';
		SpawnBlood (org, '0 0 0', 5);
		self.bleedcount++;
	}
	);
	
	ai_rep($FRAME_walk11, ai_walk, 0, 3, 4, 5, 7, 2, 6, 4);
	ai_rep($FRAME_walk19, ai_walk, 2, 7, 5, 7, 4, 0, 0, 0);
);

/*

RUN

*/

framerloop($FRAME_run01, $FRAME_run08, q2gunner_frames_run, 0.1,

//	frame_arb(FRAME_walkc5, footsetp(););
//	frame_arb(FRAME_walkc10, footstep(););
	frame_arb($FRAME_run01,

	if (random() < 0.1) sound (self, CHAN_VOICE, GUNNER_SOUND_SEARCH, 1, ATTN_IDLE);

	if (self.bIsWounded && self.bleedcount < MAX_BLEED)
	{
		local	vector	org;
		org = self.origin + '0 0 24';
		SpawnBlood (org, '0 0 0', 5);
		self.bleedcount++;
	}
	);
	
	ai_rep($FRAME_run01, ai_run, 26, 9, 9, 9, 15, 10, 13, 6);
);

/*

DEATH

*/

void() q2gunner_dead =
{
	setsize (self, '-16 -16 -24', '16 16 -8');
	self.movetype = MOVETYPE_TOSS;
	self.solid = SOLID_CORPSE;
};

framer($FRAME_death01, $FRAME_death11, q2gunner_die1_frames, SUB_Null, 0.1,
	
	frame_arb($FRAME_death01,

		q2gunner_dead();
	//	self.ammo_shells = 5;
	//	DropBackpack();
	);
);

void() q2gunner_die =
{
	local float n;

 	if (self.health < -70)
	{
		sound (self, CHAN_VOICE, "misc/udeath.wav", 1, ATTN_NORM);
		
		for (n= 0; n < 2; n++)
			ThrowGib ("models/objects/gibs/bone/tris.md2", self.health / 4, GIB_FLESH);
		for (n= 0; n < 4; n++)
			ThrowGib ("models/objects/gibs/sm_meat/tris.md2", self.health / 4, GIB_FLESH);
		
		ThrowHead ("models/objects/gibs/head2/tris.md2", self.health / 4);
		
		remove(self);
		return;
	} 

	self.takedamage = DAMAGE_YES;

 	if (self.deadflag == DEAD_DEAD){
		return;
	}
	else
	{
	// regular death
	sound(self, CHAN_VOICE, GUNNER_SOUND_DEATH, 1, ATTN_NORM);
	self.deadflag = DEAD_DEAD;
	q2gunner_die1_frames();
	}
};

// PAIN1

framer($FRAME_pain101, $FRAME_pain118, q2gunner_pain1, q2gunner_frames_run, 0.135, 
	
	frame_arb($FRAME_pain101,
		local	vector	org;
		org = self.origin + '0 0 24';
		SpawnBlood (org, '0 0 0', 20);
	);
	
	frame_arb($FRAME_pain118,
		ai_pain(1);
	);
);

// PAIN2

framer($FRAME_pain201, $FRAME_pain208, q2gunner_pain2, q2gunner_frames_run, 0.135, 
	
	frame_arb($FRAME_pain201,
		local	vector	org;
		org = self.origin + '0 0 24';
		SpawnBlood (org, '0 0 0', 20);
	);
	
	frame_arb($FRAME_pain208,
		ai_pain(1);
	);
);

// PAIN3

framer($FRAME_pain301, $FRAME_pain305, q2gunner_pain3, q2gunner_frames_run, 0.135, 
	
	frame_arb($FRAME_pain301,
		local	vector	org;
		org = self.origin + '0 0 24';
		SpawnBlood (org, '0 0 0', 20);
	);
	
	frame_arb($FRAME_pain305,
		ai_pain(1);
	);
);

void(entity attacker, float damage)	q2gunner_pain =
{
	local vector org;
	org = self.origin + '0 0 24';

	if (self.health < (self.max_health / 2))
		self.skin = 1;

	SpawnBlood (org, '0 0 0', 20);
	
	self.bIsWounded = 1;
	self.bleedcount = 0;

	if (skill == 3)
		return;		// no pain anims in nightmare

	if (self.pain_finished > time)
		return;

	if (damage <= 10)
	{
		self.pain_finished = time + 0.5;
		q2gunner_pain3 ();
		sound (self, CHAN_VOICE, GUNNER_SOUND_PAIN2, 1, ATTN_NORM);
	}
	else if (damage <= 25)
	{
		self.pain_finished = time + 0.8;
		q2gunner_pain2 ();
		sound (self, CHAN_VOICE, GUNNER_SOUND_PAIN, 1, ATTN_NORM);
	}
	else
	{
		self.pain_finished = time + 1.8;
		q2gunner_pain1 ();
		sound (self, CHAN_VOICE, GUNNER_SOUND_PAIN2, 1, ATTN_NORM);
	}
};

/*

GRENADE ATTACK

*/

framer($FRAME_attak101, $FRAME_attak121, q2gunner_attack_grenade, q2gunner_frames_run, 0.1,

	frame_arb($FRAME_attak105,W_FireGrenade());
	frame_arb($FRAME_attak108,W_FireGrenade());
	frame_arb($FRAME_attak111,W_FireGrenade());
	frame_arb($FRAME_attak114,W_FireGrenade());
	ai_face();
);

/*

CHAIN ATTACK

*/

void() gunner_fire_bullet =
{
	local	vector	dir;
	local	entity	en;

	sound (self, CHAN_AUTO, GUNNER_SOUND_ATTACK2, 1, ATTN_NORM);

	en = self.enemy;
	dir = en.origin - en.velocity*0.1;
	dir = normalize (dir - self.origin);

	FireBullets (1, dir, '0.05 0.05 0');
};

framer($FRAME_attak209, $FRAME_attak230, q2gunner_attack_chain, q2gunner_frames_run, 0.1,

	frame_arb($FRAME_attak210,sound (self, CHAN_AUTO, GUNNER_SOUND_OPEN, 1, ATTN_NORM););
	frame_arb($FRAME_attak216,gunner_fire_bullet());
	frame_arb($FRAME_attak217,gunner_fire_bullet());
	frame_arb($FRAME_attak218,gunner_fire_bullet());
	frame_arb($FRAME_attak219,gunner_fire_bullet());
	frame_arb($FRAME_attak220,gunner_fire_bullet());
	frame_arb($FRAME_attak221,gunner_fire_bullet());
	frame_arb($FRAME_attak222,gunner_fire_bullet());
	frame_arb($FRAME_attak223,gunner_fire_bullet());
	ai_face();
);

void()	q2gunner_select_attack =
{
	if (self.health <= 0)
		return;
	
	if (random() > 0.4)
	{
		q2gunner_attack_grenade ();
		return;
	}
	else
	{
		q2gunner_attack_chain ();
		return;
	}
};

/*QUAKED monster_gunner (1 .5 0) (-16 -16 -24) (16 16 32) Ambush Trigger_Spawn Sight
*/

void() monster_gunner =
{
	self.classname = "q2monster_gunner";
	
	if (deathmatch)
	{
		remove(self);
		return;
	}
	
	// pre-caches
	precache_model ("models/monsters/gunner/tris.md2");
	
	precache_sound (GUNNER_SOUND_PAIN);	
	precache_sound (GUNNER_SOUND_PAIN2);	
	precache_sound (GUNNER_SOUND_DEATH);	
	precache_sound (GUNNER_SOUND_IDLE);	
	precache_sound (GUNNER_SOUND_OPEN);	
	precache_sound (GUNNER_SOUND_SEARCH);	
	precache_sound (GUNNER_SOUND_SIGHT);	
	precache_sound (GUNNER_SOUND_ATTACK2);	
	precache_sound (GUNNER_SOUND_ATTACK3);

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "models/monsters/gunner/tris.md2");

	setsize (self, '-16 -16 -24', '16 16 32');
	self.health = 175;
	self.max_health = self.health;

	self.th_stand = q2gunner_frames_stand;
	self.th_walk = q2gunner_frames_walk;
	self.th_run = q2gunner_frames_run;
	self.th_pain = q2gunner_pain;
	self.th_die = q2gunner_die;
	self.th_missile = q2gunner_select_attack;

	self.sightSound = GUNNER_SOUND_SIGHT;

	walkmonster_start;
};
