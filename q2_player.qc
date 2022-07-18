/*
==============================================================================

PLAYER

==============================================================================
*/
#include "q2/q2_player.qh"

//MrC: This will eventually go elsewhere. Here for testing.
void() player_chatter_idle =
{
	local float r;
	r = random() * 4;

	//self.nexttalktime = time + 10.35 + random() * 0.1;


	if (autocvar_cl_idletalk <= 0)
		return;

	if (coop || deathmatch)
	{
		return;
	}
	
	if (time < self.nexttalktime)
	return;

	if (self.deadflag)
		return;
	if (!(self.flags & FL_ONGROUND))
		return;
	if (vlen(self.velocity) > 10)
		return;
	if (self.movetype == MOVETYPE_NOCLIP || self.movetype == MOVETYPE_FLY)
		return;
  	if (self.waterlevel >= 3)
	{
		return;
	}
	
	if (r < 1) {sound(self, CHAN_VOICE, PLAYER_IDLECOMMENT_1, 0.5, ATTN_IDLE);
	}
	else if (r < 2) {sound(self, CHAN_VOICE, PLAYER_IDLECOMMENT_2, 0.5, ATTN_IDLE);
	}
	else if (r < 3) {sound(self, CHAN_VOICE, PLAYER_IDLECOMMENT_3, 0.5, ATTN_IDLE);
	}
	else            {sound(self, CHAN_VOICE, PLAYER_IDLECOMMENT_4, 0.5, ATTN_IDLE);
	}
	
	self.nexttalktime = time + 45;
}

void() PlayerDead =
{
	self.nextthink = -1;
// allow respawn after a certain time
	self.deadflag = DEAD_DEAD;
};

void() q2player_run;

framer($FRAME_jump1, $FRAME_jump3, q2player_jumpframes, q2player_run, 0.1,

	frame_arb($FRAME_jump1,
	);
);

framer($FRAME_jump4, $FRAME_jump6, q2player_landframes, q2player_run, 0.1,

	frame_arb($FRAME_jump4,
	
	);
);


void()	doQ2PlayerModelStandframes =
{
	self.state = STATE_IDLE;
	if (self.velocity_x || self.velocity_y)
	{
		self.walkframe=0;
		q2player_run();
		return;
	}

	if (self.walkframe >= 39)
	{
		self.walkframe = 0;
	}
	
	self.frame = $FRAME_stand01 + self.walkframe;
	self.walkframe++;
}

framer($FRAME_crstnd01, $FRAME_crstnd19, q2playeronly_crouchframes, q2player_run, 0.135,

	if (self.velocity_x || self.velocity_y)
	{
		self.walkframe=0;
		q2player_run();
		return;
	}

);

framer($FRAME_stand01, $FRAME_stand40, q2playeronly_standframes, q2player_run, 0.135,

	if (self.flags & FL_DUCKED)
	{
		q2playeronly_crouchframes();
	}

	if (self.velocity_x || self.velocity_y)
	{
		self.walkframe=0;
		q2player_run();
		return;
	}

);

void()	q2Player_stand =[	$FRAME_stand01,	q2Player_stand	]
{
	self.state = STATE_IDLE;
	player_chatter_idle();
	if (self.flags & FL_DUCKED)
	{
		q2playeronly_crouchframes();
	}
	else
	{
		q2playeronly_standframes();
	}
	self.nextthink = time + 0.135;		
};

void()	q2player_run =[	$FRAME_run1,	q2player_run	]
{
	self.state = STATE_RUNNING;
	
	if (!self.velocity_x && !self.velocity_y)
	{
		self.walkframe=0;
		q2Player_stand();
		return;
	}

	if (self.flags & FL_DUCKED)
	{
		if (self.walkframe == 6)
		self.walkframe = 0;
		self.frame = $FRAME_crwalk1 + self.walkframe;
	}
	else
	{
		if (self.walkframe == 6)
		self.walkframe = 0;
		self.frame = $FRAME_run1 + self.walkframe;
	}

	self.walkframe = self.walkframe + 1;
};


//TAUNT FLIP
framer($FRAME_flip01, $FRAME_flip12, q2player_flip, q2player_run, 0.1,

	frame_arb($FRAME_flip01,
	);
);

//TAUNT SALUTE
framer($FRAME_salute01, $FRAME_salute11, q2player_salute, q2player_run, 0.1,

	frame_arb($FRAME_salute01,
	);
);

