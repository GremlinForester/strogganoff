/*
*/
void (entity targ, entity inflictor, entity attacker, float damage) T_Damage;
void () q2player_run;
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
#endifdef
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

#endifdef
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
		SpawnBlood (org, self.velocity*0.2, self.damage);
		T_Damage (other, self, self.owner, self.damage);
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

/*
================
FireBullet

Generic hitscan selector for player use single bullet based weapons etc... And railgun!

This will be renamed at some point!
================
*/
void(float damage) FireBullet =
{
	local	vector	source;
	local	vector	org;
	local	entity	impact_point;

	makevectors (self.v_angle);
	source = self.origin + '0 0 24';
	
 	nep_traceline (source, source + v_forward*4096, FALSE, self);
	if (trace_fraction == 1.0)
		return;

	org = trace_endpos - v_forward*4;

	self.currentammo = self.inv_ammo_bullets = self.inv_ammo_bullets - 1;

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
	}
	
	local float	r = random() * 4;
	if (r < 1) sound(self, CHAN_WEAPON, "weapons/Machgf1b.wav", 0.5, ATTN_IDLE);
	else if (r < 2) sound(self, CHAN_WEAPON, "weapons/Machgf2b.wav", 0.5, ATTN_IDLE);
	else if (r < 3) sound(self, CHAN_WEAPON, "weapons/Machgf3b.wav", 0.5, ATTN_IDLE);
	else            sound(self, CHAN_WEAPON, "weapons/Machgf4b.wav", 0.5, ATTN_IDLE);
	
	
	if (self.weapon == WEP_RAILGUN)
	{
		fireRail(self.origin + (v_forward * 70) + (v_right * 20) + (v_up * 15), org, WEAPON_RAILGUN_DAMAGE);
	}
	
	if (self.weapon == WEP_MACHINEGUN)
	{
		SpawnMuzzleFlash(WEP_MACHINEGUN_MFLASH_OFFSET_FP, WEP_MACHINEGUN_MFLASH_SCALE, 0.5);
	}
	
	if (self.weapon == WEP_CHAINGUN)
	{
		self.weaponstate = WEAPON_SPINDOWN;
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
		SpawnBlood (org, vel*0.2, damage);
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

	//MrC: fixes a sound bug where one shell left on supershotgun makes normal shotgun sound	
	if (self.weapon == WEP_SUPERSHOTGUN)
	{
		sound (self ,CHAN_WEAPON, "weapons/shotgn2.wav", 1, ATTN_NORM);
	}
	else
	{
		sound (self, CHAN_WEAPON, "weapons/guncock.wav", 1, ATTN_NORM);		
	}
	
	self.punchangle_x = -2;
	
	self.currentammo = self.ammo_shells = self.ammo_shells - 1;
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
	
	makevectors(self.v_angle);

	src = self.origin + v_forward*10;
	src_z = self.absmin_z + self.size_z * 0.7;	
	
	if (self.currentammo == 1)
	{
		W_FireShotgun ();
		return;
	}
		
	sound (self ,CHAN_WEAPON, "weapons/shotgn2.wav", 1, ATTN_NORM);	

	self.punchangle_x = -4;
	
	self.currentammo = self.ammo_shells = self.ammo_shells - 2;
	dir = aim (self, 100000);

	FireBullets (14, src, dir, '0.14 0.08 0', WEAPON_SUPERSHOTGUN_DAMAGE);
};

/*
================
W_FireBlaster
================
*/

void()blasterTouch;

