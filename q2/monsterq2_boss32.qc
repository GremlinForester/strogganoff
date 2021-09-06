/*
==============================================================================

Makron -- Final Boss

==============================================================================
*/

#include "monsterq2_boss32.qh"

#define	MAKRON_SOUND_PAIN4 			"makron/pain3.wav"
#define	MAKRON_SOUND_PAIN5 			"makron/pain2.wav"
#define	MAKRON_SOUND_PAIN6 			"makron/pain1.wav"
#define	MAKRON_SOUND_DEATH			"makron/death.wav"
#define	MAKRON_SOUND_STEP_LEFT		"makron/step1.wav"
#define	MAKRON_SOUND_STEP_RIGHT		"makron/step2.wav"
#define	MAKRON_SOUND_ATTACK_BFG		"makron/bfg_fire.wav"
#define	MAKRON_SOUND_BRAINSPLORCH	"makron/brain1.wav"
#define	MAKRON_SOUND_PRERAILGUN		"makron/rail_up.wav"
#define	MAKRON_SOUND_POPUP			"makron/popup.wav"
#define	MAKRON_SOUND_TAUNT1			"makron/voice4.wav"
#define	MAKRON_SOUND_TAUNT2			"makron/voice3.wav"
#define	MAKRON_SOUND_TAUNT3			"makron/voice.wav"
#define	MAKRON_SOUND_HIT			"makron/bhit.wav"

void() makron_taunt =
{
	if (random() < 0.3)
		sound (self, CHAN_VOICE, MAKRON_SOUND_TAUNT1, 0.5, ATTN_IDLE);	
	else if (random() < 0.6)
		sound (self, CHAN_VOICE, MAKRON_SOUND_TAUNT2, 0.5, ATTN_IDLE);
	else
		sound (self, CHAN_VOICE, MAKRON_SOUND_TAUNT3, 0.5, ATTN_IDLE);
}

/*

STAND1

*/

framer($FRAME_stand201, $FRAME_stand260, makron_frames_stand, makron_frames_stand, 0.1,
	ai_stand();
);

/*

RUN

*/

framerloop($FRAME_walk204, $FRAME_walk213, makron_frames_run, 0.135,

	frame_arb($FRAME_walk204, sound (self, CHAN_AUTO, MAKRON_SOUND_STEP_LEFT, 1, ATTN_IDLE););
	frame_arb($FRAME_walk208, sound (self, CHAN_AUTO, MAKRON_SOUND_STEP_RIGHT, 1, ATTN_IDLE););
	
	ai_rep($FRAME_walk204, ai_run, 3, 12, 8, 8, 8, 6, 12, 9);
	ai_rep($FRAME_walk212, ai_run, 6, 12, 0, 0, 0, 0, 0, 0);
);

/*

WALK

*/

framerloop($FRAME_walk204, $FRAME_walk213, makron_frames_walk, 0.135,

	frame_arb($FRAME_walk204, sound (self, CHAN_AUTO, MAKRON_SOUND_STEP_LEFT, 1, ATTN_IDLE););
	frame_arb($FRAME_walk208, sound (self, CHAN_AUTO, MAKRON_SOUND_STEP_RIGHT, 1, ATTN_IDLE););
	
	ai_rep($FRAME_walk204, ai_walk, 3, 12, 8, 8, 8, 6, 12, 9);
	ai_rep($FRAME_walk212, ai_walk, 6, 12, 0, 0, 0, 0, 0, 0);
);

/*

PAIN

*/

//PAIN 6

framer($FRAME_pain601, $FRAME_pain627, makron_frames_pain6, makron_frames_run, 0.135, 
	
	frame_arb($FRAME_pain601,
		local	vector	org;
		org = self.origin + '0 0 24';
		SpawnBlood (org, '0 0 0', 20);
	);
	
		frame_arb($FRAME_pain616, sound (self, CHAN_AUTO, MAKRON_SOUND_POPUP, 1, ATTN_IDLE););
		frame_arb($FRAME_pain624, makron_taunt(););
);

//PAIN 5

framer($FRAME_pain501, $FRAME_pain504, makron_frames_pain5, makron_frames_run, 0.135, 
	
	frame_arb($FRAME_pain501,
		local	vector	org;
		org = self.origin + '0 0 24';
		SpawnBlood (org, '0 0 0', 20);
	);
);

