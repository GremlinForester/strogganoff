/*
*/
void (entity targ, entity inflictor, entity attacker, float damage) T_Damage;
void(entity bomb, entity attacker, float rad, entity ignore) T_RadiusDamage;
void(vector org, vector vel, float damage) SpawnBlood;
void() SuperDamageSound;

// called by worldspawn
void() W_Precache =
{
	precache_sound ("weapons/r_exp3.wav");	// new rocket explosion
	precache_sound ("weapons/rocket1i.wav");	// spike gun
	precache_sound ("weapons/sgun1.wav");
	precache_sound ("weapons/guncock.wav");	// player shotgun
	precache_sound ("weapons/ric1.wav");	// ricochet (used in c code)
	precache_sound ("weapons/ric2.wav");	// ricochet (used in c code)
	precache_sound ("weapons/ric3.wav");	// ricochet (used in c code)
	precache_sound ("weapons/spike2.wav");	// super spikes
	precache_sound ("weapons/tink1.wav");	// spikes tink (used in c code)
	precache_sound ("weapons/grenade.wav");	// grenade launcher
	precache_sound ("weapons/bounce.wav");		// grenade bounce
	precache_sound ("weapons/shotgn2.wav");	// super shotgun
};

#ifndef opgrade
//replaced with define
float() crandom =
{
	return 2*(random() - 0.5);
};
#endif
/*
================
W_FireAxe
================
*/
void() W_FireAxe =
{
	local	vector	source;
	local	vector	org;

	makevectors (self.v_angle);
	source = self.origin + '0 0 16';
	traceline (source, source + v_forward*64, FALSE, self);
	if (trace_fraction == 1.0)
		return;
	
	org = trace_endpos - v_forward*4;

	if (trace_ent.takedamage)
	{
		trace_ent.axhitme = 1;
//		SpawnBlood (org, '0 0 0', 20);
		T_Damage (trace_ent, self, self, 20);
	}
	
	Q3Surface_Impact(org);
			
};


//============================================================================



vector() wall_velocity =
{
	local vector	vel;
	
	vel = normalize (self.velocity);
	vel = normalize(vel + v_up*(random()- 0.5) + v_right*(random()- 0.5));
	vel = vel + 2*trace_plane_normal;
	vel = vel * 200;
	
	return vel;
};


/*
================
SpawnMeatSpray
================
*/
void(vector org, vector vel) SpawnMeatSpray =
{
#define missile 	newmis
//	local	entity missile;//, mpuff;	// fx_warning
//	local	vector	org;

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
//	missile.solid = SOLID_NOT;

	makevectors (self.angles);

	missile.velocity = vel;
	missile.velocity_z = missile.velocity_z + 250 + 50*random();

	missile.avelocity = '3000 1000 2000';
	
// set missile duration
	missile.nextthink = time + 1;
	missile.think = SUB_Remove;

	setmodel (missile, "progs/zom_gib.mdl");
	setsize (missile, '0 0 0', '0 0 0');		
	setorigin (missile, org);
#undef missile
};

/*
================
SpawnBlood
================
*/
void(vector org, vector vel, float damage) SpawnBlood =
{
	particle (org, vel*0.1, 73, damage*2);
};

/*
================
spawn_touchblood
================
*/
void(float damage) spawn_touchblood =
{
	local vector	vel;

	vel = wall_velocity () * 0.2;
	SpawnBlood (self.origin + vel*0.01, vel, damage);
};


/*
================
SpawnChunk
================
*/
#ifdef unused
void(vector org, vector vel) SpawnChunk =
{
	particle (org, vel*0.02, 0, 10);
};

#endif
/*
==============================================================================

MULTI-DAMAGE

Collects multiple small damages into a single damage

==============================================================================
*/

entity	multi_ent;
float	multi_damage;

void() ClearMultiDamage =
{
	multi_ent = world;
	multi_damage = 0;
};

void() ApplyMultiDamage =
{
	if (!multi_ent)
		return;
	T_Damage (multi_ent, self, self, multi_damage);
};

void(entity hit, float damage) AddMultiDamage =
{
	if (!hit)
		return;
	
	if (hit != multi_ent)
	{
		ApplyMultiDamage ();
		multi_damage = damage;
		multi_ent = hit;
	}
	else
		multi_damage = multi_damage + damage;
};

/*
==============================================================================

PROJECTILE TOUCH FUNCTIONS

==============================================================================
*/

