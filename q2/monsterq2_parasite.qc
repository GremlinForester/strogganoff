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

framerloop($FRAME_stand01, $FRAME_stand17, q2parasite_stand, 0.1,

	frame_arb($FRAME_stand03, sound (self, CHAN_AUTO, PARASITE_SOUND_TAP, 0.5, ATTN_IDLE););
	frame_arb($FRAME_stand05, sound (self, CHAN_AUTO, PARASITE_SOUND_TAP, 0.5, ATTN_IDLE););
	frame_arb($FRAME_stand09, sound (self, CHAN_AUTO, PARASITE_SOUND_TAP, 0.5, ATTN_IDLE););
	frame_arb($FRAME_stand11, sound (self, CHAN_AUTO, PARASITE_SOUND_TAP, 0.5, ATTN_IDLE););
	frame_arb($FRAME_stand15, sound (self, CHAN_AUTO, PARASITE_SOUND_TAP, 0.5, ATTN_IDLE););
	frame_arb($FRAME_stand17, sound (self, CHAN_AUTO, PARASITE_SOUND_TAP, 0.5, ATTN_IDLE);q2parasite_select_stand(););

	ai_rep($FRAME_stand01, ai_stand, 0, 0, 0, 0, 0, 0, 0, 0);
	ai_rep($FRAME_stand09, ai_stand, 0, 0, 0, 0, 0, 0, 0, 0);
	ai_rep($FRAME_stand17, ai_stand, 0, 0, 0, 0, 0, 0, 0, 0);
);

/*

STAND FIDGET

*/

