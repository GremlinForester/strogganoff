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


#define GIB_VELOCITY_MUL 1.1
#define GIB_VELOCITY_FLAMING_MUL random() * 4

void(entity ent) setWounded =
{
	//Any weird pain skin workaround stuff can go here
	if (ent.bIsWounded){
		return;
	}
	else{
		self.bIsWounded = 1;
		self.bleedcount = 3;
		ent.skin++;
	}
}

void() initClassType =
{
	switch(self.classname)
	{
	case "monster_soldier_light":
		self.classtype = CLASS_STROGG;
		break;
	case "monster_soldier_ss":
		self.classtype = CLASS_STROGG;
		break;
	case "monster_soldier":
		self.classtype = CLASS_STROGG;
		break;
	case "monster_soldier_flak":
		self.classtype = CLASS_STROGG;
		break;
	case "monster_infantry":
		self.classtype = CLASS_STROGG;
		break;
	case "monster_infantry_nail":
		self.classtype = CLASS_STROGG;
		break;		
	case "monster_berserk":
		self.classtype = CLASS_STROGG;
		break;
	case "monster_brain":
		self.classtype = CLASS_STROGG;
		break;
	case "monster_chick":
		self.classtype = CLASS_STROGG;
		break;
	case "monster_flipper":
		self.classtype = CLASS_ANIMAL;
		break;
	case "monster_floater":
		self.classtype = CLASS_STROGG;
		break;
	case "monster_flyer":
		self.classtype = CLASS_STROGG;
		break;
	case "monster_gladiator":
		self.classtype = CLASS_STROGG;
		break;
	case "monster_gunner":
		self.classtype = CLASS_STROGG;
		break;
	case "monster_hover":
		self.classtype = CLASS_STROGG;
		break;
	case "monster_hover_teleporter":
		self.classtype = CLASS_STROGG;
		break;		
	case "monster_medic":
		self.classtype = CLASS_STROGG;
		break;
	case "monster_mutant":
		self.classtype = CLASS_ANIMAL;
		break;
	case "monster_parasite":
		self.classtype = CLASS_STROGG;
		break;	
	case "monster_tank":
		self.classtype = CLASS_STROGG;
		break;
	case "monster_tank_commander":
		self.classtype = CLASS_STROGG;
		break;
	case "monster_stroggzombie":
		self.classtype = CLASS_ANIMAL;
		break;		
	}
}