void() blasterTouch =
{
	local vector org;

	if (other == self.owner)
		return;		// don't explode on owner

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}

	sound (self, CHAN_WEAPON, "enforcer/enfstop.wav", 1, ATTN_STATIC);
	org = self.origin - 8*normalize(self.velocity);

	if (other.health)
	{
		SpawnBlood (org, self.velocity*0.2, self.dmg);
		T_Damage (other, self, self.owner, self.dmg);
	}
	else
	{
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_GUNSHOT);
		WriteCoord (MSG_BROADCAST, org_x);
		WriteCoord (MSG_BROADCAST, org_y);
		WriteCoord (MSG_BROADCAST, org_z);
	}

	remove(self);
};


/*
=================
fire_rail
=================

void fire_rail (vector start, vector aimdir, int damage)
{
	vector		from;
	vector		end;
	trace_t		tr;
	edict_t		*ignore;
	float			mask;
	qboolean	water;

	VectorMA (start, 8192, aimdir, end);
	VectorCopy (start, from);
	ignore = self;
	water = false;
	mask = MASK_SHOT|CONTENTS_SLIME|CONTENTS_LAVA;
	while (ignore)
	{
		tr = gi.trace (from, NULL, NULL, end, ignore, mask);

		if (tr.contents & (CONTENTS_SLIME|CONTENTS_LAVA))
		{
			mask &= ~(CONTENTS_SLIME|CONTENTS_LAVA);
			water = true;
		}
		else
		{
			//ZOID--added so rail goes through SOLID_BBOX entities (gibs, etc)
			if ((tr.ent->svflags & SVF_MONSTER) || (tr.ent->client) ||
				(tr.ent->solid == SOLID_BBOX))
				ignore = tr.ent;
			else
				ignore = NULL;

			if ((tr.ent != self) && (tr.ent->takedamage))
				T_Damage (tr.ent, self, self, aimdir, tr.endpos, tr.plane.normal, damage, kick, 0, MOD_RAILGUN);
		}

		VectorCopy (tr.endpos, from);
	}

	// send gun puff / flash
	gi.WriteByte (svc_temp_entity);
	gi.WriteByte (TE_RAILTRAIL);
	gi.WritePosition (start);
	gi.WritePosition (tr.endpos);
	gi.multicast (self->s.origin, MULTICAST_PHS);
//	gi.multicast (start, MULTICAST_PHS);
	if (water)
	{
		gi.WriteByte (svc_temp_entity);
		gi.WriteByte (TE_RAILTRAIL);
		gi.WritePosition (start);
		gi.WritePosition (tr.endpos);
		gi.multicast (tr.endpos, MULTICAST_PHS);
	}

	if (self->client)
		PlayerNoise(self, tr.endpos, PNOISE_IMPACT);
}
*/
/*
================
Fire Rilgun
================
*/
void(vector start, vector aimdir, float damage) fireRail =
{
	local	vector	org;
	local	entity	impact_point;

 	nep_traceline (start, aimdir, FALSE, self);
//	if (trace_fraction == 1.0)
//		return;

	org = trace_endpos - aimdir*4;

	if (self.classname == "player"){
//	self.currentammo = self.inv_ammo_bullets = self.inv_ammo_bullets - 1;
	}

	trailparticles(self, particleeffectnum("TR_KNIGHTSPIKE"), start, aimdir);
	trailparticles(self, particleeffectnum("TR_AFRITSPIKE_RED"), start, aimdir);

	impact_point = spawn();
	impact_point.origin = org;
	impact_point.solid = SOLID_NOT;
	impact_point.movetype = MOVETYPE_NONE;
	impact_point.effects = self.effects | EF_LOWPRECISION;
	impact_point.nextthink = time + 0.01;
	setmodel (impact_point, "models/objects/flash/tris.md2");
	impact_point.think = SUB_Remove;
	
	if (trace_ent.takedamage)
	{
		T_Damage (trace_ent, self, self, damage);
	}
	else
	{	// hit wall
		Q3Surface_Impact_Ent(impact_point);
		//sound (impact_sound, CHAN_WEAPON, "player/axhit2.wav", 1, ATTN_NORM);
		/*
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_GUNSHOT);
		WriteCoord (MSG_BROADCAST, org_x);
		WriteCoord (MSG_BROADCAST, org_y);
		WriteCoord (MSG_BROADCAST, org_z);
		*/
		//T_Damage (trace_ent, self, self, WEAPON_DEFAULT_DAMAGE);
	}
};

/*
==============================================================================

BULLETS

==============================================================================
*/

void(float damage, vector dir) TraceAttack;

void() fireBulletSound =
{
	local float	r = random() * 4;
	if (r < 1) sound(self, CHAN_WEAPON, "weapons/Machgf1b.wav", 0.5, ATTN_IDLE);
	else if (r < 2) sound(self, CHAN_WEAPON, "weapons/Machgf2b.wav", 0.5, ATTN_IDLE);
	else if (r < 3) sound(self, CHAN_WEAPON, "weapons/Machgf3b.wav", 0.5, ATTN_IDLE);
	else            sound(self, CHAN_WEAPON, "weapons/Machgf4b.wav", 0.5, ATTN_IDLE);
}

