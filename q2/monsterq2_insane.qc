/*
==============================================================================

QUAKE II INSANE

==============================================================================
*/

#include "monsterq2_insane.qh"

#define sound_fist "sound/insane/insane11.wav"
#define sound_shake "sound/insane/insane5.wav"
#define sound_moan "sound/insane/insane7.wav"

void insane_fist ()=
{
	sound (self, CHAN_VOICE, sound_fist, 1, ATTN_IDLE);
}

void insane_shake ()=
{
	sound (self, CHAN_VOICE, sound_shake, 1, ATTN_IDLE);
}

void insane_moan ()=
{
	if (random() < 0.2)
	{
		sound (self, CHAN_VOICE, sound_moan, 1, ATTN_IDLE);
	}
}

void insane_scream ()=
{
	local float r;
	r = rint(random()*8);
	
	if (random() < 0.1)
	{
	switch(r){
		default:
			sound (self, CHAN_VOICE, "sound/insane/insane1.wav", 1, ATTN_IDLE);
			break;
		case 1:
			sound (self, CHAN_VOICE, "sound/insane/insane2.wav", 1, ATTN_IDLE);
			break;
		case 2:
			sound (self, CHAN_VOICE, "sound/insane/insane3.wav", 1, ATTN_IDLE);
			break;
		case 3:
			sound (self, CHAN_VOICE, "sound/insane/insane4.wav", 1, ATTN_IDLE);
			break;
		case 4:
			sound (self, CHAN_VOICE, "sound/insane/insane6.wav", 1, ATTN_IDLE);
			break;
		case 5:
			sound (self, CHAN_VOICE, "sound/insane/insane8.wav", 1, ATTN_IDLE);
			break;
		case 6:
			sound (self, CHAN_VOICE, "sound/insane/insane9.wav", 1, ATTN_IDLE);
			break;
		case 7:
			sound (self, CHAN_VOICE, "sound/insane/insane10.wav", 1, ATTN_IDLE);
			break;
	}
	}
}

void() insane_stand;
void() insane_dead;
void() insane_cross;
void() insane_walk;
void() insane_run;
void() insane_checkdown;
void() insane_checkup;
void() insane_onground;


/*

STAND FIDGET

*/

//STAND1
framer($FRAME_stand60, $FRAME_stand65, insane_move_stand_normal, insane_stand, 0.1,

	frame_arb($FRAME_stand65, insane_checkdown(););

	ai_stand();
);

framer($FRAME_stand65, $FRAME_stand94, insane_move_stand_insane, insane_stand, 0.1,

	frame_arb($FRAME_stand65, insane_shake(););
	frame_arb($FRAME_stand94, insane_checkdown(););

	ai_stand();
);

framer($FRAME_stand1, $FRAME_stand40, insane_move_uptodown, insane_onground, 0.1,
	
	frame_arb($FRAME_stand8, insane_moan(););
	
	frame_arb($FRAME_stand28, insane_fist(););
	
	frame_arb($FRAME_stand34, insane_fist(););
	
	ai_rep($FRAME_stand21, ai_walk, 2.7, 4.1, 6, 7.6, 3.6, 0, 0, 0);
	
	ai_walk(0);
);

framer($FRAME_stand41, $FRAME_stand59, insane_move_downtoup, insane_stand, 0.1,
	
	ai_rep($FRAME_stand41, ai_walk, -0.7, -1.2, -1.5, -4.5, -3.5, -0.2, 0, -1.3);
	
	ai_rep($FRAME_stand49, ai_walk, -3, -2, 0, 0, 0, -3.3, -1.6, -0.3);
	
	ai_walk(0);
);


framer($FRAME_stand96, $FRAME_stand100, insane_move_jumpdown, insane_onground, 0.1,

	frame_arb($FRAME_stand96, ai_walk(0.2););
	frame_arb($FRAME_stand97, ai_walk(11.5););
	frame_arb($FRAME_stand98, ai_walk(5.1););
	frame_arb($FRAME_stand99, ai_walk(7.1););

	ai_walk(0);
);

framer($FRAME_stand100, $FRAME_stand160, insane_move_down, insane_onground, 0.1, 
	
	ai_rep($FRAME_walk27, ai_walk, 0, 2.5,3.5, 1.7, 2.3, 2.4, 2.2, 4.2, 5.6);
	frame_arb($FRAME_stand111, ai_walk(-1.7););
	frame_arb($FRAME_stand112, ai_walk(-1.6););
	
	frame_arb($FRAME_stand116, insane_fist(););
	
	frame_arb($FRAME_stand133, insane_moan(););
	
	frame_arb($FRAME_stand151, ai_walk(0.5););
	
	frame_arb($FRAME_stand153, ai_walk(-0.2); insane_scream(););
	
	frame_arb($FRAME_stand160, insane_checkup(););
	
	ai_rep($FRAME_stand155, ai_walk, 0.2, 0.4, 0.6, 0.8, 0.7, 0, 0, 0);
	
	ai_walk(0);
	
);

