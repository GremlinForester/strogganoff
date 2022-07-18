/*
==============================================================================

QUAKE II STROGG FLYER

monster_flyer

==============================================================================
*/
#include "monsterq2_flyer.qh"

#define FLYER_SOUND_SIGHT 	"flyer/flysght1.wav"
#define FLYER_SOUND_IDLE 		"flyer/flysrch1.wav"
#define FLYER_SOUND_PAIN1 	"flyer/flypain1.wav"
#define FLYER_SOUND_PAIN2 	"flyer/flypain2.wav"
#define FLYER_SOUND_SPLASH 	"flyer/flyatck2.wav"
#define FLYER_SOUND_SPROING "flyer/flyatck1.wav"
#define FLYER_SOUND_BLASTER	"flyer/flyatck3.wav"
#define FLYER_SOUND_DIE 		"flyer/flydeth1.wav"


float FLYER_NEXT_MOVE;

void() flyer_check_melee;
void() flyer_loop_melee;
void() flyer_melee;
void() flyer_setstart;
void() flyer_stand;
void() flyer_nextmove;

void() flyer_sight ={
	sound(self, CHAN_VOICE, FLYER_SOUND_SIGHT, 1, ATTN_NORM);
};

void() flyer_idle ={
	sound(self, CHAN_VOICE, FLYER_SOUND_IDLE, 1, ATTN_IDLE);
};

void() flyer_pop_blades ={
	sound(self, CHAN_VOICE, FLYER_SOUND_SPROING, 1, ATTN_NORM);
};

void(float side) flyer_blaster_fire={
	local vector org;
	local vector end;
	local vector dir;
	local vector ofs;
	
	if(side)
		ofs = '12.1 -7.4 -14.5';
	else
		ofs = '12.1 13.4 -14.5';
	
	makevectors(self.angles);
	
	org = self.origin + (v_forward * ofs_x) + (v_right * ofs_y) + (v_up * ofs_z);
	
	end = self.enemy.origin;
	end_z = end_z + self.enemy.view_ofs_z;
	
	dir = normalize(end - org);

	monster_fire_blaster(org, dir, 10, '0.5 0.5 1', MF_TRACER3);
	sound(self, CHAN_WEAPON, FLYER_SOUND_BLASTER, 1, ATTN_NORM);
};


//STAND1
framerloop($FRAME_stand01, $FRAME_stand45, flyer_stand, 0.1, ai_stand(););

//WALK1
framerloop($FRAME_stand01, $FRAME_stand45, flyer_walk, 0.1, ai_walk(5););

//RUN1
framerloop($FRAME_stand01, $FRAME_stand45, flyer_run, 0.1, ai_run(10););

void() flyer_run_start={
	flyer_run();
};

//START
framer($FRAME_start01, $FRAME_start06, flyer_start1, flyer_nextmove, 0.1, ai_stand(););

//STOP
framer($FRAME_stop01, $FRAME_stop07, flyer_stop1, flyer_nextmove, 0.1, ai_stand(););

//ROLL RIGHT
framer($FRAME_rollr01, $FRAME_rollr09, flyer_roll_right, flyer_run_start, 0.1, ai_run(32););

//ROLL LEFT
framer($FRAME_rollf01, $FRAME_rollf09, flyer_roll_left, flyer_run_start, 0.1, ai_run(32););

//PAIN1
framer($FRAME_pain101, $FRAME_pain109, flyer_pain1, flyer_run_start, 0.1, ai_stand(););

//PAIN2
framer($FRAME_pain201, $FRAME_pain204, flyer_pain2_1, flyer_run_start, 0.1, ai_stand(););

//PAIN3
framer($FRAME_pain301, $FRAME_pain304, flyer_pain3_1, flyer_run_start, 0.1, ai_stand(););

//PAIN SELECT
void(entity attacker, float damage) flyer_pain={
	local float r;
	
	if(self.health < (self.max_health / 2))
		self.skin = 1;
	
	if(self.pain_finished < time)
		return;
	
	if(skill == 3)
		return;
	
	self.pain_finished = time + 3;
	r = random();
	if(r < 0.3){
		flyer_pain1();
		sound(self, CHAN_VOICE, FLYER_SOUND_PAIN1, 1, ATTN_NORM);
	}
	else if(r <= 0.6){
		flyer_pain2_1();
		sound(self, CHAN_VOICE, FLYER_SOUND_PAIN1, 1, ATTN_NORM);
	}
	else{
		flyer_pain3_1();
		sound(self, CHAN_VOICE, FLYER_SOUND_PAIN2, 1, ATTN_NORM);
	}
};

//DEFENSE
framer($FRAME_defens01,$FRAME_defens06,flyer_defense,flyer_run_start,0.1,ai_back(0););

//BANK RIGHT
framer($FRAME_bankr01,$FRAME_bankr07,flyer_bank_right,flyer_run_start,0.1,
	ai_run(20);
	frametwo_arb($FRAME_bankr01,$FRAME_bankr03,flyer_blaster_fire(0););
	//fire right
	frametwo_arb($FRAME_bankr02,$FRAME_bankr04,flyer_blaster_fire(1););
);

//BANK LEFT
framer($FRAME_bankl01,$FRAME_bankl07,flyer_bank_left,flyer_run_start,0.1,
	ai_run(20);
	frametwo_arb($FRAME_bankr01,$FRAME_bankr03,flyer_blaster_fire(0););
	//fire right
	frametwo_arb($FRAME_bankr02,$FRAME_bankr04,flyer_blaster_fire(1););
);

