/*
Adapted from Avirox's code
and doors.qc
*/

/*QUAKED func_door_rotating (0 .5 .8) ? START_OPEN REVERSE CRUSHER NOMONSTER ANIMATED TOGGLE X_AXIS Y_AXIS
TOGGLE causes the door to wait in both the start and end states for a trigger event.

START_OPEN	the door to moves to its destination when spawned, and operate in reverse.  It is used to temporarily or permanently close off an area when triggered (not useful for touch or takedamage doors).
NOMONSTER	monsters will not trigger this door

You need to have an origin brush as part of this entity.  The center of that brush will be
the point around which it is rotated. It will rotate around the Z axis by default.  You can
check either the X_AXIS or Y_AXIS box to change that.

"distance" is how many degrees the door will be rotated.
"speed" determines how fast the door moves; default value is 100.

REVERSE will cause the door to rotate in the opposite direction.

"message"	is printed when the door is touched if it is a trigger door and it hasn't been fired yet
"angle"		determines the opening direction
"targetname" if set, no touch field will be spawned and a remote button or trigger field activates the door.
"health"	if set, door must be shot open
"speed"		movement speed (100 default)
"wait"		wait before returning (3 default, -1 = never return)
"dmg"		damage to inflict when blocked (2 default)
"sounds"
0)		default
1)		silent
2-4		not used
5-99	custom sound- e.g. doors/dr05_strt.wav, doors/dr05_mid.wav, doors/dr05_end.wav
*/

void() rotatingdoor_touch;
void() rotatingdoor_go_down;
void() rotatingdoor_go_up;
void() rotatingdoor_fire;
void() rotatingdoor_use;

void() rotating_door_blocked =
{
	local entity t;
/*
	if (self.link)
	{
		t = self;
		self = find(world, linkname, self.link);
		self.blocked();
		self = t;
	}
*/
	T_Damage (other, self, self, self.dmg);
	
// if a door has a negative wait, it would never come back if blocked,
// so let it just squash the object to death real fast

	if (self.wait >= 0)
	{
		T_Damage (other, self, self, self.dmg);
		
	//	if (self.state == STATE_DOWN)
	//		rotatingdoor_go_up ();
	//	else
	//		rotatingdoor_go_down ();
	}
};

void() rotatingdoor_killed =
{
	local entity oself;
	
	oself = self;
	self = self.owner;
	self.health = self.max_health;
	self.takedamage = DAMAGE_NO;	// wil be reset upon return
	rotatingdoor_use ();
	self = oself;
};

void() rotatingdoor_hit_top =
{

	sound (self, CHAN_VOICE, self.noise1, 1, ATTN_NORM);
	self.state = STATE_TOP;

	if (self.spawnflags & DOOR_TOGGLE) {
		self.touch = SUB_Null;
		self.th_die = SUB_Null;
		return;		// don't come down automatically
	}
	self.think = rotatingdoor_go_down;
	self.nextthink = self.ltime + self.wait;
	if (self.health)
	{
		self.takedamage = 1;
		self.th_die = rotatingdoor_killed;
	}
};

void() rotatingdoor_hit_bottom =
{
	sound (self, CHAN_VOICE, self.noise1, 1, ATTN_NORM);
	self.state = STATE_BOTTOM;

	self.touch = rotatingdoor_touch;
	if (self.health)
	{
		self.takedamage = 1;
		self.th_die = rotatingdoor_killed;
	}
};

void() rotatingdoor_go_down =
{
	sound (self, CHAN_VOICE, self.noise2, 1, ATTN_NORM);
	if (self.max_health)
	{
		self.takedamage = DAMAGE_YES;
		self.health = self.max_health;
	}
	
	self.state = STATE_DOWN;
	SUB_CalcAngleMove (self.pos1, self.speed, rotatingdoor_hit_bottom);
	SUB_UseTargets();
	self.takedamage = 0;
};

void() rotatingdoor_go_up =
{
	if (self.state == STATE_UP)
		return;		// already going up

	if (self.state == STATE_TOP)
	{	// reset top wait time
		self.nextthink = self.ltime + self.wait;
		return;
	}
	
	sound (self, CHAN_VOICE, self.noise2, 1, ATTN_NORM);
	self.state = STATE_UP;
	SUB_CalcAngleMove (self.pos2, self.speed, rotatingdoor_hit_top);
	self.takedamage = 0;
	SUB_UseTargets();
};


void() rotatingdoor_use =
{
	local entity oself;

	self.enemy = self;
	self.owner = self;
	self.message = "";			// door message are for touch only
	self.owner.message = "";	
	self.enemy.message = "";
	oself = self;
	self = self.owner;
	rotatingdoor_fire ();
	self = oself;
};


