#include "monsterq2_infantry.qh"

/*
==============================================================================
INFANTRY CODE
==============================================================================
*/

void(float shotsfired) infantry_fire;

void()	infantry_stand1	=[	$stand1,	infantry_stand2	] {ai_stand();};
void()	infantry_stand2	=[	$stand2,	infantry_stand3	] {ai_stand();};
void()	infantry_stand3	=[	$stand3,	infantry_stand4	] {ai_stand();};
void()	infantry_stand4	=[	$stand4,	infantry_stand5	] {ai_stand();};
void()	infantry_stand5	=[	$stand5,	infantry_stand6	] {ai_stand();};
void()	infantry_stand6	=[	$stand6,	infantry_stand7	] {
ai_stand();
sound (self, CHAN_VOICE, "player/boot1.wav", 1, ATTN_IDLE);};
void()	infantry_stand7	=[	$stand7,	infantry_stand8	] {ai_stand();};
void()	infantry_stand8	=[	$stand8,	infantry_stand9	] {ai_stand();};
void()	infantry_stand9	=[	$stand9,	infantry_stand10	] {ai_stand();};
void()	infantry_stand10	=[	$stand10,	infantry_stand11	] {ai_stand();};
void()	infantry_stand11	=[	$stand11,	infantry_stand12	] {ai_stand();};
void()	infantry_stand12	=[	$stand12,	infantry_stand13	] {ai_stand();};
void()	infantry_stand13	=[	$stand13,	infantry_stand14	] {ai_stand();};
void()	infantry_stand14	=[	$stand14,	infantry_stand15	] {ai_stand();};
void()	infantry_stand15	=[	$stand15,	infantry_stand16	] {ai_stand();};
void()	infantry_stand16	=[	$stand16,	infantry_stand17	] {ai_stand();};
void()	infantry_stand17	=[	$stand17,	infantry_stand18	] {ai_stand();};
void()	infantry_stand18	=[	$stand18,	infantry_stand19	] {ai_stand();};
void()	infantry_stand19	=[	$stand19,	infantry_stand20	] {ai_stand();};
void()	infantry_stand20	=[	$stand20,	infantry_stand21	] {ai_stand();};
void()	infantry_stand21	=[	$stand21,	infantry_stand22	] {ai_stand();};
void()	infantry_stand22	=[	$stand22,	infantry_stand23	] {ai_stand();};
void()	infantry_stand23	=[	$stand23,	infantry_stand24	] {ai_stand();};
void()	infantry_stand24	=[	$stand24,	infantry_stand25	] {ai_stand();};
void()	infantry_stand25	=[	$stand25,	infantry_stand26	] {ai_stand();};
void()	infantry_stand26	=[	$stand26,	infantry_stand27	] {ai_stand();};
void()	infantry_stand27	=[	$stand27,	infantry_stand28	] {ai_stand();};
void()	infantry_stand28	=[	$stand28,	infantry_stand29	] {ai_stand();};
void()	infantry_stand29	=[	$stand29,	infantry_stand30	] {ai_stand();};
void()	infantry_stand30	=[	$stand30,	infantry_stand31	] {ai_stand();};
void()	infantry_stand31	=[	$stand31,	infantry_stand32	] {ai_stand();};
void()	infantry_stand32	=[	$stand32,	infantry_stand33	] {ai_stand();};
void()	infantry_stand33	=[	$stand33,	infantry_stand34	] {ai_stand();};
void()	infantry_stand34	=[	$stand34,	infantry_stand35	] {ai_stand();};
void()	infantry_stand35	=[	$stand35,	infantry_stand36	] {ai_stand();};
void()	infantry_stand36	=[	$stand36,	infantry_stand37	] {ai_stand();};
void()	infantry_stand37	=[	$stand37,	infantry_stand38	] {ai_stand();};
void()	infantry_stand38	=[	$stand38,	infantry_stand39	] {ai_stand();};
void()	infantry_stand39	=[	$stand39,	infantry_stand40	] {ai_stand();};
void()	infantry_stand40	=[	$stand40,	infantry_stand41	] {ai_stand();};
void()	infantry_stand41	=[	$stand41,	infantry_stand42	] {ai_stand();};
void()	infantry_stand42	=[	$stand42,	infantry_stand43	] {ai_stand();};
void()	infantry_stand43	=[	$stand43,	infantry_stand44	] {ai_stand();};
void()	infantry_stand44	=[	$stand44,	infantry_stand45	] {ai_stand();};
void()	infantry_stand45	=[	$stand45,	infantry_stand46	] {ai_stand();};
void()	infantry_stand46	=[	$stand46,	infantry_stand47	] {ai_stand();};
void()	infantry_stand47	=[	$stand47,	infantry_stand48	] {ai_stand();};
void()	infantry_stand48	=[	$stand48,	infantry_stand49	] {
ai_stand();
sound (self, CHAN_VOICE, "player/boot2.wav", 1, ATTN_IDLE);};
void()	infantry_stand49	=[	$stand49,	infantry_stand50	] {ai_stand();};
void()	infantry_stand50	=[	$stand50,	infantry_stand51	] {ai_stand();};
void()	infantry_stand51	=[	$stand51,	infantry_stand52	] {ai_stand();};
void()	infantry_stand52	=[	$stand52,	infantry_stand53	] {ai_stand();};
void()	infantry_stand53	=[	$stand53,	infantry_stand54	] {ai_stand();};
void()	infantry_stand54	=[	$stand54,	infantry_stand55	] {ai_stand();};
void()	infantry_stand55	=[	$stand55,	infantry_stand56	] {ai_stand();};
void()	infantry_stand56	=[	$stand56,	infantry_stand57	] {ai_stand();};
void()	infantry_stand57	=[	$stand67,	infantry_stand58	] {ai_stand();};
void()	infantry_stand58	=[	$stand58,	infantry_stand59	] {ai_stand();};
void()	infantry_stand59	=[	$stand59,	infantry_stand60	] {ai_stand();};
void()	infantry_stand60	=[	$stand60,	infantry_stand61	] {ai_stand();};
void()	infantry_stand61	=[	$stand61,	infantry_stand62	] {ai_stand();};
void()	infantry_stand62	=[	$stand62,	infantry_stand63	] {ai_stand();};
void()	infantry_stand63	=[	$stand63,	infantry_stand64	] {ai_stand();};
void()	infantry_stand64	=[	$stand64,	infantry_stand65	] {ai_stand();};
void()	infantry_stand65	=[	$stand65,	infantry_stand66	] {ai_stand();};
void()	infantry_stand66	=[	$stand66,	infantry_stand67	] {ai_stand();};
void()	infantry_stand67	=[	$stand67,	infantry_stand68	] {ai_stand();};
void()	infantry_stand68	=[	$stand68,	infantry_stand69	] {ai_stand();};
void()	infantry_stand69	=[	$stand69,	infantry_stand70	] {ai_stand();};
void()	infantry_stand70	=[	$stand70,	infantry_stand71	] {ai_stand();};
void()	infantry_stand71	=[	$stand71,	infantry_stand1	] {ai_stand();};