//PAIN 4

framer($FRAME_pain401, $FRAME_pain404, makron_frames_pain4, makron_frames_run, 0.135, 
	
	frame_arb($FRAME_pain401,
		local	vector	org;
		org = self.origin + '0 0 24';
		SpawnBlood (org, '0 0 0', 20);
	);
);

/*

DEATH

*/
//
// death
//

void() makron_dead={
	setsize(self, '-60 -60 0', '60 60 0');
	setorigin(self, self.origin);
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_CORPSE;
};

void() doMakronDeathFrameShit =
{
	switch (self.frame)
	{
		case 251:
			sound(self, CHAN_AUTO, MAKRON_SOUND_STEP_LEFT, 1, ATTN_IDLE);
			makron_dead();
			break;
		case 268:
			sound(self, CHAN_AUTO, MAKRON_SOUND_STEP_RIGHT, 1, ATTN_IDLE);
			break;
		case 286:
			sound(self, CHAN_AUTO, MAKRON_SOUND_STEP_LEFT, 1, ATTN_IDLE);
			break;
		case 306:
			sound(self, CHAN_AUTO, MAKRON_SOUND_STEP_RIGHT, 1, ATTN_IDLE);
			break;
		case 308:
			sound(self, CHAN_AUTO, MAKRON_SOUND_STEP_LEFT, 1, ATTN_IDLE);
			break;
		case 315:
			sound(self, CHAN_AUTO, MAKRON_SOUND_STEP_RIGHT, 1, ATTN_IDLE);
			break;
		case 317:
			sound(self, CHAN_AUTO, MAKRON_SOUND_STEP_LEFT, 1, ATTN_IDLE);
			break;
		case 320:
			sound(self, CHAN_AUTO, MAKRON_SOUND_STEP_RIGHT, 1, ATTN_IDLE);
			break;
		case 323:
			sound(self, CHAN_AUTO, MAKRON_SOUND_STEP_LEFT, 1, ATTN_IDLE);
			break;
		case 341:
			sound(self, CHAN_AUTO, MAKRON_SOUND_HIT, 1, ATTN_IDLE);
			break;
		case 343:
			sound(self, CHAN_AUTO, MAKRON_SOUND_BRAINSPLORCH, 1, ATTN_IDLE);
			if (self.target)
				SUB_UseTargets();
			break;
	}
}

framer($FRAME_death201, $FRAME_death295, makron_frames_death2, SUB_Null, 0.1, doMakronDeathFrameShit(););

/*

ATTACK PROJECTILES

*/

void() MakronBFG =
{
	local	vector	dir;
	local	entity	en;
	local	vector	org;

	sound (self, CHAN_AUTO, MAKRON_SOUND_ATTACK_BFG, 1, ATTN_NORM);

	en = self.enemy;
	dir = en.origin - en.velocity*0.1;
	dir = normalize (en.origin - self.origin);
	org = self.origin + (v_forward * 30) + (v_right * 16) + (v_up * 36);
	
	monster_fire_bfg(org, dir, 50);
};

void() MakronRailgun =
{
	local vector org;
	local vector end;
	local vector dir;

	makevectors(self.angles);

	org = self.origin + (v_forward * -17.3) + (v_right * 7.8) + (v_up * 72.4);
	
	end = self.enemy.origin - self.enemy.velocity*0.05;
	end_z = end_z + self.enemy.view_ofs_z - self.enemy.velocity*0.05;
	
	dir = normalize(end - org);
	
	sound (self, CHAN_WEAPON, "weapons/RAILGF1A.WAV", 1, ATTN_NORM);
	monster_fire_railgun(org, end, 20);
};

/*

MAKRON HYPERBLASTER

*/

