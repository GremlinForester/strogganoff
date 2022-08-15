/*
==============================================================================

chick

==============================================================================
*/

#include "monsterq2_chick.qh"

#define	CHICK_SOUND_MISSILE_PRELAUNCH	"chick/chkatck1.wav"
#define CHICK_SOUND_MISSILE_LAUNCH 		"chick/chkatck2.wav"
#define	CHICK_SOUND_MELEE_SWING 		"chick/chkatck3.wav"
#define	CHICK_SOUND_MELEE_HIT 			"chick/chkatck4.wav"
#define	CHICK_SOUND_MISSILE_RELOAD 		"chick/chkatck5.wav"
#define	CHICK_SOUND_DEATH1 				"chick/chkdeth1.wav"
#define	CHICK_SOUND_DEATH2 				"chick/chkdeth2.wav"
#define	CHICK_SOUND_FALL_DOWN 			"chick/chkfall1.wav"
#define	CHICK_SOUND_IDLE1 				"chick/chkidle1.wav"
#define	CHICK_SOUND_IDLE2 				"chick/chkidle2.wav"
#define	CHICK_SOUND_PAIN1 				"chick/chkpain1.wav"
#define	CHICK_SOUND_PAIN2 				"chick/chkpain2.wav"
#define	CHICK_SOUND_PAIN3 				"chick/chkpain3.wav"
#define	CHICK_SOUND_SIGHT 				"chick/chksght1.wav"
#define	CHICK_SOUND_SEARCH 				"chick/chksrch1.wav"

void() q2chick_moan_sounds =
{
	if (random() < 0.5)
		sound (self, CHAN_VOICE, CHICK_SOUND_IDLE1, 0.5, ATTN_IDLE);	
	else
		sound (self, CHAN_VOICE, CHICK_SOUND_IDLE2, 0.5, ATTN_IDLE);	
}

void() q2chick_death_sounds =
{
	if (random() < 0.5)
		sound (self, CHAN_VOICE, CHICK_SOUND_DEATH1, 0.5, ATTN_NORM);	
	else
		sound (self, CHAN_VOICE, CHICK_SOUND_DEATH2, 0.5, ATTN_NORM);	
}

void() q2chick_select_stand;

/*

STAND1

*/

framer($FRAME_stand101, $FRAME_stand130, q2chick_frames_stand, q2chick_select_stand, 0.1,
	ai_stand();
);


/*

STAND FIDGET

*/

framer($FRAME_stand201, $FRAME_stand230, q2chick_stand_fidget, q2chick_select_stand, 0.1,
	frame_arb($FRAME_stand209, q2chick_moan_sounds(););
	ai_stand();
);

/*
STAND SELECTOR

Chooses between regular idle and randomly playing a fidget animation

*/

void()	q2chick_select_stand =
{
	if (self.health <= 0)
		return;
	
	if (random() > 0.1)
	{
		q2chick_frames_stand ();
		return;
	}
	else
	{
		q2chick_stand_fidget ();
		return;
	}
};

/*

The original monster had a start sequence, where she seemed to compose herself
before running. This was skipped to allow her to just get straight into running.

Also running is played at 1.5X the speed of walking.

*/

/*

RUN

*/

framerloop($FRAME_walk11, $FRAME_walk20, q2chick_frames_run, 0.075,

//	frame_arb(FRAME_walkc5, footsetp(););
//	frame_arb(FRAME_walkc10, footstep(););
	frame_arb($FRAME_walk13,

	if (self.bIsWounded && self.bleedcount < MAX_BLEED)
	{
		local	vector	org;
		org = self.origin + '0 0 24';
		SpawnBlood (org, '0 0 0', 5);
		self.bleedcount++;
	}
	);
	
	ai_rep($FRAME_walk11, ai_run, 6, 8, 13, 5, 7, 4, 11, 5);
	ai_rep($FRAME_walk19, ai_run, 9, 7, 0, 0, 0, 0, 0, 0);
);

/*

WALK

*/

framerloop($FRAME_walk11, $FRAME_walk20, q2chick_frames_walk, 0.1,

//	frame_arb(FRAME_walkc5, footsetp(););
//	frame_arb(FRAME_walkc10, footstep(););
	frame_arb($FRAME_walk13,

	if (self.bIsWounded && self.bleedcount < MAX_BLEED)
	{
		local	vector	org;
		org = self.origin + '0 0 24';
		SpawnBlood (org, '0 0 0', 5);
		self.bleedcount++;
	}
	);
	
	ai_rep($FRAME_walk11, ai_walk, 6, 8, 13, 5, 7, 4, 11, 5);
	ai_rep($FRAME_walk19, ai_walk, 9, 7, 0, 0, 0, 0, 0, 0);
);

// PAIN1

framer($FRAME_pain101, $FRAME_pain105, q2chick_pain1, q2chick_frames_run, 0.135, 
	
	frame_arb($FRAME_pain101,
		local	vector	org;
		org = self.origin + '0 0 24';
		SpawnBlood (org, '0 0 0', 20);
	);
);

// PAIN2

framer($FRAME_pain201, $FRAME_pain205, q2chick_pain2, q2chick_frames_run, 0.135, 
	
	frame_arb($FRAME_pain201,
		local	vector	org;
		org = self.origin + '0 0 24';
		SpawnBlood (org, '0 0 0', 20);
	);
);

