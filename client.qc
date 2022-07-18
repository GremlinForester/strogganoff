void () W_WeaponFrame;
void() W_ChangeWeapon;
void() q2player_pain;
void (vector org) spawn_tfog;
void (vector org, entity death_owner) spawn_tdeath;

//MrC: Crouch stuff based on:

//===================
//Chris
//Crouch for player '06
//===================

#define	CROUCH_VEC_HULL_MIN '-16 -16 -24'
#define	CROUCH_VEC_HULL_MAX '16 16 4'

.float crouch, attemptcrouch;
float (entity targ) crouchcheck =
{
	makevectors (self.v_angle);
	tracebox (self.origin, CROUCH_VEC_HULL_MIN, CROUCH_VEC_HULL_MAX, self.origin + '0 0 32', FALSE, self); 

	if (trace_fraction == 1)            //hits nothing go ahead
		return TRUE;

	if (!trace_ent.takedamage)      //hits world or nondamagable object
		return FALSE;

	return FALSE;
};

void() crouch_on =
{
	if (!self.flags & FL_DUCKED) //crouch down
	{
		setsize (self, '-16 -16 -24', '16 16 4');
		self.flags = self.flags | FL_DUCKED;
		self.view_ofs = '0 0 -2';
		return;
	}
};

void() crouch_off =
{
	if (self.flags & FL_DUCKED && (!self.velocity_z) && crouchcheck(self))  //get up
	{
		setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
		self.flags = self.flags - (self.flags & FL_DUCKED);
		self.origin_z = self.origin_z + 16;
		self.view_ofs = '0 0 22';
		return;
	}
};

/*
=============================================================================

				LEVEL CHANGING / INTERMISSION

=============================================================================
*/

float	intermission_running;
float	intermission_exittime;

/*
plrVO is an enum that is checked below to select different sounds based on player type.

When calling a player sound, use something like: playerVOSound(PLAYER_VOICE_JUMP);

This could also be done by assigning globals for player entity self.sndpain25_1 etc... But I went with this instead, it might be a bit of a messy read. 

Tried to keep it clean.

*/

void(float plrVO) playerVOSound =
{
	local string playerVO;
	local float r;

	if (self.playerType == PT_MALE)
	{	
		switch(plrVO)
		{
			case PLAYER_VOICE_JUMP:
			playerVO = "players/male/jump1.wav";
			break;

			case PLAYER_VOICE_LAND1:
			playerVO = "players/male/fall1.wav";
			break;

			case PLAYER_VOICE_LAND2:
			playerVO = "players/male/fall2.wav";
			break;
			
			case PLAYER_VOICE_PAIN25:
				if (random() > 0.5)
					playerVO = "players/male/pain25_1.wav";
				else
					playerVO = "players/male/pain25_2.wav";
			break;

			case PLAYER_VOICE_PAIN50:
				if (random() > 0.5)
					playerVO = "players/male/pain50_1.wav";
				else
					playerVO = "players/male/pain50_2.wav";
			break;
			
			case PLAYER_VOICE_PAIN75:
				if (random() > 0.5)
					playerVO = "players/male/pain75_1.wav";
				else
					playerVO = "players/male/pain75_2.wav";
			break;
			
			case PLAYER_VOICE_PAIN100:
				if (random() > 0.5)
					playerVO = "players/male/pain100_1.wav";
				else
					playerVO = "players/male/pain100_2.wav";
			break;
			
			case PLAYER_VOICE_DEATH:
				r = rint(random() * 4);
				if (r == 1)
					playerVO = "players/male/death1.wav";
				else if (r == 2)
					playerVO = "players/male/death2.wav";
				else if (r == 3)
					playerVO = "players/male/death3.wav";
				else
					playerVO = "players/male/death4.wav";
			break;
			
			case PLAYER_VOICE_GURP:
				r = rint(random() * 2);
				if (r == 1)
					playerVO = "players/male/gurp1.wav";
				else
					playerVO = "players/male/gurp2.wav";
			break;
			
			case PLAYER_VOICE_DROWN:
				playerVO = "players/male/drown1.wav";
			break;
		}
	}
	else if (self.playerType == PT_FEMALE)
	{	
		switch(plrVO)
		{
			case PLAYER_VOICE_JUMP:
			playerVO = "players/female/jump1.wav";
			break;

			case PLAYER_VOICE_LAND1:
			playerVO = "players/female/fall1.wav";
			break;

			case PLAYER_VOICE_LAND2:
			playerVO = "players/female/fall2.wav";
			break;

			case PLAYER_VOICE_PAIN25:
				if (random() > 0.5)
					playerVO = "players/female/pain25_1.wav";
				else
					playerVO = "players/female/pain25_2.wav";
			break;

			case PLAYER_VOICE_PAIN50:
				if (random() > 0.5)
					playerVO = "players/female/pain50_1.wav";
				else
					playerVO = "players/female/pain50_2.wav";
			break;
			
			case PLAYER_VOICE_PAIN75:
				if (random() > 0.5)
					playerVO = "players/female/pain75_1.wav";
				else
					playerVO = "players/female/pain75_2.wav";
			break;
			
			case PLAYER_VOICE_PAIN100:
				if (random() > 0.5)
					playerVO = "players/female/pain100_1.wav";
				else
					playerVO = "players/female/pain100_2.wav";
			break;
			
			case PLAYER_VOICE_DEATH:
				r = rint(random() * 4);
				if (r == 1)
					playerVO = "players/female/death1.wav";
				else if (r == 2)
					playerVO = "players/female/death2.wav";
				else if (r == 3)
					playerVO = "players/female/death3.wav";
				else
					playerVO = "players/female/death4.wav";
			break;
			
			case PLAYER_VOICE_GURP:
				r = rint(random() * 2);
				if (r == 1)
					playerVO = "players/female/gurp1.wav";
				else
					playerVO = "players/female/gurp2.wav";
			break;
			
			case PLAYER_VOICE_DROWN:
				playerVO = "players/female/drown.wav";
			break;
		}
	}
	else
	{
		switch(plrVO)
		{
			case PLAYER_VOICE_JUMP:
			playerVO = "players/cyborg/jump1.wav";
			break;

			case PLAYER_VOICE_LAND1:
			playerVO = "players/cyborg/fall1.wav";
			break;

			case PLAYER_VOICE_LAND2:
			playerVO = "players/cyborg/fall2.wav";
			break;
			
			case PLAYER_VOICE_PAIN25:
				if (random() > 0.5)
					playerVO = "players/cyborg/pain25_1.wav";
				else
					playerVO = "players/cyborg/pain25_2.wav";
			break;

			case PLAYER_VOICE_PAIN50:
				if (random() > 0.5)
					playerVO = "players/cyborg/pain50_1.wav";
				else
					playerVO = "players/cyborg/pain50_2.wav";
			break;
			
			case PLAYER_VOICE_PAIN75:
				if (random() > 0.5)
					playerVO = "players/cyborg/pain75_1.wav";
				else
					playerVO = "players/cyborg/pain75_2.wav";
			break;
			
			case PLAYER_VOICE_PAIN100:
				if (random() > 0.5)
					playerVO = "players/cyborg/pain100_1.wav";
				else
					playerVO = "players/cyborg/pain100_2.wav";
			break;
			
			case PLAYER_VOICE_DEATH:
				r = rint(random() * 4);
				if (r == 1)
					playerVO = "players/cyborg/death1.wav";
				else if (r == 2)
					playerVO = "players/cyborg/death2.wav";
				else if (r == 3)
					playerVO = "players/cyborg/death3.wav";
				else
					playerVO = "players/cyborg/death4.wav";
			break;
			
			case PLAYER_VOICE_GURP:
				r = rint(random() * 2);
				if (r == 1)
					playerVO = "players/cyborg/gurp1.wav";
				else
					playerVO = "players/cyborg/gurp2.wav";
			break;
			
			case PLAYER_VOICE_DROWN:
				playerVO = "players/cyborg/drown1.wav";
			break;
		}		
	}
	sound(self, CHAN_VOICE, playerVO, 1, ATTN_IDLE);
}

void(entity ent) stripKeys =
{
	ent.items_q2keys = ent.items_q2keys - (ent.items_q2keys & (IT_KEY_DATACD | IT_KEY_POWERCUBE | IT_KEY_PYRAMID | IT_KEY_DATASPINNER | IT_KEY_PASS | IT_KEY_BLUE | IT_KEY_RED | IT_KEY_HEAD) );
}