//TAUNT
framer($FRAME_taunt01, $FRAME_taunt17, q2player_taunt, q2player_run, 0.1,

	frame_arb($FRAME_taunt01,
	);
);

//WAVE
framer($FRAME_wave01, $FRAME_wave11, q2player_wave, q2player_run, 0.1,

	frame_arb($FRAME_wave01,
	);
);


//POINT
framer($FRAME_point01, $FRAME_point12, q2player_point, q2player_run, 0.1,

	frame_arb($FRAME_point01,
	);
);

//STAND attack 4 frames
framer($FRAME_attack1, $FRAME_attack4, q2playeronly_4attackframes, q2player_run, 0.1,

	frame_arb($FRAME_attack1,
	);

);

//CROUCH attack 4 frames
framer($FRAME_crattak1, $FRAME_crattak4, q2playeronly_4attackframes_crouch, q2player_run, 0.1,

	frame_arb($FRAME_crattak1,
	);

);

//STAND attack 8 frames
framer($FRAME_attack1, $FRAME_attack8, q2playeronly_8attackframes, q2player_run, 0.1,

	frame_arb($FRAME_attack1,
	);
);

//CROUCH attack 8 frames
framer($FRAME_crattak1, $FRAME_crattak8, q2playeronly_8attackframes_crouch, q2player_run, 0.1,

	frame_arb($FRAME_crattak1,
	);
);

//CROUCH attack 2 frames
framer($FRAME_crattak2, $FRAME_crattak3, q2playeronly_2attackframes_crouch, q2playeronly_2attackframes_crouch, 0.075,

	if(self.weaponstate != WEAPON_FIRING) 
		q2player_run();
);

//STAND attack 2 frames
framer($FRAME_attack2, $FRAME_attack3, q2playeronly_2attackframes, q2playeronly_2attackframes, 0.1,

	if(self.weaponstate != WEAPON_FIRING) 
		q2player_run();
);

//============================================================================

void() q2playerPainSound =
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

//CROUCH PAIN


framer($FRAME_crpain1, $FRAME_crpain4, q2player_CRpainFramesA, q2player_run, 0.1,

	frame_arb($FRAME_crpain1,
	q2playerPainSound();
	);
);

//STAND PAIN

framer($FRAME_pain101, $FRAME_pain104, q2player_painFramesA, q2player_run, 0.1,

	frame_arb($FRAME_pain101,
	q2playerPainSound();
	);
);

framer($FRAME_pain201, $FRAME_pain204, q2player_painFramesB, q2player_run, 0.1,

	frame_arb($FRAME_pain201,
	
	q2playerPainSound();
	);
);

framer($FRAME_pain301, $FRAME_pain304, q2player_painFramesC, q2player_run, 0.1,

	frame_arb($FRAME_pain301,
	
	q2playerPainSound();
	);
);

void() q2player_pain =
{
	local float r;
	
	r = random() * 3;
	
//	if (self.weaponframe)
//		return;

	if (self.invisible_finished > time)
		return;		// eyes don't have pain frames

	if (self.flags & FL_DUCKED)
	{
		q2player_CRpainFramesA();
	}
	else
	{
		if (r < 1) q2player_painFramesA();
		else if (r < 2) q2player_painFramesB();
		else            q2player_painFramesC();
	}
};

void() q2playerDeathSound =
{
//local float		rs;

	// water death sounds
	if (self.waterlevel == 3)
	{
		//DeathBubbles(20); //TODO: bubbles particle call here.
		playerVOSound(PLAYER_VOICE_DROWN);
		return;
	}
/*	
	self.rnd_ = rint ((random() * 4) + 1);
	if (self.rnd_ == 1)
		self.noise = "player/death1.wav";
	if (self.rnd_ == 2)
		self.noise = "player/death2.wav";
	if (self.rnd_ == 3)
		self.noise = "player/death3.wav";
	if (self.rnd_ == 4)
		self.noise = "player/death4.wav";
	if (self.rnd_ == 5)
		self.noise = "player/death5.wav";

	sound (self, CHAN_VOICE, self.noise, 1, ATTN_NONE);
	*/
	playerVOSound(PLAYER_VOICE_DEATH);
//	return;
};


void() q2PlayerDead =
{
	self.nextthink = -1;
// allow respawn after a certain time
	self.deadflag = DEAD_DEAD;
};

