//********************************************
// FUNC_EXPLOSIVE
//********************************************

//MrC: The following is based on func_xplowall from DPMOD. Thanks!

// several counters (so far only count2 and cnt2 are used but more things from dpmod might be added that use these).
// 
.float count1, count2, count3, count4, count5, count6, cnt1, cnt2;

float XWALL_HEAL = 1;

void() xwall_break;
void() xwall_heal;

void() xwall_respawn =
{
	self.solid = SOLID_BSP;
	self.dphitcontentsmask = DPCONTENTS_SOLID;
	self.touch = xwall_break;
	self.movetype = MOVETYPE_PUSH;
	setorigin (self, self.origin);
	setmodel (self, self.mdl);
	self.use = xwall_break;

	if (self.max_health >= 1)
	{
		self.takedamage = DAMAGE_YES;
		self.th_die = xwall_break;
		if (self.spawnflags & XWALL_HEAL)
			self.th_pain = xwall_heal;
		else
			self.th_pain = SUB_Null;
	}
	else{
		self.takedamage = DAMAGE_NO;
	}

	self.touch = SUB_Null;
};

void() xwall_hidethink;
void() BecomeExplosion;
void(float lootType, float lootAmt, vector org) DropLoot;

void() xwall_spawnLoot =
{
	switch(self.owner.droploot)
	{
		case 1:
			DropLoot(LOOT_SHELLS, self.owner.aflag, randompos(self.absmin, self.absmax));
		break;
		case 2:
			DropLoot(LOOT_BULLETS, self.owner.aflag, randompos(self.absmin, self.absmax));
		break;		
		case 3:
			DropLoot(LOOT_ROCKETS, self.owner.aflag, randompos(self.absmin, self.absmax));
		break;
		case 4:
			DropLoot(LOOT_SLUGS, self.owner.aflag, randompos(self.absmin, self.absmax));
		break;
		case 5:
			DropLoot(LOOT_CELLS, self.owner.aflag, randompos(self.absmin, self.absmax));
		break;
		case 6:
			DropLoot(LOOT_ARMOR_SHARD, self.owner.aflag, randompos(self.absmin, self.absmax));
		break;
		case 7:
			DropLoot(LOOT_HEALTH_SMALL, self.owner.aflag, randompos(self.absmin, self.absmax));
		break;
		case 8:
			DropLoot(LOOT_SHOTGUN, self.owner.aflag, randompos(self.absmin, self.absmax));
		break;
		case 9:
			DropLoot(LOOT_SUPERSHOTGUN, self.owner.aflag, randompos(self.absmin, self.absmax));
		break;
		case 10:
			DropLoot(LOOT_MACHINEGUN, self.owner.aflag, randompos(self.absmin, self.absmax));
		break;
		case 11:
			DropLoot(LOOT_CHAINGUN, self.owner.aflag, randompos(self.absmin, self.absmax));
		break;
		case 12:
			DropLoot(LOOT_GRENADE_LAUNCHER, self.owner.aflag, randompos(self.absmin, self.absmax));
		break;
		case 13:
			DropLoot(LOOT_ROCKET_LAUNCHER, self.owner.aflag, randompos(self.absmin, self.absmax));
		break;
		case 14:
			DropLoot(LOOT_HYPERBLASTER, self.owner.aflag, randompos(self.absmin, self.absmax));
		break;
		case 15:
			DropLoot(LOOT_RAILGUN, self.owner.aflag, randompos(self.absmin, self.absmax));
		break;
		case 16:
			DropLoot(LOOT_BFG, self.owner.aflag, randompos(self.absmin, self.absmax));
		break;		
	}
}