void() MakronHyperblaster={
	local vector start;
	local vector end;
	local vector dir;
	local vector vec;
	local vector org_offset;
	local float flashId;

	flashId = self.frame - $FRAME_attak405;
	org_offset = MZ2_MAKRON_BLASTER[flashId];
	
	makevectors(self.angles);
	
	start = self.origin + (v_forward * org_offset_x) + (v_right * org_offset_y) + (v_up * org_offset_z);
	
	if (self.enemy)
	{
		end = self.enemy.origin;
		end_z = end_z + self.enemy.view_ofs_z;
		vec = end - start;
		vec = vectoangles (vec);
		dir_x = anglemod(vec_x * -1);
	}
	else
	{
		dir_x = 0;
	}
	if (self.frame <= $FRAME_attak413)
		dir_y = self.angles_y - (10 * (self.frame - $FRAME_attak413));
	else
		dir_y = self.angles_y + (10 * (self.frame - $FRAME_attak421));
	
	dir_z = 0;
	dir_y = anglemod(dir_y);
	
	makevectors(dir);
	
	vec = start + (v_forward * vlen(self.enemy.origin - self.origin));
	sound (self, CHAN_AUTO, "weapons/BLASTF1A.WAV", 1, ATTN_NORM);
	monster_fire_blaster (start, normalize(vec - start), 20, '2 0.2 0.2', MF_TRACER2);
};

void() doMakronHyperblasterFrames =
{
	switch (self.frame)
	{
		case 213:
			MakronHyperblaster();
			break;
		case 214:
			MakronHyperblaster();
			break;
		case 215:
			MakronHyperblaster();
			break;
		case 216:
			MakronHyperblaster();
			break;
		case 217:
			MakronHyperblaster();
			break;
		case 218:
			MakronHyperblaster();
			break;
		case 219:
			MakronHyperblaster();
			break;
		case 220:
			MakronHyperblaster();
			break;
		case 221:
			MakronHyperblaster();
			break;
		case 222:
			MakronHyperblaster();
			break;
		case 223:
			MakronHyperblaster();
			break;
		case 224:
			MakronHyperblaster();
			break;
		case 225:
			MakronHyperblaster();
			break;
		case 226:
			MakronHyperblaster();
			break;
		case 227:
			MakronHyperblaster();
			break;
		case 228:
			MakronHyperblaster();
			break;
		case 229:
			MakronHyperblaster();
			break;
	}
}

/*

ATTACK

*/

framer($FRAME_attak301, $FRAME_attak308, makron_frames_attack3, makron_frames_run, 0.135,
	frame_arb($FRAME_attak304, MakronBFG(););
	ai_face();
);

framer($FRAME_attak401, $FRAME_attak426, makron_frames_attack4, makron_frames_run, 0.135,
	doMakronHyperblasterFrames();
	ai_face();
);

framer($FRAME_attak501, $FRAME_attak516, makron_frames_attack5, makron_frames_run, 0.135,
	frame_arb($FRAME_attak501, sound (self, CHAN_WEAPON, MAKRON_SOUND_PRERAILGUN, 1, ATTN_NORM););
	frame_arb($FRAME_attak509, MakronRailgun(););
	ai_face();
);

void() makron_attack =
{
	if (random() <= 0.3)
	{
		makron_frames_attack3();
	}
	else if (random() <= 0.6)
	{
		makron_frames_attack4();
	}
	else
	{
		makron_frames_attack5();
	}
}

void (entity attacker, float damage) makron_pain =
{
	if (self.health < (self.max_health / 2))
			self.skin = 1;

	// Lessen the chance of him going into his pain frames
	if (damage <=25)
		if (random()<0.2)
			return;

	if (skill == 3)
		return;		// no pain anims in nightmare


	if (damage <= 40)
	{
		sound (self, CHAN_VOICE, MAKRON_SOUND_PAIN4, 1, ATTN_IDLE);
		makron_frames_pain4();
	}
	else if (damage <= 110)
	{
		sound (self, CHAN_VOICE, MAKRON_SOUND_PAIN5, 1, ATTN_IDLE);
		makron_frames_pain5();
	}
	else
	{
		if (damage <= 150)
			if (random() <= 0.45)
			{
				sound (self, CHAN_VOICE, MAKRON_SOUND_PAIN6, 1, ATTN_IDLE);
				makron_frames_pain6();
			}
		else
			if (random() <= 0.35)
			{
				sound (self, CHAN_VOICE, MAKRON_SOUND_PAIN6, 1, ATTN_IDLE);
				makron_frames_pain6();
			}
	}
};

/*
---
Makron Torso.
---
*/

//Upper torso on ground loop

framerloop($FRAME_death301, $FRAME_death320, makron_frames_death3, 0.1,
	frame_arb($FRAME_death301, sound (self, CHAN_VOICE, "makron/spine.wav", 1, ATTN_IDLE););
);

