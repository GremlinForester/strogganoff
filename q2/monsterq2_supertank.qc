/*
==============================================================================

SUPERTANK

==============================================================================
*/

#include "monsterq2_supertank.qh"

#define SUPERTANK_SOUND_PAIN1		"bosstank/btkpain1.wav"
#define SUPERTANK_SOUND_PAIN2		"bosstank/btkpain2.wav"
#define SUPERTANK_SOUND_PAIN3		"bosstank/btkpain3.wav"
#define SUPERTANK_SOUND_DEATH		"bosstank/btkdeth1.wav"
#define SUPERTANK_SOUND_SEARCH1		"bosstank/btkunqv1.wav"
#define SUPERTANK_SOUND_SEARCH2		"bosstank/btkunqv2.wav"
#define SUPERTANK_SOUND_TREAD		"bosstank/btkengn1.wav"

//Search sounds not used, but left in in case used in future

void() q2boss1_reattack1;
void() q2boss1_reattack2;

void() q2boss1_search =
{
	if (random() < 0.5)
		sound (self, CHAN_VOICE, SUPERTANK_SOUND_SEARCH1, 1, ATTN_NORM);
	else
		sound (self, CHAN_VOICE, SUPERTANK_SOUND_SEARCH1, 1, ATTN_NORM);
}

// STAND

framerloop($FRAME_stand_1, $FRAME_stand_60, q2boss1_frames_stand, 0.1, ai_stand(););

// RUN

framerloop($FRAME_forwrd_1, $FRAME_forwrd_18, q2boss1_frames_run, 0.1,

	frame_arb($FRAME_forwrd_1, sound (self, CHAN_BODY, SUPERTANK_SOUND_TREAD, 1, ATTN_IDLE));

	ai_run(12);
);


// WALK

framerloop($FRAME_forwrd_1, $FRAME_forwrd_18, q2boss1_frames_walk, 0.1,

	frame_arb($FRAME_forwrd_1, sound (self, CHAN_VOICE, SUPERTANK_SOUND_TREAD, 1, ATTN_IDLE));

	ai_walk(4);
);

// PAIN3

framer($FRAME_pain3_9, $FRAME_pain3_12, q2boss1_frames_pain3, q2boss1_frames_run, 0.135, 
	
	frame_arb($FRAME_pain3_9,
		local	vector	org;
		org = self.origin + '0 0 24';
		SpawnBlood (org, '0 0 0', 20);
	);
);

// PAIN2

framer($FRAME_pain2_5, $FRAME_pain2_8, q2boss1_frames_pain2, q2boss1_frames_run, 0.135, 
	
	frame_arb($FRAME_pain2_5,
		local	vector	org;
		org = self.origin + '0 0 24';
		SpawnBlood (org, '0 0 0', 20);
	);
);

// PAIN1

framer($FRAME_pain1_1, $FRAME_pain1_4, q2boss1_frames_pain1, q2boss1_frames_run, 0.135, 
	
	frame_arb($FRAME_pain1_1,
		local	vector	org;
		org = self.origin + '0 0 24';
		SpawnBlood (org, '0 0 0', 20);
	);
);

void() q2boss1_firerocket =
{
	local vector org;
	local vector end;
	local vector dir;
	
	makevectors(self.angles);
	
	end = self.enemy.origin;
	end_z = end_z + self.enemy.view_ofs_z;

	if (self.frame == $FRAME_attak2_8)
	{
		org = self.origin + (v_forward * 16) + (v_right * -22.5) + (v_up * 91.2);
		dir = normalize(end - org);
		monster_fire_rocket(org, dir, 50);
	}
	else if (self.frame == $FRAME_attak2_11)
	{
		org = self.origin + (v_forward * 16) + (v_right * -33.4) + (v_up * 86.7);
		dir = normalize(end - org);
		monster_fire_rocket(org, dir, 50);
	}
	else
	{
		org = self.origin + (v_forward * 16) + (v_right * -42.8) + (v_up * 83.3);
		dir = normalize(end - org);
		monster_fire_rocket(org, dir, 50);
	}
	//TODO: rocket fire sound
	//sound(self, CHAN_WEAPON, "", 1, ATTN_NORM);
};	

void() q2boss1_firebullet =
{
	local	vector	dir;
	local	entity	en;
	local	vector	org;
	//TODO: Fire sound
	//sound (self, CHAN_AUTO, "", 1, ATTN_NORM);

	en = self.enemy;

	org = self.origin + (v_forward * 30) + (v_right * 30) + (v_up * 88.5);
	dir = normalize (en.origin - org);
	pointparticles(particleeffectnum("TE_GLASS_SHATTER"), org, '0 0 0', 1);
	monster_fire_bullet(org, dir, '0.01 0.01 0', 3);
};


/*

ATTACK 2 (ROCKETS)

*/

framer($FRAME_attak2_1, $FRAME_attak2_27, q2boss1_frames_attack2, q2boss1_reattack2, 0.135,
	frame_arb($FRAME_attak2_8, q2boss1_firerocket();ai_face(););
	frame_arb($FRAME_attak2_11, q2boss1_firerocket();ai_face(););
	frame_arb($FRAME_attak2_14, q2boss1_firerocket(););
//	ai_face();
);

/*

ATTACK 1 (MG)

*/

//testing: ai_face for one shot, otherwise tank looks odd spining in place and this gives players a chance to dodge out of harms way