void() GibQ2Player =
{
	// gibbs plays a sound that we take over below				
	gibbs("progs/h_player.mdl");

	self.deadflag = DEAD_DEAD;

	if (damage_attacker.classname == "teledeath")
	{
		sound (self, CHAN_VOICE, "player/teledth1.wav", 1, ATTN_NONE);
		return;
	}

	if (damage_attacker.classname == "teledeath2")
	{
		sound (self, CHAN_VOICE, "player/teledth1.wav", 1, ATTN_NONE);
		return;
	}
		
	if (random() < 0.5)
		sound (self, CHAN_VOICE, "player/gib.wav", 1, ATTN_NONE);
	else
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NONE);
};

// Q2 Player Death

//crouch death
framer($FRAME_crdeath1, $FRAME_crdeath5, q2player_CRdieA, PlayerDead, 0.1,SUB_Null());

framer($FRAME_death101, $FRAME_death106, q2player_dieA, PlayerDead, 0.1,SUB_Null());

framer($FRAME_death201, $FRAME_death206, q2player_dieB, PlayerDead, 0.1,SUB_Null());

framer($FRAME_death301, $FRAME_death308, q2player_dieC, PlayerDead, 0.1,SUB_Null());

void() q2PlayerDie =
{
//	local	float	i;
	
	self.items - (self.items & (IT_KEY1 | IT_KEY2 | IT_INVISIBILITY | IT_INVULNERABILITY | IT_SUIT | IT_BREATHER | IT_QUAD | IT_DOUBLER | IT_INVISIBILITY) );
	self.invisible_finished = 0;
	self.invincible_finished = 0;
	self.super_damage_finished = 0;
	self.radsuit_finished = 0;
	self.silencer_finished = 0;

#ifdef opgrade

#ifndef glowcorpse
#ifdef xvars2
	if (!cvar("svx_glowcorpse"))
#endif
	self.effects = 0;	// 1998-07-23 Glowing corpse of players which had quad/pentagram until respawn fix by Maddes
#endif

#endif

//	self.modelindex = modelindex_player;	// don't use eyes

	if (deathmatch || coop) //just added this for now, savepack stuff might go here or just for coop?
	{
	//	DropBackpack();
		if (self.weapon == WEP_SHOTGUN || self.weapon == WEP_SUPERSHOTGUN){
			DropLoot(LOOT_SHELLS, ceil(self.inv_ammo_shells / 4), self.origin);
		}
		
		if (self.weapon == WEP_MACHINEGUN || self.weapon == WEP_CHAINGUN){
		DropLoot(LOOT_BULLETS, ceil(self.inv_ammo_bullets / 4), self.origin);
		}
		
		if (self.weapon == WEP_GRENADE_LAUNCHER || self.weapon == WEP_ROCKET_LAUNCHER){
		DropLoot(LOOT_ROCKETS, ceil(self.inv_ammo_rockets / 4), self.origin);
		}
		
		if (self.weapon == WEP_HYPERBLASTER || self.weapon == WEP_BFG){
		DropLoot(LOOT_CELLS, ceil(self.inv_ammo_cells / 4), self.origin);
		}
		
		if (self.weapon == WEP_RAILGUN){
		DropLoot(LOOT_SLUGS, ceil(self.inv_ammo_slugs / 4), self.origin);
		}
	}
	
  //Stroggannoff EXT-COOP / playerCache ops
  local entity cache;
  cache = PLAYER_CACHE_ENTS[self.playerCache];
  if(cache && self){
    sv_coop_client_setCache(self, cache);
  }
  
  
	self.weaponmodel=string_null;
	self.view_ofs = '0 0 -8';
	self.deadflag = DEAD_DYING;
	self.solid = SOLID_NOT;
	self.flags = self.flags - (self.flags & FL_ONGROUND);
	self.movetype = MOVETYPE_TOSS;
	if (self.velocity_z < 10)
		self.velocity_z = self.velocity_z + random()*300;

	if (self.health < -40)
	{
		GibQ2Player ();
		return;
	}

	q2playerDeathSound();
	
	self.angles_x = 0;
	self.angles_z = 0;
	
	self.f__ = 1 + floor(random()*3);

	if (self.flags & FL_DUCKED)
	{
		q2player_CRdieA();
	}
	else
	{
		if (self.f__ == 1)
			q2player_dieA();
		else if (self.f__ == 2)
			q2player_dieB();
		else
			q2player_dieC();
	}
};