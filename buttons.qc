// button and multiple button

void() button_wait;
void() button_return;

void() button_wait =
{
	self.state = STATE_TOP;
	self.nextthink = self.ltime + self.wait;
	self.think = button_return;
	activator = self.enemy;
	SUB_UseTargets();
	self.frame = 1;			// use alternate textures
};

void() button_done =
{
	self.state = STATE_BOTTOM;
};

void() button_return =
{
	self.state = STATE_DOWN;
	SUB_CalcMove (self.pos1, self.speed, button_done);
	self.frame = 0;			// use normal textures
	if (self.health)
		self.takedamage = DAMAGE_YES;	// can be shot again
};


#define button_blocked SUB_Null
/*

duplicates SUB_Null

void() button_blocked =
{	// do nothing, just don't ome all the way back out
};

*/

void() button_fire =
{
	if (self.state == STATE_UP || self.state == STATE_TOP)
		return;

	sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);

	self.state = STATE_UP;
	SUB_CalcMove (self.pos2, self.speed, button_wait);
};


void() button_use =
{
	self.enemy = activator;
	button_fire ();
};

#define REMOVE_KEY	1

void() button_touch =
{
	local string keyname;
	
	if (other.classname != "player")
		return;
//	self.enemy = other;

	if (self.attack_finished > time)
		return;

	self.attack_finished = time + 2;

// key door stuff
	if (!self.items){
		button_fire();
	}

	switch(self.items){
		case IT_KEY_DATACD:
			keyname = "Data CD";
			break;
		case IT_KEY_POWERCUBE:
			keyname = "Power Cube";
			break;
		case IT_KEY_PYRAMID:
			keyname = "Pyramid Key";
			break;
		case IT_KEY_DATASPINNER:
			keyname = "Data Spinner";
			break;			
		case IT_KEY_PASS:
			keyname = "Security Pass";
			break;
		case IT_KEY_BLUE:
			keyname = "Blue Key";
			break;
		case IT_KEY_RED:
			keyname = "Red Key";
			break;
		case IT_KEY_HEAD:
			keyname = "Head Key";
			break;
	}
	
	if ( (self.items & other.items) != self.items )
	{
		if (self.items == IT_KEY_DATACD)
		{
				centerprint (other, "You need the data CD");
				sound (self, CHAN_VOICE, self.noise3, 1, ATTN_NORM);
		}
		else if (self.items == IT_KEY_POWERCUBE)
		{
				centerprint (other, "You need a power cube");
				sound (self, CHAN_VOICE, self.noise3, 1, ATTN_NORM);
		}
		else if (self.items == IT_KEY_PYRAMID)
		{
				centerprint (other, "You need the pyramid key");
				sound (self, CHAN_VOICE, self.noise3, 1, ATTN_NORM);
		}
		else if (self.owner.items == IT_KEY_DATASPINNER)
		{
				centerprint (other, "You need the data spinner");
				sound (self, CHAN_VOICE, self.noise3, 1, ATTN_NORM);
		}
		else if (self.items == IT_KEY_PASS)
		{
				centerprint (other, "You need the security pass");
				sound (self, CHAN_VOICE, self.noise3, 1, ATTN_NORM);
		}
		else if (self.items == IT_KEY_BLUE)
		{
				centerprint (other, "You need the blue keycard");
				sound (self, CHAN_VOICE, self.noise3, 1, ATTN_NORM);
		}
		else if (self.items == IT_KEY_RED)
		{
				centerprint (other, "You need the red keycard");
				sound (self, CHAN_VOICE, self.noise3, 1, ATTN_NORM);
		}
		else if (self.items == IT_KEY_HEAD)
		{
				centerprint (other, "You need to get a head");
				sound (self, CHAN_VOICE, self.noise3, 1, ATTN_NORM);
		}
		return;
	}

	if (self.spawnflags & REMOVE_KEY){
		centerprint (other, strcat("Access granted: ", keyname, " removed."));
		other.items = other.items - self.items;
		button_fire();
		return;
	}

	button_fire();
};

void() button_killed =
{
	self.enemy = damage_attacker;
	self.health = self.max_health;
	self.takedamage = DAMAGE_NO;	// wil be reset upon return
	button_fire ();
};


/*QUAKED func_button (0 .5 .8) ?
When a button is touched, it moves some distance in the direction of it's angle, triggers all of it's targets, waits some time, then returns to it's original position where it can be triggered again.

"angle"		determines the opening direction
"target"	all entities with a matching targetname will be used
"speed"		override the default 40 speed
"wait"		override the default 1 second wait (-1 = never return)
"lip"		override the default 4 pixel lip remaining at end of move
"health"	if set, the button must be killed instead of touched
"sounds"
0) steam metal
1) wooden clunk
2) metallic click
3) in-out
*/

void() func_button =
{
	if (!self.sounds || self.sounds == 1)
	{
		precache_sound ("");
		self.noise = "";
	}
	if (self.sounds == 2)
	{
		precache_sound ("buttons/airbut1.wav");
		self.noise = "buttons/airbut1.wav";
	}	
	if (self.sounds == 3)
	{
		precache_sound ("buttons/switch21.wav");
		self.noise = "buttons/switch21.wav";
	}
	if (self.sounds == 4)
	{
		precache_sound ("buttons/switch02.wav");
		self.noise = "buttons/switch02.wav";
	}
	if (self.sounds == 5)
	{
		precache_sound ("buttons/switch04.wav");
		self.noise = "buttons/switch04.wav";
	}
	
	SetMovedir ();

	self.movetype = MOVETYPE_PUSH;
	self.solid = SOLID_BSP;
	setmodel (self, self.model);

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

	self.blocked = button_blocked;
	self.use = button_use;

	if (self.health)
	{
		self.max_health = self.health;
		self.th_die = button_killed;
		self.takedamage = DAMAGE_YES;
	}
	else
		self.touch = button_touch;

	if (!self.speed)
		self.speed = 40;
	if (!self.wait)
		self.wait = 1;
	if (!self.lip)
		self.lip = 4;

	self.state = STATE_BOTTOM;

	self.pos1 = self.origin;
	self.pos2 = self.pos1 + self.movedir*(fabs(self.movedir*self.size) - self.lip);
};

