/*
==============================================================================

QUAKE II STROGG SOLDIERS

monster_soldier_light
monster_soldier
monster_soldier_ss
monster_soldier_flak

==============================================================================
*/

#include "monsterq2_soldier.qh"

void() q2soldier_fire;
void() q2soldier_death1fire;
void() q2soldier_selectwalk;
void() q2soldier_select_stand;

/*

STAND1

*/

void() q2soldier_idle_sound =
{
	if (random() > 0.8)
		sound (self, CHAN_VOICE, "soldier/solidle1.wav", 1, ATTN_IDLE);
}

void() q2soldier_cock_sound =
{
	if (self.frame == $stand322)
		sound (self, CHAN_WEAPON, "infantry/infatck3.wav", 1, ATTN_IDLE);
	else
		sound (self, CHAN_WEAPON, "infantry/infatck3.wav", 1, ATTN_IDLE);
}

// STAND 1

framer($stand101, $stand130, q2soldier_frames_stand, q2soldier_select_stand, 0.1,
	frame_arb($stand101, q2soldier_idle_sound(););
	ai_stand();
);


/*

STAND FIDGET

*/

// STAND 2

framer($stand301, $stand339, q2soldier_stand_fidget, q2soldier_select_stand, 0.1,
	frame_arb($stand322, q2soldier_cock_sound(););
	ai_stand();
);

/*
STAND SELECTOR

Chooses between regular idle and randomly playing a fidget animation

*/

void()	q2soldier_select_stand =
{
	if (self.health <= 0)
		return;
	
	if (random() > 0.1)
	{
		q2soldier_frames_stand ();
		return;
	}
	else
	{
		q2soldier_stand_fidget ();
		return;
	}
};

// WALK 1

framerloop($walk101, $walk133, q2soldier_1walk1, 0.1,

	frame_arb($walk133, q2soldier_selectwalk(););
//	frame_arb($walk104, footsetp(););
//	frame_arb($walk109, footstep(););
	frame_arb($walk104,
//	footsetp();	
	if (self.bIsWounded && self.bleedcount < MAX_BLEED)
	{
		local	vector	org;
		org = self.origin + '0 0 24';
		SpawnBlood (org, '0 0 0', 5);
		self.bleedcount++;
	}
	);

	ai_rep($walk101, ai_walk, 3, 6, 3, 2, 2, 2, 1, 6);
	ai_rep($walk109, ai_walk, 5, 3, -1, 0, 0, 0, 0, 0);
	ai_rep($walk117, ai_walk, 0, 0, 0, 0, 0, 0, 0, 0);
	ai_rep($walk125, ai_walk, 0, 0, 0, 0, 0, 0, 0, 0);
);

// WALK 2

framerloop($walk209, $walk218, q2soldier_2walk1, 0.1,

	frame_arb($walk218, q2soldier_selectwalk(););
//	frame_arb($walk210, footsetp(););
//	frame_arb($walk214, footstep(););

	ai_rep($walk209, ai_walk, 4, 4, 9, 8, 5, 1, 3, 7);
	ai_rep($walk217, ai_walk, 6, 7, 0, 0, 0, 0, 0, 0);
);

// RUN

framerloop($run03, $run08, q2soldier_run1, getSpeedByClassname(),

//	frame_arb($run04, footsetp(););
//	frame_arb($run08, footstep(););

	frame_arb($run04, 
//	footstep();
	if (self.bIsWounded && self.bleedcount < MAX_BLEED)
	{
		local	vector	org;
		org = self.origin + '0 0 24';
		SpawnBlood (org, '0 0 0', 5);
		self.bleedcount++;
	}
	);
	ai_rep($run03, ai_run, 10, 11, 11, 16, 10, 15, 0, 0);
);

// ATTACK

framer($attak101, $attak112, q2soldier_atk1, q2soldier_run1, 0.1, ai_face();
	
	frame_arb($attak103,
		q2soldier_fire();
		self.effects = self.effects | EF_MUZZLEFLASH;
	);
	
	frame_arb($attak106,
		SUB_CheckRefire (q2soldier_atk1);
	);
	
	frame_arb($attak108,
		sound (self, CHAN_VOICE, "soldier/Solatck3.wav", 1, ATTN_IDLE);
	);
);

