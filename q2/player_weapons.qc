/*
  Q2-style weapon system complete with states


*/

void() weapon_frames_blaster_attack;
void() weapon_frames_shotgun_attack;
void() weapon_frames_supershot_attack;
void() weapon_frames_machineg_attack;
void() weapon_frames_chaingun_attack;
void() weapon_frames_nadelaunch_attack;
void() weapon_frames_rocketlaunch_attack;
void() weapon_frames_hyperb_attack;
void() weapon_frames_rail_attack;
void() weapon_frames_bfg_attack;


void() weapon_state_idle={

	if( self.weapon_anim_start ){
		self.weapon_anim_start = FALSE;
		
		switch(self.weapon){
			case WEP_BLASTER:
				if(crandom() > 0.4){
						self.weaponframe = WEP_BLASTER_IDLE1_FIRSTFRAME;
						self.weapon_frame_end = WEP_BLASTER_IDLE1_LASTFRAME;
					}
					else{
						self.weaponframe = WEP_BLASTER_IDLE2_FIRSTFRAME;
						self.weapon_frame_end = WEP_BLASTER_IDLE2_LASTFRAME;
					}
				break;
			case WEP_SHOTGUN:
				self.weaponframe = WEP_SHOTGUN_IDLE1_FIRSTFRAME;
				self.weapon_frame_end = WEP_SHOTGUN_IDLE1_LASTFRAME;
				break;
			case WEP_SUPERSHOTGUN:
				self.weaponframe = WEP_SUPERSHOTGUN_IDLE1_FIRSTFRAME;
				self.weapon_frame_end = WEP_SUPERSHOTGUN_IDLE1_LASTFRAME;
				break;
			case WEP_MACHINEGUN:
				self.weaponframe = WEP_MACHINEGUN_IDLE1_FIRSTFRAME;
				self.weapon_frame_end = WEP_MACHINEGUN_IDLE1_LASTFRAME;
				break;
			case WEP_CHAINGUN:
				self.weaponframe = WEP_CHAINGUN_IDLE1_FIRSTFRAME;
				self.weapon_frame_end = WEP_CHAINGUN_IDLE1_LASTFRAME;
				break;
			case WEP_GRENADE_LAUNCHER:
				self.weaponframe = WEP_NADELAUNCH_IDLE1_FIRSTFRAME;
				self.weapon_frame_end = WEP_NADELAUNCH_IDLE1_LASTFRAME;
				break;
			case WEP_ROCKET_LAUNCHER:
				self.weaponframe = WEP_ROCKETLAUNCH_IDLE1_FIRSTFRAME;
				self.weapon_frame_end = WEP_ROCKETLAUNCH_IDLE1_LASTFRAME;
				break;
			case WEP_HYPERBLASTER:
				self.weaponframe = WEP_HYPERBLAST_IDLE1_FIRSTFRAME;
				self.weapon_frame_end = WEP_HYPERBLAST_IDLE1_LASTFRAME;
				break;
			case WEP_RAILGUN:
				self.weaponframe = WEP_RAILGUN_IDLE1_FIRSTFRAME;
				self.weapon_frame_end = WEP_RAILGUN_IDLE1_LASTFRAME;
				break;
			case WEP_BFG:
				self.weaponframe = WEP_BFG_IDLE1_FIRSTFRAME;
				self.weapon_frame_end = WEP_BFG_IDLE1_LASTFRAME;
				break;
		}
	}

	if( time > self.weapon_think){
		self.weapon_think = time + 0.1;
		if(self.weaponframe == self.weapon_frame_end){
			//simply loop animation here
			if(self.weaponstate_next == WEAPON_READY){
				self.weapon_anim_start = TRUE;
			}
			return;
		}
		self.weaponframe++;
	}
};

