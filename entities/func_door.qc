/*

Doors are similar to buttons, but can spawn a fat trigger field around them
to open without a touch, and they link together to form simultanious
double/quad doors.
 
Door.owner is the master door.  If there is only one door, it points to itself.
If multiple doors, all will point to a single one.

Door.enemy chains from the master door through all doors linked in the chain.

*/

/*
================
q2door_touch

Prints messages and opens key doors
================
*/
void() q2door_touch =
{
	if ((self.owner.spawnflags & NOMONSTER) && (other.flags & FL_MONSTER))
		return;	
	
	if (other.classname != "player")
		return;
	
	if (self.owner.attack_finished > time)
		return;

	self.owner.attack_finished = time + 2;

	if (self.owner.message) // != string_null)
	{
		centerprint (other, self.owner.message);
		sound (other, CHAN_VOICE, "misc/talk.wav", 1, ATTN_NORM);
	}
	
// key door stuff
	if (!self.items_q2keys)
		return;

	if ( (self.items_q2keys & other.items_q2keys) != self.items_q2keys )
	{
		if (self.owner.items_q2keys == IT_KEY_DATACD)
		{
				centerprint (other, "You need the data CD");
				sound (self, CHAN_VOICE, self.noise3, 1, ATTN_NORM);
		}
		else if (self.owner.items_q2keys == IT_KEY_POWERCUBE)
		{
				centerprint (other, "You need a power cube");
				sound (self, CHAN_VOICE, self.noise3, 1, ATTN_NORM);
		}
		else if (self.owner.items_q2keys == IT_KEY_PYRAMID)
		{
				centerprint (other, "You need the pyramid key");
				sound (self, CHAN_VOICE, self.noise3, 1, ATTN_NORM);
		}
		else if (self.owner.items_q2keys == IT_KEY_DATASPINNER)
		{
				centerprint (other, "You need the data spinner");
				sound (self, CHAN_VOICE, self.noise3, 1, ATTN_NORM);
		}
		else if (self.owner.items_q2keys == IT_KEY_PASS)
		{
				centerprint (other, "You need the security pass");
				sound (self, CHAN_VOICE, self.noise3, 1, ATTN_NORM);
		}
		else if (self.owner.items_q2keys == IT_KEY_BLUE)
		{
				centerprint (other, "You need the blue keycard");
				sound (self, CHAN_VOICE, self.noise3, 1, ATTN_NORM);
		}
		else if (self.owner.items_q2keys == IT_KEY_RED)
		{
				centerprint (other, "You need the red keycard");
				sound (self, CHAN_VOICE, self.noise3, 1, ATTN_NORM);
		}
		else if (self.owner.items_q2keys == IT_KEY_HEAD)
		{
				centerprint (other, "You need to get a head");
				sound (self, CHAN_VOICE, self.noise3, 1, ATTN_NORM);
		}
		return;
	}

	other.items_q2keys = other.items_q2keys - self.items_q2keys;
	self.touch = SUB_Null;
	if (self.enemy)
		self.enemy.touch = SUB_Null;	// get paired door
	door_use ();
};

