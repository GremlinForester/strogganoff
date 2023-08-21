/*
==============================================================================

QUAKE II STROGG FLOATER

monster_floater

==============================================================================
*/

#include "monsterq2_floater.qh"

#define FLOATER_SOUND_ATTACK2	"floater/Fltatck2.wav"
#define FLOATER_SOUND_ATTACK3	"floater/Fltatck3.wav"
#define FLOATER_SOUND_DEATH1	"floater/Fltdeth1.wav"
#define FLOATER_SOUND_IDLE		"floater/Fltidle1.wav"
#define FLOATER_SOUND_PAIN1		"floater/Fltpain1.wav"
#define FLOATER_SOUND_PAIN2		"floater/Fltpain2.wav"
#define FLOATER_SOUND_SIGHT		"floater/Fltsght1.wav"
#define FLOATER_SOUND_ACT1		"switches/butn2.wav"
#define FLOATER_SOUND_ACT2		"flyer/Flyatck1.wav"
#define FLOATER_SOUND_ACT3		"flyer/Flyatck2.wav"

void() floater_stand_switch;
void() floater_attack_start;
void() floater_run1;
void() floater_activate;

//ACTIVATE
framer($actvat01, $actvat31, floater_activate, floater_run1, 0.1, 
//SUB_Null();
//	frame_arb($attak104, floater_fire_blaster(););
//	frame_arb($attak105, floater_fire_blaster(););

	frame_arb($actvat02, sound (self, CHAN_VOICE, FLOATER_SOUND_IDLE, 1, ATTN_NORM););	
	frame_arb($actvat04, sound (self, CHAN_BODY, FLOATER_SOUND_PAIN2, 1, ATTN_NORM););
	frame_arb($actvat07, sound (self, CHAN_AUTO, FLOATER_SOUND_ACT1, 1, ATTN_NORM););
	frame_arb($actvat16, sound (self, CHAN_AUTO, FLOATER_SOUND_ACT2, 1, ATTN_NORM););	
	frame_arb($actvat20, sound (self, CHAN_AUTO, FLOATER_SOUND_ACT3, 1, ATTN_NORM););
	frame_arb($actvat22, sound (self, CHAN_AUTO, FLOATER_SOUND_SIGHT, 1, ATTN_NORM););	
);

//STAND1
framer($stand101, $stand152, floater_stand1, floater_stand_switch, 0.1,
	ai_stand();
);

//STAND2
framer($stand201, $stand252, floater_stand2_1, floater_stand_switch, 0.1,
	ai_stand();
);

//PAIN1
framer($pain101, $pain107, floater_pain1, floater_run1, 0.1, ai_walk(0); );

//PAIN2
framer($pain201, $pain208, floater_pain2, floater_run1, 0.1, ai_walk(0); );

//PAIN3
framer($pain301, $pain312, floater_pain3, floater_run1, 0.1, ai_walk(0); );

void(entity attacker, float damage) floater_pain={
	local float r;
	
	if(self.health < (self.max_health / 2))
		self.skin = 1;
	
	if(self.pain_finished > time)
		return;
	
	if(skill == 3)
		return;
	
	if((self.enemy == world) && (self.spawnflags & 1)){
		self.enemy = attacker;
		floater_activate();
		return;
	}
	
	r = random();
	if(r < 0.3){
		self.pain_finished = time + 2.7;
		floater_pain1();
		sound(self, CHAN_VOICE, FLOATER_SOUND_PAIN1, 1, ATTN_NORM);
	}
	else if(r <= 0.6){
		floater_pain2();
		self.pain_finished = time + 3.8;
		sound(self, CHAN_VOICE, FLOATER_SOUND_PAIN1, 1, ATTN_NORM);
	}
	else{
		floater_pain3();
		self.pain_finished = time + 4.2;
		sound(self, CHAN_VOICE, FLOATER_SOUND_PAIN2, 1, ATTN_NORM);
	}
	
	
	self.bIsWounded = 1;
	self.bleedcount = 0;
};

void() floater_fire_blaster={
	local	vector	dir;
	local	entity	en;
	local vector org;
	
	ai_face();
	
	makevectors(self.angles);
	
	org = self.origin + (v_forward * 30) + (v_right * -0.8) + (v_up * 10);
	
	en = self.enemy;
	
	dir = en.origin + en.velocity*0.2;
	dir = normalize (dir - org);
	
	monster_fire_blaster(org, dir, autocvar_sk_q2floater_blaster_damage, '2 0.5 0.5', MF_TRACER2);
	sound (self, CHAN_WEAPON, "weapons/BLASTF1A.WAV", 1, ATTN_NORM);
};

/*
	
*/
void() floater_wham={
	if (!self.enemy)
		return;
	if (!CanDamage (self.enemy, self))
		return;
	
	if (vlen(self.enemy.origin - self.origin) > 75)
		return;
	
	T_Damage(self.enemy, self, self, autocvar_sk_q2floater_wham_damage + (4*random()));
	sound (self, CHAN_WEAPON, FLOATER_SOUND_ATTACK3, 1, ATTN_NORM);
};