void() SetChangeParms =
{
	if (self.health <= 0)
	{
		SetNewParms ();
		return;
	}

// remove items
	self.items = self.items - (self.items & (IT_KEY1 | IT_KEY2 | IT_INVISIBILITY | IT_INVULNERABILITY | IT_BREATHER | IT_SUIT | IT_QUAD | IT_DOUBLER) );
	
// cap super health
	if (self.health > 100)
		self.health = 100;
	if (self.health < 50)
		self.health = 50;
	parm1 = self.items;
	parm2 = self.health;
	parm3 = self.armorvalue;
	if (self.inv_ammo_shells < 25)
		parm4 = 25;
	else
		parm4 = self.inv_ammo_shells;
	parm5 = self.inv_ammo_bullets;
	parm6 = self.inv_ammo_rockets;
	parm7 = self.inv_ammo_cells;
	parm8 = self.weapon;
	parm9 = self.armortype * 100;
	parm10 = self.inv_weapons;
	parm11 = self.inv_ammo_slugs;
	parm12 = self.items_q2keys;
	parm13 = self.inv_pickup_quad;
	parm14 = self.inv_pickup_rebreather;
	parm15 = self.inv_pickup_invisibility; //power screen
	parm16 = self.inv_pickup_silencer;
	parm17 = self.inv_pickup_invulnerability;
	parm18 = self.inv_pickup_envirosuit;
	parm19 = self.playerType;	
};

void() SetNewParms =
{
	parm1 = 0; //.items
	parm2 = 100;
	parm3 = 0;
	parm4 = 0;
	parm5 = 0;
	parm6 = 0;
	parm7 = 0;
	parm8 = WEP_BLASTER;
	parm9 = 0;
	parm10 = WEP_BLASTER;
	parm11 = 0;
	parm12 = 0; //self.items_q2keys;
	parm13 = 0;
	parm14 = 0;
	parm15 = 0;
	parm16 = 0;
	parm17 = 0;
	parm18 = 0;
	parm19 = 0;
};

.float resetkeys;

void() DecodeLevelParms =
{
	if (serverflags)
#ifdef opgrade
	if (!deathmatch){
#endif
		if (world.model == "maps/start.bsp")
			SetNewParms ();		// take away all stuff on starting new episode
	}
	
	self.items = parm1;
	self.health = parm2;
	self.armorvalue = parm3;
	self.inv_ammo_shells = parm4;
	self.inv_ammo_bullets = parm5;
	self.inv_ammo_rockets = parm6;
	self.inv_ammo_cells = parm7;
	self.weapon = parm8;
	self.armortype = parm9 * 0.01;
	self.inv_weapons = self.inv_weapons | parm10;
	self.inv_ammo_slugs = parm11;
	self.items_q2keys = parm12;
	self.inv_pickup_quad = parm13;
	self.inv_pickup_rebreather = parm14;
	self.inv_pickup_invisibility = parm15; 
	self.inv_pickup_silencer = parm16;
	self.inv_pickup_invulnerability = parm17;
	self.inv_pickup_envirosuit = parm18;
	self.playerType = parm19;
};

/*
============
FindIntermission

Returns the entity to view from
============
*/
entity() FindIntermission =
{
	local	entity spot;
	local	float cyc;

// look for info_intermission first
	spot = find (world, classname, "info_intermission");
	if (spot)
	{	// pick a random one
		cyc = random() * 4;
		while (cyc > 1)
		{
			spot = find (spot, classname, "info_intermission");
			if (!spot)
				spot = find (spot, classname, "info_intermission");
			cyc = cyc - 1;
		}
		return spot;
	}

// then look for the start position
	spot = find (world, classname, "info_player_start");
	if (spot)
		return spot;
	
// testinfo_player_start is only found in regioned levels
	spot = find (world, classname, "testplayerstart");
	if (spot)
		return spot;
	
#ifdef noobjerr
	return world;
#else
	objerror ("FindIntermission: no spot");					//opgrade protected
#endif
	
};


string nextmap;
void() GotoNextMap =
{
	if (cvar("samelevel"))	// if samelevel is set, stay on same level
		changelevel (mapname);
	else
		changelevel (nextmap);
};


void() ExitIntermission =
{
// skip any text in deathmatch
	if (deathmatch)
	{
		GotoNextMap ();
		return;
	}
	
	intermission_exittime = time + 1;
	intermission_running = intermission_running + 1;

//
// run some text if at the end of an episode
//
	if (intermission_running == 2)
	{
		if (world.model == "maps/e1m7.bsp")
		{
			WriteByte (MSG_ALL, SVC_CDTRACK);
			WriteByte (MSG_ALL, 2);
			WriteByte (MSG_ALL, 3);
			if (!cvar("registered"))
			{
				WriteByte (MSG_ALL, SVC_FINALE);		// qc++ dp only make these cvar_string
				WriteString (MSG_ALL, "As the corpse of the monstrous entity\nChthon sinks back into the lava whence\nit rose, you grip the Rune of Earth\nMagic tightly. Now that you have\nconquered the Dimension of the Doomed,\nrealm of Earth Magic, you are ready to\ncomplete your task in the other three\nhaunted lands of Quake. Or are you? If\nyou don't register Quake, you'll never\nknow what awaits you in the Realm of\nBlack Magic, the Netherworld, and the\nElder World!");
			}
			else
			{
				WriteByte (MSG_ALL, SVC_FINALE);
				WriteString (MSG_ALL, "As the corpse of the monstrous entity\nChthon sinks back into the lava whence\nit rose, you grip the Rune of Earth\nMagic tightly. Now that you have\nconquered the Dimension of the Doomed,\nrealm of Earth Magic, you are ready to\ncomplete your task. A Rune of magic\npower lies at the end of each haunted\nland of Quake. Go forth, seek the\ntotality of the four Runes!");
			}
			return;
		}
		else if (world.model == "maps/e2m6.bsp")
		{
			WriteByte (MSG_ALL, SVC_CDTRACK);
			WriteByte (MSG_ALL, 2);
			WriteByte (MSG_ALL, 3);

			WriteByte (MSG_ALL, SVC_FINALE);
			WriteString (MSG_ALL, "The Rune of Black Magic throbs evilly in\nyour hand and whispers dark thoughts\ninto your brain. You learn the inmost\nlore of the Hell-Mother; Shub-Niggurath!\nYou now know that she is behind all the\nterrible plotting which has led to so\nmuch death and horror. But she is not\ninviolate! Armed with this Rune, you\nrealize that once all four Runes are\ncombined, the gate to Shub-Niggurath's\nPit will open, and you can face the\nWitch-Goddess herself in her frightful\notherworld cathedral.");
			return;
		}
		else if (world.model == "maps/e3m6.bsp")
		{
			WriteByte (MSG_ALL, SVC_CDTRACK);
			WriteByte (MSG_ALL, 2);
			WriteByte (MSG_ALL, 3);

			WriteByte (MSG_ALL, SVC_FINALE);
			WriteString (MSG_ALL, "The charred viscera of diabolic horrors\nbubble viscously as you seize the Rune\nof Hell Magic. Its heat scorches your\nhand, and its terrible secrets blight\nyour mind. Gathering the shreds of your\ncourage, you shake the devil's shackles\nfrom your soul, and become ever more\nhard and determined to destroy the\nhideous creatures whose mere existence\nthreatens the souls and psyches of all\nthe population of Earth.");
			return;
		}
		else if (world.model == "maps/e4m7.bsp")
		{
			WriteByte (MSG_ALL, SVC_CDTRACK);
			WriteByte (MSG_ALL, 2);
			WriteByte (MSG_ALL, 3);

			WriteByte (MSG_ALL, SVC_FINALE);
			WriteString (MSG_ALL, "Despite the awful might of the Elder\nWorld, you have achieved the Rune of\nElder Magic, capstone of all types of\narcane wisdom. Beyond good and evil,\nbeyond life and death, the Rune\npulsates, heavy with import. Patient and\npotent, the Elder Being Shub-Niggurath\nweaves her dire plans to clear off all\nlife from the Earth, and bring her own\nfoul offspring to our world! For all the\ndwellers in these nightmare dimensions\nare her descendants! Once all Runes of\nmagic power are united, the energy\nbehind them will blast open the Gateway\nto Shub-Niggurath, and you can travel\nthere to foil the Hell-Mother's plots\nin person.");
			return;
		}

		GotoNextMap();
	}
	
	if (intermission_running == 3)
	{
		if (!cvar("registered"))
		{	// shareware episode has been completed, go to sell screen
			WriteByte (MSG_ALL, SVC_SELLSCREEN);
			return;
		}
		
		if ( (serverflags&15) == 15)
		{
			WriteByte (MSG_ALL, SVC_FINALE);
			WriteString (MSG_ALL, "Now, you have all four Runes. You sense\ntremendous invisible forces moving to\nunseal ancient barriers. Shub-Niggurath\nhad hoped to use the Runes Herself to\nclear off the Earth, but now instead,\nyou will use them to enter her home and\nconfront her as an avatar of avenging\nEarth-life. If you defeat her, you will\nbe remembered forever as the savior of\nthe planet. If she conquers, it will be\nas if you had never been born.");
			return;
		}
		
	}

	GotoNextMap();
};

