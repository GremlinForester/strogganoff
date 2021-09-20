/*

Quake 1 compatibility spawn functions.

These should point to Quake 2 counterparts allowing for Quake 1 map support.

*/


/*
Quake 1 used for possible replacement items in Q1 map compatibility.
*/

/*QUAKED item_shells (0 .5 .8) (0 0 0) (32 32 32) big
*/

#define WEAPON_BIG2 1

void() item_shells =
{
	self.touch = ammo_touch;

	if (!self.model) // allow next 3 functions to come here & not run this set
	{
		if (self.spawnflags & WEAPON_BIG2)
		{
			precache_model ("maps/b_shell1.bsp");
			setmodel (self, "maps/b_shell1.bsp");
			self.aflag = 40;
		}
		else
		{
			precache_model ("maps/b_shell0.bsp");
			setmodel (self, "maps/b_shell0.bsp");
			self.aflag = 20;
		}
		self.weapon = 1;
		self.netname = "shells";
	}
	setsize (self, '0 0 0', '32 32 56');
	StartItem();
};

/*QUAKED item_spikes (0 .5 .8) (0 0 0) (32 32 32) big
*/

void() item_spikes =
{
//	self.touch = ammo_touch;

	if (self.spawnflags & WEAPON_BIG2)
	{
		precache_model ("maps/b_nail1.bsp");
		setmodel (self, "maps/b_nail1.bsp");
		self.aflag = 50;
	}
	else
	{
		precache_model ("maps/b_nail0.bsp");
		setmodel (self, "maps/b_nail0.bsp");
		self.aflag = 25;
	}
	self.weapon = 2;
	self.netname = "bullets";
	item_shells();
/*
	setsize (self, '0 0 0', '32 32 56');
	StartItem ();
*/
};

/*QUAKED item_rockets (0 .5 .8) (0 0 0) (32 32 32) big
*/

void() item_rockets =
{
//	self.touch = ammo_touch;

	if (self.spawnflags & WEAPON_BIG2)
	{
		precache_model ("maps/b_rock1.bsp");
		setmodel (self, "maps/b_rock1.bsp");
		self.aflag = 10;
	}
	else
	{
		precache_model ("maps/b_rock0.bsp");
		setmodel (self, "maps/b_rock0.bsp");
		self.aflag = 5;
	}
	self.weapon = 3;
	self.netname = "rockets";
	item_shells();
/*
	setsize (self, '0 0 0', '32 32 56');
	StartItem ();
*/
};

/*QUAKED item_cells (0 .5 .8) (0 0 0) (32 32 32) big
*/

void() item_cells =
{
//	self.touch = ammo_touch;

	if (self.spawnflags & WEAPON_BIG2)
	{
		precache_model ("maps/b_batt1.bsp");
		setmodel (self, "maps/b_batt1.bsp");
		self.aflag = 12;
	}
	else
	{
		precache_model ("maps/b_batt0.bsp");
		setmodel (self, "maps/b_batt0.bsp");
		self.aflag = 6;
	}
	self.weapon = 4;
	self.netname = "cells";
	item_shells();
/*
	setsize (self, '0 0 0', '32 32 56');
	StartItem ();
*/
};


/*QUAKED item_weapon (0 .5 .8) (0 0 0) (32 32 32) shotgun rocket spikes big
DO NOT USE THIS!!!! IT WILL BE REMOVED!
*/