framerloop($FRAME_stand18, $FRAME_stand35, q2parasite_stand_fidget, 0.1,

	frame_arb($FRAME_stand35, q2parasite_select_stand(););

	frame_arb($FRAME_stand22, sound (self, CHAN_AUTO, PARASITE_SOUND_SCRATCH, 1, ATTN_IDLE););
	frame_arb($FRAME_stand25, sound (self, CHAN_AUTO, PARASITE_SOUND_SCRATCH, 1, ATTN_IDLE););
	frame_arb($FRAME_stand28, sound (self, CHAN_AUTO, PARASITE_SOUND_SCRATCH, 1, ATTN_IDLE););

	ai_rep($FRAME_stand18, ai_stand, 0, 0, 0, 0, 0, 0, 0, 0);
	ai_rep($FRAME_stand26, ai_stand, 0, 0, 0, 0, 0, 0, 0, 0);
	ai_rep($FRAME_stand34, ai_stand, 0, 0, 0, 0, 0, 0, 0, 0);
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











/*
mframe_t parasite_frames_run [] =
{
	ai_run, 30, NULL, //3
	ai_run, 30, NULL,
	ai_run, 22, NULL,
	ai_run, 19, NULL,
	ai_run, 24, NULL,
	ai_run, 28, NULL,
	ai_run, 25, NULL //9
};
mmove_t parasite_move_run = {FRAME_run03, FRAME_run09, parasite_frames_run, NULL};

mframe_t parasite_frames_start_run [] =
{
	ai_run, 0,	NULL,
	ai_run, 30, NULL,
};
mmove_t parasite_move_start_run = {FRAME_run01, FRAME_run02, parasite_frames_start_run, parasite_run};

mframe_t parasite_frames_stop_run [] =
{	
	ai_run, 20, NULL,
	ai_run, 20,	NULL,
	ai_run, 12, NULL,
	ai_run, 10, NULL,
	ai_run, 0,  NULL,
	ai_run, 0,  NULL
};
mmove_t parasite_move_stop_run = {FRAME_run10, FRAME_run15, parasite_frames_stop_run, NULL};

void parasite_start_run (edict_t *self)
{	
	if (self->monsterinfo.aiflags & AI_STAND_GROUND)
		self->monsterinfo.currentmove = &parasite_move_stand;
	else
		self->monsterinfo.currentmove = &parasite_move_start_run;
}

void parasite_run (edict_t *self)
{
	if (self->monsterinfo.aiflags & AI_STAND_GROUND)
		self->monsterinfo.currentmove = &parasite_move_stand;
	else
		self->monsterinfo.currentmove = &parasite_move_run;
}


mframe_t parasite_frames_walk [] =
{
	ai_walk, 30, NULL,
	ai_walk, 30, NULL,
	ai_walk, 22, NULL,
	ai_walk, 19, NULL,
	ai_walk, 24, NULL,
	ai_walk, 28, NULL,
	ai_walk, 25, NULL
};
mmove_t parasite_move_walk = {FRAME_run03, FRAME_run09, parasite_frames_walk, parasite_walk};

mframe_t parasite_frames_start_walk [] =
{
	ai_walk, 0,	NULL,
	ai_walk, 30, parasite_walk
};
mmove_t parasite_move_start_walk = {FRAME_run01, FRAME_run02, parasite_frames_start_walk, NULL};

mframe_t parasite_frames_stop_walk [] =
{	
	ai_walk, 20, NULL,
	ai_walk, 20,	NULL,
	ai_walk, 12, NULL,
	ai_walk, 10, NULL,
	ai_walk, 0,  NULL,
	ai_walk, 0,  NULL
};
mmove_t parasite_move_stop_walk = {FRAME_run10, FRAME_run15, parasite_frames_stop_walk, NULL};

void parasite_start_walk (edict_t *self)
{	
	self->monsterinfo.currentmove = &parasite_move_start_walk;
}

void parasite_walk (edict_t *self)
{
	self->monsterinfo.currentmove = &parasite_move_walk;
}


mframe_t parasite_frames_pain1 [] =
{
	ai_move, 0, NULL,
	ai_move, 0, NULL,
	ai_move, 0,	NULL,
	ai_move, 0,	NULL,
	ai_move, 0,	NULL,
	ai_move, 0,	NULL,
	ai_move, 6,	NULL,
	ai_move, 16, NULL,
	ai_move, -6, NULL,
	ai_move, -7, NULL,
	ai_move, 0, NULL
};
mmove_t parasite_move_pain1 = {FRAME_pain101, FRAME_pain111, parasite_frames_pain1, parasite_start_run};

void parasite_pain (edict_t *self, edict_t *other, float kick, int damage)
{
	if (self->health < (self->max_health / 2))
		self->s.skinnum = 1;

	if (level.time < self->pain_debounce_time)
		return;

	self->pain_debounce_time = level.time + 3;

	if (skill->value == 3)
		return;		// no pain anims in nightmare

	if (random() < 0.5)
		gi.sound (self, CHAN_VOICE, sound_pain1, 1, ATTN_NORM, 0);
	else
		gi.sound (self, CHAN_VOICE, sound_pain2, 1, ATTN_NORM, 0);

	self->monsterinfo.currentmove = &parasite_move_pain1;
}


static qboolean parasite_drain_attack_ok (vec3_t start, vec3_t end)
{
	vec3_t	dir, angles;

	// check for max distance
	VectorSubtract (start, end, dir);
	if (VectorLength(dir) > 256)
		return false;

	// check for min/max pitch
	vectoangles (dir, angles);
	if (angles[0] < -180)
		angles[0] += 360;
	if (fabs(angles[0]) > 30)
		return false;

	return true;
}

void parasite_drain_attack (edict_t *self)
{
	vec3_t	offset, start, f, r, end, dir;
	trace_t	tr;
	int damage;

	AngleVectors (self->s.angles, f, r, NULL);
	VectorSet (offset, 24, 0, 6);
	G_ProjectSource (self->s.origin, offset, f, r, start);

	VectorCopy (self->enemy->s.origin, end);
	if (!parasite_drain_attack_ok(start, end))
	{
		end[2] = self->enemy->s.origin[2] + self->enemy->maxs[2] - 8;
		if (!parasite_drain_attack_ok(start, end))
		{
			end[2] = self->enemy->s.origin[2] + self->enemy->mins[2] + 8;
			if (!parasite_drain_attack_ok(start, end))
				return;
		}
	}
	VectorCopy (self->enemy->s.origin, end);

	tr = gi.trace (start, NULL, NULL, end, self, MASK_SHOT);
	if (tr.ent != self->enemy)
		return;

	if (self->s.frame == FRAME_drain03)
	{
		damage = 5;
		gi.sound (self->enemy, CHAN_AUTO, sound_impact, 1, ATTN_NORM, 0);
	}
	else
	{
		if (self->s.frame == FRAME_drain04)
			gi.sound (self, CHAN_WEAPON, sound_suck, 1, ATTN_NORM, 0);
		damage = 2;
	}

	gi.WriteByte (svc_temp_entity);
	gi.WriteByte (TE_PARASITE_ATTACK);
	gi.WriteShort (self - g_edicts);
	gi.WritePosition (start);
	gi.WritePosition (end);
	gi.multicast (self->s.origin, MULTICAST_PVS);

	VectorSubtract (start, end, dir);
	T_Damage (self->enemy, self, self, dir, self->enemy->s.origin, vec3_origin, damage, 0, DAMAGE_NO_KNOCKBACK, MOD_UNKNOWN);
}

mframe_t parasite_frames_drain [] =
{
	ai_charge, 0,	parasite_launch,
	ai_charge, 0,	NULL,
	ai_charge, 15,	parasite_drain_attack,			// Target hits
	ai_charge, 0,	parasite_drain_attack,			// drain
	ai_charge, 0,	parasite_drain_attack,			// drain
	ai_charge, 0,	parasite_drain_attack,			// drain
	ai_charge, 0,	parasite_drain_attack,			// drain
	ai_charge, -2,  parasite_drain_attack,			// drain
	ai_charge, -2,	parasite_drain_attack,			// drain
	ai_charge, -3,	parasite_drain_attack,			// drain
	ai_charge, -2,	parasite_drain_attack,			// drain
	ai_charge, 0,	parasite_drain_attack,			// drain
	ai_charge, -1,  parasite_drain_attack,			// drain
	ai_charge, 0,	parasite_reel_in,				// let go
	ai_charge, -2,	NULL,
	ai_charge, -2,	NULL,
	ai_charge, -3,	NULL,
	ai_charge, 0,	NULL
};
mmove_t parasite_move_drain = {FRAME_drain01, FRAME_drain18, parasite_frames_drain, parasite_start_run};


mframe_t parasite_frames_break [] =
{
	ai_charge, 0,	NULL,
	ai_charge, -3,	NULL,
	ai_charge, 1,	NULL,
	ai_charge, 2,	NULL,
	ai_charge, -3,	NULL,
	ai_charge, 1,	NULL,
	ai_charge, 1,	NULL,
	ai_charge, 3,	NULL,
	ai_charge, 0,	NULL,
	ai_charge, -18,	NULL,
	ai_charge, 3,	NULL,
	ai_charge, 9,	NULL,
	ai_charge, 6,	NULL,
	ai_charge, 0,	NULL,
	ai_charge, -18,	NULL,
	ai_charge, 0,	NULL,
	ai_charge, 8,	NULL,
	ai_charge, 9,	NULL,
	ai_charge, 0,	NULL,
	ai_charge, -18,	NULL,
	ai_charge, 0,	NULL,
	ai_charge, 0,	NULL,		// airborne
	ai_charge, 0,	NULL,		// airborne
	ai_charge, 0,	NULL,		// slides
	ai_charge, 0,	NULL,		// slides
	ai_charge, 0,	NULL,		// slides
	ai_charge, 0,	NULL,		// slides
	ai_charge, 4,	NULL,
	ai_charge, 11,	NULL,		
	ai_charge, -2,	NULL,
	ai_charge, -5,	NULL,
	ai_charge, 1,	NULL
};
mmove_t parasite_move_break = {FRAME_break01, FRAME_break32, parasite_frames_break, parasite_start_run};

/*
=== 
Break Stuff Ends
===


void parasite_attack (edict_t *self)
{
//	if (random() <= 0.2)
//		self->monsterinfo.currentmove = &parasite_move_break;
//	else
		self->monsterinfo.currentmove = &parasite_move_drain;
}
*/

//MrC: Ok, started as a test and turned out awesome (imho). Electrical stun attacks from the parasite! Also, yea it's just the shambler lighting attack.
// Also they currently damage themselves with this attack which will need fixing if this stays in.

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
	setsize (self, '-16 -16 0', '16 16 16');
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
		sound (self, CHAN_VOICE, "misc/udeath.wav", 1, ATTN_NORM);
		
		for (n= 0; n < 2; n++)
			ThrowGib ("models/objects/gibs/bone/tris.md2", self.health / 4, GIB_FLESH);
		for (n= 0; n < 4; n++)
			ThrowGib ("models/objects/gibs/sm_meat/tris.md2", self.health / 4, GIB_FLESH);
		
		ThrowHead ("models/objects/gibs/head2/tris.md2", self.health / 4);
		
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
	self.classname = "q2monster_parasite";
	
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
