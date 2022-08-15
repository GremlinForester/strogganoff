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

framer($FRAME_stand01, $FRAME_stand30, q2gunner_frames_stand, q2gunner_select_stand, 0.1,
	ai_stand();
);

/*

STAND FIDGET

*/

framer($FRAME_stand31, $FRAME_stand70, q2gunner_frames_fidget, q2gunner_select_stand, 0.1,
	frame_arb($FRAME_stand38, sound(self, CHAN_WEAPON, GUNNER_SOUND_IDLE, 1, ATTN_NORM););
	ai_stand();
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
		gibMonster();
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
	
	DropLoot(LOOT_BULLETS, floor(random()*6)+1, self.origin);
	
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
);

// PAIN2

framer($FRAME_pain201, $FRAME_pain208, q2gunner_pain2, q2gunner_frames_run, 0.135, 
	
	frame_arb($FRAME_pain201,
		local	vector	org;
		org = self.origin + '0 0 24';
		SpawnBlood (org, '0 0 0', 20);
	);
);

// PAIN3

framer($FRAME_pain301, $FRAME_pain305, q2gunner_pain3, q2gunner_frames_run, 0.135, 
	
	frame_arb($FRAME_pain301,
		local	vector	org;
		org = self.origin + '0 0 24';
		SpawnBlood (org, '0 0 0', 20);
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
		self.pain_finished = time + 3.5;
		q2gunner_pain3 ();
		sound (self, CHAN_VOICE, GUNNER_SOUND_PAIN2, 1, ATTN_NORM);
	}
	else if (damage <= 25)
	{
		self.pain_finished = time + 4.8;
		q2gunner_pain2 ();
		sound (self, CHAN_VOICE, GUNNER_SOUND_PAIN, 1, ATTN_NORM);
	}
	else
	{
		self.pain_finished = time + 2.3;
		q2gunner_pain1 ();
		sound (self, CHAN_VOICE, GUNNER_SOUND_PAIN2, 1, ATTN_NORM);
	}
};


void() q2gunner_fire_grenade =
{
	local vector org;

	org = self.origin + (v_forward * 8) + (v_right * -8) + (v_up * 16);
//	org = '20 8 17';
//	makevectors(self.angles);	
	monster_fire_grenade (org, '300 300 300', autocvar_sk_q2gunner_grenade_damage, 600);
};

/*

GRENADE ATTACK

*/

framer($FRAME_attak101, $FRAME_attak121, q2gunner_attack_grenade, q2gunner_frames_run, 0.1,

	frame_arb($FRAME_attak105,q2gunner_fire_grenade());
	frame_arb($FRAME_attak108,q2gunner_fire_grenade());
	frame_arb($FRAME_attak111,q2gunner_fire_grenade());
	frame_arb($FRAME_attak114,q2gunner_fire_grenade());
	ai_face();
);

/*

CHAIN ATTACK

*/

void() gunner_fire_bullet =
{
	local	vector	dir;
	local	entity	en;
	local	vector	org;

	sound (self, CHAN_AUTO, GUNNER_SOUND_ATTACK2, 1, ATTN_NORM);

	en = self.enemy;
	dir = en.origin - en.velocity*0.1;
	dir = normalize (en.origin - self.origin);
	org = self.origin + (v_forward * 30) + (v_right * 16) + (v_up * 36);
	
	monster_fire_bullet(self.origin, dir, '0.01 0.01 0', autocvar_sk_q2gunner_mg_damage);
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

void() precache_gunner =
{
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
}

/*QUAKED monster_gunner (1 .5 0) (-16 -16 -24) (16 16 32) Ambush Trigger_Spawn Sight
*/
void() monster_gunner =
{
	self.classname = "monster_gunner";
	
	if (deathmatch)
	{
		remove(self);
		return;
	}
	
	precache_gunner();

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "models/monsters/gunner/tris.md2");

	setsize (self, '-16 -16 -24', '16 16 32');
	self.health = autocvar_sk_q2gunner_health;
	self.max_health = self.health;

	self.th_stand = q2gunner_frames_stand;
	self.th_walk = q2gunner_frames_walk;
	self.th_run = q2gunner_frames_run;
	self.th_pain = q2gunner_pain;
	self.th_die = q2gunner_die;
	self.th_missile = q2gunner_select_attack;
	self.th_melee = q2gunner_attack_chain;

	self.sightSound = GUNNER_SOUND_SIGHT;

	walkmonster_start;
};
