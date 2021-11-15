/*
==============================================================================

BRAIN

==============================================================================
*/

#include "monsterq2_brain.qh"

#define BRAIN_CHEST_OPEN 		"brain/brnatck1.wav"
#define BRAIN_TENTACLES_EXTEND 	"brain/brnatck2.wav"
#define BRAIN_TENTACLES_RETRACT "brain/brnatck3.wav"
#define BRAIN_DEATH 			"brain/brndeth1.wav"
#define BRAIN_IDLE1 			"brain/brnidle1.wav"
#define BRAIN_IDLE2 			"brain/brnidle2.wav"
#define BRAIN_IDLE3 			"brain/brnlens1.wav"
#define BRAIN_PAIN1 			"brain/brnpain1.wav"
#define BRAIN_PAIN2 			"brain/brnpain2.wav"
#define BRAIN_SIGHT 			"brain/brnsght1.wav"
#define BRAIN_SEARCH 			"brain/brnsrch1.wav"
#define BRAIN_MELEE1 			"brain/melee1.wav"
#define BRAIN_MELEE2 			"brain/melee2.wav"
#define BRAIN_MELEE3 			"brain/melee3.wav"

//
// STAND
//

framerloop($FRAME_stand01, $FRAME_stand30, brain_stand_frames, 0.1, ai_stand());

//
// WALK
//

void() brain_walk	=[	$FRAME_walk101,	brain_walk2	]{ai_walk(7);Q3Surface_FootStep();};
void() brain_walk2	=[	$FRAME_walk102,	brain_walk3	]{ai_walk(2);};
void() brain_walk3	=[	$FRAME_walk103,	brain_walk4	]{ai_walk(3);};
void() brain_walk4	=[	$FRAME_walk104,	brain_walk5	]{ai_walk(3);Q3Surface_FootStep();};
void() brain_walk5	=[	$FRAME_walk105,	brain_walk6	]{ai_walk(1);};
void() brain_walk6	=[	$FRAME_walk106,	brain_walk7	]{ai_walk(0);};
void() brain_walk7	=[	$FRAME_walk107,	brain_walk8	]{ai_walk(0);};
void() brain_walk8	=[	$FRAME_walk108,	brain_walk9	]{ai_walk(9);};
void() brain_walk9	=[	$FRAME_walk109,	brain_walk10 ]{ai_walk(-4);};
void() brain_walk10	=[	$FRAME_walk110, brain_walk11 ]{ai_walk(-1);Q3Surface_FootStep();};
void() brain_walk11	=[	$FRAME_walk110, brain_walk ]{ai_walk(2);};

// RUN (slightly faster)

void() brain_run	=[	$FRAME_walk101,	brain_run2	]{ai_run(7);Q3Surface_FootStep();};
void() brain_run2	=[	$FRAME_walk102,	brain_run3	]{ai_run(2);};
void() brain_run3	=[	$FRAME_walk103,	brain_run4	]{ai_run(3);};
void() brain_run4	=[	$FRAME_walk104,	brain_run5	]{ai_run(3);Q3Surface_FootStep();};
void() brain_run5	=[	$FRAME_walk105,	brain_run6	]{ai_run(1);};
void() brain_run6	=[	$FRAME_walk106,	brain_run7	]{ai_run(0);};
void() brain_run7	=[	$FRAME_walk107,	brain_run8	]{ai_run(0);};
void() brain_run8	=[	$FRAME_walk108,	brain_run9	]{ai_run(9);};
void() brain_run9	=[	$FRAME_walk109,	brain_run0 ]{ai_run(-4);};
void() brain_run0	=[	$FRAME_walk110, brain_run1 ]{ai_run(-1);Q3Surface_FootStep();};
void() brain_run1	=[	$FRAME_walk110, brain_run ]{ai_run(2);};

// ATTACK 1

framer($FRAME_attak101, $FRAME_attak118, brain_atk1_frames, brain_run, 0.1,

	frame_arb($FRAME_attak105, 
	sound (self, CHAN_BODY, BRAIN_MELEE1, 1, ATTN_NORM);
	ai_melee();
	);
	frame_arb($FRAME_attak108, 
	sound (self, CHAN_BODY, BRAIN_MELEE2, 1, ATTN_NORM);
	ai_melee();
	);
	frame_arb($FRAME_attak110, 
	sound (self, CHAN_BODY, BRAIN_MELEE3, 1, ATTN_NORM);
	ai_melee();
	);
	frame_arb($FRAME_attak112, 
	sound (self, CHAN_BODY, BRAIN_MELEE1, 1, ATTN_NORM);
	ai_melee();
	);

	ai_rep($FRAME_attak101, ai_charge, 8, 3, 5, 0, -3, 0, -5, -7);
	ai_rep($FRAME_attak109, ai_charge, 0, 6, 1, 2, -3, 6, -1, -3);
	ai_rep($FRAME_attak117, ai_charge, 2, 11, 0, 0, 0, 0, 0, 0);
);