/*
================
FireBullet

Generic hitscan selector for player use single bullet based weapons etc... And railgun!

This will be renamed at some point!
================
*/
void(float damage) FireBullet =
{
	
	local 	vector 	vel; 
	local	vector	source;
	local	vector	org;
	local	entity	impact_point;

//	makevectors (self.v_angle);
	source = self.origin + '0 0 24';
	
 	nep_traceline (source, source + v_forward*4096, FALSE, self);
	if (trace_fraction == 1.0)
		return;

	org = trace_endpos - v_forward*4;

	impact_point = spawn();
	impact_point.origin = org;
	impact_point.solid = SOLID_NOT;
	impact_point.movetype = MOVETYPE_NONE;
	impact_point.effects = self.effects | EF_LOWPRECISION;
	impact_point.nextthink = time + 0.1;
	setmodel (impact_point, "models/objects/flash/tris.md2");
	impact_point.think = SUB_Remove;
	
	if (self.weapon == WEP_MACHINEGUN)
	{
//		fireBulletSound();
//		self.currentammo = self.inv_ammo_bullets = self.inv_ammo_bullets - 1;
		SpawnMuzzleFlash(WEP_MACHINEGUN_MFLASH_OFFSET_FP, WEP_MACHINEGUN_MFLASH_SCALE, 0.5);
	}
	
	if (trace_ent.takedamage)
	{
		if (trace_ent.classname == "monster_tank" || trace_ent.classname == "monster_tank_commander")
		{
			if (self.weapon == WEP_SHOTGUN || self.weapon == WEP_SUPERSHOTGUN || self.weapon == WEP_MACHINEGUN || self.weapon == WEP_CHAINGUN)
			{
				damage = damage * 0.1;
			}
			else if (self.weapon == WEP_RAILGUN)
			{
				damage = damage * 20.0; //goes through armor like a hot knife through butter
				SpawnBlood (org, org*0.2, damage);
			}
			
			T_Damage (trace_ent, self, self, damage);
			Q3Surface_Impact_Ent(impact_point);
		}
		else
		{
			T_Damage (trace_ent, self, self, damage);
		}
	}
	else
	{	// hit wall
		Q3Surface_Impact_Ent(impact_point);
	}
	
	if (self.weapon == WEP_RAILGUN)
	{
		fireRail(self.origin + (v_forward * 70) + (v_right * 20) + (v_up * 15), org, WEAPON_RAILGUN_DAMAGE);
		self.currentammo = self.inv_ammo_slugs = self.inv_ammo_slugs - 1;
	}
	
	if (self.weapon == WEP_CHAINGUN)
	{
		fireBulletSound();
		self.currentammo = self.inv_ammo_bullets = self.inv_ammo_bullets - 1;
		#ifndef new_weapon_generic
		//self.weaponstate = WEAPON_SPINDOWN;
		#endif
		SpawnMuzzleFlash(WEP_MACHINEGUN_MFLASH_OFFSET_FP, 2, 0.5);
		sound (self, CHAN_WEAPON2, "weapons/chngnl1a.wav", 0.5, ATTN_NORM); //spinning
	}
};

/*
================
Q3 Surface TraceAttack
================
*/
void(float damage, vector dir) Q3SurfaceTraceAttack =
{
	local vector vel; 
	local vector org;
	local entity impact_point;
	
	vel = normalize(dir + v_up*crandom() + v_right*crandom());
	vel = vel + 2*trace_plane_normal;
	vel = vel * 200;
	
	org = trace_endpos - dir*4;

	impact_point = spawn();
	impact_point.origin = org;
	impact_point.solid = SOLID_NOT;
	impact_point.movetype = MOVETYPE_NONE;
	impact_point.effects = self.effects | EF_LOWPRECISION;
	impact_point.nextthink = time + 0.01;
	setmodel (impact_point, "models/objects/flash/tris.md2");
	impact_point.think = SUB_Remove;
	
	if (trace_ent.takedamage && trace_ent.flags & FL_MONSTER || trace_ent.classname == "player")
	{
		if (trace_ent.classname == "monster_tank" || trace_ent.classname == "monster_tank_commander")
		{
			damage = damage * 0.1;
			Q3Surface_Impact_Ent(impact_point);
		}	
		else
		{
			SpawnBlood (org, vel*0.2, damage);
		}
		AddMultiDamage (trace_ent, damage);
	//	Q3Surface_Impact_Ent(impact_point);
	}
	else
	{
		AddMultiDamage (trace_ent, damage);
		Q3Surface_Impact_Ent(impact_point);
	}
};