/*
============
IntermissionThink

When the player presses attack or jump, change to the next level
============
*/
void() IntermissionThink =
{
	if (time < intermission_exittime)
		return;

	if (!self.button0 && !self.button1 && !self.button2)
		return;
	
	ExitIntermission ();
};

void() execute_changelevel =
{
	local entity	pos;

	intermission_running = 1;
	
// enforce a wait time before allowing changelevel
	if (deathmatch)
		intermission_exittime = time + 5;
	else
		intermission_exittime = time + 2;

	WriteByte (MSG_ALL, SVC_CDTRACK);
	WriteByte (MSG_ALL, 3);
	WriteByte (MSG_ALL, 3);
	
	pos = FindIntermission ();

	other = find (world, classname, "player");
	while (other) // != world)
	{
		other.view_ofs = '0 0 0';
		other.angles = other.v_angle = pos.mangle;
		other.fixangle = TRUE;		// turn this way immediately
		other.nextthink = time + 0.5;
		other.takedamage = DAMAGE_NO;
		other.solid = SOLID_NOT;
		other.movetype = MOVETYPE_NONE;
		other.modelindex = 0;
		setorigin (other, pos.origin);
		other = find (other, classname, "player");
	}	

	WriteByte (MSG_ALL, SVC_INTERMISSION);
};


void() changelevel_touch =
{
//	local entity	pos;	// fx_warning

	if (other.classname != "player")
		return;

	if ((cvar("noexit") == 1) || ((cvar("noexit") == 2) && (mapname != "start")))
	{
		T_Damage (other, self, self, 50000);
		return;
	}

	if (coop || deathmatch)
	{
		bprint (other.netname);
		bprint (" exited the level\n");
	}
	
	nextmap = self.map;

	SUB_UseTargets ();

	if ( (self.spawnflags & 1) && (! deathmatch) ) // == 0) )
	{	// NO_INTERMISSION
		GotoNextMap();
		return;
	}
	
	self.touch = SUB_Null;

// we can't move people right now, because touch functions are called
// in the middle of C movement code, so set a think time to do it
	self.think = execute_changelevel;
	self.nextthink = time + 0.1;
};

/*
=============================================================================

				PLAYER GAME EDGE FUNCTIONS

=============================================================================
*/

// called by ClientKill and DeadThink
void() respawn =
{
	if (coop)
	{
		// make a copy of the dead body for appearances sake
		CopyToBodyQue (self);
		// get the spawn parms as they were at level start
		setspawnparms (self);
		// respawn		
		PutClientInServer ();
	}
	else if (deathmatch)
	{
		// make a copy of the dead body for appearances sake
		CopyToBodyQue (self);
		// set default spawn parms
		SetNewParms ();
		// respawn		
		PutClientInServer ();
	}
	else
	{	// restart the entire server
		localcmd ("restart\n");
	}
};

void() gibMonster;

/*
============
ClientKill

Player entered the suicide command
============
*/
void() ClientKill =
{
#ifdef opgrade
	if ((intermission_running) && ((coop) || (deathmatch)))  // not allowed during intermission
		return;
#endif
	bprint (self.netname);
	bprint (" suicides\n");
//	set_suicide_frame ();
	gibMonster();
	ThrowHead ("models/objects/gibs/skull/tris.md2", self.health);
//	self.modelindex = modelindex_player;
	self.frags = self.frags - 2;	// extra penalty  
  
  //Stroggannoff EXT-COOP / playerCache ops
  local entity cache;
  cache = PLAYER_CACHE_ENTS[self.playerCache];
  if(cache && self){
    sv_coop_client_setCache(self, cache);
  }
  
	respawn ();
};

#ifdef unused
float(vector v) CheckSpawnPoint =
{
	return FALSE;
};

#endif


/*
  Stroggannoff co-op
    info_player_coop now has 2 specific fields
      isActive
      coopId
      
    these spawn points are controlled by map-logic and player coopID
      giving the map high-level control over player spawn locations.
*/
entity() selectCoopSpawnPoint={
  local entity point;
  
  point = findchain(classname, "info_player_coop");
  while(point){
    if(point.isActive){
      if(point.coopId == self.coopId){
        return point;
      }
    }
    point = point.chain;
  }
  
  return point;
};
/*
============
SelectSpawnPoint

Returns the entity to spawn at
============
*/
entity() SelectSpawnPoint =
{
	local	entity spot;
	local	entity thing;
	local	float  pcount;
	
// testinfo_player_start is only found in regioned levels
	spot = find (world, classname, "testplayerstart");
	if (spot)
		return spot;
		
// choose a info_player_deathmatch point
	if (coop)
	{
    //Stroggannoff - check for cool new co-op spawns.
    spot = selectCoopSpawnPoint();
    if(spot){
      return spot;
    }
    else{
      //Stroggannoff - we didn't find hip new co-op spawns, defaulting behavior.
      lastspawn = find(lastspawn, classname, "info_player_coop");
      if (! lastspawn){// == world)
        lastspawn = find (lastspawn, classname, "info_player_start");
      }
      if (lastspawn){ // != world)
        return lastspawn;
      }
    }
	}
	else if (deathmatch)
	{
		spot = lastspawn;
		while (1)
		{
			spot = find(spot, classname, "info_player_deathmatch");
			if (spot) // != world)
			{
				if (spot == lastspawn)
					return lastspawn;
				pcount = 0;
				thing = findradius(spot.origin, 32);
				while(thing)
				{
					if (thing.classname == "player")
						pcount = pcount + 1;
					thing = thing.chain;
				}
				if (! pcount) // == 0)
				{
					lastspawn = spot;
					return spot;
				}
			}
		}
	}

	if (serverflags)
	{	// return with a rune to start
		spot = find (world, classname, "info_player_start2");
		if (spot)
			return spot;
	}
	
	spot = find (world, classname, "info_player_start");
	if (!spot)
#ifdef noobjerr
	{
// later use our uber random find dest
		spot = find (world, classname, "info_player_deathmatch");
		if (!spot) spot = find (world, classname, "info_teleport_destination");
		if (!spot) spot = find (world, classname, "info_intermission");
		if (!spot)
		{
			spot = spawn(); // bounce player in at 0, 0, 0 - might be a bad move
			spot.classname =  "info_player_start"; // save for DM / coop spawns
		}

	}
#else
		error ("PutClientInServer: no info_player_start on level");					//opgrade protected
#endif
	
	return spot;
};

/*
===========
setPlayerModel

called each time a player is spawned
============
*/
void() DecodeLevelParms;
void() q2PlayerDie;
void() q2Player_stand;

void(entity ent) setPlayerModel =
{
	local float i;

	ent.skin = cvar("skin");
	
	if (ent.isbot == 1)
	{
		ent.playerType = PT_OTHER;
		
		if (random() > 0.8){
			ent.skin = 2;
		}
		else if (random() > 0.5){
			ent.skin = 1;
		}
		else{
			ent.skin = 0;
		}
	}
	
	if(ent.playerType == PT_MALE)
	{
		setmodel (ent, "players/male/tris.md2");
		setsize (ent, VEC_HULL_MIN, VEC_HULL_MAX);
		
	}
	else if (ent.playerType == PT_FEMALE)
	{
		setmodel (ent, "players/female/tris.md2");
		setsize (ent, VEC_HULL_MIN, VEC_HULL_MAX);
	
	}
	else
	{
		setmodel (ent, "players/cyborg/tris.md2");
		setsize (ent, VEC_HULL_MIN, VEC_HULL_MAX);
	}
}

/*
===========
PutClientInServer

called each time a player is spawned
============
*/

