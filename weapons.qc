/*
===============================================================================

PLAYER WEAPON USE

===============================================================================
*/

void() W_SetDefaultFrames;
void() W_Draw;
void() q2player_run;

void() W_SetCurrentAmmo =
{
// idea: check frame set & only do for fire frames
	q2player_run ();		// get out of any weapon firing states

	self.items = self.items - ( self.items & (IT_SHELLS | IT_BULLETS | IT_ROCKETS | IT_CELLS) );
//	self.weaponframe = 0; // this always happens

	if (self.weapon == WEP_BLASTER)
	{
		self.currentammo = 0;
	}
	else if (self.weapon == WEP_SHOTGUN)
	{
		self.currentammo = self.ammo_shells;
		self.items = self.items | IT_SHELLS;
	}
	else if (self.weapon == WEP_SUPERSHOTGUN)
	{
		self.currentammo = self.ammo_shells;
		self.items = self.items | IT_SHELLS;
	}
	else if (self.weapon == WEP_MACHINEGUN)
	{
		self.currentammo = self.inv_ammo_bullets;
		self.items = self.items | IT_BULLETS;
	}
	else if (self.weapon == WEP_CHAINGUN)
	{
		self.currentammo = self.inv_ammo_bullets;
		self.items = self.items | IT_BULLETS;
	}
	else if (self.weapon == WEP_GRENADE_LAUNCHER)
	{
		self.currentammo = self.ammo_rockets;
		self.items = self.items | IT_ROCKETS;
	}
	else if (self.weapon == WEP_ROCKET_LAUNCHER)
	{
		self.currentammo = self.ammo_rockets;
		self.items = self.items | IT_ROCKETS;
	}
	else if (self.weapon == WEP_HYPERBLASTER)
	{
		self.currentammo = self.ammo_cells;
		self.items = self.items | IT_CELLS;
	}
	else if (self.weapon == WEP_RAILGUN)
	{
		self.currentammo = self.ammo_cells;
		self.items = self.items | IT_CELLS;
	}
	else if (self.weapon == WEP_BFG)
	{
		self.currentammo = self.ammo_cells;
		self.items = self.items | IT_CELLS;
	}
	else
	{
		self.currentammo = 0;
	}
};

float() W_BestWeapon =
{
	local	float	it;
	
	it = self.inv_weapons;

	if (self.ammo_cells >= 1 && (it & WEP_BFG) )
			return WEP_BFG;
	if (self.ammo_cells >= 1 && (it & WEP_RAILGUN) )
			return WEP_RAILGUN;
	if (self.ammo_cells >= 1 && (it & WEP_HYPERBLASTER) )
			return WEP_HYPERBLASTER;
	if(self.inv_ammo_bullets >= 2 && (it & WEP_CHAINGUN) )
		return WEP_CHAINGUN;
	if(self.ammo_shells >= 2 && (it & WEP_SUPERSHOTGUN) )
		return WEP_SUPERSHOTGUN;
	if(self.inv_ammo_bullets >= 1 && (it & WEP_MACHINEGUN) )
		return WEP_MACHINEGUN;
	if(self.ammo_shells >= 1 && (it & WEP_SHOTGUN) )
		return WEP_SHOTGUN;
	return WEP_BLASTER;
};

float() W_CheckNoAmmo =
{
  //lead with this
	if (self.weapon == WEP_BLASTER)
		return TRUE;
  
	if (self.currentammo > 0)
		return TRUE;
	
	self.weapon_next = W_BestWeapon ();
  self.weaponstate_next = WEAPON_DROPPING;
  
// drop the weapon down
#ifdef pointless_warning
	return FALSE;
#endifdef
};

/*
============
W_Attack

An attack impulse can be triggered now
============
*/
void()	q2player_MGattackframes;
void()	q2player_CGattackframes;
void()	q2player_4attackframes;
void()	q2player_8attackframes;
void()	q2playeronly_8attackframes;
void()	q2playeronly_4attackframes;
void()	q2player_HBattackframes;
void()	q2player_4drawframes;

/*
============
Quake 2 uses the same 8 attack frames for the player, synced across 
third person and first person weapon frames and player animation.

The first 4 are the firing of the weapon and the next 4 are the gun cocking. 
Weapons like the blaster only use the first 4 while almost every other weapon 
uses the full 8 frames.

void()	q2player_4attackframes;
void()	q2player_8attackframes;

============
*/

