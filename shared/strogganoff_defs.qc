/*

The largest change is the weapons code, which is handled in a similar fashion to Quake 2. Weapon_Generic is a function that will check the state of all weapons 
and switch or loop frames based on player and weapons states. Firing, switching, idle animation loops and spin downs for the chaingun and hyperblaster.

Making a note of it here to help make sense of it for myself or anyone else who might use this.

*/

/*
============
MONSTER MUZZLE FLASH OFFSETS 

NOTE: This (and friends) should eventually go into its own file (possible TODO: port m_flash and choose from positions in a giant array of vectors like Q2
or put each one in it's own?).
============
*/

vector MZ2_MAKRON_BLASTER[] = {
'-3.6 -24.1 59.5',
'-1.6 -19.3	59.5',
'-0.1 -14.4 59.5',
'2.0 -7.6 59.5',
'3.4 1.3 59.5',
'3.7 11.1 59.5',
'-0.3 22.3 59.5',
'-6	33 59.5',
'-9.3 36.4 59.5',
'-7	35 59.5',
'-2.1 29 59.5',
'3.9 17.3 59.5',
'6.1 5.8 59.5',
'5.9 -4.4 59.5',
'4.2 -14.1 59.5',
'2.4 -18.8 59.5',
'-1.8 -25.5 59.5'
};

/*
============
PROGS DUMP / QUAKE 1.5 STUFF
============
*/

.float onladder;
.float		onladder;			// Update state from ladder entity to client
.entity		entladder;			// Ladder entity for reference (time, sounds etc)
.float		timeladder;			// Amount of time before playing climb sound

float ENT_STARTOFF = 64;	// Global spawnflags setting
float ESTATE_BLOCK = 6;		// Blocked OFF+DISABLE
float ESTATE_LOWER = 7;		// ON+OFF+DISABLE
float ESTATE_ON = 1;		// Switch ON
float ESTATE_OFF = 2;		// Switch OFF
float ESTATE_DISABLE = 4;	// Disabled (blocks toggle)
float ESTATE_RESET = 8;		// Reset parameters

// Entity state system
.float		estate_trigger;		// Entity state to be applied to target
.float		estate;				// Entity state (off,on and disable)
.void()		estate_on;			// Entity state ON  function
.void()		estate_off;			// Entity state OFF function
.void()		estate_disable;		// Entity state DISABLE function
.void()		estate_use;			// Entity state USE function
.void()		estate_fire;		// Entity state USE++ function
.void()		estate_reset;		// Entity state RESET function

float (vector from, vector to) Dot =
{
	return from_x * to_x + from_y * to_y + from_z * to_z;
};

/*
============
ADDITIONAL CONSOLE COMMANDS
============
*/

var float autocvar_cl_surfacesniffer = 0;
var float autocvar_cl_smacktalk = 0;
var float autocvar_cl_printpos = 0;
var float autocvar_cl_printstate = 0;

/*
============
SMACK TALK LINES
============
*/
#define PLAYER_KILLCOMMENT_1 "player/killcomment1.wav"
#define PLAYER_KILLCOMMENT_2 "player/killcomment2.wav"
#define PLAYER_KILLCOMMENT_3 "player/killcomment3.wav"
#define PLAYER_KILLCOMMENT_4 "player/killcomment4.wav"
#define PLAYER_KILLCOMMENT_5 "player/killcomment5.wav"
#define PLAYER_KILLCOMMENT_6 "player/killcomment6.wav"

.float nexttalktime;
.float nextsmacktalktime;
.float damage;

float START_ON = 1;

.string sightSound;

.float weapon_anim_start;
.float weapon_frame_end;

//Q2 weapon impl flattened down to player
//mimic ammo_index value in Q2
enum
{
	AMMO_IDX_NONE,
	AMMO_IDX_SHELLS,
	AMMO_IDX_BULLETS,
	AMMO_IDX_ROCKETS,
	AMMO_IDX_SLUGS,
	AMMO_IDX_CELLS
};
.float ammo_index;

.float grenade_time;
.float machinegun_shots;

.float weapon_next;
.float lastweapon;
.float weaponstate;
.float weaponstate_next;
.float weapon_think;
.float() weapon_update_func;
.float() weapon_pause_frames;	// these really need to be structs
.float() weapon_fire_frames;


//frame_t wpnFramesFire[10];
//frame_t wpnFamesPause[10];

.float state;
.float bCrouched;

.float idletime;
.float animIdle;
.float nextframetime;

//Quake 1.5 stuff, used for spinning down the chaingun and hyperblaster
//Thanks again for pointing me in the right direction!
.float spindown;
.float spintimer;

#define	FL_DUCKED 4096