void() spawn_q2_func_door = 
{
	if (!self.sounds) //Silent
	{
		precache_sound ("misc/null.wav");
		precache_sound ("misc/null.wav");
		self.noise1 = "misc/null.wav";
		self.noise2 = "misc/null.wav";
	}
	if (self.sounds == 1) //Stone
	{
		precache_sound ("doors/drclos4.wav");
		precache_sound ("doors/doormv1.wav");
		self.noise1 = "doors/drclos4.wav";
		self.noise2 = "doors/doormv1.wav";
	}
	if (self.sounds == 2) //Machine
	{
		precache_sound ("doors/hydro1.wav");
		precache_sound ("doors/hydro2.wav");
		self.noise2 = "doors/hydro1.wav";
		self.noise1 = "doors/hydro2.wav";
	}
	if (self.sounds == 3) //Stone Chain
	{
		precache_sound ("doors/stndr1.wav");
		precache_sound ("doors/stndr2.wav");
		self.noise2 = "doors/stndr1.wav";
		self.noise1 = "doors/stndr2.wav";
	}
	if (self.sounds == 4) //Screechy Metal
	{
		precache_sound ("doors/ddoor1.wav");
		precache_sound ("doors/ddoor2.wav");
		self.noise1 = "doors/ddoor2.wav";
		self.noise2 = "doors/ddoor1.wav";
	}
	if (self.sounds == 5) //Quake 2 Door
	{
	//	precache_sound ("doors/dr1_strt.wav");
		precache_sound ("doors/dr1_mid.wav");
		precache_sound ("doors/dr1_end.wav");
		self.noise1 = "doors/dr1_end.wav";
		self.noise2 = "doors/dr1_mid.wav";
	}	

	SetMovedir ();

	self.max_health = self.health;
	self.solid = SOLID_BSP;
	self.movetype = MOVETYPE_PUSH;
	setorigin (self, self.origin);	
	setmodel (self, self.model);
	self.classname = "door";

	self.blocked = door_blocked;
	self.use = door_use;

	if (self.spawnflags & DOOR_KEY_DATA_CD)
		self.items_q2keys = IT_KEY_DATACD;
	
	if (self.spawnflags & DOOR_KEY_POWER_CUBE)
		self.items_q2keys = IT_KEY_POWERCUBE;
	
	if (self.spawnflags & DOOR_KEY_PYRAMID)
		self.items_q2keys = IT_KEY_PYRAMID;
	
	if (self.spawnflags & DOOR_KEY_DATA_SPINNER)
		self.items_q2keys = IT_KEY_DATASPINNER;
	
	if (self.spawnflags & DOOR_KEY_PASS)
		self.items_q2keys = IT_KEY_PASS;
	
	if (self.spawnflags & DOOR_KEY_BLUE_KEY)
		self.items_q2keys = IT_KEY_BLUE;
	
	if (self.spawnflags & DOOR_KEY_RED_KEY)
		self.items_q2keys = IT_KEY_RED;
	
	if (self.spawnflags & DOOR_KEY_COMMANDER_HEAD)
		self.items_q2keys = IT_KEY_HEAD;
	
	if (!self.speed)
		self.speed = 100;
	if (!self.wait)
		self.wait = 3;
	if (!self.lip)
		self.lip = 8;
	if (!self.dmg)
		self.dmg = 2;
	
	if (self.items_q2keys)
	{
		precache_sound ("misc/keytry.wav");
		precache_sound ("misc/keyuse.wav");			
		self.noise3 = "misc/keytry.wav";
		self.noise4 = "misc/keyuse.wav";
	}

	self.pos1 = self.origin;
	self.pos2 = self.pos1 + self.movedir*(fabs(self.movedir*self.size) - self.lip);

// DOOR_START_OPEN is to allow an entity to be lighted in the closed position
// but spawn in the open position
	if (self.spawnflags & DOOR_START_OPEN)
	{
		setorigin (self, self.pos2);
		self.pos2 = self.pos1;
		self.pos1 = self.origin;
	}

	self.state = STATE_BOTTOM;

	if (self.health)
	{
		self.takedamage = DAMAGE_YES;
		self.th_die = door_killed;
	}
	
	if (self.items_q2keys)
		self.wait = -1;
		
	self.touch = q2door_touch;

// LinkDoors can't be done until all of the doors have been spawned, so
// the sizes can be detected properly.
	self.think = LinkDoors;
	self.nextthink = self.ltime + 0.1;
}

/*
=============================================================================

THINK FUNCTIONS

=============================================================================
*/

void() door_blocked =
{
	if (self.spawnflags & CRUSHER)
	{
		T_Damage (other, self, self, self.dmg);
		return;
	}
	else
	{
		T_Damage (other, self, self, self.dmg);
		
		if (self.state == STATE_DOWN)
			door_go_up ();
		else
			door_go_down ();
	}
	
// if a door has a negative wait, it would never come back if blocked,
// so let it just squash the object to death real fast
/*
	if (self.wait >= 0)
	{
		if (self.state == STATE_DOWN)
			door_go_up ();
		else
			door_go_down ();
	}
	*/
};