void() W_Draw =
{
	local	float	r;

	if (!W_CheckNoAmmo ())
		return;

	self.weaponframe = 0;
	self.weaponstate = WEAPON_ACTIVATING;

	if (self.weapon == WEP_BLASTER)
	{
		sound(self, CHAN_WEAPON, "weapons/HGRENT1A.WAV", 0.5, ATTN_IDLE);		
		q2player_4drawframes ();
	//	self.attack_finished = time + 0.4;
	}
	else if (self.weapon == WEP_SHOTGUN)
	{
		sound(self, CHAN_WEAPON, "weapons/Shotgr1b.wav", 0.5, ATTN_IDLE);	
		q2player_4drawframes ();
	//	self.attack_finished = time + 0.6;
	}
	else if (self.weapon == WEP_SUPERSHOTGUN)
	{
		sound(self, CHAN_WEAPON, "weapons/HGRENT1A.WAV", 0.5, ATTN_IDLE);	
		q2player_4drawframes ();
	//	self.attack_finished = time + 0.4;
	}
	else if (self.weapon == WEP_MACHINEGUN)
	{
		sound(self, CHAN_WEAPON, "weapons/HGRENT1A.WAV", 0.5, ATTN_IDLE);	
		q2player_4drawframes ();
	//	self.attack_finished = time + 0.4;
	}
	else if (self.weapon == WEP_CHAINGUN)
	{
		sound(self, CHAN_WEAPON, "weapons/HGRENT1A.WAV", 0.5, ATTN_IDLE);	
		q2player_4drawframes ();
	//	self.attack_finished = time + 0.4;
	}
	else if (self.weapon == WEP_GRENADE_LAUNCHER)
	{
		sound(self, CHAN_WEAPON, "weapons/HGRENT1A.WAV", 0.5, ATTN_IDLE);	
		q2player_4drawframes ();
	//	self.attack_finished = time + 0.9;
	}
	else if (self.weapon == WEP_ROCKET_LAUNCHER)
	{
		sound(self, CHAN_WEAPON, "weapons/HGRENT1A.WAV", 0.5, ATTN_IDLE);	
		q2player_4drawframes ();
	//	self.attack_finished = time + 0.9;
	}
	else if (self.weapon == WEP_HYPERBLASTER)
	{
		sound(self, CHAN_WEAPON, "weapons/HGRENT1A.WAV", 0.5, ATTN_IDLE);	
		q2player_4drawframes ();
	//	self.attack_finished = time + 0.9;
	}
	else if (self.weapon == WEP_RAILGUN)
	{
		sound(self, CHAN_WEAPON, "weapons/HGRENT1A.WAV", 0.5, ATTN_IDLE);	
		q2player_4drawframes ();
	//	self.attack_finished = time + 0.9;
	}
	else if (self.weapon == WEP_BFG)
	{
		sound(self, CHAN_WEAPON, "weapons/HGRENT1A.WAV", 0.5, ATTN_IDLE);	
		q2player_4drawframes ();
	//	self.attack_finished = time + 0.9;
	}
};

void() W_Attack =
{
	local	float	r;

	if (!W_CheckNoAmmo ())
		return;
  
  if(self.weaponstate == WEAPON_FIRING){
    return;
  }
	makevectors	(self.v_angle);			// calculate forward angle for velocity
	self.show_hostile = time + 1;	// wake monsters up
	
  //immediate interrupt
  self.weaponstate =  self.weaponstate_next = WEAPON_FIRING;
  self.weapon_anim_start = TRUE;
  
	switch (self.weapon)
	{		
		case WEP_BLASTER:
			W_FireBlaster();
			self.attack_finished = time + WEP_BLASTER_ATTACKTIME;
			break;
		case WEP_SHOTGUN:
			W_FireShotgun ();
			self.attack_finished = time + WEP_SHOTGUN_ATTACKTIME;
			break;
		case WEP_SUPERSHOTGUN:
			W_FireSuperShotgun ();
			self.attack_finished = time + WEP_SUPERSHOTGUN_ATTACKTIME;
			break;
		case WEP_MACHINEGUN:
			self.attack_finished = time + WEP_MACHINEGUN_ATTACKTIME;
			break;
		case WEP_CHAINGUN:
			self.state = STATE_ATTACKING;
			self.attack_finished = time + WEP_CHAINGUN_ATTACKTIME;
			break;
		case WEP_GRENADE_LAUNCHER:
			W_FireGrenade();
			self.attack_finished = time + WEP_GRENADE_LAUNCHER_ATTACKTIME;
			break;
		case WEP_ROCKET_LAUNCHER:
			W_FireRocket();
			self.attack_finished = time + WEP_ROCKET_LAUNCHER_ATTACKTIME;
			break;
		case WEP_HYPERBLASTER:
			W_FireBlaster();
			self.attack_finished = time + WEP_HYPERBLASTER_ATTACKTIME;
			break;
		case WEP_RAILGUN:
			FireBullet();
			self.attack_finished = time + WEP_RAILGUN_ATTACKTIME;
			break;
		case WEP_BFG:
			self.weaponframe = 9;
			self.attack_finished = time + WEP_BFG_ATTACKTIME;
			break;
	}
};