void() PutClientInServer =
{
  
	local	entity spot;
	local float i;

	spot = SelectSpawnPoint ();
	
	self.classname = "player";
	self.health = 100;
	self.takedamage = DAMAGE_AIM;
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_WALK;
	self.show_hostile = 0;
	self.max_health = 100;
	self.flags = FL_CLIENT;
	self.air_finished = time + 12;
	self.dmg = 2;   		// initial water damage
	self.super_damage_finished = 0;
	self.radsuit_finished = 0;
	self.rebreather_finished = 0;	
	self.invisible_finished = 0;
	self.invincible_finished = 0;
	self.silencer_finished = 0;	
	self.effects = 0;
	self.invincible_time = 0;
	self.onladder = 0;
	self.alpha = 1.0;
	self.player_pickup_itemnum = 0;
	#ifdef q2model_lighting
	self.effects = EF_FULLBRIGHT; //MrC Lightgrid workaround
	#endif
  
  //Stroggannoff EXT-COOP / playerCache ops
  local entity cache;
  cache = PLAYER_CACHE_ENTS[self.playerCache];
  if(self.isNewCache){
    DecodeLevelParms ();
    if(cache && self){
      sv_coop_client_setCache(self, cache);
      self.isNewCache = FALSE;
    }
  }
  else{
    if(cache && self){
      sv_coop_client_setCache(cache, self);
    }
  }

	self.attack_finished = time;
	self.th_pain = q2player_pain;
	self.th_die = q2PlayerDie;
	
	self.deadflag = DEAD_NO;
// paustime is set by teleporters to keep the player from moving a while
	self.pausetime = 0;

	/*
	if (autocvar_cl_playertype == PT_MALE)
	{
		self.playerType = PT_MALE;
	}
	if (autocvar_cl_playertype == PT_FEMALE)
	{
		self.playerType = PT_FEMALE;
	}
	if (autocvar_cl_playertype == PT_OTHER)
	{
		self.playerType = PT_OTHER;
	}
	*/
	
//	spot = SelectSpawnPoint ();

	//self.playerType = PT_MALE;

	
#ifdef opgrade
	self.oldorigin = 
#endif
	self.origin = spot.origin + '0 0 1';	// 1998-07-21 Respawning where player died fix by Robert Field
	self.angles = spot.angles;
	self.fixangle = TRUE;		// turn this way immediately

// oh, this is a hack!
//	setmodel (self, "progs/eyes.mdl");
//	modelindex_eyes = self.modelindex;

	self.view_ofs = '0 0 22';

#ifdef opgrade
	self.velocity = '0 0 0';	// 1998-07-21 Player moves after respawn fix by Xian
#endif
//	setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
	setPlayerModel(self);
	q2Player_stand();
	AttachTPWeapon();
	spawnPowerupShell();
	spawnPLRpowerupShell();	
	
	//setup player v_wep state machine
	self.weapon_next = self.weapon;
  if(!(self.inv_weapons & WEP_BLASTER)){
    self.inv_weapons = self.inv_weapons | WEP_BLASTER;
  }
  
	W_ChangeWeapon();
  
	if (deathmatch || coop)
	{
		makevectors(self.angles);
		spawn_tfog (self.origin + v_forward*20);
	}
	spawn_tdeath (self.origin, self);
  
	// pOx - START - func_water support
	self.fwatershift = TRUE;// catch runaway cshifts (changlevel/respawn while in func_water)
	self.oldgravity = 0;// use unmodified sv_gravity
	// pOx - END - func_water support
	
	if (world.fadein == 1)
	{
		stuffcmd(self, "bf 0 0 0 1\n");
	}
};


/*
=============================================================================

				QUAKED FUNCTIONS

=============================================================================
*/

/*
saved out by quaked in region mode
*/
#ifdef debug
// CHECK: search map source - find out if regioned mode is ever used REMOVE this check
void() testplayerstart =
{
};
#endif

/*
===============================================================================

RULES

===============================================================================
*/

/*
go to the next level for deathmatch
only called if a time or frag limit has expired
*/
void() NextLevel =
{
	local entity o;

	if (mapname == "start")
	{
		if (!cvar("registered"))
		{
			mapname = "e1m1";
		}
		else if (!(serverflags & 1))
		{
			mapname = "e1m1";
			serverflags = serverflags | 1;
		}
		else if (!(serverflags & 2))
		{
			mapname = "e2m1";
			serverflags = serverflags | 2;
		}
		else if (!(serverflags & 4))
		{
			mapname = "e3m1";
			serverflags = serverflags | 4;
		}
		else if (!(serverflags & 8))
		{
			mapname = "e4m1";
			serverflags = serverflags - 7;
		}

		o = spawn();
		o.map = mapname;
	}
	else
	{
		// find a trigger changelevel
		o = find(world, classname, "trigger_changelevel");

		// go back to start if no trigger_changelevel
		if (!o)
		{
			mapname = "start";
			o = spawn();
			o.map = mapname;
		}
	}

	nextmap = o.map;
	gameover = TRUE;
	
	if (o.nextthink < time)
	{
		o.think = execute_changelevel;
		o.nextthink = time + 0.1;
	}
};

/*
============
CheckRules

Exit deathmatch games upon conditions
============
*/
void() CheckRules =
{
	local	float		timelimit;
	local	float		fraglimit;
	local string s;
	
	if (gameover)	// someone else quit the game already
		return;
		
	timelimit = cvar("timelimit") * 60;
	fraglimit = cvar("fraglimit");
	
#ifdef opgrade
	if (deathmatch)	// 1998-07-27 Timelimit/Fraglimit fix by Maddes
#endif
	if (timelimit && time >= timelimit)
	{
		NextLevel();
//		return;
	}
	
#ifdef opgrade
	if (deathmatch)	// 1998-07-27 Timelimit/Fraglimit fix by Maddes
#endif
	if (fraglimit && self.frags >= fraglimit)
	{
		NextLevel();
//		return;
	}	
};

//============================================================================

void() PlayerDeathThink =
{
//	local entity	old_self;	// fx_warning
	local float		forward;

	// pOx - func_water support
	CheckFuncWaterDeath();//check cshift for dead players in func_water	
	
	if ((self.flags & FL_ONGROUND))
	{
		forward = vlen (self.velocity);
		forward = forward - 20;
		if (forward <= 0)
			self.velocity = '0 0 0';
		else	
			self.velocity = forward * normalize(self.velocity);
	}

// wait for all buttons released
	if (self.deadflag == DEAD_DEAD)
	{
		if (self.button2 || self.button1 || self.button0)
			return;
		self.deadflag = DEAD_RESPAWNABLE;
		return;
	}

// wait for any button down
	if (!self.button2 && !self.button1 && !self.button0)
		return;

	self.button0 = 0;
	self.button1 = 0;
	self.button2 = 0;
	respawn();
};

void() q2player_jumpframes;

void() PlayerJump =
{
//	local vector start, end;	// fx_warning
	
	if (self.flags & FL_WATERJUMP)
		return;
	
	if (self.flags & FL_DUCKED){
		crouch_off();
		return;
	}
	
	if (self.waterlevel >= 2)
	{
		if (self.watertype == CONTENT_WATER)
			self.velocity_z = 100;
		else if (self.watertype == CONTENT_SLIME)
			self.velocity_z = 80;
		else
			self.velocity_z = 50;

// play swiming sound
		if (self.swim_flag < time)
		{
			self.swim_flag = time + 1;
			if (random() < 0.5)
				sound (self, CHAN_BODY, "misc/water1.wav", 1, ATTN_NORM);
			else
				sound (self, CHAN_BODY, "misc/water2.wav", 1, ATTN_NORM);
		}

		return;
	}

	if (!(self.flags & FL_ONGROUND))
		return;

	if ( !(self.flags & FL_JUMPRELEASED) )
		return;		// don't pogo stick

	self.flags = self.flags - (self.flags & FL_JUMPRELEASED);

	self.flags = self.flags - FL_ONGROUND;	// don't stairwalk
	
	self.button2 = 0;
// player jumping sound
//	sound (self, CHAN_VOICE, "player/plyrjmp8.wav", 1, ATTN_NORM);
	playerVOSound(PLAYER_VOICE_JUMP);
	q2player_jumpframes();
	self.velocity_z = self.velocity_z + 285; //270
};


/*
===========
WaterMove

============
*/
.float	dmgtime;

