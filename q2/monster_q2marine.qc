/*
==============================================================================

A friendly marine companion

==============================================================================
*/
#include "q2_player.qh"

//STAND

framerloop($FRAME_stand01, $FRAME_stand40, q2marine_stand, 0.1,
	frame_arb($FRAME_stand25,player_chatter_idle();
	);
ai_stand();
);

//RUN

framerloop($FRAME_run1, $FRAME_run6, q2marine_run, 0.1,
	ai_rep($FRAME_run1, ai_run, 20, 20, 20, 20, 20, 20, 0, 0);
);

//WALK

framerloop($FRAME_run1, $FRAME_run6, q2marine_walk, 0.1,
	ai_rep($FRAME_run1, ai_walk, 20, 20, 20, 20, 20, 20, 0, 0);
);

//TAUNT FLIP
framer($FRAME_flip01, $FRAME_flip12, q2marine_flip, q2marine_run, 0.1,

	frame_arb($FRAME_flip01,
	);
);

//TAUNT SALUTE
framer($FRAME_salute01, $FRAME_salute11, q2marine_salute, q2marine_run, 0.1,

	frame_arb($FRAME_salute01,
	);
);

//TAUNT
framer($FRAME_taunt01, $FRAME_taunt17, q2marine_taunt, q2marine_run, 0.1,

	frame_arb($FRAME_taunt01,
	);
);

//WAVE
framer($FRAME_wave01, $FRAME_wave11, q2marine_wave, q2marine_run, 0.1,

	frame_arb($FRAME_wave01,
	);
);


//POINT
framer($FRAME_point01, $FRAME_point12, q2marine_point, q2marine_run, 0.1,

	frame_arb($FRAME_point01,
	);
);

void() q2marine_fireweapon =
{
	local	vector	dir, end;
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

	if (self.inv_weapons & WEP_BLASTER){
		sound (self, CHAN_WEAPON, "soldier/Solatck2.wav", 1, ATTN_NORM);		
		monster_fire_blaster(org, self.enemy.origin - self.origin, autocvar_sk_q2soldier_light_damage, '2 0.2 0.2', MF_TRACER2);		
	}

	if (self.inv_weapons & WEP_SHOTGUN){
		sound (self, CHAN_WEAPON, "soldier/Solatck1.wav", 1, ATTN_NORM);
		monster_fire_shotgun(8, org, dir, autocvar_sk_q2soldier_shotgun_accuracy, autocvar_sk_q2soldier_shotgun_damage);
	}

	if (self.inv_weapons & WEP_SUPERSHOTGUN){
		sound (self, CHAN_WEAPON, "soldier/Solatck1.wav", 1, ATTN_NORM);
		monster_fire_shotgun(8, org, dir, autocvar_sk_q2soldier_shotgun_accuracy, autocvar_sk_q2soldier_shotgun_damage);
	}
	
	if (self.inv_weapons & WEP_MACHINEGUN){
		sound (self, CHAN_WEAPON, "soldier/Solatck3.wav", 1, ATTN_NORM);
		monster_fire_bullet(org, dir, '0.01 0.01 0', autocvar_sk_q2soldier_mg_damage);
	}
	
	if (self.inv_weapons & WEP_CHAINGUN){
		sound (self, CHAN_WEAPON, "soldier/Solatck3.wav", 1, ATTN_NORM);
		monster_fire_bullet(org, dir, '0.01 0.01 0', autocvar_sk_q2soldier_mg_damage);
	}

	if (self.inv_weapons & WEP_GRENADE_LAUNCHER){
		monster_fire_grenade (org, '300 300 300', autocvar_sk_q2gunner_grenade_damage, 600);		
	}
	
	if (self.inv_weapons & WEP_ROCKET_LAUNCHER){
		sound(self, CHAN_AUTO, "weapons/ROCKLF1A.wav", 1, ATTN_NORM);		
		monster_fire_rocket(org, dir, 50);
	}
	
	if (self.inv_weapons & WEP_HYPERBLASTER){
		sound (self, CHAN_WEAPON, "soldier/Solatck2.wav", 1, ATTN_NORM);		
		monster_fire_blaster(org, self.enemy.origin - self.origin, autocvar_sk_q2soldier_light_damage, '2 0.2 0.2', MF_TRACER2);		
	}

	if (self.inv_weapons & WEP_RAILGUN){
		
		end = self.enemy.origin - self.enemy.velocity*0.05;
		end_z = end_z + self.enemy.view_ofs_z - self.enemy.velocity*0.05;
		
		sound (self, CHAN_WEAPON, "weapons/RAILGF1A.WAV", 1, ATTN_NORM);
		monster_fire_railgun(org, end, 20);
	}
	
	if (self.inv_weapons & WEP_BFG){
		monster_fire_bfg(org, dir, 50);
	}	
};

