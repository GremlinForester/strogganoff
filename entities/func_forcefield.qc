void() func_forcefield_use =
{
	fieldFloatFlipFlop(SOLID_BSP, SOLID_NOT, solid);
	
	if (self.effects & EF_NODRAW){
	removeBitsFromEntity(self, effects, EF_NODRAW);	
	}
	else{
	addBitsToEntity(self, effects, EF_NODRAW);
	}
};

void() func_forcefield_touch =
{
	if (other.classname != "player")
		return;

	if (self.dmg){
		if (other.takedamage)
		{
			T_Damage (other, self, self, self.dmg);
		}
	}
}

/*QUAKED func_forcefield (0 .5 .8) ?
Solid wall that toggles between solid/visible and passible/invisible
*/
void() func_forcefield=
{
	self.angles = '0 0 0';
	self.movetype = MOVETYPE_PUSH;	// so it doesn't get pushed by anything
	self.solid = SOLID_BSP;
	self.use = func_forcefield_use;
	self.touch = func_forcefield_touch;
	setmodel (self, self.model);
};

void() func_damage_reset =
{
	self.solid = SOLID_BSP;
	self.nextthink = -1;
};

void() func_damage_touch =
{
	if (other.takedamage)
	{
		self.solid = SOLID_NOT;
		T_Damage (other, self, self, self.dmg);
		self.nextthink = time + 0.5;		
		self.think = func_damage_reset;
	}
}

/*QUAKED func_damage (0 .5 .8) ?
Solid wall that damages on touch with a message for the obit
*/
void() func_damage=
{
	self.angles = '0 0 0';
	self.movetype = MOVETYPE_PUSH;	// so it doesn't get pushed by anything
	self.solid = SOLID_BSP;
	self.use = func_forcefield_use;
	self.touch = func_forcefield_touch;
	setmodel (self, self.model);
}; 