void() WaterMove =
{
//dprint (ftos(self.waterlevel));
	if (self.movetype == MOVETYPE_NOCLIP)
		return;
	if (self.health < 0)
		return;

	if (self.waterlevel != 3)
	{
		if (self.air_finished < time)
			sound (self, CHAN_VOICE, "player/gasp2.wav", 1, ATTN_NORM);
		else if (self.air_finished < time + 9)
			sound (self, CHAN_VOICE, "player/gasp2.wav", 1, ATTN_NORM); 
		//changed to more generic gasp2 because of player types
		self.air_finished = time + 12;
		self.dmg = 2;
	}
	else if (self.air_finished < time)
	{	// drown!
		if (self.pain_finished < time)
		{
			self.dmg = self.dmg + 2;
			if (self.dmg > 15)
				self.dmg = 10;
			T_Damage (self, world, world, self.dmg);
			self.pain_finished = time + 1;
		}
	}
	
	if (!self.waterlevel)
	{
		if (self.flags & FL_INWATER)
		{	
			// play leave water sound
			sound (self, CHAN_BODY, "misc/outwater.wav", 1, ATTN_NORM);
			self.flags = self.flags - FL_INWATER;
		}
		return;
	}

	if (self.watertype == CONTENT_LAVA)
	{	// do damage
		if (self.dmgtime < time)
		{
			if (self.radsuit_finished > time)
				self.dmgtime = time + 1;
			else
				self.dmgtime = time + 0.2;

			T_Damage (self, world, world, 10*self.waterlevel);
		}
	}
	else if (self.watertype == CONTENT_SLIME)
	{	// do damage
		if (self.dmgtime < time && self.radsuit_finished < time)
		{
			self.dmgtime = time + 1;
			T_Damage (self, world, world, 4*self.waterlevel);
		}
		if (self.waterlevel >= 3){
			if (self.numoverlays <= 1){
				SetVModelOverlaySelf('0 0 0', "models/overlay.md3", OVERLAY_SLIME, '1 0 0', 0.1, 2);
				self.numoverlays++;				
			}			
		}
	}
	
	if ( !(self.flags & FL_INWATER) )
	{	
		// player enter water sound

		if (self.watertype == CONTENT_LAVA)
			sound (self, CHAN_BODY, "player/inlava.wav", 1, ATTN_NORM);
		if (self.watertype == CONTENT_WATER)
			sound (self, CHAN_BODY, "player/inh2o.wav", 1, ATTN_NORM);
		if (self.watertype == CONTENT_SLIME)
			sound (self, CHAN_BODY, "player/slimbrn2.wav", 1, ATTN_NORM);

		self.flags = self.flags + FL_INWATER;
		self.dmgtime = 0;
	}
	
	if (! (self.flags & FL_WATERJUMP) )
		self.velocity = self.velocity - 0.8*self.waterlevel*frametime*self.velocity;
};

void() CheckWaterJump =
{
	local vector start, end;

// check for a jump-out-of-water
	makevectors (self.angles);
	start = self.origin;
	start_z = start_z + 8; 
	v_forward_z = 0;
	normalize(v_forward);
	end = start + v_forward*24;
	traceline (start, end, TRUE, self);
	if (trace_fraction < 1)
	{	// solid at waist
		start_z = start_z + self.maxs_z - 8;
		end = start + v_forward*24;
		self.movedir = trace_plane_normal * -50;
		traceline (start, end, TRUE, self);
		if (trace_fraction == 1)
		{	// open at eye level
			self.flags = self.flags | FL_WATERJUMP;
			self.velocity_z = 225;
			self.flags = self.flags - (self.flags & FL_JUMPRELEASED);
			self.teleport_time = time + 2;	// safety net
//			return;
		}
	}
};
/*

LADDER STUFF from Quake 1.5


*/


void() LadderSound2 =
{
	if (self.timeladder < time) 
	{
	// Reset timer for next sound to play
	self.timeladder = time + 0.35;
	// Check for any sounds and query if footsteps are active

			if (random() < 0.25) 
				sound (self, CHAN_BODY, "player/clank1.wav", 1, ATTN_NORM);
			else if (random() < 0.5) 
				sound (self, CHAN_BODY, "player/clank1.wav", 1, ATTN_NORM);
			else if (random() < 0.75) 
				sound (self, CHAN_BODY, "player/clank1.wav", 1, ATTN_NORM);
			else 
				sound (self, CHAN_BODY, "player/clank1.wav", 1, ATTN_NORM);
	}
}

void() LadderSound =
{
	if (self.timeladder < time) 
	{
	// Reset timer for next sound to play
	self.timeladder = time + self.entladder.waitmin;
	// Check for any sounds and query if footsteps are active
		if (self.entladder.sounds != 4) 
		{
			self.lip = random();
			if (self.lip < 0.25 && self.entladder.noise1) 
				sound (self, CHAN_BODY, self.entladder.noise1, 1, ATTN_NORM);
			else if (self.lip < 0.5 && self.entladder.noise2) 
				sound (self, CHAN_BODY, self.entladder.noise2, 1, ATTN_NORM);
			else if (self.lip < 0.75 && self.entladder.noise3) 
				sound (self, CHAN_BODY, self.entladder.noise3, 1, ATTN_NORM);
			else if (self.entladder.noise4) 
				sound (self, CHAN_BODY, self.entladder.noise4, 1, ATTN_NORM);
		}
	}
}

void() Ladder_ClimbJump =
{
	// Reset velocity upwards and all sideways movement
	// so that the player stays on the ladder and climbs
	// straight up with very little sidways movement
	self.velocity = '0 0 0';
	
	//Updated ladder movement - look in the direction you want to move and hold jump
	
	if (self.v_angle_x < -25) //-25
		self.velocity_z = self.entladder.speed; //climb up with the ladder speed when player is looking up
	else if (self.v_angle_x > 25) //25
		self.velocity_z = -self.entladder.speed; //negate ladder speed when player looks down, was not possible to descend before
	else 
		self.velocity = v_forward*215; //holding jump while looking straight on will dismount the player
	//self.velocity_z = self.entladder.speed;
	LadderSound();
}

void() Ladder_ClimbMove =
{
	//Use Dot products to determine if user is trying to move up or down
	
	if (Dot(v_forward,self.velocity) > 2 || Dot(v_up,self.velocity) < -20 || Dot(v_up,self.velocity) > 20) //-20 20
	{
		//self.velocity = v_forward*self.entladder.speed;
		if (self.v_angle_x < -25) //-25
			self.velocity_z = self.entladder.speed; //climb up with the ladder speed when player is looking up
		else if (self.v_angle_x > 25) //25
		{
			self.velocity = v_forward*self.entladder.speed;
			self.velocity_z = -self.entladder.speed; //negate ladder speed when player looks down, was not possible to descend before
		}
		else 
		//	self.velocity = '0 0 0'; //let the player hover on ladder when not moving forward
		LadderSound();
		LadderSound2();			
	}
}


/*
================
PlayerPreThink

Called every frame before physics are run
================
*/
void() PlayerPreThink =
{
//	local	float	mspeed, aspeed;	// fx_warning
//	local	float	r;	// fx_warning

#ifdef FRIKBOT

// frikbot tie-in
	if (autocvar_bot_create_dynamic_waypoint == 1){ //MrC: temp "fix", will move this later.
	if ( BotPreFrame () )
		return ;
}
#endif

	if (intermission_running)
	{
		IntermissionThink ();	// otherwise a button could be missed between
		return;					// the think tics
	}

	if (!self.view_ofs) // == '0 0 0')
		return;		// intermission or finale

	makevectors (self.v_angle);		// is this still used

	// pOx - START - func_water & func_ladder support
	// Set cshift back to normal if eyes are out of func_water
	if (self.fwatershifttime < time) {
		if (self.fwatershift) {
			stuffcmd(self, "v_cshift 130 80 50 0\n");
			self.fwatershift = FALSE;
		}
	}
	// Both func_water and func_ladder require zero G to work properly.
	// Lucky for us, the Mission Pack build of Quake has a gravity modifier we can exploit.
	if (self.zerogtime < time)
		self.gravity = self.oldgravity;// reset normal gravity
	else
		self.gravity = 0.0001;// zero G (0 OR 1 is normal)
	// pOx - END  - func_water & func_ladder support	
	
	CheckRules ();
	WaterMove ();

	if (self.waterlevel == 2)
		CheckWaterJump ();

	if (self.deadflag >= DEAD_DEAD)
	{
		PlayerDeathThink ();
		return;
	}
	
	if (self.deadflag == DEAD_DYING)
		return;	// dying, so do nothing

	if (self.button2)
	{
		if (self.flags & FL_DUCKED)
			return;
		
		PlayerJump ();
	}
	else
		self.flags = self.flags | FL_JUMPRELEASED;

// teleporters can force a non-moving pause time	
	if (time < self.pausetime)
		self.velocity = '0 0 0';

	//----------------------------------------------------------------------
	// Rubicon Ladder Code - johnfitz
	// Modified by me to support diff climb sounds and on/off/toggle states
	//----------------------------------------------------------------------
	
	if (self.onladder) {
		self.onladder = 0;		// Reset ladder touch function
		if (self.button2) {		// Is jump key being pressed?
			
			//Climb Ladder with jump key
			Ladder_ClimbJump();
			
			if (self.health > 0)
				self.gravity = 0.0000001;
			
		}
		else {
			
			// Jump key released, stay floating on the ladder
			self.flags = self.flags | FL_JUMPRELEASED;
			self.velocity = 0.7 * self.velocity;
			self.velocity_z = 0;

			//climb ladder with forward key
			Ladder_ClimbMove();
			if (self.health > 0)
				self.gravity = 0.0000001;
			
			
		}
	}
	else {
		// Reset any ladder gravity settings
		self.gravity = 1;
		// Original jump conditions
		//if (self.button2) PlayerJump ();
		//else self.flags = self.flags | FL_JUMPRELEASED;
	}
};

