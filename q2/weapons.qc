/*
	Straight port of Q2 weapon systems to QC.
		biggest difference is QC has to flatten weapon struct data down to the client struct scope.
*/

void() weapon_blaster_update;
void() weapon_shotgun_update;
void() weapon_supershotg_update;
void() weapon_machineg_update;
void() weapon_chaingun_update;
void() weapon_nadelaunch_update;
void() weapon_rocketlaunch_update;
void() weapon_hyperb_update;
void() weapon_railgun_update;
void() weapon_bfg_update;

/*
	AMMO_IDX_NONE,		0
	AMMO_IDX_SHELLS,	1
	AMMO_IDX_BULLETS,	2
	AMMO_IDX_ROCKETS,	3
	AMMO_IDX_SLUGS,		4
	AMMO_IDX_CELLS		5
*/
float(float weaponId ) W_Ammo_Index={
	switch(weaponId){
		case WEP_BLASTER:
			return AMMO_IDX_NONE;
		
		case WEP_SHOTGUN:
			return AMMO_IDX_SHELLS;
		
		case WEP_SUPERSHOTGUN:
			return AMMO_IDX_SHELLS;
		
		case WEP_MACHINEGUN:
			return AMMO_IDX_BULLETS;
		
		case WEP_CHAINGUN:
			return AMMO_IDX_BULLETS;
		
		case WEP_GRENADE_LAUNCHER:
			return AMMO_IDX_ROCKETS;
		
		case WEP_ROCKET_LAUNCHER:
			return AMMO_IDX_ROCKETS;
		
		case WEP_HYPERBLASTER:
			return AMMO_IDX_CELLS;
		
		case WEP_RAILGUN:
			return AMMO_IDX_SLUGS;
		
		case WEP_BFG:
			return AMMO_IDX_CELLS;
	}
	return AMMO_IDX_NONE;
};

/*
	return ammo amounts based on desired Ammo_index
*/
float(float ammoIdx) W_Ammo_Amount={
	switch(ammoIdx){
		case AMMO_IDX_SHELLS:
			return self.ammo_shells;
		
		case AMMO_IDX_BULLETS:
			return self.inv_ammo_bullets;
		
		case AMMO_IDX_ROCKETS:
			return self.ammo_rockets;
		
		case AMMO_IDX_SLUGS:
			return self.inv_ammo_slugs;
		
		case AMMO_IDX_CELLS:
			return self.ammo_cells;
	}
	return 0;
};

/*
===============
ChangeWeapon
The old weapon has been dropped all the way, so make the new one
current
===============
*/
void() W_ChangeWeapon = 
{
	float i;

	if (self.grenade_time)
	{
		self.grenade_time = 0;
		//ent->client->weapon_sound = 0;
		//weapon_grenade_fire (ent, false);
		self.grenade_time = 0;
	}

	self.lastweapon = self.weapon;
	self.weapon = self.weapon_next;
	self.weapon_next = 0;
	self.machinegun_shots = 0;

	// set visible model
	//TODO
	/*if (self.modelindex == 255) {
		if (self.weapon)
			i = ((ent->client->pers.weapon->weapmodel & 0xff) << 8);
		else
			i = 0;
		ent->s.skinnum = (ent - g_edicts - 1) | i;
	}*/

	/*
		TODO - ammo index
	if (self.weapon && ent->client->pers.weapon->ammo)
		self.ammo_index = ITEM_INDEX(FindItem(ent->client->pers.weapon->ammo));
	else
		self.ammo_index = 0;
	*/
	
	if (self.weapon)
	{	// dead
		self.weaponmodel = "";
		return;
	}

	self.weaponstate = WEAPON_ACTIVATING;
	self.weaponframe = 0;
	
	//TODO - gun model
	//ent->client->ps.gunindex = gi.modelindex(ent->client->pers.weapon->view_model);

	/*
	TODO - sync player model
	ent->client->anim_priority = ANIM_PAIN;
	if(ent->client->ps.pmove.pm_flags & PMF_DUCKED)
	{
			ent->s.frame = FRAME_crpain1;
			ent->client->anim_end = FRAME_crpain4;
	}
	else
	{
			ent->s.frame = FRAME_pain301;
			ent->client->anim_end = FRAME_pain304;
			
	}*/
}

