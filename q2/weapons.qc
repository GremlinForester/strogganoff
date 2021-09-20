/*
	Straight port of Q2 weapon systems to QC.
		biggest difference is QC has to flatten weapon struct data down to the client struct scope.
*/

/*
	Pause Frame funcs
*/
//.void() weapon_pause_frames;	// these really need to be structs
//.void() weapon_fire_frames;

float() weapon_blaster_pause={
	switch(self.weaponframe){
		case 19:
			return TRUE;
		case 32:
			return TRUE;
	}
	return FALSE;
};

float() weapon_shotgun_pause={
	switch(self.weaponframe){
		case 22:
			return TRUE;
		case 28:
			return TRUE;
		case 34:
			return TRUE;
	}
	return FALSE;
};

float() weapon_supershotg_pause={
	switch(self.weaponframe){
		case 29:
			return TRUE;
		case 42:
			return TRUE;
		case 57:
			return TRUE;
	}
	return FALSE;
};

float() weapon_machineg_pause={
	switch(self.weaponframe){
		case 23:
			return TRUE;
		case 45:
			return TRUE;
	}
	return FALSE;
};

float() weapon_chaingun_pause={
	switch(self.weaponframe){
		case 38:
			return TRUE;
		case 43:
			return TRUE;
		case 51:
			return TRUE;
		case 61:
			return TRUE;
	}
	return FALSE;
};

float() weapon_nadelaunch_pause={
	switch(self.weaponframe){
		case 34:
			return TRUE;
		case 51:
			return TRUE;
		case 59:
			return TRUE;
	}
	return FALSE;
};

float() weapon_rocketlaunch_pause={
	switch(self.weaponframe){
		case 25:
			return TRUE;
		case 33:
			return TRUE;
		case 42:
			return TRUE;
		case 50:
			return TRUE;
	}
	return FALSE;
};

float() weapon_hyperb_pause={
	if(self.weaponframe)
		return FALSE;
	
	return TRUE;
};

float() weapon_railgun_pause={
	switch(self.weaponframe){
		case 56:
			return TRUE;
	}
	return FALSE;
};

float() weapon_bfg_pause={
	switch(self.weaponframe){
		case 39:
			return TRUE;
		case 45:
			return TRUE;
		case 50:
			return TRUE;
		case 55:
			return TRUE;
	}
	return FALSE;
};

/*
	Fire Frame Funcs
*/
float() weapon_blaster_fire={
	switch(self.weaponframe){
		case 5:
			return TRUE;
	}
	return FALSE;
};
float() weapon_shotgun_fire={
	switch(self.weaponframe){
		case 8:
			return TRUE;
		case 9:
			return TRUE;
	}
	return FALSE;
};
float() weapon_supershotg_fire={
	switch(self.weaponframe){
		case 7:
			return TRUE;
	}
	return FALSE;
};
float() weapon_machineg_fire={
	switch(self.weaponframe){
		case 4:
			return TRUE;
		case 5:
			return TRUE;
	}
	return FALSE;
};
float() weapon_chaingun_fire={
	
	if( self.weaponframe >= 5 && self.weaponframe <= 21)
		return TRUE;
	
	if(self.weaponframe == 0)
		return TRUE;
	
	return FALSE;
};
float() weapon_nadelaunch_fire={
	if(self.weaponframe == 6 || self.weaponframe == 9)
		return TRUE;
	return FALSE;
};
float() weapon_rocketlaunch_fire={
	if(self.weaponframe == 5 || self.weaponframe == 0 || self.weaponframe == 9)
		return TRUE;
	return FALSE;
};
float() weapon_hyperb_fire={
	if(self.weaponframe == 0)
		return TRUE;
	
	if(self.weaponframe > 5 && self.weaponframe < 12)
		return TRUE;
	return FALSE;
};
float() weapon_railgun_fire={
	if(self.weaponframe == 4 || self.weaponframe == 0)
		return TRUE;
	return FALSE;
};
float() weapon_bfg_fire={
	if(self.weaponframe == 9 || self.weaponframe == 17 || self.weaponframe == 0)
		return TRUE;
	return FALSE;
};

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
			return self.inv_ammo_shells;
		
		case AMMO_IDX_BULLETS:
			return self.inv_ammo_bullets;
		
		case AMMO_IDX_ROCKETS:
			return self.inv_ammo_rockets;
		
		case AMMO_IDX_SLUGS:
			return self.inv_ammo_slugs;
		
		case AMMO_IDX_CELLS:
			return self.inv_ammo_cells;
	}
	return 0;
};