.float breathcount;
	
/*
================
CheckPowerups

Check for turning off powerups
================
*/
void() CheckPowerups =
{
	if (self.health <= 0)
		return;

// invisibility
	if (self.invisible_finished)
	{
// sound and screen flash when items starts to run out
/*
		if (self.invisible_sound < time)
		{
		//	sound (self, CHAN_AUTO, "items/inv3.wav", 0.5, ATTN_IDLE);
			self.invisible_sound = time + ((random() * 3) + 1);
		}
*/

		if (self.invisible_finished < time + 3)
		{
			if (self.invisible_time == 1)
			{
				sprint (self, "Cloak is failing\n");
				stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, "items/inv2.wav", 1, ATTN_NORM);
				self.invisible_time = time + 1;
			}
			
			if (self.invisible_time < time)
			{
				self.invisible_time = time + 1;
				stuffcmd (self, "bf\n");

			}
		}

		if (self.invisible_finished < time)
		{	// just stopped
			self.items = self.items - IT_INVISIBILITY;
			self.invisible_finished = 0;
			self.invisible_time = 0;
		//	self.alpha = 1.0;
		}
		
	// use the eyes
		//self.frame = 0;
		//self.modelindex = modelindex_eyes;
	//	self.alpha = 0.05;
	}

// invincibility
	if (self.invincible_finished)
	{
// sound and screen flash when items starts to run out
		if (self.invincible_finished < time + 3)
		{
			if (self.invincible_time == 1)
			{
				sprint (self, "Protection is almost burned out\n");
				stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, "items/protect2.wav", 1, ATTN_NORM);
				self.invincible_time = time + 1;
			}
			
			if (self.invincible_time < time)
			{
				self.invincible_time = time + 1;
				stuffcmd (self, "bf\n");
			}
		}
		
		if (self.invincible_finished < time)
		{	// just stopped
			self.items = self.items - IT_INVULNERABILITY;
			self.invincible_time = 0;
			self.invincible_finished = 0;
		}
		/*
		if (self.invincible_finished > time)
			self.effects = self.effects | EF_DIMLIGHT;
		else
			self.effects = self.effects - (self.effects & EF_DIMLIGHT);
		*/
	}

// super damage
	if (self.super_damage_finished)
	{

// sound and screen flash when items starts to run out

		if (self.super_damage_finished < time + 3)
		{
			if (self.super_time == 1)
			{
				sprint (self, "Quad Damage is wearing off\n");
				stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, "items/damage2.wav", 1, ATTN_NORM);
				self.super_time = time + 1;
			}	  
			
			if (self.super_time < time)
			{
				self.super_time = time + 1;
				stuffcmd (self, "bf\n");
			}
		}

		if (self.super_damage_finished < time)
		{	// just stopped
		//	self.items = self.items - IT_QUAD;
			removeBitsFromEntity(self,items,IT_QUAD);
			self.super_damage_finished = 0;
			self.super_time = 0;
		}
		/*
		if (self.super_damage_finished > time){
			self.effects = self.effects | EF_BLUE;
		//	removeBitsFromEntity(self,pflags,PFLAGS_NOSHADOW);
		}
		else{
			self.effects = self.effects - (self.effects & EF_BLUE);
		}
		*/
	}	

// suit	
	if (self.radsuit_finished)
	{

		if (self.rebreather_sound < time)
		{
			if (self.waterlevel >= 3)
			{
				if (self.breathcount == 0)
				{
					sound (self, CHAN_AUTO, "player/u_breath1.wav", 0.5, ATTN_IDLE);
					self.breathcount = 1;
				}
				else
				{
					sound (self, CHAN_AUTO, "player/u_breath2.wav", 0.5, ATTN_IDLE);
					self.breathcount = 0;
					pointparticles(particleeffectnum("TR_GRENADE"), (self.origin + '0 0 24'), '0 32 0', 1);					
				}				
				self.rebreather_sound = time + ((random() * 5) + 2);
			}
		}		
		
		self.air_finished = time + 12;		// don't drown
		
// sound and screen flash when items starts to run out
		
		if (self.radsuit_finished < time + 3)
		{
			if (self.rad_time == 1)
			{
				sprint (self, "Air supply in Biosuit expiring\n");
				stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, "items/suit2.wav", 1, ATTN_NORM);
				self.rad_time = time + 1;
			}
			
			if (self.rad_time < time)
			{
				self.rad_time = time + 1;
				stuffcmd (self, "bf\n");
			}
		}

		if (self.radsuit_finished < time)
		{	// just stopped
			self.items = self.items - IT_SUIT;
			self.rad_time = 0;
			self.radsuit_finished = 0;
		}
	}
	
// rebreather	
	if (self.rebreather_finished)
	{

		if (self.rebreather_sound < time)
		{
			if (self.waterlevel >= 3)
			{
				if (self.breathcount == 0)
				{
					sound (self, CHAN_AUTO, "player/u_breath1.wav", 0.5, ATTN_IDLE);
					self.breathcount = 1;
				}
				else
				{
					sound (self, CHAN_AUTO, "player/u_breath2.wav", 0.5, ATTN_IDLE);
					self.breathcount = 0;
				}				
				self.rebreather_sound = time + ((random() * 5) + 1);
			}
		}	
	
		self.air_finished = time + 12;		// don't drown
		
// sound and screen flash when items starts to run out
		
		if (self.rebreather_finished < time + 3)
		{
			if (self.rad_time == 1)
			{
				sprint (self, "Rebreather expiring\n");
				stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, "items/suit2.wav", 1, ATTN_NORM);
				self.rad_time = time + 1;
			}
			
			if (self.rad_time < time)
			{
				self.rad_time = time + 1;
				stuffcmd (self, "bf\n");
			}
		}

		if (self.rebreather_finished < time)
		{	// just stopped
			self.items = self.items - IT_BREATHER;
			self.rad_time = 0;
			self.rebreather_finished = 0;
		}
	}	
	
	// "silencer" / doubler actually it's 25%
	if (self.silencer_finished)
	{

// sound and screen flash when items starts to run out

		if (self.silencer_finished < time + 3)
		{
			if (self.silencer_time == 1)
			{
				sprint (self, "Doubler is wearing off\n");
				stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, "items/inv2.wav", 1, ATTN_NORM);
				self.silencer_time = time + 1;
			}	  
			
			if (self.silencer_time < time)
			{
				self.silencer_time = time + 1;
				stuffcmd (self, "bf\n");
			}
		}

		if (self.silencer_finished < time)
		{	// just stopped
			self.items = self.items - IT_DOUBLER;
			self.silencer_finished = 0;
			self.silencer_time = 0;
		}
	}

};


/*
================
PlayerPostThink

Called every frame after physics are run
================
*/

void() q2player_landframes;


//this is a little jank atm but just wanted to experiment
void() W_roomTrace =
{
	local	vector	source;
	local	vector	org;
	local	float	roomheight;
	local	float	roomwidth;
	local	float	roomwidth2;	
	local 	float	roomsize; 	

//	makevectors (self.v_angle);
	source = self.origin + '0 0 16';

//Trace room height	
	traceline (source, source + '0 0 2048', FALSE, self);
//	if (trace_fraction == 1.0)
//		return;
	org = trace_endpos;
//	Q3Surface_Impact(org);	
	roomheight = vlen(org);

//Trace room width +y
	traceline (source, source + '0 2048 0', FALSE, self);
	
//	if (trace_fraction == 1.0)
//		return;	
	org = trace_endpos;
//	Q3Surface_Impact(org);	
	roomwidth = vlen(org);
	
//Trace room width -y
	traceline (source, source + '0 -2048 0', FALSE, self);
	org = trace_endpos;
//	Q3Surface_Impact(org);	
	roomwidth2 = vlen(org);

	roomsize = roomheight + (roomwidth + roomwidth2);

//	FLOG(floor(roomheight + roomwidth));

	FLOG(roomsize);
	
	if (roomsize < 500){
		LOG("Small room");
	}
	else if (roomsize < 1250){
		LOG("Medium room");
	}
	else if (roomsize < 2500){
		LOG("Large room");
	}
	else if (roomsize < 4000){
		LOG("Auditorium");
	}	
	else
	{
		LOG("Bigger on the inside.");
	}
	
//	Q3Surface_Impact(org);
};