void() door_hit_top =
{
	sound (self, CHAN_VOICE, self.noise1, 1, ATTN_NORM);
	self.state = STATE_TOP;
	if (self.spawnflags & DOOR_TOGGLE)
		return;		// don't come down automatically
	self.think = door_go_down;
	self.nextthink = self.ltime + self.wait;
};

void() door_hit_bottom =
{
	sound (self, CHAN_VOICE, self.noise1, 1, ATTN_NORM);
	self.state = STATE_BOTTOM;
};

void() door_go_down =
{
	sound (self, CHAN_VOICE, self.noise2, 1, ATTN_NORM);
	if (self.max_health)
	{
		self.takedamage = DAMAGE_YES;
		self.health = self.max_health;
	}
	
	self.state = STATE_DOWN;
	SUB_CalcMove (self.pos1, self.speed, door_hit_bottom);
};

void() door_go_up =
{
	if (self.state == STATE_UP)
		return;		// allready going up

	if (self.state == STATE_TOP)
	{	// reset top wait time
		self.nextthink = self.ltime + self.wait;
		return;
	}
	
	sound (self, CHAN_VOICE, self.noise2, 1, ATTN_NORM);
	self.state = STATE_UP;
	SUB_CalcMove (self.pos2, self.speed, door_hit_top);

	SUB_UseTargets();
};


/*
=============================================================================

ACTIVATION FUNCTIONS

=============================================================================
*/

void() door_fire =
{
	local entity 	oself;
	local entity	starte;

	if (self.owner != self)
#ifdef noobjerr
	{
#ifdef xvars1
		if (cvar("svx_platdoorfail") < 0) // remove option
		{
			remove(self);
			return;
		}
#endif
		self.owner = self;

	}
#else
		objerror ("door_fire: self.owner != self");					//opgrade protected
#endif

// play use key sound

	if (self.items_q2keys)
		sound (self, CHAN_AUTO, self.noise4, 1, ATTN_NORM);

	self.message = string_null;		// no more message
	oself = self;

	if (self.spawnflags & DOOR_TOGGLE)
	{
		if (self.state == STATE_UP || self.state == STATE_TOP)
		{
			starte = self;
			do
			{
				door_go_down ();
				self = self.enemy;
			} while ( (self != starte) && (self) );// != world) );
			self = oself;
			return;
		}
	}
	
// trigger all paired doors
	starte = self;
	do
	{
		door_go_up ();
		self = self.enemy;
	} while ( (self != starte) && (self) );// != world) );
	self = oself;
};


void() door_use =
{
	local entity oself;
	
	self.message = string_null;			// door message are for touch only
	self.owner.message = string_null;	
	self.enemy.message = string_null;
	oself = self;
	self = self.owner;
	door_fire ();
	self = oself;
};


void() door_trigger_touch =
{
	if ((self.owner.spawnflags & NOMONSTER) && (other.flags & FL_MONSTER))
		return;
	
	if (other.health <= 0)
		return;

	if (time < self.attack_finished)
		return;
	self.attack_finished = time + 1;

	activator = other;

	self = self.owner;
	door_use ();
};


void() door_killed =
{
	local entity oself;
	
	oself = self;
	self = self.owner;
	self.health = self.max_health;
	self.takedamage = DAMAGE_NO;	// wil be reset upon return
	door_use ();
	self = oself;
};