framer($attak201, $attak218, q2soldier_atk2, q2soldier_run1, 0.1, ai_face();
	
	frame_arb($attak205,
		q2soldier_fire();
		self.effects = self.effects | EF_MUZZLEFLASH;
	);
	
	frame_arb($attak208,
		SUB_CheckRefire (q2soldier_atk2);
	);
	
	frame_arb($attak211,
		sound (self, CHAN_VOICE, "infantry/infatck3.wav", 1, ATTN_IDLE);
	);
);

framer($attak201, $attak218, q2soldier_atk3, q2soldier_run1, 0.1, ai_face();
	
	frame_arb($attak205,
		q2soldier_fire();
		self.effects = self.effects | EF_MUZZLEFLASH;
	);
	
	frame_arb($attak208,
		SUB_CheckRefire (q2soldier_atk3);
	);
	
	frame_arb($attak211,
		sound (self, CHAN_VOICE, "infantry/infatck3.wav", 1, ATTN_IDLE);
	);
);

// PAIN1

framer($pain101, $pain105, q2soldier_pain1, q2soldier_run1, 0.1, 
	
	frame_arb($pain101,
		local	vector	org;
		org = self.origin + '0 0 24';
		SpawnBlood (org, '0 0 0', 20);
	);
	
	frame_arb($pain105,
		ai_pain(1);
	);
);

// PAIN2

framer($pain201, $pain207, q2soldier_painb1, q2soldier_run1, 0.1, 
	
	frame_arb($pain201,
		local	vector	org;
		org = self.origin + '0 0 24';
		SpawnBlood (org, '0 0 0', 20);
	);
);

// PAIN3

framer($pain301, $pain318, q2soldier_pain3, q2soldier_run1, 0.1, 
	
	frame_arb($pain201,
		local	vector	org;
		org = self.origin + '0 0 24';
		SpawnBlood (org, '0 0 0', 20);
	);
);

// PAIN4

framer($pain401, $pain417, q2soldier_pain4, q2soldier_run1, 0.1, 
	
	frame_arb($pain201,
		local	vector	org;
		org = self.origin + '0 0 24';
		SpawnBlood (org, '0 0 0', 20);
	);
);

void() q2Soldier_Random_Pain_Sound =
{
	local float r = random() * 3;
	
	if (r < 1) 
	{ 
		sound(self, CHAN_VOICE, "soldier/solpain1.wav", 1, ATTN_NORM);
	}
	else if (r < 2)
	{
		 sound(self, CHAN_VOICE, "soldier/solpain2.wav", 1, ATTN_NORM);
	}
	else
	{ 			
		sound(self, CHAN_VOICE, "soldier/solpain3.wav", 1, ATTN_NORM);
	}
}

void(entity attacker, float damage)	q2soldier_pain =
{
	local float r;

	//SKIN 0 = Red, Laser monster_soldier_light
	//SKIN 2 = Shotgun monster_soldier
	//SKIN 4 = Chaingun monster_soldier_ss
	//SKIN 6 = flak 
	local	vector	org;
	org = self.origin + '0 0 24';
	SpawnBlood (org, '0 0 0', 30);
	
	/*
	if (self.skin == 4 && self.classname == "monster_soldier_ss") //machinegun soldier
	{
		self.skin = 5;
	}
	else if (self.skin == 2 && self.classname == "monster_soldier") //shogun soldier
	{
		self.skin = 3;
	}
	else if (self.skin == 6 && self.classname == "monster_soldier_flak") //shogun soldier
	{
		self.skin = 7;
	}
	else if (self.skin == 0 && self.classname == "monster_soldier_light") //laser soldier
	{
		self.skin = 1; 
	}
	*/

	if (self.health < (self.max_health / 2))
		setWounded(self);
	
	if (self.pain_finished > time)
		return;

	r = random();

	if (r < 0.2)
	{
		self.pain_finished = time + 1.6;
		q2soldier_pain1 ();
	//	sound (self, CHAN_VOICE, "soldier/solpain1.wav", 1, ATTN_NORM);
		q2Soldier_Random_Pain_Sound();
	}
	else if (r < 0.4)
	{
		self.pain_finished = time + 1.5;
		q2soldier_painb1 ();
	//	sound (self, CHAN_VOICE, "soldier/solpain2.wav", 1, ATTN_NORM);
		q2Soldier_Random_Pain_Sound();
	}
	else if (r < 0.6)
	{
		self.pain_finished = time + 1.8;
		q2soldier_pain3 ();
	//	sound (self, CHAN_VOICE, "soldier/solpain3.wav", 1, ATTN_NORM);
		q2Soldier_Random_Pain_Sound();
	}
	else
	{
		self.pain_finished = time + 1.7;
		q2soldier_pain4 ();
	//	sound (self, CHAN_VOICE, "soldier/solpain3.wav", 1, ATTN_NORM);
		q2Soldier_Random_Pain_Sound();
	}
};

