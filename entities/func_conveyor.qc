/*QUAKED func_object (0 .5 .8) ? TRIGGER_SPAWN

WIP: Do not use. Unsupported atm. I'm either pretty dumb (probably the case!) or this sort of thing is easier said than done!

*/

void() func_conveyor_touch =
{
	if (other.movetype != MOVETYPE_BOUNCE || other.movetype != MOVETYPE_STEP)
		return;

//	other.velocity = other.velocity + (self.movedir * self.speed);
	other.velocity_x = other.velocity_x + (self.movedir_x * self.speed);
	other.velocity_y = other.velocity_y + (self.movedir_y * self.speed);
	
	other.velocity_z = (other.gravity * -1) + 20;
}

void() func_conveyor =
{
	SetMovedir ();
	setmodel (self, self.model);
	InitTrigger ();
	
//	self.solid = SOLID_TRIGGER;
//	self.movetype = MOVETYPE_PUSH;
	self.touch = func_conveyor_touch;	
}