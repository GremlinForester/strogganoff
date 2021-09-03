/*
	Straight port of Q2's p_weapon file.
		adapted to QuakeC.
*/

//attack funcs return bool TRUE/FALSE if thge attack funcs
//	took control of the attack state.
float() weapon_frames_blaster_attack;
float() weapon_frames_shotgun_attack;
float() weapon_frames_supershot_attack;
float() weapon_frames_machineg_attack;
float() weapon_frames_chaingun_attack;
float() weapon_frames_nadelaunch_attack;
float() weapon_frames_rocketlaunch_attack;
float() weapon_frames_hyperb_attack;
float() weapon_frames_rail_attack;
float() weapon_frames_bfg_attack;


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
	local float override;
	if(self.weapon_anim_start == TRUE){
		self.weapon_anim_start = FALSE;
		self.weapon_state_attack_frames = SUB_Null;
		self.weapon_has_spin = FALSE;
		switch(self.weapon){
			case WEP_BLASTER:
				self.weaponframe = WEP_BLASTER_FIRE_FIRSTFRAME;
				self.weapon_frame_end = WEP_BLASTER_FIRE_LASTFRAME;
				self.weapon_state_attack_frames = weapon_frames_blaster_attack;
				self.attack_finished = time + WEP_BLASTER_ATTACKTIME;
				break;
			case WEP_SHOTGUN:
				self.weaponframe = WEP_SHOTGUN_FIRE_FIRSTFRAME;
				self.weapon_frame_end = WEP_SHOTGUN_FIRE_LASTFRAME;
				self.weapon_state_attack_frames = weapon_frames_shotgun_attack;
				self.attack_finished = time + WEP_SHOTGUN_ATTACKTIME;
				break;
			case WEP_SUPERSHOTGUN:
				self.weaponframe = WEP_SUPERSHOTGUN_FIRE_FIRSTFRAME;
				self.weapon_frame_end = WEP_SUPERSHOTGUN_FIRE_LASTFRAME;
				self.weapon_state_attack_frames = weapon_frames_supershot_attack;
				self.attack_finished = time + WEP_SUPERSHOTGUN_ATTACKTIME;
				break;
			case WEP_MACHINEGUN:
				self.weaponframe = WEP_MACHINEGUN_FIRE_FIRSTFRAME;
				self.weapon_frame_end = WEP_MACHINEGUN_FIRE_LASTFRAME;
				self.weapon_state_attack_frames = weapon_frames_machineg_attack;
				self.attack_finished = time + WEP_MACHINEGUN_ATTACKTIME;
				break;
			case WEP_CHAINGUN:
				self.weaponframe = WEP_CHAINGUN_FIRE_FIRSTFRAME;
				self.weapon_frame_end = WEP_CHAINGUN_FIRE_LASTFRAME;
				self.weapon_state_attack_frames = weapon_frames_chaingun_attack;
				self.weapon_has_spin = TRUE;
				self.attack_finished = time + WEP_CHAINGUN_ATTACKTIME;
				break;
			case WEP_GRENADE_LAUNCHER:
				self.weaponframe = WEP_NADELAUNCH_FIRE_FIRSTFRAME;
				self.weapon_frame_end = WEP_NADELAUNCH_FIRE_LASTFRAME;
				self.weapon_state_attack_frames = weapon_frames_nadelaunch_attack;
				self.attack_finished = time + WEP_GRENADE_LAUNCHER_ATTACKTIME;
				break;
			case WEP_ROCKET_LAUNCHER:
				self.weaponframe = WEP_ROCKETLAUNCH_FIRE_FIRSTFRAME;
				self.weapon_frame_end = WEP_ROCKETLAUNCH_FIRE_LASTFRAME;
				self.weapon_state_attack_frames = weapon_frames_rocketlaunch_attack;
				self.attack_finished = time + WEP_ROCKET_LAUNCHER_ATTACKTIME;
				break;
			case WEP_HYPERBLASTER:
				self.weaponframe = WEP_HYPERBLAST_FIRE_FIRSTFRAME;
				self.weapon_frame_end = WEP_HYPERBLAST_FIRE_LASTFRAME;
				self.weapon_state_attack_frames = weapon_frames_hyperb_attack;
				self.weapon_has_spin = TRUE;
				self.attack_finished = time + WEP_HYPERBLASTER_ATTACKTIME;
				break;
			case WEP_RAILGUN:
				self.weaponframe = WEP_RAILGUN_FIRE_FIRSTFRAME;
				self.weapon_frame_end = WEP_RAILGUN_FIRE_LASTFRAME;
				self.weapon_state_attack_frames = weapon_frames_rail_attack;
				self.attack_finished = time + WEP_RAILGUN_ATTACKTIME;
				break;
			case WEP_BFG:
				self.weaponframe = WEP_BFG_FIRE_FIRSTFRAME;
				self.weapon_frame_end = WEP_BFG_FIRE_LASTFRAME;
				self.weapon_state_attack_frames = weapon_frames_bfg_attack;
				self.attack_finished = time + WEP_BFG_ATTACKTIME;
				break;
		}
	}
	
	if( time > self.weapon_think){
		self.weapon_think = time + 0.1;
		if(self.weapon_state_attack_frames != SUB_Null){
			override = self.weapon_state_attack_frames();
			if(override){
				//attack frame should say what happens!
				return;
			}
		}
		if(self.weaponframe == self.weapon_frame_end){
			if(!W_CheckNoAmmo()){
				return;
			}
			if(self.weapon_has_spin ){
				self.weaponstate_next = WEAPON_SPINDOWN;
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
/*void() W_WeaponAnimate={

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
	
};*/

/*
  Attack frames per weapon.
  
  these are set on initial WEAPON_FIRING state to weapon_state_attack_frames()
    and then are called every frame of weapon attack anim.
    
  each weapon gets their own function where we put frames the weapon cares about.
  
  I feel that each gets their own function for cleanliness - allowing edits to be contained
  to a single chunk of code at a time.
*/

float() weapon_frames_blaster_attack={
	switch (self.weaponframe)
	{
		case WEP_BLASTER_FIRE_FIRSTFRAME:
			//q2playeronly_4attackframes();
			W_FireBlaster();
		break;
	}
	return FALSE;
};

float() weapon_frames_shotgun_attack={
	switch (self.weaponframe)
	{
		case WEP_SHOTGUN_FIRE_FIRSTFRAME:
			//q2playeronly_8attackframes ();
			W_FireShotgun();
		break;
	}
	return FALSE;
};

float() weapon_frames_supershot_attack={
	switch (self.weaponframe)
	{
		case WEP_SUPERSHOTGUN_FIRE_FIRSTFRAME:
			//q2playeronly_8attackframes ();
			W_FireSuperShotgun();
		break;
	}
	return FALSE;
};

float() weapon_frames_machineg_attack={
	switch (self.weaponframe)
	{
		case WEP_MACHINEGUN_FIRE_FIRSTFRAME:
			//q2playeronly_4attackframes ();
			FireBullet(WEAPON_CHAINGUN_DAMAGE);
		break;
	}
	return FALSE;
};


/*
	frame activate last 4
	frame fire last 31
	frame idle last 61
	frame putaway last 64
*/
float() weapon_frames_chaingun_attack={
	
	local float shots, i;
	
	bprint(ftos(self.weaponframe));
	bprint("\n");	//debug
	
	if(self.weaponframe == WEP_CHAINGUN_FIRE_FIRSTFRAME){
		sound(self, CHAN_WEAPON, "weapons/chngnu1a.wav", 0.5, ATTN_IDLE);
	}
	
	if(self.weaponframe == 14 && !self.button0){
		self.weaponframe = self.weapon_frame_end;
		return FALSE;
	}
	else if(self.weaponframe == 21 && self.button0 && self.inv_ammo_bullets > 0){
		self.weaponframe = 15;
	}
	else{
		self.weaponframe++;
	}
	
	if(self.weaponframe == 22){
		FireBullet(WEAPON_CHAINGUN_DAMAGE);
		sound(self, CHAN_WEAPON, "weapons/chngnd1a.wav", 0.5, ATTN_IDLE);
	}
	else{
		sound(self, CHAN_WEAPON, "weapons/chngnl1a.wav", 0.5, ATTN_IDLE);
	}
	
	/*
		Q2 source for player animations.
	ent->client->anim_priority = ANIM_ATTACK;
	if (ent->client->ps.pmove.pm_flags & PMF_DUCKED)
	{
		ent->s.frame = FRAME_crattak1 - (ent->client->ps.gunframe & 1);
		ent->client->anim_end = FRAME_crattak9;
	}
	else
	{
		ent->s.frame = FRAME_attack1 - (ent->client->ps.gunframe & 1);
		ent->client->anim_end = FRAME_attack8;
	}
	*/
	
	if(self.weaponframe <= 9){
		shots = 1;
	}
	else if(self.weaponframe <= 14){
		if (self.button0)
			shots = 2;
		else
			shots = 1;
	}
	else{
		shots = 3;
	}
	
	if(self.inv_ammo_bullets < shots){
		shots = self.inv_ammo_bullets;
	}
	
	if(!shots){
		if(time > self.attack_finished){
			sound(self, CHAN_BODY, "weapons/noammo.wav", 1.0, ATTN_NORM);
			self.attack_finished = time + 1;
		}
		self.weaponframe = self.weapon_frame_end;
		return FALSE;
	}
	/*
		Q2 source - quad
		if (is_quad)
		{
			damage *= 4;
			kick *= 4;
		}
	*/
	
	for (i=0 ; i<3 ; i++)
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
	
	for (i=0 ; i<shots ; i++)
	{
		// get start / end positions
		/*AngleVectors (ent->client->v_angle, forward, right, up);
		r = 7 + crandom()*4;
		u = crandom()*4;
		VectorSet(offset, 0, r, u + ent->viewheight-8);
		P_ProjectSource (ent->client, ent->s.origin, offset, forward, right, start);

		fire_bullet (ent, start, forward, damage, kick, DEFAULT_BULLET_HSPREAD, DEFAULT_BULLET_VSPREAD, MOD_CHAINGUN);
		*/
		FireBullet(WEAPON_CHAINGUN_DAMAGE);
	}
	
	self.weaponstate_next = WEAPON_FIRING;
	if(self.weaponframe == self.weapon_frame_end){
		self.weaponframe = WEP_CHAINGUN_FIRE_FIRSTFRAME;
	}
	return TRUE;
};

float() weapon_frames_nadelaunch_attack={
	switch (self.weaponframe)
	{
		case WEP_NADELAUNCH_FIRE_FIRSTFRAME:
			//q2playeronly_8attackframes ();
			W_FireGrenade();
		break;
	}
	return FALSE;
};

float() weapon_frames_rocketlaunch_attack={
	switch (self.weaponframe)
	{
		case WEP_ROCKETLAUNCH_FIRE_FIRSTFRAME:
			//q2playeronly_8attackframes ();
			W_FireRocket();
		break;
	}
	return FALSE;
};

float() weapon_frames_hyperb_attack={
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
	return TRUE;
};

float() weapon_frames_rail_attack={
	switch (self.weaponframe)
	{
		case WEP_RAILGUN_FIRE_FIRSTFRAME:
			sound (self, CHAN_WEAPON, "weapons/RAILGF1A.WAV", 1, ATTN_NORM);
			//q2playeronly_8attackframes ();
			FireBullet(WEAPON_RAILGUN_DAMAGE);
			//fireRail(WEAPON_RAILGUN_DAMAGE);
		break;
	}
	return FALSE;
};

float() weapon_frames_bfg_attack={
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
	return FALSE;
};