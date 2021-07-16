/*
===============================================================================

PLAYER WEAPON USE

===============================================================================
*/

void() W_SetDefaultFrames;

void() W_Draw;

void() W_SetCurrentAmmo =
{
// idea: check frame set & only do for fire frames
	q2player_run ();		// get out of any weapon firing states

	self.items = self.items - ( self.items & (IT_SHELLS | IT_BULLETS | IT_ROCKETS | IT_CELLS) );
//	self.weaponframe = 0; // this always happens

	if (self.weapon == WEP_BLASTER)
	{
		self.currentammo = 0;
		self.weaponmodel = "models/weapons/v_blast/tris.md2";
//		self.weaponframe = 0;
	}
	else if (self.weapon == WEP_SHOTGUN)
	{
		self.currentammo = self.ammo_shells;
		self.weaponmodel = "models/weapons/v_shotg/tris.md2";
//		self.weaponframe = 9;
		self.items = self.items | IT_SHELLS;
	}
	else if (self.weapon == WEP_SUPERSHOTGUN)
	{
		self.currentammo = self.ammo_shells;
		self.weaponmodel = "models/weapons/v_shotg2/tris.md2";
//		self.weaponframe = 0;
		self.items = self.items | IT_SHELLS;
	}
	else if (self.weapon == WEP_MACHINEGUN)
	{
		self.currentammo = self.inv_ammo_bullets;
		self.weaponmodel = "models/weapons/v_machn/tris.md2";
//		self.weaponframe = 0;
		self.items = self.items | IT_BULLETS;
	}
	else if (self.weapon == WEP_CHAINGUN)
	{
		self.currentammo = self.inv_ammo_bullets;
		self.weaponmodel = "models/weapons/v_chain/tris.md2";
//		self.weaponframe = 0;
		self.items = self.items | IT_BULLETS;
	}
	else if (self.weapon == WEP_GRENADE_LAUNCHER)
	{
		self.currentammo = self.ammo_rockets;
		self.weaponmodel = "models/weapons/v_launch/tris.md2";
//		self.weaponframe = 0;
		self.items = self.items | IT_ROCKETS;
	}
	else if (self.weapon == WEP_ROCKET_LAUNCHER)
	{
		self.currentammo = self.ammo_rockets;
		self.weaponmodel = "models/weapons/v_rocket/tris.md2";
//		self.weaponframe = 0;
		self.items = self.items | IT_ROCKETS;
	}
	else if (self.weapon == WEP_HYPERBLASTER)
	{
		self.currentammo = self.ammo_cells;
		self.weaponmodel = "models/weapons/v_hyperb/tris.md2";
//		self.weaponframe = 0;
		self.items = self.items | IT_CELLS;
	}
	else
	{
		self.currentammo = 0;
		self.weaponmodel = string_null;
//		self.weaponframe = 0;
	}
	
	W_SetDefaultFrames();
};

float() W_BestWeapon =
{
	local	float	it;
	
	it = self.items;

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
	if (self.currentammo > 0)
		return TRUE;

	if (self.weapon == WEP_BLASTER)
		return TRUE;
	
	self.weapon = W_BestWeapon ();

	W_SetCurrentAmmo ();
	
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
};

