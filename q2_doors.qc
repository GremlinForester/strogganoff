

/*
================
door_touch

Prints messages and opens key doors
================
*/
void() q2door_touch =
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

	if ( (self.items & other.items) != self.items )
	{
		if (self.owner.items == IT_KEY_DATACD)
		{
				centerprint (other, "You need the data CD");
				sound (self, CHAN_VOICE, self.noise3, 1, ATTN_NORM);
		}
		else if (self.owner.items == IT_KEY_POWERCUBE)
		{
				centerprint (other, "You need a power cube");
				sound (self, CHAN_VOICE, self.noise3, 1, ATTN_NORM);
		}
		else if (self.owner.items == IT_KEY_PYRAMID)
		{
				centerprint (other, "You need the pyramid key");
				sound (self, CHAN_VOICE, self.noise3, 1, ATTN_NORM);
		}
		else if (self.owner.items == IT_KEY_DATASPINNER)
		{
				centerprint (other, "You need the data spinner");
				sound (self, CHAN_VOICE, self.noise3, 1, ATTN_NORM);
		}
		else if (self.owner.items == IT_KEY_PASS)
		{
				centerprint (other, "You need the security pass");
				sound (self, CHAN_VOICE, self.noise3, 1, ATTN_NORM);
		}
		else if (self.owner.items == IT_KEY_BLUE)
		{
				centerprint (other, "You need the blue keycard");
				sound (self, CHAN_VOICE, self.noise3, 1, ATTN_NORM);
		}
		else if (self.owner.items == IT_KEY_RED)
		{
				centerprint (other, "You need the red keycard");
				sound (self, CHAN_VOICE, self.noise3, 1, ATTN_NORM);
		}
		else if (self.owner.items == IT_KEY_HEAD)
		{
				centerprint (other, "You need to get a head");
				sound (self, CHAN_VOICE, self.noise3, 1, ATTN_NORM);
		}
		return;
	}

	other.items = other.items - self.items;
	self.touch = SUB_Null;
	if (self.enemy)
		self.enemy.touch = SUB_Null;	// get paired door
	door_use ();
};

void() spawn_q2_func_door = 
{
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

	if (self.spawnflags & DOOR_KEY_DATA_CD)
		self.items = IT_KEY_DATACD;
	
	if (self.spawnflags & DOOR_KEY_POWER_CUBE)
		self.items = IT_KEY_POWERCUBE;
	
	if (self.spawnflags & DOOR_KEY_PYRAMID)
		self.items = IT_KEY_PYRAMID;
	
	if (self.spawnflags & DOOR_KEY_DATA_SPINNER)
		self.items = IT_KEY_DATASPINNER;
	
	if (self.spawnflags & DOOR_KEY_PASS)
		self.items = IT_KEY_PASS;
	
	if (self.spawnflags & DOOR_KEY_BLUE_KEY)
		self.items = IT_KEY_BLUE;
	
	if (self.spawnflags & DOOR_KEY_RED_KEY)
		self.items = IT_KEY_RED;
	
	if (self.spawnflags & DOOR_KEY_COMMANDER_HEAD)
		self.items = IT_KEY_HEAD;
	
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
		
	self.touch = q2door_touch;

// LinkDoors can't be done until all of the doors have been spawned, so
// the sizes can be detected properly.
	self.think = LinkDoors;
	self.nextthink = self.ltime + 0.1;
}