/*

LOOP machine gun for 10 shots

*/


framer($FRAME_attack5, $FRAME_attack8, q2marine_frames_endattack, q2marine_run, 0.135,);

framerloop($FRAME_attack1, $FRAME_attack2, q2marine_frames_holdattack, 0.05,
	frame_arb($FRAME_attack1,
	if (self.shotcount >= 10 || (!visible (self.enemy))){
		self.shotcount = 0;
	
	q2soldier_frames_endattack();
	}
	else
	{
		self.shotcount++;
	}
	);
	
	frame_arb($FRAME_attack2, q2marine_fireweapon(););

	ai_face();
);

//STAND attack 8 frames
framer($FRAME_attack1, $FRAME_attack8, q2marine_attack, q2marine_run, 0.1,

	frame_arb($FRAME_attack1,q2marine_fireweapon(););
);

void() q2marine_select_attack =
{
	if (self.inv_weapons & WEP_BLASTER)
		q2marine_attack();
	
	if (self.inv_weapons & WEP_SHOTGUN)
		q2marine_attack();
	
	if (self.inv_weapons & WEP_SUPERSHOTGUN)
		q2marine_attack();
	
	if (self.inv_weapons & WEP_MACHINEGUN)
		q2marine_frames_holdattack();
	
	if (self.inv_weapons & WEP_CHAINGUN)
		q2marine_frames_holdattack();
	
	if (self.inv_weapons & WEP_GRENADE_LAUNCHER)
		q2marine_attack();
	
	if (self.inv_weapons & WEP_ROCKET_LAUNCHER)
		q2marine_attack();
	
	if (self.inv_weapons & WEP_HYPERBLASTER)
		q2marine_frames_holdattack();
	
	if (self.inv_weapons & WEP_RAILGUN)
		q2marine_attack();
	
	if (self.inv_weapons & WEP_BFG)
		q2marine_attack();
};

void() q2marinePainSound =
{
//local float		rs;
	
	if (self.health < 0)
		return;

	if (damage_attacker.classname == "teledeath")
	{
		sound (self, CHAN_VOICE, "player/teledth1.wav", 1, ATTN_NONE);
		return;
	}

// water pain sounds
	if (self.watertype == CONTENT_WATER && self.waterlevel == 3)
	{
		//DeathBubbles(1); TODO: bubbles particle call here.
			playerVOSound(PLAYER_VOICE_GURP);
		return;
	}

// slime pain sounds
	if (self.watertype == CONTENT_SLIME)
	{
// FIX ME	put in some steam here
#ifdef opgrade
		if (self.waterlevel == 3)
			//DeathBubbles(1); TODO: slime bubbles? particle call here.
#endif

		if (random() > 0.5)
			sound (self, CHAN_VOICE, "player/lburn1.wav", 1, ATTN_NORM);
		else
			sound (self, CHAN_VOICE, "player/lburn2.wav", 1, ATTN_NORM);
		return;
	}

	if (self.watertype == CONTENT_LAVA)
	{
		if (random() > 0.5)
			sound (self, CHAN_VOICE, "player/lburn1.wav", 1, ATTN_NORM);
		else
			sound (self, CHAN_VOICE, "player/lburn2.wav", 1, ATTN_NORM);
		return;
	}

	if (self.pain_finished > time)
	{
		self.axhitme = 0;
		return;
	}
	self.pain_finished = time + 0.5;

	// ax pain sound
	if (self.axhitme == 1)
	{
		self.axhitme = 0;
		sound (self, CHAN_VOICE, "player/axhit1.wav", 1, ATTN_NORM);
		return;
	}
	
	if (self.health > 75){
		playerVOSound(PLAYER_VOICE_PAIN75);
	//		SetVModelOverlaySelf('0 0 0', "models/overlay.md3", OVERLAY_RAIN, '1 0 0', 0.1);
	}
	else if (self.health > 50){
		playerVOSound(PLAYER_VOICE_PAIN50);
	//		SetVModelOverlaySelf('0 0 0', "models/overlay.md3", OVERLAY_RAIN, '0 1 0', 0.1);
	}
	else if (self.health > 25){
		playerVOSound(PLAYER_VOICE_PAIN25);
	//		SetVModelOverlaySelf('0 0 0', "models/overlay.md3", OVERLAY_FACE, '0 1 0', 0.1);
	}
	else
	{
		playerVOSound(PLAYER_VOICE_PAIN100);
	//		SetVModelOverlaySelf('0 0 0', "models/overlay.md3", OVERLAY_RAIN, '5 1 1', 0.1);
	}
};

//STAND PAIN

framer($FRAME_pain101, $FRAME_pain104, q2marine_painFramesA, q2marine_run, 0.1,

	frame_arb($FRAME_pain101,
	q2marinePainSound();
	);
);

