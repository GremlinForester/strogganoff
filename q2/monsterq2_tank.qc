/*
==============================================================================

QUAKE II STROGG TANK

monster_tank

==============================================================================
*/

#include "monsterq2_tank.qh"

void() tank_refire_rocket;
void() tank_doattack_rocket;
void() tank_reattack_blaster;

#define TANK_SOUND_PAIN		"tank/tnkpain2.wav"
#define TANK_SOUND_THUD		"tank/tnkdeth2.wav"
#define TANK_SOUND_IDLE		"tank/tnkidle1.wav"
#define TANK_SOUND_DIE		"tank/death.wav"
#define TANK_SOUND_STEP		"tank/step.wav"
#define TANK_SOUND_WINDUP		"tank/tnkatck4.wav"
#define TANK_SOUND_STRIKE		"tank/tnkatck5.wav"
#define TANK_SOUND_SIGHT		"tank/sight1.wav"

//Muzzle Flash offsets
#define MZ2_TANK_BLASTER_1	'20.7 -18.5 28.7'
#define MZ2_TANK_BLASTER_2	'16.6 -21.5 30.1'
#define MZ2_TANK_BLASTER_3	'11.8 -23.9 32.1'

#define MZ2_TANK_ROCKET_1	'6.2 29.1 49.1'
#define MZ2_TANK_ROCKET_2	'6.9 23.8 49.1'
#define MZ2_TANK_ROCKET_3	'8.3 17.8 49.5'

float INI_TANK_DATA;
vector MZ2_TANK_MACHINEGUN[19];

void() tank_sight={
	sound (self, CHAN_VOICE, TANK_SOUND_SIGHT, 1, ATTN_NORM);
};

void() tank_footstep={
	sound (self, CHAN_BODY, TANK_SOUND_STEP, 1, ATTN_NORM);
};

void() tank_thud={
	sound (self, CHAN_BODY, TANK_SOUND_THUD, 1, ATTN_NORM);
};

void() tank_windup={
	sound (self, CHAN_WEAPON, TANK_SOUND_WINDUP, 1, ATTN_NORM);
};

void() tank_idle={
	sound (self, CHAN_VOICE, TANK_SOUND_IDLE, 1, ATTN_NORM);
};

//STAND
framerloop($FRAME_stand01, $FRAME_stand30, tank_move_stand, 0.1, ai_stand(););

void() tank_stand={
	tank_move_stand();
};

//WALK
void() tank_walk;

framer($FRAME_walk01, $FRAME_walk04, tank_move_start_walk, tank_walk, 0.1,
	frame_arb($FRAME_walk01, ai_walk(0););
	frametwo_arb($FRAME_walk02, $FRAME_walk03, ai_walk(6););
	frame_arb($FRAME_walk04, ai_walk(11););
);

void() tank_move_walk2_;

/*
I broke walk cycle into 2 parts to not choke the macro (?)
*/
framer($FRAME_walk05, $FRAME_walk12, tank_move_walk1_, tank_move_walk2_, 0.1, 
	ai_rep($FRAME_walk05, ai_walk, 4,5,3,2,5,5,4,4);
	frame_arb($FRAME_walk12, tank_footstep(););
);

framer($FRAME_walk13, $FRAME_walk20, tank_move_walk2_, tank_walk, 0.1,
	ai_rep($FRAME_walk13, ai_walk, 3,5,4,5,7,7,6,6);
	frame_arb($FRAME_walk20, tank_footstep(););
);

//walk stop
framer($FRAME_walk21, $FRAME_walk25, tank_move_stop_walk, tank_stand, 0.1, 
	ai_rep($FRAME_walk21, ai_walk, 3,3,2,2,4,-6,-6,-6);
	frame_arb($FRAME_walk25, tank_footstep(););
);

void() tank_walk={
	tank_move_walk1_();
};

//RUN
void() tank_run;

framer($FRAME_walk01, $FRAME_walk04, tank_move_start_run, tank_run, 0.1, 
	ai_rep($FRAME_walk01, ai_run, 0,6,6,11,-6,-6,-6,-6);
);

/*
I broke run cycle into 2 parts to not choke the macro (?)
*/
void() tank_move_run2_;