void() W_FireBlaster =
{
	local vector source;
	local vector rotation_offset;
	local float rotation;
		
	self.punchangle_x = -3;
	newmis = spawn ();
	newmis.owner = self;
	newmis.damage = WEAPON_BLASTER_DAMAGE;
	newmis.movetype = MOVETYPE_FLYMISSILE;
	newmis.solid = SOLID_BBOX;
	newmis.classname = "blasterbolt";
	newmis.glow_color = '200 0 0';
	newmis.glow_size = 100;
	newmis.light_lev = 200;
    newmis.modelflags = MF_TRACER2;
	newmis.color = '1 0 0'; // color (does not affect radius), typical value '1 1 1' (bright white), can be up to '255 255 255' (nuclear blast)
	newmis.style = 6; // light style (like normal light entities, flickering torches or switchable, etc)
	newmis.pflags = PFLAGS_FULLDYNAMIC; // flags (see PFLAGS_ constants)

// set missile speed

	makevectors (self.v_angle);
	newmis.velocity = aim(self, PLAYER_ROCKET_SPEED);
	newmis.velocity = newmis.velocity * PLAYER_ROCKET_SPEED;
	newmis.angles = vectoangles(newmis.velocity);

	newmis.touch = blasterTouch;

// set missile duration

	newmis.nextthink = time + 5;
	newmis.think = SUB_Remove;

	source = G_ProjectSource (self.origin, '20 8 17', v_forward, v_right, '0 0 0'); //24 -18 22
	
	setmodel (newmis, "progs/laser.mdl");
	setsize (newmis, '4 4 4', '4 4 4');
	setorigin (newmis, source);
	
	SpawnMuzzleFlash(WEP_BLASTER_MFLASH_OFFSET_FP, WEP_BLASTER_MFLASH_SCALE, 0.5);
	SpawnMuzzleFlashTP(WEP_BLASTER_MFLASH_OFFSET_TP, 0.5);
	
	if (self.weapon == WEP_HYPERBLASTER)
	{
		self.currentammo = self.ammo_cells = self.ammo_cells - 1;
		self.weaponstate = WEAPON_SPINDOWN;
		sound (self, CHAN_WEAPON2, "weapons/hyprbl1a.wav", 0.7, ATTN_NORM);
		sound (self, CHAN_WEAPON, "weapons/Hyprbf1a.wav", 1, ATTN_NORM);
		
		rotation = (self.weaponframe - 5) * 2*PI/3; //2*PI/6
		
		rotation_offset_x = -6 * sin(rotation); //-4
		rotation_offset_y = 6;					// 0
		rotation_offset_z = 6 * cos(rotation); //4
		
		source = G_ProjectSource (self.origin, '20 6 10' + rotation_offset, v_forward, v_right, '0 0 0'); //24 -18 22
		setorigin (newmis, source);
	}
	else if (self.weapon == WEP_BLASTER)
	{
		sound (self, CHAN_WEAPON, "weapons/BLASTF1A.WAV", 1, ATTN_NORM);
	}
	else
	{
		self.currentammo = self.ammo_cells = self.ammo_cells - 5; //ammo cost for testing BFG and Railgun
	}
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
	s_explode1 ();
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

	damg = self.damage;
	
	if (other.health)
	{
		if (other.classname == "monster_shambler")
			damg = damg * 0.5;	// mostly immune
		T_Damage (other, self, self.owner, self.damage );
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
#endifdef
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
	self.currentammo = self.ammo_rockets = self.ammo_rockets - 1;
	
	sound (self, CHAN_WEAPON, "weapons/sgun1.wav", 1, ATTN_NORM);

	self.punchangle_x = -2;

//	launch_spike(self.origin + v_forward*8 + '0 0 16', aim(self, PLAYER_ROCKET_SPEED));

	newmis = spawn ();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLYMISSILE;
	newmis.solid = SOLID_BBOX;
	newmis.damage = WEAPON_ROCKET_DAMAGE;
	newmis.modelflags = MF_ROCKET;

	newmis.classname = "missile";
		
// set missile speed	

	makevectors (self.v_angle);
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

	if (self.ammo_cells < 1)
	{
		self.weapon = W_BestWeapon ();
		W_SetCurrentAmmo ();
		return;
	}

// explode if under water
	if (self.waterlevel > 1)
	{
		cells = self.ammo_cells;
		self.ammo_cells = 0;
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

	self.currentammo = self.ammo_cells = self.ammo_cells - 1;

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
#endifdef


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
		self.currentammo = self.ammo_rockets = self.ammo_rockets - 1;
		
		self.punchangle_x = -2;

// set missile speed	

		makevectors (self.v_angle);

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

#endifdef


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

#ifdef opgrade


// damage we exceed to make a super spike
#define SPIKE_DMG_SUPER		15

// recode - all in one
//					- if ox = 0, this will fire superspikes
//					  or if self.weaon = IT_SUPER_NAILGUN and self.ammo_nails > 1

// if needed - not called in original code without the qualifier in W_FireSpikes
#define W_FireSuperSpikes() W_FireSpikes(0)

void(float ox) W_FireSpikes =
{

	if (self.ammo_nails < 1)
	{
		self.weapon = W_BestWeapon ();
		W_SetCurrentAmmo ();
		return;
	}
	
	makevectors (self.v_angle);

	sound (self, CHAN_WEAPON, "weapons/rocket1i.wav", 1, ATTN_NORM);

	if (self.ammo_nails >= 2 && self.weapon == IT_SUPER_NAILGUN) ox = 0;

#ifdef noautoaim
	launch_spike (self.origin + '0 0 16' + v_right*ox, v_forward);
#else
	local vector	dir;
	dir = aim (self, 1000);
	launch_spike (self.origin + '0 0 16' + v_right*ox, dir);
#endifdef
	
	if (!ox)
	{
		sound (self, CHAN_WEAPON, "weapons/spike2.wav", 1, ATTN_NORM);
		self.ammo_nails = self.ammo_nails - 1;
		newmis.touch = superspike_touch;
		setmodel (newmis, "progs/s_spike.mdl");
		setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);		
		newmis.dmg = 18;
	}

	self.attack_finished = time + 0.2;
	self.currentammo = self.ammo_nails = self.ammo_nails - 1;

	self.punchangle_x = -2;
};

#else

// if opgrade is defined separate spike code below is all folded into one function for both / all types

void() W_FireSuperSpikes =
{
	local vector	dir;
//	local entity	old;	// fx_warning
	
	sound (self, CHAN_WEAPON, "weapons/spike2.wav", 1, ATTN_NORM);
	self.attack_finished = time + 0.2;
	self.currentammo = self.ammo_nails = self.ammo_nails - 2;
	dir = aim (self, 1000);
	launch_spike (self.origin + '0 0 16', dir);
	newmis.touch = superspike_touch;
	setmodel (newmis, "progs/s_spike.mdl");
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);		
	newmis.dmg = 18;
	self.punchangle_x = -2;
};

void(float ox) W_FireSpikes =
{
	local vector	dir;
//	local entity	old;	// fx_warning
	
	makevectors (self.v_angle);
	
	if (self.ammo_nails >= 2 && self.weapon == IT_SUPER_NAILGUN)
	{
		W_FireSuperSpikes ();
		return;
	}

	if (self.ammo_nails < 1)
	{
		self.weapon = W_BestWeapon ();
		W_SetCurrentAmmo ();
		return;
	}

	sound (self, CHAN_WEAPON, "weapons/rocket1i.wav", 1, ATTN_NORM);
	self.attack_finished = time + 0.2;
	self.currentammo = self.ammo_nails = self.ammo_nails - 1;
	dir = aim (self, 1000);
	launch_spike (self.origin + '0 0 16' + v_right*ox, dir);
	self.punchangle_x = -2;

};
#endifdef


//.float hit_z;	// fx_warning
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
#ifdef opgrade
			if (self.dmg > SPIKE_DMG_SUPER) self.spike_type = TE_SUPERSPIKE;
#endifdef
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

#endifdef


