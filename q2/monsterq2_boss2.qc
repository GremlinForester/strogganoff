/*
==============================================================================

boss2 - HORNET

==============================================================================
*/

#include "monsterq2_boss2.qh"

#define HORNET_SOUND_PAIN1		"bosshovr/bhvpain1.wav"
#define HORNET_SOUND_PAIN2		"bosshovr/bhvpain2.wav"
#define HORNET_SOUND_PAIN3		"bosshovr/bhvpain3.wav"
#define HORNET_SOUND_DEATH		"bosshovr/bhvdeth1.wav"
#define HORNET_SOUND_SEARCH1	"bosshovr/bhvunqv1.wav"
#define HORNET_SOUND_HOVER 		"bosshovr/bhvengn1.wav"

void() q2boss2_select_stand;
void() q2boss2_reattack_mg;
void() q2boss2_frames_attack_mg;

/*

MISSILE

*/

void() q2boss2_fire_rockets =
{
	local vector org;
	local vector end;
	local vector dir;
	
	makevectors(self.angles);
	
	end = self.enemy.origin;
	end_z = end_z + self.enemy.view_ofs_z;


	org = self.origin + (v_forward * 22) + (v_right * 16) + (v_up * 10);
		dir = normalize(end - org);
	monster_fire_rocket(org, dir, 50);
	org = self.origin + (v_forward * 22) + (v_right * 8) + (v_up * 10);
		dir = normalize(end - org);
	monster_fire_rocket(org, dir, 50);
	org = self.origin + (v_forward * 22) + (v_right * -8) + (v_up * 10);
		dir = normalize(end - org);
	monster_fire_rocket(org, dir, 50);
	org = self.origin + (v_forward * 22) + (v_right * -16) + (v_up * 10);
		dir = normalize(end - org);
	monster_fire_rocket(org, dir, 50);
	
	//TODO: Rocket firing sound
	//sound(self, CHAN_WEAPON, "", 1, ATTN_NORM);
};


/*

CHAINGUNS

*/

void() q2boss2_firebullet =
{
	local	vector	dir;
	local	entity	en;
	local	vector	org;
	
	//TODO: Machine firing sound
	//sound (self, CHAN_WEAPON, "", 1, ATTN_NORM);

	en = self.enemy;
	
	//LEFT
	org = self.origin + (v_forward * 32) + (v_right * -40) + (v_up * 70);
	dir = normalize (en.origin - org);
	pointparticles(particleeffectnum("TE_GLASS_SHATTER"), org, '0 0 0', 1);
	monster_fire_bullet(org, dir, '0.01 0.01 0', 3);
	
	//RIGHT
	org = self.origin + (v_forward * 32) + (v_right * 40) + (v_up * 70);
	dir = normalize (en.origin - org);
	pointparticles(particleeffectnum("TE_GLASS_SHATTER"), org, '0 0 0', 1);
	monster_fire_bullet(org, dir, '0.01 0.01 0', 3);
};	

//STAND1
framerloop($FRAME_stand30, $FRAME_stand50, q2boss2_frames_stand, 0.1, ai_stand(););

//STAND FIDGET

framer($FRAME_stand1, $FRAME_stand29, q2boss2_stand_fidget, q2boss2_select_stand, 0.1,
	ai_stand();
);

/*
STAND SELECTOR

Chooses between regular idle and randomly playing a fidget animation

*/

void()	q2boss2_select_stand =
{
	if (self.health <= 0)
		return;
	
	if (random() > 0.1)
	{
		q2boss2_frames_stand ();
		return;
	}
	else
	{
		q2boss2_stand_fidget ();
		return;
	}
};


/*

WALKING/RUNNING

*/


//WALK
framer($FRAME_walk1, $FRAME_walk20, q2boss2_frames_walk, SUB_Null, 0.1, ai_walk(8););

//RUN
framer($FRAME_walk1, $FRAME_walk20, q2boss2_frames_run, SUB_Null, 0.1, ai_run(8););

//START MACHINE GUN ATTACK

framer($FRAME_attack1, $FRAME_attack9, q2boss2_frames_start_attack_mg, q2boss2_frames_attack_mg, 0.135,

	ai_face();
);

//MACHINEGUN ATTACK

framer($FRAME_attack10, $FRAME_attack15, q2boss2_frames_attack_mg, q2boss2_reattack_mg, 0.135,
	frame_arb($FRAME_attack10, q2boss2_firebullet(););
	frame_arb($FRAME_attack11, q2boss2_firebullet(););
	frame_arb($FRAME_attack12, q2boss2_firebullet(););
	frame_arb($FRAME_attack13, q2boss2_firebullet(););
	frame_arb($FRAME_attack14, q2boss2_firebullet(););
	ai_face();
);

//END MACHINEGUN ATTACK

framer($FRAME_attack16, $FRAME_attack19, q2boss2_frames_end_attack_mg, q2boss2_frames_run, 0.135,);

//REATTACK MACHINEGUN

void() q2boss2_reattack_mg =
{
	if (visible(self.enemy) )
	{
		if (random() <= 0.9)
		{
			q2boss2_frames_attack_mg();
		}
		else
		{
			q2boss2_frames_end_attack_mg();
		}
	}
	else
	{
		q2boss2_frames_end_attack_mg();
	}
}

//ROCKET ATTACK

framer($FRAME_attack20, $FRAME_attack40, q2boss2_frames_attack_rockets, q2boss2_frames_run, 0.135,
	frame_arb($FRAME_attack32, q2boss2_fire_rockets(););
	ai_face();
);

/*

HORNET ATTACK

*/

