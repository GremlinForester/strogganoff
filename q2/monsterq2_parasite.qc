/*
==============================================================================

parasite

==============================================================================
*/

#include "monsterq2_parasite.qh"

#define PARASITE_SOUND_PAIN1 	"parasite/parpain1.wav"
#define PARASITE_SOUND_PAIN2 	"parasite/parpain2.wav"
#define PARASITE_SOUND_DIE 		"parasite/pardeth1.wav"
#define PARASITE_SOUND_LAUNCH 	"parasite/paratck1.wav"
#define PARASITE_SOUND_IMPACT 	"parasite/paratck2.wav"
#define PARASITE_SOUND_SUCK 	"parasite/paratck3.wav"
#define PARASITE_SOUND_REELIN 	"parasite/paratck4.wav"
#define PARASITE_SOUND_SIGHT 	"parasite/parsght1.wav"
#define PARASITE_SOUND_TAP 		"parasite/paridle1.wav"
#define PARASITE_SOUND_SCRATCH 	"parasite/paridle2.wav"
#define PARASITE_SOUND_SEARCH 	"parasite/parsrch1.wav"

void() q2parasite_select_stand;

void() q2parasite_pain_sounds =
{
	if (random() < 0.5)
		sound (self, CHAN_VOICE, PARASITE_SOUND_PAIN1, 1, ATTN_NORM);	
	else
		sound (self, CHAN_VOICE, PARASITE_SOUND_PAIN2, 1, ATTN_NORM);	
}

/*

STAND1

*/

//STAND1
framer($FRAME_stand01, $FRAME_stand17, q2parasite_stand, q2parasite_select_stand, 0.1,
	frame_arb($FRAME_stand03, sound (self, CHAN_AUTO, PARASITE_SOUND_TAP, 0.5, ATTN_IDLE););
	frame_arb($FRAME_stand05, sound (self, CHAN_AUTO, PARASITE_SOUND_TAP, 0.5, ATTN_IDLE););
	frame_arb($FRAME_stand09, sound (self, CHAN_AUTO, PARASITE_SOUND_TAP, 0.5, ATTN_IDLE););
	frame_arb($FRAME_stand11, sound (self, CHAN_AUTO, PARASITE_SOUND_TAP, 0.5, ATTN_IDLE););
	frame_arb($FRAME_stand15, sound (self, CHAN_AUTO, PARASITE_SOUND_TAP, 0.5, ATTN_IDLE););
	frame_arb($FRAME_stand17, sound (self, CHAN_AUTO, PARASITE_SOUND_TAP, 0.5, ATTN_IDLE););
	ai_stand();
);

/*

STAND FIDGET

*/

framer($FRAME_stand18, $FRAME_stand35, q2parasite_stand_fidget, q2parasite_select_stand, 0.1,
	frame_arb($FRAME_stand22, sound (self, CHAN_AUTO, PARASITE_SOUND_SCRATCH, 1, ATTN_IDLE););
	frame_arb($FRAME_stand25, sound (self, CHAN_AUTO, PARASITE_SOUND_SCRATCH, 1, ATTN_IDLE););
	frame_arb($FRAME_stand28, sound (self, CHAN_AUTO, PARASITE_SOUND_SCRATCH, 1, ATTN_IDLE););
	ai_stand();
);

/*
STAND SELECTOR

Chooses between regular idle and randomly playing a fidget animation

*/

void()	q2parasite_select_stand =
{
	if (self.health <= 0)
		return;
	
	if (random() > 0.1)
	{
		q2parasite_stand ();
		return;
	}
	else
	{
		q2parasite_stand_fidget ();
		return;
	}
};

/*

RUN

*/

