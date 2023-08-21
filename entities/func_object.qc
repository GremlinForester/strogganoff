/*QUAKED func_object (0 .5 .8) ? TRIGGER_SPAWN ANIMATED ANIMATED_FAST
This is solid bmodel that will fall if it's support it removed.
*/

.float bTouchUseTargets;

void() func_object_touch =
{
	if (!self.velocity_z){
		if (other.classname == "player" || other.owner.classname == "player")
			return;
	}
	
	if (self.velocity_z != 0){
		sound (self, CHAN_BODY, "weapons/bounce.wav", 0.5, ATTN_NORM);	
	}	


	if (self.bTouchUseTargets)
		SUB_UseTargets ();
	
	if (other.takedamage == DAMAGE_NO)
		return;
	
//	if (self.mass >= other.mass)
//	{
		if (self.velocity_z != 0){
			T_Damage (other, self, self, self.dmg);
		}
//	}
}

void() func_object_release =
{
	self.movetype = MOVETYPE_BOUNCE;
	self.touch = func_object_touch;
}

void() func_object_use =
{
	self.solid = SOLID_BSP;
	self.use = SUB_Null;
	func_object_release();
}

void() func_object =
{
	setmodel (self, self.model);
	
	if (self.targetname)
	{
		self.solid = SOLID_BSP;
		self.movetype = MOVETYPE_NONE;
		self.use = func_object_use;
	}
	else
	{
		self.solid = SOLID_BSP;
		self.movetype = MOVETYPE_PUSH;
		self.think = func_object_release;
		if (self.delay)
			self.nextthink = time + self.delay;
		else
			self.nextthink = time + 0.2;			
	}
}