/*
================
Fire_Lead
================
*/
void(vector org, vector dir, vector spread, float damage) fire_lead =
{
	local	vector direction;
	local	vector	src;

	direction = dir + crandom()*spread_x*v_right + crandom()*spread_y*v_up;

	traceline (org, org + direction*2048, FALSE, self);
		
	if (trace_fraction != 1.0)
	{
		if (self.weapon == WEP_SHOTGUN)
		{
			Q3SurfaceTraceAttack(WEAPON_SHOTGUN_DAMAGE, direction);
		}
		else
		{
			Q3SurfaceTraceAttack(damage, direction);				
		}	
	}	
};

/*
================
FireBullets

Used by shotgun, super shotgun, and enemy soldier firing
Go to the trouble of combining multiple pellets into a single damage call.
================
*/
void(float shotcount, vector org, vector dir, vector spread, float damage) FireBullets =
{
	local	vector direction;
	local	vector	src;
	
//	makevectors(self.v_angle);

//	src = self.origin + v_forward*10;
//	src_z = self.absmin_z + self.size_z * 0.7;

	ClearMultiDamage ();
	while (shotcount > 0)
	{
		direction = dir + crandom()*spread_x*v_right + crandom()*spread_y*v_up;

		traceline (org, org + direction*2048, FALSE, self);
		
		if (trace_fraction != 1.0)
		{
			if (self.weapon == WEP_SHOTGUN)
			{
				Q3SurfaceTraceAttack(WEAPON_SHOTGUN_DAMAGE, direction);
			}
			else
			{
				Q3SurfaceTraceAttack(damage, direction);				
			}	
		}	
		//	TraceAttack (4, direction);

		shotcount = shotcount - 1;
		
	}
	ApplyMultiDamage ();
};

/*
================
TraceAttack
================
*/
void(float damage, vector dir) TraceAttack =
{
	local	vector	vel, org;
	
	vel = normalize(dir + v_up*crandom() + v_right*crandom());
	vel = vel + 2*trace_plane_normal;
	vel = vel * 200;

	org = trace_endpos - dir*4;

	if (trace_ent.takedamage)
	{
	//	SpawnBlood (org, vel*0.2, damage);
		AddMultiDamage (trace_ent, damage);
	}
	else
	{
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_GUNSHOT);
		WriteCoord (MSG_BROADCAST, org_x);
		WriteCoord (MSG_BROADCAST, org_y);
		WriteCoord (MSG_BROADCAST, org_z);
	}
};

/*
================
W_FireShotgun
================
*/
void() W_FireShotgun =
{
	local vector dir;
	local vector src;
	
	makevectors(self.v_angle);

	src = self.origin + v_forward*10;
	src_z = self.absmin_z + self.size_z * 0.7;	
	
	sound (self, CHAN_WEAPON, "weapons/Shotgf1b.wav", 1, ATTN_NORM);		
	self.punchangle_x = -2;
	
	self.currentammo = self.inv_ammo_shells = self.inv_ammo_shells - 1;
	dir = aim (self, 100000);
	self.solid = SOLID_BBOX;
	FireBullets (6, src, dir, '0.04 0.04 0', WEAPON_SHOTGUN_DAMAGE);
	self.solid = SOLID_SLIDEBOX;
};


/*
================
W_FireSuperShotgun
================
*/
void() W_FireSuperShotgun =
{
	local vector dir;
	local vector src;
	
//	makevectors(self.v_angle);

	src = self.origin + v_forward*10;
	src_z = self.absmin_z + self.size_z * 0.7;	
	
	if (self.currentammo == 1)
	{
		W_FireShotgun ();
		return;
	}
		
	//sound (self ,CHAN_WEAPON, "weapons/shotgn2.wav", 1, ATTN_NORM);	

	self.punchangle_x = -4;
	
	self.currentammo = self.inv_ammo_shells = self.inv_ammo_shells - 2;
	dir = aim (self, 100000);
	
	self.solid = SOLID_BBOX;
	FireBullets (14, src, dir, '0.14 0.08 0', WEAPON_SUPERSHOTGUN_DAMAGE);
	self.solid = SOLID_SLIDEBOX;
};

/*
==============================================================================

ROCKETS

==============================================================================
*/

void() GrenadeExplode;

/*
void()	s_explode1	=	[0,		s_explode2] {};
void()	s_explode2	=	[1,		s_explode3] {};
void()	s_explode3	=	[2,		s_explode4] {};
void()	s_explode4	=	[3,		s_explode5] {};
void()	s_explode5	=	[4,		s_explode6] {};
void()	s_explode6	=	[5,		SUB_Remove] {};
*/

framer(0, 5, s_explode1, SUB_Remove, 0.1,SUB_Null());