framer($FRAME_walk05, $FRAME_walk12, tank_move_run1_, tank_move_run2_, 0.1, 
	ai_rep($FRAME_walk05, ai_run, 4,5,3,2,5,5,4,4);
	frame_arb($FRAME_walk12, tank_footstep(););
);

framer($FRAME_walk13, $FRAME_walk20, tank_move_run2_, tank_run, 0.1,
	ai_rep($FRAME_walk13, ai_run, 3,5,4,5,7,7,6,6);
	frame_arb($FRAME_walk20, tank_footstep(););
);

framer($FRAME_walk21, $FRAME_walk25, tank_move_stop_run, tank_walk, 0.1, 
	ai_rep($FRAME_walk21, ai_run, 3,3,2,2,4,-6,-6,-6);
	frame_arb($FRAME_walk25, tank_footstep(););
);


void() tank_run={
	/*if (self->enemy && self->enemy->client)
		self->monsterinfo.aiflags |= AI_BRUTAL;
	else
		self->monsterinfo.aiflags &= ~AI_BRUTAL;

	if (self->monsterinfo.aiflags & AI_STAND_GROUND)
	{
		self->monsterinfo.currentmove = &tank_move_stand;
		return;
	}*/

	if (self.frame >= $FRAME_walk01 && self.frame < $FRAME_walk21)
	{
		tank_move_run1_();
	}
	else
	{
		tank_move_start_run();
	}
};

//PAIN
framer($FRAME_pain101, $FRAME_pain104, tank_move_pain1_, tank_run, 0.1, ai_walk(0););

framer($FRAME_pain201, $FRAME_pain205, tank_move_pain2_, tank_run, 0.1, ai_walk(0););

framer($FRAME_pain301, $FRAME_pain316, tank_move_pain3_, tank_run, 0.1, ai_walk(0);
	ai_rep($FRAME_pain301, ai_walk, -7,0,0,0,2,0,0,3);
	ai_rep($FRAME_pain309, ai_walk, 0,2,0,0,0,0,0,0);
	frame_arb($FRAME_pain316, tank_footstep(););
);

void(entity attacker, float damage) tank_pain={
	if(self.health < (self.max_health / 2))
		self.skin = 1;

	if (damage <= 10)
		return;

	if(self.pain_finished < time)
		return;

	if (damage <= 30)
		if (random() > 0.2)
			return;
	
	// If hard or nightmare, don't go into pain while attacking
	if ( skill >= 2)
	{
		if ( (self.frame >= $FRAME_attak301) && (self.frame <= $FRAME_attak330) )
			return;
		if ( (self.frame >= $FRAME_attak101) && (self.frame <= $FRAME_attak116) )
			return;
	}

	self.pain_finished = time + 3;
	sound(self, CHAN_VOICE, TANK_SOUND_PAIN, 1, ATTN_NORM);
	
	if (skill == 3)
		return;		// no pain anims in nightmare

	if (damage <= 30)
		tank_move_pain1_();
	else if (damage <= 60)
		tank_move_pain2_();
	else
		tank_move_pain3_();
	
	self.bIsWounded = 1;
	self.bleedcount = 0;
};

//ATTACKS
void() TankBlaster ={
	local vector start;
	local vector end;
	local vector dir;
	local vector org_offset;

	if (self.frame == $FRAME_attak110)
		org_offset = MZ2_TANK_BLASTER_1;
	else if (self.frame == $FRAME_attak113)
		org_offset = MZ2_TANK_BLASTER_2;
	else // (self->s.frame == FRAME_attak116)
		org_offset = MZ2_TANK_BLASTER_3;

	makevectors(self.angles);
	
	start = self.origin + (v_forward * org_offset_x) + (v_right * org_offset_y) + (v_up * org_offset_z);
	end = self.enemy.origin;
	end_z = end_z + self.enemy.view_ofs_z;
	
	dir = normalize(end - start);
	
	monster_fire_blaster (start, dir, 30);
};

void() TankStrike ={
	sound(self, CHAN_WEAPON, TANK_SOUND_STRIKE, 1, ATTN_NORM);
};

