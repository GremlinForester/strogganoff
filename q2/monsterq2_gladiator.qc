/*
==============================================================================

QUAKE II GLADIATOR

==============================================================================
*/

#include "monsterq2_gladiator.qh"

#define GLADIATOR_SOUND_PAIN1 			"gladiator/pain.wav"
#define GLADIATOR_SOUND_PAIN2 			"gladiator/gldpain2.wav"	
#define GLADIATOR_SOUND_DIE 			"gladiator/glddeth2.wav"
#define GLADIATOR_SOUND_GUN 			"gladiator/railgun.wav"
#define GLADIATOR_SOUND_CLEAVER_SWING 	"gladiator/melee1.wav"
#define GLADIATOR_SOUND_CLEAVER_HIT 	"gladiator/melee2.wav"
#define GLADIATOR_SOUND_CLEAVER_MISS 	"gladiator/melee3.wav"
#define GLADIATOR_SOUND_IDLE 			"gladiator/gldidle1.wav"
#define GLADIATOR_SOUND_SEARCH 			"gladiator/gldsrch1.wav"
#define GLADIATOR_SOUND_SIGHT 			"gladiator/sight.wav"

/*

STAND

*/

framerloop($FRAME_stand1, $FRAME_stand7, q2gladiator_stand, 0.1, ai_stand());

/*

WALK1

*/

framerloop($FRAME_walk1, $FRAME_walk16, q2gladiator_walk, 0.1,

	ai_rep($FRAME_walk1, ai_walk, 15, 7, 6, 5, 2, 0, 2, 8);
	ai_rep($FRAME_walk9, ai_walk, 12, 8, 5, 5, 2, 2, 1, 8);
);

/*

RUN

*/

framerloop($FRAME_run1, $FRAME_run6, q2gladiator_run, 0.1,

	ai_rep($FRAME_run1, ai_run, 23, 14, 14, 21, 12, 13, 0, 0);
);

/*

MELEE

*/

void(float damage) gladiator_melee =
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
			sound(self, CHAN_WEAPON, GLADIATOR_SOUND_CLEAVER_HIT, 1, ATTN_NORM);
		}
/*		else{
		sound(self, CHAN_WEAPON, GLADIATOR_SOUND_CLEAVER_HIT, 1, ATTN_NORM);
		} */
	}
};

// MELEE ATTACK 1

framer($FRAME_melee1, $FRAME_melee9, q2gladiator_melee_attack1, q2gladiator_run, 0.05,

	frame_arb($FRAME_melee5,sound(self, CHAN_WEAPON, GLADIATOR_SOUND_CLEAVER_SWING, 1, ATTN_NORM););
	
	frame_arb($FRAME_melee7, gladiator_melee(20); ai_charge(25););
);

// MELEE ATTACK 2

framer($FRAME_melee10, $FRAME_melee17, q2gladiator_melee_attack2, q2gladiator_run, 0.05,

	frame_arb($FRAME_melee11,sound(self, CHAN_WEAPON, GLADIATOR_SOUND_CLEAVER_SWING, 1, ATTN_NORM););
	
	frame_arb($FRAME_melee14, gladiator_melee(20); ai_charge(25););
);

// Select Attack

void()	q2gladiator_melee_select =
{
	if (random() > 0.5)
	{
		q2gladiator_melee_attack1 ();
	}
	else
	{
		q2gladiator_melee_attack2 ();
	}
};

/*

ATTACK

*/

void() q2gladiator_fire =
{
	local vector org;
	local vector end;
	local vector dir;

	makevectors(self.angles);
	
	org = self.origin + (v_forward * 30) + (v_right * 16) + (v_up * 30);
	
	end = self.enemy.origin - self.enemy.velocity*0.05;
	end_z = end_z + self.enemy.view_ofs_z - self.enemy.velocity*0.05;
	
	dir = normalize(end - org);
	
	monster_fire_railgun(org, end, 20);
};