/*
	vanilla Q1 uses self.items to determine which ammo icon to display for the active weapon.
	This could be seen in the old W_SetCurrentAmmo() func in v1.06
*/
void(float ammoIdx) W_Ammo_toItems={
	self.items = self.items - (self.items & (IT_SHELLS | IT_BULLETS | IT_CELLS | IT_ROCKETS));
	switch(ammoIdx){
		case AMMO_IDX_SHELLS:
			self.items = self.items | IT_SHELLS;
			return;
			
		case AMMO_IDX_BULLETS:
			self.items = self.items | IT_BULLETS;
			return;
		
		case AMMO_IDX_ROCKETS:
			self.items = self.items | IT_ROCKETS;
			return;
		
		case AMMO_IDX_SLUGS:
			self.items = self.items | IT_BULLETS;
			return;
		
		case AMMO_IDX_CELLS:
			self.items = self.items | IT_CELLS;
			return;
	}
	return;
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
	local float i;

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
	
	if (!self.weapon)
	{	// dead
		self.weaponmodel = "";
		return;
	}

	self.weaponstate = WEAPON_ACTIVATING;
	self.weaponframe = 0;
	
	//TODO - gun model
	//ent->client->ps.gunindex = gi.modelindex(ent->client->pers.weapon->view_model);
	local string readySfx;
	switch(self.weapon){
		case WEP_BLASTER:
			readySfx = "weapons/HGRENT1A.WAV";
			self.weaponmodel = "models/weapons/v_blast/tris.md2";
			self.weapon_update_func = weapon_blaster_update;
			self.weapon_pause_frames = weapon_blaster_pause;
			self.weapon_fire_frames = weapon_blaster_fire;
			self.weapon_ammo_min = 0;	//unlimited ammo
			break;
		case WEP_SHOTGUN:
			readySfx = "weapons/Shotgr1b.wav";
			self.weaponmodel = "models/weapons/v_shotg/tris.md2";
			self.weapon_update_func = weapon_shotgun_update;
			self.weapon_pause_frames = weapon_shotgun_pause;
			self.weapon_fire_frames = weapon_shotgun_fire;
			self.weapon_ammo_min = 1;
			break;
		case WEP_SUPERSHOTGUN:
			readySfx = "weapons/HGRENT1A.WAV";
			self.weaponmodel = "models/weapons/v_shotg2/tris.md2";
			self.weapon_update_func = weapon_supershotg_update;
			self.weapon_pause_frames = weapon_supershotg_pause;
			self.weapon_fire_frames = weapon_supershotg_fire;
			self.weapon_ammo_min = 2;
			break;
		case WEP_MACHINEGUN:
			readySfx = "weapons/HGRENT1A.WAV";
			self.weaponmodel = "models/weapons/v_machn/tris.md2";
			self.weapon_update_func = weapon_machineg_update;
			self.weapon_pause_frames = weapon_machineg_pause;
			self.weapon_fire_frames = weapon_machineg_fire;
			self.weapon_ammo_min = 1;
			break;
		case WEP_CHAINGUN:
			readySfx = "weapons/HGRENT1A.WAV";
			self.weaponmodel = "models/weapons/v_chain/tris.md2";
			self.weapon_update_func = weapon_chaingun_update;
			self.weapon_pause_frames = weapon_chaingun_pause;
			self.weapon_fire_frames = weapon_chaingun_fire;
			self.weapon_ammo_min = 1;
			break;
		case WEP_GRENADE_LAUNCHER:
			readySfx = "weapons/HGRENT1A.WAV";
			self.weaponmodel = "models/weapons/v_launch/tris.md2";
			self.weapon_update_func = weapon_nadelaunch_update;
			self.weapon_pause_frames = weapon_nadelaunch_pause;
			self.weapon_fire_frames = weapon_nadelaunch_fire;
			self.weapon_ammo_min = 1;
			break;
		case WEP_ROCKET_LAUNCHER:
			readySfx = "weapons/HGRENT1A.WAV";
			self.weaponmodel = "models/weapons/v_rocket/tris.md2";
			self.weapon_update_func = weapon_rocketlaunch_update;
			self.weapon_pause_frames = weapon_rocketlaunch_pause;
			self.weapon_fire_frames = weapon_rocketlaunch_fire;
			self.weapon_ammo_min = 1;
			break;
		case WEP_HYPERBLASTER:
			readySfx = "weapons/HGRENT1A.WAV";
			self.weaponmodel = "models/weapons/v_hyperb/tris.md2";
			self.weapon_update_func = weapon_hyperb_update;
			self.weapon_pause_frames = weapon_hyperb_pause;
			self.weapon_fire_frames = weapon_hyperb_fire;
			self.weapon_ammo_min = 1;
			break;
		case WEP_RAILGUN:
			readySfx = "weapons/HGRENT1A.WAV";
			self.weaponmodel = "models/weapons/v_rail/tris.md2";
			self.weapon_update_func = weapon_railgun_update;
			self.weapon_pause_frames = weapon_railgun_pause;
			self.weapon_fire_frames = weapon_railgun_fire;
			self.weapon_ammo_min = 1;
			break;
		case WEP_BFG:
			readySfx = "weapons/HGRENT1A.WAV";
			self.weaponmodel = "models/weapons/v_bfg/tris.md2";
			self.weapon_update_func = weapon_bfg_update;
			self.weapon_pause_frames = weapon_bfg_pause;
			self.weapon_fire_frames = weapon_bfg_fire;
			self.weapon_ammo_min = 50;
			break;
	}
	sound(self, CHAN_WEAPON, readySfx, 0.5, ATTN_IDLE);

	self.ammo_index = W_Ammo_Index(self.weapon);
	self.currentammo = W_Ammo_Amount(self.ammo_index);
	W_Ammo_toItems(self.ammo_index);
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
	sound(self, CHAN_AUTO, "weapons/noammo.wav", 1.0, ATTN_NORM);
	if(self.inv_ammo_slugs && (self.inv_weapons & WEP_RAILGUN)){
		self.weapon_next = WEP_RAILGUN;
		return;
	}
	
	if(self.inv_ammo_cells && (self.inv_weapons & WEP_HYPERBLASTER)){
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
	
	if(self.inv_ammo_shells && (self.inv_weapons & WEP_SUPERSHOTGUN)){
		self.weapon_next = WEP_SUPERSHOTGUN;
		return;
	}
	
	if(self.inv_ammo_shells && (self.inv_weapons & WEP_SHOTGUN)){
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
	local float ammoIndex;
	
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
		
	ammoIndex = W_Ammo_Index(weaponId);
	if (!W_Ammo_Amount(ammoIndex))
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

/*
	Called in client.qc - PlayerPostThink();
		run after impulse checks.
		this is the per-frame update func for the weapon state machine.
*/
/*
void() W_WeaponAnimate={
	if( time > self.weapon_think ){
		self.weapon_update_func();
		self.weapon_think = time + 0.1;
	}
};
*/
/*
void() W_WeaponAnimate={
	if( time > self.weapon_think ){
		if (self.weaponstate == WEAPON_ACTIVATING || self.weaponstate == WEAPON_DROPPING)
		{
			self.weapon_think = time + WEAPON_SWITCH_SPEED;
		}
		else
		{	
		self.weapon_think = time + 0.1;
		}
	self.weapon_update_func();
	}
};
*/
void() W_WeaponAnimate={
	if( time > self.weapon_think )
	{
		if (self.weaponstate == WEAPON_ACTIVATING || self.weaponstate == WEAPON_DROPPING)
		{
			if (autocvar_cl_fastweaponswitch >= 1)
			{
				self.weapon_think = time + WEAPON_SWITCH_SPEED;
			}
			else
			{	
				self.weapon_think = time + 0.1;
			}
		}
		else
		{
			self.weapon_think = time + 0.1;
		}
	self.weapon_update_func();
	}
};

//MrC: This will eventually go elsewhere. Here for testing.
void() player_chatter_idle =
{
	local float r;
	r = random() * 4;

	//self.nexttalktime = time + 10.35 + random() * 0.1;


	if (autocvar_cl_idletalk <= 0)
		return;

	if (coop || deathmatch)
	{
		return;
	}
	
	if (time < self.nexttalktime)
	return;

	if (self.deadflag)
		return;
	if (!(self.flags & FL_ONGROUND))
		return;
	if (vlen(self.velocity) > 10)
		return;
	if (self.movetype == MOVETYPE_NOCLIP || self.movetype == MOVETYPE_FLY)
		return;
  	if (self.waterlevel >= 3)
	{
		return;
	}
	
	if (r < 1) {sound(self, CHAN_VOICE, PLAYER_IDLECOMMENT_1, 0.5, ATTN_IDLE);
	}
	else if (r < 2) {sound(self, CHAN_VOICE, PLAYER_IDLECOMMENT_2, 0.5, ATTN_IDLE);
	}
	else if (r < 3) {sound(self, CHAN_VOICE, PLAYER_IDLECOMMENT_3, 0.5, ATTN_IDLE);
	}
	else            {sound(self, CHAN_VOICE, PLAYER_IDLECOMMENT_4, 0.5, ATTN_IDLE);
	}
	
	self.nexttalktime = time + 45;
}

/*

This is called during weapon idle. 
It could be used to call random sounds or effects during a sequence.

*/

void() doWeaponframes =
{
	switch(self.weapon)
	{
	case WEP_BLASTER:
		switch(self.weaponframe)
		{
			case 27:
			//	player_chatter_idle();
			break;
			case 50:
			//	player_chatter_idle();
			break;
		}
	break;
	/*
	case WEP_SHOTGUN:
		switch(self.weaponframe)
		{
			case 0:
				sound(self, CHAN_WEAPON2, "player/axhit2.wav", 1, ATTN_IDLE);
			break;
		}
	break;
	case WEP_SUPERSHOTGUN:
		switch(self.weaponframe)
		{
			case 0:
				sound(self, CHAN_WEAPON2, "player/axhit2.wav", 1, ATTN_IDLE);
			break;
		}
	break;
	case WEP_MACHINEGUN:
		switch(self.weaponframe)
		{
			case 0:
				sound(self, CHAN_WEAPON2, "player/axhit2.wav", 1, ATTN_IDLE);
			break;
		}
	break;
	case WEP_CHAINGUN:
		switch(self.weaponframe)
		{
			case 0:
				sound(self, CHAN_WEAPON2, "player/axhit2.wav", 1, ATTN_IDLE);
			break;
		}
	break;
	case WEP_GRENADE_LAUNCHER:
		switch(self.weaponframe)
		{
			case 0:
				sound(self, CHAN_WEAPON2, "player/axhit2.wav", 1, ATTN_IDLE);
			break;
		}
	break;
	case WEP_ROCKET_LAUNCHER:
		switch(self.weaponframe)
		{
			case 0:
				sound(self, CHAN_WEAPON2, "player/axhit2.wav", 1, ATTN_IDLE);
			break;
		}
	break;
	case WEP_HYPERBLASTER:
		switch(self.weaponframe)
		{
			case 0:
				sound(self, CHAN_WEAPON2, "player/axhit2.wav", 1, ATTN_IDLE);
			break;
		}
	break;
	case WEP_RAILGUN:
		switch(self.weaponframe)
		{
			case 0:
				sound(self, CHAN_WEAPON2, "player/axhit2.wav", 1, ATTN_IDLE);
			break;
		}
	break;
	case WEP_BFG:
		switch(self.weaponframe)
		{
			case 0:
				sound(self, CHAN_WEAPON2, "player/axhit2.wav", 1, ATTN_IDLE);
			break;
		}
	break;
	*/
	}
}


/*
================
Weapon_Generic
A generic function to handle the basics of weapon thinking
================
*/
//removed args int *pause_frames[], int *fire_frames[], 
void(float FRAME_ACTIVATE_LAST, float FRAME_FIRE_LAST, float FRAME_IDLE_LAST, float FRAME_DEACTIVATE_LAST, void() fire_func) Weapon_Generic =
{
	local float n;
	local float FRAME_FIRE_FIRST;
	local float FRAME_IDLE_FIRST;
	local float FRAME_DEACTIVATE_FIRST;
	
	FRAME_FIRE_FIRST = FRAME_ACTIVATE_LAST + 1;
	FRAME_IDLE_FIRST = FRAME_FIRE_LAST + 1;
	FRAME_DEACTIVATE_FIRST = FRAME_IDLE_LAST + 1;
	
	//if(self.deadflag || self.modelindex != 255) // VWep animations screw up corpses
	//{
	//	return;
	//}

	if (self.weaponstate == WEAPON_DROPPING)
	{
		if (self.weaponframe == FRAME_DEACTIVATE_LAST)
		{
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

	if (self.weapon_next && self.weaponstate != WEAPON_FIRING)
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
		if ( self.button0 )
		{
			//ent->client->latched_buttons &= ~BUTTON_ATTACK;
			self.button0 = 0;
			if ( !self.ammo_index || W_Ammo_Amount(self.ammo_index) >= self.weapon_ammo_min)	//ent->client->pers.weapon->quantity
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
				W_NoAmmoWeaponChange();
			}
		}
		else
		{
			if (self.weaponframe == FRAME_IDLE_LAST)
			{
				self.weaponframe = FRAME_IDLE_FIRST;
				return;
			}
			if (self.weapon_pause_frames)
			{
				if(self.weapon_pause_frames()){
					if (random() > 0.2)
						return;
				}
			}
			self.weaponframe++;
			doWeaponframes();
			return;
		}
	}

	if (self.weaponstate == WEAPON_FIRING)
	{
		if(self.weapon_fire_frames){
			if(self.weapon_fire_frames()){
				fire_func();
			}
		}
		/*for (n = 0; n < frames.fire_frames.length; n++)
		{
			if (self.weaponframe == fire_frames[n])
			{
				//TODO - quad damage
				//if (ent->client->quad_framenum > level.framenum)
					//gi.sound(ent, CHAN_ITEM, gi.soundindex("items/damage3.wav"), 1, ATTN_NORM, 0);

				
				break;
			}
		}*/
		if(self.weapon_fire_frames){
			if(!self.weapon_fire_frames()){
				self.weaponframe++;
			}
		}
		
		if (self.weaponframe == FRAME_IDLE_FIRST+1)
			self.weaponstate = WEAPON_READY;
	}
}

void() Weapon_Blaster_Fire=
{
	local float		damage;

	if (deathmatch)
		damage = 15;
	else
		damage = 10;
	
	fire_blaster_base(self.origin, self.v_angle, 800, damage, 200, 100, 200);
	
	sound (self, CHAN_WEAPON, "weapons/BLASTF1A.WAV", 1, ATTN_NORM);
	self.weaponframe++;
}
void() weapon_blaster_update={
	Weapon_Generic(4, 8, 52, 55, Weapon_Blaster_Fire );
};


void() Weapon_Shotgun_Fire={
	local vector start;
	local float kick, damage;
	
	damage = 4;
	kick = 8;

	if (self.weaponframe == 9)
	{
		sound(self, CHAN_AUTO, "weapons/Shotgr1b.wav", 1, ATTN_NORM);
		self.weaponframe++;
		return;
	}

	//VectorScale (forward, -2, ent->client->kick_origin);
	//ent->client->kick_angles[0] = -2;
	
	
	if (self.super_damage_finished > time)
	{
		damage *= 4;
		kick *= 4;
	}
	
	fire_shotgun_base(self.origin, self.v_angle, 6, '0.06 0.06', damage);
	
	self.punchangle_x = random() * kick;

	//if (deathmatch->value)
	//	fire_shotgun (ent, start, forward, damage, kick, 500, 500, DEFAULT_DEATHMATCH_SHOTGUN_COUNT, MOD_SHOTGUN);
	//else
	//	fire_shotgun (ent, start, forward, damage, kick, 500, 500, DEFAULT_SHOTGUN_COUNT, MOD_SHOTGUN);

	// send muzzle flash
	//gi.WriteByte (svc_muzzleflash);
	//gi.WriteShort (ent-g_edicts);
	//gi.WriteByte (MZ_SHOTGUN | is_silenced);
	//gi.multicast (ent->s.origin, MULTICAST_PVS);

	sound(self, CHAN_WEAPON, "weapons/Shotgf1b.wav", 1, ATTN_NORM);
	self.weaponframe++;

	//if (! ( (int)dmflags->value & DF_INFINITE_AMMO ) )
	self.inv_ammo_shells = max(self.inv_ammo_shells - 1, 0);
	self.currentammo = W_Ammo_Amount(self.ammo_index);
};

void() weapon_shotgun_update={

	Weapon_Generic (7, 18, 36, 39, Weapon_Shotgun_Fire);
};

void() Weapon_SuperShotgun={

	local vector v, left, right;
	local float damage, kick;
	damage = 6;
	kick = 12;
	
	
	self.punchangle_x = -2;
	
	if (self.super_damage_finished > time){
		damage *= 4;
		kick *= 4;
	}
	//TODO - muzzle flash
	sound (self ,CHAN_WEAPON, "weapons/Sshotf1b.wav", 1, ATTN_NORM);
	
	makevectors(self.v_angle);
	left = self.origin + (v_right * -5);
	right = self.origin + (v_right * 5);
	
	fire_shotgun_base(left, self.v_angle, 6, '0.08 0.06', damage);
	fire_shotgun_base(right, self.v_angle, 6, '0.08 0.06', damage);
	
	self.weaponframe++;

	//TODO - infinite ammo flag?
	//if (! ( (int)dmflags->value & DF_INFINITE_AMMO ) )
	self.inv_ammo_shells = max(self.inv_ammo_shells - 2,0);
	self.currentammo = self.inv_ammo_shells;
	//TODO - ammo decrementing
};
void() weapon_supershotg_update={

	Weapon_Generic (6, 17, 57, 61, Weapon_SuperShotgun);
};

void() Weapon_MachineGun_Fire={
	
	//local vector start, offset;
	local float i, damage, kick, cone, sfx;
	
	damage = 8;
	kick = 2;
	
	if (!self.button0)
	{
		self.machinegun_shots = 0;
		self.weaponframe++;
		return;
	}

	if (self.weaponframe == 5)
		self.weaponframe = 4;
	else
		self.weaponframe = 5;

	if ( W_Ammo_Amount(self.ammo_index) < 1)
	{
		self.weaponframe = 6;
		/*if (level.time >= ent->pain_debounce_time)
		{
			gi.sound(ent, CHAN_VOICE, gi.soundindex("weapons/noammo.wav"), 1, ATTN_NORM, 0);
			ent->pain_debounce_time = level.time + 1;
		}*/
		W_NoAmmoWeaponChange ();
		return;
	}

	if (self.super_damage_finished > time)
	{
		damage *= 4;
		kick *= 4;
	}

	for (i=1 ; i<3 ; i++)
	{
		//ent->client->kick_origin[i] = crandom() * 0.35;
		if(i==1){
			self.punchangle_y = crandom() * 0.7;
		}
		else if(i==2){
			self.punchangle_z = crandom() * 0.7;
		}
	}
	//ent->client->kick_origin[0] = crandom() * 0.35;
	
	//note: this is "the" signature machine gun vertical kick...which is dumb in single player unless balance.
		//for now, we ain't using it. - Subject9x
	//self.punchangle_x = self.machinegun_shots * -1.5;
	
	
	// raise the gun as it is firing
	if (!deathmatch)
	{
		self.machinegun_shots++;
		if (self.machinegun_shots > 9)
			self.machinegun_shots = 9;
	}
	
	cone = self.machinegun_shots / 9;
	
	//Aim is all over the place? Reverted back to FireBullet for now.
	
//	fire_bullet_base(self.origin, self.v_angle, '0.02 0.02 0' * cone, damage);
	FireBullet(damage);
	
	sfx = random() * 1.0;
	if(sfx < 0.3){
		sound(self, CHAN_AUTO, "weapons/Machgf1b.wav", 1.0, ATTN_NORM);
	}
	else if(sfx < 0.5){
		sound(self, CHAN_AUTO, "weapons/Machgf2b.wav", 1.0, ATTN_NORM);
	}
	else if(sfx < 0.7){
		sound(self, CHAN_AUTO, "weapons/Machgf3b.wav", 1.0, ATTN_NORM);
	}
	else if(sfx < 0.9){
		sound(self, CHAN_AUTO, "weapons/Machgf4b.wav", 1.0, ATTN_NORM);
	}
	else{
		sound(self, CHAN_AUTO, "weapons/Machgf5b.wav", 1.0, ATTN_NORM);
	}
	
	// get start / end positions
	/*VectorAdd (ent->client->v_angle, ent->client->kick_angles, angles);
	AngleVectors (angles, forward, right, NULL);
	VectorSet(offset, 0, 8, ent->viewheight-8);
	P_ProjectSource (ent->client, ent->s.origin, offset, forward, right, start);
	fire_bullet (ent, start, forward, damage, kick, DEFAULT_BULLET_HSPREAD, DEFAULT_BULLET_VSPREAD, MOD_MACHINEGUN);

	gi.WriteByte (svc_muzzleflash);
	gi.WriteShort (ent-g_edicts);
	gi.WriteByte (MZ_MACHINEGUN | is_silenced);
	gi.multicast (ent->s.origin, MULTICAST_PVS);

	PlayerNoise(ent, start, PNOISE_WEAPON);
*/
	//if (! ( (int)dmflags->value & DF_INFINITE_AMMO ) )
	self.inv_ammo_bullets = max(self.inv_ammo_bullets - 1, 0);
	self.currentammo = W_Ammo_Amount(self.ammo_index);
	/*ent->client->anim_priority = ANIM_ATTACK;
	if (ent->client->ps.pmove.pm_flags & PMF_DUCKED)
	{
		ent->s.frame = FRAME_crattak1 - (int) (random()+0.25);
		ent->client->anim_end = FRAME_crattak9;
	}
	else
	{
		ent->s.frame = FRAME_attack1 - (int) (random()+0.25);
		ent->client->anim_end = FRAME_attack8;
	}*/
};
void() weapon_machineg_update={

	Weapon_Generic (3, 5, 45, 49, Weapon_MachineGun_Fire);
};


void() Weapon_Chaingun_Fire={
	local float i, shots, damage, kick, r, u, sfx;
	kick = 2;
	
	if (deathmatch)
		damage = 6;
	else
		damage = 8;

	if (self.weaponframe == 5)
		sound(self, CHAN_WEAPON, "weapons/chngnu1a.wav", 0.5, ATTN_IDLE);

	if (self.weaponframe == 14 && !self.button0)
	{
		sound(self, CHAN_WEAPON2, "weapons/noammo.wav", 0.1, ATTN_IDLE);
		self.weaponframe = 32;
		//ent->client->weapon_sound = 0;
		return;
	}
	else if (self.weaponframe == 21 && self.button0 && W_Ammo_Amount(self.ammo_index))
	{
		self.weaponframe = 15;
	}
	else
	{
		self.weaponframe++;
	}

	if (self.weaponframe == 22)
	{
		//ent->client->weapon_sound = 0;
		sound(self, CHAN_WEAPON2, "weapons/noammo.wav", 1, ATTN_IDLE);
		sound(self, CHAN_WEAPON, "weapons/chngnd1a.wav", 1, ATTN_IDLE);
	}
	else
	{
		//ent->client->weapon_sound = gi.soundindex("weapons/chngnl1a.wav");
		sound(self, CHAN_WEAPON, "", 1, ATTN_IDLE);
		sound(self, CHAN_WEAPON2, "weapons/chngnl1a.wav", 1, ATTN_IDLE);
	}

	//ent->client->anim_priority = ANIM_ATTACK;
	/*if (ent->client->ps.pmove.pm_flags & PMF_DUCKED)
	{
		ent->s.frame = FRAME_crattak1 - (ent->client->ps.gunframe & 1);
		ent->client->anim_end = FRAME_crattak9;
	}
	else
	{
		ent->s.frame = FRAME_attack1 - (ent->client->ps.gunframe & 1);
		ent->client->anim_end = FRAME_attack8;
	}*/

	if (self.weaponframe <= 9)
		shots = 1;
	else if (self.weaponframe <= 14)
	{
		if (self.button0)
			shots = 2;
		else
			shots = 1;
	}
	else
		shots = 3;

	if (W_Ammo_Amount(self.ammo_index) < shots)
		shots = W_Ammo_Amount(self.ammo_index);

	if (!shots)
	{
		/*if (level.time >= ent->pain_debounce_time)
		{
			gi.sound(ent, CHAN_VOICE, gi.soundindex("weapons/noammo.wav"), 1, ATTN_NORM, 0);
			ent->pain_debounce_time = level.time + 1;
		}*/
		W_NoAmmoWeaponChange ();
		return;
	}

	if (self.super_damage_finished > time)
	{
		damage *= 4;
		kick *= 4;
	}
	
	for (i=0 ; i<3 ; i = i + 1)
	{
		//ent->client->kick_origin[i] = crandom() * 0.35;
		//ent->client->kick_angles[i] = crandom() * 0.7;
		if(i == 0){
			self.punchangle_x = crandom() * 0.7;
		}
		else if(i == 1){
			self.punchangle_y = crandom() * 0.7;
		}
		else{
			self.punchangle_z = crandom() * 0.7;
		}
	}

	for (i=0 ; i < shots ; i=i+1)
	{
		// get start / end positions
		//AngleVectors (ent->client->v_angle, forward, right, up);
		//r = 7 + crandom()*4;
		//u = crandom()*4;
		//VectorSet(offset, 0, r, u + ent->viewheight-8);
		//P_ProjectSource (ent->client, ent->s.origin, offset, forward, right, start);

		//fire_bullet (ent, start, forward, damage, kick, DEFAULT_BULLET_HSPREAD, DEFAULT_BULLET_VSPREAD, MOD_CHAINGUN);
		fire_bullet_base(self.origin, self.v_angle, '0.02 0.02', damage);
	}
	sfx = random() * 1.0;
	if(sfx < 0.3){
		sound(self, CHAN_AUTO, "weapons/Machgf1b.wav", 1.0, ATTN_NORM);
	}
	else if(sfx < 0.5){
		sound(self, CHAN_AUTO, "weapons/Machgf2b.wav", 1.0, ATTN_NORM);
	}
	else if(sfx < 0.7){
		sound(self, CHAN_AUTO, "weapons/Machgf3b.wav", 1.0, ATTN_NORM);
	}
	else if(sfx < 0.9){
		sound(self, CHAN_AUTO, "weapons/Machgf4b.wav", 1.0, ATTN_NORM);
	}
	else{
		sound(self, CHAN_AUTO, "weapons/Machgf5b.wav", 1.0, ATTN_NORM);
	}

	// send muzzle flash
	//WriteByte (svc_muzzleflash);
	//WriteShort (ent-g_edicts);
	//WriteByte ((MZ_CHAINGUN1 + shots - 1) | is_silenced);
	//multicast (ent->s.origin, MULTICAST_PVS);

	//PlayerNoise(ent, start, PNOISE_WEAPON);

	//if (! ( (int)dmflags->value & DF_INFINITE_AMMO ) )
	//ent->client->pers.inventory[ent->client->ammo_index] -= shots;
	self.inv_ammo_bullets = max(self.inv_ammo_bullets - shots, 0);
	self.currentammo = W_Ammo_Amount(self.ammo_index);

};

void() weapon_chaingun_update={

	Weapon_Generic (4, 31, 61, 64, Weapon_Chaingun_Fire);
};

void() Weapon_GrenadeLauncher_Fire={
	local float radius, damage;
	local vector offset, start;

	//simply does the ka-chunk sound of reload
	if(self.weaponframe == 9){
		sound(self, CHAN_AUTO, "weapons/Grenlr1b.WAV", 0.6, ATTN_NORM);
		self.weaponframe++;
		return;
	}
	
	damage = 120;
	
	radius = damage+40;
	if (self.super_damage_finished > time)
		damage *= 4;
	
	self.punchangle_x = -1;
	fire_grenade_base(self.origin, self.v_angle, damage, '700 250 0', 2.5, radius);
	
	//gi.WriteByte (svc_muzzleflash);
	//gi.WriteShort (ent-g_edicts);
	//gi.WriteByte (MZ_GRENADE | is_silenced);
	//gi.multicast (ent->s.origin, MULTICAST_PVS);
	sound(self, CHAN_WEAPON, "weapons/GRENLF1A.WAV", 1.0, ATTN_NORM);
	
	self.weaponframe++;
	
	//if (! ( (int)dmflags->value & DF_INFINITE_AMMO ) )
	self.inv_ammo_rockets = max(self.inv_ammo_rockets - 1, 0);
	self.currentammo = W_Ammo_Amount(self.ammo_index);
};
void() weapon_nadelaunch_update={	
	Weapon_Generic (5, 16, 59, 64, Weapon_GrenadeLauncher_Fire);
};

void() Weapon_RocketLauncher_Fire={
	local float		damage;
	local float	damage_radius;
	local float		radius_damage;
	
	if(self.weaponframe == 9){
		sound(self, CHAN_AUTO, "weapons/Rocklr1b.wav", 0.67, ATTN_NORM);
		self.weaponframe++;
		return;
	}
	
	damage = 100 + (random() * 20.0);
	radius_damage = 120;
	damage_radius = 120;
	if (self.super_damage_finished > time)
	{
		damage *= 4;
		radius_damage *= 4;
	}
	
	self.punchangle_x = -1;
	
	fire_rocket_base(self.origin, self.v_angle, damage, '1000 0 0', 5, damage_radius, radius_damage);
	
	sound(self, CHAN_WEAPON, "weapons/ROCKLF1A.WAV", 1.0, ATTN_NORM);
	
	// send muzzle flash
	
	//if (! ( (int)dmflags->value & DF_INFINITE_AMMO ) )
	self.inv_ammo_rockets = max(self.inv_ammo_rockets - 1, 0);
	self.currentammo = W_Ammo_Amount(self.ammo_index);
	self.weaponframe++;
};

void() weapon_rocketlaunch_update={

	Weapon_Generic (4, 12, 50, 54, Weapon_RocketLauncher_Fire);
};

void() Weapon_Hyperblaster_Fire={

//	local float rotation, effect, 
	local float damage;
//	local vector offset;

	//ent->client->weapon_sound = gi.soundindex("weapons/hyprbl1a.wav");
	

	if (!self.button0)
	{
		self.weaponframe++;
	}
	else
	{
		if (!W_Ammo_Amount(self.ammo_index) )
		{
			/*if (level.time >= ent->pain_debounce_time)
			{
				gi.sound(ent, CHAN_VOICE, gi.soundindex("weapons/noammo.wav"), 1, ATTN_NORM, 0);
				ent->pain_debounce_time = level.time + 1;
			}*/
			W_NoAmmoWeaponChange ();
		}
		else
		{
		/*	rotation = (self.weaponframe - 5) * 2*PI/6;
			offset_x = -4 * sin(rotation);
			offset_y = 0;
			offset_z = 4 * cos(rotation);*/

			/*if ((self.weaponframe == 6) || (self.weaponframe == 9))
				effect = EF_HYPERBLASTER;
			else
				effect = 0;
			*/
			if (deathmatch)
				damage = 15;
			else
				damage = 20;
			
			fire_blaster_base(self.origin, self.v_angle, 800, damage, 200, 100, 200);
			
			sound (self, CHAN_WEAPON, "weapons/Hyprbf1a.wav", 1, ATTN_NORM);
			sound (self, CHAN_WEAPON2, "weapons/Hyprbl1a.wav", 1, ATTN_NORM);
			
			//if (! ( (int)dmflags->value & DF_INFINITE_AMMO ) )
			self.inv_ammo_cells = max(self.inv_ammo_cells - 1, 0);
			self.currentammo = W_Ammo_Amount(self.ammo_index);

			/*ent->client->anim_priority = ANIM_ATTACK;
			if (ent->client->ps.pmove.pm_flags & PMF_DUCKED)
			{
				ent->s.frame = FRAME_crattak1 - 1;
				ent->client->anim_end = FRAME_crattak9;
			}
			else
			{
				ent->s.frame = FRAME_attack1 - 1;
				ent->client->anim_end = FRAME_attack8;
			}*/
		}

		self.weaponframe++;
		if (self.weaponframe == 12 && W_Ammo_Amount(self.ammo_index))
			self.weaponframe = 6;
	}

	if (self.weaponframe == 12)
	{
		sound(self, CHAN_WEAPON2, "weapons/hyprbd1a.wav", 1, ATTN_NORM);
		//ent->client->weapon_sound = 0;
	}

};
void() weapon_hyperb_update={

	Weapon_Generic (5, 20, 49, 53, Weapon_Hyperblaster_Fire);
};

void() Weapon_Railgun_Fire={
	local float damage, kick;
	local vector start;
	
	if (deathmatch)
	{	// normal damage is too extreme in dm
		damage = 100;
		kick = 200;
	}
	else
	{
		damage = 150;
		kick = 250;
	}

	if (self.super_damage_finished > time)
	{
		damage *= 4;
		kick *= 4;
	}

	self.punchangle_x = -3;

	makevectors(self.v_angle);
	//start = self.origin + v_forward*10;
	start = self.origin + (v_forward * 10) + (v_right * 20) + (v_up * 15);
	start_z = self.absmin_z + self.size_z * 0.7;
	fire_railgun_base(start, self.origin + (v_forward * 4096)+ PlayerViewOrg(v_up), damage);

	// send muzzle flash

	self.weaponframe++;
	
	sound(self, CHAN_WEAPON, "weapons/RAILGF1A.WAV", 1.0, ATTN_NORM);

	//if (! ( (int)dmflags->value & DF_INFINITE_AMMO ) )
	self.inv_ammo_slugs = max(self.inv_ammo_slugs - 1, 0);
	self.currentammo = W_Ammo_Amount(self.ammo_index);
};
void() weapon_railgun_update={

	Weapon_Generic (3, 18, 56, 61, Weapon_Railgun_Fire);
};

void() Weapon_BFG_Fire={
	local float damage, damage_radius;
	damage_radius = 1000;

	if (deathmatch)
		damage = 200;
	else
		damage = 500;

	if (self.weaponframe == 9)
	{
		// send muzzle flash
		/*gi.WriteByte (svc_muzzleflash);
		gi.WriteShort (ent-g_edicts);
		gi.WriteByte (MZ_BFG | is_silenced);
		gi.multicast (ent->s.origin, MULTICAST_PVS);*/

		self.weaponframe++;

		//PlayerNoise(ent, ent->s.origin, PNOISE_WEAPON);
		sound(self, CHAN_WEAPON, "weapons/Bfg__f1y.wav", 1.0, ATTN_NORM);
		return;
	}

	// cells can go down during windup (from power armor hits), so
	// check again and abort firing if we don't have enough now
	if (W_Ammo_Amount(self.ammo_index)< 50)
	{
		self.weaponframe++;
		return;
	}

	if (self.super_damage_finished > time)
		damage *= 4;

	/*AngleVectors (ent->client->v_angle, forward, right, NULL);

	VectorScale (forward, -2, ent->client->kick_origin);

	// make a big pitch kick with an inverse fall
	ent->client->v_dmg_pitch = -40;
	ent->client->v_dmg_roll = crandom()*8;
	ent->client->v_dmg_time = level.time + DAMAGE_TIME;

	VectorSet(offset, 8, 8, ent->viewheight-8);
	P_ProjectSource (ent->client, ent->s.origin, offset, forward, right, start);
	fire_bfg (ent, start, forward, damage, 400, damage_radius);*/
	
	fire_bfg_base(self.origin, self.v_angle, 400, damage, damage_radius);
	self.weaponframe++;

	//PlayerNoise(ent, start, PNOISE_WEAPON);

	//if (! ( (int)dmflags->value & DF_INFINITE_AMMO ) )
	self.inv_ammo_cells = max(self.inv_ammo_cells - 50, 0);
	self.currentammo = W_Ammo_Amount(self.ammo_index);
};

void() weapon_bfg_update={

	Weapon_Generic (8, 32, 54, 58, Weapon_BFG_Fire);
};
