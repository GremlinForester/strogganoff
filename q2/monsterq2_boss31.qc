/*
==============================================================================

jorg

==============================================================================
*/

#include "monsterq2_boss31.qh"

#define JORG_SOUND_PAIN1		"boss3/bs3pain1.wav"
#define JORG_SOUND_PAIN2		"boss3/bs3pain2.wav"
#define JORG_SOUND_PAIN3		"boss3/bs3pain3.wav"
#define JORG_SOUND_IDLE			"boss3/bs3idle1.wav"
#define JORG_SOUND_DEATH		"boss3/bs3deth1.wav"
#define JORG_SOUND_SEARCH1		"boss3/bs3srch1.wav"
#define JORG_SOUND_SEARCH2		"boss3/bs3srch2.wav"
#define JORG_SOUND_SEARCH3		"boss3/bs3srch3.wav"
#define JORG_SOUND_ATTACK1		"boss3/bs3atck1.wav"
#define JORG_SOUND_ATTACK2		"boss3/bs3atck2.wav"
#define JORG_SOUND_FIREGUN		"boss3/xfire.wav"
#define JORG_SOUND_STEP_LEFT	"boss3/step1.wav"
#define JORG_SOUND_STEP_RIGHT	"boss3/step2.wav"
#define JORG_SOUND_DEATH_HIT	"boss3/d_hit.wav"

void() jorg_search_sounds =
{
	if (random() < 0.3)
		sound (self, CHAN_VOICE, JORG_SOUND_SEARCH1, 0.5, ATTN_IDLE);	
	else if (random() < 0.6)
		sound (self, CHAN_VOICE, JORG_SOUND_SEARCH2, 0.5, ATTN_IDLE);
	else
		sound (self, CHAN_VOICE, JORG_SOUND_SEARCH3, 0.5, ATTN_IDLE);
}

/*

STAND

*/

framer($FRAME_stand01, $FRAME_stand51, jorg_frames_stand, jorg_frames_stand, 0.135,
	
	frame_arb($FRAME_stand01, sound (self, CHAN_AUTO, JORG_SOUND_IDLE, 1, ATTN_IDLE););
	frame_arb($FRAME_stand34, ai_forward(19););
	frame_arb($FRAME_stand35, ai_forward(11););
	frame_arb($FRAME_stand38, ai_forward(6););
	frame_arb($FRAME_stand39, ai_forward(9););
	frame_arb($FRAME_stand47, ai_forward(-2););
	frame_arb($FRAME_stand48, ai_forward(-17););
	frame_arb($FRAME_stand50, ai_forward(-12););
	frame_arb($FRAME_stand51, ai_forward(-14););

	ai_stand();
);

/*

RUN

*/

framerloop($FRAME_walk06, $FRAME_walk19, jorg_frames_run, 0.1,
	
	ai_rep($FRAME_walk06, ai_run, 17, 0, 0, 0, 12, 8, 10, 33);
	ai_rep($FRAME_walk14, ai_run, 0, 0, 0, 9, 9, 9, 0, 0);
	
	frame_arb($FRAME_walk06, sound (self, CHAN_BODY, JORG_SOUND_STEP_LEFT, 1, ATTN_IDLE););

	frame_arb($FRAME_walk07,
	if (random() < 0.2) 
		jorg_search_sounds();
	);

	frame_arb($FRAME_walk13, sound (self, CHAN_BODY, JORG_SOUND_STEP_RIGHT, 1, ATTN_IDLE););
);

/*

WALK

*/

framerloop($FRAME_walk06, $FRAME_walk19, jorg_frames_walk, 0.1,

	ai_rep($FRAME_walk06, ai_walk, 17, 0, 0, 0, 12, 8, 10, 33);
	ai_rep($FRAME_walk14, ai_walk, 0, 0, 0, 9, 9, 9, 0, 0);

	frame_arb($FRAME_walk06, sound (self, CHAN_BODY, JORG_SOUND_STEP_LEFT, 1, ATTN_IDLE););
	
	frame_arb($FRAME_walk07,
	if (random() < 0.2) 
		jorg_search_sounds();
	);
	
	frame_arb($FRAME_walk13, sound (self, CHAN_BODY, JORG_SOUND_STEP_RIGHT, 1, ATTN_IDLE););
);