void() gibMonster =
{
	local float n;

	sound (self, CHAN_VOICE, "misc/udeath.wav", 1, ATTN_NORM);
	
	//everyone gets a little meat	
	for (n= 0; n < 2; n++)
		ThrowGib ("models/objects/gibs/bone/tris.md2", self.health * GIB_VELOCITY_MUL, GIB_FLESH, 1);
	for (n= 0; n < 4; n++)
		ThrowGib ("models/objects/gibs/sm_meat/tris.md2", self.health * GIB_VELOCITY_MUL, GIB_FLESH, 1);
	for (n= 0; n < 3; n++)
		ThrowGib ("models/objects/gibs/bone2/tris.md2", self.health * GIB_VELOCITY_MUL, GIB_FLESH, 1);	
	
	//Explosive Monsters
	if (self.classname == "monster_hover"
	|| self.classname == "monster_brain"
	|| self.classname == "monster_flyer"
	|| self.classname == "monster_supertank"
	|| self.classname == "monster_tank_commander"
	|| self.classname == "monster_stroggzombie"	
	|| self.classname == "monster_tank")
	{
		
		if (self.classname == "monster_stroggzombie"){
			T_RadiusDamage (self, self.owner, 85, other); //BOOM! Get out the way!
		}
		else{
			T_RadiusDamage (self, self.owner, 5, other);	
		}
		
		ThrowGib ("models/objects/debris1/tris.md2", self.health * GIB_VELOCITY_FLAMING_MUL, GIB_FLAMING, 1);
		ThrowGib ("models/objects/debris2/tris.md2", self.health * GIB_VELOCITY_FLAMING_MUL, GIB_FLAMING, 1);
		ThrowGib ("models/objects/debris3/tris.md2", self.health * GIB_VELOCITY_FLAMING_MUL, GIB_FLAMING, 1);
		ThrowGib ("models/objects/gibs/skull/tris.md2", self.health * GIB_VELOCITY_MUL, GIB_FLESH, 1);
		for (n= 0; n < 2; n++){
		ThrowGib ("models/objects/gibs/gear/tris.md2", self.health * GIB_VELOCITY_MUL, GIB_METAL, 0.75);
		}

		sound (self, CHAN_BODY, "weapons/r_exp3.wav", 1, ATTN_NORM);

		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_EXPLOSION);
		WriteCoord (MSG_BROADCAST, self.origin_x);
		WriteCoord (MSG_BROADCAST, self.origin_y);
		WriteCoord (MSG_BROADCAST, self.origin_z);
	}
	
	if (self.classname == "monster_floater")
	{
		ThrowGib ("models/objects/debris1/tris.md2", self.health * GIB_VELOCITY_FLAMING_MUL, GIB_FLAMING, 1);
		ThrowGib ("models/objects/debris2/tris.md2", self.health * GIB_VELOCITY_FLAMING_MUL, GIB_FLAMING, 1);
		ThrowGib ("models/objects/debris3/tris.md2", self.health * GIB_VELOCITY_FLAMING_MUL, GIB_FLAMING, 1);
		ThrowGib ("models/objects/gibs/skull/tris.md2", self.health * GIB_VELOCITY_MUL, GIB_FLESH, 1);
		for (n= 0; n < 2; n++){
		ThrowGib ("models/objects/gibs/gear/tris.md2", self.health * GIB_VELOCITY_MUL, GIB_METAL, 1);
		}
		
		T_RadiusDamage (self, self.owner, 10, other);
		sound (self, CHAN_BODY, "weapons/r_exp3.wav", 1, ATTN_NORM);

		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_EXPLOSION);
		WriteCoord (MSG_BROADCAST, self.origin_x);
		WriteCoord (MSG_BROADCAST, self.origin_y);
		WriteCoord (MSG_BROADCAST, self.origin_z);
	}
	
	//Non-explosive but with some Strogg pieces (chest, head)
	if (self.classname == "monster_soldier" 
	|| self.classname == "monster_soldier_light"
	|| self.classname == "monster_soldier_ss"
	|| self.classname == "monster_soldier_ss"
	|| self.classname == "monster_infantry"
	|| self.classname == "monster_gladiator"
	|| self.classname == "monster_gunner"
	|| self.classname == "monster_berserk"
	|| self.classname == "monster_chick"
	|| self.classname == "monster_parasite")
	{
		ThrowGib ("models/objects/gibs/chest/tris.md2", self.health * GIB_VELOCITY_MUL, GIB_FLESH, 0.75);
		ThrowGib ("models/objects/gibs/head2/tris.md2", self.health * GIB_VELOCITY_MUL, GIB_FLESH, 1);
	}	
	
/*
models/objects/gibs/gear/tris.md2

models/objects/gibs/bone/tris.md2
models/objects/gibs/bone2/tris.md2
models/objects/gibs/arm/tris.md2 //flesh arm
models/objects/gibs/head/tris.md2 //player head
models/objects/gibs/leg/tris.md2 //player leg

models/objects/gibs/skull/tris.md2 //bloody skull
models/objects/gibs/sm_meat/tris.md2 //round gib
models/objects/gibs/sm_metal/tris.md2 //bloody pyramid

models/objects/gibs/chest/tris.md2 //strogg chest
models/objects/gibs/head2/tris.md2 //strogg head
	
monster_flipper
monster_mutant
misc_insane
*/	
	
}

/*
monster_ projectile stuff, ala Quake 2. These essentially wrap as many shared general weapon projectile functions as possible, also used by the player.

For now they mostly just pass parameters but down the road can be used for more monster specific stuff. Quake 2 used this for muzzle flashes for example.
*/

//MrC: Unless there's a performance hit with ApplyMultiDamage, this should work fine. 
//This defaults FireBullets to 1 bullet of configurable damage and spread.

