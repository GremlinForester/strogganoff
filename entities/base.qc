//Used by func_bossgate, func_illusionary, func_episodegate

void() func_wall;

//Lights
#define START_OFF 1

//Trap Shooters
#define SPAWNFLAG_SUPERSPIKE 1
#define SPAWNFLAG_LASER 2

.float wait;
.float delay;
.float variance;

//used by target_speaker
.float volume;
.float attenuation;

// button and multiple button
void() button_wait;
void() button_return;

#define button_blocked SUB_Null
/*
duplicates SUB_Null
void() button_blocked =
{	// do nothing, just don't ome all the way back out
};
*/

#define REMOVE_KEY	1

//TRAINS
void() train_next;
void() func_train_find;
void() train_blocked;
void() train_use;

//PLATS
void() plat_center_touch;
void() plat_outside_touch;
void() plat_trigger_use;
void() plat_go_up;
void() plat_go_down;
void() plat_crush;
#define PLAT_LOW_TRIGGER 1

//DOORS
#define DOOR_START_OPEN 1
#define DOOR_DONT_LINK 	4
#define DOOR_GOLD_KEY	8
#define DOOR_SILVER_KEY	16
#define DOOR_TOGGLE		32

void() door_go_down;
void() door_go_up;
void() door_hit_bottom;
void() door_use;
void() door_blocked;
void() door_killed;
void() LinkDoors;
void() spawn_q2_func_door;

//PARTICLE SPAWNER
.string myparticle;
.string myendparticle;

//POINT_SHAKE
.float	duration;

/*
=============================================================================

SECRET DOORS

=============================================================================
*/

void() fd_secret_move1;
void() fd_secret_move2;
void() fd_secret_move3;
void() fd_secret_move4;
void() fd_secret_move5;
void() fd_secret_move6;
void() fd_secret_done;

#define SECRET_OPEN_ONCE 1		// stays open
#define SECRET_1ST_LEFT 2		// 1st move is left of arrow
#define SECRET_1ST_DOWN 4		// 1st move is down from arrow
#define SECRET_NO_SHOOT 8		// only opened by trigger
#define SECRET_YES_SHOOT 16	// shootable even if targeted

/*
==============================================================================

TRIGGERS SHARED

==============================================================================
*/

//entity stemp, otemp, s, old;	// fx_warning
// FIX - opgrade this
entity s; 
///in function spawn_tfog (line 7)
///triggers.qc:305: error: Unknown value "s".

void() trigger_reactivate =
{
	self.solid = SOLID_TRIGGER;
};

//=============================================================================

#define	SPAWNFLAG_NOMESSAGE 1
#define	SPAWNFLAG_NOTOUCH 1

// the wait time has passed, so set back up for another activation
void() multi_wait =
{
	if (self.max_health)
	{
		self.health = self.max_health;
		self.takedamage = DAMAGE_YES;
		self.solid = SOLID_BBOX;
	}
};


// the trigger was just touched/killed/used
// self.enemy should be set to the activator so it can be held through a delay
// so wait for the delay time before firing
void() multi_trigger =
{
	if (self.nextthink > time)
	{
		return;		// allready been triggered
	}

	if (self.classname == "trigger_secret")
	{
		if (self.enemy.classname != "player")
			return;
		found_secrets = found_secrets + 1;
		WriteByte (MSG_ALL, SVC_FOUNDSECRET);
	}

	if (self.noise)
		sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);

// don't trigger again until reset
	self.takedamage = DAMAGE_NO;

	activator = self.enemy;
	
	SUB_UseTargets();

	if (self.wait > 0)	
	{
		self.think = multi_wait;
		self.nextthink = time + self.wait;
	}
	else
	{	// we can't just remove (self) here, because this is a touch function
		// called wheil C code is looping through area links...
		self.touch = SUB_Null;
		self.nextthink = time + 0.1;
		self.think = SUB_Remove;
	}
};

void() multi_killed =
{
	self.enemy = damage_attacker;
	multi_trigger();
};

void() multi_use =
{
	self.enemy = activator;
	multi_trigger();
};

void() multi_touch =
{
	if (other.classname != "player")
		return;	
	
// if the trigger has an angles field, check player's facing direction
	if (self.movedir) // != '0 0 0')
	{
		makevectors (other.angles);
		if (v_forward * self.movedir < 0)
			return;		// not facing the right way
	}
	
	self.enemy = other;
	multi_trigger();
};

/*
==============================================================================

TELEPORT TRIGGERS

==============================================================================
*/

