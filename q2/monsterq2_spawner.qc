void() monster_q2soldier_spawn =
{
	local entity monster_q2soldier;
	local float r;
	
	if (self.spawn_count >= self.spawn_max)
	{
		return;
	}
	
	//SKIN 0 = Red, Laser monster_soldier_light
	//SKIN 2 = Shotgun monster_soldier
	//SKIN 4 = Chaingun monster_soldier_ss
		
	monster_q2soldier = spawn();
	
	r = random() * 10;
	if (r < 3) 
	{
		monster_q2soldier.skin = 4;
		monster_q2soldier.classname = "monster_soldier_ss";
	}
	else if (r < 6) 
	{
		monster_q2soldier.skin = 2;
		monster_q2soldier.classname = "monster_soldier";
	}
	else
	{
		monster_q2soldier.skin = 0;
		monster_q2soldier.classname = "monster_soldier_light";
	}

	monster_q2soldier.origin = self.origin;
	monster_q2soldier.origin_z = monster_q2soldier.origin_z + 16;
	setmodel (monster_q2soldier, "models/monsters/soldier/tris.md2");
	monster_q2soldier.solid = SOLID_SLIDEBOX;
	monster_q2soldier.movetype = MOVETYPE_STEP;
	monster_q2soldier.fixangle = TRUE;	

	setsize (monster_q2soldier, '-16 -16 -24', '16 16 40');
	monster_q2soldier.health = 20;
	
	monster_q2soldier.use = monster_use;
	monster_q2soldier.ideal_yaw = monster_q2soldier.angles * '0 1 0';
	monster_q2soldier.yaw_speed = 120;
	monster_q2soldier.view_ofs = '0 0 28';
	monster_q2soldier.flags = monster_q2soldier.flags | FL_MONSTER;
	monster_q2soldier.takedamage = DAMAGE_AIM;
	monster_q2soldier.th_stand = q2soldier_stand1;
	monster_q2soldier.th_walk = q2soldier_selectwalk; //q2soldier_2walk1;
	monster_q2soldier.th_run = q2soldier_run1;
	monster_q2soldier.th_missile = q2soldier_atk1;
	monster_q2soldier.th_pain = q2soldier_pain;
	monster_q2soldier.th_die = q2soldier_die;

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_TELEPORT);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);

	droptofloor();
	
	monster_q2soldier.nextthink = 0.1;
	monster_q2soldier.think = monster_q2soldier.th_run;
	
	self.think = monster_q2soldier_spawn;
	self.nextthink = time + 5;
	self.spawn_count = self.spawn_count + 1;
}

/*QUAKED monster_q2soldier_spawner (1 .5 0) (-16 -16 -24) (16 16 32) Ambush Trigger_Spawn Sight
*/
void () monster_q2soldier_spawner =
{
	self.spawn_count = 0;
	self.spawn_max = self.spawn_max;
	
	if (!(self.spawn_max)){
		self.spawn_max = 10;
	}
	
	self.classname = "monster_q2soldier_spawner";
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model ("models/monsters/soldier/tris.md2");
	precache_model ("progs/h_guard.mdl");
	precache_model ("progs/gib1.mdl");
	precache_model ("progs/gib2.mdl");
	precache_model ("progs/gib3.mdl");

	// SHARED SOUNDS
	precache_sound ("soldier/solidle1.wav");
	precache_sound ("soldier/solsght1.wav");
	precache_sound ("soldier/solsrch1.wav");
	precache_sound ("infantry/infatck3.wav");

	precache_sound ("soldier/solpain3.wav");
	precache_sound ("soldier/soldeth3.wav");
	precache_sound ("soldier/solatck3.wav");

	precache_sound ("misc/udeath.wav");		// gib death

	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_NONE;
	
	self.think = monster_q2soldier_spawn;
	self.nextthink = time + 5;
}

/*QUAKED monster_strogg_spawner (1 .5 0) (-16 -16 -24) (16 16 32) Ambush Trigger_Spawn Sight
-------- KEYS --------
"strogg_type" :
1 = infantry
2 = soldier_light
3 = soldier_shotgun
4 = soldier_machinegun
5 = soldier(random)

*/
void() monster_strogg_spawn =
{
	local entity monster_strogg;
	local float r;
	
	precache_model ("progs/h_guard.mdl");
	precache_model ("progs/gib1.mdl");
	precache_model ("progs/gib2.mdl");
	precache_model ("progs/gib3.mdl");

	precache_sound ("infantry/infdeth1.wav");
	precache_sound ("infantry/infdeth2.wav");
	precache_sound ("infantry/infidle1.wav");
	precache_sound ("infantry/infpain1.wav");
	precache_sound ("infantry/infpain2.wav");
	precache_sound ("soldier/sattck1.wav");
	precache_sound ("infantry/infsrch1.wav");
	precache_sound ("infantry/INFSGHT1.wav");

	precache_sound ("player/udeath.wav");		// gib death
	
	if (self.spawn_count >= self.spawn_max)
	{
		return;
	}
	
	if (!(self.strogg_type))
	{
		bprint("No Strogg_type set.");
		bprint("\n");
		return;
	}
	
	monster_strogg = spawn();
	monster_strogg.origin = self.origin;
	monster_strogg.origin_z = monster_strogg.origin_z + 16;
	monster_strogg.solid = SOLID_SLIDEBOX;
	monster_strogg.movetype = MOVETYPE_STEP;
	monster_strogg.fixangle = TRUE;

	switch (self.strogg_type)
	{
		case 1:

			bprint("monster_strogg_infantry");
			bprint("\n");
			precache_model ("models/monsters/infantry/tris.md2");
			setmodel (monster_strogg, "models/monsters/infantry/tris.md2");
			setsize (monster_strogg, '-16 -16 -24', '16 16 40');
			monster_strogg.health = 30;

			monster_strogg.th_stand = infantry_stand1;
			monster_strogg.th_walk = infantry_walk1;
			monster_strogg.th_run = infantry_run1;
			monster_strogg.th_missile = infantry_atk1;
			monster_strogg.th_pain = infantry_pain;
			monster_strogg.th_die = infantry_die;
			
			droptofloor();
	
			monster_strogg.use = monster_use;
			monster_strogg.ideal_yaw = monster_strogg.angles * '0 1 0';
			monster_strogg.yaw_speed = 120;
			monster_strogg.view_ofs = '0 0 28';
			monster_strogg.flags = monster_strogg.flags | FL_MONSTER;
			monster_strogg.takedamage = DAMAGE_AIM;
	
			monster_strogg.nextthink = 0.1;
			monster_strogg.think = monster_strogg.th_run;
			break;
		case 2:
			bprint("strogg_type 2");
			bprint("\n");
			break;
	}			

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_TELEPORT);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);

	self.think = monster_strogg_spawn;
	self.nextthink = time + 5;
	self.spawn_count = self.spawn_count + 1;
}

/*QUAKED monster_strogg_spawner (1 .5 0) (-16 -16 -24) (16 16 32)
*/
void () monster_strogg_spawner =
{
	self.spawn_count = 0;
	self.spawn_max = self.spawn_max;
	
	if (!(self.spawn_max)){
		self.spawn_max = 10;
	}
	
	self.classname = "monster_strogg_spawner";
	if (deathmatch)
	{
		remove(self);
		return;
	}

	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_NONE;
	
	self.think = monster_strogg_spawn;
	self.nextthink = time + 5;
}
