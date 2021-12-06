.float spawn_max;
.float spawn_count;
.float strogg_type;

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
	local entity e;
	local float r;
	
	if (self.spawn_count >= self.spawn_max)
	{
	//	remove(self);
		return;
	}
	
	if (!(self.strogg_type))
	{
		bprint("No Strogg_type set.");
		bprint("\n");
		return;
	}
	
	e = spawn();

/*
1 = infantry
2 = soldier_light
3 = soldier_shotgun
4 = soldier_machinegun
5 = soldier(random)
6 = berserk
7 = brain
8 = chick
9 = floater
10 = flyer
11 = gladiator
12 = gunner
13 = hover
14 = mutant
15 = tank
*/

	switch (self.strogg_type)
	{
		case 1:
			e.classname = "monster_infantry";
			setmodel (e, "models/monsters/infantry/tris.md2");
			setsize (e, '-16 -16 -24', '16 16 40');
			e.health = 30;
		
			e.th_stand = q2infantry_select_stand;
			e.th_walk = q2infantry_frames_walk;
			e.th_run = q2infantry_frames_run;
			e.th_missile = q2infantry_frames_start_attack;
			e.th_pain = q2infantry_pain;
			e.th_die = q2infantry_die;
			e.th_melee = q2infantry_melee;
			
			e.sightSound = "infantry/INFSGHT1.wav";
			break;
		case 2:
			e.classname = "monster_soldier_light";
			setmodel (e, "models/monsters/soldier/tris.md2");
			setsize (e, '-16 -16 -24', '16 16 32');
			e.health = 30;
			e.skin = 0;
			
			e.th_stand = q2soldier_frames_stand;
			e.th_walk = q2soldier_2walk1;
			e.th_run = q2soldier_run1;
			e.th_missile = q2soldier_seleck_attack;
			e.th_pain = q2soldier_pain;
			e.th_die = q2soldier_die;
			
			e.sightSound = "soldier/solsght1.wav";
			break;
		case 3:
			e.classname = "monster_soldier";
			setmodel (e, "models/monsters/soldier/tris.md2");
			setsize (e, '-16 -16 -24', '16 16 32');
			e.health = 30;
			e.skin = 2;

			e.th_stand = q2soldier_frames_stand;
			e.th_walk = q2soldier_2walk1;
			e.th_run = q2soldier_run1;
			e.th_missile = q2soldier_seleck_attack;
			e.th_pain = q2soldier_pain;
			e.th_die = q2soldier_die;

			e.sightSound = "soldier/solsght1.wav";
			break;
		case 4:
			e.classname = "monster_soldier_ss";
			setmodel (e, "models/monsters/soldier/tris.md2");
			setsize (e, '-16 -16 -24', '16 16 32');
			e.health = 40;
			e.skin = 4;
			
			e.th_stand = q2soldier_frames_stand;
			e.th_walk = q2soldier_2walk1;
			e.th_run = q2soldier_run1;
			e.th_missile = q2soldier_seleck_attack;
			e.th_pain = q2soldier_pain;
			e.th_die = q2soldier_die;

			e.sightSound = "soldier/solsght1.wav";
			break;
		case 5:
			setmodel (e, "models/monsters/soldier/tris.md2");
			setsize (e, '-16 -16 -24', '16 16 32');

			if (random() < 0.3){
			e.classname = "monster_soldier_ss";		
			e.skin = 4;
			e.health = 40;
			}
			else if (random() < 0.7){
			e.classname = "monster_soldier_light";		
			e.skin = 0;
			e.health = 30;			
			}
			else{
			e.classname = "monster_soldier";		
			e.skin = 2;
			e.health = 30;			
			}
			
			e.th_stand = q2soldier_frames_stand;
			e.th_walk = q2soldier_2walk1;
			e.th_run = q2soldier_run1;
			e.th_missile = q2soldier_seleck_attack;
			e.th_pain = q2soldier_pain;
			e.th_die = q2soldier_die;

			e.sightSound = "soldier/solsght1.wav";
			break;
		case 6:
			e.classname = "monster_berserk";
			setmodel (e, "models/monsters/berserk/tris.md2");

			setsize (e, '-16 -16 -24', '16 16 32');
			e.health = 240;

			e.th_stand = q2berserk_select_stand;
			e.th_walk = q2berserk_walk;
			e.th_run = q2berserk_run;
			e.th_pain = q2berserk_pain;
			e.th_die = q2berserk_die;
			e.th_melee = q2berserk_melee;
			
			e.sightSound = BERSERK_SOUND_SIGHT;
			break;
		case 7:
			e.classname = "monster_brain";
			setmodel (e, "models/monsters/brain/tris.md2");

			setsize (e, '-16 -16 -24', '16 16 32');
			e.health = 150;

			e.th_stand = brain_stand_frames;
			e.th_walk = brain_walk;
			e.th_run = brain_run;
			e.th_melee = brain_melee;
			e.th_pain = brain_pain;
			e.th_die = brain_die;
			
			e.sightSound = BRAIN_SIGHT;
			break;
		case 8:
			e.classname = "monster_chick";
			setmodel (e, "models/monsters/bitch/tris.md2");

			setsize (e, '-16 -16 0', '16 16 56');
			e.health = 175;

			e.th_stand = q2chick_frames_stand;
			e.th_walk = q2chick_frames_walk;
			e.th_run = q2chick_frames_run;
			e.th_pain = q2chick_pain;
			e.th_die = q2chick_die;
			e.th_missile = q2chick_missile_attack;
			e.th_melee = q2chick_melee_attack;
			
			e.sightSound = CHICK_SOUND_SIGHT;
			break;
		case 9:
			e.classname = "monster_floater";
			setmodel(e, "models/monsters/float/tris.md2");
			
			setsize(e, '-16 -16 -16', '16 16 40');
			e.health = 200;
			
			e.th_stand = floater_stand_switch;
			e.th_walk = floater_walk1;
			e.th_run = floater_run1;
			e.th_missile = floater_attack_start;
			e.th_melee = floater_melee_select;
			e.th_pain = floater_pain;
			e.th_die = floater_die;
			e.flags = e.flags | FL_FLY;
			e.sightSound = FLOATER_SOUND_SIGHT;
			break;
		case 10:
			e.classname = "monster_flyer";
			setmodel(e, "models/monsters/flyer/tris.md2");
			
			setsize(e, '-16 -16 -24', '16 16 32');
			
			e.health = 50;
			
			e.th_stand = flyer_stand;
			e.th_walk = flyer_walk;
			e.th_run = flyer_run_start;
			e.th_missile = flyer_attack;
			e.th_melee = flyer_melee;
			e.th_pain = flyer_pain;
			e.th_die = flyer_die;
	
			e.flags = e.flags | FL_FLY;
			
			e.sightSound = FLYER_SOUND_SIGHT;
			break;
		case 11:
			e.classname = "monster_gladiator";
			setmodel (e, "models/monsters/gladiatr/tris.md2");

			setsize (e, '-32 -32 -24', '32 32 64');
			e.health = 400;

			e.th_stand = q2gladiator_stand;
			e.th_walk = q2gladiator_walk;
			e.th_run = q2gladiator_run;
			e.th_pain = q2gladiator_pain;
			e.th_die = q2gladiator_die;
			e.th_missile = q2gladiator_attack;
			e.th_melee = q2gladiator_melee_select;
			
			e.sightSound = GLADIATOR_SOUND_SIGHT;
			break;
		case 12:
			e.classname = "monster_gunner";
			setmodel (e, "models/monsters/gunner/tris.md2");

			setsize (e, '-16 -16 -24', '16 16 32');
			e.health = 175;

			e.th_stand = q2gunner_frames_stand;
			e.th_walk = q2gunner_frames_walk;
			e.th_run = q2gunner_frames_run;
			e.th_pain = q2gunner_pain;
			e.th_die = q2gunner_die;
			e.th_missile = q2gunner_select_attack;
			e.th_melee = q2gunner_attack_chain;
			
			e.sightSound = GUNNER_SOUND_SIGHT;
			break;
		case 13: //TODO: attach hover sound
			e.classname = "monster_hover";
			setmodel(e, "models/monsters/hover/tris.md2");
			
			setsize(e, '-16 -16 -24', '16 16 32');
			e.health = 240;
			
			e.th_stand = hover_stand;
			e.th_walk = hover_walk;
			e.th_run = hover_run;
			e.th_missile = hover_start_attack;
			e.th_pain = hover_pain;
			e.th_die = hover_die;
			
			e.flags = e.flags | FL_FLY;
			
			e.sightSound = HOVER_SOUND_SIGHT1;
			break;
		case 14:
			e.classname = "monster_mutant";
			setmodel (e, "models/monsters/mutant/tris.md2");
			setsize (e, '-32 -32 -24', '32 32 48');
			e.health = 300;

			e.th_stand = q2mutant_stand;
			e.th_walk = q2mutant_walk;
			e.th_run = q2mutant_run;
			e.th_die = q2mutant_die;
			e.th_melee = q2mutant_atta1;
			e.th_missile = q2mutant_jump;
			e.th_pain = q2mutant_pain;
			
			e.sightSound = MUTANT_SOUND_SIGHT;
			break;
		case 15: //TODO: tank commander
			e.classname = "monster_tank";
			setmodel(e, "models/monsters/tank/tris.md2");
			setsize(e, '-32 -32 -16', '32 32 72');
			e.health = 750;
			
			e.th_stand = tank_stand;
			e.th_walk = tank_walk;
			e.th_run = tank_run;
			e.th_missile = tank_attack;
			e.th_die = tank_die;
			e.th_pain = tank_pain;
			
			e.sightSound = TANK_SOUND_SIGHT;
			break;				
	}
	

	e.origin = self.origin;