/*

Attack 2 - BFG

*/
void() jorg_firebfg =
{
	local	vector	dir;
	local	entity	en;
	local	vector	org;

	sound (self, CHAN_AUTO, JORG_SOUND_FIREGUN, 1, ATTN_NORM);

	en = self.enemy;
	dir = en.origin - en.velocity*0.1;
	dir = normalize (en.origin - self.origin);
	org = self.origin + (v_forward * 30) + (v_right * 16) + (v_up * 36);
	
	monster_fire_bfg(org, dir, 50);
};

framer($FRAME_attak201, $FRAME_attak213, jorg_frames_attack2, jorg_frames_run, 0.135,
	frame_arb($FRAME_attak207, jorg_firebfg(););
	ai_face();
);

/*

Attack 1 - Chainguns

*/
void() jorg_firebullet =
{
	local	vector	dir;
	local	entity	en;
	local	vector	org;

	sound (self, CHAN_AUTO, JORG_SOUND_FIREGUN, 1, ATTN_NORM);

	en = self.enemy;

	//LEFT
	org = self.origin + (v_forward * 78.5) + (v_right * -47.1) + (v_up * 96);
	dir = normalize (en.origin - org);
	pointparticles(particleeffectnum("TE_GLASS_SHATTER"), org, '0 0 0', 1);
	monster_fire_bullet(org, dir, '0.01 0.01 0', 3);
	//RIGHT
	org = self.origin + (v_forward * 78.5) + (v_right * 46.7) + (v_up * 96);
	dir = normalize (en.origin - org);
	pointparticles(particleeffectnum("TE_GLASS_SHATTER"), org, '0 0 0', 1);
	monster_fire_bullet(org, dir, '0.01 0.01 0', 3);
};

void() jorg_reattack1;
void() jorg_frames_attack1;
void() jorg_frames_start_attack1;
void() jorg_frames_end_attack1;

framer($FRAME_attak101, $FRAME_attak108, jorg_frames_start_attack1, jorg_frames_attack1, 0.135,

	ai_face();
);

framer($FRAME_attak109, $FRAME_attak114, jorg_frames_attack1, jorg_reattack1, 0.135,
	frame_arb($FRAME_attak109, jorg_firebullet(););
	frame_arb($FRAME_attak110, jorg_firebullet(););
	frame_arb($FRAME_attak111, jorg_firebullet(););
	frame_arb($FRAME_attak112, jorg_firebullet(););
	frame_arb($FRAME_attak113, jorg_firebullet(););
	frame_arb($FRAME_attak114, jorg_firebullet(););
	ai_face();
);

framer($FRAME_attak115, $FRAME_attak118, jorg_frames_end_attack1, jorg_frames_run, 0.135,);

void() jorg_reattack1 =
{
	if (visible(self.enemy) )
	{
		if (random() <= 0.9)
		{
			jorg_frames_attack1();
		}
		else
		{
			jorg_frames_end_attack1();
		}
	}
	else
	{
		jorg_frames_end_attack1();
	}
}

/*

JORG ATTACK

*/

void() jorg_attack =
{
	if (random() <= 0.75)
	{
		sound (self, CHAN_VOICE, JORG_SOUND_ATTACK1, 1, ATTN_NORM);
		jorg_frames_start_attack1();
	}
	else
	{
		sound (self, CHAN_VOICE, JORG_SOUND_ATTACK2, 1, ATTN_NORM);
		jorg_frames_attack2();
	}
}

/*

DEATH

*/

void () jorg_explode =
{
	local float n;
	
	sound (self, CHAN_VOICE, "misc/udeath.wav", 1, ATTN_NORM);

	if (self.target)
		SUB_UseTargets();
		
	for (n= 0; n < 10; n++)
		ThrowGib ("models/objects/gibs/bone/tris.md2", 400, GIB_FLESH, 1);
	for (n= 0; n < 15; n++)
		ThrowGib ("models/objects/gibs/sm_meat/tris.md2", 500, GIB_FLESH, 1);
	for (n= 0; n < 5; n++)
		ThrowGib ("models/objects/debris1/tris.md2", 500, GIB_FLAMING, 1);
		
	remove(self);
}