void (vector start, vector aimDir, vector spread, float dmg) monster_fire_bullet =
{
	removeBitsFromEntity(self,dphitcontentsmask,DPCONTENTS_MONSTERCLIP);	
	FireBullets(1, start, aimDir, spread, dmg);
	addBitsToEntity(self,dphitcontentsmask,DPCONTENTS_MONSTERCLIP);		
}

void (float shotcount, vector start, vector aimDir, vector spread, float dmg) monster_fire_shotgun =
{
	removeBitsFromEntity(self,dphitcontentsmask,DPCONTENTS_MONSTERCLIP);	
	FireBullets(shotcount, start, aimDir, spread, dmg);
	addBitsToEntity(self,dphitcontentsmask,DPCONTENTS_MONSTERCLIP);	
}

void (float shotcount, vector start, vector aimDir, vector spread, float setDamage) monster_fire_flechette =
{
	local entity mfletch;
  local vector dir;
	makevectors(aimDir);
  
	while (shotcount > 0)
	{
		mfletch = spawn();
		mfletch.owner = self;
		mfletch.dmg = setDamage;
		mfletch.movetype = MOVETYPE_FLY;
		mfletch.solid = SOLID_BBOX;
		//mfletch.modelflags = mflags; //MF_TRACER2;
		mfletch.effects = EF_FULLBRIGHT;
		mfletch.colormod = '1 1 1';
		mfletch.glow_size = 50;
		mfletch.light_lev = 50;
		mfletch.color = '0.5 0.25 0.1'; // color (does not affect radius), typical value '1 1 1' (bright white), can be up to '255 255 255' (nuclear blast)
		mfletch.style = 6; // light style (like normal light entities, flickering torches or switchable, etc)
		mfletch.pflags = PFLAGS_NOSHADOW | PFLAGS_FULLDYNAMIC; // flags (see PFLAGS_ constants)
		
		mfletch.angles = '0 0 0'; // orientation of the light
		
		setmodel (mfletch, "models/objects/flash/tris.md2");
		setsize (mfletch, '0 0 0', '0 0 0');
		setorigin (mfletch, start);
		
    dir = normalize(aimDir) + ((crandom()*spread_x)*v_right) + ((crandom()*spread_y)*v_up);
		mfletch.velocity =  dir * (500 + (random() * 200));
		
		mfletch.angles = vectoangles(mfletch.velocity);
		
		mfletch.nextthink = time + 5;
		mfletch.think = SUB_Remove;
		mfletch.touch = blasterTouch; 
		shotcount = shotcount - 1;
	}
}

// Blaster and rocket spawns a new entity for monsters for now, can expose more parms if needed, like speed etc...
void(vector org, vector vec, float damage, vector colortint, float mflags) monster_fire_blaster =
{
	local entity mlaser;
	
	mlaser = spawn();
	mlaser.owner = self;
	mlaser.dmg = damage;
	mlaser.movetype = MOVETYPE_FLY;
	mlaser.solid = SOLID_BBOX;
	mlaser.modelflags = mflags; //MF_TRACER2;
	mlaser.effects = EF_FULLBRIGHT;
	mlaser.colormod = colortint;
	mlaser.glow_size = 100;
	mlaser.light_lev = 200;
	mlaser.color = colortint; // color (does not affect radius), typical value '1 1 1' (bright white), can be up to '255 255 255' (nuclear blast)
	mlaser.style = 6; // light style (like normal light entities, flickering torches or switchable, etc)
	mlaser.pflags = PFLAGS_NOSHADOW | PFLAGS_FULLDYNAMIC; // flags (see PFLAGS_ constants)
	
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

void(vector org, vector vec, float damage) monster_fire_rocket =
{
	local entity mrocket;
	
	mrocket = spawn();
	mrocket.owner = self;
	mrocket.dmg = damage;
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

void(vector org, vector vec, float damage) monster_fire_bfg =
{
	newmis = spawn();
	newmis.owner = self;
	newmis.dmg = damage;
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
	initClassType();
	
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
#endif	
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
#endif
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
#endif

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
	self.dphitcontentsmask = self.dphitcontentsmask | (DPCONTENTS_SOLID | DPCONTENTS_BODY | DPCONTENTS_MONSTERCLIP | DPCONTENTS_DONOTENTER| DPCONTENTS_BOTCLIP | DPCONTENTS_WATER);

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