void() TankRocket ={
	local vector start;
	local vector end;
	local vector dir;
	local vector org_offset;
	
	if (self.frame == $FRAME_attak324)
		org_offset = MZ2_TANK_ROCKET_1;
	else if (self.frame == $FRAME_attak327)
		org_offset = MZ2_TANK_ROCKET_2;
	else // (self->s.frame == FRAME_attak330)
		org_offset = MZ2_TANK_ROCKET_3;
	
	makevectors(self.angles);
	
	start = self.origin + (v_forward * org_offset_x) + (v_right * org_offset_y) + (v_up * org_offset_z);
	end = self.enemy.origin;
	end_z = end_z + self.enemy.view_ofs_z;
	
	dir = normalize(end - start);
	
	monster_fire_rocket (start, dir, 50);
};

void() TankMachineGun={
	local vector start;
	local vector end;
	local vector dir;
	local vector vec;
	local vector org_offset;
	local float flashId;

	//MZ2_TANK_MACHINEGUN_1 = 4
	flashId = self.frame - $FRAME_attak406;
	org_offset = MZ2_TANK_MACHINEGUN[flashId];
	
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
	if (self.frame <= $FRAME_attak415)
		dir_y = self.angles_y - (8 * (self.frame - $FRAME_attak411));
	else
		dir_y = self.angles_y + (8 * (self.frame - $FRAME_attak419));
	dir_z = 0;
	dir_y = anglemod(dir_y);
	
	makevectors(dir);
	vec = start + (v_forward * vlen(self.enemy.origin - self.origin));
	
	monster_fire_bullet (start, normalize(vec - start), '0.025 0.01 0', 4);
};

framer($FRAME_attak101, $FRAME_attak116, tank_move_attack_blast, tank_reattack_blaster, 0.1, 
	ai_rep($FRAME_attak101, ai_charge, 0,0,0,0,-1,-2,-1,-1);
	ai_rep($FRAME_attak109, ai_charge, 0,0,0,0,0,0,0,0);
	frame_arb($FRAME_attak110, TankBlaster(););
	frame_arb($FRAME_attak113, TankBlaster(););
	frame_arb($FRAME_attak116, TankBlaster(););
);

framer($FRAME_attak111, $FRAME_attak116, tank_move_reattack_blast, tank_reattack_blaster, 0.1,
	ai_charge(0);
	frame_arb($FRAME_attak113, TankBlaster(););
	frame_arb($FRAME_attak116, TankBlaster(););
);

framer($FRAME_attak117, $FRAME_attak122, tank_move_attack_post_blast, tank_run, 0.1, 
	ai_rep($FRAME_attak117, ai_charge, 0,0,2,3,2,-2,-6,-6);
	frame_arb($FRAME_attak122, tank_footstep(););
);

void () tank_reattack_blaster ={
	if (skill >= 2)
		if (visible (self.enemy))
			if (self.enemy.health > 0)
				if (random() <= 0.6)
				{
					tank_move_reattack_blast();
					return;
				}
	tank_move_attack_post_blast();
};

void() tank_poststrike ={
	self.enemy = world;
	tank_run ();
};

framer($FRAME_attak201, $FRAME_attak238, tank_move_attack_strike, tank_poststrike, 0.1,
	ai_rep($FRAME_attak201, ai_charge, 3,2,2,1,6,7,9,2);
	frame_arb($FRAME_attak207, tank_footstep(););
	
	ai_rep($FRAME_attak209, ai_charge, 1,2,2,2,0,0,0,0);
	frame_arb($FRAME_attak211, tank_footstep(););
	
	ai_rep($FRAME_attak217, ai_charge, -2,-2,0,0,0,0,0,0);
	frame_arb($FRAME_attak219, tank_windup(););
	
	ai_rep($FRAME_attak225, ai_charge, 0,0,0,-1,-1,-1,-1,-1);
	frame_arb($FRAME_attak226, TankStrike(););

	ai_rep($FRAME_attak233, ai_charge, -3,-10,-10,-2,-3,-2, -6,-6);
	frame_arb($FRAME_attak238, tank_footstep(););
);

framer($FRAME_attak301, $FRAME_attak321, tank_move_attack_pre_rocket, tank_doattack_rocket, 0.1, 
	ai_rep($FRAME_attak301, ai_charge, 0,0,0,0,0,0,0,0);
	
	ai_rep($FRAME_attak309, ai_charge, 0,0,0,1,2,7,7,7);
	
	ai_rep($FRAME_attak309, ai_charge, 0,0,0,0,-3,-6,-6,-6);
	
	frame_arb($FRAME_attak316, tank_footstep(););
);

