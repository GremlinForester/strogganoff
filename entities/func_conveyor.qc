/*QUAKED func_conveyor (0 .5 .8) ? TRIGGER_SPAWN

WIP: Do not use. Unsupported atm.
*/
/*
void() func_conveyor_touch =
{
	other.movetype = MOVETYPE_TOSS;
	
	if (other.movetype == MOVETYPE_TOSS || other.movetype == MOVETYPE_STEP || other.movetype == MOVETYPE_WALK)
	{
		LOG("Touched me!");
	//	other.velocity = other.velocity + (self.movedir * self.speed);
		other.velocity_x = (self.movedir_x * self.speed);
		other.velocity_y = (self.movedir_y * self.speed);
	//	other.velocity_z = (other.gravity * -1) + 20;
	}
}

void() func_conveyor =
{
	SetMovedir ();
	InitTrigger ();
	
	if (!self.speed)
		self.speed = 10;
	
	self.solid = SOLID_TRIGGER;
//	self.movetype = MOVETYPE_PUSH;
	self.touch = func_conveyor_touch;	
}
*/