//ATTACK2
framer($FRAME_attak201, $FRAME_attak217, flyer_attack2_1, flyer_run_start, 0.1, 
	ai_charge(0);
	//fire left
	frametwo_arb($FRAME_attak204,$FRAME_attak206,ai_charge(-10);flyer_blaster_fire(0););
	frametwo_arb($FRAME_attak208,$FRAME_attak210,ai_charge(-10);flyer_blaster_fire(0););
	//fire right
	frametwo_arb($FRAME_attak205,$FRAME_attak207,ai_charge(-10);flyer_blaster_fire(1););
	frametwo_arb($FRAME_attak209,$FRAME_attak211,ai_charge(-10);flyer_blaster_fire(1););
);


void() flyer_slash_left=
{
	if (!self.enemy)
		return;
	if (!CanDamage (self.enemy, self))
		return;
	
	if (vlen(self.enemy.origin - self.origin) > 64)
		return;
	
	T_Damage(self.enemy, self, self, 5);
	sound (self, CHAN_WEAPON, FLYER_SOUND_SPLASH, 1, ATTN_NORM);
}

void() flyer_slash_right=
{
	if (!self.enemy)
		return;
	if (!CanDamage (self.enemy, self))
		return;
	
	if (vlen(self.enemy.origin - self.origin) > 64)
		return;
	
	T_Damage(self.enemy, self, self, 5);
	sound (self, CHAN_WEAPON, FLYER_SOUND_SPLASH, 1, ATTN_NORM);
}


//ATTACk1
framer($FRAME_attak101, $FRAME_attak106, flyer_move_start_melee, flyer_loop_melee, 0.1, 
	ai_charge(0);
	frame_arb($FRAME_attak101,flyer_pop_blades(););
);

framer($FRAME_attak119, $FRAME_attak121, flyer_move_end_melee, flyer_run_start, 0.1, ai_charge(0););

framer($FRAME_attak107, $FRAME_attak118, flyer_move_loop_melee, flyer_check_melee, 0.1, ai_charge(0);
	frame_arb($FRAME_attak110,flyer_slash_left(););
	frame_arb($FRAME_attak115 ,flyer_slash_right(););
);

//LOGIC
void() flyer_check_melee={
	
	if (range(self.enemy) == RANGE_MELEE)
		if (random() <= 0.8)
			flyer_move_loop_melee();
		else
			flyer_move_end_melee();
	else
		flyer_move_end_melee();
};

void() flyer_loop_melee ={
	flyer_move_loop_melee();
};

void() flyer_attack ={
	local float dice;
	if(self.health < self.max_health / 2){
		if(self.attack_state != AS_SLIDING){
			dice = random();
			if(dice < 0.4){
				self.attack_state = AS_SLIDING;
				self.lefty = 1;
				flyer_bank_left();
				return;
			}
			else if(dice < 0.7){
				self.attack_state = AS_SLIDING;
				self.lefty = 0;
				flyer_bank_right();
				return;
			}
		}
	}
	flyer_attack2_1();
	self.attack_state = AS_MISSILE;
};

void() flyer_melee={
	flyer_move_start_melee();
};

void() flyer_setstart={
	FLYER_NEXT_MOVE = $ACTION_run;
	flyer_start1();
};

void() flyer_nextmove={
	if (FLYER_NEXT_MOVE == $ACTION_attack1)
		flyer_move_start_melee();
	else if (FLYER_NEXT_MOVE == $ACTION_attack2)
		flyer_attack2_1();
	else if (FLYER_NEXT_MOVE == $ACTION_run)
		flyer_run_start();
};


//DEATH
void() flyer_die=
{
	sound (self, CHAN_VOICE, FLYER_SOUND_DIE, 1, ATTN_NORM);
	gibMonster();
	remove(self);
};

void() precache_flyer =
{
	precache_model("models/monsters/flyer/tris.md2");
	
	precache_sound (FLYER_SOUND_SIGHT);
	precache_sound (FLYER_SOUND_IDLE);
	precache_sound (FLYER_SOUND_PAIN1);
	precache_sound (FLYER_SOUND_PAIN2);
	precache_sound (FLYER_SOUND_SPLASH);
	precache_sound (FLYER_SOUND_SPROING);
	precache_sound (FLYER_SOUND_DIE);	
}

/*QUAKED monster_flyer (1 .5 0) (-16 -16 -24) (16 16 32) Ambush Trigger_Spawn Sight
*/
void() monster_flyer=
{
	self.classname = "monster_flyer";
	
	if(deathmatch){
		remove(self);
		return;
	}
	
	precache_flyer();
	
	self.solid = SOLID_BBOX;
	self.movetype = MOVETYPE_STEP;
	
	setmodel(self, "models/monsters/flyer/tris.md2");
	
	setsize(self, '-16 -16 -24', '16 16 32');
	
	self.health = 50;
	self.max_health = self.health;
	
	self.th_stand = flyer_stand;
	self.th_walk = flyer_walk;
	self.th_run = flyer_run_start;
	self.th_missile = flyer_attack;
	self.th_melee = flyer_melee;
	self.th_pain = flyer_pain;
	self.th_die = flyer_die;
	
	flymonster_start;
};