void() W_surfaceSniffer =
{
	local	vector	source;
	local	vector	org;

	makevectors (self.v_angle);
	source = self.origin + '0 0 -16';
	traceline (source, source + v_forward*32, FALSE, self);
	org = trace_endpos - v_forward*4;
	
	if (self.movetype == MOVETYPE_NOCLIP)
		return;

//	makevectors (self.v_angle);

	tracebox (self.origin, VEC_HULL_MIN, VEC_HULL_MAX, self.origin + '32 0 0', FALSE, self);
	
	
//	if (trace_dphitcontents == 4097)
//	if (trace_dphitcontents == 4104)
//	if (trace_dphitcontents == 4864) //this seems to be ladder?
//	well I give up! :(
	/*
	if (trace_dphitcontents ==	4864)
	{
		bprint ("Ladder?");
		bprint ("\n");
	//	self.onladder = TRUE;
	//	self.velocity_z = 160;
		self.movetype = MOVETYPE_FLY;
	}
	else if (!trace_dphitcontents)
	{
	//	self.onladder = FALSE;
		self.movetype = MOVETYPE_WALK;
	}
	*/
};

void() PlayerPostThink =
{
//	local	float	mspeed, aspeed;	// fx_warning
//	local	float	r;	// fx_warning

#ifdef FRIKBOT

// frikbot tie-in

	if ( BotPostFrame () )
		return ;

#endif

	if (!self.view_ofs) // == '0 0 0')
		return;		// intermission or finale
	if (self.deadflag)
		return;

	if (self.button4){
			crouch_on ();
	}
	else
	{
		crouch_off ();
	}
	
// do weapon stuff
	W_WeaponFrame ();
	
	if(self.weapon_update_func && self.weapon_update_func != SUB_Null){
		W_WeaponAnimate();
	}
	
// check to see if player landed and play landing sound
	if ((self.jump_flag < -100) && (self.flags & FL_ONGROUND) && (self.health > 0))
	{
		if (self.watertype == CONTENT_WATER)
			sound (self, CHAN_BODY, "player/h2ojump.wav", 1, ATTN_NORM);
		else if (self.jump_flag < -650)
		{
			T_Damage (self, world, world, 10);
			//sound (self, CHAN_VOICE, "player/land2.wav", 1, ATTN_NORM);
			playerVOSound(PLAYER_VOICE_LAND1);
			self.deathtype = "falling";
		}
		else if (self.jump_flag < -850)
		{
			T_Damage (self, world, world, 200);
			//sound (self, CHAN_VOICE, "player/land2.wav", 1, ATTN_NORM);
			playerVOSound(PLAYER_VOICE_LAND1);
			self.deathtype = "falling";
		}
		else
		{
			if (self.flags & FL_DUCKED)
			{
				Generic_FootStep();
				self.jump_flag = 0;
			}
			else
			{
				q2player_landframes();
				Generic_FootStep();
				//playerVOSound(PLAYER_VOICE_LAND2);
				self.jump_flag = 0;
			}
		}
			
		self.jump_flag = 0;
		self.punchangle_x = 1;
		self.punchvector = '0 0 -7';
	}

	if (!(self.flags & FL_ONGROUND))
		self.jump_flag = self.velocity_z;

	CheckPowerups ();

	//MrC Lightgrid workaround for Q2 style lighting on players in Q3BSP with Lightgrid
	/*
	if (autocvar_q2_classicmode >= 1)
	{
		self.colormod = (getlight(self.origin + '0 0 22') + '0.1 0.1 0.1');
	}
	*/
	
	Q3Surface_FootStep();

	if (autocvar_cl_printroomsize >= 1){
	W_roomTrace();
	}
	
	if (autocvar_cl_surfacesniffer >= 1)
	{
		W_surfaceSniffer();
		
		bprint ("Contents flag: ");
		bprint (ftos(trace_dphitcontents));
		bprint ("\n");
		bprint ("Surface flag: ");
		bprint (ftos(trace_dphitq3surfaceflags));
		bprint ("\n");
		bprint ("Surface name: ");
		bprint (trace_dphittexturename);
		bprint ("\n");
		bprint ("Surface start: ");
		bprint (ftos(trace_dpstartcontents));
		bprint ("\n");
	}

	if (autocvar_cl_printpos>= 1)
	{
		bprint ("Position: ");
		bprint (vtos(self.origin));
		bprint ("\n");
		bprint ("Angle: ");
		bprint (vtos(self.angles));
		bprint ("\n");
	}
	
	if (autocvar_cl_printstate >= 1)	
	{
		switch (self.weapon)
		{
		case 1:
			bprint ("BLASTER");
			break;
		case 2:
			bprint ("SHOTGUN");
			break;
		case 4:
			bprint ("SUPER SHOTGUN");
			break;
		case 8:
			bprint ("MACHINEGUN");
			break;
		case 16:
			bprint ("CHAINGUN");
			break;
		case 32:
			bprint ("GRENADE LAUNCHER");
			break;
		case 64:
			bprint ("ROCKET LAUNCHER");
			break;
		case 128:
			bprint ("HYPERBLASTER");
			break;
		case 256:
			bprint ("RAILGUN");
			break;
		case 512:
			bprint ("BFG");
			break;
		}
	bprint ("\n");
	bprint (" Weaponstate: ");
		switch (self.weaponstate)
		{
		case 0:
			bprint ("WEAPON_EMPTY");
			break;
		case 1:
			bprint ("WEAPON_READY");
			break;
		case 2:
			bprint ("WEAPON_ACTIVATING");
			break;
		case 3:
			bprint ("WEAPON_DROPPING");
			break;
		case 4:
			bprint ("WEAPON_SPINDOWN");
			break;
		case 5:
			bprint ("WEAPON_FIRING");
			break;
		}
	bprint ("\n");
	bprint ("State: ");
		switch (self.state)
		{
		case 0:
			bprint ("STATE_IDLE");
			break;
		case 1:
			bprint ("STATE_RUNNING");
			break;
		case 2:
			bprint ("STATE_ATTACKING");
			break;
		case 3:
			bprint ("STATE_NONE");
			break;
		}
	bprint ("\n");
	}
};


/*
===========
ClientConnect

called when a player connects to a server
============
*/
void() ClientConnect =
{

#ifdef FRIKBOT

// frikbot tie-in

	ClientInRankings();

  //Stroggannoff - ext_coop
  sv_coop_client_connect();

/*
   if ( ((self.netname == "CamClient") || (self.netname == "")) )
	{
		self.impulse = 250;
	}
	else
	{
		bprint (self.netname);
		bprint (" entered the game\n");
	}
*/

#endif

	bprint (self.netname);
	bprint (" entered the game\n");
	
// a client connecting during an intermission can cause problems
	if (intermission_running)
		ExitIntermission ();
};


/*
===========
ClientDisconnect

called when a player disconnects from a server
============
*/
void() ClientDisconnect =
{

#ifdef FRIKBOT

// frikbot tie-in

	ClientDisconnected();

#endif
  
  sv_coop_client_disconnect();
  
	if (gameover)
		return;
	// if the level end trigger has been activated, just return
	// since they aren't *really* leaving

	// let everyone else know
	bprint (self.netname);
	bprint (" left the game with ");
	bprint (ftos(self.frags));
	bprint (" frags\n");
	sound (self, CHAN_BODY, "player/tornoff2.wav", 1, ATTN_NONE);
//	set_suicide_frame ();
	self.health = 0; //used to remove attachments, hud models, etc...
	gibMonster();
	ThrowHead ("models/objects/gibs/skull/tris.md2", self.health);
};

