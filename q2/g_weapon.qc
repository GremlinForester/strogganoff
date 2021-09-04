/*
	Straight port of Q2's g_weapons file.
		adapted to QuakeC.
*/

/*
	handle the simple direction and sending of shot tracelines,
	sfx, punchangle, etc are left up to the calling func.
	
	slight optimization:
		combined elements of Firebullets because not every Firebullets needs a for-loop.
		and we'd like to reduce func call jump counts.
*/


void(vector entOrg, vector aimAngle, float speed, float damage, float clr, float glowSize, float lightLev) fire_blaster_base={
	local vector source;
	local vector rotation_offset;
	local float rotation;
		
	newmis = spawn ();
	newmis.owner = self;
	newmis.dmg = damage;
	newmis.movetype = MOVETYPE_FLYMISSILE;
	newmis.solid = SOLID_BBOX;
	newmis.classname = "blasterbolt";
	newmis.glow_color = clr;	//'200 0 0'
	newmis.glow_size = glowSize;	//100
	newmis.light_lev = lightLev;	//200
    newmis.modelflags = MF_TRACER2;
	newmis.color = '1 0 0'; // color (does not affect radius), typical value '1 1 1' (bright white), can be up to '255 255 255' (nuclear blast)
	newmis.style = 6; // light style (like normal light entities, flickering torches or switchable, etc)
	newmis.pflags = PFLAGS_FULLDYNAMIC; // flags (see PFLAGS_ constants)

// set missile speed

//	makevectors (self.v_angle);
	newmis.velocity = aim(self, speed);
	newmis.velocity = newmis.velocity * speed;
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
		sound (self, CHAN_WEAPON2, "weapons/hyprbl1a.wav", 0.7, ATTN_NORM);
		sound (self, CHAN_WEAPON, "weapons/Hyprbf1a.wav", 1, ATTN_NORM);
		
		rotation = (self.weaponframe - 5) * 2*PI/3; //2*PI/6
		
		rotation_offset_x = -6 * sin(rotation); //-4
		rotation_offset_y = 6;					// 0
		rotation_offset_z = 6 * cos(rotation); //4
		
		source = G_ProjectSource (self.origin, '20 6 10' + rotation_offset, v_forward, v_right, '0 0 0'); //24 -18 22
		source = G_ProjectSource (self.origin, '20 6 10' + rotation_offset, v_forward, v_right, '0 0 0'); //24 -18 22
		setorigin (newmis, source);
	}
};

void(vector entOrg, vector aimAngle, vector spread, float damage) fire_bullet_base={
	local vector org;
	local vector dir;
	
	makevectors(aimAngle);
	
	org = entOrg + v_forward * 10;
	org_z = self.absmin_z + self.size_z * 0.7;

	dir = aim(self, 100000);
	dir = dir + crandom()*spread_x*v_right + crandom()*spread_y*v_up;
		
	traceline (org, org + dir*2048, FALSE, self);
	
	if (trace_fraction != 1.0)
	{
		Q3SurfaceTraceAttack(damage, dir);
	}
};


void(vector entOrg, vector aimAngle, float pellets, vector spread, float damage) fire_shotgun_base={

	local vector org;
	local vector dir;
	
	makevectors(aimAngle);
	
	org = entOrg + v_forward * 6;
	org_z = self.absmin_z + self.size_z * 0.7;

	dir = aim(self, 100000);
	
	ClearMultiDamage();
	while (pellets > 0)
	{
		dir = dir + crandom()*spread_x*v_right + crandom()*spread_y*v_up;
		
		traceline (org, org + dir*2048, FALSE, self);
		
		if (trace_fraction != 1.0)
		{
			Q3SurfaceTraceAttack(damage, dir);
		}
		pellets = pellets - 1;
	}
	ApplyMultiDamage ();
};


void(vector start, vector aimdir, float damage, vector speed, float timer, float damage_radius) fire_grenade_base=
{
	
	local vector source;
	
	makevectors(aimdir);
	
	newmis = spawn ();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_BOUNCE;
	newmis.solid = SOLID_BBOX;
	newmis.classname = "grenade";
	
	if (self.v_angle_x)
		newmis.velocity = v_forward*speed_x + v_up * speed_y + crandom()*v_right*10 + crandom()*v_up*10;
	else
	{
		newmis.velocity = aim(self, 10000);
		newmis.velocity = newmis.velocity * speed_x;
		newmis.velocity_z = speed_y;
	}

	newmis.dmg = damage;
	newmis.avelocity = '300 300 300';

	newmis.angles = vectoangles(newmis.velocity);
	
	newmis.touch = GrenadeTouch;

// set missile duration
	newmis.nextthink = time + timer;
	newmis.think = GrenadeExplode;

	source = G_ProjectSource (start, '20 8 17', v_forward, v_right, '0 0 0');

	setmodel (newmis, "models/objects/grenade/tris.md2");
	setsize (newmis, '0 0 0', '0 0 0');
	setorigin (newmis, source);
};


void(vector start, vector aimdir, float damage, vector speed, float timer, float damage_radius, float radius_damage) fire_rocket_base={
	
	local vector source;
	
	newmis = spawn ();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLYMISSILE;
	newmis.solid = SOLID_BBOX;
	newmis.dmg = damage;
	newmis.modelflags = MF_ROCKET;
	
	newmis.classname = "missile";
	
	makevectors (aimdir);
	newmis.velocity = aim(self, 1000);
	newmis.velocity = newmis.velocity * speed_x;
	newmis.angles = vectoangles(newmis.velocity);
	
	newmis.touch = T_MissileTouch;
	
// set missile duration
	newmis.nextthink = time + timer;
	newmis.think = SUB_Remove;
	
	source = G_ProjectSource (start, '20 8 17', v_forward, v_right, '0 0 0');
	
	setmodel (newmis, "models/objects/rocket/tris.md2");
	setsize (newmis, '0 0 0', '0 0 0');
	setorigin (newmis, source);	
};

void(vector start, vector end, float damage) fire_railgun_base={
	local	vector	org;
	local	entity	impact_point;

 	traceline (start, end, FALSE, self);
//	if (trace_fraction == 1.0)
//		return;

	org = trace_endpos - end*4;

	trailparticles(self, particleeffectnum("TR_KNIGHTSPIKE"), start, end);
	trailparticles(self, particleeffectnum("TR_AFRITSPIKE_RED"), start, end);

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

void(vector start, vector aimdir, float speed, float damage, float damage_radius) fire_bfg_base={
	

	

};