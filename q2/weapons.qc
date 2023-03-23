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
		case 4: //5
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
	if(self.weaponframe == 6)
		return TRUE;
	return FALSE;
};
/*
float() weapon_nadelaunch_fire={
	if(self.weaponframe == 6 || self.weaponframe == 9)
		return TRUE;
	return FALSE;
};
*/
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
	self.items = self.items - (self.items & (IT_SHELLS | IT_BULLETS | IT_CELLS | IT_ROCKETS | IT_SLUGS));
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
			self.items = self.items | IT_SLUGS;
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
	local string readySfx;

	if (self.grenade_time)
	{
		self.grenade_time = 0;
		self.grenade_time = 0;
	}

	self.pausemin = 50; 
	self.pausemax = 100;

	self.lastweapon = self.weapon;
	self.weapon = self.weapon_next;
	self.weapon_next = 0;
	self.machinegun_shots = 0;

	if (!self.weapon)
	{	// dead
		self.weaponmodel = "";
		return;
	}

	self.weaponstate = WEAPON_ACTIVATING;
	self.weaponframe = 0;

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
			self.weapon_ammo_min = 1;
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
void() W_WeaponAnimate =
{
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
		else if (self.items & IT_DOUBLER && self.weaponstate == WEAPON_FIRING)
		{
			self.weapon_think = time + 0.075;
		}	
		else 
		{
			self.weapon_think = time + 0.1;
		}
	self.weapon_update_func();
	}
};

void() q2playeronly_2attackframes_crouch;
void() q2playeronly_4attackframes_crouch;
void() q2playeronly_8attackframes_crouch;
void() q2playeronly_2attackframes;
void() q2playeronly_4attackframes;
void() q2playeronly_8attackframes;

/*
doPlayerframes
This is called in weapon_generic. 
It calls the appropriate player animation during WEAPON_READY/WEAPON_FIRING.
*/
void() doPlayerframes =
{
	if (self.weapon == WEP_BLASTER)
	{
		if (self.flags & FL_DUCKED){
		q2playeronly_4attackframes_crouch();
		}
		else{
		q2playeronly_4attackframes();
		}
	}
	else if (self.weapon == WEP_MACHINEGUN
	|| self.weapon == WEP_CHAINGUN 
	|| self.weapon == WEP_HYPERBLASTER)
	{
		if (self.flags & FL_DUCKED){
		q2playeronly_2attackframes_crouch();
		}
		else{
		q2playeronly_2attackframes();
		}
	}
	else
	{
		if (self.flags & FL_DUCKED){
		q2playeronly_8attackframes_crouch();
		}
		else{
		q2playeronly_8attackframes();
		}
	}
}

/*
doWeaponframes
This is called in weapon_generic. 
It could be used to call sounds, effects, etc... during a sequence.

*/
void() doWeaponfx =
{
	switch(self.weapon)
	{
	case WEP_GRENADE_LAUNCHER:
		switch(self.weaponframe)
		{
			case 9:
			sound(self, CHAN_AUTO, "weapons/Grenlr1b.WAV", 0.6, ATTN_NORM);
			break;
		}
	break;
	}
}

