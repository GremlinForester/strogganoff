/*QUAKED func_timer (0.3 0.1 0.6) (-8 -8 -8) (8 8 8) START_ON
"wait"			base time between triggering all targets, default is 1
"random"		wait variance, default is 0

so, the basic time between firing is a random time between
(wait - random) and (wait + random)

"delay"			delay before first firing when turned on, default is 0

"pausetime"		additional delay used only the very first time
				and only if spawned with START_ON

These can used but not touched.
*/

void() func_timer_think  =
{
	SUB_UseTargets ();
	
	if (self.spawnflags & FIRE_ONCE)
	{
		self.think = SUB_Remove;
		self.nextthink = time + 0.1;
	}
	else
	{
		//self.nextthink = time + (((random() * 1 ) + self.wait) + ((random() * 1 ) * self.delay));
		self.nextthink = ((time + self.wait) + (random() * self.variance));
		//level.time + self->wait + crandom() * self->random;
	}
}

void() func_timer_use =
{
	SUB_UseTargets();
}

void() func_timer =
{
	self.classname = "func_timer";

	activator = self;
	
	if (!self.wait)
	{
		self.wait = 1;
	}

	if (self.spawnflags & ESTATE_ON)
	{
		self.nextthink = time + self.wait;
		self.think = func_timer_think;

	}
	
	self.use = func_timer_use;
}