/*
	
*/
void() floater_zap={
	local vector dir;
	local vector org;
	
	makevectors(self.angles);
	
	org = self.origin + (v_forward * 24) + (v_right * -0.9) + (v_up * 10);
	dir = normalize(self.enemy.origin - org) * 14;
	
	te_spark(org, dir, 15);
	
	//T_Damage(self.enemy, self, self, 7 * random());
	T_Damage(self.enemy, self, self, autocvar_sk_q2floater_zap_damage);
	
	sound (self, CHAN_WEAPON, FLOATER_SOUND_ATTACK2, 1, ATTN_NORM);
};


//ATTACK1
framer($attak101, $attak114, floater_attack1, floater_run1, 0.2, 

	ai_charge(5);
	frame_arb($attak104, floater_fire_blaster(););
	frame_arb($attak105, floater_fire_blaster(););
	frame_arb($attak106, floater_fire_blaster(););
	frame_arb($attak107, floater_fire_blaster(););
	frame_arb($attak108, floater_fire_blaster(););
	frame_arb($attak109, floater_fire_blaster(););
	frame_arb($attak110, floater_fire_blaster(););
);

//ATTACK2
framer($attak201, $attak225, floater_attack2_1, floater_run1, 0.1,
	ai_charge(0);
	frame_arb($attak215, floater_wham(););
);

//I find it odd that the melee attack for this anim is low frequency vs the total animation frames of the attack.
//	-Subject9x
//ATTACK3
framer($attak301, $attak334, floater_attack3_1, floater_run1, 0.1,
	ai_charge(0);
	frame_arb($attak309, floater_zap(););
	frame_arb($attak310, floater_zap(););
	frame_arb($attak311, floater_zap(););
	frame_arb($attak312, floater_zap(););
	frame_arb($attak313, floater_zap(););
	frame_arb($attak314, floater_zap(););
	frame_arb($attak315, floater_zap(););
	frame_arb($attak316, floater_zap(););
	frame_arb($attak317, floater_zap(););
	frame_arb($attak318, floater_zap(););
);

//ATTACK
void() floater_attack_start={
	floater_attack1();
};

//WALK
framerloop($stand101, $stand152, floater_walk1, 0.1, 
	ai_walk(5);
);

void() floater_walk_start={
	floater_walk1();
};

//RUN
framerloop($stand201, $stand252, floater_run1, 0.1, ai_run(13););

void() floater_run_start={
	floater_run1();
};

void() floater_stand_switch={
	if(random() <= 0.5)
		floater_stand1();
	else
		floater_stand2_1();
};

void() floater_stand_deactivated	=[	$actvat01,	floater_stand_deactivated	] {ai_stand();};

void() floater_stand_set={
	if(self.spawnflags & 1)
		floater_stand_deactivated();
	else
		floater_stand_switch();
};

void() floater_run_set =
{
	if(self.spawnflags & 1)
		floater_activate();
	else
		floater_run1();
};

void() floater_melee_select={
	if(random() <= 0.5)
		floater_attack2_1();
	else
		floater_attack3_1();
};

/*
	Curiously enough, there are death frames, and even the original Q2 has an animated death sequence for the
	floater...but its never used? maybe iD thought simply exploding and being removed quickly was the most
	optimized choice.
		-Subject9x
*/

void() floater_explode;

//DEATH1
framer($death01, $death13, floater_die1, SUB_Null, 0.1, 
frame_arb($death03, self.solid = SOLID_NOT;)
frame_arb($death09, floater_explode();)
);

void() floater_die={
	// check for gib
	self.movetype = MOVETYPE_TOSS;
	
	setsize(self, '-32 -32 -8', '32 32 32');
	setorigin(self, self.origin);
	
	if (self.health < -40)
	{
		floater_explode();
	}
	
	floater_die1 ();
};

/*
	Original Q2 behavior
*/
void floater_explode(){
	sound (self, CHAN_VOICE, FLOATER_SOUND_DEATH1, 1, ATTN_NORM);
	gibMonster();
	remove(self);
};

void() precache_floater =
{
	precache_model("models/monsters/float/tris.md2");
	
	precache_sound (FLOATER_SOUND_ATTACK2);
	precache_sound (FLOATER_SOUND_ATTACK3);
	precache_sound (FLOATER_SOUND_DEATH1);
	precache_sound (FLOATER_SOUND_IDLE);
	precache_sound (FLOATER_SOUND_PAIN1);
	precache_sound (FLOATER_SOUND_PAIN2);
	precache_sound (FLOATER_SOUND_SIGHT);
	precache_sound (FLOATER_SOUND_ACT1);
	precache_sound (FLOATER_SOUND_ACT2);
	precache_sound (FLOATER_SOUND_ACT3);	
}

/*QUAKED monster_floater (1 .5 0) (-16 -16 -16) (16 16 40) Ambush Trigger_Spawn Sight
*/
void() monster_floater=
{
	self.classname = "monster_floater";
	
	if(deathmatch){
		remove(self);
		return;
	}

	precache_floater();
	
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	
	setmodel(self, "models/monsters/float/tris.md2");
	
	setsize(self, '-16 -16 -16', '16 16 40');
	self.health = autocvar_sk_q2floater_health;
	self.max_health = self.health;
	
	//self.th_stand = floater_stand_switch;
	self.th_stand = floater_stand_set;
	self.th_walk = floater_walk1;
//	self.th_run = floater_run1;
	self.th_run = floater_run_set;
	self.th_missile = floater_attack_start;
	self.th_melee = floater_melee_select;
	self.th_pain = floater_pain;
	self.th_die = floater_die;

	flymonster_start;
}