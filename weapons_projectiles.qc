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

//Quake 2
	precache_sound ("weapons/BLASTF1A.WAV");
	precache_sound ("weapons/HGRENT1A.WAV");
	precache_sound ("weapons/noammo.wav");
	precache_sound ("weapons/BLASTF1A.WAV");
	precache_sound ("weapons/Shotgr1b.wav");
	precache_sound ("weapons/Shotgf1b.wav");
	precache_sound ("weapons/Sshotf1b.wav");
	precache_sound ("weapons/Machgf1b.wav");
	precache_sound ("weapons/Machgf2b.wav");
	precache_sound ("weapons/Machgf3b.wav");
	precache_sound ("weapons/Machgf4b.wav");
	precache_sound ("weapons/Machgf5b.wav");
	precache_sound ("weapons/chngnu1a.wav");
	precache_sound ("weapons/chngnd1a.wav");
	precache_sound ("weapons/chngnl1a.wav");
	precache_sound ("weapons/Grenlr1b.WAV");
	precache_sound ("weapons/GRENLF1A.WAV");
	precache_sound ("weapons/Rocklr1b.wav");
	precache_sound ("weapons/ROCKLF1A.WAV");
	precache_sound ("weapons/Hyprbf1a.wav");
	precache_sound ("weapons/Hyprbl1a.wav");
	precache_sound ("weapons/hyprbd1a.wav");
	precache_sound ("weapons/RAILGF1A.WAV");
	precache_sound ("weapons/Bfg__f1y.wav");

	precache_sound ("misc/ar1_pkup.wav");
	
};

