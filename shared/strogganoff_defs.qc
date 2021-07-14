/* Weapons State machine

The largest change is the weapons code, which is handled in a similar fashion to Quake 2. Weapon_Generic is a function that will check the state of all weapons 
and switch or loop frames based on player and weapons states. Firing, switching, idle animation loops and spin downs for the chaingun and hyperblaster.

Making a note of it here to help make sense of it for myself or anyone else who might use this, may also do a tutorial.



*/

float START_ON = 1;

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
PLAYER STARTING VALUES
============
*/

#define WEAPON_DEFAULT_DAMAGE 		5
#define WEAPON_AXE_DAMAGE 		15
#define WEAPON_BLASTER_DAMAGE 		12
#define WEAPON_SHOTGUN_DAMAGE 		4 //per pellot
#define WEAPON_SUPERSHOTGUN_DAMAGE 	8 //per pellot
#define WEAPON_MACHINEGUN_DAMAGE 	10
#define WEAPON_CHAINGUN_DAMAGE 		15
#define WEAPON_GRENADE_DAMAGE 		80
#define WEAPON_ROCKET_DAMAGE 		110
#define WEAPON_RAILGUN_DAMAGE 		200
#define WEAPON_HUPERBLASTER_DAMAGE 	200
#define WEAPON_BFG_DAMAGE 		200

/*
============
WEAPONS
============
*/
/*
enum
{
WEP_BLASTER,
WEP_SHOTGUN,
WEP_SSHOTGUN,
WEP_MACHINEGUN,
WEP_CHAINGUN,
WEP_GRENADELAUNCHER,
WEP_ROCKETLAUNCHER,
WEP_RAILGUN,
WEP_HYPERBLASTER,
WEP_BFG,
WEP_GRENADE
};
*/

// items
#define	WEP_BLASTER				4096
#define	WEP_SHOTGUN				1
#define	WEP_SUPERSHOTGUN		2
#define	WEP_MACHINEGUN			4
#define	WEP_CHAINGUN			8
#define	WEP_GRENADE_LAUNCHER	16
#define	WEP_ROCKET_LAUNCHER		32
#define	WEP_HYPERBLASTER		64
#define	WEP_RAILGUN				128
#define WEP_BFG 				256
#define WEP_GRENADE 			512

#define	WEP_SHOTGUN_ATTACKTIME 0.9

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