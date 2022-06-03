void() model_static_think =
{
	local float closedframe = self.anim_startframe;
	local float openframe = self.anim_lastframe;

	if (self.parent){
		self.tag_entity = find(world, targetname, self.parent);	
		self.owner = find(world, targetname, self.parent);
		setorigin (self, self.origin - self.owner.origin);

		self.origin = self.origin + self.owner.origin;
			
		if (self.holo_color){
			self.colormod = self.holo_color;
		}
		else
		{
			self.colormod = getlight(self.origin + self.owner.origin);
		}	
	}
	
	if (self.spawnflags & SF_HOLOGRAM)
	{
		self.colormod = self.holo_color;
		
		self.alpha = 0.75 + random();
		
		if (random() < 0.2){
			self.scale = self.oscale + (random() / 14);
		}
		else{
			self.scale = self.oscale;
		}
	}	
	
	if (self.onUse)
	{
	//	LOG("I've been used!");	
		/*
		if (self.eState == LOCKED)
		{
			//locked sound?
			self.onUse = 0;
			return;
		}
		*/
		if(self.eState == OPEN){
			self.eState = CLOSING;
		//	self.solid = SOLID_NOT;
			self.onUse = 0;
		}
		
		if (self.eState == CLOSED){
			self.eState = OPENING;
		//	self.solid = SOLID_NOT;
			self.onUse = 0;
		}

		self.onUse = 0;
	}
	else
	{
		self.onUse = 0;
		//can't use
	}

	if (self.eState == OPENING){
		
		if (self.frame == openframe){
			LOG("Open");
			self.eState = OPEN;	
			self.bUseEnable = TRUE;
		//	self.solid = SOLID_BSP;			
		}
		else{
			LOG("Opening");
			self.bUseEnable = FALSE;
			self.frame++;
		}
	}
	
	if (self.eState == CLOSING){
		
		if (self.frame == closedframe){
			LOG("Closed");
			self.eState = CLOSED;	
			self.bUseEnable = TRUE;
		//	self.solid = SOLID_BSP;			
		}
		else{
			LOG("Closing");
			self.bUseEnable = FALSE;
			self.frame--;
		}
	}

	if (self.bAnimLoop) //may loop but override hold last frame at some point
	{
		if (self.frame < self.anim_startframe){
			self.frame = self.anim_startframe;
		}
		
		if (self.frame == self.anim_lastframe)
		{
			if (self.anim_lastframe_hold == 1)
			{
				self.frame = self.anim_lastframe;
				self.nextthink = -1;
				return;
			}
			else
			{
				self.frame = self.anim_startframe;
			}
		}
	self.frame++;
	}

	self.nextthink = time + 0.1;
	self.think = model_static_think;
}

void() model_static_use =
{
	if (self.bUseEnable == FALSE)
		return;
	
	self.onUse = 1;
	
	if (self.bToggleVisibility >= 1)	
	{	
		LOG("Model static used.");
		fieldFloatFlipFlop(SOLID_BSP, SOLID_NOT, solid);
				
		if (self.effects & EF_NODRAW){
		removeBitsFromEntity(self, effects, EF_NODRAW);	
		}
		else{
		addBitsToEntity(self, effects, EF_NODRAW);
		}	
	}
	
	//todo enable/disable fire targets
	SUB_UseTargets();
}
					
void(entity attacker, float damage)	model_static_pain =
{
	bprint (ftos(self.health));
	bprint ("\n");
};

