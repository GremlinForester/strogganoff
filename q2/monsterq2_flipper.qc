/*
==============================================================================

FLIPPER

==============================================================================
*/

#include "monsterq2_flipper.qh"

#define	FLIPPER_SOUND_PAIN1		"flipper/flppain1.wav"	
#define	FLIPPER_SOUND_PAIN2		"flipper/flppain2.wav"	
#define	FLIPPER_SOUND_DEATH		"flipper/flpdeth1.wav"	
#define	FLIPPER_SOUND_CHOMP		"flipper/flpatck1.wav"
#define	FLIPPER_SOUND_ATTACK	"flipper/flpatck2.wav"
#define	FLIPPER_SOUND_IDLE		"flipper/flpidle1.wav"
#define	FLIPPER_SOUND_SEARCH	"flipper/flpsrch1.wav"
#define	FLIPPER_SOUND_SIGHT		"flipper/flpsght1.wav"

void() q2flipper_frames_run;

//STAND

framerloop($FRAME_flphor01, $FRAME_flphor01, q2flipper_frames_stand, 0.1,ai_stand());

//WALK 

framerloop($FRAME_flphor01, $FRAME_flphor24, q2flipper_frames_walk, 0.1,ai_walk(4));

//RUN START

framer($FRAME_flphor01, $FRAME_flphor05, q2flipper_frames_start_run, q2flipper_frames_run, 0.1, 
	ai_rep($FRAME_flphor01, ai_run, 8,8,8,8,8,0,0,0);
);

//RUN LOOP

framerloop($FRAME_flpver06, $FRAME_flpver29, q2flipper_frames_run, 0.1,

	if (self.frame != $FRAME_flpver06) self.frame = self.frame + 1;
	ai_run(24);
	frame_arb($FRAME_flpver06,if (random() < 0.5) sound (self, CHAN_VOICE, FLIPPER_SOUND_IDLE, 1, ATTN_NORM));
);

framer($FRAME_flppn101, $FRAME_flppn105, q2flipper_frames_pain2, q2flipper_frames_start_run, 0.135,);

framer($FRAME_flppn201, $FRAME_flppn205, q2flipper_frames_pain1, q2flipper_frames_start_run, 0.135,);

void(entity attacker, float damage)	q2flipper_pain =
{
	local vector org;
	org = self.origin + '0 0 24';

	if (self.health < (self.max_health / 2))
		self.skin = 1;

	SpawnBlood (org, '0 0 0', 20);
	
	if (skill == 3)
		return;		// no pain anims in nightmare

	if (self.pain_finished > time)
		return;

	if (random() < 0.5)
	{
		self.pain_finished = time + 1;
		q2flipper_frames_pain1 ();
		sound (self, CHAN_VOICE, FLIPPER_SOUND_PAIN1, 1, ATTN_NORM);
	}
	else
	{
		self.pain_finished = time + 1;
		q2flipper_frames_pain2 ();
		sound (self, CHAN_VOICE, FLIPPER_SOUND_PAIN2, 1, ATTN_NORM);
	}
};

void() q2flipper_bite =
{
	if (!self.enemy)
		return;		// removed before stroke
		
	if (vlen(self.enemy.origin - self.origin) > 60)
		return;
		
	sound (self, CHAN_VOICE, FLIPPER_SOUND_CHOMP, 1, ATTN_NORM);
	self.ldmg_ = (random() + random()) * 3;
	T_Damage (self.enemy, self, self, self.ldmg_);
};

framer($FRAME_flpbit01, $FRAME_flpbit20, q2flipper_frames_attack, q2flipper_frames_start_run, 0.05,

	frame_arb($FRAME_flpbit14, q2flipper_bite(););
	
	frame_arb($FRAME_flpbit19, q2flipper_bite(););
);


void() flipper_dead =
{
	self.movetype = MOVETYPE_TOSS;
	self.solid = SOLID_CORPSE;
}

framer($FRAME_flpdth01, $FRAME_flpdth56, q2flipper_frames_death, SUB_Null, 0.1,

	frame_arb($FRAME_flpdth01,sound (self, CHAN_VOICE, FLIPPER_SOUND_DEATH, 1, ATTN_NORM));
	frame_arb($FRAME_flpdth02, flipper_dead(););
);


void() q2flipper_die =
{
	local float n;
	
// check for gib
 	if (self.health < -20)
	{
		gibMonster();
		remove(self);
		return;
	} 

	if (self.deadflag == DEAD_DEAD)
		return;

// regular death
	self.deadflag = DEAD_DEAD;
	self.takedamage = DAMAGE_YES;
	q2flipper_frames_death();
}

/*QUAKED monster_flipper (1 .5 0) (-16 -16 -24) (16 16 32) Ambush Trigger_Spawn Sight
*/
void () monster_flipper =
{
	self.classname = "monster_flipper";
	
	if (deathmatch)
	{
		remove(self);
		return;
	}
	
	// pre-caches
	precache_model ("models/monsters/flipper/tris.md2");
	
	precache_sound (FLIPPER_SOUND_PAIN1);	
	precache_sound (FLIPPER_SOUND_PAIN2);	
	precache_sound (FLIPPER_SOUND_DEATH);	
	precache_sound (FLIPPER_SOUND_CHOMP);	
	precache_sound (FLIPPER_SOUND_ATTACK);	
	precache_sound (FLIPPER_SOUND_IDLE);	
	precache_sound (FLIPPER_SOUND_SEARCH);	
	precache_sound (FLIPPER_SOUND_SIGHT);	
	
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "models/monsters/flipper/tris.md2");

	setsize (self, '-16 -16 0', '16 16 32');
	self.health = 50;
	self.max_health = self.health;

	self.th_stand = q2flipper_frames_stand;
	self.th_walk = q2flipper_frames_walk;
	self.th_run = q2flipper_frames_run;
	self.th_pain = q2flipper_pain;
	self.th_die = q2flipper_die;
	self.th_melee = q2flipper_frames_attack;

	self.sightSound = FLIPPER_SOUND_SIGHT;

	swimmonster_start;
}