#define WEAPON_SHOTGUN 1
#define WEAPON_ROCKET 2
#define WEAPON_SPIKES 4
#define WEAPON_BIG 8
void() item_weapon =
{
	self.touch = ammo_touch;

// detect items
	self.f__ = self.spawnflags;
// make bit 1 big setting for sub calls
	self.spawnflags = (self.spawnflags & WEAPON_BIG) / 8;

	if (self.f__ & WEAPON_SHOTGUN)
	{
		item_shells();
/*
		if (self.spawnflags & WEAPON_BIG)
		{
			precache_model ("maps/b_shell1.bsp");
			setmodel (self, "maps/b_shell1.bsp");
			self.aflag = 40;
		}
		else
		{
			precache_model ("maps/b_shell0.bsp");
			setmodel (self, "maps/b_shell0.bsp");
			self.aflag = 20;
		}
		self.weapon = 1;
		self.netname = "shells";
*/
	}

	if (self.f__ & WEAPON_SPIKES)
	{
		item_spikes();
/*
		if (self.spawnflags & WEAPON_BIG)
		{
			precache_model ("maps/b_nail1.bsp");
			setmodel (self, "maps/b_nail1.bsp");
			self.aflag = 40;
		}
		else
		{
			precache_model ("maps/b_nail0.bsp");
			setmodel (self, "maps/b_nail0.bsp");
			self.aflag = 20;
		}
		self.weapon = 2;
*/
		self.netname = "spikes";
	}

	if (self.f__ & WEAPON_ROCKET)
	{
		item_rockets();
/*
		if (self.spawnflags & WEAPON_BIG)
		{
			precache_model ("maps/b_rock1.bsp");
			setmodel (self, "maps/b_rock1.bsp");
			self.aflag = 10;
		}
		else
		{
			precache_model ("maps/b_rock0.bsp");
			setmodel (self, "maps/b_rock0.bsp");
			self.aflag = 5;
		}
		self.weapon = 3;
		self.netname = "rockets";
*/
	}

#ifndef codefix
// if no spawnflags & 7 - this causes a "You got the" message	with no inventory change
	setsize (self, '0 0 0', '32 32 56');
	StartItem ();
#endifdef
};


/*QUAKED item_key1 (0 .5 .8) (-16 -16 -24) (16 16 32)
SILVER key
In order for keys to work you MUST set your maps world.worldtype to one of the
following:
0: medieval
1: metal
2: base
(see worldspawn).

-------- QC++ --------
Key local override:
"worldtype" - set this on key & override the map setting
- use "-1" for a 0 override
- allow all 6 keys on 1 map
note: gold and silver keys all do the same thing, open the appropriate door
*/

void() item_key1 =
{
// if no override was provided on map, set to world value
	if (!self.worldtype) self.worldtype = world.worldtype;

	if (!self.model) // allow next function to come here & not run this set
	{
		if (self.worldtype < 1) // a negative value on local key ent will override world.worldtype as self.worldtype == 0
		{
			precache_model ("progs/w_s_key.mdl");
			setmodel (self, "progs/w_s_key.mdl");
			self.netname = "silver key";
		}
		if (self.worldtype == 1) // bounds checking - > 1 and < 2 will still fail
		{
			precache_model ("progs/m_s_key.mdl");
			setmodel (self, "progs/m_s_key.mdl");
			self.netname = "silver runekey";
		}
		if (self.worldtype >= 2) // note: failsafe on bogus worldtype now
		{
			precache_model2 ("progs/b_s_key.mdl");
			setmodel (self, "progs/b_s_key.mdl");
			self.netname = "silver keycard";
		}
	}
	key_setsounds();
	self.touch = key_touch;
	self.items = IT_KEY1;
	setsize (self, '-16 -16 -24', '16 16 32');
	StartItem ();
};

/*QUAKED item_key2 (0 .5 .8) (-16 -16 -24) (16 16 32)
GOLD key
In order for keys to work you MUST set your maps world.worldtype to one of the
following:
0: medieval
1: metal
2: base
(see worldspawn).

-------- QC++ --------
Key local override:
"worldtype" - set this on key & override the map setting
- use "-1" for a 0 override
- allow all 6 keys on 1 map
note: gold and silver keys all do the same thing, open the appropriate door
*/