framerloop($FRAME_run03, $FRAME_run09, q2parasite_frames_run, 0.1,

	frame_arb($FRAME_run03, sound (self, CHAN_AUTO, PARASITE_SOUND_TAP, 1, ATTN_IDLE););
	frame_arb($FRAME_run05, sound (self, CHAN_AUTO, PARASITE_SOUND_TAP, 1, ATTN_IDLE););
	frame_arb($FRAME_run09, sound (self, CHAN_AUTO, PARASITE_SOUND_TAP, 1, ATTN_IDLE););
		
//	frame_arb(FRAME_walkc5, footsetp(););
//	frame_arb(FRAME_walkc10, footstep(););
	frame_arb($FRAME_run04,

	if (self.bIsWounded && self.bleedcount < MAX_BLEED)
	{
		local	vector	org;
		org = self.origin + '0 0 24';
		SpawnBlood (org, '0 0 0', 5);
		self.bleedcount++;
	}
	);
	
	ai_rep($FRAME_run03, ai_run, 30, 30, 22, 19, 24, 28, 25, 0);
);

/*

WALK

*/

framerloop($FRAME_run03, $FRAME_run09, q2parasite_frames_walk, 0.1,

	frame_arb($FRAME_run03, sound (self, CHAN_AUTO, PARASITE_SOUND_TAP, 1, ATTN_IDLE););
	frame_arb($FRAME_run05, sound (self, CHAN_AUTO, PARASITE_SOUND_TAP, 1, ATTN_IDLE););
	frame_arb($FRAME_run09, sound (self, CHAN_AUTO, PARASITE_SOUND_TAP, 1, ATTN_IDLE););

//	frame_arb(FRAME_walkc5, footsetp(););
//	frame_arb(FRAME_walkc10, footstep(););
	frame_arb($FRAME_run04,

	if (self.bIsWounded && self.bleedcount < MAX_BLEED)
	{
		local	vector	org;
		org = self.origin + '0 0 24';
		SpawnBlood (org, '0 0 0', 5);
		self.bleedcount++;
	}
	);
	
	ai_rep($FRAME_run03, ai_walk, 30, 30, 22, 19, 24, 28, 25, 0);
);

//MrC: Ok, started as a test and turned out awesome (imho). Electrical stun attacks from the parasite! Also, yea it's just the shambler lighting attack.
//Also they currently damage themselves with this attack which will need fixing if this stays in.

void() CastUmbilical =
{
	local	vector	org;//, dir;
	
	ai_face ();

	org = G_ProjectSource (self.origin, '32 0 8', v_forward, v_right, '0 0 0');

//	org = self.origin + '50 0 20';

	self.v__ = self.enemy.origin + '0 0 16' - org;
	self.v__ = normalize (self.v__);

	traceline (org, self.origin + self.v__ * 300, TRUE, self);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_LIGHTNING1);
	WriteEntity (MSG_BROADCAST, self);
	WriteCoord (MSG_BROADCAST, org_x);
	WriteCoord (MSG_BROADCAST, org_y);
	WriteCoord (MSG_BROADCAST, org_z);
	WriteCoord (MSG_BROADCAST, trace_endpos_x);
	WriteCoord (MSG_BROADCAST, trace_endpos_y);
	WriteCoord (MSG_BROADCAST, trace_endpos_z);
	self.effects | EF_MUZZLEFLASH;
	LightningDamage (org, trace_endpos, self, 10);
};

void() q2parasite_attack1     =[      $FRAME_drain01,       q2parasite_attack2    ] {ai_face();sound (self, CHAN_WEAPON, "shambler/sattck1.wav", 1, ATTN_NORM);};
void() q2parasite_attack2     =[      $FRAME_drain03,       q2parasite_attack3    ] {ai_face();};
void() q2parasite_attack3     =[      $FRAME_drain05,       q2parasite_attack4    ] {ai_face();self.nextthink = self.nextthink + 0.2;ai_face();};
void() q2parasite_attack4     =[      $FRAME_drain07,       q2parasite_attack5    ]{};
void() q2parasite_attack5     =[      $FRAME_drain09,       q2parasite_attack6    ]{};
void() q2parasite_attack6     =[      $FRAME_drain11,       q2parasite_attack9    ]{CastUmbilical();sound (self, CHAN_WEAPON, "shambler/sboom.wav", 1, ATTN_NORM);};
void() q2parasite_attack9     =[      $FRAME_drain13,       q2parasite_attack10   ]{CastUmbilical();};
void() q2parasite_attack10    =[      $FRAME_drain15,      q2parasite_attack11   ]{CastUmbilical();};
void() q2parasite_attack11    =[      $FRAME_drain16,      q2parasite_attack12   ]{if (skill == 3)CastUmbilical();};
void() q2parasite_attack12    =[      $FRAME_drain18,      q2parasite_frames_run	   ] {};

