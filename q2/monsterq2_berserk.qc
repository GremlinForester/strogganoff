/*
==============================================================================

QUAKE II BERSERK

==============================================================================
*/


#include "monsterq2_berserk.qh"

#define BERSERK_SOUND_PAIN 		"berserk/berpain2.wav"
#define BERSERK_SOUND_DIE 		"berserk/berdeth2.wav"
#define BERSERK_SOUND_IDLE		"berserk/beridle1.wav"
#define BERSERK_SOUND_ATTACK	"berserk/attack.wav"
#define BERSERK_SOUND_SEARCH	"berserk/bersrch1.wav"
#define BERSERK_SOUND_SIGHT		"berserk/sight.wav"

void() q2berserk_select_stand;

/*

STAND1

*/

framer($FRAME_stand1, $FRAME_stand5, q2berserk_stand_idle, q2berserk_select_stand, 0.1,
	ai_stand();
);

/*

STAND FIDGET

*/

framer($FRAME_standb1, $FRAME_standb20, q2berserk_stand_fidget, q2berserk_select_stand, 0.1,

frame_arb($FRAME_standb2, sound (self, CHAN_VOICE, BERSERK_SOUND_IDLE, 1, ATTN_NORM););

	ai_stand();
);

/*
STAND SELECTOR

Chooses between regular idle and randomly playing a fidget animation

*/

void()	q2berserk_select_stand =
{
	if (self.health <= 0)
		return;
	
	if (random() > 0.05)
	{
		q2berserk_stand_idle ();
		return;
	}
	else
	{
		q2berserk_stand_fidget ();
		return;
	}
};

// WALK

framerloop($FRAME_walkc1, $FRAME_walkc11, q2berserk_walk, 0.1,

//	frame_arb(FRAME_walkc5, footsetp(););
//	frame_arb(FRAME_walkc10, footstep(););

	ai_rep($FRAME_walkc1, ai_walk, 9.1, 6.3, 4.9, 6.7, 6.0, 8.2, 7.2, 6.1);
	ai_rep($FRAME_walkc9, ai_walk, 4.9, 4.7, 4.7, 4.8, 0, 0, 0, 0);
);

// RUN

framerloop($FRAME_run1, $FRAME_run6, q2berserk_run, 0.1,

//	frame_arb(FRAME_walkc5, footsetp(););
//	frame_arb(FRAME_walkc10, footstep(););
	frame_arb($FRAME_run2,

	if (self.bIsWounded && self.bleedcount < MAX_BLEED)
	{
		local	vector	org;
		org = self.origin + '0 0 24';
		SpawnBlood (org, '0 0 0', 5);
		self.bleedcount++;
	}
	);

	ai_rep($FRAME_run1, ai_run, 21, 11, 21, 25, 18, 19, 0, 0);
);

/*

BERSERK MELEE ATTACK

*/


// MrC TODO: Add more attacks and effects. Like an AOE slam attack.

void(float damage) berserk_spike =
{
	if (!self.enemy)
		return;
	if (!CanDamage (self.enemy, self))
		return;

	ai_charge(10);

//	delta = self.enemy.origin - self.origin;

	if (vlen(self.enemy.origin - self.origin) > 125)
		return;
		
	self.ldmg_ = (random() + random() + random()) * damage;
	T_Damage (self.enemy, self, self, self.ldmg_);
	
	if (damage)
	{
		makevectors (self.angles);
		if (damage == 1)
			SpawnMeatSpray (self.origin + v_forward*16, crandom() * 100 * v_right);
		else
			SpawnMeatSpray (self.origin + v_forward*16, damage * v_right);
	}
};

// ATTACK 1

framer($FRAME_att_c1, $FRAME_att_c8, q2berserk_melee_attack1, q2berserk_run, 0.1,

	frame_arb($FRAME_att_c4,sound(self, CHAN_WEAPON, BERSERK_SOUND_ATTACK, 1, ATTN_NORM));
	
	frame_arb($FRAME_att_c5, berserk_spike(autocvar_sk_q2berserk_melee_damage); ai_charge(25););
);

// ATTACK 2

framer($FRAME_att_c9, $FRAME_att_c20, q2berserk_melee_attack2, q2berserk_run, 0.1,

	frame_arb($FRAME_att_c9,sound(self, CHAN_WEAPON, BERSERK_SOUND_ATTACK, 1, ATTN_NORM));
	
	frame_arb($FRAME_att_c14, berserk_spike(autocvar_sk_q2berserk_melee_damage); ai_charge(25););
);