void()	infantry_walk1	=[	$walk01,	infantry_walk2	] {ai_walk(3);};
void()	infantry_walk2	=[	$walk02,	infantry_walk3	] {ai_walk(4);};
void()	infantry_walk3	=[	$walk03,	infantry_walk4	] {
ai_walk(3);
sound (self, CHAN_VOICE, "player/boot3.wav", 1, ATTN_IDLE);};
void()	infantry_walk4	=[	$walk04,	infantry_walk5	] {ai_walk(4);};
void()	infantry_walk5	=[	$walk05,	infantry_walk6	] {ai_walk(3);};
void()	infantry_walk6	=[	$walk06,	infantry_walk7	] {ai_walk(4);};
void()	infantry_walk7	=[	$walk07,	infantry_walk8	] {ai_walk(3);};
void()	infantry_walk8	=[	$walk08,	infantry_walk9	] {ai_walk(4);};
void()	infantry_walk9	=[	$walk09,	infantry_walk10	] {
ai_walk(3);
sound (self, CHAN_VOICE, "player/boot4.wav", 1, ATTN_IDLE);};
void()	infantry_walk10	=[	$walk10,	infantry_walk11	] {ai_walk(4);};
void()	infantry_walk11	=[	$walk11,	infantry_walk12	] {ai_walk(3);};
void()	infantry_walk12	=[	$walk12,	infantry_walk1	] {ai_walk(4);};