void() makron_torso_die =
{
	local float n;

	if (self.health <= 0)
	{
		sound (self, CHAN_VOICE, "misc/udeath.wav", 1, ATTN_NORM);
		
		for (n= 0; n < 2; n++)
			ThrowGib ("models/objects/gibs/bone/tris.md2", self.health / 4, GIB_FLESH);
		for (n= 0; n < 4; n++)
			ThrowGib ("models/objects/gibs/sm_meat/tris.md2", self.health / 4, GIB_FLESH);
		
		remove(self);
	}
};

void () makron_torso =
{
	local entity makron_torso;
	local float r;
	
	makron_torso = spawn();
	makron_torso.origin = self.origin - '44 44 0';

	setmodel (makron_torso, "models/monsters/boss3/rider/tris.md2");
	makron_torso.solid = SOLID_CORPSE;
	makron_torso.movetype = MOVETYPE_NONE;

	setsize (makron_torso, '-30 -30 0', '30 30 30');
	makron_torso.health = 300;
	makron_torso.ideal_yaw = makron_torso.angles * '0 1 0';
	makron_torso.flags = makron_torso.flags | FL_MONSTER;
	makron_torso.takedamage = DAMAGE_YES;
	makron_torso.th_pain = makron_frames_death3;
	makron_torso.th_die = makron_torso_die;
	
	makron_torso.nextthink = time + 0.1;
	makron_torso.think = makron_frames_death3;
}

void() makron_die =
{
	local float n;

 	if (self.health <= -400)
	{
		sound (self, CHAN_VOICE, "misc/udeath.wav", 1, ATTN_NORM);
		
		for (n= 0; n < 2; n++)
			ThrowGib ("models/objects/gibs/bone/tris.md2", self.health / 4, GIB_FLESH);
		for (n= 0; n < 4; n++)
			ThrowGib ("models/objects/gibs/sm_meat/tris.md2", self.health / 4, GIB_FLESH);
		
		remove(self);
	} 

	self.takedamage = DAMAGE_YES;

 	if (self.deadflag == DEAD_DEAD){
		return;
	}
	else
	{
	// regular death
	sound (self, CHAN_VOICE, MAKRON_SOUND_DEATH, 1, ATTN_NORM);
	self.deadflag = DEAD_DEAD;
	makron_frames_death2 ();
	}
	
	makron_torso();
};

//
// monster_makron
//

void() MakronPrecache
{
	precache_sound (MAKRON_SOUND_PAIN4);
	precache_sound (MAKRON_SOUND_PAIN5);
	precache_sound (MAKRON_SOUND_PAIN6);
	precache_sound (MAKRON_SOUND_DEATH);
	precache_sound (MAKRON_SOUND_STEP_LEFT);
	precache_sound (MAKRON_SOUND_STEP_RIGHT);
	precache_sound (MAKRON_SOUND_ATTACK_BFG);
	precache_sound (MAKRON_SOUND_BRAINSPLORCH);
	precache_sound (MAKRON_SOUND_PRERAILGUN);
	precache_sound (MAKRON_SOUND_POPUP);
	precache_sound (MAKRON_SOUND_TAUNT1);
	precache_sound (MAKRON_SOUND_TAUNT2);
	precache_sound (MAKRON_SOUND_TAUNT3);
	precache_sound (MAKRON_SOUND_HIT);
	precache_model ("models/monsters/boss3/rider/tris.md2");
}

/*QUAKED monster_makron (1 .5 0) (-30 -30 0) (30 30 90) Ambush Trigger_Spawn Sight
*/
void() monster_makron =
{
	self.classname = "q2monster_makron";
	
	if (deathmatch)
	{
		remove(self);
		return;
	}	

	MakronPrecache();

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel (self, "models/monsters/boss3/rider/tris.md2");
	setsize (self, '-30 -30 0', '30 30 90');
	self.health = 300; //MrC: 3000 also lowered for testing
	self.max_health = self.health;

	self.th_stand = makron_frames_stand;
	self.th_walk = makron_frames_walk;
	self.th_run = makron_frames_run;
	self.th_pain = makron_pain;
	self.th_die = makron_die;
	self.th_missile = makron_attack;
	self.th_melee = makron_attack;

	self.sightSound = MAKRON_SOUND_POPUP;

	walkmonster_start;
}
