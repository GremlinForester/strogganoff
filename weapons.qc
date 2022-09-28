/*
===============================================================================

PLAYER WEAPON USE

===============================================================================
*/

float() W_BestWeapon =
{
	local	float	it;
	
	it = self.inv_weapons;

  if (self.inv_ammo_cells > 0 && (it & WEP_BFG) ){
    return WEP_BFG;
  }
  if (self.inv_ammo_slugs > 0 && (it & WEP_RAILGUN) ){
    return WEP_RAILGUN;
  }
  if (self.inv_ammo_cells > 0 && (it & WEP_HYPERBLASTER) ){
    return WEP_HYPERBLASTER;
  }
  if(self.inv_ammo_bullets > 1 && (it & WEP_CHAINGUN) ){
    return WEP_CHAINGUN;
  }
  if(self.inv_ammo_shells > 1 && (it & WEP_SUPERSHOTGUN) ){
    return WEP_SUPERSHOTGUN;
  }
  if(self.inv_ammo_bullets > 0 && (it & WEP_MACHINEGUN) ){
    return WEP_MACHINEGUN;
  }
  if(self.inv_ammo_shells > 0 && (it & WEP_SHOTGUN) ){
    return WEP_SHOTGUN;
  }
	return WEP_BLASTER;
};

float() W_CheckNoAmmo =
{
  //lead with this
	if (self.weapon == WEP_BLASTER){
		return TRUE;
  }
	if (self.currentammo > 0){
		return TRUE;
	}
	self.weapon_next = W_BestWeapon ();
  bprint(ftos(self.weapon_next));   //debug
  bprint("\n");
  //override state system
	self.weaponstate_next = WEAPON_DROPPING;
	return FALSE;
};

void()	q2playeronly_8attackframes;
void()	q2playeronly_4attackframes;


/*
============
Quake 2 uses the same 8 attack frames for the player, synced across 
third person and first person weapon frames and player animation.

The first 4 are the firing of the weapon and the next 4 are the gun cocking. 
Weapons like the blaster only use the first 4 while almost every other weapon 
uses the full 8 frames.

============
*/

void() W_Attack =
{
	makevectors	(self.v_angle);			// calculate forward angle for velocity
	self.show_hostile = time + 1;	// wake monsters up
};

/*
============
W_ChangeWeapon
  player chose specific weapon.
============
*/

void() W_ImpulseChangeWeapon =
{

  local float wep;
	
	
	if(self.weaponstate != WEAPON_READY){
		self.impulse = 0;	//consume events
		return;
	}
	if (cvar("developer")){
	bprint("W_ChangeWeapon state = ");	//debug
	bprint(ftos(self.weaponstate));	//debug
	bprint("\n");	//debug
	}
		
	switch (self.impulse){
		case IMPULSE_USE_WEAPON1:
			wep = WEP_BLASTER;
			break;
		case IMPULSE_USE_WEAPON2:
			wep = WEP_SHOTGUN;
			break;
		case IMPULSE_USE_WEAPON3:
			wep = WEP_SUPERSHOTGUN;
			break;
		case IMPULSE_USE_WEAPON4:
			wep = WEP_MACHINEGUN;
			break;
		case IMPULSE_USE_WEAPON5:
			wep = WEP_CHAINGUN;
			break;
		case IMPULSE_USE_WEAPON6:
			wep = WEP_GRENADE_LAUNCHER;
			break;
		case IMPULSE_USE_WEAPON7:
			wep = WEP_ROCKET_LAUNCHER;
			break;
		case IMPULSE_USE_WEAPON8:
			wep = WEP_HYPERBLASTER;
			break;
		case IMPULSE_USE_WEAPON9:
			wep = WEP_RAILGUN;
			break;
		case IMPULSE_USE_WEAPON10:
			wep = WEP_BFG;
			break;
	}

	self.impulse = 0;	//consume events
	if (cvar("developer")){
	//bprint("\n W_ImpulseChangeWeapon()->wep = ");	//debug TODO: add this under a more specific weapon debug cvar
	//bprint(ftos(wep));
	//bprint("\n");
	}

	//reverting W_ChangeWeapon back to mostly quake standard,
		//this is a different case from 'running out of ammo'
	W_Use_Weapon(wep);
};

