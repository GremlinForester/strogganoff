/*
  EXT_STROGGANOFF / Extended Triggers.
  
    moved all non-standard triggers out to their own file. 
      trigger_coop_checkpoint.
      
      trigger_hub_changelevel
      
      trigger_hub_on_state
      
      trigger_hub_set_map
      
      trigger_hub_set_state
*/

void() hub_setState_use={
  if(self.hubState){
    cvar_set(SV_CVAR_HUB_STATE, ftos(self.hubState));
  }
};
void() hub_setState_touch={
  if(!(other.flags & FL_CLIENT)){
    return;
  }
  self.solid = SOLID_NOT;
  self.touch = SUB_Null;
  
  hub_setState_use();
  
  self.think = SUB_Remove;
  self.nextthink = time + 0.1;
};
//Stroggannoff EXT-HUB / set hub state
/*QUAKED trigger_hub_set_state (.5 .5 .5) 
  sets server's SV_CVAR_HUB_STATE value
    .hubState = target state to send to server.
*/
void() trigger_hub_set_state={
  
  if(!self.hubState){
    dprint(sprintf("trigger_hub_set_state[%s] - missing .hubState value.\n", vtos(self.origin)));
    remove(self);
    return;
  }
  InitTrigger ();
  self.touch = hub_setState_touch;
  self.use = hub_setState_use;
};



void() hub_setMap_use={
  if(self.map){
    cvar_set(SV_CVAR_HUB_MAP, self.map);
  }
};
void() hub_setMap_touch={
  if(!(other.flags & FL_CLIENT)){
    return;
  }
  self.solid = SOLID_NOT;
  self.touch = SUB_Null;
  
  hub_setMap_use();
  
  self.think = SUB_Remove;
  self.nextthink = time + 0.1;
};
//Stroggannoff EXT-HUB / set hub map
/*QUAKED trigger_hub_set_map (.5 .5 .5) 
  sets server's SV_CVAR_HUB_MAP value
    .hubState = target state to send to server.
*/
void() trigger_hub_set_map={
  
  if(!self.map){
    dprint(sprintf("trigger_hub_set_map[%s] - missing .map value.\n", vtos(self.origin)));
    remove(self);
    return;
  }
  InitTrigger ();
  self.touch = hub_setMap_touch;
  self.use = hub_setMap_use;
};

//just here for compile reference
void() changelevel_touch;
void() execute_changelevel;

void() changelevel_tohub_use={
  
  self.solid = SOLID_NOT;
  self.touch = SUB_Null;

  dprint(sprintf("\n hub map = %s", cvar_string(SV_CVAR_HUB_MAP))); //debug
  
  self.map = strzone(cvar_string(SV_CVAR_HUB_MAP));
  dprint(sprintf("\n self.map = %s", self.map)); //debug
  
  if(self.map){
    changelevel_touch();
  }
  
  remove(self);
};
void() changelevel_tohub_touch={
  if(!(other.flags & FL_CLIENT)){
      return;
  }
  self.solid = SOLID_NOT;
  self.touch = SUB_Null;
  
  changelevel_tohub_use();
  
  self.think = SUB_Remove;
  self.nextthink = time + 0.2;
};
//Stroggannoff EXT-HUB / go to hub map
/*QUAKED trigger_hub_changelevel (.5 .5 .5) ? NO_INTERMISSION
  wraps trigger_changelevel() so that the specific map is auto-set to SV_CVAR_HUB_MAP.
  
*/
void() trigger_hub_changelevel={
  local string s;
  
  s = cvar_string(SV_CVAR_HUB_MAP);
  if(s == ""){
    dprint(sprintf("trigger_hub_changelevel[%s] - missing .map value.\n", vtos(self.origin)));
    remove(self);
    return;
  }
	InitTrigger ();
	self.touch = changelevel_tohub_touch;
	self.use = changelevel_tohub_use;
};


#define FLAG_EQUAL_TO 1
#define FLAG_LESS_THAN 2
#define FLAG_MORE_THAN 4
#define FLAG_NOT_EQUAL 8
#define REMOVE_TARGETS 16

void() hub_onState={

};
#define SV_HUB_STATE "sv_hub_state"
void() hub_onState_load={
  
  local float svHubState;
  local float conditionMet;
  local entity hubRemove;
  local entity remNext;
  
  svHubState = cvar(SV_HUB_STATE);
  conditionMet = FALSE;
  
  if((self.spawnflags & FLAG_EQUAL_TO)){
    if(self.hubState == svHubState){
      conditionMet = TRUE;
    }
  }
  
  if((self.spawnflags & FLAG_LESS_THAN)){
    if(self.hubState > svHubState){
      conditionMet = TRUE;
    }
  }
  
  if((self.spawnflags & FLAG_MORE_THAN)){
    if(self.hubState < svHubState){
      conditionMet = TRUE;
    }
  }
  
  if((self.spawnflags & FLAG_NOT_EQUAL)){
    if(svHubState != self.hubState){
      conditionMet = TRUE;
    }
  }
  
  if(conditionMet){
    if(self.target){
      SUB_UseTargets();
    }
  }
  else if((self.spawnflags & REMOVE_TARGETS)){
    //remove items
    hubRemove = findchain(hub_target, self.target);
    while(hubRemove){
      remNext = hubRemove;
      hubRemove = hubRemove.chain;
      remove(remNext);
    }
  }
  self.use = SUB_Null;
  self.think = SUB_Remove;
  self.nextthink = time + 0.1;
};
//Stroggannoff EXT-HUB / fire triggers based on hubstate
/*QUAKED trigger_hub_on_state (.5 .5 .5) EQUAL_TO HUB_LESS_THAN HUB_MORE_THAN NOT_EQUAL REMOVE_TARGETS
  Kills / removes any entity with matching TARGETNAME
  .hubState(integer) : "the hubState value to compare to server."
*/
void() trigger_hub_on_state={
  InitTrigger ();
  
  self.solid = SOLID_NOT;
  self.touch = SUB_Null;
  self.use = hub_onState_load;
  self.think = hub_onState_load;
  self.nextthink = time + 0.15;
};