void()	infantry_run1	=[	$run01,		infantry_run2	] {
if (random() < 0.2)
	sound (self, CHAN_VOICE, "infantry/infidle1.wav", 1, ATTN_IDLE);
ai_run(11);};
void()	infantry_run2	=[	$run02,		infantry_run3	] {
ai_run(15);
sound (self, CHAN_VOICE, "player/boot3.wav", 1, ATTN_IDLE);};
void()	infantry_run3	=[	$run03,		infantry_run4	] {ai_run(10);};
void()	infantry_run4	=[	$run04,		infantry_run5	] {ai_run(10);};
void()	infantry_run5	=[	$run05,		infantry_run6	] {ai_run(8);};
void()	infantry_run6	=[	$run06,		infantry_run7	] {
ai_run(15);
sound (self, CHAN_VOICE, "player/boot4.wav", 1, ATTN_IDLE);};
void()	infantry_run7	=[	$run07,		infantry_run8	] {ai_run(10);};
void()	infantry_run8	=[	$run08,		infantry_run1	] {ai_run(8);};

/*

MELEE

*/

void(float damage) infantry_melee =
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
		sound(self, CHAN_WEAPON, "infantry/melee2.wav", 1, ATTN_NORM);
		}
	}
};

// MELEE ATTACK 2

framer($FRAME_attak201, $FRAME_attak208, q2infantry_melee, infantry_run1, 0.1,

	frame_arb($FRAME_attak203,sound(self, CHAN_WEAPON, "infantry/infatck2.wav", 1, ATTN_NORM););
	
	frame_arb($FRAME_attak206, infantry_melee(20); ai_charge(25););
);


void()	infantry_atk1	=[	$shoot1,	infantry_atk2	] {ai_face();};
void()	infantry_atk2	=[	$shoot2,	infantry_atk3	] {ai_face();sound(self, CHAN_WEAPON, "infantry/infatck3.wav", 1, ATTN_NORM);};
void()	infantry_atk3	=[	$shoot3,	infantry_atk4	] {ai_face();};
void()	infantry_atk4	=[	$shoot4,	infantry_atk5	] {ai_face();};
void()	infantry_atk5	=[	$shoot5,	infantry_atk5	] {ai_face();infantry_fire(12); self.effects = self.effects | EF_MUZZLEFLASH;};
void()	infantry_atk6	=[	$shoot6,	infantry_atk7	] {ai_face();};
void()	infantry_atk7	=[	$shoot7,	infantry_atk8	] {ai_face();SUB_CheckRefire (infantry_atk1);};
void()	infantry_atk8	=[	$shoot8,	infantry_atk9	] {ai_face();};
void()	infantry_atk9	=[	$shoot9,	infantry_run1	] {ai_face();};


void()	infantry_pain1	=[	$pain101,		infantry_pain2	] {	SpawnBlood (self.origin, '0 0 30', 30);};
void()	infantry_pain2	=[	$pain102,		infantry_pain3	] {};
void()	infantry_pain3	=[	$pain103,		infantry_pain4	] {};
void()	infantry_pain4	=[	$pain104,		infantry_pain5	] {};
void()	infantry_pain5	=[	$pain105,		infantry_pain6	] {};
void()	infantry_pain6	=[	$pain106,		infantry_pain7	] {};
void()	infantry_pain7	=[	$pain107,		infantry_pain8	] {};
void()	infantry_pain8	=[	$pain108,		infantry_pain9	] {};
void()	infantry_pain9	=[	$pain109,		infantry_pain10	] {};
void()	infantry_pain10	=[	$pain110,	infantry_run1	] {ai_pain(1);};

void()	infantry_painb1	=[	$pain201,	infantry_painb2	] {	SpawnBlood (self.origin, '0 0 30', 30);};
void()	infantry_painb2	=[	$pain202,	infantry_painb3	] {};
void()	infantry_painb3	=[	$pain203,	infantry_painb4	] {};
void()	infantry_painb4	=[	$pain204,	infantry_painb5	] {};
void()	infantry_painb5	=[	$pain205,	infantry_painb6	] {};
void()	infantry_painb6	=[	$pain206,	infantry_painb7	] {};
void()	infantry_painb7	=[	$pain207,	infantry_painb8	] {};
void()	infantry_painb8	=[	$pain208,	infantry_painb9	] {};
void()	infantry_painb9	=[	$pain209,	infantry_painb10	] {};
void()	infantry_painb10	=[	$pain210,	infantry_run1	] {};

void(entity attacker, float damage)	infantry_pain =
{
	local float r;

	if (self.pain_finished > time)
		return;

	r = random();

	if (r < 0.2)
	{
		self.pain_finished = time + 0.6;
		infantry_pain1 ();
		sound (self, CHAN_VOICE, "infantry/infpain1.wav", 1, ATTN_NORM);
	}
	else if (r < 0.6)
	{
		self.pain_finished = time + 1.1;
		infantry_painb1 ();
		sound (self, CHAN_VOICE, "infantry/infpain2.wav", 1, ATTN_NORM);
	}
	else
	{
		self.pain_finished = time + 1.1;
		infantry_pain1 ();
		sound (self, CHAN_VOICE, "infantry/infpain2.wav", 1, ATTN_NORM);
	}
	self.skin = 1;
};


