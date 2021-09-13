/* ALL MONSTERS SHOULD BE 1 0 0 IN COLOR */

// name =[framenum,	nexttime, nextthink] {code}
// expands to:
// name ()
// {
//		self.frame=framenum;
//		self.nextthink = time + nexttime;
//		self.think = nextthink;
//		<code>
// };


/*
monster_ projectile stuff, ala Quake 2. These essentially wrap as many shared general weapon projectile functions as possible, also used by the player.

For now they mostly just pass parameters but down the road can be used for more monster specific stuff. Quake 2 used this for muzzle flashes for example.
*/

//MrC: Unless there's a performance hit with ApplyMultiDamage, this should work fine. 
//This defaults FireBullets to 1 bullet of configurable damage and spread.

void (vector start, vector aim, vector spread, float dmg) monster_fire_bullet =
{
	FireBullets(1, start, aim, spread, dmg);
}

void (float shotcount, vector start, vector aim, vector spread, float dmg) monster_fire_shotgun =
{
	FireBullets(shotcount, start, aim, spread, dmg);

/* Quake 2 uses a for loop and a single shot fire_lead function to simulate shotguns. Leaving this here to experiment with later. 
	local float i;
	
	for (i = 0; i < shotcount; i++)
		fire_lead(start, aim, spread, dmg);
*/
}

// Blaster and rocket spawns a new entity for monsters for now, can expose more parms if needed, like speed etc...
void(vector org, vector vec, float dmg, vector colortint, float mflags) monster_fire_blaster =
{
	local entity mlaser;
	
	mlaser = spawn();
	mlaser.owner = self;
	mlaser.damage = dmg;
	mlaser.movetype = MOVETYPE_FLY;
	mlaser.solid = SOLID_BBOX;
	mlaser.modelflags = mflags; //MF_TRACER2;
	mlaser.effects = EF_FULLBRIGHT;
	mlaser.colormod = colortint;
	mlaser.glow_color = colortint;
	mlaser.glow_size = 100;
	mlaser.light_lev = 200;
	mlaser.color = colortint; // color (does not affect radius), typical value '1 1 1' (bright white), can be up to '255 255 255' (nuclear blast)
	mlaser.style = 6; // light style (like normal light entities, flickering torches or switchable, etc)
	mlaser.pflags = PFLAGS_FULLDYNAMIC; // flags (see PFLAGS_ constants)
	
	mlaser.angles = '0 0 0'; // orientation of the light

	setmodel (mlaser, "models/objects/flash/tris.md2");
//	setmodel (mlaser, "models/objects/laser/tris.md2");
	setsize (mlaser, '0 0 0', '0 0 0');

	setorigin (mlaser, org);

	mlaser.velocity = vec * 600;
	mlaser.angles = vectoangles(mlaser.velocity);

	mlaser.nextthink = time + 5;
	mlaser.think = SUB_Remove;
	mlaser.touch = blasterTouch;
};

void(vector org, vector vec, float dmg) monster_fire_rocket =
{
	local entity mrocket;
	
	mrocket = spawn();
	mrocket.owner = self;
	mrocket.damage = dmg;
	mrocket.movetype = MOVETYPE_FLY;
	mrocket.solid = SOLID_BBOX;
	mrocket.modelflags = MF_ROCKET;

	setmodel (mrocket, "models/objects/rocket/tris.md2");
	setsize (mrocket, '0 0 0', '0 0 0');

	setorigin (mrocket, org);

	mrocket.velocity = vec * 600;
	mrocket.angles = vectoangles(mrocket.velocity);

	mrocket.nextthink = time + 5;
	mrocket.think = SUB_Remove;
	mrocket.touch = T_MissileTouch;
};

void monster_fire_grenade (vector start, vector rotation, float damage, float speed)
{
	local vector source;
	local entity grenade;
	
	sound (self, CHAN_AUTO, "weapons/GRENLF1A.WAV", 1, ATTN_NORM);	

	grenade = spawn ();
	grenade.owner = self;
	grenade.movetype = MOVETYPE_BOUNCE;
	grenade.solid = SOLID_BBOX;
	grenade.classname = "grenade";

	makevectors (self.angles);

	grenade.velocity = normalize(self.enemy.origin - self.origin);
	grenade.velocity = grenade.velocity * speed;
	grenade.velocity_z = speed / 3;

	grenade.dmg = damage;

	grenade.avelocity = rotation;
	grenade.angles = vectoangles(grenade.velocity);
	grenade.touch = GrenadeTouch;

	grenade.nextthink = time + 2.5;
	grenade.think = GrenadeExplode;

	setmodel (grenade, "progs/grenade.mdl");
	setsize (grenade, '0 0 0', '0 0 0');		
	setorigin (grenade, start);
}

void monster_fire_railgun (vector start, vector aimdir, float damage) =
{
	fireRail(start, aimdir, damage);
}

void(vector org, vector vec, float dmg) monster_fire_bfg =
{
	newmis = spawn();
	newmis.owner = self;
	newmis.damage = dmg;
	newmis.movetype = MOVETYPE_FLY;
	newmis.solid = SOLID_BBOX;

	setmodel (newmis, "sprites/s_bfg1.sp2");
	setsize (newmis, '0 0 0', '0 0 0');

	setorigin (newmis, org);

	newmis.velocity = vec * 600;
	newmis.angles = vectoangles(newmis.velocity);

	newmis.nextthink = time + 0.1;
	newmis.think = m_BFGthink;
	newmis.touch = T_BFGTouch;
};