void() weapon_state_putaway={

	if(self.weapon_anim_start == TRUE){
		self.weapon_anim_start = FALSE;
		self.weapon_state_attack_frames = SUB_Null;
		switch(self.weapon){
			case WEP_BLASTER:
				self.weaponframe = WEP_BLASTER_AWAY_FIRSTFRAME;
				self.weapon_frame_end = WEP_BLASTER_AWAY_LASTFRAME;
				break;
			case WEP_SHOTGUN:
				self.weaponframe = WEP_SHOTGUN_AWAY_FIRSTFRAME;
				self.weapon_frame_end = WEP_SHOTGUN_AWAY_LASTFRAME;
				break;
			case WEP_SUPERSHOTGUN:
				self.weaponframe = WEP_SUPERSHOTGUN_AWAY_FIRSTFRAME;
				self.weapon_frame_end = WEP_SUPERSHOTGUN_AWAY_LASTFRAME;
				break;
			case WEP_MACHINEGUN:
				self.weaponframe = WEP_MACHINEGUN_AWAY_FIRSTFRAME;
				self.weapon_frame_end = WEP_MACHINEGUN_AWAY_LASTFRAME;
				break;
			case WEP_CHAINGUN:
				self.weaponframe = WEP_CHAINGUN_AWAY_FIRSTFRAME;
				self.weapon_frame_end = WEP_CHAINGUN_AWAY_LASTFRAME;
				break;
			case WEP_GRENADE_LAUNCHER:
				self.weaponframe = WEP_NADELAUNCH_AWAY_FIRSTFRAME;
				self.weapon_frame_end = WEP_NADELAUNCH_AWAY_LASTFRAME;
				break;
			case WEP_ROCKET_LAUNCHER:
				self.weaponframe = WEP_ROCKETLAUNCH_AWAY_FIRSTFRAME;
				self.weapon_frame_end = WEP_ROCKETLAUNCH_AWAY_LASTFRAME;
				break;
			case WEP_HYPERBLASTER:
				self.weaponframe = WEP_HYPERBLAST_AWAY_FIRSTFRAME;
				self.weapon_frame_end = WEP_HYPERBLAST_AWAY_LASTFRAME;
				break;
			case WEP_RAILGUN:
				self.weaponframe = WEP_RAILGUN_AWAY_FIRSTFRAME;
				self.weapon_frame_end = WEP_RAILGUN_AWAY_LASTFRAME;
				break;
			case WEP_BFG:
				self.weaponframe = WEP_BFG_AWAY_FIRSTFRAME;
				self.weapon_frame_end = WEP_BFG_AWAY_LASTFRAME;
				break;
		}
	}

	if( time > self.weapon_think){
		self.weapon_think = time + 0.1;
		if(self.weaponframe == self.weapon_frame_end){
			self.weaponstate_next = WEAPON_ACTIVATING;
			return;
		}
		self.weaponframe++;
	}
};