void() W_Attack =
{
	local	float	r;

	if (!W_CheckNoAmmo ())
		return;

	makevectors	(self.v_angle);			// calculate forward angle for velocity
	self.show_hostile = time + 1;	// wake monsters up

	switch (self.weapon)
	{
		case WEP_BLASTER:
			q2player_4attackframes ();
			W_FireBlaster();
			self.attack_finished = time + 0.4;
			break;
		case WEP_SHOTGUN:
			q2player_8attackframes ();
			W_FireShotgun ();
			self.attack_finished = time + WEP_SHOTGUN_ATTACKTIME;
			break;
		case WEP_SUPERSHOTGUN:
			q2player_8attackframes ();
			W_FireSuperShotgun ();
			self.attack_finished = time + 0.9;
			break;
		case WEP_MACHINEGUN:
			q2player_MGattackframes();
			self.attack_finished = time + 0.15;
			break;
		case WEP_CHAINGUN:
			self.state = STATE_ATTACKING;
			q2player_CGattackframes();
			self.attack_finished = time + 0.05;
			break;
		case WEP_GRENADE_LAUNCHER:
			q2player_8attackframes ();
			W_FireGrenade();
			self.attack_finished = time + 0.8;
			break;
		case WEP_ROCKET_LAUNCHER:
			q2player_8attackframes ();
			W_FireRocket();
			self.attack_finished = time + 0.8;
			break;
		case WEP_RAILGUN:
			break;
		case WEP_HYPERBLASTER:
			W_FireBlaster();
			q2player_HBattackframes ();
			self.attack_finished = time + 0.135;
			break;
		case WEP_BFG:
			break;
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
	local	float	was;
	
	was = self.weapon;

//MrC: select a new wep or don't do anything if it's already selected
//There's for sure a better way of doing THIS!

	switch (self.impulse)
	{
		case 1:
			if (self.weapon == WEP_BLASTER)
			{ 
				return;
			}
			self.weapon = WEP_BLASTER;
			break;
		case 2:
			if (self.weapon == WEP_SHOTGUN)
			{ 
				return;
			}
			self.weapon = WEP_SHOTGUN;
			break;
		case 3:
			if (self.weapon == WEP_SUPERSHOTGUN)
			{ 
				return;
			}
			self.weapon = WEP_SUPERSHOTGUN;
			break;
		case 4:
			if (self.weapon == WEP_MACHINEGUN)
			{ 
				return;
			}
			self.weapon = WEP_MACHINEGUN;
			break;
		case 5:
			if (self.weapon == WEP_CHAINGUN)
			{ 
				return;
			}
			self.weapon = WEP_CHAINGUN;
			break;
		case 6:
			if (self.weapon == WEP_GRENADE_LAUNCHER)
			{ 
				return;
			}
			self.weapon = WEP_GRENADE_LAUNCHER;
			break;
		case 7:
			if (self.weapon == WEP_ROCKET_LAUNCHER)
			{ 
				return;
			}
			self.weapon = WEP_ROCKET_LAUNCHER;
			break;
		case 8:
			if (self.weapon == WEP_HYPERBLASTER)
			{ 
				return;
			}
			self.weapon = WEP_HYPERBLASTER;
			break;
	}



/*
	if (self.impulse == 1) self.weapon = WEP_BLASTER;
	if (self.impulse == 2) self.weapon = WEP_SHOTGUN;
	if (self.impulse == 3) self.weapon = WEP_SUPERSHOTGUN;
	if (self.impulse == 4) self.weapon = WEP_MACHINEGUN;
	if (self.impulse == 5) self.weapon = WEP_CHAINGUN;
	if (self.impulse == 6) self.weapon = WEP_GRENADE_LAUNCHER;
	if (self.impulse == 7) self.weapon = WEP_ROCKET_LAUNCHER;
	if (self.impulse == 8) self.weapon = WEP_HYPERBLASTER;
*/
	self.f__ = 1; // so logic doesnt change weapon
// use logic test here
	CycleWeaponCommand();

// failed
	if (self.impulse)
	{
		self.impulse = 0;

		if (!(self.items & self.weapon))
// don't have the weapon
			sprint (self, "no weapon.\n");
		else
//  or the ammo				- this is an either or fail, so if its not no wep, it must be this
			sprint (self, "not enough ammo.\n");

// we were here
		self.weapon = was;
		return;	
	}
	
	W_Draw();
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
	self.ammo_shells = 10;
	self.items = self.items | 
		WEP_BLASTER |
		WEP_SHOTGUN |
		WEP_SUPERSHOTGUN |
		WEP_MACHINEGUN |
		WEP_CHAINGUN |
		WEP_GRENADE_LAUNCHER |
		WEP_ROCKET_LAUNCHER |
		IT_KEY1 | IT_KEY2;

	self.ammo_cells = 200;
	self.items = self.items | WEP_HYPERBLASTER;

	self.weapon = WEP_ROCKET_LAUNCHER;
	self.impulse = 0;
	W_SetCurrentAmmo ();
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
		self.weapon = self.weapon * self.f__;

// coming from axe on this system - arg!  why couldnt the axe have been 1?
		if (self.weapon == 8192 ) self.weapon = WEP_SHOTGUN;
		if (self.weapon == 2048 ) self.weapon = WEP_HYPERBLASTER;
// going to the axe
		if (!(self.weapon & 127)) self.weapon = WEP_BLASTER;

// weapon select logic
		if (self.weapon == WEP_HYPERBLASTER && self.ammo_cells < 1) am = 1;
		if (self.weapon == WEP_ROCKET_LAUNCHER && self.ammo_rockets < 1) am = 1;
		if (self.weapon == WEP_GRENADE_LAUNCHER && self.ammo_rockets < 1) am = 1;
		if (self.weapon == WEP_CHAINGUN && self.inv_ammo_bullets < 2) am = 1;
		if (self.weapon == WEP_MACHINEGUN && self.inv_ammo_bullets < 1) am = 1;
		if (self.weapon == WEP_SUPERSHOTGUN && self.ammo_shells < 2) am = 1;
		if (self.weapon == WEP_SHOTGUN && self.ammo_shells < 1) am = 1;
	
		if ( (self.items & self.weapon) && ! am)
		{
			W_SetCurrentAmmo ();
			self.impulse = 0;
			W_Draw();
			return;
		}
// dont cycle single select
		if (self.impulse < 10) return;
		
	}
		

};

