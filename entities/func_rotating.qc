/*QUAKED func_rotating (0 .5 .8) ? START_ON REVERSE X_AXIS Y_AXIS TOUCH_PAIN STOP ANIMATED ANIMATED_FAST
You need to have an origin brush as part of this entity.  The center of that brush will be
the point around which it is rotated. It will rotate around the Z axis by default.  You can
check either the X_AXIS or Y_AXIS box to change that.

"speed" determines how fast it moves; default value is 100.
"dmg"	damage to inflict when blocked (2 default)

REVERSE will cause the it to rotate in the opposite direction.
STOP mean it will stop moving instead of pushing entities
*/

void () rotating_blocked =
{
	T_Damage (other, self, self, self.dmg);
}

void() func_rotating =
{
	self.classname = "func_rotating";
	setorigin (self, self.origin);
	setmodel (self, self.model);
	
	self.solid = SOLID_BSP;
	if (self.spawnflags & 32)
		self.movetype = MOVETYPE_NONE;
	else
		self.movetype = MOVETYPE_PUSH;

	// set the axis of rotation
	if (self.spawnflags & 4)
		self.avelocity_z = self.speed;
	else if (self.spawnflags & 8)
		self.avelocity_x = self.speed;
	else // Z_AXIS
		self.avelocity_y = self.speed;

	// check for reverse rotation
	if (self.spawnflags & 2)
		self.avelocity = -self.avelocity;

	if (self.speed)
		self.speed = 100;

//	if (!self.dmg)
		self.dmg = 200;
	
	self.nextthink = 99999999;

	if (self.dmg)
		self.blocked = rotating_blocked;
}