//	e.origin_z = e.origin_z + 16;
	e.solid = SOLID_SLIDEBOX;
	e.movetype = MOVETYPE_STEP;
	e.fixangle = TRUE;
	e.angles = self.angles;
	e.yaw_speed = 20;
	e.view_ofs = '0 0 28';
	e.max_health = e.health;
	e.flags = e.flags | FL_MONSTER;
	e.takedamage = DAMAGE_AIM;
	e.nextthink = time + 0.1;
			
	if (self.target)
	{
		e.goalentity = e.movetarget = find(world, targetname, self.target);
		
		if (!(e.flags & FL_FLY))
			e.ideal_yaw = vectoyaw(e.goalentity.origin - e.origin);

		if (!e.movetarget)
		{
			e.think = e.th_walk;
		}

		if ((e.flags & FL_SWIM) || e.movetarget.classname == "path_corner")
		{
			e.pausetime = 0;
			e.think = e.th_walk;
		}
	}
	else{
			e.think = e.th_walk;	
	}
	
	if (e.classname == "monster_hover"){
		attachq2hoverSound(e);
	}
		
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_TELEPORT);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);
	
	self.think = monster_strogg_spawn;
	self.nextthink = time + self.delay;
	self.spawn_count = self.spawn_count + 1;
	total_monsters = total_monsters + 1;
}