/*
============
CheatCommand
============
*/
#ifdef debug
// only for testing, so only enabled in debug mode
void() CheatCommand =
{
	//Yes, this is completely unnecessary but dammit I can't be the only one who needs just a little reassurance that I just cheated!
	//Just a little flash. And a sound. Just a little bling and some cha-ching. That's all. 
	//Alright fine. I need it okay!? Happy? There I said it. I need it.
	//Think of me what you will, judge me even, but just don't take this away. Ok, alright. Maybe I need help.
	stuffcmd(self, "bf\n");
	sound(self, CHAN_ITEM, "misc/ar1_pkup.wav", 1, ATTN_NORM);
	
	if (deathmatch
// note: opgrade has this cheat enabled in coop
#ifndef opgrade
						|| coop
#endif
									)		return;

	self.inv_pickup_invisibility = 5;
	self.inv_pickup_quad = 5;
	self.inv_pickup_invulnerability = 5;
	self.inv_pickup_silencer = 5;
	self.inv_pickup_rebreather = 5;	
	self.inv_pickup_envirosuit = 5;	
	self.inv_ammo_rockets = 100;
	self.inv_ammo_bullets = 200;
	self.inv_ammo_shells = 100;
	self.inv_ammo_slugs = 100;
	self.inv_ammo_cells = 200;
	self.inv_weapons = self.inv_weapons | 
		WEP_BLASTER |
		WEP_SHOTGUN |
		WEP_SUPERSHOTGUN |
		WEP_MACHINEGUN |
		WEP_CHAINGUN |
		WEP_GRENADE_LAUNCHER |
		WEP_ROCKET_LAUNCHER |
		WEP_HYPERBLASTER |
		WEP_RAILGUN |
		WEP_BFG;
		WEP_GRENADE;
	self.items_q2keys = self.items_q2keys | 
		IT_KEY_DATACD | 
		IT_KEY_POWERCUBE | 
		IT_KEY_PYRAMID | 
		IT_KEY_DATASPINNER |
		IT_KEY_PASS |
		IT_KEY_BLUE |
		IT_KEY_RED |
		IT_KEY_HEAD;
	self.items = self.items | 
		IT_KEY1 | IT_KEY2 | IT_ARMOR_JACKET;
	self.armorvalue = 100;
	self.armortype = 0.3;
	
	W_updateCurrentAmmo(self);
	
	self.impulse = 0;
};

// debug qual
#endif

float() onlyBlaster =
{
	if (self.inv_weapons & WEP_SHOTGUN)
		return FALSE;
	if (self.inv_weapons & WEP_SUPERSHOTGUN)
		return FALSE;
	if (self.inv_weapons & WEP_MACHINEGUN)
		return FALSE;
	if (self.inv_weapons & WEP_CHAINGUN)
		return FALSE;
	if (self.inv_weapons & WEP_GRENADE_LAUNCHER)
		return FALSE;
	if (self.inv_weapons & WEP_ROCKET_LAUNCHER)
		return FALSE;
	if (self.inv_weapons & WEP_HYPERBLASTER)
		return FALSE;
	if (self.inv_weapons & WEP_RAILGUN)
		return FALSE;
	if (self.inv_weapons & WEP_BFG)
		return FALSE;
	return TRUE;
} 