void() q2soldier_fire =
{
	local	vector	dir;
	local	entity	en;
	local vector org;
	
//	if (!visible (self.enemy))
//	return;
	
	ai_face();
  makevectors(self.angles);

// fire somewhat behind the player, so a dodging player is harder to hit
	en = self.enemy;

	dir = en.origin - en.velocity*0.2;
	dir = normalize (dir - self.origin);

	org = self.origin + v_forward * 30 + v_right * -8.5 + '0 0 16';

	if (self.classname == "monster_soldier")
	{
		sound (self, CHAN_WEAPON, "soldier/Solatck1.wav", 1, ATTN_NORM);
		monster_fire_shotgun(8, org, dir, autocvar_sk_q2soldier_shotgun_accuracy, autocvar_sk_q2soldier_shotgun_damage);
	}
	else if (self.classname == "monster_soldier_ss")
	{
		sound (self, CHAN_WEAPON, "soldier/Solatck3.wav", 1, ATTN_NORM);
		monster_fire_bullet(org, dir, '0.01 0.01 0', autocvar_sk_q2soldier_mg_damage);
	}
	else if (self.classname == "monster_soldier_flak"){
		sound (self, CHAN_WEAPON, "soldier/Solatck1.wav", 1, ATTN_NORM);
		monster_fire_flechette(4, org, self.enemy.origin - self.origin, '0.05 0.06', autocvar_sk_q2soldier_flak_damage);
	}
	else
	{
		sound (self, CHAN_WEAPON, "soldier/Solatck2.wav", 1, ATTN_NORM);		
		monster_fire_blaster(org, self.enemy.origin - self.origin, autocvar_sk_q2soldier_light_damage, '2 0.2 0.2', MF_TRACER2);
	}
};

/*

LOOP soldier_ss machine gun for 10 shots

*/


framer($attak404, $attak406, q2soldier_frames_endattack, q2soldier_run1, 0.135,);

framerloop($attak402, $attak403, q2solder_frames_holdattack, 0.05,
	frame_arb($attak402,
	if (self.shotcount >= 10 || (!visible (self.enemy))){
		self.shotcount = 0;
	q2soldier_frames_endattack();
	}
	else
	{
		self.shotcount++;
	}
	);
	frame_arb($attak403, q2soldier_fire(););

	ai_face();
);

void() q2soldier_select_attack =
{
	if (self.classname == "monster_soldier")
	{
		q2soldier_atk2();

	}
	else if (self.classname == "monster_soldier_ss")
	{
		q2solder_frames_holdattack();
	}
  else if (self.classname == "monster_soldier_flak"){
    q2soldier_atk3();
  }
	else
	{
		q2soldier_atk1();
	}
};

void() q2soldier_death1fire =
{
	local vector dir;
	local vector org;

//	if (!visible (self.enemy))
//	return;

	makevectors (self.angles);

	dir = self.origin - v_forward*1000;
	
	org = self.origin + v_forward * 30 + v_right * 4 + '0 0 8';
	dir = normalize (org - self.origin);
	
	if (self.classname == "monster_soldier_ss")
	{
		org = self.origin + v_forward * 30 + v_right * 0 + '0 0 0';
		dir = normalize (org - self.origin);

		sound (self, CHAN_WEAPON, "soldier/Solatck3.wav", 1, ATTN_NORM);
		monster_fire_bullet(org, dir, '0.01 0.01 0', autocvar_sk_q2soldier_mg_damage);

	}
	else if (self.classname == "monster_soldier")
	{
		org = self.origin + v_forward + v_right * 0 + '0 0 0';
		dir = normalize (org - self.origin);

		sound (self, CHAN_WEAPON, "soldier/Solatck1.wav", 1, ATTN_NORM);
		monster_fire_shotgun(8, org, dir, '0.1 0.1 0', autocvar_sk_q2soldier_shotgun_damage);		
	}
	else if (self.classname == "monster_soldier_flak"){
		sound (self, CHAN_WEAPON, "soldier/Solatck1.wav", 1, ATTN_NORM);
		monster_fire_flechette(2, org, self.enemy.origin - self.origin, '0.05 0.06', autocvar_sk_q2soldier_flak_damage);
	}
	else
	{
		sound (self, CHAN_WEAPON, "soldier/Solatck2.wav", 1, ATTN_NORM);
		monster_fire_blaster(org, v_forward * 2000, autocvar_sk_q2soldier_light_damage, '2 0.2 0.2', MF_TRACER2);
	}
};