framer($FRAME_attack1, $FRAME_attack9, q2gladiator_attack, q2gladiator_run, 0.1, ai_face();
	
	frame_arb($FRAME_attack1,
		sound(self, CHAN_WEAPON, GLADIATOR_SOUND_GUN, 1, ATTN_NORM);
	);
	
	frame_arb($FRAME_attack4,
		q2gladiator_fire();
		self.effects = self.effects | EF_MUZZLEFLASH;
	);
	
	frame_arb($FRAME_attack9,
		SUB_AttackFinished(3);
	);
);

// PAIN

framer($FRAME_pain1, $FRAME_pain6, q2gladiator_pain_frames, q2gladiator_run, 0.1, 
	
	frame_arb($FRAME_pain1,
		local	vector	org;
		org = self.origin + '0 0 24';
		SpawnBlood (org, '0 0 0', 20);
	);
	
	frame_arb($FRAME_pain4,
		ai_pain(1);
	);
);

void(entity attacker, float damage)	q2gladiator_pain =
{
	local float r;
	local vector org;
	org = self.origin + '0 0 24';

	if (self.health < (self.max_health / 2))
		self.skin = 1;

	if (self.pain_finished > time)
		return;

	self.pain_finished = time + 1;
	q2gladiator_pain_frames ();
	
	
	if (random() < 0.5)
	{
		sound (self, CHAN_VOICE, GLADIATOR_SOUND_PAIN1, 1, ATTN_NORM);
	}
	else
	{
		sound (self, CHAN_VOICE, GLADIATOR_SOUND_PAIN2, 1, ATTN_NORM);
	}
	
	SpawnBlood (org, '0 0 0', 20);
	
	self.bIsWounded = 1;
	self.bleedcount = 0;
};

//DEATH FRAMES

framer($FRAME_death1, $FRAME_death22, q2gladiator_death_frames, SUB_Null, 0.1,
	
	frame_arb($FRAME_death1,

		self.solid = SOLID_CORPSE;
	//	self.ammo_shells = 5;
	//	DropBackpack();

	setsize (self, '-16 -16 -24', '16 16 -8');
	);
);

void() q2gladiator_die =
{
// check for gib
	if (self.health < -40)
	{
		gibMonster();
		remove(self);
		return;
	}

	// regular death

	self.takedamage = DAMAGE_YES;

 	if (self.deadflag == DEAD_DEAD){
		return;
	}
	else
	{

		sound (self, CHAN_VOICE, GLADIATOR_SOUND_DIE, 1, ATTN_NORM);
		self.deadflag = DEAD_DEAD;
		q2gladiator_death_frames ();
	}
};

void() precache_gladiator =
{
	precache_model ("models/monsters/gladiatr/tris.md2");
	
	precache_sound ("gladiator/pain.wav");
	precache_sound ("gladiator/gldpain2.wav");
	precache_sound ("gladiator/glddeth2.wav");
	precache_sound ("gladiator/railgun.wav");
	precache_sound ("gladiator/melee1.wav");
	precache_sound ("gladiator/melee2.wav");
	precache_sound ("gladiator/melee3.wav");
	precache_sound ("gladiator/gldidle1.wav");
	precache_sound ("gladiator/gldsrch1.wav");
	precache_sound ("gladiator/sight.wav");	
}

/*QUAKED monster_gladiator (1 .5 0) (-32 -32 -24) (32 32 64) Ambush Trigger_Spawn Sight
*/
void () monster_gladiator =
{
	self.classname = "monster_gladiator";
	
	if (deathmatch)
	{
		remove(self);
		return;
	}
	
	precache_gladiator();

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "models/monsters/gladiatr/tris.md2");

	setsize (self, '-32 -32 -24', '32 32 64');
	self.health = 400;
	self.max_health = self.health;

	self.th_stand = q2gladiator_stand;
	self.th_walk = q2gladiator_walk;
	self.th_run = q2gladiator_run;
	self.th_pain = q2gladiator_pain;
	self.th_die = q2gladiator_die;
	self.th_missile = q2gladiator_attack;
	self.th_melee = q2gladiator_melee_select;
	
	self.sightSound = GLADIATOR_SOUND_SIGHT;
	
	walkmonster_start;
}