void() xwall_breakthink =
{
	local float t, r, t2, t3;
	local vector v, v2;
	local entity ts;
	local float mat = 0;
	local string break_sound;
	
	self.think = xwall_breakthink;
	self.nextthink = time + self.owner.delay;
	
	if (self.owner.droploot)
	{
		xwall_spawnLoot();
	}	
	
	t = 0; // give up the search after 20 failures
	while (t < 20)
	{
		v = randompos(self.absmin, self.absmax);
		t = t + 1;
		if (pointcontents(v) != CONTENT_SOLID) // found a spot
			t = 1000000;
	}

	t3 = TRUE; // pick a new location for each piece of rubble
	if (self.cnt2 > 0)
	{
		t3 = FALSE; // spawn rubble from each explosion
		self.cnt2 = self.cnt2 - 1;
		newmis = spawn();
		newmis.owner = self.owner;
		setorigin(newmis, v);
		//T_RadiusDamage(newmis, newmis.owner, newmis.owner.dmg, newmis.owner.dmg, newmis.owner.dmg, world, self.deathtype, DT_EXPLOSION, Obituary_Generic);
		T_RadiusDamage (self, self, newmis.owner.dmg, world);
		//BecomeExplosion(newmis, '0 0 0', FALSE);
		BecomeExplosion ();
	}
	t2 = floor(self.cnt);
	self.cnt = self.cnt + self.count;

	while (t2 < self.cnt)
	{
		t2 = t2 + 1;
		if (t3) // pick a new location for each piece of rubble
		{
			t = 0; // give up the search after 20 failures
			while (t < 20)
			{
				v = randompos(self.absmin, self.absmax);
				t = t + 1;
				if (pointcontents(v) != CONTENT_SOLID) // found a spot
					t = 1000000;
			}
		}
		v2 = randomvec() * (self.owner.dmg + 20) * 3 + '0 0 120';

		pointparticles(particleeffectnum(self.owner.myparticle), v, v2, 1);

		r = floor(random()*3);		
		
		switch(self.owner.material)
		{
		case 1:
		break_sound = "";
		if (r == 0) ThrowDebris(world, v, v2, "models/objects/debris1/tris.md2", GIB_NONE);
		if (r == 1) ThrowDebris(world, v, v2, "models/objects/debris2/tris.md2", GIB_NONE);
		if (r == 2) ThrowDebris(world, v, v2, "models/objects/debris3/tris.md2", GIB_NONE);
		break;
		
		case 2:
		break_sound = "misc/udeath.wav";
		if (r == 0) ThrowDebris(world, v, v2, "models/objects/gibs/bone/tris.md2", GIB_FLESH);
		if (r == 1) ThrowDebris(world, v, v2, "models/objects/gibs/sm_meat/tris.md2", GIB_FLESH);
		break;
		
		case 3:
		if (r == 0) ThrowDebris(world, v, v2, "models/objects/debris1/tris.md2", GIB_METAL);
		if (r == 1) ThrowDebris(world, v, v2, "models/objects/debris2/tris.md2", GIB_METAL);
		if (r == 2) ThrowDebris(world, v, v2, "models/objects/debris3/tris.md2", GIB_METAL);
		break;
		
		case 4:
		if (r == 0) ThrowDebris(world, v, v2, "models/objects/debris1/tris.md2", GIB_FLAMING);
		if (r == 1) ThrowDebris(world, v, v2, "models/objects/debris2/tris.md2", GIB_FLAMING);
		if (r == 2) ThrowDebris(world, v, v2, "models/objects/debris3/tris.md2", GIB_FLAMING);
		break;
		
		case 5:
		if (r == 0) ThrowDebris(world, v, v2, "models/objects/debris1/tris.md2", GIB_GLASS);
		if (r == 1) ThrowDebris(world, v, v2, "models/objects/debris2/tris.md2", GIB_GLASS);
		if (r == 2) ThrowDebris(world, v, v2, "models/objects/debris3/tris.md2", GIB_GLASS);
		break;
		
		case 6:
		if (r == 0) ThrowDebris(world, v, v2, "models/objects/debris1/tris.md2", GIB_WOOD);
		if (r == 1) ThrowDebris(world, v, v2, "models/objects/debris2/tris.md2", GIB_WOOD);
		if (r == 2) ThrowDebris(world, v, v2, "models/objects/debris3/tris.md2", GIB_WOOD);
		break;
		
		case 7:
		if (r == 0) ThrowDebris(world, v, v2, "models/objects/debris1/tris.md2", GIB_STONE);
		if (r == 1) ThrowDebris(world, v, v2, "models/objects/debris2/tris.md2", GIB_STONE);
		if (r == 2) ThrowDebris(world, v, v2, "models/objects/debris3/tris.md2", GIB_STONE);
		break;		
		}

		sound(self, CHAN_BODY, break_sound, 0.75, ATTN_IDLE);

		r = r + 1;
		if (r >= 3)
			r = 0;
	}
	if (self.cnt2 < 1)
	{
		ts = self;
		self = self.owner;
		if (self.use == SUB_Null)
		xwall_hidethink();
		self = ts;
		remove(self);
	}
};