/*
============
CycleWeaponNext

Go to the next weapon with ammo
============
*/
void() CycleWeaponNext =
{
	local	float	am, checkWep;
	
	self.impulse = 0;
	checkWep = self.weapon;

	if (onlyBlaster()){
		return;
	}
	
	while (1)
	{
		am = 0;

		if (checkWep == WEP_BFG)
		{
			checkWep = WEP_BLASTER;
		}
		else if (checkWep == WEP_BLASTER)
		{
			checkWep = WEP_SHOTGUN;
			if (self.inv_ammo_shells < 1)
				am = 1;
		}
		else if (checkWep == WEP_SHOTGUN)
		{
			checkWep = WEP_SUPERSHOTGUN;
			if (self.inv_ammo_shells < 2)
				am = 1;
		}               
		else if (checkWep == WEP_SUPERSHOTGUN)
		{
			checkWep = WEP_MACHINEGUN;
			if (self.inv_ammo_bullets < 1)
				am = 1;
		}
		else if (checkWep == WEP_MACHINEGUN)
		{
			checkWep = WEP_CHAINGUN;
			if (self.inv_ammo_bullets < 1)
				am = 1;
		}
		else if (checkWep == WEP_CHAINGUN)
		{
			checkWep = WEP_GRENADE_LAUNCHER;
			if (self.inv_ammo_rockets < 1)
				am = 1;
		}
		else if (checkWep == WEP_GRENADE_LAUNCHER)
		{
			checkWep = WEP_ROCKET_LAUNCHER;
			if (self.inv_ammo_rockets < 1)
				am = 1;
		}
		else if (checkWep == WEP_ROCKET_LAUNCHER)
		{
			checkWep = WEP_HYPERBLASTER;
			if (self.inv_ammo_cells < 1)
				am = 1;
		}
		else if (checkWep == WEP_HYPERBLASTER)
		{
			checkWep = WEP_RAILGUN;
			if (self.inv_ammo_slugs < 1)
				am = 1;
		}
		else if (checkWep == WEP_RAILGUN)
		{
			checkWep = WEP_BFG;
			if (self.inv_ammo_cells < 1)
				am = 1;
		}
	
		if ( (self.inv_weapons & checkWep) && am == 0 )
		{
			self.weapon_next = checkWep;
			return;
		}
	}

};

/*
============
CycleWeaponPrev

Go to the previous weapon with ammo
============
*/
void() CycleWeaponPrev =
{
	local	float	am, checkWep;
	
	self.impulse = 0;
	//cache this here, I think the loop only works when using specifically 1 var
	checkWep = self.weapon;
	
	if (onlyBlaster()){
		return;
	}
	
	while (1)
	{
		am = 0;
		if (checkWep == WEP_BFG)
		{
			checkWep = WEP_RAILGUN;
			if (self.inv_ammo_slugs < 1)
				am = 1;
		}
		else if (checkWep == WEP_RAILGUN)
		{
			checkWep = WEP_HYPERBLASTER;
			if (self.inv_ammo_cells < 1)
				am = 1;
		}
		else if (checkWep == WEP_HYPERBLASTER)
		{
			checkWep = WEP_ROCKET_LAUNCHER;
			if (self.inv_ammo_rockets < 1)
				am = 1;
		}
		else if (checkWep == WEP_ROCKET_LAUNCHER)
		{
			checkWep = WEP_GRENADE_LAUNCHER;
			if (self.inv_ammo_rockets < 1)
				am = 1;
		}
		else if (checkWep == WEP_GRENADE_LAUNCHER)
		{
			checkWep = WEP_CHAINGUN;
			if (self.inv_ammo_bullets < 2)
				am = 1;
		}
		else if (checkWep == WEP_CHAINGUN)
		{
			checkWep = WEP_MACHINEGUN;
			if (self.inv_ammo_bullets < 1)
				am = 1;
		}
		else if (checkWep == WEP_MACHINEGUN)
		{
			checkWep = WEP_SUPERSHOTGUN;
			if (self.inv_ammo_shells < 2)
				am = 1;
		}
		else if (checkWep == WEP_SUPERSHOTGUN)
		{
			checkWep = WEP_SHOTGUN;
			if (self.inv_ammo_shells < 1)
				am = 1;
		}
		else if (checkWep == WEP_SHOTGUN)
		{
			checkWep = WEP_BLASTER;
			am = 0;
		}
		else if (checkWep == WEP_BLASTER)
		{
			checkWep = WEP_BFG;
			if (self.inv_ammo_cells < 1)
				am = 1;
		}
		
		if ( (self.inv_weapons & checkWep) && am == 0 )
		{
			self.weapon_next = checkWep;
			return;
		}
	}
};