void() W_Attack2 =
{
	local	float	r;

	if (!W_CheckNoAmmo ())
		return;

	makevectors	(self.v_angle);			// calculate forward angle for velocity
	self.show_hostile = time + 1;	// wake monsters up
	self.weaponstate = WEAPON_FIRING;
	
	switch (self.weapon)
	{
/*		
		case WEP_BLASTER:
			q2player_4attackframes ();
			W_FireBlaster();
			self.attack_finished = time + WEP_BLASTER_ATTACKTIME;
			break;
*/
		case WEP_SHOTGUN:
			q2player_8attackframes ();
			W_FireShotgun ();
			self.attack_finished = time + WEP_SHOTGUN_ATTACKTIME;
			break;
		case WEP_SUPERSHOTGUN:
			q2player_8attackframes ();
			W_FireSuperShotgun ();
			self.attack_finished = time + WEP_SUPERSHOTGUN_ATTACKTIME;
			break;
/*
		case WEP_MACHINEGUN:
			q2player_MGattackframes();
			self.attack_finished = time + WEP_MACHINEGUN_ATTACKTIME;
			break;
		case WEP_CHAINGUN:
			self.state = STATE_ATTACKING;
			q2player_CGattackframes();
			self.attack_finished = time + WEP_CHAINGUN_ATTACKTIME;
			break;
*/
		case WEP_GRENADE_LAUNCHER:
			q2player_8attackframes ();
			W_FireGrenade();
			self.attack_finished = time + WEP_GRENADE_LAUNCHER_ATTACKTIME;
			break;
		case WEP_ROCKET_LAUNCHER:
			q2player_8attackframes ();
			W_FireRocket();
			self.attack_finished = time + WEP_ROCKET_LAUNCHER_ATTACKTIME;
			break;
		case WEP_HYPERBLASTER:
			W_FireBlaster();
			q2player_HBattackframes ();
			self.attack_finished = time + WEP_HYPERBLASTER_ATTACKTIME;
			break;
/*		case WEP_RAILGUN:
			q2player_8attackframes ();
			FireBullet();
			self.attack_finished = time + WEP_RAILGUN_ATTACKTIME;
			break;
		case WEP_BFG:
			self.weaponframe = 9;
			q2playeronly_8attackframes ();
			self.attack_finished = time + WEP_BFG_ATTACKTIME;
			break;
*/
	}
};

/*
============
W_ChangeWeapon

============
*/
void() CycleWeaponCommand;