void() jorg_dead =
{
	setsize (self, '-16 -16 0', '16 16 16');
	self.movetype = MOVETYPE_TOSS;
	self.solid = SOLID_CORPSE;
}

void (entity targ) jorg_tossmakron =
{
	local entity monster_q2makron;
	local float r;
	
	monster_q2makron = spawn();
	monster_q2makron.origin = self.origin;
	monster_q2makron.origin_z = monster_q2makron.origin_z + 64;
	setmodel (monster_q2makron, "models/monsters/boss3/rider/tris.md2");
	monster_q2makron.solid = SOLID_SLIDEBOX;
	monster_q2makron.movetype = MOVETYPE_STEP;
	monster_q2makron.fixangle = TRUE;
	monster_q2makron.enemy = targ;
	monster_q2makron.target = self.target;	

	setsize (monster_q2makron, '-30 -30 0', '30 30 90');
	monster_q2makron.health = 300;
	
	monster_q2makron.use = monster_use;
	monster_q2makron.ideal_yaw = monster_q2makron.angles * '0 1 0';
	monster_q2makron.yaw_speed = 120;
	monster_q2makron.view_ofs = '0 0 28';
	monster_q2makron.flags = monster_q2makron.flags | FL_MONSTER;
	monster_q2makron.takedamage = DAMAGE_AIM;
	monster_q2makron.th_stand = makron_frames_stand;
	monster_q2makron.th_walk = makron_frames_walk; //q2soldier_2walk1;
	monster_q2makron.th_run = makron_frames_run;
	monster_q2makron.th_missile = makron_attack;
	monster_q2makron.th_pain = makron_pain;
	monster_q2makron.th_die = makron_die;
	monster_q2makron.velocity_z = 300;
	
	monster_q2makron.nextthink = time;
	monster_q2makron.think = monster_q2makron.th_run;
}

// Death 1

framer($FRAME_death01, $FRAME_death50, jorg_die_frames, SUB_Null, 0.1,
	
	frame_arb($FRAME_death01, jorg_dead(););
	frame_arb($FRAME_death48, jorg_tossmakron(self.enemy););
	frame_arb($FRAME_death50, jorg_explode(););
);

void() jorg_die =
{
	sound (self, CHAN_AUTO, JORG_SOUND_DEATH, 1, ATTN_IDLE);
	jorg_die_frames ();
}

// PAIN1

framer($FRAME_pain101, $FRAME_pain103, jorg_move_pain1, jorg_frames_run, 0.135, 
	
	frame_arb($FRAME_pain101,
		local	vector	org;
		org = self.origin + '0 0 24';
		SpawnBlood (org, '0 0 0', 20);
	);
);

// PAIN2

framer($FRAME_pain201, $FRAME_pain203, jorg_move_pain2, jorg_frames_run, 0.135, 
	
	frame_arb($FRAME_pain201,
		local	vector	org;
		org = self.origin + '0 0 24';
		SpawnBlood (org, '0 0 0', 20);
	);
);

//MrC: These ai_forward amounts don't seem accurate. Will fiddle with them later.

framer($FRAME_pain301, $FRAME_pain325, jorg_move_pain3, jorg_frames_run, 0.135,
	ai_rep($FRAME_pain301, ai_forward, -28,-6,-3,-9,-9,0,0,0);
	ai_rep($FRAME_pain309, ai_forward, 19,11,6,9,0,0,-12,-14);
	ai_rep($FRAME_pain317, ai_forward, 0,11,6,9,-2,-17,0,0);
	ai_rep($FRAME_pain325, ai_forward, -9,0,0,0,0,0,0,0);
	frame_arb($FRAME_pain303, sound (self, CHAN_AUTO, JORG_SOUND_STEP_LEFT, 1, ATTN_IDLE););
	frame_arb($FRAME_pain305, sound (self, CHAN_AUTO, JORG_SOUND_STEP_RIGHT, 1, ATTN_IDLE););
	frame_arb($FRAME_pain321, sound (self, CHAN_AUTO, JORG_SOUND_STEP_LEFT, 1, ATTN_IDLE););
	frame_arb($FRAME_pain325, sound (self, CHAN_AUTO, JORG_SOUND_STEP_RIGHT, 1, ATTN_IDLE););
);