/*
============
Items are handled like weapons with cycle prev/next but will need activating via an impulse.
============
*/

void() switchItemNum =
{
		local string itname;
		
		switch (self.player_pickup_itemnum){
		case INV_PICKUP_QUAD:
			itname = "Quad Damage";
			/*
			bprint("ITEM: ");
			bprint(itname);
			bprint(" ");	
			bprint(ftos(self.inv_pickup_quad));
			bprint("\n");
			*/
			break;
		case INV_PICKUP_REBREATHER:
			itname = "Rebreather";
			/*			
			bprint("ITEM: ");
			bprint(itname);
			bprint(" ");	
			bprint(ftos(self.inv_pickup_rebreather));
			bprint("\n");
			*/			
			break;
		case INV_PICKUP_INVISIBILITY:
			itname = "Invisibility";
			/*			
			bprint("ITEM: ");
			bprint(itname);
			bprint(" ");	
			bprint(ftos(self.inv_pickup_invisibility));
			bprint("\n");
			*/			
			break;
		case INV_PICKUP_SILENCER:
			itname = "Silencer";
			/*			
			bprint("ITEM: ");
			bprint(itname);
			bprint(" ");	
			bprint(ftos(self.inv_pickup_silencer));
			bprint("\n");
			*/			
			break;
		case INV_PICKUP_INVULNERABILITY:
			itname = "Invulnerability";
			/*			
			bprint("ITEM: ");
			bprint(itname);
			bprint(" ");	
			bprint(ftos(self.inv_pickup_invulnerability));
			bprint("\n");
			*/			
			break;
		case INV_PICKUP_ENVIROSUIT:
			itname = "Envirosuit";
			/*			
			bprint("ITEM: ");
			bprint(itname);
			bprint(" ");	
			bprint(ftos(self.inv_pickup_envirosuit));
			bprint("\n");
			*/			
			break;
	}
}

/*
============
CycleSkinNext

Go to the next availible skin by playerType
============
*/

void() CycleSkinNext =
{
	if (world.isHub == 1){
	self.skin += 1;

	if (self.playerType == PT_OTHER){
		if (self.skin > 2){
			self.skin = 0;
		}
	}
	
	if (self.playerType == PT_MALE){
		if (self.skin > 14){
			self.skin = 0;
		}
	}

	if (self.playerType == PT_FEMALE){
		if (self.skin > 9){
			self.skin = 0;
		}
	}
	}
	else
	{
		LOG("Skin can only be changed in HUB maps.");
	}
};

/*
============
CycleItemNext

Go to the next item in inventory
============
*/

void() CycleItemNext =
{
	self.player_pickup_itemnum += 1;

	if (self.player_pickup_itemnum > 6)
		self.player_pickup_itemnum = 0;

//	switchItemNum();
};

/*
============
CycleItemPrev

Go to the previous item in inventory
============
*/

void() CycleItemPrev =
{
	self.player_pickup_itemnum -= 1;

	if (self.player_pickup_itemnum < 0)
		self.player_pickup_itemnum = 6;
	
//	switchItemNum();
};

