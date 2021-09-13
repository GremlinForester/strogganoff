/*
===============================================================================

PLAYER WEAPON USE

===============================================================================
*/

void() q2player_run;

/*
	W_SetCurrentAmmo
		seemingly called after any	
			W_ChangeWeapon()
			W_BestWeapon()
*/
void() W_SetCurrentAmmo =
{
// idea: check frame set & only do for fire frames
	//q2player_run ();		// get out of any weapon firing states

	//I don't know why Q1 originally did this.
	self.items = self.items - ( self.items & (IT_SHELLS | IT_BULLETS | IT_ROCKETS | IT_CELLS) );
//	self.weaponframe = 0; // this always happens

	switch(self.weapon){
		case WEP_BLASTER:
			self.currentammo = 0;
			break;
			
		case WEP_SHOTGUN:
			self.currentammo = self.inv_ammo_shells;
			self.items = self.items | IT_SHELLS;
			break;
			
		case WEP_SUPERSHOTGUN:
			self.currentammo = self.inv_ammo_shells;
			self.items = self.items | IT_SHELLS;
			break;
			
		case WEP_MACHINEGUN:
			self.currentammo = self.inv_ammo_bullets;
			self.items = self.items | IT_BULLETS;
			break;
			
		case WEP_CHAINGUN:
			self.currentammo = self.inv_ammo_bullets;
			self.items = self.items | IT_BULLETS;
			break;
			
		case WEP_GRENADE_LAUNCHER:
			self.currentammo = self.inv_ammo_rockets;
			self.items = self.items | IT_ROCKETS;
			break;
			
		case WEP_ROCKET_LAUNCHER:
			self.currentammo = self.inv_ammo_rockets;
			self.items = self.items | IT_ROCKETS;
			break;
			
		case WEP_HYPERBLASTER:
			self.currentammo = self.inv_ammo_cells;
			self.items = self.items | IT_CELLS;
			break;
			
		case WEP_RAILGUN:
			self.currentammo = self.inv_ammo_slugs;
			self.items = self.items | IT_CELLS;
			break;
			
		case WEP_BFG:
			self.currentammo = self.inv_ammo_cells;
			self.items = self.items | IT_CELLS;
			break;
		
		default:
			self.currentammo = 0;
			break;
	}
};

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

/*
============
W_Attack

An attack impulse can be triggered now
============
*/

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
	local float r;
	
	//if (!W_CheckNoAmmo ())
		//return;
	
	//if(self.weaponstate == WEAPON_FIRING){
	///  return;
	//}
	makevectors	(self.v_angle);			// calculate forward angle for velocity
	self.show_hostile = time + 1;	// wake monsters up
	
	//immediate interrupt
	//if(self.weaponstate != WEAPON_FIRING){
	//	self.weaponstate_next = WEAPON_FIRING;
	//}
};

/*
============
W_ChangeWeapon
  player chose specific weapon.
============
*/
void() CycleWeaponCommand;

void() W_ImpulseChangeWeapon =
{

  local float wep;
	
	
	if(self.weaponstate != WEAPON_READY){
		self.impulse = 0;	//consume events
		return;
	}
	bprint("W_ChangeWeapon state = ");	//debug
	bprint(ftos(self.weaponstate));	//debug
	bprint("\n");	//debug
		
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
	bprint("\n W_ImpulseChangeWeapon()->wep = ");	//debug
	bprint(ftos(wep));
	bprint("\n");

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
	if (deathmatch
// note: opgrade has this cheat enabled in coop
#ifndef opgrade
						|| coop
#endifdef
									)		return;

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
	self.items = self.items | 
		IT_KEY1 | IT_KEY2;

	self.impulse = 0;
};

// debug qual
#endifdef

/*
============
CycleWeaponCommand

Go to the next weapon with ammo
============
*/

void() CycleWeaponCommand =
{
	local	float	am;


// note: no loop protection! - this code assumes the player _always_ has an axe
	while (1)
	{
		am = 0;

// since these are bit flags, * 2 selects next and * 0.5 selects previous - for single select set this to 1
//		self.weapon = self.weapon * self.f__;
// weapon select logic
		if (self.weapon_next == WEP_BFG && self.inv_ammo_cells < 1) am = 1;
		if (self.weapon_next == WEP_RAILGUN && self.inv_ammo_slugs < 1) am = 1;
		if (self.weapon_next == WEP_HYPERBLASTER && self.inv_ammo_cells < 1) am = 1;
		if (self.weapon_next == WEP_ROCKET_LAUNCHER && self.inv_ammo_rockets < 1) am = 1;
		if (self.weapon_next == WEP_GRENADE_LAUNCHER && self.inv_ammo_rockets < 1) am = 1;
		if (self.weapon_next == WEP_CHAINGUN && self.inv_ammo_bullets < 2) am = 1;
		if (self.weapon_next == WEP_MACHINEGUN && self.inv_ammo_bullets < 1) am = 1;
		if (self.weapon_next == WEP_SUPERSHOTGUN && self.inv_ammo_shells < 2) am = 1;
		if (self.weapon_next == WEP_SHOTGUN && self.inv_ammo_shells < 1) am = 1;
	
		if ( (self.inv_weapons & self.weapon_next) && ! am)
		{
			self.impulse = 0;
			self.weaponstate_next = WEAPON_DROPPING;
			return;
		}
// dont cycle single select
		if (self.impulse <= IMPULSE_USE_WEAPON10) 
			return;
	}
};

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
ServerflagsCommand

Just for development
============
*/
#ifdef debug

void() ServerflagsCommand =
{
// opgrade blocks this cheat in DM - which only affects the start hub 4 rune floor gate
#ifdef opgrade
	if (deathmatch)
		return;
#endifdef
	serverflags = serverflags * 2 + 1;
};

void() QuadCheat =
{
	if (deathmatch
// note: opgrade has this cheat enabled in coop
#ifndef opgrade
						|| coop
#endifdef
									)		return;
	self.super_time = 1;
	self.super_damage_finished = time + 30;
	self.items = self.items | IT_QUAD;
#ifndef nodprint
	dprint ("quad cheat\n");
#endifdef
};

// debug qual
#endifdef

/*
============
ImpulseCommands

============
*/

void() ImpulseCommands =
{
	if (self.impulse == IMPULSE_TOSS_WEAPON){
		if( self.weaponstate == WEAPON_READY){
			q2_tossWeapon();
		}
		self.impulse = 0;
	}
	
	if (self.impulse >= IMPULSE_USE_WEAPON1 && self.impulse <= IMPULSE_USE_WEAPON10)
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
#endifdef

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
#endifdef
		ImpulseCommands ();
	
	// check for attack
	if(self.weaponstate == WEAPON_READY || time > self.attack_finished){
		if (self.button0)
		{
			self.state = STATE_ATTACKING;
			SuperDamageSound ();
			W_Attack ();
		}
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

