void() W_ChangeWeapon;
float() W_CheckNoAmmo;

//for Q2 weapon tossing (and maybe other things)
void() weapon_shotgun;
void() weapon_supershotgun;
void() weapon_machinegun;
void() weapon_chaingun;
void() weapon_grenadelauncher;
void() weapon_rocketlauncher;
void() weapon_hyperblaster;
void() weapon_railgun;
void() weapon_bfg;

//MrC: this might be moved somewhere else eventually
void(entity ent) W_updateCurrentAmmo =
{
	if (ent.weapon == WEP_SHOTGUN || ent.weapon == WEP_SUPERSHOTGUN){
		ent.currentammo = ent.inv_ammo_shells;
		return;
	}
	
	if (ent.weapon == WEP_MACHINEGUN || ent.weapon == WEP_CHAINGUN){
		ent.currentammo = ent.inv_ammo_bullets;
		return;
	}	

	if (ent.weapon == WEP_GRENADE_LAUNCHER || ent.weapon == WEP_ROCKET_LAUNCHER){
		ent.currentammo = ent.inv_ammo_rockets;
		return;
	}

	if (ent.weapon == WEP_HYPERBLASTER || ent.weapon == WEP_BFG){
		ent.currentammo = ent.inv_ammo_cells;
		return;
	}

	if (ent.weapon == WEP_RAILGUN){
		ent.currentammo = ent.inv_ammo_slugs;
		return;
	}
};

/* ALL LIGHTS SHOULD BE 0 1 0 IN COLOR ALL OTHER ITEMS SHOULD
BE .8 .3 .4 IN COLOR */

void() SUB_regen =
{
	self.model = self.mdl;		// restore original model
	self.solid = SOLID_TRIGGER;	// allow it to be touched again
	sound (self, CHAN_VOICE, "items/itembk2.wav", 1, ATTN_NORM);	// play respawn sound
	setorigin (self, self.origin);
};

void() SUB_triggerRegen =
{
	self.nextthink = self.oldthinktime;
	self.think = self.oldthink;
	self.solid = SOLID_TRIGGER;	// allow it to be touched again
};

void(float tim) triggerTouched =
{
	self.oldthinktime = self.nextthink;
	self.oldthink = self.think;
	
	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets	
	self.solid = SOLID_NOT;
	self.nextthink = time + tim;
	self.think = SUB_triggerRegen;
};

// stand in for much repetitve touch code - all touch do this
// in mark 3 all touch fn will route through a master fn that will do this

// self - touched item
// other - touching ent
// tim - respawn time for dm

void(float tim) touched =
{
// tim code <= -1 is for not a player touching - note: no respawn on this
// -1 = use targets but no bf\n
// expand - future code for mark 3 if monsters can pick up items - uncomment next code to // }
//	if (tim > -2)
//	{
//		if (tim > -1) 
		stuffcmd(other, "bf\n");
		activator = other;
		SUB_UseTargets();				// fire all targets / killtargets	
//	}

	self.solid = SOLID_NOT;
	self.model = string_null;

// note: dm > 2 rule upgrade implement later
//	if (deathmatch && deathmatch != 2 && tim > 0)
	if (deathmatch == 1 && tim > 0)
	{
		self.nextthink = time + tim;
		self.think = SUB_regen;
	}
};


/*QUAKED noclass (0 0 0) (-8 -8 -8) (8 8 8)
prints a warning message when spawned
*/
#ifdef debug
void() noclass =
{
#ifndef nodprint
// this does not seem to work - even with dprint on
	dprint("noclass spawned at");
	dprint(vtos(self.origin));
	dprint("\n");
#endif
	remove (self);
};
#endif



/*
============
PlaceItem

plants the object on the floor
============
*/
void() PlaceItem =
{
#ifndef opgrade
	local float	oldz;
#endif

	self.mdl = self.model;		// so it can be restored on respawn
	self.flags = FL_ITEM;		// make extra wide
	self.solid = SOLID_TRIGGER;

	self.movetype = MOVETYPE_TOSS;
	self.velocity = '0 0 0';
	self.origin_z = self.origin_z + 6;
	/*
	if (!self.cnt)
		self.cnt = self.aflag;
	else
		self.aflag = self.cnt;
	*/
	//Take THAT Bembridge Scholars!
	
#ifndef opgrade
// stats - cost of this one line of code: strofs = 4, numstatements = 1, numfunc = 0, numglobaldef = 1, numpr_global = 1, total size+ = 24
	oldz = self.origin_z;
#endif
	if (!droptofloor())
	{
#ifndef nodprint
		dprint ("Bonus item fell out of level at ");
		dprint (vtos(self.origin));
		dprint ("\n");
#endif
		remove(self);
//		return;
	}
};

/*
============
StartItem

Sets the clipping size and plants the object on the floor
============
*/
void() StartItem =
{
	self.nextthink = time + 0.2;	// items start after other solids
	self.think = PlaceItem;
};

void() item_megahealth_rot;
.float	healamount, healtype;

/*
=========================================================================

HEALTH BOX

=========================================================================
*/
//
// T_Heal: add health to an entity, limiting health to max_health
// "ignore" will ignore max_health limit
//
float (entity e, float healamount, float ignore) T_Heal =
{
	if (e.health <= 0)
		return 0;
	if ((!ignore) && (e.health >= other.max_health))
		return 0;
	healamount = ceil(healamount);

	e.health = e.health + healamount;
	if ((!ignore) && (e.health >= other.max_health))
		e.health = other.max_health;
		
	if (e.health > 250)
		e.health = 250;
	return 1;
};