void() UseInventoryItem =
{
	local string itname;	

	switch (self.player_pickup_itemnum){
		case INV_PICKUP_QUAD:
			itname = "Quad Damage";
			
			if (self.inv_pickup_quad > 0){
			self.inv_pickup_quad -= 1;
			self.super_time = 1;
			self.super_damage_finished += time + 30;
			//self.items = self.items | IT_QUAD;
			addBitsToEntity(self,items,IT_QUAD);
			//spawnPLRpowerupShell();			
			}
			else{
					sprint (self, "out of item ");
					sprint (self, itname);
					sprint (self, "\n");
			}
			
			break;
		case INV_PICKUP_REBREATHER:
			itname = "Rebreather";
			if (self.inv_pickup_rebreather > 0){
			self.inv_pickup_rebreather -= 1;
			self.rad_time = 1;
			self.rebreather_finished = time + 60;
			self.items = self.items | IT_BREATHER;
			}
			else{
					sprint (self, "out of item ");
					sprint (self, itname);
					sprint (self, "\n");
			}
			
			break;
		case INV_PICKUP_INVISIBILITY:
			itname = "Invisibility";
			
			if (self.inv_pickup_invisibility > 0){
			self.inv_pickup_invisibility -= 1;
			self.invisible_time = 1;
			self.invisible_finished = time + 30;
			self.items = self.items | IT_INVISIBILITY;
			}
			else{
					sprint (self, "out of item ");
					sprint (self, itname);
					sprint (self, "\n");
			}
			
			break;
		case INV_PICKUP_SILENCER:
			itname = "Silencer";

			if (self.inv_pickup_silencer > 0){
			self.inv_pickup_silencer -= 1;
			self.silencer_time = 1;
			self.silencer_finished = time + 30;
			self.items = self.items | IT_DOUBLER;
			}
			else{
					sprint (self, "out of item ");
					sprint (self, itname);
					sprint (self, "\n");
			}
			
			break;
		case INV_PICKUP_INVULNERABILITY:
			itname = "Invulnerability";

			if (self.inv_pickup_invulnerability > 0){
			self.inv_pickup_invulnerability -= 1;
			self.invincible_time = 1;
			self.invincible_finished = time + 30;
			self.items = self.items | IT_INVULNERABILITY;
			}
			else{
					sprint (self, "out of item ");
					sprint (self, itname);
					sprint (self, "\n");
			}
			
			break;
		case INV_PICKUP_ENVIROSUIT:
			itname = "Envirosuit";
			
			if (self.inv_pickup_envirosuit > 0){
			self.inv_pickup_envirosuit -= 1;				
			self.rad_time = 1;
			self.radsuit_finished = time + 30;
			self.items = self.items | IT_SUIT;
			}
			else{
					sprint (self, "out of item ");
					sprint (self, itname);
					sprint (self, "\n");
			}
			
			break;
	}	
};

/*
============
ServerflagsCommand

Just for development
============
*/
#ifdef debug

void() ServerflagsCommand =
{
	if (deathmatch)
		return;
	
	serverflags = serverflags * 2 + 1;
};

void() QuadCheat =
{
	if (deathmatch || coop)		
		return;
	
	self.super_time = 1;
	self.super_damage_finished = time + 30;
	self.items = self.items | IT_QUAD;
#ifndef nodprint
	dprint ("quad cheat\n");
#endif
};

// debug qual
#endif

/*
============
ImpulseCommands

============
*/

void() crouch_on;
void() crouch_off;

void() q2player_flip;
void() q2player_salute;
void() q2player_taunt;
void() q2player_wave;
void() q2player_point;

.float nextpingtime;

void() q2player_ping_think =
{
	if (self.owner.health <= 0)
	{
		remove(self);
		return;
	}

	if (!self.alpha)
		self.alpha = 1;

	self.alpha = self.alpha - 0.04;
	
	if (self.alpha < 0.02){
		self.think = SUB_Remove;
	}
	else{
		self.think = q2player_ping_think;
	}

	self.nextthink = time + 0.1;	
}