/*
  self.weapon = old weapon
  self.weapon_next = next weapon
*/
void() weapon_state_activate={
	local string readySfx;
	
	//detect initial state change
	if(self.weapon_anim_start == TRUE){
		self.weapon_anim_start = FALSE;
		self.weapon = self.weapon_next;
		self.weapon_next = 0; //make sure we clear this out.
		W_SetCurrentAmmo ();
		switch(self.weapon){
			case WEP_BLASTER:
				readySfx = "weapons/HGRENT1A.WAV";
				self.weaponmodel = "models/weapons/v_blast/tris.md2";
				self.weaponframe = WEP_BLASTER_ACTIVE_FIRSTFRAME;
				self.weapon_frame_end = WEP_BLASTER_ACTIVE_LASTFRAME;
				break;
			case WEP_SHOTGUN:
				readySfx = "weapons/Shotgr1b.wav";
				self.weaponmodel = "models/weapons/v_shotg/tris.md2";
				self.weaponframe = WEP_SHOTGUN_ACTIVE_FIRSTFRAME;
				self.weapon_frame_end = WEP_SHOTGUN_ACTIVE_LASTFRAME;
				self.currentammo = self.ammo_shells;
				break;
			case WEP_SUPERSHOTGUN:
				readySfx = "weapons/HGRENT1A.WAV";
				self.weaponmodel = "models/weapons/v_shotg2/tris.md2";
				self.weaponframe = WEP_SUPERSHOTGUN_ACTIVE_FIRSTFRAME;
				self.weapon_frame_end = WEP_SUPERSHOTGUN_ACTIVE_LASTFRAME;
				self.currentammo = self.ammo_shells;
				break;
			case WEP_MACHINEGUN:
				readySfx = "weapons/HGRENT1A.WAV";
				self.weaponmodel = "models/weapons/v_machn/tris.md2";
				self.weaponframe = WEP_MACHINEGUN_ACTIVE_FIRSTFRAME;
				self.weapon_frame_end = WEP_MACHINEGUN_ACTIVE_LASTFRAME;
				self.currentammo = self.inv_ammo_bullets;
				break;
			case WEP_CHAINGUN:
			 readySfx = "weapons/HGRENT1A.WAV";
				self.weaponmodel = "models/weapons/v_chain/tris.md2";
				self.weaponframe = WEP_CHAINGUN_ACTIVE_FIRSTFRAME;
				self.weapon_frame_end = WEP_CHAINGUN_ACTIVE_LASTFRAME;
				self.currentammo = self.inv_ammo_bullets;
				break;
			case WEP_GRENADE_LAUNCHER:
				readySfx = "weapons/HGRENT1A.WAV";
				self.weaponmodel = "models/weapons/v_launch/tris.md2";
				self.weaponframe = WEP_NADELAUNCH_ACTIVE_FIRSTFRAME;
				self.weapon_frame_end = WEP_NADELAUNCH_ACTIVE_LASTFRAME;
				self.currentammo = self.ammo_rockets;
				break;
			case WEP_ROCKET_LAUNCHER:
				readySfx = "weapons/HGRENT1A.WAV";
				self.weaponmodel = "models/weapons/v_rocket/tris.md2";
				self.weaponframe = WEP_ROCKETLAUNCH_ACTIVE_FIRSTFRAME;
				self.weapon_frame_end = WEP_ROCKETLAUNCH_ACTIVE_LASTFRAME;
				self.currentammo = self.ammo_rockets;
				break;
			case WEP_HYPERBLASTER:
				readySfx = "weapons/HGRENT1A.WAV";
				self.weaponmodel = "models/weapons/v_hyperb/tris.md2";
				self.weaponframe = WEP_HYPERBLAST_ACTIVE_FIRSTFRAME;
				self.weapon_frame_end = WEP_HYPERBLAST_ACTIVE_LASTFRAME;
				self.currentammo = self.ammo_cells;
				break;
			case WEP_RAILGUN:
				readySfx = "weapons/HGRENT1A.WAV";
				self.weaponmodel = "models/weapons/v_rail/tris.md2";
				self.weaponframe = WEP_RAILGUN_ACTIVE_FIRSTFRAME;
				self.weapon_frame_end = WEP_RAILGUN_ACTIVE_LASTFRAME;
				self.currentammo = self.ammo_cells;
				break;
			case WEP_BFG:
				readySfx = "weapons/HGRENT1A.WAV";
				self.weaponmodel = "models/weapons/v_bfg/tris.md2";
				self.weaponframe = WEP_BFG_ACTIVE_FIRSTFRAME;
				self.weapon_frame_end = WEP_BFG_ACTIVE_LASTFRAME;
				self.currentammo = self.ammo_cells;
				break;
		}
		sound(self, CHAN_WEAPON, readySfx, 0.5, ATTN_IDLE);
	}

	if( time > self.weapon_think){
		self.weapon_think = time + 0.1;
		if(self.weaponframe == self.weapon_frame_end){
			self.weaponstate_next = WEAPON_READY;
			return;
		}
		self.weaponframe++;
	}  
};