/*
Quake used ammo_ for inventory tracking but Quake 2 used ammo_ as the pickup item name. 
For compatibility with Quake 2 maps (espeically MP),
all variables pertaining to the player's inventory were renamed to 
inv_ammo_ instead of ammo_. 

Find/Replace, it's time to work!
*/

.float inv_weapons;

.float inv_ammo_bullets;
.float inv_ammo_shells;
.float inv_ammo_cells;
.float inv_ammo_slugs; //Railgun
.float inv_ammo_rockets;
.float inv_ammo_grenades;

.float anim_end;
.float anim_priority;

#define	ANIM_BASIC		0		// stand / run
#define	ANIM_WAVE		1
#define	ANIM_JUMP		2
#define	ANIM_PAIN		3
#define	ANIM_ATTACK		4
#define	ANIM_DEATH		5
#define	ANIM_REVERSE	6

enum 
{
	WEAPON_EMPTY,			//0
	WEAPON_READY, 		//1
	WEAPON_ACTIVATING,//2
	WEAPON_DROPPING,	//3
	WEAPON_SPINDOWN,	//4
	WEAPON_FIRING,		//5
};

enum 
{
	STATE_IDLE,
	STATE_RUNNING,
	STATE_ATTACKING,
	STATE_NONE
};

/*
============
Functions converted from Quake 2 to QC
============
*/

vector (vector point, vector distance, vector forward, vector right, vector result) G_ProjectSource =
{
	result_x = point_x + forward_x * distance_x + right_x * distance_y;
	result_y = point_y + forward_y * distance_x + right_y * distance_y;
	result_z = point_z + forward_z * distance_x + right_z * distance_y + distance_z;
	return result;
}

vector (vector start, vector end, vector result, float jitter) vRandomPoint =
{
	result_x = (end_x - (start_x * jitter)); 
	result_y = (end_y - (start_y * jitter)); 
	result_z = (end_z - (start_z * jitter)); 
	return result;
}

vector(vector m1, vector m2) randompos =
{
	local vector v;
	m2 = m2 - m1;
	v_x = m2_x * random() + m1_x;
	v_y = m2_y * random() + m1_y;
	v_z = m2_z * random() + m1_z;
	return  v;
};

/*
============
Additional Q3BSP surfaceflags
============
*/

float Q3SURFACEFLAG_WOOD = 0x80000; //524288;
float Q3SURFACEFLAG_GLASS = 0x100000;
float Q3SURFACEFLAG_DIRT = 0x200000;
float Q3SURFACEFLAG_FORCEFIELD = 0x400000;
float Q3SURFACEFLAG_GRASS = 0x800000;
float Q3SURFACEFLAG_TILE = 0x1000000;

.float aiflags;
.float shotcount;

// aiflags
#define	FL_MEDIC				1

/*
============
WEAPON VARS
============
*/

#define PLAYER_ROCKET_SPEED 1000

//lights
.float intensity_original;
.float intensity; // store the value
.float gsize;
float MOVING	= 2;
float NOSHADOW	= 4;
float CORONA	= 8;
float FULL_DYN	= 16;

//Parenting
.string		parent;

#define MAX_BLEED 10
.float bIsWounded;
.float bleedcount;

.float state_mood;
.float state_movement;

// added for Dark Places
float CHAN_SPEECH             = 5;
float CHAN_FOOT               = 6;
float CHAN_WEAPON2            = 7;

/*
============
WEAPONS
============
*/

#define WEAPON_DEFAULT_DAMAGE 		5
#define WEAPON_AXE_DAMAGE 			15
#define WEAPON_BLASTER_DAMAGE 		12
#define WEAPON_SHOTGUN_DAMAGE 		4 //per pellot
#define WEAPON_SUPERSHOTGUN_DAMAGE 	8 //per pellot
#define WEAPON_MACHINEGUN_DAMAGE 	5
#define WEAPON_CHAINGUN_DAMAGE 		5
#define WEAPON_GRENADE_DAMAGE 		80
#define WEAPON_ROCKET_DAMAGE 		110
#define WEAPON_RAILGUN_DAMAGE 		200
#define WEAPON_HUPERBLASTER_DAMAGE 	200
#define WEAPON_BFG_DAMAGE 		200

#define	WEP_BLASTER				1
#define	WEP_SHOTGUN				2
#define	WEP_SUPERSHOTGUN		4
#define	WEP_MACHINEGUN			8
#define	WEP_CHAINGUN			16
#define	WEP_GRENADE_LAUNCHER	32
#define	WEP_ROCKET_LAUNCHER		64
#define	WEP_HYPERBLASTER		128
#define	WEP_RAILGUN				256
#define WEP_BFG 				512
//#define WEP_GRENADE 			512

