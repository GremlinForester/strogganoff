
void() T_MissileTouch;
void() info_player_start;
void(entity targ, entity attacker) ClientObituary;

void() monster_death_use;

//============================================================================

// Thanks Preach from func_messageboard

float(entity ent) playerRemarkCheckClass=
{
	if (ent.classname == "monster_soldier_light" && ent.health < -20 
		|| ent.classname == "monster_soldier_ss" && ent.health < -10
		|| ent.classname == "monster_soldier" && ent.health < -10
		|| ent.classname == "monster_infantry" && ent.health < -10){
		return TRUE;
		}

		return FALSE;
};

void(entity e, entity monster) PlayerRemarkOnKill =
{
	local float r;

	if (e.classname != "player")
		return;

	if (time < e.nextsmacktalktime)
		return;
/*
		if (monster.classname == "monster_soldier_light" && monster.health < -20 
		|| monster.classname == "monster_soldier_ss" && monster.health < -10
		|| monster.classname == "monster_soldier" && monster.health < -10
		|| monster.classname == "monster_infantry" && monster.health < -10)
*/	
		if (playerRemarkCheckClass(monster))
		{
			e.nextsmacktalktime = time + 2;
			r = random() * 7;
			if (r < 1) sound(e, CHAN_VOICE, PLAYER_KILLCOMMENT_1, 1, ATTN_IDLE);
			else if (r < 2) sound(e, CHAN_VOICE, PLAYER_KILLCOMMENT_2, 1, ATTN_IDLE);
			else if (r < 3) sound(e, CHAN_VOICE, PLAYER_KILLCOMMENT_3, 1, ATTN_IDLE);
			else if (r < 4) sound(e, CHAN_VOICE, PLAYER_KILLCOMMENT_4, 1, ATTN_IDLE);
			else if (r < 5) sound(e, CHAN_VOICE, PLAYER_KILLCOMMENT_5, 1, ATTN_IDLE);
			else if (r < 6) sound(e, CHAN_VOICE, PLAYER_KILLCOMMENT_6, 1, ATTN_IDLE);
			else sound(e, CHAN_VOICE, "", 1, ATTN_IDLE);
		//	LOG("Talked smack!");
		}
		
		e.nextsmacktalktime = time + 15;
		return;
};

/*
============
CanDamage

Returns true if the inflictor can directly damage the target.  Used for
explosions and melee attacks.
============
*/
float(entity targ, entity inflictor) CanDamage =
{
// bmodels need special checking because their origin is 0,0,0
	if (targ.movetype == MOVETYPE_PUSH)
	{
		traceline(inflictor.origin, 0.5 * (targ.absmin + targ.absmax), TRUE, self);
		if (trace_fraction == 1)
			return TRUE;
		if (trace_ent == targ)
			return TRUE;
		return FALSE;
	}
	
	traceline(inflictor.origin, targ.origin, TRUE, self);
	if (trace_fraction == 1)
		return TRUE;
	traceline(inflictor.origin, targ.origin + '15 15 0', TRUE, self);
	if (trace_fraction == 1)
		return TRUE;
	traceline(inflictor.origin, targ.origin + '-15 -15 0', TRUE, self);
	if (trace_fraction == 1)
		return TRUE;
	traceline(inflictor.origin, targ.origin + '-15 15 0', TRUE, self);
	if (trace_fraction == 1)
		return TRUE;
	traceline(inflictor.origin, targ.origin + '15 -15 0', TRUE, self);
	if (trace_fraction == 1)
		return TRUE;

#ifdef pointless_warning
	return FALSE;
#endif
};