framer($FRAME_walk27, $FRAME_walk39, insane_move_walk_normal, insane_walk, 0.1,
	ai_rep($FRAME_walk28, ai_walk, 2.5, 3.5, 1.7, 2.3, 2.4, 2.2, 4.2, 5.6);
	ai_rep($FRAME_walk36, ai_walk, 3.3, 2.4, 0.9, 3.0, 0, 0, 0, 0);
);
framer($FRAME_walk27, $FRAME_walk39, insane_move_run_normal, insane_run, 0.1,
	ai_rep($FRAME_walk28, ai_run,2.5,3.5, 1.7, 2.3, 2.4, 2.2, 4.2, 5.6);
	ai_rep($FRAME_walk36, ai_run, 3.3, 2.4, 0.9, 3.0, 0, 0, 0, 0);	
);

framer($FRAME_walk1, $FRAME_walk26, insane_move_walk_insane, insane_walk, 0.1,
	
	ai_rep($FRAME_walk1, ai_walk, 0, 3.4, 3.6, 2.9, 2.2, 2.6, 0, 0.7);
	
	ai_rep($FRAME_walk9, ai_walk, 4.8, 5.3, 1.1, 2, 0.5, 0, 0, 4.9);
	
	ai_rep($FRAME_walk17, ai_walk, 6.7, 3.8, 2, 0.2, 0, 3.4, 6.4, 5);
	
	frame_arb($FRAME_walk25, ai_walk(1.8););
	frame_arb($FRAME_walk26, ai_walk(0););
)

framer($FRAME_walk1, $FRAME_walk26, insane_move_run_insane, insane_run, 0.1,
	
	ai_rep($FRAME_walk1, ai_walk, 0, 3.4, 3.6, 2.9, 2.2, 2.6, 0, 0.7);
	
	ai_rep($FRAME_walk9, ai_walk, 4.8, 5.3, 1.1, 2, 0.5, 0, 0, 4.9);
	
	ai_rep($FRAME_walk17, ai_walk, 6.7, 3.8, 2, 0.2, 0, 3.4, 6.4, 5);
	
	frame_arb($FRAME_walk25, ai_walk(1.8););
	frame_arb($FRAME_walk26, ai_walk(0););
)


framer($FRAME_st_pain2, $FRAME_st_pain12, insane_move_stand_pain, insane_run, 0.1,
	ai_walk(0);
);


framer($FRAME_st_death2, $FRAME_st_death18, insane_move_stand_death, insane_dead, 0.1,
	ai_walk(0);
);

framerloop($FRAME_crawl1, $FRAME_crawl9, insane_move_crawl, 0.1,
	frame_arb($FRAME_crawl1, ai_walk(0););
	ai_rep($FRAME_crawl2, ai_walk, 1.5, 2.1, 3.6, 2, 0.9, 3, 3.4, 2.4);
);

framerloop($FRAME_crawl1, $FRAME_crawl9, insane_move_runcrawl, 0.1,
	frame_arb($FRAME_crawl1, ai_walk(0););
	ai_rep($FRAME_crawl2, ai_walk, 1.5, 2.1, 3.6, 2, 0.9, 3, 3.4, 2.4);
);

framer($FRAME_cr_pain2, $FRAME_cr_pain10, insane_move_crawl_pain, insane_run, 0.1,
	ai_walk(0);
);

framer($FRAME_cr_death10, $FRAME_cr_death16, insane_move_crawl_death, insane_dead, 0.1,
	ai_walk(0);
);

framer($FRAME_cross1, $FRAME_cross15, insane_move_cross, insane_cross, 0.1,
	frame_arb($FRAME_cross1, insane_moan(););
//	ai_walk(0);
);

framer($FRAME_cross16, $FRAME_cross30, insane_move_struggle_cross, insane_cross, 0.1,
	frame_arb($FRAME_cross16, insane_scream(););
//	ai_walk(0);
);

void() insane_cross=
{
	if (random() < 0.8)
		insane_move_cross();
	else
		insane_move_struggle_cross();
}

void() insane_walk=
{
	if ( (self.spawnflags & 16) )			// Hold Ground?
		if (self.frame == $FRAME_cr_pain10)
		{
			insane_move_down();
			return;
		}
	if ((self.spawnflags & 4)){
		insane_move_crawl();
	}
	else{
		if (random() <= 0.5){
			insane_move_walk_normal();
		}
		else{
			insane_move_walk_insane();
		}
	}
};