void() q2boss2_attack =
{
	if (random() <= 0.75)
	{
		q2boss2_frames_start_attack_mg();
	}
	else
	{
		q2boss2_frames_attack_rockets();
	}
}

/*

HORNET PAIN

*/

// PAIN HEAVY

framer($FRAME_pain2, $FRAME_pain19, q2boss2_frames_pain_heavy, q2boss2_frames_run, 0.135, 
	
	frame_arb($FRAME_pain2,
		local	vector	org;
		org = self.origin + '0 0 24';
		SpawnBlood (org, '0 0 0', 20);
	);
);

// PAIN LIGHT

framer($FRAME_pain20, $FRAME_pain23, q2boss2_frames_pain_light, q2boss2_frames_run, 0.135, 
	
	frame_arb($FRAME_pain20,
		local	vector	org;
		org = self.origin + '0 0 24';
		SpawnBlood (org, '0 0 0', 20);
	);
);

void (entity attacker, float damage) q2boss2_pain =
{
	if(self.health < (self.max_health / 2))
		self.skin = 1;

	if (self.pain_finished > time)
		return;
	
	if (skill == 3)
		return;		// no pain anims in nightmare

	if (damage < 10)
	{
		sound (self, CHAN_VOICE, HORNET_SOUND_PAIN3, 1, ATTN_NORM);
		self.pain_finished = time + 5;
		q2boss2_frames_pain_light();
	}
	else if (damage < 30)
	{
		sound (self, CHAN_VOICE, HORNET_SOUND_PAIN1, 1, ATTN_NORM);
		self.pain_finished = time + 5;
		q2boss2_frames_pain_light();
	}
	else
	{
		sound (self, CHAN_VOICE, HORNET_SOUND_PAIN2, 1, ATTN_NORM);
		self.pain_finished = time + 5;
		q2boss2_frames_pain_heavy();
	}
};

/*

DEATH

*/

void () q2boss2_explode =
{
	local float n;
	
	sound (self, CHAN_VOICE, "misc/udeath.wav", 1, ATTN_NORM);

	if (self.target)
		SUB_UseTargets();
		
	for (n= 0; n < 10; n++)
		ThrowGib ("models/objects/gibs/bone/tris.md2", 400, GIB_FLESH);
	for (n= 0; n < 15; n++)
		ThrowGib ("models/objects/gibs/sm_meat/tris.md2", 500, GIB_FLESH);
	for (n= 0; n < 5; n++)
		ThrowGib ("models/objects/debris1/tris.md2", 500, GIB_FLAMING);
		
	remove(self);
}

void() q2boss2_dead =
{
	self.movetype = MOVETYPE_TOSS;
	self.solid = SOLID_CORPSE;
}

// Death

framer($FRAME_death2, $FRAME_death50, q2boss2_die_frames, SUB_Null, 0.1,
	
	frame_arb($FRAME_death2, q2boss2_dead(););
	frame_arb($FRAME_death50, q2boss2_explode(););
);

void() q2boss2_die =
{
	sound (self, CHAN_AUTO, HORNET_SOUND_DEATH, 1, ATTN_IDLE);
	q2boss2_die_frames ();
}

// BEGIN HOVER SOUND

void() q2boss2HoverSound_think =
{
	if (self.owner.health <= 0)
	{
		remove(self);
		return;
	}

	self.origin = self.owner.origin;
	sound (self, CHAN_BODY, HORNET_SOUND_HOVER, 0.3, ATTN_IDLE);
	self.think = q2boss2HoverSound_think;
	self.nextthink = time + soundlength(HORNET_SOUND_HOVER);
}

void() q2boss2AttachHoverSound =
{
	local entity q2boss2HoverSound;
	
	q2boss2HoverSound = spawn();
	setorigin (q2boss2HoverSound, self.owner.origin);
	q2boss2HoverSound.owner = self;
	q2boss2HoverSound.netname = "q2boss2HoverSound";
	setmodel (q2boss2HoverSound, "");
	q2boss2HoverSound.solid = SOLID_NOT;
	q2boss2HoverSound.movetype = MOVETYPE_NOCLIP;
	q2boss2HoverSound.think = q2boss2HoverSound_think;
	q2boss2HoverSound.nextthink = time;

	setattachment(q2boss2HoverSound, self, "");
};

//END HOVER SOUND

/*QUAKED monster_boss2 (1 .5 0) (-56 -56 0) (56 56 80) Ambush Trigger_Spawn Sight
*/
void() monster_boss2 =
{
	self.classname = "monster_boss2";
	
	if (deathmatch)
	{
		remove(self);
		return;
	}

	precache_model ("models/monsters/boss2/tris.md2");

	precache_sound (HORNET_SOUND_PAIN1);
	precache_sound (HORNET_SOUND_PAIN2);	
	precache_sound (HORNET_SOUND_PAIN3);	
	precache_sound (HORNET_SOUND_DEATH);	
	precache_sound (HORNET_SOUND_SEARCH1);	
	precache_sound (HORNET_SOUND_HOVER);

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "models/monsters/boss2/tris.md2");

	setsize (self, '-56 -56 0', '56 56 80');
	self.health = 2000;
	self.max_health = self.health;

	self.th_stand = q2boss2_select_stand;
	self.th_walk = q2boss2_frames_walk;
	self.th_run = q2boss2_frames_run;
	self.th_pain = q2boss2_pain;
	self.th_die = q2boss2_die;
	self.th_missile = q2boss2_attack;

	self.sightSound = HORNET_SOUND_SEARCH1;

	q2boss2AttachHoverSound();

	flymonster_start;
}