void() BecomeExplosion =
{
	self.movetype = MOVETYPE_NONE;
	self.velocity = '0 0 0';
	self.touch = SUB_Null;
	setmodel (self, "progs/s_explod.spr");
	self.solid = SOLID_NOT;
	self.think = SUB_Remove;
	self.nextthink = 0.6;
	effect(self.origin, "progs/s_explod.spr", 0, 5, 10);
};

void() T_MissileTouch =
{
	local float	damg;

	if (other == self.owner)
		return;		// don't explode on owner

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	
	if (trace_dphitq3surfaceflags & Q3SURFACEFLAG_SKY)
	{
		remove(self);
		return;
	}	

	damg = self.dmg;
	
	if (other.health)
	{
		if (other.classname == "monster_shambler")
			damg = damg * 0.5;	// mostly immune
		T_Damage (other, self, self.owner, self.dmg );
	}

#ifdef opgrade

	self.origin = self.origin - 8*normalize(self.velocity);

	if (!self.dmg) self.dmg = 120;

// same explode code except for 8 q-unit reposition				- note: other adjust in fn call
	GrenadeExplode();

#else
	// don't do radius damage to the other, because all the damage
	// was done in the impact
	T_RadiusDamage (self, self.owner, 120, other);

//	sound (self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM);
	self.origin = self.origin - 8*normalize(self.velocity);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);

	BecomeExplosion ();
#endif
};


void(vector org, vector dir) launch_spike;
/*
================
W_FireRocket
================
*/
void() W_FireRocket =
{
	local vector source;
	self.currentammo = self.inv_ammo_rockets = self.inv_ammo_rockets - 1;
	
	sound (self, CHAN_WEAPON, "weapons/sgun1.wav", 1, ATTN_NORM);

	self.punchangle_x = -2;

//	launch_spike(self.origin + v_forward*8 + '0 0 16', aim(self, PLAYER_ROCKET_SPEED));

	newmis = spawn ();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLYMISSILE;
	newmis.solid = SOLID_BBOX;
	newmis.dmg = WEAPON_ROCKET_DAMAGE;
	newmis.modelflags = MF_ROCKET;

	newmis.classname = "missile";
		
// set missile speed	

//	makevectors (self.v_angle);
	newmis.velocity = aim(self, PLAYER_ROCKET_SPEED);
	newmis.velocity = newmis.velocity * PLAYER_ROCKET_SPEED;
	newmis.angles = vectoangles(newmis.velocity);

	newmis.touch = T_MissileTouch;
	
// set missile duration

	newmis.nextthink = time + 5;
	newmis.think = SUB_Remove;

	source = G_ProjectSource (self.origin, '20 8 17', v_forward, v_right, '0 0 0');

	setmodel (newmis, "models/objects/rocket/tris.md2");
	setsize (newmis, '0 0 0', '0 0 0');
	setorigin (newmis, source);	
//	setorigin (newmis, self.origin + v_forward*8 + '0 0 16');
};


void() T_BFGTouch =
{
//	local float	damg;

	if (other == self.owner)
		return;		// don't explode on owner

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	
	if (trace_dphitq3surfaceflags & Q3SURFACEFLAG_SKY)
	{
		remove(self);
		return;
	}	

//	damg = self.dmg;

#ifdef opgrade

	self.origin = self.origin - 8*normalize(self.velocity);

	if (!self.dmg) self.dmg = 120;

// same explode code except for 8 q-unit reposition				- note: other adjust in fn call
	GrenadeExplode();

#else
	// don't do radius damage to the other, because all the damage
	// was done in the impact
	T_RadiusDamageRad (self, self.owner, self.dmg, self.owner, self.dmgradius);

//	sound (self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM);
	self.origin = self.origin - 8*normalize(self.velocity);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);

	BecomeExplosion ();
#endif
};