#define	WEP_BLASTER_ATTACKTIME          0.5
#define	WEP_SHOTGUN_ATTACKTIME          0.9
#define	WEP_SUPERSHOTGUN_ATTACKTIME     0.9
#define	WEP_MACHINEGUN_ATTACKTIME       0.05
#define	WEP_CHAINGUN_ATTACKTIME         0.01
#define	WEP_GRENADE_LAUNCHER_ATTACKTIME 0.8
#define	WEP_ROCKET_LAUNCHER_ATTACKTIME  0.8
#define	WEP_HYPERBLASTER_ATTACKTIME     0.135
#define	WEP_RAILGUN_ATTACKTIME          2.0
#define	WEP_BFG_ATTACKTIME              0 //3.105

#define	WEP_BLASTER_MFLASH_OFFSET_FP '74 -18 -10'
#define	WEP_BLASTER_MFLASH_OFFSET_TP '40 -18 -10'
#define	WEP_BLASTER_MFLASH_SCALE 1.5
#define	WEP_BLASTER_MFLASH_ALPHA 0.5

#define	WEP_MACHINEGUN_MFLASH_OFFSET_FP '74 -23 -17'
#define	WEP_MACHINEGUN_MFLASH_OFFSET_TP '40 -18 -10'
#define	WEP_MACHINEGUN_MFLASH_SCALE 0.5
#define	WEP_MG_MFLASH_ALPHA 0.5


/*
============
IMPULSE VALUES
============
*/
#define IMPULSE_TOSS_WEAPON 13

#define IMPULSE_USE_WEAPON1 1
#define IMPULSE_USE_WEAPON2 2
#define IMPULSE_USE_WEAPON3 3
#define IMPULSE_USE_WEAPON4 4
#define IMPULSE_USE_WEAPON5 5
#define IMPULSE_USE_WEAPON6 6
#define IMPULSE_USE_WEAPON7 7
#define IMPULSE_USE_WEAPON8 8
#define IMPULSE_USE_WEAPON9 9
#define IMPULSE_USE_WEAPON10 10

#define IMPULSE_WEAPON_NEXT 30
#define IMPULSE_WEAPON_PREV 31

#define IMPULSE_CHEAT_CMD 99

#define IMPULSE_SVFLAGS_CMD 11

#define IMPULSE_CHEAT_QUAD 255



/*
============
VIEW WEAPON FRAMES
============
*/

//BLASTER
#define WEP_BLASTER_ACTIVE_FIRSTFRAME 1
#define WEP_BLASTER_ACTIVE_LASTFRAME 4

#define WEP_BLASTER_FIRE_FIRSTFRAME 5
#define WEP_BLASTER_FIRE_LASTFRAME 8

#define WEP_BLASTER_IDLE1_FIRSTFRAME 9
#define WEP_BLASTER_IDLE1_LASTFRAME 32

#define WEP_BLASTER_IDLE2_FIRSTFRAME 33
#define WEP_BLASTER_IDLE2_LASTFRAME 52

#define WEP_BLASTER_AWAY_FIRSTFRAME 54
#define WEP_BLASTER_AWAY_LASTFRAME 56

//SHOTGUN
#define WEP_SHOTGUN_ACTIVE_FIRSTFRAME 1
#define WEP_SHOTGUN_ACTIVE_LASTFRAME 7

#define WEP_SHOTGUN_FIRE_FIRSTFRAME 8
#define WEP_SHOTGUN_FIRE_LASTFRAME 18

#define WEP_SHOTGUN_IDLE1_FIRSTFRAME 19
#define WEP_SHOTGUN_IDLE1_LASTFRAME 36

#define WEP_SHOTGUN_AWAY_FIRSTFRAME 37
#define WEP_SHOTGUN_AWAY_LASTFRAME 39

//SUPER SHOTGUN
#define WEP_SUPERSHOTGUN_ACTIVE_FIRSTFRAME 1
#define WEP_SUPERSHOTGUN_ACTIVE_LASTFRAME 7

#define WEP_SUPERSHOTGUN_FIRE_FIRSTFRAME 8
#define WEP_SUPERSHOTGUN_FIRE_LASTFRAME 18

#define WEP_SUPERSHOTGUN_IDLE1_FIRSTFRAME 19
#define WEP_SUPERSHOTGUN_IDLE1_LASTFRAME 58

#define WEP_SUPERSHOTGUN_AWAY_FIRSTFRAME 59
#define WEP_SUPERSHOTGUN_AWAY_LASTFRAME 62

//MACHINE GUN
#define WEP_MACHINEGUN_ACTIVE_FIRSTFRAME 1
#define WEP_MACHINEGUN_ACTIVE_LASTFRAME 4