void() W_ChangeWeapon =
{
	switch (self.impulse)
	{
		case IMPULSE_USE_WEAPON1:
			self.weapon_next = WEP_BLASTER;
			break;
		case IMPULSE_USE_WEAPON2:
			self.weapon_next = WEP_SHOTGUN;
			break;
		case IMPULSE_USE_WEAPON3:
			self.weapon_next = WEP_SUPERSHOTGUN;
			break;
		case IMPULSE_USE_WEAPON4:
			self.weapon_next = WEP_MACHINEGUN;
			break;
		case IMPULSE_USE_WEAPON5:
			self.weapon_next = WEP_CHAINGUN;
			break;
		case IMPULSE_USE_WEAPON6:
			self.weapon_next = WEP_GRENADE_LAUNCHER;
			break;
		case IMPULSE_USE_WEAPON7:
			self.weapon_next = WEP_ROCKET_LAUNCHER;
			break;
		case IMPULSE_USE_WEAPON8:
			self.weapon_next = WEP_HYPERBLASTER;
			break;
		case IMPULSE_USE_WEAPON9:
			self.weapon_next = WEP_RAILGUN;
			break;
		case IMPULSE_USE_WEAPON10:
			self.weapon_next = WEP_BFG;
			break;
	}
  
  if(self.weapon == self.weapon_next){
    //same weapon pressed, do nothing.
    return;
  }

	self.f__ = 1; // so logic doesnt change weapon
// use logic test here
  //only need a cycle check for ammo-using weapons.
	if(self.weapon_next == WEP_BLASTER){
    self.impulse = 0; //auto-success because blaster is always on-hand, and has infinite ammo.
  }
  else{
    CycleWeaponCommand();
  }

// failed
	if (self.impulse)
	{
		self.impulse = 0;

		if (!(self.items & self.weapon_next))
// don't have the weapon
			sprint (self, "no weapon.\n");
		else
//  or the ammo				- this is an either or fail, so if its not no wep, it must be this
			sprint (self, "not enough ammo.\n");

// we were here
		return;	
	}
	
  if(self.weaponstate != WEAPON_SPINDOWN){
    self.weaponstate_next = WEAPON_DROPPING;
  }
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

	self.ammo_rockets = 100;
	self.inv_ammo_bullets = 200;
	self.ammo_shells = 100;
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

	self.ammo_cells = 200;

	self.weapon = WEP_BFG;
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
		if (self.weapon_next == WEP_BFG && self.ammo_cells < 1) am = 1;
		if (self.weapon_next == WEP_RAILGUN && self.ammo_cells < 1) am = 1;
		if (self.weapon_next == WEP_HYPERBLASTER && self.ammo_cells < 1) am = 1;
		if (self.weapon_next == WEP_ROCKET_LAUNCHER && self.ammo_rockets < 1) am = 1;
		if (self.weapon_next == WEP_GRENADE_LAUNCHER && self.ammo_rockets < 1) am = 1;
		if (self.weapon_next == WEP_CHAINGUN && self.inv_ammo_bullets < 2) am = 1;
		if (self.weapon_next == WEP_MACHINEGUN && self.inv_ammo_bullets < 1) am = 1;
		if (self.weapon_next == WEP_SUPERSHOTGUN && self.ammo_shells < 2) am = 1;
		if (self.weapon_next == WEP_SHOTGUN && self.ammo_shells < 1) am = 1;
	
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
//	local	float	it, am;
	local	float	am;
	
//	it = self.items;
	self.impulse = 0;

	while (1)
	{
		am = 0;

		if (self.weapon == WEP_BFG)
		{
			self.weapon_next = WEP_BLASTER;
		}
		else if (self.weapon == WEP_BLASTER)
		{
			self.weapon_next = WEP_SHOTGUN;
			if (self.ammo_shells < 1)
				am = 1;
		}
		else if (self.weapon == WEP_SHOTGUN)
		{
			self.weapon_next = WEP_SUPERSHOTGUN;
			if (self.ammo_shells < 2)
				am = 1;
		}               
		else if (self.weapon == WEP_SUPERSHOTGUN)
		{
			self.weapon_next = WEP_MACHINEGUN;
			if (self.inv_ammo_bullets < 1)
				am = 1;
		}
		else if (self.weapon == WEP_MACHINEGUN)
		{
			self.weapon_next = WEP_CHAINGUN;
			if (self.inv_ammo_bullets < 1)
				am = 1;
		}
		else if (self.weapon == WEP_CHAINGUN)
		{
			self.weapon_next = WEP_GRENADE_LAUNCHER;
			if (self.ammo_rockets < 1)
				am = 1;
		}
		else if (self.weapon == WEP_GRENADE_LAUNCHER)
		{
			self.weapon_next = WEP_ROCKET_LAUNCHER;
			if (self.ammo_rockets < 1)
				am = 1;
		}
		else if (self.weapon == WEP_ROCKET_LAUNCHER)
		{
			self.weapon_next = WEP_HYPERBLASTER;
			if (self.ammo_cells < 1)
				am = 1;
		}
		else if (self.weapon == WEP_HYPERBLASTER)
		{
			self.weapon_next = WEP_RAILGUN;
			if (self.ammo_cells < 1)
				am = 1;
		}
		else if (self.weapon == WEP_RAILGUN)
		{
			self.weapon_next = WEP_BFG;
			if (self.ammo_cells < 1)
				am = 1;
		}
	
		if ( (self.inv_weapons & self.weapon_next) && am == 0)
		{
			//W_SetCurrentAmmo ();
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
//	local	float	it, am;
	local	float	am;
	
//	it = self.items;
	self.impulse = 0;

	while (1)
	{
		am = 0;
		
		if (self.weapon == WEP_BFG)
		{
			self.weapon_next = WEP_RAILGUN;
			if (self.ammo_cells < 1)
				am = 1;
		}
		else if (self.weapon == WEP_RAILGUN)
		{
			self.weapon_next = WEP_HYPERBLASTER;
			if (self.ammo_cells < 1)
				am = 1;
		}
		else if (self.weapon == WEP_HYPERBLASTER)
		{
			self.weapon_next = WEP_ROCKET_LAUNCHER;
			if (self.ammo_rockets < 1)
				am = 1;
		}
		else if (self.weapon == WEP_ROCKET_LAUNCHER)
		{
			self.weapon_next = WEP_GRENADE_LAUNCHER;
			if (self.ammo_rockets < 1)
				am = 1;
		}
		else if (self.weapon == WEP_GRENADE_LAUNCHER)
		{
			self.weapon_next = WEP_CHAINGUN;
			if (self.inv_ammo_bullets < 1)
				am = 1;
		}
		else if (self.weapon == WEP_CHAINGUN)
		{
			self.weapon_next = WEP_MACHINEGUN;
			if (self.inv_ammo_bullets < 1)
				am = 1;
		}
		else if (self.weapon == WEP_MACHINEGUN)
		{
			self.weapon_next = WEP_SUPERSHOTGUN;
			if (self.ammo_shells < 2)
				am = 1;
		}		
		else if (self.weapon == WEP_SUPERSHOTGUN)
		{
			self.weapon_next = WEP_SHOTGUN;
			if (self.ammo_shells < 1)
				am = 1;
		}
		else if (self.weapon == WEP_SHOTGUN)
		{
			self.weapon_next = WEP_BLASTER;
		}
		else if (self.weapon == WEP_BLASTER)
		{
			self.weapon_next = WEP_BFG;
			if (self.ammo_cells < 1)
				am = 1;
		}
	
		if ( (self.inv_weapons & self.weapon_next) && am == 0)
		{
			//W_SetCurrentAmmo ();
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
		q2_tossWeapon();
    self.weaponstate = 0;
    self.weaponstate_next = WEAPON_ACTIVATING;
    self.weapon_next = W_BestWeapon();
	}
	
	if (self.impulse >= IMPULSE_USE_WEAPON1 && self.impulse <= IMPULSE_USE_WEAPON10)
	{
		if (self.weaponstate == WEAPON_SPINDOWN)
		{
			self.weaponstate = WEAPON_READY;
			sound (self, CHAN_WEAPON, "weapons/noammo.wav", 0.1, ATTN_NORM);
			sound (self, CHAN_WEAPON2, "weapons/noammo.wav", 0.1, ATTN_NORM);
			W_ChangeWeapon ();
		}
		else
		{
			W_ChangeWeapon ();
		}
	}

	if (self.impulse == IMPULSE_WEAPON_NEXT)
	{
    CycleWeaponNext();
	
	}
	if (self.impulse == IMPULSE_WEAPON_PREV)
	{
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

// "Inspired" by Quake 2 ;D ... Semi-ported version below.
// MrC: I also come here too and ponder what the hell I'm thinking!?

void (float FRAME_ACTIVATE_LAST, float FRAME_FIRE_LAST, float FRAME_IDLE_FIRST, float FRAME_IDLE_LAST) Weapon_Generic_Idle =
{
	local float r = random();

	if (time < self.nextframetime)
		return;
	
	if (self.state == STATE_ATTACKING)
	{
		if (self.weaponstate == WEAPON_SPINDOWN || WEAPON_FIRING)
		{
			self.idletime = time;
			return;
		}
		else
		{
			self.idletime = time + 5 + random() * 2;
			return;
		}
		/*
		if (self.weaponstate == WEAPON_FIRING)
		{
			if (self.weapon == WEP_BFG){		
				switch (self.weaponframe)
				{
				case 18:
					W_fireBFG();
					sound (self, CHAN_WEAPON, "weapons/hyprbd1a.wav", 1, ATTN_NORM);
				break;
				case FRAME_FIRE_LAST:
					self.weaponstate = WEAPON_READY;
					self.weaponframe = FRAME_IDLE_FIRST;
					self.idletime = time + 5 + random() * 2;
				break;
				}
			}
		}
		*/
		return;
	}
	

/*	
	if (self.state == STATE_ATTACKING)
	{
		//Stuff in W_Attack can probably go here.
		//NO IDLETIME IF SPINDOWN
		if (self.weaponstate == WEAPON_SPINDOWN)
		{
			self.idletime = time;
			return;
		}
		else
		{
			self.idletime = time + 5 + random() * 2;
			return;
		}
	}
*/
	
	if (self.weaponstate == WEAPON_ACTIVATING)
	{
		/*
		switch (self.weaponframe)
		{
		case 12:
			sound (self, CHAN_WEAPON2, "weapons/hyprbd1a.wav", 1, ATTN_NORM);
			break;
		case 20:
			sound(self, CHAN_WEAPON, "weapons/Hyprbu1a.wav", 0.5, ATTN_IDLE);
			self.weaponstate = WEAPON_READY;
			break;
		}
		*/
		if (self.weaponframe == FRAME_ACTIVATE_LAST)
		{
			self.weaponstate = WEAPON_READY;
			self.weaponframe = FRAME_IDLE_FIRST;
			self.idletime = time + 10 + random() * 5;
			return;
		}
		
		self.nextframetime = time + 0.05;
		self.weaponframe++;
		return;
	}	

	if (self.state == STATE_RUNNING)
	{
		if (self.weaponstate == WEAPON_SPINDOWN && self.weapon == WEP_HYPERBLASTER)
		{
			self.idletime = time;
//			bprint ("Running attacking HyperBlaster!");
//			bprint ("\n");
			
			switch (self.weaponframe)
			{
			case 12:
				sound (self, CHAN_WEAPON2, "weapons/hyprbd1a.wav", 1, ATTN_NORM);
				break;
			case 20:
				sound(self, CHAN_WEAPON, "weapons/Hyprbu1a.wav", 0.5, ATTN_IDLE);
				self.weaponstate = WEAPON_READY;
				break;
			}
			
		}
		else if (self.weaponstate == WEAPON_SPINDOWN && self.weapon == WEP_CHAINGUN)
		{
			self.idletime = time;
//			bprint ("Running attacking Chaingun!");
//			bprint ("\n");
			
			switch (self.weaponframe)
			{
			case 22:
				sound (self, CHAN_WEAPON2, "weapons/noammo.wav", 0.1, ATTN_NORM);
				sound(self, CHAN_WEAPON, "weapons/chngnd1a.wav", 0.5, ATTN_IDLE);
				break;
			case 31:
				self.weaponstate = WEAPON_READY;
				break;
			}
		}
		else if (self.state == STATE_ATTACKING)
		{
			return;
		}
		else
		{
			if (self.weaponstate == WEAPON_FIRING)
			{
	
				if (self.weapon == WEP_BFG)
				{		
					switch (self.weaponframe)
					{
					case 9:
						sound (self, CHAN_WEAPON, "weapons/Bfg__f1y.wav", 1, ATTN_NORM);
					break;
					case 18:
						W_fireBFG();
					break;
					case FRAME_FIRE_LAST:
						self.weaponstate = WEAPON_READY;
						self.weaponframe = FRAME_IDLE_FIRST;
						self.idletime = time + 5 + random() * 2;
					break;
					}
				}
			self.weaponframe++;
			self.nextframetime = time + 0.135;
			return;
			}
		self.weaponframe = FRAME_IDLE_FIRST;
		self.idletime = time + 10 + random() * 5;
		/*
		self.idletime = time;
			
			if (self.weaponframe >= FRAME_IDLE_LAST)
			{
				if (r < 0.75){
				self.animIdle = 1;
			}
			else{
				self.animIdle = 0;
			}
			
			self.weaponframe = FRAME_IDLE_FIRST;
			self.idletime = time + 3 + random() * 2;
			return;
			}
		*/
		return;
		}
	}

	if (self.state == STATE_IDLE) // && self.weaponstate == WEAPON_READY)
	{
		if (time < self.idletime)
			return;

		if (self.weaponstate == WEAPON_SPINDOWN && self.weapon == WEP_HYPERBLASTER)
		{
			self.idletime = time;
//			bprint ("Done attacking HyperBlaster!");
//			bprint ("\n");
						
			switch (self.weaponframe)
			{
			case 12:
				sound (self, CHAN_WEAPON2, "weapons/hyprbd1a.wav", 1, ATTN_NORM);
				break;
			case 20:
				sound(self, CHAN_WEAPON, "weapons/Hyprbu1a.wav", 0.5, ATTN_IDLE);
				self.weaponstate = WEAPON_READY;
				break;
			}
		}
		else if (self.weaponstate == WEAPON_SPINDOWN && self.weapon == WEP_CHAINGUN)
		{
			self.idletime = time;
//			bprint ("Idle attacking Chaingun!");
//			bprint ("\n");

			switch (self.weaponframe)
			{
			case 22:
				sound (self, CHAN_WEAPON2, "weapons/noammo.wav", 0.1, ATTN_NORM);
				sound(self, CHAN_WEAPON, "weapons/chngnd1a.wav", 0.5, ATTN_IDLE);
				break;
			case 31:
				self.weaponstate = WEAPON_READY;
				break;
			}
		}
		
		if (self.weaponstate == WEAPON_FIRING)
		{
			if (self.weapon == WEP_BFG){		
				switch (self.weaponframe)
				{
				case 9:
					sound (self, CHAN_WEAPON, "weapons/Bfg__f1y.wav", 1, ATTN_NORM);
				break;
				case 18:
					W_fireBFG();
				break;
				case FRAME_FIRE_LAST:
					self.weaponstate = WEAPON_READY;
					self.weaponframe = FRAME_IDLE_FIRST;
					self.idletime = time + 5 + random() * 2;
				break;
				}
			}
		}
		
		if (self.weaponframe >= FRAME_IDLE_LAST)
		{
			local float r = random();
			if (r < 0.75){
				self.animIdle = 1;
			}
			else{
				self.animIdle = 0;
			}
			
			self.weaponframe = FRAME_IDLE_FIRST;
			self.idletime = time + 3 + random() * 2;
			return;
		}
		
	}
/*
	dprint (ftos(self.nextframetime));
	dprint ("\n");
	dprint ("Idle Fidget Sequence: ");
	dprint (ftos(self.animIdle));
	dprint ("\n");
*/

	self.weaponframe++;
	self.nextframetime = time + 0.135;
}

// Ported from Quake 2

void() doWeaponFrames =
{
		if (self.weapon == WEP_BFG)
		{		
			switch (self.weaponframe)
			{
				case 9:
					sound (self, CHAN_WEAPON, "weapons/Bfg__f1y.wav", 1, ATTN_NORM);
				break;
				case 18:
				q2playeronly_8attackframes ();
				W_fireBFG();
				break;
			}
		}
		
		if (self.weapon == WEP_RAILGUN)
		{		
			switch (self.weaponframe)
			{
				case 5:
					sound (self, CHAN_WEAPON, "weapons/RAILGF1A.WAV", 1, ATTN_NORM);
					q2playeronly_8attackframes ();
					FireBullet(WEAPON_RAILGUN_DAMAGE);
					//fireRail(WEAPON_RAILGUN_DAMAGE);
				break;
			}
		}
		
		if (self.weapon == WEP_HYPERBLASTER)
		{	
			switch (self.weaponframe)
			{
				case 6:
					q2playeronly_4attackframes ();
					W_FireBlaster();
				break;
				case 7:
					W_FireBlaster();
				break;
				case 8:
					W_FireBlaster();
				break;
				case 9:
					W_FireBlaster();
				break;
				case 10:
					W_FireBlaster();
				break;
				case 11:
					W_FireBlaster();
					sound (self, CHAN_WEAPON2, "weapons/Hyprbd1a.wav", 1, ATTN_NORM);
				break;
			}
		}
		
		if (self.weapon == WEP_ROCKET_LAUNCHER)
		{		
			switch (self.weaponframe)
			{
				case 5:
					q2playeronly_8attackframes ();
					W_FireRocket();
				break;
			}
		}
		
		if (self.weapon == WEP_GRENADE_LAUNCHER)
		{		
			switch (self.weaponframe)
			{
				case 7:
					q2playeronly_8attackframes ();
					W_FireGrenade();
				break;
			}
		}
		
		if (self.weapon == WEP_CHAINGUN)
		{		
			switch (self.weaponframe)
			{
				case 7:
					q2playeronly_4attackframes ();
					FireBullet(WEAPON_CHAINGUN_DAMAGE);
				break;
			}
		}
		
		if (self.weapon == WEP_MACHINEGUN)
		{		
			switch (self.weaponframe)
			{
				case 7:
					q2playeronly_4attackframes ();
					FireBullet(WEAPON_CHAINGUN_DAMAGE);
				break;
			}
		}
		
		if (self.weapon == WEP_SUPERSHOTGUN)
		{		
			switch (self.weaponframe)
			{
				case 7:
					q2playeronly_8attackframes ();
					W_FireSuperShotgun();
				break;
			}
		}
		
		if (self.weapon == WEP_SHOTGUN)
		{		
			switch (self.weaponframe)
			{
				case 8:
					q2playeronly_8attackframes ();
					W_FireShotgun();
				break;
			}
		}
		
		if (self.weapon == WEP_BLASTER)
		{		
			switch (self.weaponframe)
			{
				case 5:
					q2playeronly_4attackframes();
					W_FireBlaster();
				break;
			}
		}
}

float hyperblaster_fire_frames[] = {6, 7, 8, 9, 10, 11};

void Weapon_Generic (float FRAME_ACTIVATE_LAST, float FRAME_FIRE_LAST, float FRAME_IDLE_LAST, float FRAME_DEACTIVATE_LAST)
{
	local float n;
	local float FRAME_FIRE_FIRST = FRAME_ACTIVATE_LAST + 1;
	local float FRAME_IDLE_FIRST = FRAME_FIRE_LAST + 1;
	local float FRAME_DEACTIVATE_FIRST = FRAME_IDLE_LAST + 1;
	
	if (time < self.nextframetime)
		return;
	
	if(self.deadflag) // VWep animations screw up corpses
	{
		return;
	}

	if (self.weaponstate == WEAPON_DROPPING)
	{
		if (self.weaponframe == FRAME_DEACTIVATE_LAST)
		{
			self.weapon = W_BestWeapon ();
			return;
		}
		else if ((FRAME_DEACTIVATE_LAST - self.weaponframe) == 4)
		{
			self.anim_priority = ANIM_REVERSE;
			if(self.flags & FL_DUCKED)
			{
			//	self.walkframe = FRAME_crpain4+1;
			//	self.anim_end = FRAME_crpain1;
			}
			else
			{
			//	self.walkframe = FRAME_pain304+1;
			//	self.anim_end = FRAME_pain301;
			}
		}
		self.weaponframe++;
		return;
	}

	if (self.weaponstate == WEAPON_ACTIVATING)
	{
		if (self.weaponframe == FRAME_ACTIVATE_LAST)
		{
			self.weaponstate = WEAPON_READY;
			self.weaponframe = FRAME_IDLE_FIRST;
			return;
		}
		self.nextframetime = time + 0.1;
		self.weaponframe++;
		return;
	}

	//if ((newweapon()) && (self.weaponstate != WEAPON_FIRING)) //MrC: float check new weapon?
/*	if (self.weaponstate != WEAPON_FIRING)
	{
		self.weaponstate = WEAPON_DROPPING;
		self.weaponframe = FRAME_DEACTIVATE_FIRST;

		if ((FRAME_DEACTIVATE_LAST - FRAME_DEACTIVATE_FIRST) < 4)
		{
			self.anim_priority = ANIM_REVERSE;
			if(self.flags & FL_DUCKED)
			{
			//	self.walkframe = FRAME_crpain4+1;
			//	self.anim_end = FRAME_crpain1;
			}
			else
			{
			//	self.walkframe = FRAME_pain304+1;
			//	self.anim_end = FRAME_pain301;
			}
		}
		return;
	}
*/
	if (self.weaponstate == WEAPON_READY)
	{
		//if ( ((ent->client->latched_buttons|ent->client->buttons) & BUTTON_ATTACK) )
		if (self.button0)
		{
			//ent->client->latched_buttons &= ~BUTTON_ATTACK;
			//if ((!ent->client->ammo_index) || ( ent->client->pers.inventory[ent->client->ammo_index] >= ent->client->pers.weapon->quantity))
			if (W_CheckNoAmmo ())
			{
				self.weaponframe = FRAME_FIRE_FIRST;
				self.weaponstate = WEAPON_FIRING;
				
				// start the animation
				self.anim_priority = ANIM_ATTACK;
				if (self.flags & FL_DUCKED)
				{
				//	self.walkframe = FRAME_crattak1-1;
				//	self.anim_end = FRAME_crattak9;
				}
				else
				{
				//	self.walkframe = FRAME_attack1-1;
				//	self.anim_end = FRAME_attack8;
				}
			}
/*			else
			{
				if (time >= self.pain_debounce_time)
				{
				//	gi.sound(ent, CHAN_VOICE, gi.soundindex("weapons/noammo.wav"), 1, ATTN_NORM, 0);
					self.pain_debounce_time = time + 1;
				}
				NoAmmoWeaponChange (ent);
			}
*/
		}
		else
		{
			if (self.weaponframe >= FRAME_IDLE_LAST)
			{
				local float r = random();
				if (r < 0.5){
					self.animIdle = 1;
				}
				else{
					self.animIdle = 0;
				}
			
				self.weaponframe = FRAME_IDLE_FIRST;
				return;
			}
			self.nextframetime = time + 0.1;
			self.weaponframe++;
			return;
		}
	}

	if (self.weaponstate == WEAPON_FIRING)
	{
	/*	for (n = 0; fire_frames[n]; n++)
		{
			if (self.weaponframe == fire_frames[n])
			{
				SuperDamageSound();

				// fire (ent); //switch weapon firing stuff
				break;
			}
		}
	
		if (!fire_frames[n])
			self.weaponframe++;
		*/
		//	self.weaponframe++;
			doWeaponFrames();

		if (self.weaponframe == FRAME_IDLE_FIRST+1)
			self.weaponstate = WEAPON_READY;

		self.weaponframe++;
	}
//	self.nextframetime = time + 0.135;
	self.nextframetime = time + 0.1;
}

/*
============
W_WeaponFrame

Called every frame so impulse events can be handled as well as possible
============
*/
void() W_WeaponFrame =
{
	if (time < self.attack_finished)
		return;
	
#ifdef opgrade
	if (self.impulse)
#endifdef
		ImpulseCommands ();
	
	// check for attack
	#ifndef new_weapon_generic
	if (self.button0)
	{
	//	if (self.weaponstate == WEAPON_FIRING)
	//		return;
		
		self.state = STATE_ATTACKING;
		SuperDamageSound ();
		//W_Attack ();
	}
	#endifdef
	
	#ifdef new_weapon_generic
  
	#endifdef
  if (self.button0)
	{
    if(time > self.attack_finished ){
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