void() model_static_die =
{
	local float n;
	
	local string break_sound;
	if (self.material == 2)
	{
		break_sound = "misc/udeath.wav";
			for (n= 0; n < 2; n++)
				ThrowGib ("models/objects/gibs/bone/tris.md2", self.health, GIB_FLESH, 1);
			for (n= 0; n < 4; n++)
				ThrowGib ("models/objects/gibs/sm_meat/tris.md2", self.health, GIB_FLESH, 1);
			for (n= 0; n < 3; n++)
				ThrowGib ("models/objects/gibs/bone2/tris.md2", self.health, GIB_FLESH, 1);
	}
	else if (self.material == 3)
	{
			for (n= 0; n < 2; n++)
				ThrowGib ("models/objects/debris1/tris.md2", self.health, GIB_METAL, 1);
			for (n= 0; n < 3; n++)
				ThrowGib ("models/objects/debris2/tris.md2", self.health, GIB_METAL, 1);
			for (n= 0; n < 4; n++)
				ThrowGib ("models/objects/debris3/tris.md2", self.health, GIB_METAL, 1);				
	}
	else if (self.material == 4)
	{
			for (n= 0; n < 2; n++)
				ThrowGib ("models/objects/debris1/tris.md2", self.health, GIB_FLAMING, 1);
			for (n= 0; n < 3; n++)
				ThrowGib ("models/objects/debris2/tris.md2", self.health, GIB_FLAMING, 1);
			for (n= 0; n < 4; n++)
				ThrowGib ("models/objects/debris3/tris.md2", self.health, GIB_FLAMING, 1);	
	}
	else if (self.material == 5)
	{
			sound (self, CHAN_VOICE, "world/brkglas.wav", 1, ATTN_NORM);
			for (n= 0; n < 2; n++)
				ThrowGib ("models/objects/debris1/tris.md2", self.health, GIB_GLASS, 1);
			for (n= 0; n < 3; n++)
				ThrowGib ("models/objects/debris2/tris.md2", self.health, GIB_GLASS, 1);
			for (n= 0; n < 4; n++)
				ThrowGib ("models/objects/debris3/tris.md2", self.health, GIB_GLASS, 1);				
	}
	else if (self.material == 6)
	{
			for (n= 0; n < 2; n++)
				ThrowGib ("models/objects/debris1/tris.md2", self.health, GIB_WOOD, 1);
			for (n= 0; n < 3; n++)
				ThrowGib ("models/objects/debris2/tris.md2", self.health, GIB_WOOD, 1);
			for (n= 0; n < 4; n++)
				ThrowGib ("models/objects/debris3/tris.md2", self.health, GIB_WOOD, 1);			
	}

	self.solid = SOLID_NOT;
	self.takedamage = DAMAGE_NO;
	remove(self);
}

void() model_static_init =
{
	if (self.health > 0) 
	{
		self.solid = SOLID_BBOX;		
		self.takedamage = DAMAGE_YES;
	}

	if (!self.scale)
		self.scale = 1.0;
		
	self.nextthink = time + 0.1;
	self.think = model_static_think;
}

void() model_static =
{
	self.classname = "model_static";	
	makevectors(self.angles);

	if (self.spawnflags & SF_SOLID_BSP)
	{
		self.solid = SOLID_BSP;
	}
	else
	{
		self.solid = SOLID_NOT;
	}
	
	/*
	if (self._color){
		self.colormod = self._color;
	}
	
	if (self.bUseEnvLight){
		self.colormod = getlight(self.origin);
	}
	*/
	
	self.movetype = MOVETYPE_NOCLIP;
	precache_model(self.model);
	setorigin (self, self.origin);

	if (self.holo_color){
		self.colormod = self.holo_color;
	}
	
	setmodel (self, self.model);
	self.eState = CLOSED;
//	self.effects = self.effects | EF_LOWPRECISION;
	self.oscale = self.scale;
	self.max_health = self.health;
	self.takedamage = DAMAGE_NO;
//	self.skin = 0;
	self.th_die = model_static_die;
	self.use = model_static_use;	
	self.th_pain = model_static_pain;
	self.scale = self.modelscale;
	self.avelocity = self.avelocity;

	self.nextthink = time + 0.1;
	self.think = model_static_init;
	
	if (self.bUseEnable == 1){
		self.bUseEnable = TRUE;
	}
	else
	{		
		self.bUseEnable = FALSE;	
	}

	if (self.bAnimLoop)
		self.solid = SOLID_NOT;

	self.frame = self.anim_startframe;

	if (self.spawnflags & SF_HOLOGRAM)
	{
		addBitsToEntity(self,effects,EF_ADDITIVE | EF_DOUBLESIDED);
	}
	
	if (self.spawnflags & SF_START_INVIS)
	{
		self.bToggleVisibility = 1;
		addBitsToEntity(self,effects,EF_NODRAW);		
	}	
	
};

void() model_static_brush =
{
	model_static();
}