void() insane_run=
{
	if ( (self.spawnflags & 16) )			// Hold Ground?
		if (self.frame == $FRAME_cr_pain10)
		{
			insane_move_down();
			return;
		}
	if ((self.spawnflags & 4)){				// Crawling?
		insane_move_runcrawl();
	}
	else
		if (random() <= 0.5){				// Else, mix it up
			insane_move_run_normal();
		}
		else{
			insane_move_run_insane();
		}
};


void(entity attacker, float damage) insane_pain=
{
	float	l,r;

	SpawnBlood (self.origin, '0 0 0', 20);
	
	if (time < self.pain_finished)
		return;
	
	sound (self, CHAN_VOICE, sprintf("player/male/pain%s_%s.wav", ftos(rint(l)), ftos(rint(r))), 1, ATTN_IDLE);

	if (skill == 3)
		return;		// no pain anims in nightmare

	// Don't go into pain frames if crucified.
	if ((self.spawnflags & 8))
	{
		insane_move_struggle_cross();
		return;
	}
	
	if  ( ((self.frame >= $FRAME_crawl1) && (self.frame <= $FRAME_crawl9)) || ((self.frame >= $FRAME_stand99) && (self.frame <= $FRAME_stand160)) )
	{
		insane_move_crawl_pain();
	}
	else
	{
		insane_move_stand_pain();
	}

};

void() insane_onground=
{
	insane_move_down();
};

void() insane_checkdown=
{
//	if ( (self->s.frame == FRAME_stand94) || (self->s.frame == FRAME_stand65) )
	if ((self.spawnflags & 32))				// Always stand
		return;
	if (random() < 0.3){
		if (random() < 0.5){
			insane_move_uptodown();
		}
		else{
			insane_move_jumpdown();
		}
	}
};


void() insane_checkup=
{
	// If Hold_Ground and Crawl are set
	if ( (self.spawnflags & 4) && (self.spawnflags & 16) )
		return;
	if (random() < 0.5)
		insane_move_downtoup();
};


void() insane_stand=
{
	if ((self.spawnflags & 8))			// If crucified
	{
		insane_cross();
	}
	// If Hold_Ground and Crawl are set
	else if ( (self.spawnflags & 4) && (self.spawnflags & 16) )
		insane_move_down();
	else
		if (random() < 0.5)
			insane_move_stand_normal();
		else
			insane_move_stand_insane();
	
};

void() insane_dead=
{
	self.solid = SOLID_CORPSE;	
	
	if ((self.spawnflags & 8))
	{
		self.movetype = MOVETYPE_NONE;
	//	self.flags = self.flags | FL_FLY;
	}
	else
	{
		setsize(self, '-16 -16 -24', '16 16 -8');
		self.movetype = MOVETYPE_TOSS;
	}
	//self->svflags |= SVF_DEADMONSTER;
	self.nextthink = -1;
};

void() insane_die=
{
	float		n;

	if (self.health <= -50)
	{
		sound (self, CHAN_VOICE, "misc/udeath.wav", 1, ATTN_IDLE);
		for (n= 0; n < 2; n++)
			ThrowGib ("models/objects/gibs/bone/tris.md2", self.health, GIB_FLESH, 1);
		for (n= 0; n < 4; n++)
			ThrowGib ("models/objects/gibs/sm_meat/tris.md2", self.health, GIB_FLESH, 1);
		ThrowHead ("models/objects/gibs/head2/tris.md2", self.health);
		self.deadflag = DEAD_DEAD;
		return;
	}

	if (self.deadflag == DEAD_DEAD)
		return;
	
	sound (self, CHAN_VOICE, sprintf("player/male/death%s.wav", ftos(rint((random()*4) + 1))), 1, ATTN_IDLE);

	self.deadflag = DEAD_DEAD;
	self.takedamage = DAMAGE_YES;

	if ((self.spawnflags & 8))
	{
		self.nextthink = -1;
		insane_dead ();
	}
	else
	{
		if ( ((self.frame >= $FRAME_crawl1) && (self.frame <= $FRAME_crawl9)) || ((self.frame >= $FRAME_stand99) && (self.frame <= $FRAME_stand160)) )
		//if (self.aiflags & bits_AI_CRAWLING)	
			insane_move_crawl_death();
		else
			insane_move_stand_death();	
	}
}