void(string model, float skinnum, float tim) q2player_ping_point =
{
	local	vector	source;
	local	vector	org;
	local entity q2playerping;
	
	makevectors (self.v_angle);
	source = self.origin + '0 0 16';
	traceline (source, source + v_forward*4096, FALSE, self);
	if (trace_fraction == 1.0)
		return;
	
	org = trace_endpos - v_forward*4;

	if (time < self.nextpingtime)
		return;	
	
	q2playerping = spawn();
	q2playerping.movetype = MOVETYPE_NONE;
	q2playerping.solid = SOLID_NOT;
	q2playerping.effects = q2playerping.effects + EF_ADDITIVE + EF_NODEPTHTEST + EF_LOWPRECISION;
	q2playerping.owner = self;
	q2playerping.classname = "q2playerping";
	q2playerping.alpha = 1;
	q2playerping.skin = skinnum;
	setmodel(q2playerping, model);
	setorigin(q2playerping, org);
	sound7(q2playerping, CHAN_AUTO, "misc/keytry.wav", 1.0, ATTN_NORM, 0, 0);
	q2playerping.think = q2player_ping_think;
	q2playerping.nextthink = time + tim;
	self.nextpingtime = time + 1; //prevent spamming	
};

void(string model, float skinnum, float tim) q2player_ping =
{
	local entity q2playerping;

	if (time < self.nextpingtime)
		return;	
	
	//play ping sound
	q2playerping = spawn();
	q2playerping.movetype = MOVETYPE_NONE;
	q2playerping.solid = SOLID_NOT;
	q2playerping.effects = q2playerping.effects + EF_ADDITIVE + EF_NODEPTHTEST + EF_LOWPRECISION;
	q2playerping.owner = self;
	q2playerping.classname = "q2playerping";
	q2playerping.alpha = 1;
	q2playerping.skin = skinnum;
	setmodel(q2playerping, model);
	setorigin(q2playerping, self.origin + '0 0 24');
	sound7(self, CHAN_AUTO, "misc/keytry.wav", 1.0, ATTN_NORM, 0, 0);	
	q2playerping.think = q2player_ping_think;
	q2playerping.nextthink = time + tim;
	self.nextpingtime = time + 1; //prevent spamming
}

void(entity) setPlayerModel;

