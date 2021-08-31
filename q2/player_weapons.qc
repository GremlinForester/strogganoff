/*
  Q2-style weapon system complete with states


*/

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
    return;
  }
  
  
  if( time > self.weapon_think){
    self.weaponframe++;
    self.weapon_think = time + 0.1;
    if(self.weaponframe == self.weapon_frame_end){
      self.weapon_anim_start = TRUE;
    }
  }
};

void() weapon_state_putaway={

  if(self.weapon_anim_start == TRUE){
    self.weapon_anim_start = FALSE;
    
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
    return;
  }
  
  if( time > self.weapon_think){
    self.weaponframe++;
    self.weapon_think = time + 0.1;
    if(self.weaponframe == self.weapon_frame_end){
      self.weaponstate_next = WEAPON_ACTIVATING;
    }
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
    return;
  }
  

  if( time > self.weapon_think){
    self.weaponframe++;
    self.weapon_think = time + 0.1;
    if(self.weaponframe == self.weapon_frame_end){
      self.weaponstate_next = WEAPON_READY;
    }
  }  
};


void() weapon_state_fire={
  local string sfx;
  
  if(self.weapon_anim_start == TRUE){
    self.weapon_anim_start = FALSE;
    switch(self.weapon){
      case WEP_BLASTER:
        self.weaponframe = WEP_BLASTER_FIRE_FIRSTFRAME;
        self.weapon_frame_end = WEP_BLASTER_FIRE_LASTFRAME;
        break;
      
     case WEP_SHOTGUN:
        self.weaponframe = WEP_SHOTGUN_FIRE_FIRSTFRAME;
        self.weapon_frame_end = WEP_SHOTGUN_FIRE_LASTFRAME;
        break;
    
     case WEP_SUPERSHOTGUN:
        self.weaponframe = WEP_SUPERSHOTGUN_FIRE_FIRSTFRAME;
        self.weapon_frame_end = WEP_SUPERSHOTGUN_FIRE_LASTFRAME;
        break;
        
     case WEP_MACHINEGUN:
        self.weaponframe = WEP_MACHINEGUN_FIRE_FIRSTFRAME;
        self.weapon_frame_end = WEP_MACHINEGUN_FIRE_LASTFRAME;
        break;
        
     case WEP_CHAINGUN:
        self.weaponframe = WEP_CHAINGUN_FIRE_FIRSTFRAME;
        self.weapon_frame_end = WEP_CHAINGUN_FIRE_LASTFRAME;
        break;
        
     case WEP_GRENADE_LAUNCHER:
        self.weaponframe = WEP_NADELAUNCH_FIRE_FIRSTFRAME;
        self.weapon_frame_end = WEP_NADELAUNCH_FIRE_LASTFRAME;
        break;
        
     case WEP_ROCKET_LAUNCHER:
        self.weaponframe = WEP_ROCKETLAUNCH_FIRE_FIRSTFRAME;
        self.weapon_frame_end = WEP_ROCKETLAUNCH_FIRE_LASTFRAME;
        break;
        
     case WEP_HYPERBLASTER:
        self.weaponframe = WEP_HYPERBLAST_FIRE_FIRSTFRAME;
        self.weapon_frame_end = WEP_HYPERBLAST_FIRE_LASTFRAME;
        break;
        
     case WEP_RAILGUN:
        self.weaponframe = WEP_RAILGUN_FIRE_FIRSTFRAME;
        self.weapon_frame_end = WEP_RAILGUN_FIRE_LASTFRAME;
        break;
        
     case WEP_BFG:
        self.weaponframe = WEP_BFG_FIRE_FIRSTFRAME;
        self.weapon_frame_end = WEP_BFG_FIRE_LASTFRAME;
        break;
    }
    return;
  }
  
  if( time > self.weapon_think){
    self.weaponframe++;
    self.weapon_think = time + 0.1;
    if(self.weaponframe == self.weapon_frame_end){
      self.weaponstate_next = WEAPON_READY;
    }
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
*/
void() W_WeaponAnimate={
  
  if(self.weaponstate != self.weaponstate_next){
    bprint(sprintf("W_WeaponAnimate()-> weaponstate_next = %s\n", ftos(self.weaponstate_next)));// debug
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
    
    default:
      weapon_state_idle();
      break;
  }
};


