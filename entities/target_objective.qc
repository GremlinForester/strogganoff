/*
================
target_objective

Sets an entity as an objective with visible quest icon (perhaps include a cvar to disable this).


<point name="target_objective" color="0 0.7 0.3" box="-8 -8 -8 8 8 8">
Sets an entity as an objective with visible quest icon.

<targetname key="targetname" name="Target Name">Name of this entity.</targetname>
<target key="target" name="Target">Entity to USE when target is destroyed.</target>
<target key="parent" name="Parent">Entity to attach an icon to.</target>
-------- SPAWNFLAGS --------
<flag key="START_OFF" name="Start Off" bit="0">Start off until triggered.</flag>
</point>

================
*/

void() objective_think =
{
	if (self.owner.health <= 0){
		SUB_UseTargets ();		
		remove(self);
	}

	local entity objectivetarget;
	local vector dir;
	local float objectivedist = 500;

	dir = normalize(self.origin - objectivetarget.origin);
	
	objectivetarget = findradius(self.origin, objectivedist);
	
	self.alpha = 0.01;
	
	while(objectivetarget)
	{
		if(objectivetarget.flags & FL_CLIENT)
		{
			if(objectivetarget.health > 0)
			{
				if (vlen(objectivetarget.origin - self.origin) < objectivedist)
				{
						self.alpha = 0.75;				
				}
			}
		}
	objectivetarget = objectivetarget.chain;
	}
	
	self.think = objective_think;
	self.nextthink = time + 1;	//check every second on owner status
}

void() target_objective =
{
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_NOCLIP;
	self.effects = 	self.effects | EF_FULLBRIGHT | EF_NODEPTHTEST;
	precache_model ("models/mapobjects/hub/stroggos_system/logo_strogg.MD3");
	setmodel (self, "models/mapobjects/hub/stroggos_system/logo_strogg.MD3");
	setsize (self, '-24 -24 -24', '24 24 24');	
	
	if (self.parent)
	{
		self.tag_entity = find(world, targetname, self.parent);	
		self.owner = find(world, targetname, self.parent);
		setorigin (self, self.origin - self.owner.origin);
	}
	else
	{
		setorigin (self, self.origin);
		LOG("target_objective without target1");
		VLOG(self.origin);	
	}
	self.think = objective_think;
	self.nextthink = time;
}