/*
================
door_touch

Prints messages and opens key doors
================
*/
void() door_touch =
{
	if (other.classname != "player")
		return;
	if (self.owner.attack_finished > time)
		return;

	self.owner.attack_finished = time + 2;

	if (self.owner.message) // != string_null)
	{
		centerprint (other, self.owner.message);
		sound (other, CHAN_VOICE, "misc/talk.wav", 1, ATTN_NORM);
	}
	
// key door stuff
	if (!self.items)
		return;

// FIXME: blink key on player's status bar
	if ( (self.items & other.items) != self.items )
	{
		if (self.owner.items == IT_KEY1)
		{
			if (world.worldtype == 2)
			{
				centerprint (other, "You need the silver keycard");
				sound (self, CHAN_VOICE, self.noise3, 1, ATTN_NORM);
			}
			else if (world.worldtype == 1)
			{
				centerprint (other, "You need the silver runekey");
				sound (self, CHAN_VOICE, self.noise3, 1, ATTN_NORM);
			}
			else if (! world.worldtype)// == 0)
			{
				centerprint (other, "You need the silver key");
				sound (self, CHAN_VOICE, self.noise3, 1, ATTN_NORM);
			}
		}
		else
		{
			if (world.worldtype == 2)
			{
				centerprint (other, "You need the gold keycard");
				sound (self, CHAN_VOICE, self.noise3, 1, ATTN_NORM);
			}
			else if (world.worldtype == 1)
			{
				centerprint (other, "You need the gold runekey");
				sound (self, CHAN_VOICE, self.noise3, 1, ATTN_NORM);			
			}
			else if (! world.worldtype) // == 0)
			{
				centerprint (other, "You need the gold key");
				sound (self, CHAN_VOICE, self.noise3, 1, ATTN_NORM);
			}
		}
		return;
	}

	other.items = other.items - self.items;
	self.touch = SUB_Null;
	if (self.enemy)
		self.enemy.touch = SUB_Null;	// get paired door
	door_use ();
};

/*
=============================================================================

SPAWNING FUNCTIONS

=============================================================================
*/


entity(vector fmins, vector fmaxs) spawn_field =
{
#define trigger self.oldenemy
//	local entity	trigger;
//	local	vector	t1, t2;

	trigger = spawn();
//	trigger.movetype = MOVETYPE_NONE;
	trigger.solid = SOLID_TRIGGER;
	trigger.owner = self;
	trigger.touch = door_trigger_touch;

//	t1 = fmins;
//	t2 = fmaxs;
	setsize (trigger, fmins - '60 60 8', fmaxs + '60 60 8');
	return (trigger);

#undef trigger
};


float (entity e1, entity e2) EntitiesTouching =
{
	if (e1.mins_x > e2.maxs_x)
		return FALSE;
	if (e1.mins_y > e2.maxs_y)
		return FALSE;
	if (e1.mins_z > e2.maxs_z)
		return FALSE;
	if (e1.maxs_x < e2.mins_x)
		return FALSE;
	if (e1.maxs_y < e2.mins_y)
		return FALSE;
	if (e1.maxs_z < e2.mins_z)
		return FALSE;
	return TRUE;
};


/*
=============
LinkDoors


=============
*/
void() LinkDoors =
{
	local entity	t, starte;
	local vector	cmins, cmaxs;

	if (self.enemy)
		return;		// already linked by another door
	if (self.spawnflags & 4)
	{
		self.owner = self.enemy = self;
		return;		// don't want to link this door
	}

	cmins = self.mins;
	cmaxs = self.maxs;
	
	starte = self;
	t = self;
	
	do
	{
		self.owner = starte;			// master door

		if (self.health)
			starte.health = self.health;
		if (self.targetname)
			starte.targetname = self.targetname;
		if (self.message) // != string_null)
			starte.message = self.message;

		t = find (t, classname, self.classname);	
		if (!t)
		{
			self.enemy = starte;		// make the chain a loop

		// shootable, fired, or key doors just needed the owner/enemy links,
		// they don't spawn a field
	
			self = self.owner;

			if (self.health)
				return;
			if (self.targetname)
				return;
			if (self.items_q2keys)
				return;

			self.owner.trigger_field = spawn_field(cmins, cmaxs);

			return;
		}

		if (EntitiesTouching(self,t))
		{
			if (t.enemy)
#ifdef noobjerr
			{
/*
// alternate possibly safer code			
			{
				remove(t);
				return;
			}
*/
#ifdef xvars1
				if (cvar("svx_platdoorfail") < 0) // remove option
				{
					remove(t);
					continue;
				}
#endif
				t.enemy = world; // find a way to test this - what will it really do...

			}
#else
				objerror ("cross connected doors");					//opgrade protected
#endif

			self.enemy = t;
			self = t;

			if (t.mins_x < cmins_x)
				cmins_x = t.mins_x;
			if (t.mins_y < cmins_y)
				cmins_y = t.mins_y;
			if (t.mins_z < cmins_z)
				cmins_z = t.mins_z;
			if (t.maxs_x > cmaxs_x)
				cmaxs_x = t.maxs_x;
			if (t.maxs_y > cmaxs_y)
				cmaxs_y = t.maxs_y;
			if (t.maxs_z > cmaxs_z)
				cmaxs_z = t.maxs_z;
		}
	} while (1 );

};