/*QUAKED monster_strogg_spawner (1 .5 0) (-16 -16 -24) (16 16 32)

If the spawner has been given a target, spawned monster will begin to walk that path after being spawned in, otherwise they'll roam the level.

*/
void () monster_strogg_spawner =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	self.classname = "monster_strogg_spawner";
	
	self.spawn_count = 0;
	self.spawn_max = self.spawn_max;
	
	makevectors (self.angles);
	
	if (!self.spawn_max)
		self.spawn_max = 10;
	
	if (!self.delay)
		self.delay = 5;

	if (self.strogg_type == 1)
		precache_infantry();
	
	if (self.strogg_type == 2 
	|| self.strogg_type == 3
	|| self.strogg_type == 4
	|| self.strogg_type == 5){
		precache_soldier();
	}

	if (self.strogg_type == 6)
		precache_berserk();

	if (self.strogg_type == 7)
		precache_brain();

	if (self.strogg_type == 8)
		precache_chick();

	if (self.strogg_type == 9)
		precache_floater();

	if (self.strogg_type == 10)
		precache_flyer();

	if (self.strogg_type == 11)
		precache_gladiator();

	if (self.strogg_type == 12)
		precache_gunner();	

	if (self.strogg_type == 13)
		precache_hover();
	
	if (self.strogg_type == 14)
		precache_mutant();	

	if (self.strogg_type == 15)
		precache_tank();

	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_NONE;
	
	self.think = monster_strogg_spawn;
	self.nextthink = time + self.delay;
}