void() updateWeaponModelFrames =
{
	if (self.owner.health <= 0)
	{
		remove(self);
		return;
	}

		switch (self.owner.inv_weapons)
		{
		case WEP_BLASTER:
			setmodel (self, "players/male/w_blaster.md2");
			break;
		case WEP_SHOTGUN:
			setmodel (self, "players/male/w_shotgun.md2");
			break;
		case WEP_SUPERSHOTGUN:
			setmodel (self, "players/male/w_sshotgun.md2");
			break;
		case WEP_MACHINEGUN:
			setmodel (self, "players/male/w_machinegun.md2");
			break;
		case WEP_CHAINGUN:
			setmodel (self, "players/male/w_chaingun.md2");
			break;
		case WEP_GRENADE_LAUNCHER:
			setmodel (self, "players/male/w_glauncher.md2");
			break;
		case WEP_ROCKET_LAUNCHER:
			setmodel (self, "players/male/w_rlauncher.md2");
			break;
		case WEP_RAILGUN:
			setmodel (self, "players/male/w_railgun.md2");
			break;
		case WEP_HYPERBLASTER:
			setmodel (self, "players/male/w_hyperblaster.md2");
			break;
		case WEP_BFG:
			setmodel (self, "players/male/w_bfg.md2");
			break;
		}	
	
	self.frame = self.owner.frame;
	
	self.think = updateWeaponModelFrames;
	self.nextthink = time;
};

void() attachWeaponModel =
{
	local entity playerTPWeapon;
	
	playerTPWeapon = spawn();
	setorigin (playerTPWeapon, '0 0 0');
	playerTPWeapon.owner = self;
//	setorigin (playerTPWeapon, self.owner.origin);
	playerTPWeapon.netname = "playerTPWeapon";
	playerTPWeapon.solid = SOLID_NOT;
	playerTPWeapon.movetype = MOVETYPE_NOCLIP;
	playerTPWeapon.exteriormodeltoclient = self;
	
	playerTPWeapon.think = updateWeaponModelFrames;
	playerTPWeapon.nextthink = time;

	setattachment(playerTPWeapon, self, "");
};

void() insane_gotaweapon =
{
	setmodel(self, "players/male/tris.md2");
	setsize(self, '-16 -16 -24', '16 16 32');
	
	if (self.skin == 0)
		self.skin = 16;
	
	if (self.skin == 1)
		self.skin = 17;

	if (self.skin == 2)
		self.skin = 18;

	self.th_stand = q2marine_stand;
	self.th_walk = q2marine_walk;
	self.th_run = q2marine_run;
	self.th_missile = q2marine_select_attack;
	self.th_pain = q2marine_pain;
	self.th_die = q2marine_die;

	attachWeaponModel();

	self.think = q2marine_salute;
	self.nextthink = time = 0.1;
	LOG2("I picked up a ", printWeaponName(self));
};

/*QUAKED misc_insane (1 .5 0) (-16 -16 -24) (16 16 32) Ambush Trigger_Spawn CRAWL CRUCIFIED STAND_GROUND ALWAYS_STAND
*/
void() misc_insane =
{
//	static int skin = 0;	//@@

	if (deathmatch)
	{
		remove(self);
		return;
	}

	precache_model("models/monsters/insane/tris.md2");

	precache_sound(sound_fist);
	precache_sound(sound_shake);
	precache_sound(sound_moan);
	
	precache_sound("sound/insane/insane1.wav");
	precache_sound("sound/insane/insane2.wav");
	precache_sound("sound/insane/insane3.wav");
	precache_sound("sound/insane/insane4.wav");
	precache_sound("sound/insane/insane6.wav");
	precache_sound("sound/insane/insane8.wav");
	precache_sound("sound/insane/insane9.wav");
	precache_sound("sound/insane/insane10.wav");
	
	self.movetype = MOVETYPE_STEP;
	self.solid = SOLID_BBOX;
	setmodel(self, "models/monsters/insane/tris.md2");
	setsize(self, '-16 -16 -24', '16 16 32');

	#ifdef misc_insane_weapon_pickup
	self.flags = FL_CLIENT; //should probably use something else
	#endifdef

	self.health = 30;

	self.th_pain = insane_pain;
	self.th_die = insane_die;

	self.th_stand = insane_stand;
	self.th_walk = insane_walk;
	self.th_run = insane_run;
	//self.touch = insane_touch;	


	//if ((self.spawnflags & 16))				// Stand Ground
		//self->monsterinfo.aiflags |= AI_STAND_GROUND;

	insane_move_stand_normal();
	
	if ((self.spawnflags & 8))					// Crucified ?
	{
		setsize(self, '-16 0 0', '16 8 32');
		self.th_stand = insane_stand;
		self.th_walk = SUB_Null;
		self.th_run = SUB_Null;		
		
		flymonster_start;
	}
	else
	{
		walkmonster_start;
		self.skin = ceil(random() * 3);
	}
};