void q2player_wepSwitchCrouch();
void q2player_wepSwitchStand();

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

	if (self.weaponstate == WEAPON_DROPPING)
	{
		if (self.weaponframe == FRAME_DEACTIVATE_LAST)
		{
			W_ChangeWeapon();
			return;
		}
		/*
		else if ((FRAME_DEACTIVATE_LAST - self.weaponframe) == 4)
		{
			if (self.flags & FL_DUCKED)
			{
				q2player_wepSwitchCrouch();
			}
			else
			{
				q2player_wepSwitchStand();
			}
		}
		*/
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
		/*
		if ((FRAME_DEACTIVATE_LAST - FRAME_DEACTIVATE_FIRST) < 4)
		{
			//TODO - player model anim syncing

			if (self.flags & FL_DUCKED)
			{
				q2player_wepSwitchCrouch();
			}
			else
			{
				q2player_wepSwitchStand();
			}

		}
		*/
		return;
	}

	if (self.weaponstate == WEAPON_READY)
	{
		if ( self.button0 )
		{
			self.button0 = 0;
			if ( !self.ammo_index || W_Ammo_Amount(self.ammo_index) >= self.weapon_ammo_min)
			{
				self.weaponframe = FRAME_FIRE_FIRST;
				self.weaponstate = WEAPON_FIRING;

				doPlayerframes();
			}
			else
			{
				W_NoAmmoWeaponChange();
				return;
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
			
			/* 
			if (self.weapon_pause_frames)
			{
				if(self.weapon_pause_frames())
				{
					//bprint (ftos(self.idletime));
					//bprint ("\n");
					if (self.idletime >= (random() * self.pausemin) + (random() * self.pausemax))
					{
					self.idletime = 0;
					}
					else
					{
					self.idletime++;
					return;
					}
				}
			}
			*/
			self.weaponframe++;
			doWeaponfx();
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
		if(self.weapon_fire_frames){
			if(!self.weapon_fire_frames()){
				self.weaponframe++;
			}
		}
		
		if (self.weaponframe == FRAME_IDLE_FIRST+1)
			self.weaponstate = WEAPON_READY;
	}
	doWeaponfx();
}

void() Weapon_Blaster_Fire=
{
	local float		damage;

	if (deathmatch)
		damage = 15 + (self.upgrade_blaster_level * autocvar_sk_blaster_upgrade_multiplier);
	else
		damage = 10 + (self.upgrade_blaster_level * autocvar_sk_blaster_upgrade_multiplier);

	fire_blaster_base(self.origin, self.v_angle, 800, damage, 200, 100, 200);	
	//SpawnMuzzleFlash(WEP_BLASTER_MFLASH_OFFSET_FP, WEP_BLASTER_MFLASH_SCALE, 0.25);
	//SpawnMuzzleFlashTP(WEP_BLASTER_MFLASH_OFFSET_TP, 0.5);
	sound (self, CHAN_WEAPON, "weapons/BLASTF1A.WAV", 1, ATTN_NORM);
	self.weaponframe++;
}
void() weapon_blaster_update={
	Weapon_Generic(3 /*4*/, 8, 52, 55, Weapon_Blaster_Fire );
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
	
	if (self.super_damage_finished > time)
	{
		damage *= 4;
		kick *= 4;
	}
	self.solid = SOLID_BBOX;
	fire_shotgun_base(self.origin, self.v_angle, 6, '0.02 0.02', damage);
	self.solid = SOLID_SLIDEBOX;
	self.punchangle_x = random() * kick;

	SpawnMuzzleFlash(WEP_MACHINEGUN_MFLASH_OFFSET_FP, 0.5, 1);
	sound(self, CHAN_WEAPON, "weapons/Shotgf1b.wav", 1, ATTN_NORM);
	self.weaponframe++;

	self.inv_ammo_shells = max(self.inv_ammo_shells - 1, 0);
	self.currentammo = W_Ammo_Amount(self.ammo_index);
};

void() weapon_shotgun_update={

	Weapon_Generic (7, 18, 36, 39, Weapon_Shotgun_Fire);
};

/* void() Weapon_SuperShotgun={

	local vector v, left, right;
	local float damage, kick;
	damage = 6;
	kick = 12;
	
	
	self.punchangle_x = -2;
	
	if (self.super_damage_finished > time){
		damage *= 4;
		kick *= 4;
	}

	SpawnMuzzleFlash(WEP_MACHINEGUN_MFLASH_OFFSET_FP, 2, 0.45);
	sound (self ,CHAN_WEAPON, "weapons/Sshotf1b.wav", 1, ATTN_NORM);
	
	left = self.origin + (v_right * -5);
	right = self.origin + (v_right * 5);

	self.solid = SOLID_BBOX;
	fire_shotgun_base(left, self.v_angle, 6, '0.08 0.06', damage);
	fire_shotgun_base(right, self.v_angle, 6, '0.08 0.06', damage);
	self.solid = SOLID_SLIDEBOX;
	
	self.weaponframe++;

	self.inv_ammo_shells = max(self.inv_ammo_shells - 2,0);
	self.currentammo = self.inv_ammo_shells;
}; */

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

	SpawnMuzzleFlash(WEP_MACHINEGUN_MFLASH_OFFSET_FP, 2, 0.45);
	sound (self ,CHAN_WEAPON, "weapons/Sshotf1b.wav", 1, ATTN_NORM);
	
	left = self.origin + (v_right * -5);
	right = self.origin + (v_right * 5);

	if (self.inv_ammo_shells >= 2)
	{
		self.solid = SOLID_BBOX;
		fire_shotgun_base(left, self.v_angle, 6, '0.08 0.06', damage);
		fire_shotgun_base(right, self.v_angle, 6, '0.08 0.06', damage);
		self.inv_ammo_shells = max(self.inv_ammo_shells - 2,0);	
		self.solid = SOLID_SLIDEBOX;
	}
	else
	{
		self.solid = SOLID_BBOX;
		if (random() < 0.5)
		{
			fire_shotgun_base(left, self.v_angle, 6, '0.08 0.06', damage);
		}
		else
		{
			fire_shotgun_base(right, self.v_angle, 6, '0.08 0.06', damage);			
		}
		self.inv_ammo_shells = max(self.inv_ammo_shells - 1,0);	
		self.solid = SOLID_SLIDEBOX;		
	}
	self.weaponframe++;
	self.currentammo = self.inv_ammo_shells;
};
void() weapon_supershotg_update={

	Weapon_Generic (6, 17, 57, 61, Weapon_SuperShotgun);
};

