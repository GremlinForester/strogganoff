/*
  Strogganoff
    co-op system
  
    an effort to create a truly co-op dedicated set of QuakeC.
    
    Using Co-op standards as of 2022, this api assumes a co-op server
      of ONLY 1-4 players. Contemporary co-op shooters use this as a golden number 
      range, and it only makes sense to use it here too. If players want uncapped
      Co-op experiences, then vanilla Quake games are where they want to be.
      
      A capped player count allows us to do some wild stuff with the QuakeC, which
      will be shown here.
*/

#include "header/ext_coop.qh"

/*
  client.qc/clientconnect()
  
    When player connects, check to see if they're one of the 4 possible co-op players 
      (all other clients can only observe or should be booted).
    
    Assign their CoopId, and let the server know which CoopPlayer they are.
    
    Cache - see if a playerCache exists already, if it does and it's the connecting-player's, assign.
*/
float() sv_coop_client_connect={
  local float makeNewCache;
  local float cacheId;
  local entity cache;
  
  if(SV_PLAYER_COUNT == SV_PLAYER_MAX){
    return FALSE;
  }
  
  self.isNewCache = TRUE;
  self.playerCache = -1;
  //Check name-cache first, maybe this player is a re-connect?
  if(strtolower(self.netname) != "player"){
    cacheId = 0;
    while(cacheId < 4){
      cache = PLAYER_CACHE_ENTS[cacheId];
      if(cache){
        if(cache.netname == self.netname){
          self.playerCache = cacheId;
          self.isNewCache = FALSE;
        }
      }
      cacheId = cacheId + 1;
    }
    if(self.isNewCache){
      //Player is probably not a re-connect, create new session
      sv_coop_client_connect_iniCache();
    }
  }
  
  //find the first available empty co-op slot and assign player.
  if(SV_PLAYER1 == world){
    sv_coop_strunzone(SV_PLAYER1_NAME);
    sv_coop_strzone(SV_PLAYER1_NAME, self.netname);

    SV_PLAYER1 = self;
    self.coopId = SV_PLAYER1_ID;
  }
  else if(SV_PLAYER2 == world){
    sv_coop_strunzone(SV_PLAYER2_NAME);
    sv_coop_strzone(SV_PLAYER2_NAME, self.netname);
    
    SV_PLAYER2 = self;
    self.coopId = SV_PLAYER2_ID;
  }
  else if(SV_PLAYER3 == world){
    sv_coop_strunzone(SV_PLAYER3_NAME);
    sv_coop_strzone(SV_PLAYER3_NAME, self.netname);
    
    SV_PLAYER3 = self;
    self.coopId = SV_PLAYER3_ID;
  }
  else if(SV_PLAYER4 == world){
    sv_coop_strunzone(SV_PLAYER4_NAME);
    sv_coop_strzone(SV_PLAYER4_NAME, self.netname);
    
    SV_PLAYER4 = self;
    self.coopId = SV_PLAYER4_ID;
  }
  SV_PLAYERS_LIST[self.coopId - 1] = self;
  
  
  //self.savePack_version = 0;
  //self.savePack_dropped = FALSE;
  
  //increase player count towards limit
  SV_PLAYER_COUNT = SV_PLAYER_COUNT + 1;
  self.player_connect_state = CLIENT_STATE_CONNECT;
  
  //sv_coop_client_slide_player_slots();
  
  return TRUE;
};

/*
  client.qc/ClientDisconnect()
    Disconnecting player decreases player count by 1.
    
    Free up that co-op slot as well.
*/
void() sv_coop_client_disconnect={
  local entity cache;
  
  cache = PLAYER_CACHE_ENTS[self.playerCache];
  if(cache && self){
    sv_coop_client_disconnect_saveCache();
  }
  
  SV_PLAYERS_LIST[self.coopId-1] = world;
  
  if(self.netname != "player"){
    if(SV_PLAYER1 == self){
      sv_coop_strunzone(SV_PLAYER1_NAME);
      SV_PLAYER1 = world;
    }
    else if(SV_PLAYER2 == self){
      sv_coop_strunzone(SV_PLAYER2_NAME);
      SV_PLAYER2 = world;
    }
    else if(SV_PLAYER3 == self){
      sv_coop_strunzone(SV_PLAYER3_NAME);
      SV_PLAYER3 = world;
    }
    else if(SV_PLAYER4 == self){
      sv_coop_strunzone(SV_PLAYER4_NAME);
      SV_PLAYER4 = world;
    }
  }
  
  /*
    I'm not sure we actually want to move players around on a disconnect?
    IF a map has specific player-paths for specific players
      example - Player 2 is on a separate path
      
    THEN shifting their playerId DURING gameplay would completely obliterate that.
    
    SO - for now, let's not touch this.
      new player connects will fill the empty slots, but! a player's slot will be
      locked after they have connected.
    
    Subject9x
  */
  /*switch(self.coopId){
    case SV_PLAYER1_ID:
      SV_PLAYER1 = world;
      break;
    
    case SV_PLAYER2_ID:
      SV_PLAYER2 = world;
      break;
    
    case SV_PLAYER3_ID:
      SV_PLAYER3 = world;
      break;
    
    case SV_PLAYER4_ID:
      SV_PLAYER4 = world;
      break;
  }
  sv_coop_client_slide_player_slots();
  SV_PLAYER_COUNT = SV_PLAYER_COUNT - 1;
  */
};