void() ImpulseCommands =
{
	if (self.impulse == IMPULSE_TOSS_WEAPON){
		if( self.weaponstate == WEAPON_READY){
			q2_tossWeapon();
		}
		self.impulse = 0;
	}
	
	if (self.impulse >= IMPULSE_USE_WEAPON1 && self.impulse <= IMPULSE_USE_WEAPON11)
	{
			W_ImpulseChangeWeapon();
	}

	if (self.impulse == IMPULSE_WEAPON_NEXT)
	{
		if(self.weaponstate == WEAPON_READY)
			CycleWeaponNext();
	}
	if (self.impulse == IMPULSE_WEAPON_PREV)
	{
		if(self.weaponstate == WEAPON_READY)
			CycleWeaponPrev();
	}
	
	if (self.impulse == IMPULSE_ITEM_NEXT)
	{
			CycleItemNext();
	}
	if (self.impulse == IMPULSE_ITEM_PREV)
	{
			CycleItemPrev();
	}
	
	if (self.impulse == IMPULSE_USE_ITEM)
	{
			UseInventoryItem();
	}

	if (self.impulse == IMPULSE_SKIN_NEXT)
	{
			CycleSkinNext();
	}

#ifdef debug
// cheat impulses are only active in debug mode - which should never be on in live server / released game code. MrC: But where's the fun in that!?
	if (self.impulse == IMPULSE_CHEAT_CMD)
		CheatCommand ();
	if (self.impulse == IMPULSE_SVFLAGS_CMD)
		ServerflagsCommand ();
	if (self.impulse == 999){
		bprint ("Current camera position: ");
		bprint (vtos (self.origin));
		bprint ("\n");
	}
	if (self.impulse == IMPULSE_CHEAT_QUAD)
		QuadCheat ();
#endif

	if(self.impulse == IMPULSE_FLIP){
		if (self.flags & FL_DUCKED){
			return;
		}
		
		sprint (self, "FLIP OFF\n");
		q2player_flip();
	}

	if(self.impulse == IMPULSE_SALUTE){
		if (self.flags & FL_DUCKED){
			return;
		}

		sprint (self, "SALUTE\n");		
		q2player_salute();
	}
	
	if(self.impulse == IMPULSE_TAUNT){
		if (self.flags & FL_DUCKED){
			return;
		}

		sprint (self, "TAUNT\n");		
		q2player_taunt();
	}

	if(self.impulse == IMPULSE_WAVE){
		if (self.flags & FL_DUCKED){
			
			if (coop)
			{
				q2player_ping("models/mapobjects/hub/stroggos_system/logo_strogg.MD3", 0, 0.1);
				self.impulse = 0;
			}
			return;
		}

		if (coop)
		{
			q2player_ping("models/mapobjects/hub/stroggos_system/logo_strogg.MD3", 0, 0.1);
		}

		sprint (self, "WAVE\n");
		q2player_wave();
	}

	if(self.impulse == IMPULSE_POINT){
		if (self.flags & FL_DUCKED){
			
			if (coop)
			{
				q2player_ping_point("models/mapobjects/hub/stroggos_system/logo_strogg.MD3", 0, 0.1);
				self.impulse = 0;
			}
			return;
		}

		if (coop)
		{
			q2player_ping_point("models/mapobjects/hub/stroggos_system/logo_strogg.MD3", 0, 0.1);
		}

		sprint (self, "POINT\n");		
		q2player_point();
	}
	
	if(self.impulse == IMPULSE_SETPLAYERMALE){
		if (self.flags & FL_DUCKED){
			return;
		}

		if (deathmatch || coop)
		{
			return;
		}

		self.playerType = PT_MALE;
		setPlayerModel(self);
	}

	if(self.impulse == IMPULSE_SETPLAYERFEMALE){
		if (self.flags & FL_DUCKED){
			return;
		}

		if (deathmatch || coop)
		{
			return;
		}

		self.playerType = PT_FEMALE;
		setPlayerModel(self);
	}

	if(self.impulse == IMPULSE_SETPLAYERCYBORG){
		if (self.flags & FL_DUCKED){
			return;
		}

		if (deathmatch || coop)
		{
			return;
		}

		self.playerType = PT_OTHER;
		setPlayerModel(self);
	}	

	self.impulse = 0;
};

/*
============
W_WeaponFrame

Called every frame so impulse events can be handled as well as possible
============
*/
void() W_WeaponFrame =
{
	//if (time < self.attack_finished)
		//return;
	
#ifdef opgrade
	if (self.impulse)
#endif
		ImpulseCommands ();
	
	// check for attack
	if(self.weaponstate == WEAPON_READY || time > self.attack_finished){
		if (self.button0)
		{
			self.state = STATE_ATTACKING;
			SuperDamageSound ();
	//		Q3Surface_Impact(self.cursor_trace_endpos);
	//		T_Damage (self.cursor_trace_ent, self, self, 40);
	//		VLOG(self.cursor_trace_endpos);
			W_Attack ();
		}
	}
	
	if (self.button3 && self.weapon == WEP_RAILGUN){
		self.viewzoom = 0.15;
	}
	else{
		self.viewzoom = 1.0;
	}
};

/*
========
SuperDamageSound

Plays sound if needed
========
*/
void() SuperDamageSound =
{
	if (self.super_damage_finished > time)
	{
		if (self.super_sound < time)
		{
			self.super_sound = time + 1;
			sound (self, CHAN_BODY, "items/damage3.wav", 1, ATTN_NORM);
		}
	}
//	return;
};