void() Weapon_MachineGun_Fire =
{
	local float i, damage, kick, cone, sfx;
	
	damage = WEAPON_MACHINEGUN_DAMAGE;
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
		if(i==1){
			self.punchangle_y = crandom() * 0.7;
		}
		else if(i==2){
			self.punchangle_z = crandom() * 0.7;
		}
	}
	
	//note: this is "the" signature machine gun vertical kick...which is dumb in single player unless balance.
		//for now, we ain't using it. - Subject9x
	//self.punchangle_x = self.machinegun_shots * -1.5;
	
	// raise the gun as it is firing
	/*
	if (!deathmatch)
	{
		self.machinegun_shots++;
		if (self.machinegun_shots > 9)
			self.machinegun_shots = 9;
	}
	
	cone = self.machinegun_shots / 9;
	*/
	//Aim is all over the place? Reverted back to FireBullet for now. -MrC
//	fire_bullet_base(self.origin, self.v_angle, '0.02 0.02 0' * cone, damage);
	self.solid = SOLID_BBOX;
	FireBullet(damage);
	self.solid = SOLID_SLIDEBOX;
	
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
	
	self.inv_ammo_bullets = max(self.inv_ammo_bullets - 1, 0);
	self.currentammo = W_Ammo_Amount(self.ammo_index);
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
		sound(self, CHAN_WEAPON2, "weapons/noammo.wav", 1, ATTN_IDLE);
		sound(self, CHAN_WEAPON, "weapons/chngnd1a.wav", 1, ATTN_IDLE);
	}
	else
	{
		sound(self, CHAN_WEAPON, "", 1, ATTN_IDLE);
		sound(self, CHAN_WEAPON2, "weapons/chngnl1a.wav", 1, ATTN_IDLE);
	}

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
		self.solid = SOLID_BBOX;
		//fire_bullet_base(self.origin, self.v_angle, '0.02 0.02', damage);
		FireBullet(damage);
		self.solid = SOLID_SLIDEBOX;
		SpawnMuzzleFlash(WEP_MACHINEGUN_MFLASH_OFFSET_FP, 0.50, 0.65);		
		SpawnMuzzleFlash(WEP_MACHINEGUN_MFLASH_OFFSET_FP, 1.35, 0.25);
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

	self.inv_ammo_bullets = max(self.inv_ammo_bullets - shots, 0);
	self.currentammo = W_Ammo_Amount(self.ammo_index);

};

