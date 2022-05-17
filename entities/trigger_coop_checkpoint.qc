void() coop_checkpoint_use={
  local entity point;
  
  if(self.target){
    point = findchain(classname, "info_player_coop");
    while(point){
      if(point.coopId){
        if(point.targetname == self.target){
          point.isActive = TRUE;
        }
      }
      point = point.chain;
    }
    self.touch = SUB_Null;
    self.think = SUB_Remove;
    self.nextthink = time + 0.1;
  }
  
  if(self.killtarget){
    point = findchain(targetname, self.killtarget);
    while(point){
      if(point.coopId){
        point.isActive = FALSE;
      }
      point = point.chain;
    }
  }
};
void() coop_checkpoint_touch={
  if(!(other.flags & FL_CLIENT)){
    return;
  }
  self.touch = SUB_Null;
  self.solid = SOLID_NOT;
  
  coop_checkpoint_use();
  
  remove(self);
};


//Stroggannoff EXT-COOP / player checkpoint system
/*QUAKED trigger_coop_checkpoint (.5 .5 .5) 
checkpoints act as info_player_coop managers.
  .target = group name for spawn points to ACTIVATE.
  .killtarget = group name for spawn points to DEACTIVATE.
*/
void() trigger_coop_checkpoint={
  if(!self.target){
    bprint("WARN - trigger_coop_checkpoint - missing TARGET!\n");
  }
  InitTrigger();
  
  self.touch = coop_checkpoint_touch;
  self.use = coop_checkpoint_use;
};
