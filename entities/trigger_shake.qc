/*

TRIGGER_SHAKE

*/

void() trigger_shake_think;

void() trigger_shake_reset =
{
	self.solid = SOLID_TRIGGER;
	self.nextthink = time + 0.1;
	self.think = trigger_shake_think;
};

void() trigger_shake_think =
{
	if (self.estate == ESTATE_OFF)
		return;

	self.nextthink = time + 0.1;
	self.think = trigger_shake_reset;
}

void() trigger_shake_touch =
{
	local float r = random() * 3;

	if (self.estate == ESTATE_OFF)
		return;
	
	if (other.classname != "player")
	return;

	self.solid = SOLID_NOT;

	
	if (r < 1){
		other.punchangle_x += crandom() * self.scale;
	}
	else if (r < 2){ 
		other.punchangle_y += crandom() * self.scale;
	}
	else{ 
		other.punchangle_z += crandom() * self.scale;
	}
	
	self.think = trigger_shake_reset;
	self.nextthink = time + 0.1;
};

void() trigger_shake_use =
{
	estateFlipFlop(ESTATE_ON, ESTATE_OFF);
}

/*QUAKED trigger_shake2 (.5 .5 .5) ?
Beats players punchangle.
delay: shake frequency (default 0.1)
*/

void() trigger_shake2 =
{
	InitTrigger ();
	if (!self.delay)
		self.delay = 0.1;

	if (!self.scale)
		self.scale = 0.8;

	if (self.targetname){
		self.estate = ESTATE_OFF;
	}
	else
	{
		self.estate = ESTATE_ON;	
	}
	self.oscale = self.scale;
	self.use = trigger_shake_use;
	self.touch = trigger_shake_touch;
};