void() weapon_chaingun_update={

	Weapon_Generic (4, 31, 61, 64, Weapon_Chaingun_Fire);
};

void() Weapon_GrenadeLauncher_Fire={
	local float radius, damage;
	local vector offset, start;

	//MrC: moved this to doWeaponframes since it's just playing a sound, so far no noticable issues.	
	//simply does the ka-chunk sound of reload
	/*
	if(self.weaponframe == 9){
		sound(self, CHAN_AUTO, "weapons/Grenlr1b.WAV", 0.6, ATTN_NORM);
		self.weaponframe++;
		return;
	}
	*/
	damage = 120;
	
	radius = damage+40;
	if (self.super_damage_finished > time)
		damage *= 4;
	
	self.punchangle_x = -1;
	fire_grenade_base(self.origin, self.v_angle, damage, '700 250 0', 2.5, radius);
	
	sound(self, CHAN_WEAPON, "weapons/GRENLF1A.WAV", 1.0, ATTN_NORM);
	
	self.weaponframe++;
	
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
	
	self.inv_ammo_rockets = max(self.inv_ammo_rockets - 1, 0);
	self.currentammo = W_Ammo_Amount(self.ammo_index);
	self.weaponframe++;
};

void() weapon_rocketlaunch_update={

	Weapon_Generic (4, 12, 50, 54, Weapon_RocketLauncher_Fire);
};

void() Weapon_Hyperblaster_Fire =
{
	local float damage;

	if (!self.button0)
	{
		self.weaponframe++;
	}
	else
	{
		if (!W_Ammo_Amount(self.ammo_index) )
		{
			W_NoAmmoWeaponChange ();
		}
		else
		{
			if (deathmatch)
				damage = 15;
			else
				damage = 20;
			
			fire_blaster_base(self.origin, self.v_angle, 800, damage, 200, 100, 200);
			self.shotcount++;
			//SpawnMuzzleFlash(WEP_BLASTER_MFLASH_OFFSET_FP, WEP_BLASTER_MFLASH_SCALE, 0.5);
			//SpawnMuzzleFlashTP(WEP_BLASTER_MFLASH_OFFSET_TP, 0.5);
			sound (self, CHAN_WEAPON, "weapons/Hyprbf1a.wav", 1, ATTN_NORM);
			sound (self, CHAN_WEAPON2, "weapons/Hyprbl1a.wav", 1, ATTN_NORM);
			
			self.inv_ammo_cells = max(self.inv_ammo_cells - 1, 0);
			self.currentammo = W_Ammo_Amount(self.ammo_index);
		}

		self.weaponframe++;
		if (self.weaponframe == 12 && W_Ammo_Amount(self.ammo_index))
			self.weaponframe = 6;
	}

	if (self.weaponframe == 12)
	{
		sound(self, CHAN_WEAPON2, "weapons/hyprbd1a.wav", 1, ATTN_NORM);
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

	start = self.origin + (v_forward * 10) + (v_right * 5) + (v_up * 5);
	start_z = self.absmin_z + self.size_z * 0.7;
	
	self.solid = SOLID_BBOX;
	fire_railgun_base(start, ((self.origin + (v_forward * 4096)) + (PlayerViewOrg(v_up))), damage);
	self.solid = SOLID_SLIDEBOX;

	self.weaponframe++;
	
	sound(self, CHAN_WEAPON, "weapons/RAILGF1A.WAV", 1.0, ATTN_NORM);

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
		self.weaponframe++;

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

	fire_bfg_base(self.origin, self.v_angle, 400, damage, damage_radius);
	self.weaponframe++;

	self.inv_ammo_cells = max(self.inv_ammo_cells - 50, 0);
	self.currentammo = W_Ammo_Amount(self.ammo_index);
};

void() weapon_bfg_update={

	Weapon_Generic (8, 32, 54, 58, Weapon_BFG_Fire);
};
