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

void() blaster_base_touch={
	
	self.solid = SOLID_NOT;
	self.velocity = '0 0 0';
	self.avelocity = '0 0 0';

	self.think = SUB_Remove;
	self.nextthink = time + 0.01;
	
	if(!other.takedamage){
		pointparticles(particleeffectnum("TE_BLASTERIMPACT"), self.origin, '0 0 0', 1);
		return;
	}
	
	if(other == self.owner){
		return;
	}
	
	makevectors(self.angles);
	traceline(self.origin, self.origin + (v_forward * self.maxs_x), FALSE, self);
	
	T_Damage (other, self, self.owner, self.dmg);
};

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
    newmis.modelflags = MF_TRACER2;
	
	if (self.weapon == WEP_HYPERBLASTER)
	{
//		if (self.shotcount >= 2)
		if (self.weaponframe == 6 || self.weaponframe == 9)
		{
			newmis.color = '1 0 0'; // color (does not affect radius), typical value '1 1 1' (bright white), can be up to '255 255 255' (nuclear blast)
			newmis.style = 6; // light style (like normal light entities, flickering torches or switchable, etc)
			newmis.pflags = PFLAGS_NOSHADOW | PFLAGS_FULLDYNAMIC;
			newmis.glow_color = clr;
			newmis.glow_size = glowSize;	//100
			newmis.light_lev = lightLev;	//200
//			self.shotcount = 0;	
		}
	}
	
	if (self.weapon == WEP_BLASTER)
	{
			newmis.color = '1 0 0'; // color (does not affect radius), typical value '1 1 1' (bright white), can be up to '255 255 255' (nuclear blast)
			newmis.style = 6; // light style (like normal light entities, flickering torches or switchable, etc)
			newmis.pflags = PFLAGS_NOSHADOW | PFLAGS_FULLDYNAMIC; // flags (see PFLAGS_ constants)
			newmis.glow_color = clr;
			newmis.glow_size = glowSize;	//100
			newmis.light_lev = lightLev;	//200
	}

// set missile speed

	newmis.velocity = aim(self, speed);
	newmis.velocity = newmis.velocity * speed;
	newmis.angles = vectoangles(newmis.velocity);

	newmis.touch = blaster_base_touch;

// set missile duration
	newmis.nextthink = time + 5;
	newmis.think = SUB_Remove;
	
	newmis.scale = 0.5;	

	if (self.flags & FL_DUCKED){
	source = G_ProjectSource (self.origin, '10 8 -4', v_forward, v_right, '0 0 0'); //20 8 -4
	}
	else{
	source = G_ProjectSource (self.origin, '10 8 17', v_forward, v_right, '0 0 0'); //20 8 17
	}
	
	setmodel (newmis, "progs/laser.mdl");
	setsize (newmis, '0 0 0', '0 0 0');
	setorigin (newmis, source);
	
	if (self.weapon == WEP_HYPERBLASTER)
	{
		rotation = (self.weaponframe - 5) * 2*PI/6;
		
		rotation_offset_x = -6 * sin(rotation);
		rotation_offset_y = 6;					
		rotation_offset_z = -6 * cos(rotation);
	
		if (self.flags & FL_DUCKED){
			source = G_ProjectSource (self.origin, '20 8 -14' + rotation_offset, v_forward, v_right, '0 0 0'); //24 -18 22
		}
		else{
			source = G_ProjectSource (self.origin, '20 6 10' + rotation_offset, v_forward, v_right, '0 0 0'); //24 -18 22
		}	
		setorigin (newmis, source);
	}
};

void(vector entOrg, vector aimAngle, vector spread, float damage) fire_bullet_base={
	local vector org;
	local vector dir;
	
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

	//source = G_ProjectSource (start, '20 8 17', v_forward, v_right, '0 0 0');
	
	if (self.flags & FL_DUCKED){
	source = G_ProjectSource (self.origin, '20 8 -4', v_forward, v_right, '0 0 0'); //24 -18 22
	}
	else{
	source = G_ProjectSource (self.origin, '20 8 17', v_forward, v_right, '0 0 0'); //24 -18 22
	}
	
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
	
	//source = G_ProjectSource (start, '20 8 17', v_forward, v_right, '0 0 0');
	if (self.flags & FL_DUCKED){
	source = G_ProjectSource (self.origin, '20 8 -4', v_forward, v_right, '0 0 0'); //24 -18 22
	}
	else{
	source = G_ProjectSource (self.origin, '20 8 17', v_forward, v_right, '0 0 0'); //24 -18 22
	}	
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

	org = trace_endpos;

	trailparticles(self, particleeffectnum("TR_KNIGHTSPIKE"), start, end);
	trailparticles(self, particleeffectnum("TR_AFRITSPIKE_RED"), start, end);

	impact_point = spawn();
	impact_point.origin = org;
	impact_point.solid = SOLID_NOT;
	impact_point.movetype = MOVETYPE_NONE;
	impact_point.effects = self.effects | EF_LOWPRECISION;
	impact_point.nextthink = time + 0.01;
	setmodel (impact_point, "");
	impact_point.think = SUB_Remove;
	
	if (trace_ent.takedamage)
	{
		T_Damage (trace_ent, self, self, damage);
	}
	else
	{	// hit wall
		Q3Surface_Impact_Ent(impact_point);
	}
};

void(vector start, vector aimdir, float speed, float damage, float damage_radius) fire_bfg_base=
{
	local vector source;

	self.punchangle_x = -8;
	newmis = spawn ();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLYMISSILE;
	newmis.solid = SOLID_BBOX;
	newmis.dmg = damage;
	newmis.dmgradius = damage_radius;
	newmis.effects = EF_ADDITIVE;
	newmis.classname = "BFG Projectile";
	newmis.velocity = aim(self, speed);
	newmis.velocity = newmis.velocity * speed;
	newmis.avelocity_x = random()*900;
	newmis.avelocity_y = random()*800;
	newmis.avelocity_z = random()*700;
	newmis.angles = vectoangles(newmis.velocity);
	newmis.touch = T_BFGTouch;
	newmis.nextthink = time + 0.1;
	newmis.think = BFGthink;
	newmis.colormod = '0 0.5 0';
	newmis.scale = 1;
	newmis.alpha = .5;
	newmis.dphitcontentsmask = self.dphitcontentsmask | (DPCONTENTS_SOLID | DPCONTENTS_BODY | DPCONTENTS_OPAQUE | DPCONTENTS_SKY | DPCONTENTS_WATER);
	
	source = G_ProjectSource (self.origin, '20 8 17', v_forward, v_right, '0 0 0');

	setmodel (newmis, "sprites/s_bfg1.sp2");
	setsize (newmis, '0 0 0', '0 0 0');
	setorigin (newmis, source);
//	setorigin (newmis, self.origin + v_forward*8 + '0 0 16');	
};