/*
==============================================================================

infantry

==============================================================================
*/

#include "monsterq2_infantry.qh"

void() q2infantry_fire;
void() q2infantry_select_stand;
void() q2infantry_frames_holdattack;
void() q2infantry_frames_endattack;

/*

STAND1

*/

framer($FRAME_stand50, $FRAME_stand71, q2infantry_frames_stand, q2infantry_select_stand, 0.1,
	frame_arb($FRAME_stand01, sound (self, CHAN_VOICE, "infantry/infidle1.wav", 1, ATTN_IDLE););
	ai_stand();
);

/*

STAND FIDGET

*/

framer($FRAME_stand01, $FRAME_stand49, q2infantry_stand_fidget, q2infantry_select_stand, 0.1,
	frame_arb($FRAME_stand01, sound (self, CHAN_VOICE, "infantry/infidle1.wav", 1, ATTN_IDLE););
	ai_stand();
);

/*
STAND SELECTOR

Chooses between regular idle and randomly playing a fidget animation

*/

void()	q2infantry_select_stand =
{
	if (self.health <= 0)
		return;
	
	if (random() > 0.2)
	{
		q2infantry_frames_stand ();
		return;
	}
	else
	{
		q2infantry_stand_fidget ();
		return;
	}
};

/*

WALK

*/

framerloop($FRAME_walk03, $FRAME_walk14, q2infantry_frames_walk, 0.1,

	frame_arb($FRAME_walk03,

	if (self.bIsWounded && self.bleedcount < MAX_BLEED)
	{
		local	vector	org;
		org = self.origin + '0 0 24';
		SpawnBlood (org, '0 0 0', 5);
		self.bleedcount++;
	}
	);
	
	ai_rep($FRAME_walk01, ai_walk, 5, 4, 4, 5, 4, 5, 6, 4);
	ai_rep($FRAME_walk09, ai_walk, 4, 4, 4, 5, 0, 0, 0, 0);
);

/*

RUN

*/

framerloop($FRAME_run01, $FRAME_run08, q2infantry_frames_run, 0.1,
	
	frame_arb($FRAME_run02,

	if (self.bIsWounded && self.bleedcount < MAX_BLEED)
	{
		local	vector	org;
		org = self.origin + '0 0 24';
		SpawnBlood (org, '0 0 0', 5);
		self.bleedcount++;
	}
	);
	
	ai_rep($FRAME_run01, ai_run, 10, 20, 5, 7, 30, 35, 2, 6);
);

/*

MELEE

*/

void(float damage) infantry_melee =
{
	if (!self.enemy)
		return;
	if (!CanDamage (self.enemy, self))
		return;

	ai_charge(5);

	if (vlen(self.enemy.origin - self.origin) > 75)
		return;
		
	self.ldmg_ = (random() + random() + random()) * damage;
	T_Damage (self.enemy, self, self, self.ldmg_);
	
	if (damage)
	{
		makevectors (self.angles);
		if (damage == 1){
		sound(self, CHAN_WEAPON, "infantry/melee2.wav", 1, ATTN_NORM);
		}
	}
};

// MELEE ATTACK 2

framer($FRAME_attak201, $FRAME_attak208, q2infantry_melee, q2infantry_frames_run, 0.1,

	frame_arb($FRAME_attak203,sound(self, CHAN_WEAPON, "infantry/infatck2.wav", 1, ATTN_NORM););
	
	frame_arb($FRAME_attak206, infantry_melee(20); ai_charge(25););
);


/*

START machinegun, hold (loop) and end attack broken up

*/


framer($FRAME_attak101, $FRAME_attak109, q2infantry_frames_start_attack, q2infantry_frames_holdattack, 0.135,
	frame_arb($FRAME_attak103,
	sound (self, CHAN_VOICE, "infantry/infatck3.wav", 1, ATTN_NORM);
	);
	ai_face();
);

framerloop($FRAME_attak110, $FRAME_attak111, q2infantry_frames_holdattack, 0.05,
	frame_arb($FRAME_attak110,
	if (self.shotcount >= 10){
		self.shotcount = 0;
	q2infantry_frames_endattack();
	}
	else
	{
		self.shotcount++;
	}
	);
	frame_arb($FRAME_attak111, q2infantry_fire(););

	ai_face();
);

framer($FRAME_attak112, $FRAME_attak115, q2infantry_frames_endattack, q2infantry_frames_run, 0.135,);

/*

END machinegun

*/

// PAIN1

framer($FRAME_pain101, $FRAME_pain110, q2infantry_pain1, q2infantry_frames_run, 0.1, 
	
	frame_arb($FRAME_pain101,
		local	vector	org;
		org = self.origin + '0 0 24';
		SpawnBlood (org, '0 0 0', 20);
	);
);

// PAIN2

framer($FRAME_pain201, $FRAME_pain210, q2infantry_pain2, q2infantry_frames_run, 0.1, 
	
	frame_arb($FRAME_pain201,
		local	vector	org;
		org = self.origin + '0 0 24';
		SpawnBlood (org, '0 0 0', 20);
	);
);

