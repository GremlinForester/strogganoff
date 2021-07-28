
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
void() q2player_run;

void() W_SetDefaultFrames =
{
	switch (self.weapon)
	{
		case WEP_BLASTER:
			self.weaponframe=WEP_BLASTER_IDLE1_FIRSTFRAME;
			break;
		case WEP_SHOTGUN:
			self.weaponframe=19;
			break;
		case WEP_SUPERSHOTGUN:
			self.weaponframe=18;
			break;
		case WEP_MACHINEGUN:
			self.weaponframe=6;
			break;
		case WEP_CHAINGUN:
			if (self.weaponstate == WEAPON_SPINDOWN){
				return;
			}
			else{
			self.weaponframe=32;
			}
			break;
		case WEP_GRENADE_LAUNCHER:
			self.weaponframe=18;
			break;
		case WEP_ROCKET_LAUNCHER:
			self.weaponframe=13;
			break;
		case WEP_RAILGUN:
			self.weaponframe=9;
			break;
		case WEP_HYPERBLASTER:
			if (self.weaponstate == WEAPON_SPINDOWN){
				return;
			}
			else{
			self.weaponframe=22;
			}
			break;
		case WEP_BFG:
			self.weaponframe=9;
			break;
	}
}


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

void()	q2Player_stand =[	$FRAME_stand01,	q2Player_stand	] //hold still dammit!
{
	self.state = STATE_IDLE;
	doQ2PlayerModelStandframes();
	self.nextthink = time + 0.135;		
};

void()	q2player_run =[	$FRAME_run1,	q2player_run	]
{
	self.state = STATE_RUNNING;
//	W_SetDefaultFrames();
	
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

// draw weapon frames
framer($FRAME_pain301, $FRAME_pain304, q2player_4drawframes, q2player_run, 0.1,

	frame_arb($FRAME_pain301,
//	self.weaponframe=0;	
	);
	frame_arb($FRAME_pain304,
//	W_SetDefaultFrames();
//	self.weaponstate = WEAPON_READY;	
	);
	
//	self.weaponframe++;
);

// Quake II Blaster 4 Frames (no gun cock)

framer($FRAME_attack1, $FRAME_attack4, q2player_4attackframes, q2player_run, 0.1,

	frame_arb($FRAME_attack1,
	self.weaponframe=5;
	self.state = STATE_ATTACKING;
	);
	frame_arb($FRAME_attack4,
	W_SetDefaultFrames();
	self.weaponstate = WEAPON_READY;	
	);
	self.weaponframe++;
);

framer($FRAME_attack1, $FRAME_attack2, q2player_HBattackframes, q2player_run, 0.1,

	frame_arb($FRAME_attack1,
	if (self.weaponframe>11)
	{
		self.weaponframe=6;
	}
	);
	frame_arb($FRAME_attack2,
	if (self.weaponframe>11)
	{
		self.weaponframe=6;
	}
	);
	self.weaponframe++;
);

framer($FRAME_attack1, $FRAME_attack2, q2player_MGattackframes, q2player_run, 0.1,

	frame_arb($FRAME_attack1,
	FireBullet(WEAPON_MACHINEGUN_DAMAGE);
	self.punchangle_x = -4;
	self.effects = self.effects | EF_MUZZLEFLASH;
	
	self.weaponframe=4;
	);
	
	frame_arb($FRAME_attack2,
	self.weaponframe=5;
	);
);

framer($FRAME_attack1, $FRAME_attack2, q2player_CGattackframes, q2player_run, 0.1,

	frame_arb($FRAME_attack1,
	
	if (self.weaponframe >= 21 || self.weaponframe <= 4)
		self.weaponframe = 15;
	
	FireBullet(WEAPON_CHAINGUN_DAMAGE);
	self.punchangle_x = -4;
	self.effects = self.effects | EF_MUZZLEFLASH;
	);
	frame_arb($FRAME_attack2,
	
	if (self.weaponframe >= 21 || self.weaponframe <= 4)
		self.weaponframe = 15;
	);
	self.weaponframe++;
);

framer($FRAME_attack1, $FRAME_attack8, q2player_8attackframes, q2player_run, 0.1,

	frame_arb($FRAME_attack1,
	switch(self.weapon)
	{
		case WEP_SHOTGUN:
		self.weaponframe=8;
			break;
		case WEP_SUPERSHOTGUN:
		self.weaponframe=8;
			break;
		case WEP_ROCKET_LAUNCHER:
		self.weaponframe=10; 
			break;
		case WEP_GRENADE_LAUNCHER:
		self.weaponframe=8; 
			break;
	}
	self.effects = self.effects | EF_MUZZLEFLASH;
	);
	frame_arb($FRAME_attack8,
	W_SetDefaultFrames();
	self.weaponstate = WEAPON_READY;
	);
	self.weaponframe++;
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
#endifdef

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
//	return;
};

framer($FRAME_pain101, $FRAME_pain104, q2player_painFramesA, q2player_run, 0.1,

	frame_arb($FRAME_pain101,
	PainSound();
	self.weaponframe=0;
	);
);

framer($FRAME_pain201, $FRAME_pain204, q2player_painFramesB, q2player_run, 0.1,

	frame_arb($FRAME_pain201,
	
	PainSound();
	self.weaponframe=0;
	);
);

framer($FRAME_pain301, $FRAME_pain304, q2player_painFramesC, q2player_run, 0.1,

	frame_arb($FRAME_pain301,
	
	PainSound();
	self.weaponframe=0;
	);
);

void() q2player_pain =
{
	local float r;
	
	r = random() * 3;
	
	if (self.weaponframe)
		return;

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
#endifdef
																				 );
	self.invisible_finished = 0;	// don't die as eyes
	self.invincible_finished = 0;
	self.super_damage_finished = 0;
	self.radsuit_finished = 0;

#ifdef opgrade

#ifndef glowcorpse
#ifdef xvars2
	if (!cvar("svx_glowcorpse"))
#endifdef
	self.effects = 0;	// 1998-07-23 Glowing corpse of players which had quad/pentagram until respawn fix by Maddes
#endifdef

#endifdef

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