/*
============
CycleWeaponReverseCommand

Go to the prev weapon with ammo
============
*
void() CycleWeaponReverseCommand =
{
//	local	float	it, am;
	local	float	am;
	
//	it = self.items;
	self.impulse = 0;

	while (1)
	{
		am = 0;

		if (self.weapon == WEP_HYPERBLASTER)
		{
			self.weapon = WEP_ROCKET_LAUNCHER;
			if (self.ammo_rockets < 1)
				am = 1;
		}
		else if (self.weapon == WEP_ROCKET_LAUNCHER)
		{
			self.weapon = WEP_GRENADE_LAUNCHER;
			if (self.ammo_rockets < 1)
				am = 1;
		}
		else if (self.weapon == WEP_GRENADE_LAUNCHER)
		{
			self.weapon = WEP_CHAINGUN;
			if (self.ammo_nails < 2)
				am = 1;
		}
		else if (self.weapon == WEP_CHAINGUN)
		{
			self.weapon = WEP_MACHINEGUN;
			if (self.ammo_nails < 1)
				am = 1;
		}
		else if (self.weapon == WEP_MACHINEGUN)
		{
			self.weapon = WEP_SUPERSHOTGUN;
			if (self.ammo_shells < 2)
				am = 1;
		}		
		else if (self.weapon == WEP_SUPERSHOTGUN)
		{
			self.weapon = WEP_SHOTGUN;
			if (self.ammo_shells < 1)
				am = 1;
		}
		else if (self.weapon == WEP_SHOTGUN)
		{
			self.weapon = IT_AXE;
		}
		else if (self.weapon == IT_AXE)
		{
			self.weapon = WEP_HYPERBLASTER;
			if (self.ammo_cells < 1)
				am = 1;
		}
	
		if ( (self.items & self.weapon) && am == 0)
		{
			W_SetCurrentAmmo ();
			return;
		}
	}

};
*/
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
	if (self.impulse == 13){
		q2_tossWeapon();
		self.weapon = W_BestWeapon();
		W_SetCurrentAmmo();
	}
	
	if (self.impulse >= 1 && self.impulse <= 8) // && self.weaponstate == WEAPON_READY)
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

	if (self.impulse == 10)
	{
		self.f__ = 2;
		CycleWeaponCommand();
	}
	if (self.impulse == 12)
	{
		self.f__ = 0.5;
		CycleWeaponCommand();
	}
//		CycleWeaponReverseCommand();

