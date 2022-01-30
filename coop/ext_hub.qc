/*
  Hub Map Concept
    Q1's concept of Hub-Map is mostly single-player focused.
      It reads a players.items | IT_RUNE values and reacts to that.

    We'd like to have something a little more robust, allowing mappers to create
    a more interactable hub map.
    
    The overall layout is a workflow to show how state is carried and modified during gameplay.
    Goal is any given map can be set to be a 'hub map' where things will change/mutate over time as
      players complete other maps/ map sets.
      
    
*/
#include "header/ext_hub.qh"
/*
  Server state variables.
    Most reliable data storage for the server in-between maps would be CVARS (thanks, Mr.C!)
    
    sv_ishub
      <map>isHub(true) -> cvar_set(sv_ishub, 1)
        map files, on-load, will tell the server if the current map is a hub map.
    
    sv_hubmap
      this is set when (sv_ishub) is also set, this becomes the reference point for players when the server
        needs to find the hub map.
          example:
            + players win a campaign and return to hub.
            + ALL players dead on the mission, return to hub.
    
    sv_hubstate
      abstract numerical value. 0 - X
      This is set by the hubmap on map changes AWAY from the hub.
      
*/

//import 
void() trigger_hub_on_state;

/*
  Stroggannoff EXT-HUB / initialize hub-map extension
    World.qc / worldspawn()
*/
void() sv_ext_hub_ini={
  local entity hubStateTrig;
  
  registercvar(SV_CVAR_HUB, "0");
  registercvar(SV_CVAR_HUB_STATE, "0");
  registercvar(SV_CVAR_HUB_MAP, "");
  
  //map is a hub.
  cvar_set(SV_CVAR_HUB, ftos(self.isHub));
  
  if(self.isHub){
    self.hubState = cvar(SV_CVAR_HUB_STATE);
    cvar_set(SV_CVAR_HUB_MAP, mapname);
    dprint(sprintf("\n hub map = %s", cvar_string(SV_CVAR_HUB_MAP))); //debug
  }
};
