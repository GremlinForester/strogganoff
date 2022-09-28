void() plat_spawn_inside_trigger =
{
#define trigger self.oldenemy
//	local entity	trigger;

#define tmin trigger.dest1
// this is the only way to use vector float components on a define - yeah, sucks, but this case saves 8 globals
#define tmin_x trigger.dest1_x
#define tmin_y trigger.dest1_y
#define tmin_z trigger.dest1_z
#define tmax trigger.dest2
#define tmax_x trigger.dest2_x
#define tmax_y trigger.dest2_y
#define tmax_z trigger.dest2_z
//	local vector	tmin, tmax;

//
// middle trigger
//	
	trigger = spawn();
	trigger.touch = plat_center_touch;
//	trigger.movetype = MOVETYPE_NONE;
	trigger.solid = SOLID_TRIGGER;
	trigger.enemy = self;
	
	tmin = self.mins + '25 25 0';
	tmax = self.maxs - '25 25 -8';
	//tmin_z = tmax_z - (self.pos1_z - self.pos2_z + 8);
	tmin_z = tmax_z - (self.pos1_z - self.pos2_z + self.lip);
	if (self.spawnflags & PLAT_LOW_TRIGGER)
		tmax_z = tmin_z + 8;
	
	if (self.size_x <= 50)
	{
		tmin_x = (self.mins_x + self.maxs_x) / 2;
		tmax_x = tmin_x + 1;
	}
	if (self.size_y <= 50)
	{
		tmin_y = (self.mins_y + self.maxs_y) / 2;
		tmax_y = tmin_y + 1;
	}
	
	setsize (trigger, tmin, tmax);

#undef trigger
// and if we would leave these defined and any future code (after this in source) uses tmin or tmax, we could have fail
#undef tmin
#undef tmin_x
#undef tmin_y
#undef tmin_z
#undef tmax
#undef tmax_x
#undef tmax_y
#undef tmax_z
};

void() plat_hit_top =
{
	sound (self, CHAN_VOICE, self.noise1, 1, ATTN_NORM);
	self.state = STATE_TOP;
	self.think = plat_go_down;
	self.nextthink = self.ltime + 3;
};

#define plat_hit_bottom		door_hit_bottom

/*
duplicates door_hit_bottom

void() plat_hit_bottom =
{
	sound (self, CHAN_VOICE, self.noise1, 1, ATTN_NORM);
	self.state = STATE_BOTTOM;
};
*/

void() plat_go_down =
{
	sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);
	self.state = STATE_DOWN;
	SUB_CalcMove (self.pos2, self.speed, plat_hit_bottom);
};

void() plat_go_up =
{
	sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);
	self.state = STATE_UP;
	SUB_CalcMove (self.pos1, self.speed, plat_hit_top);
};

void() plat_center_touch =
{
	if (other.classname != "player")
		return;
		
	if (other.health <= 0)
		return;

	self = self.enemy;
	if (self.state == STATE_BOTTOM)
		plat_go_up ();
	else if (self.state == STATE_TOP)
		self.nextthink = self.ltime + 1;	// delay going down
};

void() plat_outside_touch =
{
	if (other.classname != "player")
		return;

	if (other.health <= 0)
		return;
		
//dprint ("plat_outside_touch\n");
	self = self.enemy;
	if (self.state == STATE_TOP)
		plat_go_down ();
};

void() plat_trigger_use =
{
	if (self.think)
		return;		// allready activated
	plat_go_down();
};


void() plat_crush =
{
//dprint ("plat_crush\n");

	T_Damage (other, self, self, 1);
	
	if (self.state == STATE_UP)
		plat_go_down ();
	else if (self.state == STATE_DOWN)
		plat_go_up ();
	else
#ifdef noobjerr
	{
#ifdef xvars1
		if (cvar("svx_platdoorfail") < 0) // remove option
		{
			remove(self);
			return;
		}
		if (cvar("svx_platdoorfail") > 0) // attempt some fix - MUST be tested !
		{
			self.state = STATE_DOWN;
			plat_go_up();
		}
		else
#endif
		{
			self.velocity = '0 0 0';
			return; // dont go away mad - just go away
		}
	}
#else
		objerror ("plat_crush: bad self.state\n");					//opgrade protected
#endif
};

void() plat_use =
{
	self.use = SUB_Null;
	if (self.state != STATE_UP)
#ifdef noobjerr
	{

#ifdef xvars1
		if (cvar("svx_platdoorfail") < 0) // remove option
		{
			remove(self);
			return;
		}
		if (cvar("svx_platdoorfail") > 0) // attempt some fix - MUST be tested !
		{
			self.state = STATE_UP;
		}
		else
#endif
		{
			self.velocity = '0 0 0';
			return;
		}
	}
#else
		objerror ("plat_use: not in up state");					//opgrade protected
#endif
	plat_go_down();
};


/*QUAKED func_plat (0 .5 .8) ? PLAT_LOW_TRIGGER
speed	default 150

Plats are always drawn in the extended position, so they will light correctly.

If the plat is the target of another trigger or button, it will start out disabled in the extended position until it is trigger, when it will lower and become a normal plat.

If the "height" key is set, that will determine the amount the plat moves, instead of being implicitly determined by the model's height.
Set "sounds" to one of the following:
1) base fast
2) chain slow
*/


void() func_plat =

{
//local entity t;	// fx_warning

	if (!self.t_length)
		self.t_length = 80;
	if (!self.t_width)
		self.t_width = 10;

	if (! self.sounds) // == 0)
		self.sounds = 2;
// FIX THIS TO LOAD A GENERIC PLAT SOUND

	if (self.sounds == 1)
	{
		precache_sound ("plats/pt1_mid.wav");
		precache_sound ("plats/pt1_end.wav");
		self.noise = "plats/pt1_mid.wav";
		self.noise1 = "plats/pt1_end.wav";
	}

	if (self.sounds == 2)
	{/*
		precache_sound ("plats/medplat1.wav");
		precache_sound ("plats/medplat2.wav");
		self.noise = "plats/medplat1.wav";
		self.noise1 = "plats/medplat2.wav";
		*/
				precache_sound ("plats/pt1_mid.wav");
		precache_sound ("plats/pt1_end.wav");
		self.noise = "plats/pt1_mid.wav";
		self.noise1 = "plats/pt1_end.wav";
	}


	self.mangle = self.angles;
	self.angles = '0 0 0';

	self.classname = "plat";
	self.solid = SOLID_BSP;
	self.movetype = MOVETYPE_PUSH;
	setorigin (self, self.origin);	
	setmodel (self, self.model);
	setsize (self, self.mins , self.maxs);

	self.blocked = plat_crush;
	if (!self.speed)
		self.speed = 150;

// pos1 is the top position, pos2 is the bottom
	self.pos1 = self.origin;
	self.pos2 = self.origin;
/*
	if (self.height)
		self.pos2_z = self.origin_z - self.height;
	else
		self.pos2_z = self.origin_z - self.size_z + 8;
*/

	if (self.height)
		self.pos2_z = self.origin_z - self.height;
	else
		self.pos2_z = (self.origin_z - self.size_z) + self.lip;

/*
	if (self.height)
		self.pos2_z -= self.height;
	else
		self.pos2_z -= (self.maxs_z - self.mins_z) - self.lip;	
*/

	self.use = plat_trigger_use;

	plat_spawn_inside_trigger ();	// the "start moving" trigger	

	if (self.targetname)
	{
		self.state = STATE_UP;
		self.use = plat_use;
	}
	else
	{
		setorigin (self, self.pos2);
		self.state = STATE_BOTTOM;
	}
};