/*QUAKED func_door (0 .5 .8) ? START_OPEN x DOOR_DONT_LINK GOLD_KEY SILVER_KEY TOGGLE
if two doors touch, they are assumed to be connected and operate as a unit.

TOGGLE causes the door to wait in both the start and end states for a trigger event.

START_OPEN causes the door to move to its destination when spawned, and operate in reverse.  It is used to temporarily or permanently close off an area when triggered (not usefull for touch or takedamage doors).

Key doors are allways wait -1.

"message"	is printed when the door is touched if it is a trigger door and it hasn't been fired yet
"angle"		determines the opening direction
"targetname" if set, no touch field will be spawned and a remote button or trigger field activates the door.
"health"	if set, door must be shot open
"speed"		movement speed (100 default)
"wait"		wait before returning (3 default, -1 = never return)
"lip"		lip remaining at end of move (8 default)
"dmg"		damage to inflict when blocked (2 default)
"sounds"
0)	no sound
1)	stone
2)	base
3)	stone chain
4)	screechy metal
*/

void() spawn_q1_func_door = 
{
	if (! world.worldtype) // == 0)
	{
		precache_sound ("doors/medtry.wav");
		precache_sound ("doors/meduse.wav");
		self.noise3 = "doors/medtry.wav";
		self.noise4 = "doors/meduse.wav";
	}
	else if (world.worldtype == 1)
	{
		precache_sound ("doors/runetry.wav");
		precache_sound ("doors/runeuse.wav");
		self.noise3 = "doors/runetry.wav";
		self.noise4 = "doors/runeuse.wav";
	}
	else if (world.worldtype == 2)
	{
		precache_sound ("doors/basetry.wav");
		precache_sound ("doors/baseuse.wav");
		self.noise3 = "doors/basetry.wav";
		self.noise4 = "doors/baseuse.wav";
	}
#ifndef nodprint
	else
	{
		dprint ("no worldtype set!\n");
	}
#endif
	if (!self.sounds || self.sounds == 1)
	{
		precache_sound ("misc/null.wav");
		precache_sound ("misc/null.wav");
		self.noise1 = "misc/null.wav";
		self.noise2 = "misc/null.wav";
	}
	if (self.sounds == 2)
	{
		precache_sound ("doors/drclos4.wav");
		precache_sound ("doors/doormv1.wav");
		self.noise1 = "doors/drclos4.wav";
		self.noise2 = "doors/doormv1.wav";
	}
	if (self.sounds == 3)
	{
		precache_sound ("doors/hydro1.wav");
		precache_sound ("doors/hydro2.wav");
		self.noise2 = "doors/hydro1.wav";
		self.noise1 = "doors/hydro2.wav";
	}
	if (self.sounds == 4)
	{
		precache_sound ("doors/stndr1.wav");
		precache_sound ("doors/stndr2.wav");
		self.noise2 = "doors/stndr1.wav";
		self.noise1 = "doors/stndr2.wav";
	}
	if (self.sounds == 5)
	{
		precache_sound ("doors/ddoor1.wav");
		precache_sound ("doors/ddoor2.wav");
		self.noise1 = "doors/ddoor2.wav";
		self.noise2 = "doors/ddoor1.wav";
	}

	SetMovedir ();

	self.max_health = self.health;
	self.solid = SOLID_BSP;
	self.movetype = MOVETYPE_PUSH;
	setorigin (self, self.origin);	
	setmodel (self, self.model);
	self.classname = "door";

	self.blocked = door_blocked;
	self.use = door_use;
	
	if (self.spawnflags & DOOR_SILVER_KEY)
		self.items = IT_KEY1;
	if (self.spawnflags & DOOR_GOLD_KEY)
		self.items = IT_KEY2;
	
	if (!self.speed)
		self.speed = 100;
	if (!self.wait)
		self.wait = 3;
	if (!self.lip)
		self.lip = 8;
	if (!self.dmg)
		self.dmg = 2;

	self.pos1 = self.origin;
	self.pos2 = self.pos1 + self.movedir*(fabs(self.movedir*self.size) - self.lip);

// DOOR_START_OPEN is to allow an entity to be lighted in the closed position
// but spawn in the open position
	if (self.spawnflags & DOOR_START_OPEN)
	{
		setorigin (self, self.pos2);
		self.pos2 = self.pos1;
		self.pos1 = self.origin;
	}

	self.state = STATE_BOTTOM;

	if (self.health)
	{
		self.takedamage = DAMAGE_YES;
		self.th_die = door_killed;
	}
	
	if (self.items)
		self.wait = -1;
		
	self.touch = door_touch;

// LinkDoors can't be done until all of the doors have been spawned, so
// the sizes can be detected properly.
	self.think = LinkDoors;
	self.nextthink = self.ltime + 0.1;
}