// Select Attack

void()	q2berserk_melee =
{
	if (random() > 0.5)
	{
		q2berserk_melee_attack1 ();
	}
	else
	{
		q2berserk_melee_attack2 ();
	}
};

// PAIN1

framer($FRAME_painc1, $FRAME_painc4, q2berserk_pain1, q2berserk_run, 0.1, 
	
	frame_arb($FRAME_painc1,
		local	vector	org;
		org = self.origin + '0 0 24';
		SpawnBlood (org, '0 0 0', 20);
	);
	
	frame_arb($FRAME_painc4,
		ai_pain(1);
	);
);

// PAIN2

framer($FRAME_painb1, $FRAME_painb20, q2berserk_pain2, q2berserk_run, 0.1, 
	
	frame_arb($FRAME_painb1,
		local	vector	org;
		org = self.origin + '0 0 24';
		SpawnBlood (org, '0 0 0', 20);
	);
	
	frame_arb($FRAME_painc4,
		ai_pain(1);
	);
);

void(entity attacker, float damage)	q2berserk_pain =
{
	local vector org;
	org = self.origin + '0 0 24';

	if (self.health < (self.max_health / 2))
		self.skin = 1;

	if (self.pain_finished > time)
		return;

	if ((damage < 20) || (random() < 0.5)){
		self.pain_finished = time + 3.4;
		q2berserk_pain1 ();
		sound (self, CHAN_VOICE, BERSERK_SOUND_PAIN, 1, ATTN_NORM);
	}
	else{
		self.pain_finished = time + 2;
		q2berserk_pain2 ();
		sound (self, CHAN_VOICE, BERSERK_SOUND_PAIN, 1, ATTN_NORM);
	}
	
	SpawnBlood (org, '0 0 0', 20);
	
	self.bIsWounded = 1;
	self.bleedcount = 0;
};

void() q2berserk_dead =
{
	setsize (self, '-16 -16 -24', '16 16 -8');
	self.movetype = MOVETYPE_TOSS;
	self.solid = SOLID_CORPSE;
}

// DIE1

framer($FRAME_death1, $FRAME_death13, q2berserk_die1, SUB_Null, 0.1,
	
	frame_arb($FRAME_death2,

		q2berserk_dead();
	);
);

//DIE2

framer($FRAME_deathc1, $FRAME_deathc8, q2berserk_die2, SUB_Null, 0.1,
	
	frame_arb($FRAME_deathc2,

		q2berserk_dead();
	);
);

void() q2berserk_die =
{
// check for gib
	if (self.health < -40)
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
	sound (self, CHAN_VOICE, BERSERK_SOUND_DIE, 1, ATTN_NORM);
	self.deadflag = DEAD_DEAD;
	
	DropLoot(LOOT_SHELLS, floor(random()*8)+1, self.origin);
	
	if (random() < 0.5)
		q2berserk_die1 ();
	else
		q2berserk_die2 ();

	}
};

void() precache_berserk =
{
	// pre-caches
	precache_model ("models/monsters/berserk/tris.md2");
	
	precache_sound ("berserk/berpain2.wav");
	precache_sound ("berserk/berdeth2.wav");
	precache_sound ("berserk/beridle1.wav");
	precache_sound ("berserk/attack.wav");
	precache_sound ("berserk/bersrch1.wav");
	precache_sound ("berserk/sight.wav");	
}

/*QUAKED monster_berserk (1 .5 0) (-16 -16 -24) (16 16 32) Ambush Trigger_Spawn Sight
*/
void () monster_berserk =
{
	self.classname = "monster_berserk";
	if (deathmatch)
	{
		remove(self);
		return;
	}

	precache_berserk();
	
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "models/monsters/berserk/tris.md2");

	setsize (self, '-16 -16 -24', '16 16 32');
	self.health = autocvar_sk_q2berserk_health;
	self.max_health = self.health;

	self.th_stand = q2berserk_select_stand;
	self.th_walk = q2berserk_walk;
	self.th_run = q2berserk_run;
	self.th_pain = q2berserk_pain;
	self.th_die = q2berserk_die;
	self.th_melee = q2berserk_melee;
	
	self.sightSound = BERSERK_SOUND_SIGHT;
	
	walkmonster_start;
}
