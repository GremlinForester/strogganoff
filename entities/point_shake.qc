.float radius;
.float nextShakeSound;

void() point_shake_think =
{
	local entity shakeTarget;
	local float shakeRadius;
	shakeRadius = self.radius;
	local float r = random() * 3;
	
	if (self.parent){
		self.tag_entity = find(world, targetname, self.parent);	
		self.owner = find(world, targetname, self.parent);
	
		setorigin (self, (randompos(self.owner.absmin, self.owner.absmax)));
	}
	
//	VLOG(self.origin);

	if (self.estate == ESTATE_OFF){
	//	self.nextthink = time + 0.1;
	//	self.think = point_shake_think;
		return;
	}

	shakeTarget = findradius(self.origin, shakeRadius);
	while(shakeTarget)
	{
		if(shakeTarget.flags & FL_CLIENT)
		{
			if(shakeTarget.health > 0)
			{
				local float dist = vlen(shakeTarget.origin - self.origin);

				if (dist < shakeRadius)					
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
					if (self.duration)
					{
						self.cnt = self.cnt+0.1;
					}
				}
			}
		}
	shakeTarget = shakeTarget.chain;
	}

	self.nextthink = time + 0.1;
	self.think = point_shake_think;
	
	//loop a sound at owner's position (self.noise)
	if (self.owner)
	{
		if (time < self.nextShakeSound)
			return;

		sound (self.owner, CHAN_AUTO, self.noise, 1, ATTN_STATIC);

		self.nextShakeSound = time + soundlength(self.noise);
	}

	if (self.duration)
	{
		if (self.cnt >= self.duration)
		{
			self.estate = ESTATE_OFF;
			self.cnt = 0;
		}
		FLOG(self.cnt);
	}
}

void() point_shake_use =
{
	estateFlipFlop(ESTATE_ON, ESTATE_OFF);
	
	self.nextthink = time + 0.1;
	self.think = point_shake_think;
}

void() point_shake =
{
	self.classname = "point_shake";	
	self.movetype = MOVETYPE_NOCLIP;
	setmodel (self, "");
	setsize (self, '0 0 0', '0 0 0');
	setorigin (self, self.origin);
	self.use = point_shake_use;

	if (self.parent){
		self.tag_entity = find(world, targetname, self.parent);	
		self.owner = find(world, targetname, self.parent);
		setorigin (self, self.origin - self.owner.mins);	
	}
	
	if (!self.radius){
		objerror("point_shake without radius");
	}
	
	if (!self.intensity){
		self.intensity = 1.0;
	}

	self.noise = "world/quake.wav";

	if (self.targetname){
		self.estate = ESTATE_OFF;
	}
	else
	{
		self.estate = ESTATE_ON;	
	}
	self.cnt = 0;
	self.nextthink = time + 0.1;
	self.think = point_shake_think;
}