framer($FRAME_pain201, $FRAME_pain204, q2marine_painFramesB, q2marine_run, 0.1,

	frame_arb($FRAME_pain201,
	
	q2marinePainSound();
	);
);

framer($FRAME_pain301, $FRAME_pain304, q2marine_painFramesC, q2marine_run, 0.1,

	frame_arb($FRAME_pain301,
	
	q2marinePainSound();
	);
);

void(entity attacker, float damage) q2marine_pain =
{
	local float r;

	SpawnBlood (self.origin, '0 0 0', 30);

	if (self.pain_finished > time)
		return;
	
	r = random() * 3;
	
	if (r < 1) q2marine_painFramesA();
	else if (r < 2) q2marine_painFramesB();
	else            q2marine_painFramesC();
};

//DEATH
void() marineDead =
{
	setsize (self, '-16 -16 -24', '16 16 -8');
	self.movetype = MOVETYPE_TOSS;
	self.solid = SOLID_CORPSE;
}

framer($FRAME_death101, $FRAME_death106, q2marine_dieA, marineDead, 0.1,SUB_Null());

framer($FRAME_death201, $FRAME_death206, q2marine_dieB, marineDead, 0.1,SUB_Null());

framer($FRAME_death301, $FRAME_death308, q2marine_dieC, marineDead, 0.1,SUB_Null());

void() q2marine_die =
{
	local float r;

 	if (self.health < -35)
	{
		gibMonster();
		remove(self);
		return;
	}

	self.takedamage = DAMAGE_YES;

 	if (self.deadflag == DEAD_DEAD)
	{
		return;
	}
	else
	{
		// regular death
		playerVOSound(PLAYER_VOICE_DEATH);
		self.deadflag = DEAD_DEAD;
		
		r = random() * 3;
		if (r < 1) q2marine_dieA ();
		else if (r < 2) q2marine_dieB ();
		else            q2marine_dieC ();
		
		if (self.inv_weapons & WEP_SHOTGUN)
		{
			DropLoot(LOOT_SHOTGUN, self.inv_ammo_shells, randompos(self.absmin, self.absmax));
		}
		
		if (self.inv_weapons & WEP_SUPERSHOTGUN)
		{
			DropLoot(LOOT_SUPERSHOTGUN, self.inv_ammo_shells, randompos(self.absmin, self.absmax));
		}

		if (self.inv_weapons & WEP_MACHINEGUN)
		{
			DropLoot(LOOT_MACHINEGUN, self.inv_ammo_shells, randompos(self.absmin, self.absmax));
		}

		if (self.inv_weapons & WEP_CHAINGUN)
		{
			DropLoot(LOOT_CHAINGUN, self.inv_ammo_shells, randompos(self.absmin, self.absmax));
		}

		if (self.inv_weapons & WEP_GRENADE_LAUNCHER)
		{
			DropLoot(LOOT_GRENADE_LAUNCHER, self.inv_ammo_shells, randompos(self.absmin, self.absmax));
		}

		if (self.inv_weapons & WEP_ROCKET_LAUNCHER)
		{
			DropLoot(LOOT_ROCKET_LAUNCHER, self.inv_ammo_shells, randompos(self.absmin, self.absmax));
		}

		if (self.inv_weapons & WEP_HYPERBLASTER)
		{
			DropLoot(LOOT_HYPERBLASTER, self.inv_ammo_shells, randompos(self.absmin, self.absmax));
		}

		if (self.inv_weapons & WEP_RAILGUN)
		{
			DropLoot(LOOT_RAILGUN, self.inv_ammo_shells, randompos(self.absmin, self.absmax));
		}

		if (self.inv_weapons & WEP_BFG)
		{
			DropLoot(LOOT_BFG, self.inv_ammo_shells, randompos(self.absmin, self.absmax));
		}			
	}
};

void() precache_marine =
{
	/*
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
	*/
}

void() attachWeaponModel;

/*QUAKED monster_marine (1 .5 0) (-16 -16 -24) (16 16 32) Ambush Trigger_Spawn Sight
*/
void () monster_marine =
{
	self.classname = "monster_marine";
	if (deathmatch)
	{
		remove(self);
		return;
	}
	
	precache_marine();
	
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "players/male/tris.md2");

	setsize (self, '-16 -16 -24', '16 16 32');
	
	if (!(self.health))
		self.health = 100;
	
	self.max_health = self.health;

	self.th_stand = q2marine_stand;
	self.th_walk = q2marine_walk;
	self.th_run = q2marine_run;
	self.th_missile = q2marine_select_attack;
	self.th_pain = q2marine_pain;
	self.th_die = q2marine_die;

	self.playerType = PT_MALE; //for death sound
	
	//self.inv_weapons = WEP_SHOTGUN;
	
	attachWeaponModel();	

	//self.sightSound = "soldier/solsght1.wav";

	walkmonster_start;
}