// ATTACK 2

framer($FRAME_attak201, $FRAME_attak217, brain_atk2_frames, brain_run, 0.1,

	frame_arb($FRAME_attak205, sound (self, CHAN_BODY, BRAIN_CHEST_OPEN, 1, ATTN_NORM););
	frame_arb($FRAME_attak207, sound (self, CHAN_BODY, BRAIN_TENTACLES_EXTEND, 1, ATTN_NORM); ai_melee(););
	frame_arb($FRAME_attak211, sound (self, CHAN_BODY, BRAIN_TENTACLES_RETRACT, 1, ATTN_NORM););

	ai_rep($FRAME_attak201, ai_charge, 5, -4, -4, -3, 0, 0, 13, 0);
	ai_rep($FRAME_attak209, ai_charge, 2, 0, -9, 0, 4, 3, 2, -3);
	ai_rep($FRAME_attak217, ai_charge, -6, 0, 0, 0, 0, 0, 0, 0);
);

void()	brain_3pain1	=[	$FRAME_pain301,		brain_3pain2	] {ai_painforward(-2);};
void()	brain_3pain2	=[	$FRAME_pain302,		brain_3pain3	] {ai_painforward(2);};
void()	brain_3pain3	=[	$FRAME_pain303,		brain_3pain4	] {ai_painforward(1);};
void()	brain_3pain4	=[	$FRAME_pain304,		brain_3pain5	] {ai_painforward(3);};
void()	brain_3pain5	=[	$FRAME_pain305,		brain_3pain6	] {};
void()	brain_3pain6	=[	$FRAME_pain306,		brain_run	] {ai_painforward(-4);};

void()	brain_2pain1	=[	$FRAME_pain201,		brain_2pain2	] {ai_painforward(-2);};
void()	brain_2pain2	=[	$FRAME_pain202,		brain_2pain3	] {};
void()	brain_2pain3	=[	$FRAME_pain203,		brain_2pain4	] {};
void()	brain_2pain4	=[	$FRAME_pain204,		brain_2pain5	] {};
void()	brain_2pain5	=[	$FRAME_pain205,		brain_2pain6	] {};
void()	brain_2pain6	=[	$FRAME_pain206,		brain_2pain7	] {ai_painforward(3);};
void()	brain_2pain7	=[	$FRAME_pain207,		brain_2pain8	] {ai_painforward(1);};
void()	brain_2pain8	=[	$FRAME_pain208,		brain_run	] {ai_painforward(-2);};

void()	brain_pain1		=[	$FRAME_pain101,		brain_pain2		] {ai_painforward(-6);};
void()	brain_pain2		=[	$FRAME_pain102,		brain_pain3		] {ai_painforward(-2);};
void()	brain_pain3		=[	$FRAME_pain103,		brain_pain4		] {ai_painforward(-6);};
void()	brain_pain4		=[	$FRAME_pain104,		brain_pain5		] {};
void()	brain_pain5		=[	$FRAME_pain105,		brain_pain6		] {};
void()	brain_pain6		=[	$FRAME_pain106,		brain_pain7		] {};
void()	brain_pain7		=[	$FRAME_pain107,		brain_pain8		] {};
void()	brain_pain8		=[	$FRAME_pain108,		brain_pain9		] {};
void()	brain_pain9		=[	$FRAME_pain109,		brain_pain10	] {};
void()	brain_pain10	=[	$FRAME_pain110,		brain_pain11	] {};
void()	brain_pain11	=[	$FRAME_pain111,		brain_pain12	] {};
void()	brain_pain12	=[	$FRAME_pain112,		brain_pain13	] {};
void()	brain_pain13	=[	$FRAME_pain113,		brain_pain14	] {};
void()	brain_pain14	=[	$FRAME_pain114,		brain_pain15	] {ai_painforward(2);};
void()	brain_pain15	=[	$FRAME_pain115,		brain_pain16	] {};
void()	brain_pain16	=[	$FRAME_pain116,		brain_pain17	] {ai_painforward(2);};
void()	brain_pain17	=[	$FRAME_pain117,		brain_pain18	] {ai_painforward(1);};
void()	brain_pain18	=[	$FRAME_pain118,		brain_pain19	] {ai_painforward(7);};
void()	brain_pain19	=[	$FRAME_pain119,		brain_pain20	] {};
void()	brain_pain20	=[	$FRAME_pain120,		brain_pain21	] {ai_painforward(3);};
void()	brain_pain21	=[	$FRAME_pain121,		brain_run		] {ai_painforward(-1);};