void (entity attacker, float damage) jorg_pain =
{
	if(self.health < (self.max_health / 2))
		self.skin = 1;

//	if(self.pain_finished < time)
//		return;

	// Lessen the chance of him going into his pain frames if he takes little damage
	if (damage <= 40)
			return;
	
	if (skill == 3)
		return;		// no pain anims in nightmare

	if (damage <= 50)
	{
		sound (self, CHAN_VOICE, JORG_SOUND_PAIN1, 1, ATTN_NORM);
		jorg_move_pain1();
	}
	else if (damage <= 100)
	{
		sound (self, CHAN_VOICE, JORG_SOUND_PAIN2, 1, ATTN_NORM);
		jorg_move_pain2();
	}
	else
	{
		if (random() <= 0.3)
		{
			sound (self, CHAN_VOICE, JORG_SOUND_PAIN3, 1, ATTN_NORM);
			jorg_move_pain3();
		}
	}
	self.bIsWounded = 1;
	self.bleedcount = 0;
};

void() UpdateMakronRiderFrames =
{
	if (self.owner.frame == $FRAME_death48)
	{
		remove(self);
		return;
	}
	self.frame = self.owner.frame;
	self.think = UpdateMakronRiderFrames;
	self.nextthink = time;	
};

void() AttachMakronRider =
{
	local entity MakronRider;
	
	MakronRider = spawn();
	setorigin (MakronRider, '0 0 0');
	MakronRider.owner = self;
	MakronRider.netname = "q2monster_jorg_rider";
	setmodel (MakronRider, "models/monsters/boss3/rider/tris.md2");
	MakronRider.solid = SOLID_NOT;
	MakronRider.movetype = MOVETYPE_NOCLIP;
	MakronRider.think = UpdateMakronRiderFrames;
	MakronRider.nextthink = time;

	setattachment(MakronRider, self, "");
};

/*QUAKED monster_jorg (1 .5 0) (-80 -80 0) (90 90 140) Ambush Trigger_Spawn Sight
*/
void() monster_jorg =
{
	self.classname = "q2monster_jorg";
	
	if (deathmatch)
	{
		remove(self);
		return;
	}

	precache_model ("models/monsters/boss3/rider/tris.md2");
	precache_model ("models/monsters/boss3/jorg/tris.md2");
	
	precache_sound (JORG_SOUND_PAIN1);
	precache_sound (JORG_SOUND_PAIN2);	
	precache_sound (JORG_SOUND_PAIN3);	
	precache_sound (JORG_SOUND_IDLE);	
	precache_sound (JORG_SOUND_DEATH);	
	precache_sound (JORG_SOUND_SEARCH1);	
	precache_sound (JORG_SOUND_SEARCH2);	
	precache_sound (JORG_SOUND_SEARCH3);	
	precache_sound (JORG_SOUND_ATTACK1);	
	precache_sound (JORG_SOUND_ATTACK2);	
	precache_sound (JORG_SOUND_FIREGUN);	
	precache_sound (JORG_SOUND_STEP_LEFT);	
	precache_sound (JORG_SOUND_STEP_RIGHT);	
	precache_sound (JORG_SOUND_DEATH_HIT);		

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "models/monsters/boss3/jorg/tris.md2");

	setsize (self, '-80 -80 0', '80 80 140');
	self.health = 3000;
	self.max_health = self.health;

	self.th_stand = jorg_frames_stand;
	self.th_walk = jorg_frames_walk;
	self.th_run = jorg_frames_run;
	self.th_pain = jorg_pain;
	self.th_die = jorg_die;
	self.th_missile = jorg_attack;

	self.sightSound = JORG_SOUND_SEARCH1;

	AttachMakronRider();

	walkmonster_start;
}