/*
============
Killed
============
*/
void(entity targ, entity attacker) Killed =
{
	local entity oself;

	oself = self;
	self = targ;
	
	if (self.health < -99)
		self.health = -99;		// don't let sbar look bad if a player

	if (self.movetype == MOVETYPE_PUSH || self.movetype == MOVETYPE_NONE)
	{	// doors, triggers, etc
		self.th_die ();
		self = oself;
		return;
	}

	self.enemy = attacker;

	// bump the monster counter and award points/frags if coop
	/*
	if (self.flags & FL_MONSTER)
	{
		if (coop)
		{
			if (attacker.classname == "player")
			{
				if (!self.solid == SOLID_CORPSE || !self.deadflag == DEAD_DEAD)
				{
					attacker.frags = attacker.frags + 1;
					killed_monsters = killed_monsters + 1;			
					WriteByte (MSG_ALL, SVC_KILLEDMONSTER);
				}
			}
		}			
		else
		{
			if (!self.solid == SOLID_CORPSE || !self.deadflag == DEAD_DEAD)
			{
				killed_monsters = killed_monsters + 1;			
				WriteByte (MSG_ALL, SVC_KILLEDMONSTER);
			}
		}
//			killed_monsters = killed_monsters + 1;			
//			WriteByte (MSG_ALL, SVC_KILLEDMONSTER);
	}
	*/

	// bump the monster counter and award points/frags if coop
	if (self.flags & FL_MONSTER && attacker.classname == "player")
	{
		if (!self.solid == SOLID_CORPSE || !self.deadflag == DEAD_DEAD)
		{
			if (coop)
			{
				attacker.frags = attacker.frags + 1;
			}
			killed_monsters = killed_monsters + 1;			
			WriteByte (MSG_ALL, SVC_KILLEDMONSTER);
		}
	}
	
	if (autocvar_cl_smacktalk >= 1)
	{	
		if (random() < 0.5)
		{
			if (attacker.classname == "player")
			{
				PlayerRemarkOnKill(attacker, self);		
			}
		}
	}

	ClientObituary(self, attacker);
	
	self.takedamage = DAMAGE_NO;
	self.touch = SUB_Null;

	monster_death_use();
	self.th_die ();
	
	self = oself;
};


/*
============
T_Damage

The damage is coming from inflictor, but get mad at attacker
This should be the only function that ever reduces health.
============
*/
void(entity targ, entity inflictor, entity attacker, float damage) T_Damage=
{
	local	vector	dir;
	local	entity	oldself;
	local	float	save;
	local	float	take;

	if (!targ.takedamage)
		return;
	
	if (targ.movetype == MOVETYPE_NOCLIP)
		return;	

// used by buttons and triggers to set activator for target firing
	damage_attacker = attacker;

// check for quad damage powerup on the attacker
	if (attacker.super_damage_finished > time)
		damage = damage * 4;

// save damage based on the target's armor level

	save = ceil(targ.armortype*damage);
	if (save >= targ.armorvalue)
	{
		save = targ.armorvalue;
		targ.armortype = 0;	// lost all armor
		targ.items = targ.items - (targ.items & (IT_ARMOR_JACKET | IT_ARMOR_COMBAT | IT_ARMOR_BODY));
	}
	
	targ.armorvalue = targ.armorvalue - save;
	take = ceil(damage-save);

// add to the damage total for clients, which will be sent as a single
// message at the end of the frame
// FIXME: remove after combining shotgun blasts?
	if (targ.flags & FL_CLIENT)
	{
		targ.dmg_take = targ.dmg_take + take;
		targ.dmg_save = targ.dmg_save + save;
		targ.dmg_inflictor = inflictor;
	}

// figure momentum add
	if ( (inflictor) /* != world) */ && (targ.movetype == MOVETYPE_WALK) )
	{
		dir = targ.origin - (inflictor.absmin + inflictor.absmax) * 0.5;
		dir = normalize(dir);

		targ.velocity = targ.velocity + dir*damage*8;
	}

// check for godmode or invincibility
	if (targ.flags & FL_GODMODE)
		return;
	if (targ.invincible_finished >= time)
	{
		if (self.invincible_sound < time)
		{
			sound (targ, CHAN_ITEM, "items/protect3.wav", 1, ATTN_NORM);
			self.invincible_sound = time + 2;
		}
		return;
	}

// team play damage avoidance
#ifdef opgrade
	if ( (teamplay == 1) && (targ.team > 0) && (targ.team == attacker.team)
	&& (targ != attacker) && (attacker.classname == "player")
	&& (inflictor.classname != "door") )	// because squishing a teammate is still possible
#else
	if ( (teamplay == 1) && (targ.team > 0)&&(targ.team == attacker.team) )
#endif

		return;
		
// do the damage
	targ.health = targ.health - take;
			
	if (targ.health <= 0)
	{
		Killed (targ, attacker);
		return;
	}

// react to the damage
	oldself = self;
	self = targ;

	if ( (self.flags & FL_MONSTER) && attacker) // != world)
	{
	//MrC: TODO animals like Mutants might switch targets, Strogg should not get mad at other Strogg.
	//classtype? Or someting.
	// get mad unless of the same class (except for soldiers)
		
		if (self != attacker && attacker != self.enemy)
		{
		//	if ( (self.classtype != attacker.classtype) || (self.classname == "monster_army" ) )
			if (self.classtype != attacker.classtype)
			{
				if (self.enemy.classname == "player")
					self.oldenemy = self.enemy;
				self.enemy = attacker;
				FoundTarget ();
			}
		}
		
	}

	if (self.th_pain)
	{
		self.th_pain (attacker, take);
	// nightmare mode monsters don't go into pain frames often
		if (skill == 3)
			self.pain_finished = time + 5;
	}

	self = oldself;
};