void() xwall_hidethink =
{
	SUB_UseTargets();
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_NONE;
	setorigin(self, self.origin); // relink
	self.model = "";
	self.modelindex = 0;
	self.think = xwall_respawn;
	if (self.wait > 0)
		self.nextthink = time + self.wait;
	else
		remove(self);
};

void() xwall_break =
{
	local entity e;
	if (self.use == SUB_Null)
		return;
	e = spawn();
	e.owner = self;
	e.solid = SOLID_NOT;
	e.movetype = MOVETYPE_NONE;
	setorigin(e, '0 0 0');
	setsize(e, self.absmin - '16 16 16', self.absmax + '16 16 16');
	e.think = xwall_breakthink;
	e.nextthink = time + 0.1;
	e.cnt = 0;
	e.cnt2 = self.count2;
	e.count = self.count;
	e.count2 = self.count2;
	self.think = xwall_hidethink;
	self.nextthink = time + (self.delay * self.count2);
	self.takedamage = DAMAGE_NO;
	self.th_pain = SUB_Null;
	self.th_die = SUB_Null;
	self.touch = SUB_Null;
	self.use = SUB_Null;
};


void() xwall_heal =
{
	self.health = self.max_health;
};


/*QUAKED func_explosive (0 .5 .8) ? 

Normally you must do enough damage
in one blast to break the wall.

Flags:
"Heal"
 No progressive damage. Must break health threshold in one shot.

Keys:
"targetname"
 will break if targeted.
"target"
 will trigger when destroyed.
"health"
 if health is -1 then can only be
 broken by targeting and keys,
 default 100
 (close pipebomb will break).
"dmg"
 explosions do this much radius
 damage if set.
"count"
 how many pieces of debris
 (releases this much debris
  total, some every explosion)
 (default is 5, -1 for no debris)
"count2"
 how many explosions
 (will release debris with none)
 (default is 3, use -1 for none)
"delay"
 time between explosions
 default: 0.1
"wait"
 time before respawning
 (default is no respawn)
 (this time is counted from the
  last explosion)
"material"
 Type of debris, normal gibs make no impact sounds or effects. 

 1: Normal Gibs
 2: Flesh
 3: Metal
 4: Flaming
 5: Glass
 6: Wood
 7: Stone
*/
void() func_explosive =
{
	if (!self.deathtype) // map makers can override this
		self.deathtype = " was splattered by a wall";
	if (!self.count)
		self.count = 5;
	if (self.mass) 
		self.count = self.mass / 15;
	if (!self.count2)
		self.count2 = 0;
	if (self.delay < 0.1)
		self.delay = 0.1;
	if (!self.material)
		self.material = 1;
	if (!self.aflag)
		self.aflag = 1;

	if (self.count2 >= 1)
		self.count = self.count / self.count2;

	self.mdl = self.model;
	self.max_health = self.health;

	xwall_respawn();
}; 