/*
  Essentially walk the player list and slide players 'up' to 1,2,.. etc
    WARN - not used, because I'm not sure we want to slide players around player-seats.
      -Subject9x

void() sv_coop_client_slide_player_slots={
  local float i;
  local entity t;
  
  i = 1;
  for(i = 0; i < 4; i = i + 1){
    if(SV_PLAYERS_LIST[i-1] == world ){
      //bprint(sprintf("SV_PLAYERS_LIST[%s] empty\n", ftos(i-1)));  //debug
      
      //t = SV_PLAYERS_LIST[i];
      //bprint(sprintf("moving SV_PLAYER%s to SV_\n", ftos(i)));  //debug
      
      SV_PLAYERS_LIST[i-1] = SV_PLAYERS_LIST[i];
      
      
      SV_PLAYERS_LIST[i] = world;
    }
  }
};
*/

/*
  Player 'cache' operations.
    the cache is just a server-side entity that shadows a player's state.

  iniCache - new player in new slot.
*/
void() sv_coop_client_connect_iniCache={
  local entity cache;
  
  cache = spawn();
  cache.classname = "player_cache";
  cache.movetype = MOVETYPE_NONE;
  cache.solid = SOLID_NOT;
  setmodel(cache, "models/objects/banner/tris.md2");
  setsize(cache, '-1 -1 -1', '1 1 1');
  setorigin(cache, self.origin);
  cache.effects = cache.effects | EF_NODRAW;
  cache.netname = strzone(self.netname);
  
  cache.owner = self;
 
  PLAYER_CACHE_ENTS[SV_PLAYER_COUNT] = cache;
  self.playerCache = SV_PLAYER_COUNT;
};

/*
  Player has left the server for any reason, cache their info.
    This is overridden when someone else joins thats new to the server and ends up in the
    'old' players slot - unless we go deep and make a large cache array.
*/
void() sv_coop_client_disconnect_saveCache={
  local entity cache;
  
  cache = PLAYER_CACHE_ENTS[self.playerCache];
  
  if(self && cache){
    sv_coop_client_setCache(self, cache);
  }
  cache.nextthink = time + SV_CACHE_TIMEOUT;
  cache.think = sv_coop_player_cache_timeout;
};

/*
  Copies player cache data from the source to a destination.
    srcCache = PLAYER_CACHE_ENTS[x] || player-entity
    dstCache = PLAYER_CACHE_ENTS[x] || player-entity\
  
  WARN: call if(srcCache && dstCache) before this function!
*/
void(entity srcCache, entity dstCache) sv_coop_client_setCache={
  dstCache.items = 0;
  dstCache.weapon = srcCache.weapon;
  dstCache.items = dstCache.items | srcCache.items; 
  dstCache.inv_ammo_shells = srcCache.inv_ammo_shells;
  dstCache.inv_ammo_bullets = srcCache.inv_ammo_bullets;
  dstCache.inv_ammo_rockets = srcCache.inv_ammo_rockets;
  dstCache.inv_ammo_cells = srcCache.inv_ammo_cells;
  dstCache.inv_weapons = srcCache.inv_weapons;
  dstCache.inv_ammo_slugs = srcCache.inv_ammo_slugs;
  dstCache.items_q2keys = srcCache.items_q2keys;
  dstCache.inv_pickup_quad = srcCache.inv_pickup_quad;
  dstCache.inv_pickup_rebreather = srcCache.inv_pickup_rebreather;
  dstCache.inv_pickup_invisibility = srcCache.inv_pickup_invisibility;
  dstCache.inv_pickup_silencer = srcCache.inv_pickup_silencer;
  dstCache.inv_pickup_invulnerability = srcCache.inv_pickup_invulnerability;
  dstCache.inv_pickup_envirosuit = srcCache.inv_pickup_envirosuit;
  //dstCache.statBuffs = dstCache.statBuffs | srcCache.statBuffs;
  dstCache.frags = srcCache.frags;
};

void() sv_coop_player_cache_timeout={
  self.think = SUB_Remove;
  self.nextthink = time + 0.1;
  if(self.netname != ""){
    strunzone(self.netname);
  }
  PLAYER_CACHE_ENTS[self.coopId - 1] = world;
};

