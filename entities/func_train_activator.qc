void() target_activator_think =
{
	LOG("target_activator_think");
	VLOG(self.origin);
}

void() target_activator_touch =
{
	if (other.classname != "trigger_multiple" || other.classname != "trigger_once")
			return;
	
	SUB_UseTargets();
}

void() target_activator =
{
//	self.classname = "player";
//	precache_model(self.model);
	
	activator = self;
	
	self.movetype = MOVETYPE_NOCLIP;
	self.solid = SOLID_TRIGGER;
//	setmodel (self, self.model);
	setorigin (self, self.origin);
	setsize (self, '-32 -32 0', '16 16 16');
//	self.touch = target_activator_touch;

	if (self.parent){
		self.tag_entity = find(world, targetname, self.parent);	
		self.owner = find(world, targetname, self.parent);
		setorigin (self, self.origin - self.owner.origin);
	}

	LOG("target_activator_lives");
	
	self.think = target_activator_think;
	self.nextthink = time + 0.1;
}

/*QUAKED func_train_activator (0 .5 .8) ?
Trigger brushes that can follow a path and activate other triggers. Good for setting off a chain of events.

speed	default 100
dmg		default	2

*/
void() func_train_activator =
{	
	if (!self.speed)
		self.speed = 100;

	activator = self;
	
	self.cnt = 1;
//	self.solid = SOLID_TRIGGER; //SOLID_BBOX;
	self.use = train_use;
	self.classname = "player"; //dumb fix for trigger check
//	self.movetype = MOVETYPE_FLY;
	
	self.solid = SOLID_TRIGGER;
	self.movetype = MOVETYPE_FLY;
	
	setmodel (self, self.model);
	setsize (self, self.mins , self.maxs);
	setorigin (self, self.origin);

// moved because the non-remove option is to leave an inert solid platform
	if (!self.target)
#ifdef noobjerr
	{

#ifdef xvars1
		if (cvar("svx_platdoorfail") < 0) // remove option
		{
			remove(self);
			return;
		}
		else
#endif
		return;
	}
#else
		objerror ("func_train_activator without a target");					//opgrade protected
#endif


// start trains on the second frame, to make sure their targets have had
// a chance to spawn
	self.nextthink = self.ltime + 0.1;
	self.think = func_train_find;
};