void() func_door =
{
	if (world.model == "maps/start.bsp"
	|| world.model == "maps/e1m1.bsp"
	|| world.model == "maps/e1m2.bsp"
	|| world.model == "maps/e1m3.bsp"
	|| world.model == "maps/e1m4.bsp"
	|| world.model == "maps/e1m5.bsp"
	|| world.model == "maps/e1m6.bsp"
	|| world.model == "maps/e1m7.bsp"
	|| world.model == "maps/e1m8.bsp"
	|| world.model == "maps/e2m1.bsp"
	|| world.model == "maps/e2m2.bsp"
	|| world.model == "maps/e2m3.bsp"
	|| world.model == "maps/e2m4.bsp"
	|| world.model == "maps/e2m5.bsp"
	|| world.model == "maps/e2m6.bsp"
	|| world.model == "maps/e2m7.bsp"
	|| world.model == "maps/e3m1.bsp"
	|| world.model == "maps/e3m2.bsp"
	|| world.model == "maps/e3m3.bsp"
	|| world.model == "maps/e3m4.bsp"
	|| world.model == "maps/e3m5.bsp"
	|| world.model == "maps/e3m6.bsp"
	|| world.model == "maps/e3m7.bsp"
	|| world.model == "maps/e4m1.bsp"
	|| world.model == "maps/e4m2.bsp"
	|| world.model == "maps/e4m3.bsp"
	|| world.model == "maps/e4m4.bsp"
	|| world.model == "maps/e4m5.bsp"
	|| world.model == "maps/e4m6.bsp"
	|| world.model == "maps/e4m7.bsp"
	|| world.model == "maps/e4m8.bsp"
	|| world.model == "maps/end.bsp"
	|| world.model == "maps/dm1.bsp"
	|| world.model == "maps/dm2.bsp"
	|| world.model == "maps/dm3.bsp"
	|| world.model == "maps/dm4.bsp"
	|| world.model == "maps/dm5.bsp"
	|| world.model == "maps/dm6.bsp")
	{
		spawn_q1_func_door();
	}
	else
	{
		spawn_q2_func_door();
	}

};
