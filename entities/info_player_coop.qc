/*
  Allow trigger system to toggle info_player_coop entities.
    This lets maps unlock player_coop zones sequentially, or at-will.
*/
void() infoPlayerCoop_toggle={
  self.isActive = !self.isActive;
};

/*QUAKED info_player_coop (1 0 1) (-16 -16 -24) (16 16 24)
potential spawning position for coop games

  .coopID = player with matching coopID will spawn here.
  
  .isActive = player can only spawn at active spawn positions.
*/
void() info_player_coop =
{  
  if(!self.use){
    self.use = infoPlayerCoop_toggle;
  }
};