void() q2soldier_dead =
{
	setsize (self, '-16 -16 -24', '16 16 -8');
	self.movetype = MOVETYPE_TOSS;
	self.solid = SOLID_CORPSE;
}

// DEATH1

framer($death101, $death136, q2soldier_die1, SUB_Null, 0.1,
	
	frame_arb($death101,

		q2soldier_dead();
	);
	
		frame_arb($death122,
		q2soldier_death1fire();
	);
	
		frame_arb($death126,
		q2soldier_death1fire();
	);
);


// DEATH2

framer($death201, $death235, q2soldier_die2, SUB_Null, 0.1,
	
	frame_arb($death201,

		q2soldier_dead();
	);
);

// DEATH3

framer($death301, $death345, q2soldier_die3, SUB_Null, 0.1,
	
	frame_arb($death301, q2soldier_dead(););
);

// DEATH 4

framer($death401, $death453, q2soldier_die4, SUB_Null, 0.1,
	
	frame_arb($death401,

		q2soldier_dead();
	);
);

// DEATH 5

framer($death501, $death524, q2soldier_die5, SUB_Null, 0.1,
	
	frame_arb($death501,

		q2soldier_dead();
	);
);

// DEATH 6

framer($death601, $death610, q2soldier_die6, SUB_Null, 0.1,
	
	frame_arb($death601,

		q2soldier_dead();
	);
);

void() q2soldier_die =
{
	local float r;

 	if (self.health < -35)
	{
		gibMonster();
		remove(self);
		return;
	}

	self.takedamage = DAMAGE_YES;

 	if (self.deadflag == DEAD_DEAD)//{
		return;
//	}
//	else
//	{
	
	// regular death
	sound (self, CHAN_VOICE, "soldier/soldeth2.wav", 1, ATTN_NORM);
	self.deadflag = DEAD_DEAD;
	
	if (self.classname == "monster_soldier_light")
		DropLoot(LOOT_ARMOR_SHARD, 0, self.origin); //LOOT_ARMOR_SHARD defaults to 2 through special handling.
	if (self.classname == "monster_soldier_ss")
		DropLoot(LOOT_BULLETS, floor(random()*6)+1, self.origin);
	if (self.classname == "monster_soldier")
		DropLoot(LOOT_SHELLS, floor(random()*8)+1, self.origin);
	
	r = random() * 6;
	if (r < 1) q2soldier_die1 ();
	else if (r < 2) q2soldier_die2 ();
	else if (r < 3) q2soldier_die3 ();
	else if (r < 4) q2soldier_die4 ();
	else if (r < 5) q2soldier_die5 ();
	else            q2soldier_die6 ();
//	}
};

void()	q2soldier_selectwalk =
{
	local float r;

	r = random();

	if (r < 0.1)
	{
		q2soldier_1walk1 ();
	}
	else
	{
		q2soldier_2walk1 ();
	}
};

/*QUAKED monsterqc_soldier (1 0 0) (-16 -16 -24) (16 16 40) Ambush
*/
//SKIN 0 = Red, Laser monster_soldier_light
//SKIN 2 = Shotgun monster_soldier
//SKIN 4 = Chaingun monster_soldier_ss

/*QUAKED monster_soldier_light (1 .5 0) (-16 -16 -24) (16 16 32) Ambush Trigger_Spawn Sight
*/

void() precache_soldier =
{
	precache_model ("models/monsters/soldier/tris.md2");
	precache_sound ("soldier/Solatck1.wav");
	precache_sound ("soldier/Solatck2.wav");
	precache_sound ("soldier/Solatck3.wav");
	precache_sound ("soldier/soldeth1.wav");
	precache_sound ("soldier/soldeth2.wav");
	precache_sound ("soldier/soldeth3.wav");
	precache_sound ("soldier/solidle1.wav");
	precache_sound ("soldier/solpain1.wav");
	precache_sound ("soldier/solpain2.wav");
	precache_sound ("soldier/solpain3.wav");
	precache_sound ("soldier/solsght1.wav");
	precache_sound ("soldier/solsrch1.wav");
	precache_sound ("infantry/infatck3.wav");	
}