/*
===========
ClientObituary

called when a player dies
============
*/
void(entity targ, entity attacker) ClientObituary =
{
	local	float rnum;
	local	string deathstring, deathstring2;
	rnum = random();

	if (targ.classname == "player")
	{
		if (attacker.classname == "teledeath")
		{
			bprint (targ.netname);
			bprint (" was telefragged by ");
			bprint (attacker.owner.netname);
			bprint ("\n");

			attacker.owner.frags = attacker.owner.frags + 1;
			return;
		}

		if (attacker.classname == "teledeath2")
		{
			bprint ("Power screen deflects ");
			bprint (targ.netname);
			bprint ("'s telefrag\n");

			targ.frags = targ.frags - 1;
			return;
		}

		if (attacker.classname == "player")
		{
			if (targ == attacker)
			{
				// killed self
				attacker.frags = attacker.frags - 1;
				bprint (targ.netname);
				
				if (targ.weapon == 64 && targ.waterlevel > 1)
				{
					bprint (" discharges into the water.\n");
					return;
				}
				if (targ.weapon == WEP_GRENADE_LAUNCHER)
					bprint (" tries to put the pin back in\n");
				else
					bprint (" becomes bored with life\n");
				return;
			}
			else if ( (teamplay == 2) && (targ.team > 0)&&(targ.team == attacker.team) )
			{
				if (rnum < 0.25)
					deathstring = " mows down a teammate\n";
				else if (rnum < 0.50)
					deathstring = " checks their glasses\n";
				else if (rnum < 0.75)
					deathstring = " gets a frag for the other team\n";
				else
					deathstring = " loses another friend\n";
				bprint (attacker.netname);
				bprint (deathstring);
				attacker.frags = attacker.frags - 1;
				return;
			}
			else
			{
				attacker.frags = attacker.frags + 1;

				rnum = attacker.weapon;
				if (rnum == WEP_BLASTER)
				{
					deathstring = " was blasted by ";
					deathstring2 = "\n";
				}
				if (rnum == WEP_SHOTGUN)
				{
					deathstring = " chewed on ";
					deathstring2 = "'s boomstick\n";
				}
				if (rnum == WEP_SUPERSHOTGUN)
				{
					deathstring = " ate 2 loads of ";
					deathstring2 = "'s buckshot\n";
				}
				if (rnum == WEP_MACHINEGUN)
				{
					deathstring = " was perforated by ";
					deathstring2 = "\n";
				}
				if (rnum == WEP_CHAINGUN)
				{
					deathstring = " was punctured by ";
					deathstring2 = "\n";
				}
				if (rnum == WEP_GRENADE_LAUNCHER)
				{
					deathstring = " eats ";
					deathstring2 = "'s pineapple\n";
					if (targ.health < -40)
					{
						deathstring = " was gibbed by ";
						deathstring2 = "'s grenade\n";
					}
				}
				if (rnum == WEP_ROCKET_LAUNCHER)
				{
					deathstring = " rides ";
					deathstring2 = "'s rocket\n";
					if (targ.health < -40)
					{
						deathstring = " was gibbed by ";
						deathstring2 = "'s rocket\n" ;
					}
				}
				if (rnum == WEP_HYPERBLASTER)
				{
					deathstring = " was melted by ";
					deathstring2 = "'s hyperblaster\n";
				}
				if (rnum == WEP_RAILGUN)
				{
					deathstring = " was railed by ";
					deathstring2 = "'s railgun\n";
				}
				if (rnum == WEP_BFG)
				{
					deathstring = " was obliterated by ";
					deathstring2 = "'s bfg\n";
				}
				if (rnum == WEP_GRENADE)
				{
					deathstring = " was obliterated by ";
					deathstring2 = "'s bfg\n";
				}
				bprint (targ.netname);
				bprint (deathstring);
				bprint (attacker.netname);
				bprint (deathstring2);
			}
			return;
		}
		else
		{
			targ.frags = targ.frags - 1;
			bprint (targ.netname);

			// killed by a montser?
			if (attacker.flags & FL_MONSTER)
			{
				if (attacker.classname == "monster_army")
					bprint (" was shot by a Grunt\n");
				if (attacker.classname == "monster_demon1")
					bprint (" was eviscerated by a Fiend\n");
				if (attacker.classname == "monster_dog")
					bprint (" was mauled by a Rottweiler\n");
				if (attacker.classname == "monster_dragon")
					bprint (" was fried by a Dragon\n");
				if (attacker.classname == "monster_enforcer")
					bprint (" was blasted by an Enforcer\n");
				if (attacker.classname == "monster_fish")
					bprint (" was fed to the Rotfish\n");
				if (attacker.classname == "monster_hell_knight")
					bprint (" was slain by a Death Knight\n");
				if (attacker.classname == "monster_knight")
					bprint (" was slashed by a Knight\n");
				if (attacker.classname == "monster_ogre")
					bprint (" was destroyed by an Ogre\n");
				if (attacker.classname == "monster_oldone")
					bprint (" became one with Shub-Niggurath\n");
				if (attacker.classname == "monster_shalrath")
					bprint (" was exploded by a Vore\n");
				if (attacker.classname == "monster_shambler")
					bprint (" was smashed by a Shambler\n");
				if (attacker.classname == "monster_tarbaby")
					bprint (" was slimed by a Spawn\n");
				if (attacker.classname == "monster_vomit")
					bprint (" was vomited on by a Vomitus\n");
				if (attacker.classname == "monster_wizard")
					bprint (" was scragged by a Scrag\n");
				if (attacker.classname == "monster_zombie")
					bprint (" joins the Zombies\n");
				
				//Quake 2 Monsters
				if (attacker.classname == "monster_flipper")
					bprint (" became fish food\n");
				if (attacker.classname == "monster_berserk")
					bprint (" was berserked upon\n");
				if (attacker.classname == "monster_chick")
					bprint (" was a hit with the ladies\n");
				if (attacker.classname == "monster_brain")
					bprint (" was dissected by a brain\n");
				if (attacker.classname == "monster_soldier_light")
					bprint (" become blaster fodder for a Strogg Soldier\n");
				if (attacker.classname == "monster_soldier_ss")
					bprint (" was target practice for a Strogg Soldier\n");
				if (attacker.classname == "monster_soldier")
					bprint (" ate Strogg Soldier lead\n");
				if (attacker.classname == "monster_floater")
					bprint (" was taken out by a Floater\n");
				if (attacker.classname == "monster_flyer")
					bprint (" was air struck by a Flyer\n");
				if (attacker.classname == "monster_gladiator")
					bprint (" was entertained by a Gladiator\n");
				if (attacker.classname == "monster_gunner")
					bprint (" was gunnered down by a Gunner\n");
				if (attacker.classname == "monster_hover")
					bprint (" was killed by a Hover\n");
				if (attacker.classname == "monster_infantry")
					bprint (" obliterated by an Enforcer\n");
				if (attacker.classname == "monster_parasite")
					bprint (" caught a Parasite\n");
				if (attacker.classname == "monster_supertank")
					bprint (" destroyed by a Super Tank\n");
				if (attacker.classname == "monster_tank")
					bprint (" soaked up too much damage from a Tank\n");
				if (attacker.classname == "monster_mutant")
					bprint (" became mutant poop\n");
				if (attacker.classname == "monster_medic")
					bprint (" didn't have Medic insurance\n");
				if (attacker.classname == "monster_stroggzombie")
					bprint (" destroyed by a Strogg Zombie\n");
				return;
			}

			// tricks and traps
			if (attacker.classname == "explo_box")
			{
				bprint (" blew up\n");
				return;
			}
			if (attacker.classname == "func_forcefield")
			{
				bprint (" became one with the force... field\n");
				return;
			}			
			if (attacker.solid == SOLID_BSP && attacker) // != world)
			{
				bprint (" was squished\n");
				return;
			}
			if (attacker.classname == "trap_shooter" || attacker.classname == "trap_spikeshooter")
			{
				bprint (" was spiked\n");
				return;
			}
			if (attacker.classname == "fireball")
			{
				bprint (" ate a lavaball\n");
				return;
			}
			if (attacker.classname == "trigger_changelevel")
			{
				bprint (" tried to leave\n");
				return;
			}

			// in-water deaths
			rnum = targ.watertype;
			if (rnum == -3)
			{
				if (random() < 0.5)
					bprint (" sleeps with the fishes\n");
				else
					bprint (" sucks it down\n");
				return;
			}
			else if (rnum == -4)
			{
				if (random() < 0.5)
					bprint (" gulped a load of slime\n");
				else
					bprint (" can't exist on slime alone\n");
				return;
			}
			else if (rnum == -5)
			{
				if (targ.health < -15)
				{
					bprint (" burst into flames\n");
					return;
				}
				if (random() < 0.5)
					bprint (" turned into hot slag\n");
				else
					bprint (" visits the Volcano God\n");
				return;
			}

			// fell to their death?
			if (targ.deathtype == "falling")
			{
				targ.deathtype = string_null;
				bprint (" had a rough landing\n");
				return;
			}

			// hell if I know; he's just dead!!!
			if (random() < 0.5)
				bprint (" took the room temperature challenge\n");
			else
				bprint (" died\n");
			
			//bprint (" died\n");
		}
	}
};
