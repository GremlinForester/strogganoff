
void() bubble_bob;

/*
==============================================================================

PLAYER

==============================================================================
*/
#include "q2/q2_player.qh"

/*
==============================================================================
PLAYER
==============================================================================
*/

void() make_bubbles;

void() DeathBubblesSpawn =
{
//local entity	bubble;

#ifndef opgrade
	if (self.owner.health > 1) // was a previous opgrade - not sure of intent, removes spawner after respawn
	if (self.owner.waterlevel != 3)
		{
#ifdef codefix
			remove(self);	// remove bubble spawner
#endif
			return;
		}
#endif
/*
	bubble = spawn();
	setmodel (bubble, "progs/s_bubble.spr");
	setorigin (bubble, self.owner.origin + '0 0 24');
	bubble.movetype = MOVETYPE_NOCLIP;
	bubble.solid = SOLID_NOT;
	bubble.velocity = '0 0 15';
	bubble.nextthink = time + 0.5;
	bubble.think = bubble_bob;
	bubble.classname = "bubble";
	bubble.frame = 0;
	bubble.cnt = 0;
	setsize (bubble, '-8 -8 -8', '8 8 8');
*/
// note: fn sets think - the calling code below always resets it
	make_bubbles();
	nspawn.touch = SUB_Null;
#ifndef opgrade
	setorigin (nspawn, self.owner.origin + '0 0 24'); // can eliminate this step by setting it below
#endif

	self.nextthink = time + 0.1;

	self.think = DeathBubblesSpawn;
	self.air_finished = self.air_finished + 1;
	if (self.air_finished >= self.bubble_count)
		remove(self);
};

void(float num_bubbles) DeathBubbles =
{
#define bubble_spawner newmis
//local entity	bubble_spawner;
	
	bubble_spawner = spawn();
	setorigin (bubble_spawner, self.origin
#ifdef opgrade
																					 + '0 0 24'
#endif
	);
//	bubble_spawner.movetype = MOVETYPE_NONE;
//	bubble_spawner.solid = SOLID_NOT;
	bubble_spawner.nextthink = time
#ifdef opgrade
									 			+ 0.01;
#else
												 + 0.1;
#endif
	bubble_spawner.think = DeathBubblesSpawn;
//	bubble_spawner.air_finished = 0;
	bubble_spawner.owner = self;
	bubble_spawner.bubble_count = num_bubbles;
//	return;

#undef bubble_spawner
};

void() PlayerDead =
{
	self.nextthink = -1;
// allow respawn after a certain time
	self.deadflag = DEAD_DEAD;
};

void() set_suicide_frame =
{	// used by klill command and diconnect command
	if (self.model != "progs/player.mdl")
		return;	// allready gibbed
	self.frame = $FRAME_death106;
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_TOSS;
	self.deadflag = DEAD_DEAD;
	self.nextthink = -1;
};

void() q2player_run;


framer($FRAME_jump1, $FRAME_jump3, q2player_jumpframes, q2player_run, 0.1,

	frame_arb($FRAME_jump1,
//	self.state = STATE_ATTACKING;
//	self.weaponframe=5;
//	self.effects = self.effects | EF_MUZZLEFLASH;
	);

//	self.weaponframe++;
);