void() weapon_state_fire={
  
	if(self.weapon_anim_start == TRUE){
		self.weapon_anim_start = FALSE;
		self.weapon_state_attack_frames = SUB_Null;
		switch(self.weapon){
			case WEP_BLASTER:
				self.weaponframe = WEP_BLASTER_FIRE_FIRSTFRAME;
				self.weapon_frame_end = WEP_BLASTER_FIRE_LASTFRAME;
				self.weapon_state_attack_frames = weapon_frames_blaster_attack;
				break;
			case WEP_SHOTGUN:
				self.weaponframe = WEP_SHOTGUN_FIRE_FIRSTFRAME;
				self.weapon_frame_end = WEP_SHOTGUN_FIRE_LASTFRAME;
				self.weapon_state_attack_frames = weapon_frames_shotgun_attack;
				break;
			case WEP_SUPERSHOTGUN:
				self.weaponframe = WEP_SUPERSHOTGUN_FIRE_FIRSTFRAME;
				self.weapon_frame_end = WEP_SUPERSHOTGUN_FIRE_LASTFRAME;
				self.weapon_state_attack_frames = weapon_frames_supershot_attack;
				break;
			case WEP_MACHINEGUN:
				self.weaponframe = WEP_MACHINEGUN_FIRE_FIRSTFRAME;
				self.weapon_frame_end = WEP_MACHINEGUN_FIRE_LASTFRAME;
				self.weapon_state_attack_frames = weapon_frames_machineg_attack;
				break;
			case WEP_CHAINGUN:
				self.weaponframe = WEP_CHAINGUN_FIRE_FIRSTFRAME;
				self.weapon_frame_end = WEP_CHAINGUN_FIRE_LASTFRAME;
				self.weapon_state_attack_frames = weapon_frames_chaingun_attack;
				break;
			case WEP_GRENADE_LAUNCHER:
				self.weaponframe = WEP_NADELAUNCH_FIRE_FIRSTFRAME;
				self.weapon_frame_end = WEP_NADELAUNCH_FIRE_LASTFRAME;
				self.weapon_state_attack_frames = weapon_frames_nadelaunch_attack;
				break;
			case WEP_ROCKET_LAUNCHER:
				self.weaponframe = WEP_ROCKETLAUNCH_FIRE_FIRSTFRAME;
				self.weapon_frame_end = WEP_ROCKETLAUNCH_FIRE_LASTFRAME;
				self.weapon_state_attack_frames = weapon_frames_rocketlaunch_attack;
				break;
			case WEP_HYPERBLASTER:
				self.weaponframe = WEP_HYPERBLAST_FIRE_FIRSTFRAME;
				self.weapon_frame_end = WEP_HYPERBLAST_FIRE_LASTFRAME;
				self.weapon_state_attack_frames = weapon_frames_hyperb_attack;
				break;
			case WEP_RAILGUN:
				self.weaponframe = WEP_RAILGUN_FIRE_FIRSTFRAME;
				self.weapon_frame_end = WEP_RAILGUN_FIRE_LASTFRAME;
				self.weapon_state_attack_frames = weapon_frames_rail_attack;
				break;
			case WEP_BFG:
				self.weaponframe = WEP_BFG_FIRE_FIRSTFRAME;
				self.weapon_frame_end = WEP_BFG_FIRE_LASTFRAME;
				self.weapon_state_attack_frames = weapon_frames_bfg_attack;
				break;
		}
	}
	
	if( time > self.weapon_think){
		self.weapon_think = time + 0.1;
		if(self.weapon_state_attack_frames != SUB_Null){
			self.weapon_state_attack_frames();
		}
		if(self.weaponframe == self.weapon_frame_end){
			if(!W_CheckNoAmmo()){
				return;
			}
			self.weaponstate_next = WEAPON_READY;
			return;
		}
		self.weaponframe++;
	}

};

void() weapon_state_spin={

	if( time > self.weapon_think){
		self.weaponframe++;
		self.weapon_think = time + 0.1;
	}
};