void() rotatingdoor_fire =
{
	local entity 	oself;
	local entity	starte;

	if (self.owner != self)
		objerror ("rotatingdoor_fire: self.owner != self");

// play use key sound

	if (self.items)
		sound (self, CHAN_VOICE, self.noise4, 1, ATTN_NORM);

	self.message = string_null;		// no more message
	oself = self;

	if (self.spawnflags & DOOR_TOGGLE)
	{
		if (self.state == STATE_UP || self.state == STATE_TOP)
		{
			starte = self;
			do
			{
				rotatingdoor_go_down ();
				self = self.enemy;
			} while ( (self != starte) && (self != world) );
			self = oself;
			return;
		}
	}
	
// trigger all paired doors
	starte = self;

	do
	{
		self.goalentity = activator;		// Who fired us
		rotatingdoor_go_up ();
		self = self.enemy;
	} while ( (self != starte) && (self != world) );
	self = oself;
};

/*
================
door_touch

Prints messages and opens key doors
================
*/


void() rotatingdoor_touch =
{
	local entity finder_ent, te;
	if (other.classname != "player")
		return;
	if (self.owner.attack_finished > time)
		return;

		
	self.owner.attack_finished = time + 2;

	if (self.owner.message != "")
	{
		centerprint (other, self.owner.message);
		sound (other, CHAN_VOICE, "misc/talk.wav", 1, ATTN_NORM);
	}

	if (self.spawnflags & 16)
		return;
	if (!(self.spawnflags & 87907))
	{
		self.touch = SUB_Null;
		if (self.enemy)
		{
			self.enemy.touch = SUB_Null;
		}
		rotatingdoor_use();
		// linking rotating doors is fubar'd.. now we do it my way ;o
		finder_ent = find (world,targetname,self.targetname);
		while (finder_ent)
		{
			if ( finder_ent != self && finder_ent.classname == "door_rotating" && finder_ent.touch != SUB_Null )
			{
				te = self;
				self = finder_ent;
				self.touch();
				self = te;
			}
			finder_ent = find (finder_ent, targetname, self.targetname);
		}
	}
};

float DOOR_REVERSE		= 2;
float DOOR_X_AXIS		= 64;
float DOOR_Y_AXIS		= 128;

void() func_door_rotating =
{
	if (world.worldtype == 0)
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
	else
	{
		dprint ("no worldtype set!\n");
	}
	if (self.sounds == 0)
	{
		precache_sound ("misc/null.wav");
		precache_sound ("misc/null.wav");
		self.noise1 = "misc/null.wav";
		self.noise2 = "misc/null.wav";
	}
	if (self.sounds == 1)
	{
		precache_sound ("doors/drclos4.wav");
		precache_sound ("doors/doormv1.wav");
		self.noise1 = "doors/drclos4.wav";
		self.noise2 = "doors/doormv1.wav";
	}
	if (self.sounds == 2)
	{
		precache_sound ("doors/hydro1.wav");
		precache_sound ("doors/hydro2.wav");
		self.noise2 = "doors/hydro1.wav";
		self.noise1 = "doors/hydro2.wav";
	}
	if (self.sounds == 3)
	{
		precache_sound ("doors/stndr1.wav");
		precache_sound ("doors/stndr2.wav");
		self.noise2 = "doors/stndr1.wav";
		self.noise1 = "doors/stndr2.wav";
	}
	if (self.sounds == 4)
	{
		precache_sound ("doors/ddoor1.wav");
		precache_sound ("doors/ddoor2.wav");
		self.noise1 = "doors/ddoor2.wav";
		self.noise2 = "doors/ddoor1.wav";
	}

	if (self.spawnflags & DOOR_X_AXIS)
		self.movedir_z = 1.0;
	else if (self.spawnflags & DOOR_Y_AXIS)
		self.movedir_x = 1.0;
	else // Z_AXIS
		self.movedir_y = 1.0;

	// check for reverse rotation
	if (self.spawnflags & DOOR_REVERSE)
		self.movedir = '0 0 0' - self.movedir;



	self.max_health = self.health;
	self.solid = SOLID_BSP;
	self.movetype = MOVETYPE_PUSH;
	setorigin (self, self.origin);  
	setmodel (self, self.model);
	
	self.classname = "door_rotating";

	self.blocked = rotating_door_blocked;
	self.use = rotatingdoor_use;
	
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


	self.pos1 = self.angles;
	self.pos2 = self.angles + self.movedir * self.distance;

// DOOR_START_OPEN is to allow an entity to be lighted in the closed position
// but spawn in the open position
	if (self.spawnflags & DOOR_START_OPEN)
	{
		self.pos1 = self.angles;
	}	

	self.state = STATE_BOTTOM;

	if (self.health)
	{
		self.takedamage = DAMAGE_YES;
//		self.th_die = rotatingdoor_killed;
	}
	
	if (self.items)
		self.wait = -1;
		
	self.touch = rotatingdoor_touch;

	if (self.targetname) {		// Door is locked if it must be triggered
		self.touch = SUB_Null;
		self.th_die = SUB_Null;
	}
	self.owner = self.enemy = self;
};