/*
=================
NoAmmoWeaponChange
=================
*/
void() W_NoAmmoWeaponChange =
{
	if(self.inv_ammo_slugs && (self.inv_weapons & WEP_RAILGUN)){
		self.weapon_next = WEP_RAILGUN;
		return;
	}
	
	
	if(self.ammo_cells && (self.inv_weapons & WEP_HYPERBLASTER)){
		self.weapon_next = WEP_HYPERBLASTER;
		return;
	}
	
	
	if(self.inv_ammo_bullets && (self.inv_weapons & WEP_CHAINGUN)){
		self.weapon_next = WEP_CHAINGUN;
		return;
	}
	
	if(self.inv_ammo_bullets && (self.inv_weapons & WEP_MACHINEGUN)){
		self.weapon_next = WEP_MACHINEGUN;
		return;
	}
	
	
	if(self.ammo_shells && (self.inv_weapons & WEP_SUPERSHOTGUN)){
		self.weapon_next = WEP_SUPERSHOTGUN;
		return;
	}
	
	
	if(self.ammo_shells && (self.inv_weapons & WEP_SHOTGUN)){
		self.weapon_next = WEP_SHOTGUN;
		return;
	}

	self.weapon_next = WEP_BLASTER;
}

/*
================
Use_Weapon
Make the weapon ready if there is ammo
================
*/
void(float weaponId) W_Use_Weapon=
{
	local float ammoLeft;
	//int			ammo_index;
	//gitem_t		*ammo_item;

	// see if we're already using it
	if (weaponId == self.weapon)
		return;
	
	if(weaponId == WEP_BLASTER){
		//infinite ammo, so we can always switch to it.
		self.weapon_next = weaponId;
		return;
	}
	
	if (!(self.inv_weapons & weaponId))
	{	// don't have the weapon or the ammo
		sprint (self, "no weapon.\n");
		self.weapon_next = 0;
		return;
	}
		
	ammoLeft = W_Ammo_Index(weaponId);
	ammoLeft = W_Ammo_Amount(ammoLeft);
	if (!ammoLeft)
	{	// don't have the ammo
		sprint (self, "not enough ammo.\n");
		self.weapon_next = 0;
		return;
	}
	
	/*if (item->ammo && !g_select_empty->value && !(item->flags & IT_AMMO))
	{
		ammo_item = FindItem(item->ammo);
		ammo_index = ITEM_INDEX(ammo_item);

		if (!ent->client->pers.inventory[ammo_index])
		{
			gi.cprintf (ent, PRINT_HIGH, "No %s for %s.\n", ammo_item->pickup_name, item->pickup_name);
			return;
		}

		if (ent->client->pers.inventory[ammo_index] < item->quantity)
		{
			gi.cprintf (ent, PRINT_HIGH, "Not enough %s for %s.\n", ammo_item->pickup_name, item->pickup_name);
			return;
		}
	}*/

	// change to this weapon when down
	self.weapon_next = weaponId;
}


void() W_WeaponAnimate={
	if( time > self.weapon_think ){
		
		self.weapon_update_func();
		
		self.weapon_think = time + 0.1;
	}
};

/*
================
Weapon_Generic
A generic function to handle the basics of weapon thinking
================
*/
#define FRAME_FIRE_FIRST		(FRAME_ACTIVATE_LAST + 1)
#define FRAME_IDLE_FIRST		(FRAME_FIRE_LAST + 1)
#define FRAME_DEACTIVATE_FIRST	(FRAME_IDLE_LAST + 1)

