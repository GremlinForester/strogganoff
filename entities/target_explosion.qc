#define SF_SHAKE 1
#define EXPLOSION_SHAKE_TIME 0.7

void() target_explosion_think =
{
	local entity shakeTarget;
	local float r = random() * 3;
	
	shakeTarget = findradius(self.origin, self.radius);
	while(shakeTarget)
	{
		if(shakeTarget.flags & FL_CLIENT)
		{
			if(shakeTarget.health > 0)
			{
				local float dist = vlen(shakeTarget.origin - self.origin);

				if (dist < self.radius)					
				{
					if (r < 1)
					{
						shakeTarget.punchangle_x += crandom() * self.intensity;
					}
					else if (r < 2){ 
						shakeTarget.punchangle_y += crandom() * self.intensity;
					}
					else{ 
						shakeTarget.punchangle_z += crandom() * self.intensity;
					}
					self.cnt = self.cnt+0.1;
				}
			}
		}
	shakeTarget = shakeTarget.chain;
	}

	self.nextthink = time + 0.1;
	self.think = target_explosion_think;	

	if (self.cnt >= EXPLOSION_SHAKE_TIME)
	{
		remove(self);
		return;
	}
}

void() target_explosion_explode =
{
	T_RadiusDamage (self, self, self.dmg, world);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);
	
	effect(self.origin, "progs/cgexplodex.spr32", 0, 36, 30);	
	
	if (self.spawnflags & SF_SHAKE)
	{
		self.cnt = 0;
		self.nextthink = time;
		self.think = target_explosion_think;
		return;
	}
	self.think = SUB_Remove;
	self.nextthink = time + 0.6;
}

void() target_explosion_use =
{
	if (self.delay)
	{
		self.think = target_explosion_explode;
		self.nextthink = time + self.delay;
	}
	SUB_UseTargets();	
}

void() target_explosion =
{
	self.classname = "point_shake";	
	self.movetype = MOVETYPE_NOCLIP;
	setmodel (self, "");
	setsize (self, '0 0 0', '0 0 0');
	setorigin (self, self.origin);
	self.use = target_explosion_use;

	if (!self.dmg)
	{
		self.dmg = 100;
	}
	
	if (self.spawnflags & SF_SHAKE)
	{
		if (!self.intensity)
		{
			self.intensity = 0.7;
		}
	}	
}