void(entity attacker, float damage)	q2chick_pain =
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

	if (random() < 0.5)
	{
		self.pain_finished = time + 3.5;
		q2chick_pain1 ();
		sound (self, CHAN_VOICE, CHICK_SOUND_PAIN1, 1, ATTN_NORM);
	}
	else
	{
		self.pain_finished = time + 3.5;
		q2chick_pain2 ();
		sound (self, CHAN_VOICE, CHICK_SOUND_PAIN2, 1, ATTN_NORM);
	}
};

/*

MISSILE

*/

void() q2chick_fire =
{
	local vector org;
	local vector end;
	local vector dir;
	
	makevectors(self.angles);
	
	org = self.origin + (v_forward * 30) + (v_right * -16) + (v_up * 36);
	
	end = self.enemy.origin;
	end_z = end_z + self.enemy.view_ofs_z;
	
	dir = normalize(end - org);
	
	monster_fire_rocket(org, dir, autocvar_sk_q2chick_missile_damage);
	sound(self, CHAN_WEAPON, CHICK_SOUND_MISSILE_LAUNCH, 1, ATTN_NORM);
};

/*

MELEE

*/

void(float damage) q2chick_melee =
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
		//	SpawnMeatSpray (self.origin + v_forward*16, crandom() * 100 * v_right);
			sound(self, CHAN_WEAPON2, CHICK_SOUND_MELEE_HIT, 1, ATTN_NORM);
		}
	}
};

framer($FRAME_attak201, $FRAME_attak216, q2chick_melee_attack, q2chick_frames_run, 0.05,

	frame_arb($FRAME_attak203,sound(self, CHAN_WEAPON, CHICK_SOUND_MELEE_SWING, 1, ATTN_NORM););
	
	frame_arb($FRAME_attak205, q2chick_melee(autocvar_sk_q2chick_melee_damage); ai_charge(25););
);

/*

DEATH

*/

void() q2chick_dead =
{
	setsize (self, '-16 -16 -24', '16 16 -8');
	self.movetype = MOVETYPE_TOSS;
	self.solid = SOLID_CORPSE;
}

// Death 1

framer($FRAME_death101, $FRAME_death112, q2chick_die1_frames, SUB_Null, 0.1,
	
	frame_arb($FRAME_death101,

		q2chick_dead();
	//	self.ammo_shells = 5;
	//	DropBackpack();
	);
);

// Death 2

framer($FRAME_death201, $FRAME_death223, q2chick_die2_frames, SUB_Null, 0.1,
	
	frame_arb($FRAME_death201,

		q2chick_dead();
	//	self.ammo_shells = 5;
	//	DropBackpack();
	);
);

void() q2chick_die =
{
	local float n;

 	if (self.health < -80)
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
	q2chick_death_sounds();
	self.deadflag = DEAD_DEAD;
	if (random() < 0.5)
		q2chick_die1_frames ();
	else
		q2chick_die2_frames ();
	}
};

framer($FRAME_attak101, $FRAME_attak132, q2chick_missile_attack, q2chick_frames_run, 0.1,
	
	frame_arb($FRAME_attak101,
		sound (self, CHAN_VOICE, CHICK_SOUND_MISSILE_PRELAUNCH, 1, ATTN_NORM);
	);
	
	frame_arb($FRAME_attak113,
		sound (self, CHAN_VOICE, CHICK_SOUND_MISSILE_LAUNCH, 1, ATTN_NORM);
	);

	frame_arb($FRAME_attak114,
		self.effects = self.effects | EF_MUZZLEFLASH;
		q2chick_fire();
	);

	frame_arb($FRAME_attak121,
		sound (self, CHAN_VOICE, CHICK_SOUND_MISSILE_RELOAD, 1, ATTN_NORM);
	);
	
	frame_arb($FRAME_attak132,
		SUB_AttackFinished(4);
	);
	
	ai_face();
);

void() precache_chick =
{
	// pre-caches
	precache_model ("models/monsters/bitch/tris.md2");
	
	precache_sound ("chick/chkatck1.wav");	
	precache_sound ("chick/chkatck2.wav");	
	precache_sound ("chick/chkatck3.wav");	
	precache_sound ("chick/chkatck4.wav");	
	precache_sound ("chick/chkatck5.wav");	
	precache_sound ("chick/chkdeth1.wav");	
	precache_sound ("chick/chkdeth2.wav");	
	precache_sound ("chick/chkfall1.wav");	
	precache_sound ("chick/chkidle1.wav");	
	precache_sound ("chick/chkidle2.wav");	
	precache_sound ("chick/chkpain1.wav");	
	precache_sound ("chick/chkpain2.wav");	
	precache_sound ("chick/chkpain3.wav");	
	precache_sound ("chick/chksght1.wav");	
	precache_sound ("chick/chksrch1.wav");	
}

/*QUAKED monster_chick (1 .5 0) (-16 -16 -24) (16 16 32) Ambush Trigger_Spawn Sight
*/
void () monster_chick =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	
	self.classname = "monster_chick";
	
	precache_chick();
	
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "models/monsters/bitch/tris.md2");

	setsize (self, '-16 -16 0', '16 16 56');
	self.health = autocvar_sk_q2chick_health;
	self.max_health = self.health;

	self.th_stand = q2chick_frames_stand;
	self.th_walk = q2chick_frames_walk;
	self.th_run = q2chick_frames_run;
	self.th_pain = q2chick_pain;
	self.th_die = q2chick_die;
	self.th_missile = q2chick_missile_attack;
	self.th_melee = q2chick_melee_attack;

	self.sightSound = CHICK_SOUND_SIGHT;

	walkmonster_start;
}