/* void() infantry_fire =
{
	local	vector	dir;
	local	entity	en;

	ai_face();

	sound (self, CHAN_WEAPON, "infantry/infatck1.wav", 1, ATTN_NORM);

// fire somewhat behind the player, so a dodging player is harder to hit
	en = self.enemy;

	dir = en.origin - en.velocity*0.2;
	dir = normalize (dir - self.origin);

	FireBullets (1, dir, '0.1 0.1 0');
}; */

//MrC: takes average shots fired

void(float shotsfired) infantry_fire =
{
	local	vector	dir;
	local	entity	en;

    self.nextthink = time + 0.1;

	if (self.shotcount <= shotsfired)
	{
		
		if (random() < 0.5)
		{
			self.frame = $shoot5;
		}
		else
		{
			self.frame = $shoot6;
		}
    
	self.think = infantry_fire;
	ai_face();
	sound (self, CHAN_WEAPON, "infantry/infatck1.wav", 1, ATTN_NORM);

	en = self.enemy;
	dir = en.origin - en.velocity*0.1;
	dir = normalize (dir - self.origin);

	FireBullets (1, dir, '0.05 0.05 0');
	
	self.shotcount++;
	
	bprint (ftos(self.shotcount));
	bprint ("\n");
	}
	else
	{
		self.shotcount = 0;
		self.think = infantry_atk6;
	}
};


//LOOK MA NO HEAD
void()	infantry_die1	=[	$death101,	infantry_die2	] {SpawnBlood (self.origin + '0 0 16', '0 0 60', 30);};
void()	infantry_die2	=[	$death102,	infantry_die3	] {ThrowGib ("models/objects/gibs/head2/tris.md2", self.health);};
void()	infantry_die3	=[	$death103,	infantry_die4	] {self.solid = SOLID_CORPSE;self.ammo_shells = 5;DropBackpack();};
void()	infantry_die4	=[	$death104,	infantry_die5	] {};
void()	infantry_die5	=[	$death105,	infantry_die6	] {SpawnBlood (self.origin + '0 0 16', '0 -15 40', 30);};
void()	infantry_die6	=[	$death106,	infantry_die7	] {};
void()	infantry_die7	=[	$death107,	infantry_die8	] {};
void()	infantry_die8	=[	$death108,	infantry_die9	] {};
void()	infantry_die9	=[	$death109,	infantry_die10	] {SpawnBlood (self.origin + '0 0 16', '0 -15 35', 30);};
void()	infantry_die10	=[	$death110,	infantry_die11	] {};
void()	infantry_die11	=[	$death111,	infantry_die12	] {};
void()	infantry_die12	=[	$death112,	infantry_die13	] {};
void()	infantry_die13	=[	$death113,	infantry_die14	] {SpawnBlood (self.origin + '8 0 12', '0 35 30', 30);};
void()	infantry_die14	=[	$death114,	infantry_die15	] {};
void()	infantry_die15	=[	$death115,	infantry_die16	] {};
void()	infantry_die16	=[	$death116,	infantry_die17	] {};
void()	infantry_die17	=[	$death117,	infantry_die18	] {SpawnBlood (self.origin, '0 0 10', 30);};
void()	infantry_die18	=[	$death118,	infantry_die19	] {};
void()	infantry_die19	=[	$death119,	infantry_die20	] {};
void()	infantry_die20	=[	$death120,	infantry_die20	] {};