void() health_touch =
{
	if (other.classname != "player")
		return;
	
	if (self.healtype == 2) // Megahealth?  Ignore max_health...
	{
		if (other.health >= 250)
			return;
		if (!T_Heal(other, self.healamount, 1))
			return;
	}
	else
	{
		if (!T_Heal(other, self.healamount, 0))
			return;
	}
	
	sprint(other, "You receive ");
	sprint(other, ftos(self.healamount));
	sprint(other, " health\n");
	
	// health touch sound
	sound(other, CHAN_ITEM, self.noise, 1, ATTN_NORM);

	// note: respawn special on health
	touched(0);

	// Megahealth = rot down the player's super health
	if (self.healtype == 2)
	{
		other.items = other.items | IT_SUPERHEALTH;
		self.nextthink = time + 5;
		self.think = item_megahealth_rot;
		self.owner = other;
	}
	else
	{
		if (deathmatch != 2)		// deathmatch 2 is the silly old rules
		{
			if (deathmatch)
				self.nextthink = time + 20;
			self.think = SUB_regen;
		}
	}
};	

void() item_megahealth_rot =
{
	other = self.owner;
	
	if (other.health > other.max_health)
	{
		other.health = other.health - 1;
		self.nextthink = time + 1;
		return;
	}

// it is possible for a player to die and respawn between rots, so don't
// just blindly subtract the flag off
	other.items = other.items - (other.items & IT_SUPERHEALTH);
	
	if (deathmatch == 1)	// deathmatch 2 is silly old rules
	{
		self.nextthink = time + 20;
		self.think = SUB_regen;
	}
};

/*
===============================================================================

ARMOR

===============================================================================
*/

void() armor_touch =
{
	local	float	type, value, bit;
	
	if (other.health <= 0)
		return;
	if (other.classname != "player")
		return;

	if (self.classname == "item_armor1" || self.classname == "item_armor_jacket")
	{
		if (other.items & IT_ARMOR_COMBAT) 
		{
			bit = IT_ARMOR_COMBAT;
			type = 0.6;
			value = 50;
		}
		else if (other.items & IT_ARMOR_BODY)
		{
			bit = IT_ARMOR_BODY;
			type = 0.8;	
			value = 50;			
		}
		else{
			type = 0.3;
			value = 100;	
			bit = IT_ARMOR_JACKET;
		}
	}
	
	if (self.classname == "item_armor2" || self.classname == "item_armor_combat")
	{
		if (other.items & IT_ARMOR_BODY)
		{
			bit = IT_ARMOR_BODY;
			type = 0.8;			
			value = 75;
		}
		else{
			type = 0.6;
			value = 150;
			bit = IT_ARMOR_COMBAT;
		}
	}
	
	if (self.classname == "item_armor_body")
	{
		type = 0.8;
		value = 200;
		bit = IT_ARMOR_BODY;
	}	
	
	if (self.classname == "item_armor_shard")
	{
		if (other.items & IT_ARMOR_JACKET){
			bit = IT_ARMOR_JACKET;
			type = 0.3;
		}
		else if (other.items & IT_ARMOR_COMBAT){
			bit = IT_ARMOR_COMBAT;
			type = 0.6;
		}
		else if (other.items & IT_ARMOR_BODY){
			bit = IT_ARMOR_BODY;
			type = 0.8;
		}
		else{
			bit = IT_ARMOR_JACKET;
			type = 0.3;
		} 
		value = 2;
	}

	other.armorvalue = other.armorvalue += value;
	other.armortype = type;
	
	if (other.armorvalue >= 200)
		other.armorvalue = 200;

	other.items = other.items - (other.items & (IT_ARMOR_JACKET | IT_ARMOR_COMBAT | IT_ARMOR_BODY)) + bit;
	
	touched(20);

	sprint(other, "You got ");
	if (!self.netname){
	sprint(other, self.classname);
	}
	else{
	sprint(other, self.netname);
	}
	sprint(other, "\n");

	if (!self.noise){
	sound(other, CHAN_ITEM, "items/armor1.wav", 1, ATTN_NORM);
	}
	else{
	sound(other, CHAN_ITEM, self.noise, 1, ATTN_NORM);
	}
};

/*
===============================================================================

WEAPONS

===============================================================================
*/

/// NOTE: logic change in touch code has changed other to self in this call - *** any mod code that calls this must take into account

void(entity ent) bound_other_ammo =
{
	if (ent.inv_ammo_shells > 100)
		ent.inv_ammo_shells = 100;
	if (ent.inv_ammo_bullets > 200)
		ent.inv_ammo_bullets = 200;
	if (ent.inv_ammo_rockets > 100)
		ent.inv_ammo_rockets = 100;
	if (ent.inv_ammo_cells > 100)
		ent.inv_ammo_cells = 100;
	if (ent.inv_ammo_slugs > 100)
		ent.inv_ammo_slugs = 100;	
};

//MrC: TODO, compare these to Q2 or give this a going over.
//good, just needs a slight go-over. - Subject9x
float(float w) RankForWeapon =
{
	switch(w){
		case WEP_BLASTER:
			return 1;
		
		case WEP_SHOTGUN:
			return 2;
		
		case WEP_SUPERSHOTGUN:
			return 3;
		
		case WEP_MACHINEGUN:
			return 4;
		
		case WEP_CHAINGUN:
			return 5;
		
		case WEP_GRENADE_LAUNCHER:
			return 6;
		
		case WEP_ROCKET_LAUNCHER:
			return 7;
		
		case WEP_HYPERBLASTER:
			return 8;
		
		case WEP_RAILGUN:
			return 9;
		
		case WEP_BFG:
			return 10;
	}
	return 1;
};