/*
================
W_FireMelee
================
*/
void() W_FireMelee =
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
================
Fire Rilgun
================
*/
void(vector start, vector aimdir, float damage) fireRail =
{
	local	vector	org;
	local	vector	loc;
	local	vector	fx_end;	

 	nep_traceline (start, aimdir, FALSE, self);
//	if (trace_fraction == 1.0)
//		return;

	org = trace_endpos - aimdir*4;

	if (self.classname == "player"){
//	self.currentammo = self.inv_ammo_bullets = self.inv_ammo_bullets - 1;
	}

	trailparticles(self, particleeffectnum("TR_KNIGHTSPIKE"), start, aimdir);
	trailparticles(self, particleeffectnum("TR_AFRITSPIKE_RED"), start, aimdir);
	
	if (trace_ent.takedamage)
	{
		T_Damage (trace_ent, self, self, damage);
	}
	else
	{	// hit wall
		Q3Surface_Impact(org);
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

	if (self.flags & FL_DUCKED)
	{
		source = self.origin;
	}
	else
	{
		source = self.origin + '0 0 24';
	}
	
 	nep_traceline (source, source + v_forward*4096, FALSE, self);
	if (trace_fraction == 1.0)
		return;
	
	org = trace_endpos - v_forward*4;
	
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
				damage = damage * 0.5;
			}
			else if (self.weapon == WEP_RAILGUN)
			{
				damage = damage * 2.0; //goes through armor like a hot knife through butter
				SpawnBlood (org, org*0.2, damage);
			}
			
			T_Damage (trace_ent, self, self, damage);
			Q3Surface_Impact(org);
		}
		else
		{
			T_Damage (trace_ent, self, self, damage);
			Q3Surface_Impact(org);
		}
	}
	else
	{	// hit wall
		Q3Surface_Impact(org);
	}
	
	if (self.weapon == WEP_RAILGUN)
	{
		fireRail(self.origin + (v_forward * 70) + (v_right * 20) + (v_up * 15), org, WEAPON_RAILGUN_DAMAGE);
		self.currentammo = self.inv_ammo_slugs = self.inv_ammo_slugs - 1;
	}
	
	/*
	if (self.weapon == WEP_CHAINGUN)
	{
	//	fireBulletSound();
	//	self.currentammo = self.inv_ammo_bullets = self.inv_ammo_bullets - 1;

	//	sound (self, CHAN_WEAPON2, "weapons/chngnl1a.wav", 0.5, ATTN_NORM); //spinning
	}
	*/
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
	
	vel = normalize(dir + v_up*crandom() + v_right*crandom());
	vel = vel + 2*trace_plane_normal;
	vel = vel * 200;
	
	org = trace_endpos - dir*4;
	
	if (trace_ent.takedamage /*&& trace_ent.flags & FL_MONSTER || trace_ent.classname == "player"*/)
	{
		if (trace_ent.flags & FL_MONSTER || trace_ent.flags & FL_CLIENT)//new
		{
			if (trace_ent.classname == "monster_tank" || trace_ent.classname == "monster_tank_commander")
			{
				damage = damage * 0.5;
				Q3Surface_Impact(org);
			}	
			else
			{
				SpawnBlood (org, vel*0.2, damage);
			}
		}
		AddMultiDamage (trace_ent, damage);
		//Q3Surface_Impact(org);//new
	}
	else
	{
//		AddMultiDamage (trace_ent, damage);
		Q3Surface_Impact(org);
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
			/*
			if (self.weapon == WEP_SHOTGUN)
			{
				Q3SurfaceTraceAttack(WEAPON_SHOTGUN_DAMAGE, direction);
			}
			else
			{
				Q3SurfaceTraceAttack(damage, direction);				
			}
			*/
			Q3SurfaceTraceAttack(damage, direction);
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
	setmodel (self, "progs/cgexplodex.spr32");
	self.solid = SOLID_NOT;
	self.think = SUB_Remove;
	self.nextthink = 0.6;
//	effect(self.origin, "progs/s_explod.spr", 0, 5, 10);
	effect(self.origin, "progs/cgexplodex.spr32", 0, 36, 30);	
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

	if (trace_dphitq3surfaceflags & Q3SURFACEFLAG_FORCEFIELD)
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

void() T_BFGTouch =
{
	local entity bfg_impact_effect;
	
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
	
	T_RadiusDamageRad (self, self.owner, self.dmg, self.owner, self.dmgradius);

//	sound (self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM);
	self.origin = self.origin - 8*normalize(self.velocity);
	stuffcmd (self.owner, "bf 0 1 0 0.7\n");
	pointparticles(particleeffectnum("cthon_fireball"), self.origin, '0 0 0', 1);
	remove(self);
};

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
				//	if (visible(BFGtarget) ){
						fireBFGtrail(self.origin, BFGtarget.origin, 20);
						BFGFireCount++;
						bprint("BFG Fire count: ");
						bprint (ftos(BFGFireCount));
						bprint("\n");
					//}					
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

	local vector rotation_offset;
	local float rotation;

	dir = normalize(self.origin - BFGtarget.origin);

	self.frame++;

	rotation = (self.frame - 10) * 2*PI/6;
		
	rotation_offset_x = -20 * sin(rotation);
	rotation_offset_y = -12 * cos(rotation);					
	rotation_offset_z = -6 * cos(rotation);
	
	pointparticles(particleeffectnum("slimesplash_small"), self.origin + rotation_offset, '0 0 0', 1);
	
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
				//	if (visible(BFGtarget) ){
						fireBFGtrail(self.origin, BFGtarget.origin, 20);
						BFGFireCount++;
						bprint("BFG Fire count: ");
						bprint (ftos(BFGFireCount));
						bprint("\n");
				//	}
				
				}
				
			}
			
		}
	BFGtarget = BFGtarget.chain;
	}
	
	self.nextthink = time + 0.1;
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

//	source = G_ProjectSource (self.origin, '20 8 17', v_forward, v_right, '0 0 0');

	setmodel (newmis, "progs/grenade.mdl");
	setsize (newmis, '0 0 0', '0 0 0');		
	setorigin (newmis, self.origin);
//	setorigin (newmis, source);
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