void(vector org, vector vec, float dmg, vector colortint, float mflags) monster_fire_blaster;
/*
void() bfg_think =
{
	local entity ent;
	local entity ignore;
	local vector point;
	local vector dir;
	local vector start;
	local vector end;
	local float	dmg;

	if (deathmatch)
		dmg = sk_bfg_damage2_dm->value; //was 5
	else
		dmg = sk_bfg_damage2->value; //was 10

	ent = 0;
	while ((ent = findradius(ent, self.origin, 500)) != NULL)
	{
		if (ent == self)
			continue;

		if (ent == self.owner)
			continue;

		if (!ent.takedamage)
			continue;

		if (!(ent.flags & FL_MONSTER) && (!ent.client) && (strcmp(ent.classname, "misc_explobox") != 0))
			continue;


	//ZOID
		//don't target friendly players in CTF
		if (ctf->value && ent->client &&
			self->owner->client &&
			ent->client->resp.ctf_team == self->owner->client->resp.ctf_team)
			continue;
	//ZOID

		VectorMA (ent->absmin, 0.5, ent->size, point);

		VectorSubtract (point, self->s.origin, dir);
		VectorNormalize (dir);

		ignore = self;
		VectorCopy (self->s.origin, start);
		VectorMA (start, 2048, dir, end);
		while(1)
		{
			tr = gi.trace (start, NULL, NULL, end, ignore, CONTENTS_SOLID|CONTENTS_MONSTER|CONTENTS_DEADMONSTER);

			if (!tr.ent)
				break;

			// hurt it if we can
			if ((tr.ent->takedamage) && !(tr.ent->flags & FL_IMMUNE_LASER) && (tr.ent != self->owner))
				T_Damage (tr.ent, self, self->owner, dir, tr.endpos, vec3_origin, dmg, 1, DAMAGE_ENERGY, MOD_BFG_LASER);

			// if we hit something that's not a monster or player we're done
			if (!(tr.ent->svflags & SVF_MONSTER) && (!tr.ent->client))
			{
				gi.WriteByte (svc_temp_entity);
				gi.WriteByte (TE_LASER_SPARKS);
				gi.WriteByte (4);
				gi.WritePosition (tr.endpos);
				gi.WriteDir (tr.plane.normal);
				gi.WriteByte (self->s.skinnum);
				gi.multicast (tr.endpos, MULTICAST_PVS);
				break;
			}

			ignore = tr.ent;
			VectorCopy (tr.endpos, start);
		}

		gi.WriteByte (svc_temp_entity);
		gi.WriteByte (TE_BFG_LASER);
		gi.WritePosition (self->s.origin);
		gi.WritePosition (tr.endpos);
		gi.multicast (self->s.origin, MULTICAST_PHS);

		if(level.num_reflectors)
			ReflectTrail(TE_BFG_LASER,self->s.origin,tr.endpos);
	}

	self->nextthink = level.time + FRAMETIME;
}
*/

void(vector start, vector aimdir, float damage) fireBFGtrail =
{
	local	vector	org;
	local	entity	impact_point;

 	nep_traceline (start, aimdir, FALSE, self);
	if (trace_fraction == 1.0)
		return;

	org = trace_endpos - aimdir*4;

	trailparticles(self, particleeffectnum("TR_WIZSPIKE_2"), start, aimdir);
	
	if (trace_ent.takedamage)
	{
		T_Damage (trace_ent, self, self.owner, damage);
		
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_EXPLOSION);
		WriteCoord (MSG_BROADCAST, org_x);
		WriteCoord (MSG_BROADCAST, org_y);
		WriteCoord (MSG_BROADCAST, org_z);
	}
};

//MrC: Idea, use this as a base for a tesla ball, target points and hit them with beams. Points could follow a path or just randomize directions. 
//A future weapon could use this as a recharge, something like in Prey. Get in range with the weapon selected and leech energy.

void() m_BFGthink =
{
	local entity BFGtarget;
	local vector dir;
	local float BFGdist;
	BFGdist = 500;
	local float BFGTargetCount, BFGFireCount;

	dir = normalize(self.origin - BFGtarget.origin);
	
	BFGtarget = findradius(self.origin, BFGdist);
	BFGTargetCount = 0;
	BFGFireCount = 0;
	while(BFGtarget)
	{
		if(BFGtarget.flags & FL_CLIENT)
		{
			if(BFGtarget.health > 0)
			{
				BFGTargetCount++;
				bprint("BFG targets: ");
				bprint (ftos(BFGTargetCount));
				bprint("\n");
				if (vlen(BFGtarget.origin - self.origin) < BFGdist)
				{
					if (visible(BFGtarget) ){
						fireBFGtrail(self.origin, BFGtarget.origin, 20);
						BFGFireCount++;
						bprint("BFG Fire count: ");
						bprint (ftos(BFGFireCount));
						bprint("\n");
					}					
				}
			}
		}
	BFGtarget = BFGtarget.chain;
	}
	
	self.nextthink = time + 1;
	self.think = m_BFGthink;
}

