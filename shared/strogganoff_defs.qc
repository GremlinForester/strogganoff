/*

The largest change is the weapons code, which is handled in a similar fashion to Quake 2. Weapon_Generic is a function that will check the state of all weapons 
and switch or loop frames based on player and weapons states. Firing, switching, idle animation loops and spin downs for the chaingun and hyperblaster.

Making a note of it here to help make sense of it for myself or anyone else who might use this.

*/



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

.float weaponstate;
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
	WEAPON_READY, 
	WEAPON_ACTIVATING,
	WEAPON_DROPPING,
	WEAPON_SPINDOWN,
	WEAPON_FIRING
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

#define	WEP_BLASTER_ATTACKTIME 0.4
#define	WEP_SHOTGUN_ATTACKTIME 0.9
#define	WEP_SUPERSHOTGUN_ATTACKTIME 0.9
#define	WEP_MACHINEGUN_ATTACKTIME 0.15
#define	WEP_CHAINGUN_ATTACKTIME 0.05
#define	WEP_GRENADE_LAUNCHER_ATTACKTIME 0.8
#define	WEP_ROCKET_LAUNCHER_ATTACKTIME 0.8
#define	WEP_HYPERBLASTER_ATTACKTIME 0.135
#define	WEP_RAILGUN_ATTACKTIME 2.0
#define	WEP_BFG_ATTACKTIME 0 //3.105

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
VIEW WEAPON FRAMES
============
*/

#define WEP_BLASTER_ACTIVE_FIRSTFRAME	0
#define WEP_BLASTER_ACTIVE_LASTFRAME 	4
#define WEP_BLASTER_FIRE_FIRSTFRAME 	5
#define WEP_BLASTER_FIRE_LASTFRAME 		8
#define WEP_BLASTER_IDLE1_FIRSTFRAME 	9
#define WEP_BLASTER_IDLE1_LASTFRAME 	32
#define WEP_BLASTER_IDLE2_FIRSTFRAME 	33
#define WEP_BLASTER_IDLE2_LASTFRAME 	52

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