framer($FRAME_attak322, $FRAME_attak330, tank_move_attack_fire_rocket, tank_refire_rocket, 0.1, 
	frame_arb($FRAME_attak322, ai_charge(-3););
	
	ai_rep($FRAME_attak323, ai_charge, 0,0,0,0,0,0,0,0);
	
	frametwo_arb($FRAME_attak324, $FRAME_attak327, TankRocket(););
	
	frame_arb($FRAME_attak330, ai_charge(-1); TankRocket(););
);

framer($FRAME_attak331, $FRAME_attak353, tank_move_attack_post_rocket, tank_run, 0.1, 
	ai_rep($FRAME_attak331, ai_charge, 0,-1,-1,0,2,3,4,2);
	
	ai_rep($FRAME_attak339, ai_charge, 0,0,0,-9,-8,-7,-1,-1);
	frame_arb($FRAME_attak346, tank_footstep(););
	
	ai_rep($FRAME_attak339, ai_charge, 0,0,0,0,0,0,0,0);
);

framer($FRAME_attak401, $FRAME_attak429, tank_move_attack_chain, tank_run, 0.1, 
	ai_rep($FRAME_attak401, ai_charge, 0,0,0,0,0,-6,-6,-6);
	
	framerange_arb($FRAME_attak406, $FRAME_attak424, TankMachineGun(););
	
	framerange_arb($FRAME_attak425, $FRAME_attak429, ai_charge(0););
);

void() tank_refire_rocket ={
	// Only on hard or nightmare
	if ( skill >= 2 )
		if (self.enemy.health > 0)
			if (visible(self.enemy) )
				if (random() <= 0.4)
				{
					tank_move_attack_fire_rocket();
					return;
				}
	tank_move_attack_post_rocket();
};

void() tank_doattack_rocket={
	tank_move_attack_fire_rocket();
};

void() tank_attack ={
	local vector vec;
	local float range;
	local float r;
	
	if (self.enemy.health < 0)
	{
		tank_move_attack_strike();
		//self->monsterinfo.aiflags &= ~AI_BRUTAL;
		return;
	}
	
	range = vlen(self.enemy.origin - self.origin);
	r = random();

	if (range <= 125)
	{
		if (r < 0.4)
			tank_move_attack_chain();
		else 
			tank_move_attack_blast();
	}
	else if (range <= 250)
	{
		if (r < 0.5)
			tank_move_attack_chain();
		else
			tank_move_attack_blast();
	}
	else
	{
		if (r < 0.33)
			tank_move_attack_chain();
		else if (r < 0.66)
		{
			tank_move_attack_pre_rocket();
			self.pain_finished = time + 5.0;	// no pain for a while
		}
		else
			tank_move_attack_blast();
	}
};

//DEATH
void() tank_dead={
	setsize(self, '-16 -16 -16', '16 16 -0');
	setorigin(self, self.origin);
	
	self.movetype = MOVETYPE_TOSS;
	//self->svflags |= SVF_DEADMONSTER;
	self.nextthink = 0;
};

framer($FRAME_death101, $FRAME_death132, tank_move_death, tank_dead, 0.1, 
	ai_rep($FRAME_death101, ai_charge, -7,-2,-2,1,3,6,1,1);
	
	ai_rep($FRAME_death109, ai_charge, 2,0,0,0,-2,0,0,-3);
	
	ai_rep($FRAME_death117, ai_charge, 0,0,0,0,0,0,-4,-5);	//-5 originally -6 but -6 is no-Op
	
	ai_rep($FRAME_death125, ai_charge, -4,-5,-7,-15,-5,0,0,0);
	frame_arb($FRAME_death125, tank_thud(););
);


void() tank_die={

// check for gib
	/*if (self.health <= self->gib_health)
	{
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
		for (n= 0; n < 1; n++)	//4
			ThrowGib (self, "models/objects/gibs/sm_meat/tris.md2", damage, GIB_ORGANIC);
		for (n= 0; n < 4; n++)
			ThrowGib (self, "models/objects/gibs/sm_metal/tris.md2", damage, GIB_METALLIC);
		ThrowGib (self, "models/objects/gibs/chest/tris.md2", damage, GIB_ORGANIC);
		ThrowHead (self, "models/objects/gibs/gear/tris.md2", damage, GIB_METALLIC);
		self.deadflag = DEAD_DEAD;
		return;
	}*/

	if (self.deadflag == DEAD_DEAD)
		return;

// regular death
	sound (self, CHAN_VOICE, TANK_SOUND_DIE, 1, ATTN_NORM);
	self.deadflag = DEAD_DEAD;
	self.takedamage = DAMAGE_YES;

	tank_move_death();
}