void(entity attacker, float damage)	q2infantry_pain =
{
	local float r;

	if (self.health < (self.max_health / 2))
		self.skin = 1;

	if (self.pain_finished > time)
		return;

	r = random();

	if (r < 0.2)
	{
		self.pain_finished = time + 0.6;
		q2infantry_pain1 ();
		sound (self, CHAN_VOICE, "infantry/infpain1.wav", 1, ATTN_NORM);
	}
	else if (r < 0.6)
	{
		self.pain_finished = time + 1.1;
		q2infantry_pain2 ();
		sound (self, CHAN_VOICE, "infantry/infpain2.wav", 1, ATTN_NORM);
	}
	else
	{
		self.pain_finished = time + 1.1;
		q2infantry_pain1 ();
		sound (self, CHAN_VOICE, "infantry/infpain2.wav", 1, ATTN_NORM);
	}
};


void() q2infantry_fire =
{
	local	vector	dir, org;
	local	entity	en;

	ai_face();

	sound (self, CHAN_WEAPON, "infantry/infatck1.wav", 1, ATTN_NORM);

	// fire somewhat behind the player, so a dodging player is harder to hit
	en = self.enemy;

	dir = en.origin - en.velocity*0.1;
	dir = normalize (dir - self.origin);

	org = self.origin + (v_forward * 26.6) + (v_right * 7.1) + (v_up * 13.1);

	monster_fire_bullet(org, dir, '0.01 0.01 0', 3);
};

void() q2infantry_dead =
{
	setsize (self, '-16 -16 0', '16 16 16');
	self.movetype = MOVETYPE_TOSS;
	self.solid = SOLID_CORPSE;
	//	self.ammo_shells = 5;
	//	DropBackpack();
}

// Death 1

//LOOK MA NO HEAD
framer($FRAME_death101, $FRAME_death120, q2infantry_frames_die1, SUB_Null, 0.1,
	
	frame_arb($FRAME_death101,
		ThrowGib ("models/objects/gibs/head2/tris.md2", self.health);
		q2infantry_dead();
	);
	
	frame_arb($FRAME_death105,
		SpawnBlood (self.origin + '0 0 16', '0 -15 40', 30);
	);
	frame_arb($FRAME_death109,
		SpawnBlood (self.origin + '0 0 16', '0 -15 35', 25);
	);
	frame_arb($FRAME_death113,
		SpawnBlood (self.origin + '8 0 12', '0 35 30', 15);
	);
	frame_arb($FRAME_death117,
		SpawnBlood (self.origin, '0 0 10', 10);
	);
);

// Death 2

framer($FRAME_death201, $FRAME_death225, q2infantry_frames_die2, SUB_Null, 0.1,
	
	frame_arb($FRAME_death201,
		SpawnBlood (self.origin + '0 0 16', '0 -15 40', 30);
		q2infantry_dead();

	);
);

// Death 3

framer($FRAME_death301, $FRAME_death309, q2infantry_frames_die3, SUB_Null, 0.1,
	
	frame_arb($FRAME_death301,
		SpawnBlood (self.origin + '0 0 16', '0 -15 40', 30);
		q2infantry_dead();

	);
);

void() q2infantry_die =
{
	local float	n;
	// check for gib
	if (self.health < -30)
	{
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
		for (n= 0; n < 2; n++)
			ThrowGib ("models/objects/gibs/bone/tris.md2", self.health);
		for (n= 0; n < 4; n++)
			ThrowGib ("models/objects/gibs/sm_meat/tris.md2", self.health);
		
		ThrowHead ("models/objects/gibs/head2/tris.md2", self.health);
		return;
	}

// regular death
	sound (self, CHAN_VOICE, "infantry/infdeth2.wav", 1, ATTN_NORM);
	if (random() < 0.4)
		q2infantry_frames_die1 ();
	if (random() < 0.7)
		q2infantry_frames_die2 ();
	else
		q2infantry_frames_die3 ();
};


/*QUAKED monster_infantry(1 0 0) (-16 -16 -24) (16 16 40) Ambush
*/
void() monster_infantry =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	
	self.classname = "q2monster_infantry";
	
	precache_model ("models/monsters/infantry/tris.md2");
	precache_model ("progs/h_guard.mdl");
	precache_model ("progs/gib1.mdl");
	precache_model ("progs/gib2.mdl");
	precache_model ("progs/gib3.mdl");

	precache_sound ("infantry/infdeth1.wav");
	precache_sound ("infantry/infdeth2.wav");
	precache_sound ("infantry/infidle1.wav");
	precache_sound ("infantry/infpain1.wav");
	precache_sound ("infantry/infpain2.wav");
	precache_sound ("soldier/sattck1.wav");
	precache_sound ("infantry/infsrch1.wav");
	precache_sound ("infantry/INFSGHT1.wav");


	precache_sound ("player/udeath.wav");		// gib death

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "models/monsters/infantry/tris.md2");

	setsize (self, '-16 -16 -24', '16 16 40');
	self.health = 30;
	self.max_health = self.health;

	self.th_stand = q2infantry_select_stand;
	self.th_walk = q2infantry_frames_walk;
	self.th_run = q2infantry_frames_run;
	self.th_missile = q2infantry_frames_start_attack;
	self.th_pain = q2infantry_pain;
	self.th_die = q2infantry_die;
	self.th_melee = q2infantry_melee;

	self.sightSound = "infantry/INFSGHT1.wav";

	walkmonster_start;
};