/*
  SAVEPACK DISABLED
    a neat idea, but a little beyond the scope of the project at the moment.
*/
/*
void savePack_touch(){
	//ignore non-clients.
	if (other.classname != "player")
		return;
	
	//ignore other clients.
	if (other.coopId != self.savePack_coopId)
		return;
	
	if (other.savePack_dropped){
		centerprint(other, "You have already deployed your SavePack\n");
		return;
	}
	
	self.think = SUB_Remove;
	self.nextthink = time + 0.01;
	self.touch = SUB_Null;
	
	//only pickup if client version is less, indicating a stale savePack ON the current client
	if (other.savePack_version >= self.savePack_version){
		centerprint(other, sprintf("DEBUG - PICK UP FAIL \n Pack version: %s \n Player version: %s\n", ftos(self.savePack_version), ftos(other.savePack_version)));	//debug
		return;
	}
	//run the update
	other.items = other.items | self.items;
	//other.statBuffs = other.statBuffs | self.statBuffs;	
	
  other.inv_ammo_shells = self.inv_ammo_shells;
	other.inv_ammo_bullets = self.inv_ammo_bullets;
	other.inv_ammo_rockets = self.inv_ammo_rockets;
	other.inv_ammo_cells = self.inv_ammo_cells;
	other.inv_weapons = self.inv_weapons;
	other.inv_ammo_slugs = self.inv_ammo_slugs;
	other.items_q2keys = self.items_q2keys;
	other.inv_pickup_quad = self.inv_pickup_quad;
	other.inv_pickup_rebreather = self.inv_pickup_rebreather;
	other.inv_pickup_invisibility = self.inv_pickup_invisibility;
	other.inv_pickup_silencer = self.inv_pickup_silencer;
	other.inv_pickup_invulnerability = self.inv_pickup_invulnerability;
	other.inv_pickup_envirosuit = self.inv_pickup_envirosuit;
  
	//pack.statBuffs = pack.statBuffs | targetPlayer.statBuffs;
	other.frags = self.frags;  
	other.savePack_version += 1;
};*/

/*void savePack_hold(){
	self.solid = SOLID_TRIGGER;
	self.touch = savePack_touch;
	self.alpha = 1.0;
	self.colormod = '1 0 0';
}*/

/*
  Save Packs are a game entity designed to 'save' a specific players stats/items inside a map.
    the reason is so that player-data can be saved along with the level and restoring a network game wouldn't
    necessarily wipe out a connecting client's data.
    We also don't want to futz with sending player data back to their own client to untangle in local saves.
    
    LIFECYCLE
      ClientConnect()
        + set initial self.savePack_version = 0
        
      PutClientInServer()
      
      PlayerDeath()
      
      ClientDisconnect()
        + set final find.savePack_version = self.savePack_version;
        + set lifetime timer so that in X minutes the savepack will timeout and remove()?
        
      ClientKill()
*/
/*void savePack_drop(entity targetPlayer){
	local entity pack;
	
	if (targetPlayer.savePack_dropped)
		return;
	
	targetPlayer.savePack_version = targetPlayer.savePack_version + 1;
	targetPlayer.savePack_dropped = TRUE;
	
	pack = spawn();
  pack.classname = "player_savepack";
	setmodel(pack, "progs/backpack.mdl");
	setsize(pack, '-4 -4 -4', '4 4 4');
	setorigin(pack, targetPlayer.origin);
	pack.colormod = '0.5 0.5 0.5';
	pack.alpha = 0.67;
	
  
  pack.savePack_version = targetPlayer.savePack_version;
	pack.savePack_coopId = targetPlayer.coopId;
  
	pack.items = 0;
  pack.items = pack.items | targetPlayer.items;
	
  pack.inv_ammo_shells = targetPlayer.inv_ammo_shells;
	pack.inv_ammo_bullets = targetPlayer.inv_ammo_bullets;
	pack.inv_ammo_rockets = targetPlayer.inv_ammo_rockets;
	pack.inv_ammo_cells = targetPlayer.inv_ammo_cells;
	pack.inv_weapons = targetPlayer.inv_weapons;
	pack.inv_ammo_slugs = targetPlayer.inv_ammo_slugs;
	pack.items_q2keys = targetPlayer.items_q2keys;
	pack.inv_pickup_quad = targetPlayer.inv_pickup_quad;
	pack.inv_pickup_rebreather = targetPlayer.inv_pickup_rebreather;
	pack.inv_pickup_invisibility = targetPlayer.inv_pickup_invisibility;
	pack.inv_pickup_silencer = targetPlayer.inv_pickup_silencer;
	pack.inv_pickup_invulnerability = targetPlayer.inv_pickup_invulnerability;
	pack.inv_pickup_envirosuit = targetPlayer.inv_pickup_envirosuit;
  
	//pack.statBuffs = pack.statBuffs | targetPlayer.statBuffs;
	pack.frags = targetPlayer.frags;
	
  
	pack.think = savePack_hold;
	pack.nextthink = time + 3;
};*/

/*
  allow server to search for any savepack.
    Eventually we can chain this to be a save-load system on player connnect/reonnect.
*/
/*void savePack_search_map(entity targetPlayer)={
  local entity search;
  search = findchain(classname, "player_savepack");
  while(search != world){
    if(search.coopId == targetPlayer.coopId){
      if(search.
    }
    search = search.chain;
  }
  
};*/