void() BFGthink =
{
	local entity BFGtarget;
	local vector dir;
	local float BFGdist;
	BFGdist = 500;
	local float BFGTargetCount, BFGFireCount;

	dir = normalize(self.origin - BFGtarget.origin);
	
	BFGtarget = findradius(self.origin, BFGdist);
	BFGTargetCount = 0;
	BFGFireCount = 0;
	while(BFGtarget)
	{
		if(BFGtarget.flags & FL_MONSTER)
		{
			if(BFGtarget.health > 0)
			{
				BFGTargetCount++;
				bprint("BFG targets: ");
				bprint (ftos(BFGTargetCount));
				bprint("\n");
				if (vlen(BFGtarget.origin - self.origin) < BFGdist)
				{
					if (visible(BFGtarget) ){
						fireBFGtrail(self.origin, BFGtarget.origin, 20);
						BFGFireCount++;
						bprint("BFG Fire count: ");
						bprint (ftos(BFGFireCount));
						bprint("\n");
					}
				
				}
				
			}
			
		}
	BFGtarget = BFGtarget.chain;
	}
	
	self.nextthink = time + 1;
	self.think = BFGthink;
}

/*
===============================================================================

LIGHTNING

===============================================================================
*/

/*
=================
LightningDamage
=================
*/
void(vector p1, vector p2, entity from, float damage) LightningDamage =
{
	local entity		e1, e2;
	local vector		f;
	
	f = p2 - p1;
	normalize (f);
	f_x = 0 - f_y;
	f_y = f_x;
	f_z = 0;
	f = f*16;

	e1 = e2 = world;

	traceline (p1, p2, FALSE, self);
	if (trace_ent.takedamage)
	{
		particle (trace_endpos, '0 0 100', 225, damage*4);
		T_Damage (trace_ent, from, from, damage);
		if (self.classname == "player")
		{
			if (other.classname == "player")
				trace_ent.velocity_z = trace_ent.velocity_z + 400;
		}
	}
	e1 = trace_ent;

	traceline (p1 + f, p2 + f, FALSE, self);
	if (trace_ent != e1 && trace_ent.takedamage)
	{
		particle (trace_endpos, '0 0 100', 225, damage*4);
		T_Damage (trace_ent, from, from, damage);
	}
	e2 = trace_ent;

	traceline (p1 - f, p2 - f, FALSE, self);
	if (trace_ent != e1 && trace_ent != e2 && trace_ent.takedamage)
	{
		particle (trace_endpos, '0 0 100', 225, damage*4);
		T_Damage (trace_ent, from, from, damage);
	}
};


void() W_FireLightning =
{
	local	vector		org;
	local	float		cells;

	if (self.inv_ammo_cells < 1)
	{
		self.weapon = W_BestWeapon ();
		W_SetCurrentAmmo ();
		return;
	}

// explode if under water
	if (self.waterlevel > 1)
	{
		cells = self.inv_ammo_cells;
		self.inv_ammo_cells = 0;
		W_SetCurrentAmmo ();
		T_RadiusDamage (self, self, 35*cells, world);
		return;
	}

	if (self.t_width < time)
	{
		sound (self, CHAN_WEAPON, "weapons/lhit.wav", 1, ATTN_NORM);
		self.t_width = time + 0.6;
	}
	self.punchangle_x = -2;

	self.currentammo = self.inv_ammo_cells = self.inv_ammo_cells - 1;

	org = self.origin + '0 0 16';
	
	traceline (org, org + v_forward*600, TRUE, self);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_LIGHTNING2);
	WriteEntity (MSG_BROADCAST, self);
	WriteCoord (MSG_BROADCAST, org_x);
	WriteCoord (MSG_BROADCAST, org_y);
	WriteCoord (MSG_BROADCAST, org_z);
	WriteCoord (MSG_BROADCAST, trace_endpos_x);
	WriteCoord (MSG_BROADCAST, trace_endpos_y);
	WriteCoord (MSG_BROADCAST, trace_endpos_z);

	LightningDamage (self.origin, trace_endpos + v_forward*4, self, 30);
};


//=============================================================================

void() GrenadeExplode =
{
// qc++
	if (!self.dmg) self.dmg = 50; // default

#ifdef opgrade
// missile comes here with other set to the direct damage ent, we need world for grenades
	if (self.classname == "grenade") other = world;
	T_RadiusDamage (self, self.owner, self.dmg, other);
#else
	T_RadiusDamage (self, self.owner, self.dmg, world);
#endif


	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);

	BecomeExplosion ();
};

void() GrenadeTouch =
{
	if (other == self.owner)
		return;		// don't explode on owner
	if (other.takedamage == DAMAGE_AIM)
	{
		GrenadeExplode();
		return;
	}
	sound (self, CHAN_WEAPON, "weapons/bounce.wav", 1, ATTN_NORM);	// bounce sound
	if (!self.velocity) // == '0 0 0')
		self.avelocity = '0 0 0';
};