/*
  Quake2 style weapons really want to be a lean state-machine, so here goes.
  
    this is controlled in a few ways -  
      1) set self.weaponstate_next to the desired next state.
      2) set
            self.weaponstate
            self.weapon
            
            directly to override the state transition
*/
void() W_WeaponAnimate={
	if(self.weaponstate != self.weaponstate_next){
		self.weaponstate = self.weaponstate_next;
		self.weapon_anim_start = TRUE;
	}
	switch(self.weaponstate){
		case WEAPON_ACTIVATING:
			weapon_state_activate();
			break;
		case WEAPON_DROPPING:
			weapon_state_putaway();
			break;
		case WEAPON_SPINDOWN:
			weapon_state_spin();
			break;
		case WEAPON_FIRING:
			weapon_state_fire();
			break;
		case WEAPON_READY:
			weapon_state_idle();
			break;
	}
	
};

/*
  Attack frames per weapon.
  
  these are set on initial WEAPON_FIRING state to weapon_state_attack_frames()
    and then are called every frame of weapon attack anim.
    
  each weapon gets their own function where we put frames the weapon cares about.
  
  I feel that each gets their own function for cleanliness - allowing edits to be contained
  to a single chunk of code at a time.
*/

void() weapon_frames_blaster_attack={
	switch (self.weaponframe)
	{
		case WEP_BLASTER_FIRE_FIRSTFRAME:
			//q2playeronly_4attackframes();
			W_FireBlaster();
		break;
	}
};

void() weapon_frames_shotgun_attack={
	switch (self.weaponframe)
	{
		case WEP_SHOTGUN_FIRE_FIRSTFRAME:
			//q2playeronly_8attackframes ();
			W_FireShotgun();
		break;
	}
};

void() weapon_frames_supershot_attack={
	switch (self.weaponframe)
	{
		case WEP_SUPERSHOTGUN_FIRE_FIRSTFRAME:
			//q2playeronly_8attackframes ();
			W_FireSuperShotgun();
		break;
	}
};

void() weapon_frames_machineg_attack={
	switch (self.weaponframe)
	{
		case WEP_MACHINEGUN_FIRE_FIRSTFRAME:
			//q2playeronly_4attackframes ();
			FireBullet(WEAPON_CHAINGUN_DAMAGE);
		break;
	}
};

void() weapon_frames_chaingun_attack={
	switch (self.weaponframe)
	{
		case WEP_CHAINGUN_FIRE_FIRSTFRAME:
			//q2playeronly_4attackframes ();
			FireBullet(WEAPON_CHAINGUN_DAMAGE);
		break;
	}
};

void() weapon_frames_nadelaunch_attack={
	switch (self.weaponframe)
	{
		case WEP_NADELAUNCH_FIRE_FIRSTFRAME:
			//q2playeronly_8attackframes ();
			W_FireGrenade();
		break;
	}
};

void() weapon_frames_rocketlaunch_attack={
	switch (self.weaponframe)
	{
		case WEP_ROCKETLAUNCH_FIRE_FIRSTFRAME:
			//q2playeronly_8attackframes ();
			W_FireRocket();
		break;
	}
};

void() weapon_frames_hyperb_attack={
	switch (self.weaponframe)
	{
		case 6:
			//q2playeronly_4attackframes ();
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
};

void() weapon_frames_rail_attack={
	switch (self.weaponframe)
	{
		case WEP_RAILGUN_FIRE_FIRSTFRAME:
			sound (self, CHAN_WEAPON, "weapons/RAILGF1A.WAV", 1, ATTN_NORM);
			//q2playeronly_8attackframes ();
			FireBullet(WEAPON_RAILGUN_DAMAGE);
			//fireRail(WEAPON_RAILGUN_DAMAGE);
		break;
	}
};

void() weapon_frames_bfg_attack={
	switch (self.weaponframe)
	{
		case 9:
			sound (self, CHAN_WEAPON, "weapons/Bfg__f1y.wav", 1, ATTN_NORM);
		break;
		case 18:
		//q2playeronly_8attackframes ();
		W_fireBFG();
		break;
	}
};