// PAIN1

framer($FRAME_pain101, $FRAME_pain111, q2parasite_pain1, q2parasite_frames_run, 0.135, 
	
	frame_arb($FRAME_pain101,
		local	vector	org;
		org = self.origin + '0 0 24';
		SpawnBlood (org, '0 0 0', 20);
	);
	
	frame_arb($FRAME_pain111,
		ai_pain(1);
	);
);

void(entity attacker, float damage)	q2parasite_pain =
{
	self.bIsWounded = 1;
	self.bleedcount = 0;

	if (skill == 3)
		return;		// no pain anims in nightmare

	if (self.pain_finished > time)
		return;

	if (self.health < (self.max_health / 2))
	{
		self.skin = 1;
		self.pain_finished = time + 1.1;
		q2parasite_pain1 ();
		q2parasite_pain_sounds();
	}
};

/*
===
Death Stuff Starts
===
*/

void() q2parasite_dead =
{
	setsize (self, '-16 -16 -24', '16 16 -8');
	self.movetype = MOVETYPE_TOSS;
	self.solid = SOLID_CORPSE;
}

framer($FRAME_death101, $FRAME_death107, q2parasite_die1_frames, SUB_Null, 0.1,
	
	frame_arb($FRAME_death101,

		q2parasite_dead();
	//	self.ammo_shells = 5;
	//	DropBackpack();
	);
);

void() q2parasite_die =
{
	local float n;

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
	sound(self, CHAN_WEAPON2, PARASITE_SOUND_DIE, 1, ATTN_NORM);
	self.deadflag = DEAD_DEAD;
	
	DropLoot(LOOT_BULLETS, floor(random()*6)+1);
	
	q2parasite_die1_frames ();
	}
};

/*
===
End Death Stuff
===
*/

/*QUAKED monster_parasite (1 .5 0) (-16 -16 -24) (16 16 32) Ambush Trigger_Spawn Sight
*/
void () monster_parasite =
{
	self.classname = "monster_parasite";
	
	if (deathmatch)
	{
		remove(self);
		return;
	}
	
	// pre-caches
	precache_model ("models/monsters/parasite/tris.md2");
	
	precache_sound (PARASITE_SOUND_PAIN1);
	precache_sound (PARASITE_SOUND_PAIN2);
	precache_sound (PARASITE_SOUND_DIE);
	precache_sound (PARASITE_SOUND_LAUNCH);
	precache_sound (PARASITE_SOUND_IMPACT);
	precache_sound (PARASITE_SOUND_SUCK);
	precache_sound (PARASITE_SOUND_REELIN);
	precache_sound (PARASITE_SOUND_SIGHT);
	precache_sound (PARASITE_SOUND_TAP);
	precache_sound (PARASITE_SOUND_SCRATCH);
	precache_sound (PARASITE_SOUND_SEARCH);

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "models/monsters/parasite/tris.md2");

	setsize (self, '-16 -16 -24', '16 16 24');
	self.health = 175;
	self.max_health = self.health;

	self.th_stand = q2parasite_stand;
	self.th_walk = q2parasite_frames_walk;
	self.th_run = q2parasite_frames_run;
	self.th_pain = q2parasite_pain;
	self.th_die = q2parasite_die;
	self.th_missile = q2parasite_attack1;
	self.th_melee = q2parasite_attack1;

	self.sightSound = PARASITE_SOUND_SIGHT;

	walkmonster_start;
}
