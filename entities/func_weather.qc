
// ============================================================================
/*  Rain effect from dpmod
*/

var float autocvar_ent_rain = 1;
var float autocvar_ent_snow = 1;

void() rain_think =
{
	if(autocvar_ent_rain)
	{
		self.nextthink = time + 0.1;
		te_particlerain(self.absmin, self.absmax, self.dest, self.count, self.cnt);
	}
	else
	{ 
		remove(self);
	}
};

/*QUAKED func_rain (0 .5 .8) ?
This is an invisible area like a trigger, which rain falls inside of.

Keys:
"velocity"
 falling direction (should be something like '0 0 -700', use the X and Y velocity for wind)
"cnt"
 sets color of rain (default 12 - white)
"count"
 adjusts rain density, this many particles fall every second, experiment to see the effects (default is based on area size)
*/

void() rain_small_think =
{
	self.nextthink = time + self.pausetime;
	te_particlerain(self.absmin, self.absmax, self.dest, self.count, self.cnt);
};


void() rain_init =
{
	if (!self.dest)
		self.dest = '0 0 -700';
	if (!self.cnt)
		self.cnt = 2;
	if (!self.count) self.count = 1;
	self.count = self.count * fabs((self.absmax_x - self.absmin_x)*(self.absmax_y - self.absmin_y)/16384);
	self.count = self.count * autocvar_ent_rain;
	if (self.count < 0.01)
	{
		remove(self);
		return;
	}
	if (self.count < 1) 
	{ 
		if ( self.count < 0.4 ) 
		{
			//self.cnt = self.cnt*self.count*2.5;
			self.pausetime = 0.25;
		}
		else self.pausetime = 0.1/self.count;
		self.count = 1;
		self.think = rain_small_think;
	}
	else self.think = rain_think;
	self.nextthink = time + 0.1;
};


void() func_rain =
{
	self.dest = self.velocity;
	self.velocity = '0 0 0';
	if (!self.dest)
		self.dest = '0 0 -700';
	self.angles = '0 0 0';
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	setmodel(self, self.model);
	setorigin(self, self.origin);
	setsize(self, self.mins, self.maxs);
	self.model = "";
	if (!self.cnt)
		self.cnt = 12;
	if (!self.count)
		self.count = (self.absmax_x - self.absmin_x)*(self.absmax_y - self.absmin_y)/8192;
	if (self.count < 1)
	{
		remove(self);
		return;
	}
	// convert from per second to per 0.1 sec,
	self.count = ceil(self.count * 0.1);
	self.think = rain_think;
	self.nextthink = time + 0.5;
};


// ============================================================================
/*  Snow effect from dpmod
*/

void() snow_think =
{
	if ( autocvar_ent_snow )
	{
		self.nextthink = time + 0.1;
		te_particlesnow(self.absmin, self.absmax, self.dest, self.count, self.cnt);
	}
	else remove(self);
};

/*QUAKED func_snow (0 .5 .8) ?
This is an invisible area like a trigger, which snow falls inside of.

Keys:
"velocity"
 falling direction (should be something like '0 0 -300', use the X and Y velocity for wind)
"cnt"
 sets color of rain (default 12 - white)
"count"
 adjusts snow density, this many particles fall every second, experiment to see the effects (default is based on area size)
*/


void() func_snow =
{
	self.dest = self.velocity;
	self.velocity = '0 0 0';
	if (!self.dest)
		self.dest = '0 0 -300';
	self.angles = '0 0 0';
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	setmodel(self, self.model);
	setorigin(self, self.origin);
	setsize(self, self.mins, self.maxs);
	self.model = "";
	if (!self.cnt)
		self.cnt = 12;
	if (!self.count)
		self.count = (self.absmax_x - self.absmin_x)*(self.absmax_y - self.absmin_y)/8192;
	if (self.count < 1)
	{
		remove(self);
		return;
	}
	// convert from per second to per 0.1 sec,
	self.count = ceil(self.count * 0.1);
	self.think = snow_think;
	self.nextthink = time + 0.5;
};