/*
================
W_FireGrenade
================
*/
void() W_FireGrenade =
{
//	local	entity missile;//, mpuff;	// fx_warning
	local vector source;
	
	sound (self, CHAN_WEAPON, "weapons/GRENLF1A.WAV", 1, ATTN_NORM);	
	sound (self, CHAN_WEAPON2, "weapons/Grenlr1b.wav", 1, ATTN_NORM);

	newmis = spawn ();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_BOUNCE;
	newmis.solid = SOLID_BBOX;
	newmis.classname = "grenade";

	if (self.classname == "player")
	{
		self.currentammo = self.inv_ammo_rockets = self.inv_ammo_rockets - 1;
		
		self.punchangle_x = -2;

// set missile speed	

//		makevectors (self.v_angle);

		if (self.v_angle_x)
			newmis.velocity = v_forward*600 + v_up * 200 + crandom()*v_right*10 + crandom()*v_up*10;
		else
		{
			newmis.velocity = aim(self, 10000);
			newmis.velocity = newmis.velocity * 600;
			newmis.velocity_z = 200;
		}
// qc++
		newmis.dmg = 120;
	}
	else // monsters come here - may need to qualify individuals
	{
// ogre fires a grenade

		self.effects = self.effects | EF_MUZZLEFLASH;

		makevectors (self.angles);

		newmis.velocity = normalize(self.enemy.origin - self.origin);
		newmis.velocity = newmis.velocity * 600;
		newmis.velocity_z = 200;

		newmis.dmg = 40;
	}

	newmis.avelocity = '300 300 300';

	newmis.angles = vectoangles(newmis.velocity);
	
	newmis.touch = GrenadeTouch;

// set missile duration
	newmis.nextthink = time + 2.5;
	newmis.think = GrenadeExplode;

	source = G_ProjectSource (self.origin, '20 8 17', v_forward, v_right, '0 0 0');

	setmodel (newmis, "progs/grenade.mdl");
	setsize (newmis, '0 0 0', '0 0 0');		
//	setorigin (newmis, self.origin);
	setorigin (newmis, source);
};

/*

MrC: Spikes left in mostly for Q1 monster support. Can probbaly be cleaned up to remove player specific stuff.

*/

void() spike_touch;

#ifdef opgrade

// recoded to replace this - on superspikes, self.dmg = 18 at launch		- self.spike_type will be set to TE_SUPERSPIKE in touch if dmg > 15
#define superspike_touch		spike_touch

#else

void() superspike_touch;

#endif


/*
===============
launch_spike

Used for both the player and the ogre
===============
*/
void(vector org, vector dir) launch_spike =
{
	newmis = spawn ();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLYMISSILE;
	newmis.solid = SOLID_BBOX;

	newmis.angles = vectoangles(dir);
	
	newmis.touch = spike_touch;
	newmis.classname = "spike";
	newmis.think = SUB_Remove;
	newmis.nextthink = time + 6;
	setmodel (newmis, "progs/spike.mdl");
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);		
	setorigin (newmis, org);

	newmis.velocity = dir * 1000;
};

void() spike_touch =
{
//local float rand;	// fx_warning
	if (other == self.owner)
		return;

	if (other.solid == SOLID_TRIGGER)
		return;	// trigger field, do nothing

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	
	if (!self.dmg) self.dmg = 9;

// hit something that bleeds
// need to qualify doors / triggers and other damageables that should _not_ bleed
	if (other.takedamage)
	{
	//	spawn_touchblood (self.dmg);
		T_Damage (other, self, self.owner, self.dmg);
	}
	else
	{
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);

			/// uncomment - this code will allow per entity spike_type overrides
///		if (!self.spike_type)
///		{
			self.spike_type = TE_SPIKE;
			if (self.classname == "wizspike") self.spike_type = TE_WIZSPIKE;
//			WriteByte (MSG_BROADCAST, TE_WIZSPIKE);
//			else
			if (self.classname == "knightspike") self.spike_type = TE_KNIGHTSPIKE;
//			WriteByte (MSG_BROADCAST, TE_KNIGHTSPIKE);
///		}
		WriteByte (MSG_BROADCAST, self.spike_type);
		WriteCoord (MSG_BROADCAST, self.origin_x);
		WriteCoord (MSG_BROADCAST, self.origin_y);
		WriteCoord (MSG_BROADCAST, self.origin_z);
	}

	remove(self);

};


#ifndef opgrade

void() superspike_touch =
{
//local float rand;	// fx_warning
	if (other == self.owner)
		return;

	if (other.solid == SOLID_TRIGGER)
		return;	// trigger field, do nothing

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	
// hit something that bleeds
	if (other.takedamage)
	{
	//	spawn_touchblood (18);
		T_Damage (other, self, self.owner, 18);
	}
	else
	{
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_SUPERSPIKE);
		WriteCoord (MSG_BROADCAST, self.origin_x);
		WriteCoord (MSG_BROADCAST, self.origin_y);
		WriteCoord (MSG_BROADCAST, self.origin_z);
	}

	remove(self);

};

#endif