void() item_key2 =
{
// if no override was provided on map, set to world value
	if (!self.worldtype) self.worldtype = world.worldtype;

	if (self.worldtype < 1)
	{
		precache_model ("progs/w_g_key.mdl");
		setmodel (self, "progs/w_g_key.mdl");
		self.netname = "gold key";
	}
	if (self.worldtype == 1)
	{
		precache_model ("progs/m_g_key.mdl");
		setmodel (self, "progs/m_g_key.mdl");
		self.netname = "gold runekey";
	}
	if (self.worldtype >= 2)
	{
		precache_model2 ("progs/b_g_key.mdl");
		setmodel (self, "progs/b_g_key.mdl");
		self.netname = "gold keycard";
	}
	item_key1();
//	key_setsounds();
//	self.touch = key_touch;
	self.items = IT_KEY2;
//	setsize (self, '-16 -16 -24', '16 16 32');
//	StartItem ();
};


/*QUAKED item_sigil (0 .5 .8) (-16 -16 -24) (16 16 32) E1 E2 E3 E4
End of level sigil, pick up to end episode and return to jrstart.
*/

void() item_sigil =
{
	if (!self.spawnflags)
#ifdef noobjerr
	{
		self.spawnflags = 1;
		self.button1 = rint(random() * 3);
		while (self.button1 > 0)
		{
			self.button1 = self.button1 - 1;
			self.spawnflags = self.spawnflags * 2;
		}
#ifdef xvars2
// future add cvar("svx_rndsigil") - random bit mask selector via rnd_bit
		if (cvar("svx_defsigil") & 15) self.spawnflags = cvar("svx_defsigil");
#endifdef
	}
#else
		objerror ("no spawnflags");					//opgrade protected
#endifdef

	precache_sound ("misc/runekey.wav");
	self.noise = "misc/runekey.wav";

	if (self.spawnflags & 1)
	{
		precache_model ("progs/end1.mdl");
		setmodel (self, "progs/end1.mdl");
	}
	if (self.spawnflags & 2)
	{
		precache_model2 ("progs/end2.mdl");
		setmodel (self, "progs/end2.mdl");
	}
	if (self.spawnflags & 4)
	{
		precache_model2 ("progs/end3.mdl");
		setmodel (self, "progs/end3.mdl");
	}
	if (self.spawnflags & 8)
	{
		precache_model2 ("progs/end4.mdl");
		setmodel (self, "progs/end4.mdl");
	}
	
	self.touch = sigil_touch;
	setsize (self, '-16 -16 -24', '16 16 32');
	StartItem ();
};


/*QUAKED item_artifact_invulnerability (0 .5 .8) (-16 -16 -24) (16 16 32)
Player is invulnerable for 30 seconds
*/

// generic wont work - again because above code goes by classname
// the most you would get is an invulnerable that is different in looks and sounds

void() item_artifact_invulnerability =
{
	/*
	self.touch = powerup_touch;
	precache_model ("progs/invulner.mdl");
	precache_sound ("items/protect.wav");
	precache_sound ("items/protect2.wav");
	precache_sound ("items/protect3.wav");
	self.noise = "items/protect.wav";
	setmodel (self, "progs/invulner.mdl");
	self.netname = "Pentagram of Protection";
	self.items = IT_INVULNERABILITY;
	setsize (self, '-16 -16 -24', '16 16 32');
	StartItem();
	*/
	item_invulnerability();
};

/*QUAKED item_artifact_envirosuit (0 .5 .8) (-16 -16 -24) (16 16 32)
Player takes no damage from water or slime for 30 seconds
*/
void() item_artifact_envirosuit =
{
	precache_model ("progs/suit.mdl");
	precache_sound ("items/suit.wav");
	precache_sound ("items/suit2.wav");
	self.noise = "items/suit.wav";
	setmodel (self, "progs/suit.mdl");
	self.netname = "Biosuit";
	self.items = IT_SUIT;
	setsize (self, '-16 -16 -24', '16 16 32');
	StartItem ();
};


