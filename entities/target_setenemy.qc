//Used to set self.enemy on target enemy.
//When triggered 'target' entity will hunt down its set 'newEnemy'
/*QUAKED
<point name="target_setenemy" color="1 .5 0" box="-8 -8 -8 8 8 8">
<targetname key="targetname" name="Target Name">Name of this entity used for triggering.</targetname>
<target key="newEnemy" name="New Enemy">The entity to set as enemy.</target>
<target key="target" name="Target">The entity to set the new enemy key on.</target>
-------- NOTES --------
Will set enemy key on target entity when used.
</point>
*/

.string newEnemy;

void() target_setenemy_think =
{
	if (self.owner.health <= 0)
	{
		if (cvar("developer")){
			LOG2(self.targetname, " removed on self killed");
		}
		remove(self);
		return;
	}
	
	if (self.owner.enemy.health <= 0)
	{
		self.owner.enemy = world;
		if (cvar("developer")){
			LOG2(self.targetname, " removed on enemy killed");
		}	
		remove(self);
		return;
	}	
	
	self.think = target_setenemy_think;
	self.nextthink = time + 1;
}

void() target_setenemy_use =
{
	if (self.owner.health > 0)
	{
		self.owner.think = self.owner.th_run;	
		self.owner.enemy = find (world, targetname, self.newEnemy);
		self.owner.goalentity = self.owner.enemy;
		if (cvar("developer")){
			LOG3(self.owner.targetname, " hates ", self.owner.enemy.targetname);
		}
	}
	self.think = target_setenemy_think;
	self.nextthink = time + 1;
}

void() target_setenemy =
{
	self.use = target_setenemy_use;
	self.owner = find (world, targetname, self.target);	
}
 