/*QUAKED monster_tank (1 .5 0) (-32 -32 -16) (32 32 72) Ambush Trigger_Spawn Sight
*/
/*QUAKED monster_tank_commander (1 .5 0) (-32 -32 -16) (32 32 72) Ambush Trigger_Spawn Sight
*/
void() monster_tank={
	
	if(deathmatch){
		remove(self);
		return;
	}
	
	precache_model("models/monsters/tank/tris.md2");
	
	precache_sound (TANK_SOUND_PAIN);
	precache_sound (TANK_SOUND_THUD);
	precache_sound (TANK_SOUND_IDLE);
	precache_sound (TANK_SOUND_DIE);
	precache_sound (TANK_SOUND_STEP);
	precache_sound (TANK_SOUND_WINDUP);
	precache_sound (TANK_SOUND_STRIKE);
	precache_sound (TANK_SOUND_SIGHT);
	
	precache_sound ("tank/tnkatck1.wav");
	precache_sound ("tank/tnkatk2a.wav");
	precache_sound ("tank/tnkatk2b.wav");
	precache_sound ("tank/tnkatk2c.wav");
	precache_sound ("tank/tnkatk2d.wav");
	precache_sound ("tank/tnkatk2e.wav");
	precache_sound ("tank/tnkatck3.wav");
	
	self.solid = SOLID_BBOX;
	self.movetype = MOVETYPE_STEP;
	
	setmodel(self, "models/monsters/tank/tris.md2");
	
	setsize(self, '-32 -32 -16', '32 32 72');
	
	if (strcmp(self.classname, "monster_tank_commander") == 0){
		self.health = 1000;
		//self->gib_health = -225;
	}
	else{
		self.health = 750;
		//self->gib_health = -200;
	}
	self.max_health = self.health;
	
	self.th_stand = tank_stand;
	self.th_walk = tank_walk;
	self.th_run = tank_run;
	self.th_missile = tank_attack;
	self.th_die = tank_die;
	self.th_pain = tank_pain;
	
	//grumble grumble giant offset arrays for special effects
	if(!INI_TANK_DATA){
		INI_TANK_DATA = TRUE;
		MZ2_TANK_MACHINEGUN[0] = '22.9 -0.7 25.3';
		MZ2_TANK_MACHINEGUN[1] = '22.9 -0.7 25.3';
		MZ2_TANK_MACHINEGUN[2] = '22.2 6.2 22.3';
		MZ2_TANK_MACHINEGUN[3] = '19.4 13.1 18.6';
		MZ2_TANK_MACHINEGUN[4] = '19.4 18.8 18.6';
		MZ2_TANK_MACHINEGUN[5] = '17.9 25.0 18.6';
		MZ2_TANK_MACHINEGUN[6] = '14.1 30.5 20.6';
		MZ2_TANK_MACHINEGUN[7] = '9.3 35.3 22.1';
		MZ2_TANK_MACHINEGUN[8] = '4.7 38.4 22.1';
		MZ2_TANK_MACHINEGUN[9] = '-1.1 40.4 24.1';
		MZ2_TANK_MACHINEGUN[10] = '-6.5 41.2 24.1';
		MZ2_TANK_MACHINEGUN[11] = '3.2 40.1 24.7';
		MZ2_TANK_MACHINEGUN[12] = '11.7 36.7 26.0';
		MZ2_TANK_MACHINEGUN[13] = '18.9 31.3 26.0';
		MZ2_TANK_MACHINEGUN[14] = '24.4 24.4 26.4';
		MZ2_TANK_MACHINEGUN[15] = '27.1 17.1 27.2';
		MZ2_TANK_MACHINEGUN[16] = '28.5 9.1 28.0';
		MZ2_TANK_MACHINEGUN[17] = '27.1 2.2 28.0';
		MZ2_TANK_MACHINEGUN[18] = '24.9 -2.8 28.0';
		MZ2_TANK_MACHINEGUN[19] = '21.6 -7.0 26.4';
	}
	
	walkmonster_start;
};