framer($FRAME_jump4, $FRAME_jump6, q2player_landframes, q2player_run, 0.1,

	frame_arb($FRAME_jump4,
//	self.state = STATE_ATTACKING;
//	self.weaponframe=5;
//	self.effects = self.effects | EF_MUZZLEFLASH;
	);

//	self.weaponframe++;
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

void()	q2Player_stand =[	$FRAME_stand01,	q2Player_stand	]
{
	self.state = STATE_IDLE;
	player_chatter_idle();
	doQ2PlayerModelStandframes();
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
	
	if (self.walkframe == 6)
		self.walkframe = 0;
		self.frame = $FRAME_run1 + self.walkframe;

	self.walkframe = self.walkframe + 1;
};

framer($FRAME_attack1, $FRAME_attack4, q2playeronly_4attackframes, q2player_run, 0.1,

	frame_arb($FRAME_attack1,
	);

);

framer($FRAME_crattak1, $FRAME_crattak4, q2playeronly_4attackframes_crouch, q2player_run, 0.1,

	frame_arb($FRAME_crattak1,
	);

);

framer($FRAME_attack1, $FRAME_attack8, q2playeronly_8attackframes, q2player_run, 0.1,

	frame_arb($FRAME_attack1,
	);
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
		DeathBubbles(1);
		if (random() > 0.5)
			sound (self, CHAN_VOICE, "player/drown1.wav", 1, ATTN_NORM);
		else
			sound (self, CHAN_VOICE, "player/drown2.wav", 1, ATTN_NORM);
		return;
	}

// slime pain sounds
	if (self.watertype == CONTENT_SLIME)
	{
// FIX ME	put in some steam here
#ifdef opgrade
		if (self.waterlevel == 3)
			DeathBubbles(1);
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

// don't make multiple pain sounds right after each other

// ax pain sound
	if (self.axhitme == 1)
	{
		self.axhitme = 0;
		sound (self, CHAN_VOICE, "player/axhit1.wav", 1, ATTN_NORM);
		return;
	}
	
	/*
	self.rnd_ = rint((random() * 5) + 1);

	self.noise = string_null;
	if (self.rnd_ == 1)
		self.noise = "player/pain1.wav";
	else if (self.rnd_ == 2)
		self.noise = "player/pain2.wav";
	else if (self.rnd_ == 3)
		self.noise = "player/pain3.wav";
	else if (self.rnd_ == 4)
		self.noise = "player/pain4.wav";
	else if (self.rnd_ == 5)
		self.noise = "player/pain5.wav";
	else
		self.noise = "player/pain6.wav";

	sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);
*/	
	if (self.health > 75){
		playerVOSound(PLAYER_VOICE_PAIN75);
	//		LOG("OUCH 75");
	//		SetVModelOverlaySelf('0 0 0', "models/overlay.md3", OVERLAY_RAIN, '1 0 0', 0.1);
	}
	else if (self.health > 50){
		playerVOSound(PLAYER_VOICE_PAIN50);
	//		LOG("OUCH 50");
	//		SetVModelOverlaySelf('0 0 0', "models/overlay.md3", OVERLAY_RAIN, '0 1 0', 0.1);
	}
	else if (self.health > 25){
		playerVOSound(PLAYER_VOICE_PAIN25);
	//		LOG("OUCH 25");
	//		SetVModelOverlaySelf('0 0 0', "models/overlay.md3", OVERLAY_FACE, '0 1 0', 0.1);
	}
	else
	{
		playerVOSound(PLAYER_VOICE_PAIN100);
	//		LOG("OUCH 100?");
	//		SetVModelOverlaySelf('0 0 0', "models/overlay.md3", OVERLAY_RAIN, '5 1 1', 0.1);
	}
//	return;
};

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

	if (r < 1) q2player_painFramesA();
		else if (r < 2) q2player_painFramesB();
		else            q2player_painFramesC();
};

void() q2playerDeathSound =
{
//local float		rs;

	// water death sounds
	if (self.waterlevel == 3)
	{
		DeathBubbles(20);
		sound (self, CHAN_VOICE, "player/h2odeath.wav", 1, ATTN_NONE);
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
/*
	ThrowHead ("progs/h_player.mdl", self.health);
	ThrowGib ("progs/gib1.mdl", self.health);
	ThrowGib ("progs/gib2.mdl", self.health);
	ThrowGib ("progs/gib3.mdl", self.health);
*/
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

framer($FRAME_death101, $FRAME_death106, q2player_dieA, PlayerDead, 0.1,SUB_Null());


framer($FRAME_death201, $FRAME_death206, q2player_dieB, PlayerDead, 0.1,SUB_Null());


framer($FRAME_death301, $FRAME_death308, q2player_dieC, PlayerDead, 0.1,SUB_Null());

void() q2PlayerDie =
{
//	local	float	i;
	
	self.items = self.items - (self.items & IT_INVISIBILITY

#ifdef opgrade
					| IT_INVULNERABILITY | IT_SUIT | IT_QUAD
#endif
																				 );
	self.invisible_finished = 0;	// don't die as eyes
	self.invincible_finished = 0;
	self.super_damage_finished = 0;
	self.radsuit_finished = 0;

#ifdef opgrade

#ifndef glowcorpse
#ifdef xvars2
	if (!cvar("svx_glowcorpse"))
#endif
	self.effects = 0;	// 1998-07-23 Glowing corpse of players which had quad/pentagram until respawn fix by Maddes
#endif

#endif

	self.modelindex = modelindex_player;	// don't use eyes

	if (deathmatch || coop)
		DropBackpack();
	
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
	
	if (self.f__ == 1)
		q2player_dieA();
	else if (self.f__ == 2)
		q2player_dieB();
	else
		q2player_dieC();
};