void()	infantry_cdie1	=[	$death201,	infantry_cdie2	] {};
void()	infantry_cdie2	=[	$death202,	infantry_cdie3	] {};
void()	infantry_cdie3	=[	$death203,	infantry_cdie4	] {self.solid = SOLID_CORPSE;self.ammo_shells = 5;DropBackpack();};
void()	infantry_cdie4	=[	$death204,	infantry_cdie5	] {};
void()	infantry_cdie5	=[	$death205,	infantry_cdie6	] {};
void()	infantry_cdie6	=[	$death206,	infantry_cdie7	] {};
void()	infantry_cdie7	=[	$death207,	infantry_cdie8	] {};
void()	infantry_cdie8	=[	$death208,	infantry_cdie9	] {};
void()	infantry_cdie9	=[	$death209,	infantry_cdie10	] {};
void()	infantry_cdie10	=[	$death210,	infantry_cdie11	] {};
void()	infantry_cdie11	=[	$death211,	infantry_cdie12	] {};
void()	infantry_cdie12	=[	$death212,	infantry_cdie13	] {};
void()	infantry_cdie13	=[	$death213,	infantry_cdie14	] {};
void()	infantry_cdie14	=[	$death214,	infantry_cdie15	] {};
void()	infantry_cdie15	=[	$death215,	infantry_cdie16	] {};
void()	infantry_cdie16	=[	$death216,	infantry_cdie17	] {};
void()	infantry_cdie17	=[	$death217,	infantry_cdie18	] {};
void()	infantry_cdie18	=[	$death218,	infantry_cdie19	] {};
void()	infantry_cdie19	=[	$death219,	infantry_cdie20	] {};
void()	infantry_cdie20	=[	$death220,	infantry_cdie21	] {};
void()	infantry_cdie21	=[	$death221,	infantry_cdie22	] {};
void()	infantry_cdie22	=[	$death222,	infantry_cdie23	] {};
void()	infantry_cdie23	=[	$death223,	infantry_cdie24	] {};
void()	infantry_cdie24	=[	$death224,	infantry_cdie25	] {};
void()	infantry_cdie25	=[	$death225,	infantry_cdie25	] {};

void()	infantry_ddie1	=[	$death301,	infantry_ddie2	] {};
void()	infantry_ddie2	=[	$death302,	infantry_ddie3	] {};
void()	infantry_ddie3	=[	$death303,	infantry_ddie4	]
{self.solid = SOLID_CORPSE;self.ammo_shells = 5;DropBackpack();ai_back(4);};
void()	infantry_ddie4	=[	$death304,	infantry_ddie5	] {};
void()	infantry_ddie5	=[	$death305,	infantry_ddie6	] {};
void()	infantry_ddie6	=[	$death306,	infantry_ddie7	] {};
void()	infantry_ddie7	=[	$death307,	infantry_ddie8	] {};
void()	infantry_ddie8	=[	$death308,	infantry_ddie9	] {};
void()	infantry_ddie9	=[	$death309,	infantry_ddie9	] {};

void() infantry_die =
{
	local float	n;
// check for gib
	// check for gib
	if (self.health < -30)
	{
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
		for (n= 0; n < 2; n++)
			ThrowGib ("models/objects/gibs/bone/tris.md2", self.health);
		for (n= 0; n < 4; n++)
			ThrowGib ("models/objects/gibs/sm_meat/tris.md2", self.health);
		
		ThrowHead ("models/objects/gibs/head2/tris.md2", self.health);
		return;
	}

// regular death
	sound (self, CHAN_VOICE, "infantry/infdeth2.wav", 1, ATTN_NORM);
	if (random() < 0.4)
		infantry_cdie1 ();
	if (random() < 0.7)
		infantry_die1 ();
	else
		infantry_ddie1 ();
};


/*QUAKED monster_infantry(1 0 0) (-16 -16 -24) (16 16 40) Ambush
*/
void() monster_infantry =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	
	self.classname = "q2monster_infantry";
	
	precache_model ("models/monsters/infantry/tris.md2");
	precache_model ("progs/h_guard.mdl");
	precache_model ("progs/gib1.mdl");
	precache_model ("progs/gib2.mdl");
	precache_model ("progs/gib3.mdl");

	precache_sound ("infantry/infdeth1.wav");
	precache_sound ("infantry/infdeth2.wav");
	precache_sound ("infantry/infidle1.wav");
	precache_sound ("infantry/infpain1.wav");
	precache_sound ("infantry/infpain2.wav");
	precache_sound ("soldier/sattck1.wav");
	precache_sound ("infantry/infsrch1.wav");
	precache_sound ("infantry/INFSGHT1.wav");


	precache_sound ("player/udeath.wav");		// gib death

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "models/monsters/infantry/tris.md2");

	setsize (self, '-16 -16 -24', '16 16 40');
	self.health = 30;

	self.th_stand = infantry_stand1;
	self.th_walk = infantry_walk1;
	self.th_run = infantry_run1;
	self.th_missile = infantry_atk1;
	self.th_pain = infantry_pain;
	self.th_die = infantry_die;
	self.th_melee = q2infantry_melee;

	self.sightSound = "infantry/INFSGHT1.wav";

	walkmonster_start;
};