/*
================
monster_use

Using a monster makes it angry at the current activator
================
*/
void() monster_use =
{
	if (self.enemy)
		return;
	if (self.health <= 0)
		return;
	if (activator.items & IT_INVISIBILITY)
		return;
	if (activator.flags & FL_NOTARGET)
		return;
	if (activator.classname != "player")
		return;
	
// delay reaction so if the monster is teleported, its sound is still
// heard
	self.enemy = activator;
	self.nextthink = time + 0.1;
	self.think = FoundTarget;
};

/*
================
monster_death_use

When a mosnter dies, it fires all of its targets with the current
enemy as activator.
================
*/
void() monster_death_use =
{
//	local entity 	ent, otemp, stemp;	// fx_warning

// fall to ground
	if (self.flags & FL_FLY)
		self.flags = self.flags - FL_FLY;
	if (self.flags & FL_SWIM)
		self.flags = self.flags - FL_SWIM;

	if (!self.target)
		return;

	activator = self.enemy;
	SUB_UseTargets ();
};


//============================================================================

/*

qc++ monster_start

	unified start routine - 1 call does it all

	sub replace the old calls like this
*/

#define walkmonster_start 		monster_start(0)
#define flymonster_start 			monster_start(FL_FLY)
#define swimmonster_start 		monster_start(FL_SWIM)

void() monster_go =
{
	self.takedamage = DAMAGE_AIM;

	self.ideal_yaw = self.angles * '0 1 0';
	self.view_ofs = '0 0 25';

#ifndef nodprint
	if (self.flags & FL_FLY)
	{
		if (!walkmove(0,0))
		{
			dprint ("flymonster in wall at: ");
			dprint (vtos(self.origin));
			dprint ("\n");
		}
	}
	else
#endifdef	
	if (self.flags & FL_SWIM)
	{
		self.view_ofs = '0 0 10';
	}
	else // walkers
	{
		self.origin_z = self.origin_z + 1;	// raise off floor a bit
		droptofloor();

		if (!self.yaw_speed)
			self.yaw_speed = 20;

#ifndef nodprint
		if (!walkmove(0,0))
		{
			dprint ("walkmonster in wall at: ");
			dprint (vtos(self.origin));
			dprint ("\n");
		}
#endifdef
	}

	if (!self.yaw_speed)
		self.yaw_speed = 10;

	self.use = monster_use;
	self.flags = self.flags | FL_MONSTER;

	self.pausetime = 99999999;
	self.th_stand();

	if (self.target)
	{
		self.goalentity = self.movetarget = find(world, targetname, self.target);
		if (!(self.flags & FL_FLY))
			self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
#ifndef nodprint
		if (!self.movetarget)
		{
			dprint ("Monster can't find target at ");
			dprint (vtos(self.origin));
			dprint ("\n");
		}
#endifdef

		if ((self.flags & FL_SWIM) ||
// this used to be an objerror
			self.movetarget.classname == "path_corner")
		{
			self.pausetime = 0;
			self.th_walk();
		}
	}

// spread think times so they don't all happen at same time
	self.nextthink = self.nextthink + random()*0.5;
};


// a think() to this will default to walkmonster - self.flags will have to be set as specced below for fly or swim
// flg - FL_SWIM or FL_FLY


void(float flg) monster_start =
{

// this fires specific code in monster_go
	self.flags = self.flags | flg;

// delay drop to floor to make sure all doors have been spawned
// spread think times so they don't all happen at same time
	self.nextthink = self.nextthink + random()*0.5;
	self.think = monster_go;
	total_monsters = total_monsters + 1;
};

//============================================================================

/*

qc++	Monster_JumpTouch

Jump handle for demon and dog is same codes

vars:

self.jump_vel - do damage when vlen(velocity) > this value
self.dmg - damage to do when touching a thing that takes damage
					- default 10 health pts
'
also uses:

self.dmg_take			"ldmg_"
self.jump_flag			"jump_vel"

Multi here with:

*/

void() dog_leap1;
void() dog_run1;
void() demon1_jump1;
void() demon1_jump11;

#define jumptouch_rep(jumpclass,jumpthinkone,jumpthinktwo) if (self.classname == #jumpclass) { if (!checkbottom(self)) { if (self.flags & FL_ONGROUND) self.think = jumpthinkone; return; } self.think = jumpthinktwo; }

void()	Monster_JumpTouch =
{
//	local	float	ldmg;

	if (self.health <= 0)
		return;

	if (!self.dmg) self.dmg = 10;

	if (other.takedamage)
	{
		if ( vlen(self.velocity) > self.jump_vel)
		{
			self.ldmg_ = self.dmg + 10*random();
			T_Damage (other, self, self, self.ldmg_);	
		}
	}

	self.touch = SUB_Null;
	self.nextthink = time + 0.1;

	jumptouch_rep(monster_demon1, demon1_jump1, demon1_jump11);
	jumptouch_rep(monster_dog, dog_leap1, dog_run1);

/*
	if (!checkbottom(self))
	{
		if (self.flags & FL_ONGROUND)
		{	// jump randomly to not get hung up
//dprint ("popjump\n");
	self.think = demon1_jump1;

//			self.velocity_x = (random() - 0.5) * 600;
//			self.velocity_y = (random() - 0.5) * 600;
//			self.velocity_z = 200;
//			self.flags = self.flags - FL_ONGROUND;
		}
		return;	// not on ground yet
	}

	self.think = demon1_jump11;
*/

};

//============================================================================

/*

qc++ fr_stand9

a few monsters have $stand1 - $stand9 as the first nine frames - this does that

*/

$frame	stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8 stand9

framerloop($stand1, $stand9, fr_stand9, 0.1,

	ai_stand();
	if (self.classname == "monster_ogre") frame_arb($stand5,if (random() < 0.2) sound(self, CHAN_VOICE, "ogre/ogidle.wav", 1, ATTN_IDLE));
);