void() play_teleport =
{
//	local	float v;
//	local	string tmpstr;

	self.rnd_ = random() * 5;
	if (self.rnd_ < 1)
		self.noise = "misc/r_tele1.wav";
	else if (self.rnd_ < 2)
		self.noise = "misc/r_tele2.wav";
	else if (self.rnd_ < 3)
		self.noise = "misc/r_tele3.wav";
	else if (self.rnd_ < 4)
		self.noise = "misc/r_tele4.wav";
	else
		self.noise = "misc/r_tele5.wav";

	sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);
	remove (self);
};

void(vector org) spawn_tfog =
{
	s = spawn();
	s.origin = org;
	s.nextthink = time + 0.2;
	s.think = play_teleport;

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_TELEPORT);
	WriteCoord (MSG_BROADCAST, org_x);
	WriteCoord (MSG_BROADCAST, org_y);
	WriteCoord (MSG_BROADCAST, org_z);
};


void() tdeath_touch =
{
	if (other == self.owner)
		return;

// frag anyone who teleports in on top of an invincible player
	if (other.classname == "player")
	{
		if (other.invincible_finished > time)
			self.classname = "teledeath2";
		if (self.owner.classname != "player")
		{	// other monsters explode themselves
			T_Damage (self.owner, self, self, 50000);
			return;
		}
		
	}

	if (other.health)
	{
		T_Damage (other, self, self, 50000);
	}
};


void(vector org, entity death_owner) spawn_tdeath =
{
local entity	death;

	death = spawn();
	death.classname = "teledeath";
//	death.movetype = MOVETYPE_NONE;
	death.solid = SOLID_TRIGGER;
//	death.angles = '0 0 0';
	setsize (death, death_owner.mins - '1 1 1', death_owner.maxs + '1 1 1');
	setorigin (death, org);
	death.touch = tdeath_touch;
	death.nextthink = time + 0.2;
	death.think = SUB_Remove;
	death.owner = death_owner;
	force_retouch = 2;		// make sure even still objects get hit
};


/*
==============================================================================

TRAP_SHOOTERS

==============================================================================
*/

void() spikeshooter_use;

/*
==============================================================================

STATIC & DYNAMIC MODELS

==============================================================================
*/

.float anim_startframe;
.float anim_lastframe;
.float anim_lastframe_hold;

.float bUseEnable;
.float bUseEnvLight;
.float bToggleVisibility;
.float bAnimLoop;


/*
.float eBits;
#define bUseEnable 			1
#define bUseEnvLight 		2
#define bToggleVisibility	4
#define bAnimLoop			8
#define bAutoReset			16
#define bAnimLastFrameHold 	32
*/

.float onUse;

.float oscale; //original scale

.float eState;

//NOTE: Always denote spawnflags with SF or something, SOLID_BSP was a really crappy choice for a spawnflag name!

#define SF_HOLOGRAM 1
#define SF_SOLID_BSP 2
#define SF_START_INVIS 4
#define SF_NOTSOLID 8

.vector holo_color;

enum
{
	NONE = 0,
	OPEN = 1,
	OPENING = 2,
	CLOSED = 3,
	CLOSING = 4,
	LOCKED = 5
}; //6

//used by misc_randomnoise and particle_spawner, play some random self.noiseses
void() random4Noise =
{
	if (random() < 1){
		sound (self, CHAN_AUTO, self.noise1, 1, ATTN_NORM);
	}
	else if (random() < 0.7){
		sound (self, CHAN_AUTO, self.noise2, 1, ATTN_NORM);
	}
	else if (random() < 0.4){
		sound (self, CHAN_AUTO, self.noise3, 1, ATTN_NORM);
	}
	else 
	{
		sound (self, CHAN_AUTO, self.noise, 1, ATTN_NORM);
	}
}

//Parenting
.string		parent;

//currently used for func_water...
.float speed2;

/*
void execute_joblist(argv(0), argv(1)) =
{
}

void(string filename) menu_execute_cvar_list={
  local float f;
	local string ln;
  f = fopen(filename, FILE_READ);
	if (f != -1){
		ln = fgets(f); 
		while(ln != ""){ 
			if(strstrofs(ln, "//",0) == -1){
        tokenizebyseparator(ln, " ");
        cvar_set(argv(0), argv(1));
			}
			ln = fgets(f);
		}
    fclose(f);    
	} 
};

void(float level) graphics_light_set={
  local string cvars;
  switch(level){
    default:
      cvars = "data/cache/settings/lighting_low.cvl";
      break;
    case 2:
      cvars = "data/cache/settings/lighting_normal.cvl"; 
      break;
    case 3:
      cvars = "data/cache/settings/lighting_high.cvl";
      break;
    case 4:
      cvars = "data/cache/settings/lighting_max.cvl";
      break;
  }
  menu_execute_cvar_list(cvars);
};
*/

.vector offset;

#define IS_TRAIL 2
#define IS_RANDOM 4
#define FIRE_ONCE 8