/*QUAKED item_artifact_invisibility (0 .5 .8) (-16 -16 -24) (16 16 32)
Player is invisible for 30 seconds
*/
void() item_artifact_invisibility =
{
	self.touch = powerup_touch;
	precache_model ("progs/invisibl.mdl");
	precache_sound ("items/inv1.wav");
	precache_sound ("items/inv2.wav");
	precache_sound ("items/inv3.wav");
	self.noise = "items/inv1.wav";
	setmodel (self, "progs/invisibl.mdl");
	self.netname = "Ring of Shadows";
	self.items = IT_INVISIBILITY;
	setsize (self, '-16 -16 -24', '16 16 32');
	StartItem ();
};


/*QUAKED item_artifact_super_damage (0 .5 .8) (-16 -16 -24) (16 16 32)
The next attack from the player will do 4x damage
*/
void() item_artifact_super_damage =
{
	item_quad();
};

/*
===============================================================================

ARMOR

===============================================================================
*/

/*QUAKED item_armor1 (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() item_armor1 =
{
	self.touch = armor_touch;
	precache_model ("progs/armor.mdl");
	setmodel (self, "progs/armor.mdl");
	self.skin = 0;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};

/*QUAKED item_armor2 (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() item_armor2 =
{
	self.touch = armor_touch;
	precache_model ("progs/armor.mdl");
	setmodel (self, "progs/armor.mdl");
	self.skin = 1;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};

/*QUAKED item_armorInv (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() item_armorInv =
{
	self.touch = armor_touch;
	precache_model ("progs/armor.mdl");
	setmodel (self, "progs/armor.mdl");
	self.skin = 2;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};

/*
===============================================================================

WEAPONS

===============================================================================
*/

/*QUAKED weapon_nailgun (0 .5 .8) (-16 -16 0) (16 16 32)
*/
void() weapon_nailgun =
{
	weapon_machinegun(); //replace in maps with with weapon_machinegun
};


/*QUAKED weapon_supernailgun (0 .5 .8) (-16 -16 0) (16 16 32)
*/
void() weapon_supernailgun =
{
	weapon_chaingun(); //replace in maps with with weapon_chaingun
};

/*QUAKED weapon_lightning (0 .5 .8) (-16 -16 0) (16 16 32)
*/
void() weapon_lightning =
{
	weapon_hyperblaster(); //replace in maps with with weapon_hyperblaster
};


/*QUAKED item_health (.3 .3 1) (0 0 0) (32 32 32) rotten megahealth
Health box. Normally gives 25 points.
Rotten box heals 5-10 points,
megahealth will add 100 health, then 
rot you down to your maximum health limit, 
one point per second.
*/

#define	H_ROTTEN 1
#define	H_MEGA 2

//MrC: This will need probably need some special handling. 

/*
void() item_health =
{	
	self.touch = health_touch;

	if (self.spawnflags & H_ROTTEN)
	{
		precache_model("maps/b_bh10.bsp");
		precache_sound("items/r_item1.wav");
		setmodel(self, "maps/b_bh10.bsp");
		self.noise = "items/r_item1.wav";
		self.healamount = 15;
		self.healtype = 0;
	}
	else
	if (self.spawnflags & H_MEGA)
	{
		precache_model("maps/b_bh100.bsp");
		precache_sound("items/r_item2.wav");
		setmodel(self, "maps/b_bh100.bsp");
		self.noise = "items/r_item2.wav";
		self.healamount = 100;
		self.healtype = 2;
	}
	else
	{
		precache_model("maps/b_bh25.bsp");
		precache_sound("items/health1.wav");
		setmodel(self, "maps/b_bh25.bsp");
		self.noise = "items/health1.wav";
		self.healamount = 25;
		self.healtype = 1;
	}
	setsize (self, '0 0 0', '32 32 56');
	StartItem ();
};
*/