#define WEP_MACHINEGUN_FIRE_FIRSTFRAME 5
#define WEP_MACHINEGUN_FIRE_LASTFRAME 6

#define WEP_MACHINEGUN_IDLE1_FIRSTFRAME 7
#define WEP_MACHINEGUN_IDLE1_LASTFRAME 46

#define WEP_MACHINEGUN_AWAY_FIRSTFRAME 47
#define WEP_MACHINEGUN_AWAY_LASTFRAME 50

//CHAINGUN
#define WEP_CHAINGUN_ACTIVE_FIRSTFRAME 1
#define WEP_CHAINGUN_ACTIVE_LASTFRAME 4

#define WEP_CHAINGUN_FIRE_FIRSTFRAME 6
#define WEP_CHAINGUN_FIRE_LASTFRAME 32

#define WEP_CHAINGUN_IDLE1_FIRSTFRAME 33
#define WEP_CHAINGUN_IDLE1_LASTFRAME 62

#define WEP_CHAINGUN_AWAY_FIRSTFRAME 63
#define WEP_CHAINGUN_AWAY_LASTFRAME 65

//NADE LAUNCHER
#define WEP_NADELAUNCH_ACTIVE_FIRSTFRAME 1
#define WEP_NADELAUNCH_ACTIVE_LASTFRAME 7

#define WEP_NADELAUNCH_FIRE_FIRSTFRAME 8
#define WEP_NADELAUNCH_FIRE_LASTFRAME 18

#define WEP_NADELAUNCH_IDLE1_FIRSTFRAME 19
#define WEP_NADELAUNCH_IDLE1_LASTFRAME 61

#define WEP_NADELAUNCH_AWAY_FIRSTFRAME 62
#define WEP_NADELAUNCH_AWAY_LASTFRAME 64

//ROCKET LAUNCHER
#define WEP_ROCKETLAUNCH_ACTIVE_FIRSTFRAME 1
#define WEP_ROCKETLAUNCH_ACTIVE_LASTFRAME 5

#define WEP_ROCKETLAUNCH_FIRE_FIRSTFRAME 6
#define WEP_ROCKETLAUNCH_FIRE_LASTFRAME 13

#define WEP_ROCKETLAUNCH_IDLE1_FIRSTFRAME 14
#define WEP_ROCKETLAUNCH_IDLE1_LASTFRAME 51

#define WEP_ROCKETLAUNCH_AWAY_FIRSTFRAME 52
#define WEP_ROCKETLAUNCH_AWAY_LASTFRAME 55

//HYPERBLASTER
#define WEP_HYPERBLAST_ACTIVE_FIRSTFRAME 1
#define WEP_HYPERBLAST_ACTIVE_LASTFRAME 6

#define WEP_HYPERBLAST_FIRE_FIRSTFRAME 7
#define WEP_HYPERBLAST_FIRE_LASTFRAME 11

#define WEP_HYPERBLASTER_SPIN_FIRSTFRAME 12
#define WEP_HYPERBLASTER_LAST_FIRSTFRAME 21

#define WEP_HYPERBLAST_IDLE1_FIRSTFRAME 22
#define WEP_HYPERBLAST_IDLE1_LASTFRAME 50

#define WEP_HYPERBLAST_AWAY_FIRSTFRAME 51
#define WEP_HYPERBLAST_AWAY_LASTFRAME 54

//RAILGUN
#define WEP_RAILGUN_ACTIVE_FIRSTFRAME 1
#define WEP_RAILGUN_ACTIVE_LASTFRAME 4

#define WEP_RAILGUN_FIRE_FIRSTFRAME 5
#define WEP_RAILGUN_FIRE_LASTFRAME 19

#define WEP_RAILGUN_IDLE1_FIRSTFRAME 20
#define WEP_RAILGUN_IDLE1_LASTFRAME 57

#define WEP_RAILGUN_AWAY_FIRSTFRAME 58
#define WEP_RAILGUN_AWAY_LASTFRAME 62

//BFG
#define WEP_BFG_ACTIVE_FIRSTFRAME 1
#define WEP_BFG_ACTIVE_LASTFRAME 9

#define WEP_BFG_FIRE_FIRSTFRAME 10
#define WEP_BFG_FIRE_LASTFRAME 32

#define WEP_BFG_IDLE1_FIRSTFRAME 33
#define WEP_BFG_IDLE1_LASTFRAME 55

#define WEP_BFG_AWAY_FIRSTFRAME 56
#define WEP_BFG_AWAY_LASTFRAME 60


/*
============
GIB TYPES
============
*/

enum
{
GIB_NONE,
GIB_FLESH,
GIB_METAL,
GIB_FLAMING,
GIB_GLASS,
GIB_WOOD
};

#define GIB_LIFE 4