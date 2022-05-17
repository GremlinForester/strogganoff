/*
================
point_sensor

Shoots out a trace and activates targets based on detection for whatever it's configured for.

<targetname key="targetname" name="Target Name">Name of this entity.</targetname>
<target key="target" name="Target">Entity to USE when trace positive.</target>
<angles key="angles" name="Pitch Yaw Roll">Which way to point the trace.</angles>
<string key="classname" name="Target Classname">The classname of the trace entity to activate.</string>
<integer key="count" name="Reset Time">Time to reset the trace after firing targets. -1 to disable.</integer>

================
*/

void() point_sensor_think;

.string target_classname;

void() point_sensor_think =
{
	local	vector	source;
	local	vector	org;	

	if (self.estate == ESTATE_OFF){
		self.nextthink = -1;	
		return;
	}
	
	makevectors(self.angles);
	
//	makevectors(self.v_angle);
//	nep_traceline (self.origin, self.origin + v_forward*4096, FALSE, self);
	traceline (self.origin, self.origin + v_forward*4096, FALSE, self);

	org = trace_endpos;

//	if (trace_fraction == 1.0)
//		return;

	/*
	if (trace_ent.takedamage)
	{
		trace_ent.axhitme = 1;
		T_Damage (trace_ent, self, self, 20);
	}
	*/

//	if (trace_ent.classname == self.target_classname) //becuase this would be too flexible!
	if (trace_dphitq3surfaceflags & Q3SURFACEFLAG_WOOD) //ah, just dumb enough.
	{
	//	LOG("Activating target: ");
	//	LOG(self.target);
		SUB_UseTargets();
		self.estate = ESTATE_OFF;
		self.nextthink = time + self.count;
		self.think = self.use;		
		return;
	}
	
//	VLOG(self.origin);
	
//	Q3Surface_Impact(org);
	
	self.think = point_sensor_think;
	self.nextthink = time + 0.1;		
};

void() point_sensor_use =
{
	estateFlipFlop(ESTATE_ON, ESTATE_OFF);
	self.think = point_sensor_think;
	self.nextthink = time + 0.1;	
}

void() point_sensor =
{
	self.classname = "point_sensor";
	makevectors(self.angles);	
	self.movetype = MOVETYPE_NOCLIP;
	self.solid = SOLID_NOT;	
	setorigin (self, self.origin);
	setmodel (self, "");
	activator = self;
	if (self.targetname)
	{
		if (self.spawnflags & START_OFF){
			self.estate = ESTATE_OFF;
		}
	}
	
	if (self.parent){
		self.tag_entity = find(world, targetname, self.parent);	
		self.owner = find(world, targetname, self.parent);
		setorigin (self, self.origin - self.owner.origin);
	}

	self.use = point_sensor_use;
	
	if (self.target_classname)
		self.target_classname = strzone(self.target_classname);	
	
	self.think = point_sensor_think;
	self.nextthink = time + 0.1;
};