#ifdef debug
// cheat impulses are only active in debug mode - which should never be on in live server / released game code
	if (self.impulse == 9)
		CheatCommand ();
	if (self.impulse == 11)
		ServerflagsCommand ();
	if (self.impulse == 99){
		bprint ("Current camera position: ");
		bprint (vtos (self.origin));
		bprint ("\n");
	}
	if (self.impulse == 255)
		QuadCheat ();
#endifdef

	self.impulse = 0;
};

// "Inspired" by Quake 2 ;D ... Semi-ported version below.

void (float FRAME_ACTIVATE_LAST, float FRAME_FIRE_LAST, float FRAME_IDLE_FIRST, float FRAME_IDLE_LAST) Weapon_Generic_Idle =
{
	local float r = random();
	
	if (time < self.nextframetime)
		return;
	
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
			bprint ("Running attacking HyperBlaster!");
			bprint ("\n");
			
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
			bprint ("Running attacking Chaingun!");
			bprint ("\n");
			
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
		else
		{
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
			bprint ("Done attacking HyperBlaster!");
			bprint ("\n");
						
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
			bprint ("Idle attacking Chaingun!");
			bprint ("\n");

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

	dprint (ftos(self.nextframetime));
	dprint ("\n");
	dprint ("Idle Fidget Sequence: ");
	dprint (ftos(self.animIdle));
	dprint ("\n");
	self.weaponframe++;

	self.nextframetime = time + 0.135;
}

// Ported from Quake 2

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
	if (self.weaponstate != WEAPON_FIRING)
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
			if (self.weaponframe == FRAME_IDLE_LAST)
			{
				self.weaponframe = FRAME_IDLE_FIRST;
				return;
			}
			self.nextframetime = time + 0.135;
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

		if (self.weaponframe == FRAME_IDLE_FIRST+1)
			self.weaponstate = WEAPON_READY;
	}
	
	self.nextframetime = time + 0.135;
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
	if (self.button0)
	{
//		if (self.weaponstate != WEAPON_READY)
//			return;
		
		self.state = STATE_ATTACKING;
		SuperDamageSound ();
		W_Attack ();
	}

	switch (self.weapon)
	{
		case WEP_BLASTER:
			if (self.animIdle == 1){				
				Weapon_Generic_Idle (WEP_BLASTER_ACTIVE_LASTFRAME, WEP_BLASTER_FIRE_LASTFRAME, WEP_BLASTER_IDLE1_FIRSTFRAME, WEP_BLASTER_IDLE1_LASTFRAME);
			}
			else{
				Weapon_Generic_Idle (WEP_BLASTER_ACTIVE_LASTFRAME, WEP_BLASTER_FIRE_LASTFRAME, WEP_BLASTER_IDLE2_FIRSTFRAME, WEP_BLASTER_IDLE2_LASTFRAME);
			}
			break;
		case WEP_SHOTGUN:
			Weapon_Generic_Idle (7, 18, 19, 36);
			break;
		case WEP_SUPERSHOTGUN:
			Weapon_Generic_Idle (6, 17, 18, 57);
			break;
		case WEP_MACHINEGUN:
			if (self.animIdle == 1){				
				Weapon_Generic_Idle (3, 5, 6, 23);
			}
			else{
				Weapon_Generic_Idle (3, 5, 23, 45);
			}
			Weapon_Generic_Idle (3, 5, 6, 45);
			break;
		case WEP_CHAINGUN:
			Weapon_Generic_Idle (4, 31, 32, 61);
			break;
		case WEP_GRENADE_LAUNCHER:
			Weapon_Generic_Idle (6, 17, 18, 60);
			break;
		case WEP_ROCKET_LAUNCHER:
			 Weapon_Generic_Idle (4, 12, 13, 50);
			break;
		case WEP_RAILGUN:
			Weapon_Generic_Idle (3, 18, 19, 56);
			break;
		case WEP_HYPERBLASTER:
			Weapon_Generic_Idle (5, 20, 21, 49);
			break;
		case WEP_BFG:
			Weapon_Generic_Idle (8, 31, 32, 54);
			break;
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