//removed args int *pause_frames[], int *fire_frames[], 
void(float FRAME_ACTIVATE_LAST, float FRAME_FIRE_LAST, float FRAME_IDLE_LAST, float FRAME_DEACTIVATE_LAST, void() fire_func) Weapon_Generic =
{
  local float n;

  frame_t framesFire;
 //framesFire = wpnFramesFire[0];
 //weaponFrame_t framesPause;

  if(self.deadflag || self.modelindex != 255) // VWep animations screw up corpses
	{
		return;
	}

	if (self.weaponstate == WEAPON_DROPPING)
	{
		if (self.weaponframe == FRAME_DEACTIVATE_LAST)
		{
			//ChangeWeapon (ent);
			W_ChangeWeapon();
			return;
		}
		else if ((FRAME_DEACTIVATE_LAST - self.weaponframe) == 4)
		{
			//TODO - crouching
			/*ent->client->anim_priority = ANIM_REVERSE;
			if(ent->client->ps.pmove.pm_flags & PMF_DUCKED)
			{
				ent->s.frame = FRAME_crpain4+1;
				ent->client->anim_end = FRAME_crpain1;
			}
			else
			{
				ent->s.frame = FRAME_pain304+1;
				ent->client->anim_end = FRAME_pain301;
				
			}*/
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

		self.weaponframe++;
		return;
	}

	if ((self.weapon_next) && (self.weaponstate != WEAPON_FIRING))
	{
		self.weaponstate = WEAPON_DROPPING;
		self.weaponframe = FRAME_DEACTIVATE_FIRST;

		if ((FRAME_DEACTIVATE_LAST - FRAME_DEACTIVATE_FIRST) < 4)
		{
			//TODO - player model anim syncing
			/*ent->client->anim_priority = ANIM_REVERSE;
			if(ent->client->ps.pmove.pm_flags & PMF_DUCKED)
			{
				ent->s.frame = FRAME_crpain4+1;
				ent->client->anim_end = FRAME_crpain1;
			}
			else
			{
				ent->s.frame = FRAME_pain304+1;
				ent->client->anim_end = FRAME_pain301;
				
			}*/
		}
		return;
	}

	if (self.weaponstate == WEAPON_READY)
	{
		if ( (self.button0) )
		{
			//ent->client->latched_buttons &= ~BUTTON_ATTACK;
			if ((!self.ammo_index) || 
				( W_Ammo_Amount(self.ammo_index) >= 1))	//ent->client->pers.weapon->quantity
			{
				self.weaponframe = FRAME_FIRE_FIRST;
				self.weaponstate = WEAPON_FIRING;

				// start the animation
				//TODO - syncing player model
				/*ent->client->anim_priority = ANIM_ATTACK;
				if (ent->client->ps.pmove.pm_flags & PMF_DUCKED)
				{
					ent->s.frame = FRAME_crattak1-1;
					ent->client->anim_end = FRAME_crattak9;
				}
				else
				{
					ent->s.frame = FRAME_attack1-1;
					ent->client->anim_end = FRAME_attack8;
				}*/
			}
			else
			{
				//TODO - find pain_debounce_time
				//if (time >= ent->pain_debounce_time)
				//{
					//gi.sound(ent, CHAN_VOICE, gi.soundindex("weapons/noammo.wav"), 1, ATTN_NORM, 0);
					//ent->pain_debounce_time = level.time + 1;
				//}
				//NoAmmoWeaponChange (ent);
			}
		}
		else
		{
			if (self.weaponframe == FRAME_IDLE_LAST)
			{
				self.weaponframe = FRAME_IDLE_FIRST;
				return;
			}
			//TODO - pause frames
			/*if (pause_frames)
			{
				for (n = 0; pause_frames[n]; n++)
				{
					if (self.weaponframe == pause_frames[n])
					{
						if (random()&15)
							return;
					}
				}
			}*/
			
			self.weaponframe++;
			return;
		}
	}

	if (self.weaponstate == WEAPON_FIRING)
	{
		/*for (n = 0; fire_frames[n]; n++)
		{
			if (self.weaponframe == fire_frames[n])
			{
				//TODO - quad damage
				//if (ent->client->quad_framenum > level.framenum)
					//gi.sound(ent, CHAN_ITEM, gi.soundindex("items/damage3.wav"), 1, ATTN_NORM, 0);

				fire_func();
				break;
			}
		}*/

		//if (!fire_frames[n])
			//self.weaponframe++

		if (self.weaponframe == FRAME_IDLE_FIRST+1)
			self.weaponstate = WEAPON_READY;
	}
}
/*
	Weapon update functions.
*/
void() weapon_blaster_update={
	
	//Weapon_Generic(float FRAME_ACTIVATE_LAST, float FRAME_FIRE_LAST, float FRAME_IDLE_LAST, float FRAME_DEACTIVATE_LAST, void() fire_func)
	
};

void() weapon_shotgun_update={

};

void() weapon_supershotg_update={

};

void() weapon_machineg_update={

};

void() weapon_chaingun_update={

};

void() weapon_nadelaunch_update={

};

void() weapon_rocketlaunch_update={

};

void() weapon_hyperb_update={

};

void() weapon_railgun_update={

};

void() weapon_bfg_update={

};