/*
=============
Deathmatch_Weapon

Deathmatch weapon change rules for picking up a weapon

.float		inv_ammo_shells, inv_ammo_bullets, inv_ammo_rockets, inv_ammo_cells, inv_ammo_grenades;
=============
*/
#ifdef unused
// really - what was old going to do here ?
// it is the pass parm of .items before adding the new weapon bit
void(float old, float new) Deathmatch_Weapon =
{
	local float or, nr;

// change self.weapon if desired
	or = RankForWeapon (self.weapon);
	nr = RankForWeapon (new);
	if ( nr < or )
#else
void(float new) Deathmatch_Weapon =
{
// change self.weapon if desired
	if ( RankForWeapon(new) < RankForWeapon(self.weapon) )
#endif
		self.weapon = new;
};

/*
=============
weapon_touch
=============
*/
float() W_BestWeapon;
void() insane_gotaweapon;

void() weapon_touch =
{
	local	float	new, newRank, oldRank;
//	local	entity	stemp;
#define stemp 	newmis
	local	float	leave;

	if (!(other.flags & FL_CLIENT))
		return;
	
	#ifdef misc_insane_weapon_pickup
	if (other.classname == "misc_insane")
	{
		if (other.deadflag == DEAD_DEAD)
			return;
		
		if (other.spawnflags & 8) //no helping anyone who's crucified!
			return;
		
		if (anyWeapons(other)){ //already has a weapon
			LOG2("I already got a ", printWeaponName(other));
			return;
		}
		
		other.inv_ammo_shells = self.inv_ammo_shells;
		other.inv_ammo_bullets = self.inv_ammo_bullets;
		other.inv_ammo_rockets = self.inv_ammo_rockets;
		other.inv_ammo_slugs = self.inv_ammo_slugs;
		other.inv_ammo_cells = self.inv_ammo_cells;		
		other.think = insane_gotaweapon;
		leave = 1;
	}
	#endif

// if the player was using his best weapon, change up to the new one if better		
	stemp = self;
	self = other;

	// logic change to eliminate extra statements
	if (deathmatch == 2 || coop){
		leave = 1;
	}else{
		leave = 0;
	}
	if (stemp.classname == "weapon_machinegun")
	{
		if (leave && (self.inv_weapons & WEP_MACHINEGUN) ){
			return;
		}
		new = WEP_MACHINEGUN;
		
		//tossWeapon ammo regain balancing - previous owner gets no additional ammo for THIS pickup.
		if (self != stemp.owner){
			self.inv_ammo_bullets = self.inv_ammo_bullets + 30;
		}
	}
	else if (stemp.classname == "weapon_chaingun")
	{
		if (leave && (self.inv_weapons & WEP_CHAINGUN) ){
			return;
		}
		new = WEP_CHAINGUN;
		
		//tossWeapon ammo regain balancing - previous owner gets no additional ammo for THIS pickup.
		if (self != stemp.owner){
			self.inv_ammo_bullets = self.inv_ammo_bullets + 30;
		}
	}
	else if (stemp.classname == "weapon_supershotgun")
	{
		if (leave && (self.inv_weapons & WEP_SUPERSHOTGUN) ){
			return;
		}
		new = WEP_SUPERSHOTGUN;
		
		//tossWeapon ammo regain balancing - previous owner gets no additional ammo for THIS pickup.
		if (self != stemp.owner){
			self.inv_ammo_shells = self.inv_ammo_shells + 5;
		}
	}
	else if (stemp.classname == "weapon_shotgun")
	{
		if (leave && (self.inv_weapons & WEP_SHOTGUN) ){
			return;
		}
		new = WEP_SHOTGUN;
		
		//tossWeapon ammo regain balancing - previous owner gets no additional ammo for THIS pickup.
		if (self != stemp.owner){
			self.inv_ammo_shells = self.inv_ammo_shells + 5;
		}
	}
	else if (stemp.classname == "weapon_rocketlauncher")
	{
		if (leave && (self.inv_weapons & WEP_ROCKET_LAUNCHER) ){
			return;
		}
		new = WEP_ROCKET_LAUNCHER;
		
		//tossWeapon ammo regain balancing - previous owner gets no additional ammo for THIS pickup.
		if (self != stemp.owner){
			self.inv_ammo_rockets = self.inv_ammo_rockets + 5;
		}
	}
	else if (stemp.classname == "weapon_grenadelauncher")
	{
		if (leave && (self.inv_weapons & WEP_GRENADE_LAUNCHER) ){
			return;
		}
		new = WEP_GRENADE_LAUNCHER;
		
		//tossWeapon ammo regain balancing - previous owner gets no additional ammo for THIS pickup.
		if (self != stemp.owner){
			self.inv_ammo_rockets = self.inv_ammo_rockets + 5;
		}
	}
	else if (stemp.classname == "weapon_hyperblaster")
	{
		if (leave && (self.inv_weapons & WEP_HYPERBLASTER) ){
			return;
		}
		new = WEP_HYPERBLASTER;
		
		//tossWeapon ammo regain balancing - previous owner gets no additional ammo for THIS pickup.
		if (self != stemp.owner){
			self.inv_ammo_cells = self.inv_ammo_cells + 15;
		}
	}
	else if (stemp.classname == "weapon_railgun")
	{
		if (leave && (self.inv_weapons & WEP_RAILGUN) )
			return;

		new = WEP_RAILGUN;
		
		//tossWeapon ammo regain balancing - previous owner gets no additional ammo for THIS pickup.
		if (self != stemp.owner){
			self.inv_ammo_slugs = self.inv_ammo_slugs + 15;
		}
	}
	else if (stemp.classname == "weapon_bfg")
	{
		if (leave && (self.inv_weapons & WEP_BFG) )
			return;

		new = WEP_BFG;
		
		//tossWeapon ammo regain balancing - previous owner gets no additional ammo for THIS pickup.
		if (self != stemp.owner){
			self.inv_ammo_cells = self.inv_ammo_cells + 50;
		}
	}
	else if (stemp.classname == "weapon_grenade")
	{
		if (leave && (self.inv_weapons & WEP_GRENADE) )
			return;

		new = WEP_GRENADE;
		
		//tossWeapon ammo regain balancing - previous owner gets no additional ammo for THIS pickup.
		if (self != stemp.owner){
			self.inv_ammo_cells = self.inv_ammo_cells + 50;
		}
	}
	else
#ifdef noobjerr
	{
		remove(stemp);
		return;
	}
#else
		objerror ("weapon_touch: unknown classname");					//opgrade protected
#endif
	
	sprint (self, "You got the ");
	sprint (self, stemp.netname);
	sprint (self, "\n");
// weapon touch sound
	sound (self, CHAN_ITEM, "weapons/pkup.wav", 1, ATTN_NORM);
	stuffcmd (self, "bf\n");
	
	
	self.inv_weapons = self.inv_weapons | new;
	bound_other_ammo (self);
	
	/*if (!deathmatch)
		self.weapon = new;
	else
		Deathmatch_Weapon(new);*/
	
	newRank = RankForWeapon(new);
	oldRank = RankForWeapon(self.weapon);
	if( newRank > oldRank ){
		if(self.weaponstate == WEAPON_READY){
			self.weapon_next = new;
			W_ChangeWeapon();
		}
	}
	self = stemp;

	if (leave)
		return;

// note: causes a double bf\n
	touched(30);

#undef stemp
};

/*
===============================================================================

AMMO

===============================================================================
*/

void() ammo_touch =
{
//local entity	stemp;
#define stemp 	newmis
local float		best;

	if (other.classname != "player")
		return;
	if (other.health <= 0)
		return;

// if the player was using his best weapon, change up to the new one if better		
	stemp = self;
	self = other;
	best = W_BestWeapon();

// shells
	if (stemp.weapon == 1)
	{
		if (self.inv_ammo_shells >= 100)
			return;
		self.inv_ammo_shells = self.inv_ammo_shells + stemp.aflag;
	}

// bullets
	if (stemp.weapon == 2)
	{
		if (self.inv_ammo_bullets >= 200)
			return;
		self.inv_ammo_bullets = self.inv_ammo_bullets + stemp.aflag;
	}

//	rockets
	if (stemp.weapon == 3)
	{
		if (self.inv_ammo_rockets >= 100)
			return;
		self.inv_ammo_rockets = self.inv_ammo_rockets + stemp.aflag;
	}

//	cells
	if (stemp.weapon == 4)
	{
		if (self.inv_ammo_cells >= 100)
			return;
		self.inv_ammo_cells = self.inv_ammo_cells + stemp.aflag;
	}
	
//	slugs
	if (stemp.weapon == 5)
	{
		if (self.inv_ammo_slugs >= 100)
			return;
		self.inv_ammo_slugs = self.inv_ammo_slugs + stemp.aflag;
	}

	bound_other_ammo (self);
	
	sprint (self, "You got ");
	sprint (self, ftos(stemp.aflag));
	sprint (self, " ");
	sprint (self, stemp.netname);
	sprint (self, "\n");
	// ammo touch sound
	sound (self, CHAN_ITEM, "weapons/lock4.wav", 1, ATTN_NORM);

	W_updateCurrentAmmo(self);
	self = stemp;

	touched(30);

#undef stemp
};

/*
===============================================================================

KEYS

===============================================================================
*/

void() q2key_touch =
{
	if (other.classname != "player")
		return;
	if (other.health <= 0)
		return;
	if (other.items_q2keys & self.items_q2keys)
		return;

	sprint (other, "You got the ");
	sprint (other, self.netname);
	sprint (other,"\n");

	sound (other, CHAN_ITEM, self.noise, 1, ATTN_NORM);
	stuffcmd (other, "bf\n");
	other.items_q2keys = other.items_q2keys | self.items_q2keys;

	//FLOG(self.items_q2keys);

	if (!coop)
	{	
		self.solid = SOLID_NOT;
		self.model = string_null;
	}

	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
};

void() key_touch =
{
	if (other.classname != "player")
		return;
	if (other.health <= 0)
		return;
	if (other.items & self.items)
		return;

	sprint (other, "You got the ");
	sprint (other, self.netname);
	sprint (other,"\n");

	sound (other, CHAN_ITEM, self.noise, 1, ATTN_NORM);
	stuffcmd (other, "bf\n");
	other.items = other.items | self.items;

	if (!coop)
	{	
		self.solid = SOLID_NOT;
		self.model = string_null;
	}

	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
};

// Number 6 - mod to allow map author to override world.worldtype and have various worldtype keys on the same map
//							 future mod - make all 6 keys unique for doors - the issue with this is that the player ent only has 2 key bits

void() key_setsounds =
{
	if (self.worldtype < 1)
	{
		precache_sound ("misc/medkey.wav");
		self.noise = "misc/medkey.wav";
	}
	if (self.worldtype == 1)
	{
		precache_sound ("misc/runekey.wav");
		self.noise = "misc/runekey.wav";
	}
	if (self.worldtype >= 2)
	{
		precache_sound2 ("misc/basekey.wav");
		self.noise = "misc/basekey.wav";
	}
};

/*
===============================================================================

END OF LEVEL RUNES

===============================================================================
*/

void() sigil_touch =
{
	if (other.classname != "player")
		return;
	if (other.health <= 0)
		return;

	centerprint (other, "You got the rune!");

	sound (other, CHAN_ITEM, self.noise, 1, ATTN_NORM);

	touched(0);

	serverflags = serverflags | (self.spawnflags & 15);
	self.classname = string_null;		// so rune doors won't find it
};


/*
===============================================================================

Inventory Items

===============================================================================
*/

void() inv_item_touch =
{
	if (other.classname != "player")
		return;
	if (other.health <= 0)
		return;

	switch (self.classname){
		case "item_power_screen":
			other.inv_pickup_invisibility += 1;
			break;
		case "item_quad":
			other.inv_pickup_quad += 1;
			break;
		case "item_invulnerability":
			other.inv_pickup_invulnerability += 1;
			break;
		case "item_silencer":
			other.inv_pickup_silencer += 1;
			break;
		case "item_breather":
			other.inv_pickup_rebreather += 1;
			break;
		case "item_enviro":
			other.inv_pickup_envirosuit += 1;
			break;
	}

	sound (other, CHAN_AUTO, self.noise, 1, ATTN_NORM);

	sprint (other, "You got the ");
	sprint (other, self.netname);
	sprint (other,"\n");

	touched(0);
};

/*
===============================================================================

Upgrade Items

===============================================================================
*/

void() inv_upgrade_touch =
{
	if (other.classname != "player")
		return;
	if (other.health <= 0)
		return;

	switch (self.classname){
		case "item_upgrade_blaster":
			other.upgrade_blaster_level += 1;
			break;
	}

	sound (other, CHAN_AUTO, self.noise, 1, ATTN_NORM);

	sprint (other, "You got the ");
	sprint (other, self.netname);
	sprint (other," ");
	sprint (other, "level ");
	sprint (other, ftos(other.upgrade_blaster_level));
	sprint (other,"\n");

	touched(0);
};

/*
===============================================================================

POWERUPS

===============================================================================
*/

void() powerup_touch =
{
	if (other.classname != "player")
		return;
	if (other.health <= 0)
		return;

	sprint (other, "You got the ");
	sprint (other, self.netname);
	sprint (other,"\n");

	if (deathmatch)
	{
		self.mdl = self.model;
		
		if ((self.classname == "item_artifact_invulnerability") ||
			(self.classname == "item_artifact_invisibility"))
			self.nextthink = time + 60*5;
		else
			self.nextthink = time + 60;
		
		self.think = SUB_regen;
	}	

	sound (other, CHAN_VOICE, self.noise, 1, ATTN_NORM);

	touched(0);

	other.items = other.items | self.items;

// do the apropriate action
	if (self.classname == "item_pack")
	{
		other.inv_ammo_shells += 10;
		sprint (other, "You got 10 shells\n");		
		other.inv_ammo_bullets += 50;
		sprint (other, "You got 50 bullets\n");			
		other.inv_ammo_rockets += 5;
		sprint (other, "You got 5 rockets\n");			
		other.inv_ammo_cells += 50;
		sprint (other, "You got 50 cells\n");			
		other.inv_ammo_slugs += 10;
		sprint (other, "You got 10 slugs\n");
		W_updateCurrentAmmo(other);		
	}

};

/*
===============================================================================

PLAYER BACKPACKS AND LOOT

===============================================================================
*/

void() lootTouch =
{
	if (other.classname != "player")
		return;
	if (other.health <= 0)
		return;

	sprint (other, "You get ");

	other.inv_ammo_shells += self.inv_ammo_shells;
	other.inv_ammo_bullets += self.inv_ammo_bullets;
	other.inv_ammo_rockets += self.inv_ammo_rockets;
	other.inv_ammo_cells += self.inv_ammo_cells;
	other.inv_ammo_slugs += self.inv_ammo_slugs;
	
	bound_other_ammo (other);

	if (self.inv_ammo_shells)
	{
//		sprint(other, ", ");
		sprint (other, ftos(self.inv_ammo_shells));
		
		if (self.inv_ammo_shells == 1)
		{
			sprint (other, " shell");
		}
		else
		{
			sprint (other, " shells");
		}
	}
	if (self.inv_ammo_bullets)
	{
//		sprint(other, ", ");
		sprint (other, ftos(self.inv_ammo_bullets));
		
		if (self.inv_ammo_bullets == 1)
		{
			sprint (other, " bullet");
		}
		else
		{
			sprint (other, " bullets");
		}
	}
	if (self.inv_ammo_rockets)
	{
//		sprint(other, ", ");
		sprint (other, ftos(self.inv_ammo_rockets));
		
		if (self.inv_ammo_rockets == 1)
		{
			sprint (other, " rocket");
		}
		else
		{
			sprint (other, " rockets");
		}
	}
	if (self.inv_ammo_cells)
	{
//		sprint(other, ", ");
		sprint (other, ftos(self.inv_ammo_cells));

		if (self.inv_ammo_cells == 1)
		{
			sprint (other, " cell");
		}
		else
		{
			sprint (other, " cells");
		}
	}
	if (self.inv_ammo_slugs)
	{
//		sprint(other, ", ");
		sprint (other, ftos(self.inv_ammo_slugs));

		if (self.inv_ammo_slugs == 1)
		{
			sprint (other, " slug");
		}
		else
		{
			sprint (other, " slugs");
		}
	}
	
	sprint (other, "\n");
	sound (other, CHAN_ITEM, "weapons/lock4.wav", 1, ATTN_NORM);
	stuffcmd (other, "bf\n");

	W_updateCurrentAmmo(other);

	remove(self);
};

void() BackpackTouch =
{
//	local string	s;
#ifdef unused
	local	float	old;
#endif
	local	float	best, new;
//	local		entity	stemp;
//	local	float	acount;
#define stemp 	newmis
#define acount 	self.f__
	
	if (other.classname != "player")
		return;
	if (other.health <= 0)
		return;

	acount = 0;
	sprint (other, "You get ");

	if (self.items)
		if (!(other.items & self.items)) // == 0)
		{
			acount = 1;
			sprint (other, "the ");
			sprint (other, self.netname);
		}

// if the player was using his best weapon, change up to the new one if better		
	stemp = self;
	self = other;
	best = W_BestWeapon();
// moving because logic change changed bound_other_ammo()
//	self = stemp;

// change weapons
	self.inv_ammo_shells = self.inv_ammo_shells + stemp.inv_ammo_shells;
	self.inv_ammo_bullets = self.inv_ammo_bullets + stemp.inv_ammo_bullets;
	self.inv_ammo_rockets = self.inv_ammo_rockets + stemp.inv_ammo_rockets;
	self.inv_ammo_cells = self.inv_ammo_cells + stemp.inv_ammo_cells;
	self.inv_ammo_slugs = self.inv_ammo_slugs + stemp.inv_ammo_slugs;

	new = stemp.items;
	if (!new)
		new = self.weapon;
#ifdef unused
	old = self.items;
#endif
	
	self.items = self.items | new; 
	//MrC: FIXME: this seems to be causing the "jumpboot" bug when players pick up shells (and maybe other ammo types? More testing needed).
	//This can be replicated by picking up shells dropped by the berserk in the test_buttons map.
	//Actually now I'm not sure. Okay. So, spawn into test_buttons, kill the berserk with the machinegun and pick up the shells, boom! Jumpboots.
	//Use the shotgun or have less than the max ammo (100) for shells and no jumpboots. No added ammo either (in general).
	//This is strange as hell (or at least I'm not astute enough to see why this is happening). 
	//Screw it, I'm just gonna write a new loot touch function or something.
	
	bound_other_ammo (self);

// moved for logic change
	self = stemp;

	if (self.inv_ammo_shells)
	{
		if (acount)
			sprint(other, ", ");
		acount = 1;
//		s = ftos(self.inv_ammo_shells);
		sprint (other, ftos(self.inv_ammo_shells));
		sprint (other, " shells");
	}
	if (self.inv_ammo_bullets)
	{
		if (acount)
			sprint(other, ", ");
		acount = 1;
		sprint (other, ftos(self.inv_ammo_bullets));
		sprint (other, " bullets");
	}
	if (self.inv_ammo_rockets)
	{
		if (acount)
			sprint(other, ", ");
		acount = 1;
//		s = ftos(self.inv_ammo_rockets);
		sprint (other, ftos(self.inv_ammo_rockets));
		sprint (other, " rockets");
	}
	if (self.inv_ammo_cells)
	{
		if (acount)
			sprint(other, ", ");
		acount = 1;
//		s = ftos(self.inv_ammo_cells);
		sprint (other, ftos(self.inv_ammo_cells));
		sprint (other, " cells");
	}
	if (self.inv_ammo_slugs)
	{
		if (acount)
			sprint(other, ", ");
		acount = 1;
//		s = ftos(self.inv_ammo_cells);
		sprint (other, ftos(self.inv_ammo_slugs));
		sprint (other, " slugs");
	}
	
	sprint (other, "\n");
// backpack touch sound
	sound (other, CHAN_ITEM, "weapons/lock4.wav", 1, ATTN_NORM);
	stuffcmd (other, "bf\n");

// remove the backpack, change self to the player
	remove(self);
	self = other;

// change to the weapon
	if (!deathmatch)
		self.weapon = new;
	else
		Deathmatch_Weapon(new);

	W_updateCurrentAmmo(other);
	
#undef stemp
#undef acount
};

/*
===============
DropBackpack
===============
*/
void() DropBackpack =
{
//	local entity	item;
#define item 	newmis

	if (!(self.inv_ammo_shells + self.inv_ammo_bullets + self.inv_ammo_rockets + self.inv_ammo_cells))
		return;	// nothing in it

	item = spawn();
	item.origin = self.origin - '0 0 24';
	
	item.items = self.weapon;
	if (item.items == WEP_BLASTER)
		item.netname = "Blaster";
	else if (item.items == WEP_SHOTGUN)
		item.netname = "Shotgun";
	else if (item.items == WEP_SUPERSHOTGUN)
		item.netname = "Super Shotgun";
	else if (item.items == WEP_MACHINEGUN)
		item.netname = "Machinegun";
	else if (item.items == WEP_CHAINGUN)
		item.netname = "Chaingun";
	else if (item.items == WEP_GRENADE_LAUNCHER)
		item.netname = "Grenade Launcher";
	else if (item.items == WEP_ROCKET_LAUNCHER)
		item.netname = "Rocket Launcher";
	else if (item.items == WEP_HYPERBLASTER)
		item.netname = "Hyperblaster";
	else if (item.items == WEP_RAILGUN)
		item.netname = "Railgun";
	else if (item.items == WEP_BFG)
		item.netname = "BFG";
	else if (item.items == WEP_GRENADE)
		item.netname = "Grenade";
	else
		item.netname = string_null;

	item.inv_ammo_shells = self.inv_ammo_shells;
	item.inv_ammo_bullets = self.inv_ammo_bullets;
	item.inv_ammo_rockets = self.inv_ammo_rockets;
	item.inv_ammo_cells = self.inv_ammo_cells;

	item.velocity_z = 300;
	item.velocity_x = -100 + (random() * 200);
	item.velocity_y = -100 + (random() * 200);
	
	item.flags = FL_ITEM;
	item.solid = SOLID_TRIGGER;
	item.movetype = MOVETYPE_TOSS;
	setmodel (item, "progs/backpack.mdl");
	setsize (item, '-16 -16 0', '16 16 56');
	item.touch = BackpackTouch;
	
	item.nextthink = time + 120;	// remove after 2 minutes
	item.think = SUB_Remove;

#undef item
};
	
void(float lootType, float lootAmt, vector org) DropLoot =
{
	local entity loot;

	loot = spawn();
	loot.origin = org + '0 0 24';
	setmodel (loot, "progs/backpack.mdl");
	setsize (loot, '-16 -16 0', '16 16 56');
	loot.velocity_z = 150;
	loot.velocity_x = -10 + (random() * 5);
	loot.velocity_y = -10 + (random() * 5);
	loot.netname = string_null;
	loot.touch = BackpackTouch;

	switch (lootType)
	{
		case LOOT_SHELLS:
			loot.netname = "Shells";
			setmodel (loot, "models/items/ammo/shells/medium/tris.md2");
			setsize (loot, '-16 -16 -16', '16 16 16');
			loot.inv_ammo_shells = lootAmt;
			loot.touch = lootTouch;			
			break;
		case LOOT_BULLETS:
			loot.netname = "Bullets";
			setmodel (loot, "models/items/ammo/bullets/medium/tris.md2");
			setsize (loot, '-16 -16 -16', '16 16 16');
			loot.inv_ammo_bullets = lootAmt;
			loot.touch = lootTouch;			
			break;
		case LOOT_ROCKETS:
			loot.netname = "Rockets";
			setmodel (loot, "models/items/ammo/rockets/medium/tris.md2");
			setsize (loot, '-16 -16 -16', '16 16 16');
			loot.inv_ammo_rockets = lootAmt;
			loot.touch = lootTouch;			
			break;
		case LOOT_SLUGS:
			loot.netname = "Slugs";
			setmodel (loot, "models/items/ammo/slugs/medium/tris.md2");
			setsize (loot, '-16 -16 -16', '16 16 16');
			loot.inv_ammo_slugs = lootAmt;
			loot.touch = lootTouch;			
			break;
		case LOOT_CELLS:
			loot.netname = "Cells";
			setmodel (loot, "models/items/ammo/cells/medium/tris.md2");
			setsize (loot, '-16 -16 -16', '16 16 16');
			loot.inv_ammo_cells = lootAmt;
			loot.touch = lootTouch;			
			break;
		case LOOT_ARMOR_SHARD:
			loot.netname = "Armor Shard";
			loot.classname = "item_armor_shard";
			setmodel (loot, "models/items/armor/shard/tris.md2");
			setsize (loot, '-16 -16 -16', '16 16 16');
			loot.noise = "misc/ar2_pkup.wav";
			loot.modelflags = MF_ROTATE;
			loot.touch = armor_touch;
			break;
		case LOOT_SHOTGUN:
			loot.netname = "Shotgun";
			loot.classname = "weapon_shotgun";
			setmodel (loot, "models/weapons/g_shotg/tris.md2");
			setsize (loot, '-16 -16 0', '16 16 56');
			loot.noise = "weapons/pkup.wav";
			loot.inv_ammo_shells = lootAmt;
			loot.modelflags = MF_ROTATE;
			loot.touch = weapon_touch;
			break;
		case LOOT_SUPERSHOTGUN:
			loot.netname = "Super Shotgun";
			loot.classname = "weapon_supershotgun";
			setmodel (loot, "models/weapons/g_shotg2/tris.md2");
			setsize (loot, '-16 -16 0', '16 16 56');
			loot.noise = "weapons/pkup.wav";
			loot.inv_ammo_shells = lootAmt;
			loot.modelflags = MF_ROTATE;
			loot.touch = weapon_touch;
			break;
		case LOOT_MACHINEGUN:
			loot.netname = "Machinegun";
			loot.classname = "weapon_machinegun";
			setmodel (loot, "models/weapons/g_machn/tris.md2");
			setsize (loot, '-16 -16 0', '16 16 56');
			loot.noise = "weapons/pkup.wav";
			loot.inv_ammo_bullets = lootAmt;
			loot.modelflags = MF_ROTATE;
			loot.touch = weapon_touch;
			break;
		case LOOT_CHAINGUN:
			loot.netname = "Chaingun";
			loot.classname = "weapon_chaingun";
			setmodel (loot, "models/weapons/g_chain/tris.md2");
			setsize (loot, '-16 -16 0', '16 16 56');
			loot.noise = "weapons/pkup.wav";
			loot.inv_ammo_bullets = lootAmt;
			loot.modelflags = MF_ROTATE;
			loot.touch = weapon_touch;
			break;
		case LOOT_GRENADE_LAUNCHER:
			loot.netname = "Grenade Launcher";
			loot.classname = "weapon_grenadelauncher";
			setmodel (loot, "models/weapons/g_launch/tris.md2");
			setsize (loot, '-16 -16 0', '16 16 56');
			loot.noise = "weapons/pkup.wav";
			loot.inv_ammo_rockets = lootAmt;
			loot.modelflags = MF_ROTATE;
			loot.touch = weapon_touch;
			break;
		case LOOT_ROCKET_LAUNCHER:
			loot.netname = "Rocket Launcher";
			loot.classname = "weapon_rocketlauncher";
			setmodel (loot, "models/weapons/g_rocket/tris.md2");
			setsize (loot, '-16 -16 0', '16 16 56');
			loot.noise = "weapons/pkup.wav";
			loot.inv_ammo_rockets = lootAmt;
			loot.modelflags = MF_ROTATE;
			loot.touch = weapon_touch;
			break;
		case LOOT_HYPERBLASTER:
			loot.netname = "Hyperblaster";
			loot.classname = "weapon_hyperblaster";
			setmodel (loot, "models/weapons/g_hyperb/tris.md2");
			setsize (loot, '-16 -16 0', '16 16 56');
			loot.noise = "weapons/pkup.wav";
			loot.inv_ammo_cells = lootAmt;
			loot.modelflags = MF_ROTATE;
			loot.touch = weapon_touch;
			break;
		case LOOT_RAILGUN:
			loot.netname = "Railgun";
			loot.classname = "weapon_railgun";
			setmodel (loot, "models/weapons/g_rail/tris.md2");
			setsize (loot, '-16 -16 0', '16 16 56');
			loot.noise = "weapons/pkup.wav";
			loot.inv_ammo_slugs = lootAmt;
			loot.modelflags = MF_ROTATE;
			loot.touch = weapon_touch;
			break;
		case LOOT_BFG:
			loot.netname = "BFG";
			loot.classname = "weapon_bfg";
			setmodel (loot, "models/weapons/g_bfg/tris.md2");
			setsize (loot, '-16 -16 0', '16 16 56');
			loot.noise = "weapons/pkup.wav";
			loot.inv_ammo_cells = lootAmt;
			loot.modelflags = MF_ROTATE;
			loot.touch = weapon_touch;
			break;			
	}
	
	loot.flags = FL_ITEM;
	loot.solid = SOLID_TRIGGER;
	loot.movetype = MOVETYPE_TOSS;
	loot.nextthink = time + 120;	// remove after 2 minutes
	loot.think = SUB_Remove;
};

/*
===============
	Toss WEAPONS
	EXT_Q2
		In Q2, the player could toss any old weapon out onto the map for w/e reason.
		
		self == player
===============
*/
void() q2_tossWeapon={
	local entity newWeapon;
	local entity this;
	
	if(self.weapon == WEP_BLASTER){
		return;
	}
	
	self.weaponmodel = ""; //quick fix to make weapon vanish when throwing
		
	//remove weapon form player inventory
	self.inv_weapons = self.inv_weapons - (self.inv_weapons & self.weapon);	
	
	self.weaponstate_next = WEAPON_ACTIVATING;
	self.weapon_next = W_BestWeapon();
	
	this = self;
	newWeapon = spawn();
	self = newWeapon;
	
	makevectors(this.angles);
	
	if (this.weapon == WEP_SUPERSHOTGUN){
		weapon_supershotgun();
		self.classname = "weapon_supershotgun";
	}
	else if (this.weapon == WEP_SHOTGUN){
		weapon_shotgun();
		self.classname = "weapon_shotgun";	
	}
	else if (this.weapon == WEP_MACHINEGUN){
		weapon_machinegun();
		self.classname = "weapon_machinegun";	
	}
	else if (this.weapon == WEP_CHAINGUN){
		weapon_chaingun();
		self.classname = "weapon_chaingun";	
	}
	else if (this.weapon == WEP_GRENADE_LAUNCHER){
		weapon_grenadelauncher();
		self.classname = "weapon_grenadelauncher";	
	}
	else if (this.weapon == WEP_ROCKET_LAUNCHER){
		weapon_rocketlauncher();
		self.classname = "weapon_rocketlauncher";		
	}
	else if (this.weapon == WEP_HYPERBLASTER){
		weapon_hyperblaster();
		self.classname = "weapon_hyperblaster";	
	}
	else if (this.weapon == WEP_RAILGUN){
		weapon_railgun();
		self.classname = "weapon_railgun";	
	}
	else if (this.weapon == WEP_BFG){
		weapon_bfg();
		self.classname = "weapon_bfg";	
	}
	else{
		self = this;
		remove(newWeapon);
		return;
	}
	
	setsize (self, '-16 -16 0', '16 16 56');
	setorigin(self, this.origin + v_forward * 24);
	
	self.owner = this;
	
	self.velocity = normalize((this.origin + (v_forward * 1)) - this.origin) * 175;
	self.velocity_z = 150;
	
	self.movetype = MOVETYPE_TOSS;
	self.solid = SOLID_BBOX;	
	
	self.think = PlaceItem;
	self.nextthink = time + 1;
	
	self = this;
};