/*
============
T_RadiusDamage
============
*/
void(entity inflictor, entity attacker, float damage, entity ignore) T_RadiusDamage =
{
	local	float 	points;
	local	entity	head;
	local	vector	org;

	head = findradius(inflictor.origin, damage+40);
	
	while (head)
	{
		if (head != ignore)
		{
			if (head.takedamage)
			{
				org = head.origin + (head.mins + head.maxs)*0.5;
				points = 0.5*vlen (inflictor.origin - org);
				if (points < 0)
					points = 0;
				points = damage - points;
				if (head == attacker)
					points = points * 0.5;
				if (points > 0)
				{
					if (CanDamage (head, inflictor))
					{	// shambler takes half damage from all explosions
						if (head.classname == "monster_shambler")						
							T_Damage (head, inflictor, attacker, points*0.5);
						else
							T_Damage (head, inflictor, attacker, points);
					}
				}
			}
		}
		head = head.chain;
	}
};

/*
============
T_RadiusDamage with radius 

MrC: this is just to test something first, will extend this to regular function later
============
*/
void(entity inflictor, entity attacker, float damage, entity ignore, float rad) T_RadiusDamageRad =
{
	local	float 	points;
	local	entity	head;
	local	vector	org;

	head = findradius(inflictor.origin, rad);
	
	while (head)
	{
		if (head != ignore)
		{
			if (head.takedamage)
			{
				org = head.origin + (head.mins + head.maxs)*0.5;
				points = 0.5*vlen (inflictor.origin - org);
				if (points < 0)
					points = 0;
				points = damage - points;
				if (head == attacker)
					points = points * 0.5;
				if (points > 0)
				{
					if (CanDamage (head, inflictor))
					{	// shambler takes half damage from all explosions
						if (head.classname == "monster_shambler")						
							T_Damage (head, inflictor, attacker, points*0.5);
						else
							T_Damage (head, inflictor, attacker, points);
					}
				}
			}
		}
		head = head.chain;
	}
};

/*
============
T_BeamDamage
============
*/
#ifdef unused

void(entity attacker, float damage) T_BeamDamage =
{
	local	float 	points;
	local	entity	head;
	
	head = findradius(attacker.origin, damage+40);
	
	while (head)
	{
		if (head.takedamage)
		{
			points = 0.5*vlen (attacker.origin - head.origin);
			if (points < 0)
				points = 0;
			points = damage - points;
			if (head == attacker)
				points = points * 0.5;
			if (points > 0)
			{
				if (CanDamage (head, attacker))
				{
					if (head.classname == "monster_shambler")						
						T_Damage (head, attacker, attacker, points*0.5);
					else
						T_Damage (head, attacker, attacker, points);
				}
			}
		}
		head = head.chain;
	}
};

#endif

/*
============
gibbs
============
*/

// base std gibs & sound												- this adds 2 globals, yet it simplifies repeated code and precedes a more complex gib function that will come later

// self.model becomes hd
//	hd = head or large chunk to throw					- note: ThrowHead re-uses self for its throw

// leroy jethro...
void(string hd) gibbs =
{
// some code needs to play other sounds - call sound() with the same channel and this will not be heard
	sound(self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
	if (hd) ThrowHead (hd, self.health);
	ThrowGib ("progs/gib1.mdl", self.health, GIB_FLESH, 1, 1);
	ThrowGib ("progs/gib2.mdl", self.health, GIB_FLESH, 1, 1);
	ThrowGib ("progs/gib3.mdl", self.health, GIB_FLESH, 1, 1);
};