void () monster_soldier_light =
{
	self.classname = "monster_soldier_light";
	if (deathmatch)
	{
		remove(self);
		return;
	}

	precache_soldier();
	
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "models/monsters/soldier/tris.md2");

	setsize (self, '-16 -16 -24', '16 16 32');
	self.health = autocvar_sk_q2soldier_light_health;
	self.max_health = self.health;

	self.th_stand = q2soldier_select_stand;
	self.th_walk = q2soldier_selectwalk; //q2soldier_2walk1;
	self.th_run = q2soldier_run1;
	self.th_missile = q2soldier_select_attack; //q2soldier_atk1;
	self.th_pain = q2soldier_pain;
	self.th_die = q2soldier_die;

	self.sightSound = "soldier/solsght1.wav";
	self.skin = 0; //laser
	walkmonster_start;
}

/*QUAKED monster_soldier (1 .5 0) (-16 -16 -24) (16 16 32) Ambush Trigger_Spawn Sight
*/
void () monster_soldier =
{
	self.classname = "monster_soldier";
	if (deathmatch)
	{
		remove(self);
		return;
	}

	precache_soldier();

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "models/monsters/soldier/tris.md2");

	setsize (self, '-16 -16 -24', '16 16 32');
	self.health = autocvar_sk_q2soldier_shotgun_health;
	self.max_health = self.health;

	self.th_stand = q2soldier_select_stand;
	self.th_walk = q2soldier_selectwalk; //q2soldier_2walk1;
	self.th_run = q2soldier_run1;
	self.th_missile = q2soldier_select_attack; //q2soldier_atk1;
	self.th_pain = q2soldier_pain;
	self.th_die = q2soldier_die;

	self.sightSound = "soldier/solsght1.wav";
	self.skin = 2; //shotgun
	
	walkmonster_start;
}

/*QUAKED monster_soldier_ss (1 .5 0) (-16 -16 -24) (16 16 32) Ambush Trigger_Spawn Sight
*/
void () monster_soldier_ss =
{
	self.classname = "monster_soldier_ss";
	if (deathmatch)
	{
		remove(self);
		return;
	}
	
	precache_soldier();
	
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "models/monsters/soldier/tris.md2");

	setsize (self, '-16 -16 -24', '16 16 32');
	self.health = autocvar_sk_q2soldier_mg_health;
	self.max_health = self.health;

	self.th_stand = q2soldier_select_stand;
	self.th_walk = q2soldier_selectwalk; //q2soldier_2walk1;
	self.th_run = q2soldier_run1;
	self.th_missile = q2soldier_select_attack; //q2soldier_atk1;
	self.th_pain = q2soldier_pain;
	self.th_die = q2soldier_die;

	self.sightSound = "soldier/solsght1.wav";

	walkmonster_start;

	self.skin = 4; //machinegun
}

/*QUAKED monster_soldier_flak (1 .5 0) (-16 -16 -24) (16 16 32) Ambush Trigger_Spawn Sight
*/
void () monster_soldier_flak =
{
	self.classname = "monster_soldier_flak";
	if (deathmatch)
	{
		remove(self);
		return;
	}
	
	precache_soldier();
	
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "models/monsters/soldier/tris.md2");

	setsize (self, '-16 -16 -24', '16 16 32');
	self.health = autocvar_sk_q2soldier_flak_health;
	self.max_health = self.health;

	self.th_stand = q2soldier_select_stand;
	self.th_walk = q2soldier_selectwalk; //q2soldier_2walk1;
	self.th_run = q2soldier_run1;
	self.th_missile = q2soldier_select_attack; //q2soldier_atk1;
	self.th_pain = q2soldier_pain;
	self.th_die = q2soldier_die;

	self.sightSound = "soldier/solsght1.wav";

	walkmonster_start;

	self.skin = 6; //machinegun
}

//these should be server cvars, play through a q1 map and decide how much q2 you want in 
//there by percentage q1_strogg_monster_replacement_chance (or something shorter)

#ifdef q2monster_replace_soldier
void() monster_army =
{
	local float r;
	
		r = random() * 2;
		if (r < 1) monster_soldier_light ();
		else if (r < 2) monster_soldier ();
		else            monster_soldier_ss ();
};
#endif
