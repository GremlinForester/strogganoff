void() func_wall_use =
{	// change to alternate textures
	self.frame = 1 - self.frame;
	
	fieldFloatFlipFlop(SOLID_BSP, SOLID_NOT, solid);

	if (self.effects & EF_NODRAW){
	removeBitsFromEntity(self, effects, EF_NODRAW);	
	}
	else{
	addBitsToEntity(self, effects, EF_NODRAW);
	}
};

/*QUAKED func_wall (0 .5 .8) ?
This is just a solid wall if not inhibitted
*/
void() func_wall =
{
// v107 - this code is repeated twice below, and can even be used as-is for func_illusionary
	self.angles = '0 0 0';
	self.movetype = MOVETYPE_PUSH;	// so it doesn't get pushed by anything
	self.solid = SOLID_BSP;
	self.use = func_wall_use;
	setmodel (self, self.model);

	if (self.spawnflags & SF_START_INVIS)
	{
//		self.bToggleVisibility = 1;
		self.solid = SOLID_NOT;
		addBitsToEntity(self,effects,EF_NODRAW);		
	}	
	
}; 