void(entity attacker, float damage)	brain_pain =
{
	local float r;

	if (self.health < (self.max_health / 2)){
		self.skin = 1;
	}
	
	if (self.pain_finished > time)
		return;

	r = random();

	if (r > 0.85)
	{
		sound (self, CHAN_VOICE, "brain/brnpain1.wav", 1, ATTN_NORM);
		brain_pain1 ();
		self.pain_finished = time + 1;
	}
	else if (r > 0.50)
	{
		sound (self, CHAN_VOICE, "brain/brnpain2.wav", 1, ATTN_NORM);
		brain_2pain1 ();
		self.pain_finished = time + 1;
	}
	else
	{
		sound (self, CHAN_VOICE, "brain/brnpain1.wav", 1, ATTN_NORM);
		brain_3pain1 ();
		self.pain_finished = time + 1;
	}
	SpawnBlood (self.origin, self.origin*0.2, damage * 4);
};

void() q2brain_dead =
{
	setsize (self, '-16 -16 -24', '16 16 -8');
	self.movetype = MOVETYPE_TOSS;
	self.solid = SOLID_CORPSE;
}

// Death 1

framer($FRAME_death101, $FRAME_death118, brain_die1_frames, SUB_Null, 0.1,
	
	frame_arb($FRAME_death101,

		q2brain_dead();
	//	self.ammo_shells = 5;
	//	DropBackpack();
	);
);

// Death 2

framer($FRAME_death201, $FRAME_death205, brain_die2_frames, SUB_Null, 0.1,
	
	frame_arb($FRAME_death201,

		q2brain_dead();;
	//	self.ammo_shells = 5;
	//	DropBackpack();
	);
);

void() brain_die =
{
	local float n;

 	if (self.health < -80)
	{
		sound (self, CHAN_VOICE, "misc/udeath.wav", 1, ATTN_NORM);
		
		for (n= 0; n < 2; n++)
			ThrowGib ("models/objects/gibs/bone/tris.md2", self.health / 1.15, GIB_FLESH);
			ThrowGib ("models/objects/debris1/tris.md2", self.health / 1.25, GIB_FLAMING);
			ThrowGib ("models/objects/debris2/tris.md2", self.health / 1.25, GIB_FLAMING);
		for (n= 0; n < 4; n++)
			ThrowGib ("models/objects/gibs/sm_meat/tris.md2", self.health / 1.15, GIB_FLESH);
		
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
	sound (self, CHAN_VOICE, "brain/brndeth1.wav", 1, ATTN_NORM);
	self.deadflag = DEAD_DEAD;
	if (random() < 0.5)
		brain_die1_frames ();
	else
		brain_die2_frames ();
	}
};

void()	brain_melee =
{
	local float r;

	r = random();

	if (r < 0.5)
	{
		brain_atk1_frames();
	}
	else
	{
		brain_atk2_frames();
	}
};

/*QUAKED monster_brain (1 .5 0) (-16 -16 -24) (16 16 32) Ambush Trigger_Spawn Sight
*/
void() monster_brain =
{
	self.classname = "monster_brain";
	
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model ("models/monsters/brain/tris.md2");

	precache_sound ("brain/brnatck1.wav");
	precache_sound ("brain/brnatck2.wav");
	precache_sound ("brain/brnatck3.wav");
	precache_sound ("brain/brndeth1.wav");
	precache_sound ("brain/brnidle1.wav");
	precache_sound ("brain/brnidle2.wav");
	precache_sound ("brain/brnlens1.wav");
	precache_sound ("brain/brnpain1.wav");
	precache_sound ("brain/brnpain2.wav");
	precache_sound ("brain/brnsght1.wav");
	precache_sound ("brain/brnsrch1.wav");
	precache_sound ("brain/melee1.wav");
	precache_sound ("brain/melee2.wav");
	precache_sound ("brain/melee3.wav");
	
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "models/monsters/brain/tris.md2");

	setsize (self, '-16 -16 -24', '16 16 32');
	self.health = 150;
	self.max_health = self.health;

	self.th_stand = brain_stand_frames;
	self.th_walk = brain_walk; //frames
	self.th_run = brain_run; //frames
	self.th_melee = brain_melee;
	self.th_pain = brain_pain;
	self.th_die = brain_die;

	self.sightSound = BRAIN_SIGHT;

	walkmonster_start;
};