framer($FRAME_attak1_1, $FRAME_attak1_6, q2boss1_frames_attack1, q2boss1_reattack1, 0.135,
	frame_arb($FRAME_attak1_1, q2boss1_firebullet();ai_face(););
	frame_arb($FRAME_attak1_2, q2boss1_firebullet(););
	frame_arb($FRAME_attak1_3, q2boss1_firebullet(););
	frame_arb($FRAME_attak1_4, q2boss1_firebullet(););
	frame_arb($FRAME_attak1_5, q2boss1_firebullet(););
	frame_arb($FRAME_attak1_6, q2boss1_firebullet(););
//	ai_face();
);

//END MACHINEGUN ATTACK1

framer($FRAME_attak1_7, $FRAME_attak1_20, q2boss1_frames_end_attack1, q2boss1_frames_run, 0.135,);

/*
TODO: test to see if infront AND visible work better together.
Previously was just visible but have run into cases of monsters shooting at player with their backs turned.
May have to apply this elsewhere.
*/

void() q2boss1_reattack1 =
{
	if (infront(self.enemy) && visible(self.enemy) && self.enemy.health > 0)
	{
		if (random() <= 0.9)
		{
			q2boss1_frames_attack1();
		}
		else
		{
			q2boss1_frames_end_attack1();
		}
	}
	else
	{
		q2boss1_frames_end_attack1();
	}
}

void() q2boss1_reattack2 =
{
	if (infront(self.enemy) && visible(self.enemy) && self.enemy.health > 0)
	{
		if (random() <= 0.9)
		{
			q2boss1_frames_attack2();
		}
		else
		{
			q2boss1_frames_run();
		}
	}
	else
	{
		q2boss1_frames_run();
	}
}

void (entity attacker, float damage) q2boss1_pain =
{

	if (self.health < (self.max_health / 2))
			self.skin = 1;

	if (self.pain_finished > time)
		return;

	// Lessen the chance of him going into his pain frames
	if (damage <= 25)
		if (random()<0.2)
			return;

	// Don't go into pain if he's firing his rockets
	if (skill >= 2)
		if ( (self.frame >= $FRAME_attak2_1) && (self.frame <= $FRAME_attak2_14) )
			return;

	if (skill == 3)
		return;		// no pain anims in nightmare

	if (damage <= 10)
	{
		sound (self, CHAN_VOICE, SUPERTANK_SOUND_PAIN1, 1, ATTN_NORM);
		self.pain_finished = time + 5;
		q2boss1_frames_pain1();
	}
	else if (damage <= 25)
	{
		sound (self, CHAN_VOICE, SUPERTANK_SOUND_PAIN3, 1, ATTN_NORM);
		self.pain_finished = time + 5;
		q2boss1_frames_pain2();
	}
	else
	{
		sound (self, CHAN_VOICE, SUPERTANK_SOUND_PAIN2, 1, ATTN_NORM);
		self.pain_finished = time + 5;
		q2boss1_frames_pain3();
	}
};

void() q2boss1_attack =
{
	float	range;

	range = vlen ((self.origin) - (self.enemy.origin + self.enemy.origin));

	// Attack 1 == Chaingun
	// Attack 2 == Rocket Launcher
	if (infront(self.enemy) && visible(self.enemy))
	{
		if (range <= 260)
		{
			q2boss1_frames_attack1();
		}
		else
		{	// fire rockets more often at distance
		if (random() < 0.3)
			q2boss1_frames_attack1();
		else
			q2boss1_frames_attack2();
		}
	}
	else
	{
		q2boss1_frames_run();
	}
}

/*

DEATH

*/

void () q2boss1_explode =
{
	local float n;
	local vector org;
	
	sound (self, CHAN_VOICE, "misc/udeath.wav", 1, ATTN_NORM);

	if (self.target)
		SUB_UseTargets();
	
	gibMonster();

	remove(self);
}

void() q2boss1_dead =
{
	self.movetype = MOVETYPE_TOSS;
	self.solid = SOLID_CORPSE;
	self.count = 0;
}

// Death

framer($FRAME_death_1, $FRAME_death_24, q2boss1_frames_death, SUB_Null, 0.1,
	
	frame_arb($FRAME_death_1, q2boss1_dead(););
	frame_arb($FRAME_death_24, q2boss1_explode(););
);

void() q2boss1_die =
{
	sound (self, CHAN_AUTO, SUPERTANK_SOUND_DEATH, 1, ATTN_IDLE);
	q2boss1_frames_death();
}

/*QUAKED monster_supertank (1 .5 0) (-64 -64 0) (64 64 72) Ambush Trigger_Spawn Sight
*/
void() monster_supertank =
{
	self.classname = "monster_supertank";
	
	if (deathmatch)
	{
		remove(self);
		return;
	}

	precache_model ("models/monsters/boss1/tris.md2");

	precache_sound (SUPERTANK_SOUND_PAIN1);
	precache_sound (SUPERTANK_SOUND_PAIN2);	
	precache_sound (SUPERTANK_SOUND_PAIN3);	
	precache_sound (SUPERTANK_SOUND_DEATH);	
	precache_sound (SUPERTANK_SOUND_SEARCH1);	
	precache_sound (SUPERTANK_SOUND_SEARCH2);	
	precache_sound (SUPERTANK_SOUND_TREAD);	

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "models/monsters/boss1/tris.md2");

	setsize (self, '-64 -64 0', '64 64 112');
	self.health = 1500;
	self.max_health = self.health;

	self.th_stand = q2boss1_frames_stand;
	self.th_walk = q2boss1_frames_walk;
	self.th_run = q2boss1_frames_run;
	self.th_pain = q2boss1_pain;
	self.th_die = q2boss1_die;
	self.th_missile = q2boss1_attack;

	if (random() < 0.5)
		self.sightSound = SUPERTANK_SOUND_SEARCH1;
	else
		self.sightSound = SUPERTANK_SOUND_SEARCH2;

	walkmonster_start;
}
