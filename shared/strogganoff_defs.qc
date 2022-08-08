/*
  SendEntity Entity Type Definitions
*/
#define SENDTYPE_PLAYER 1
#define SENDTYPE_MONSTER 2
#define SENDTYPE_PROJECTILE 3
#define SENDTYPE_MISC_ENT 4
#define SENDTYPE_MAP_OBJ 5

//================================
/*
  SendEntity Change Flag definitions
  -----------------------------------
*/
#define SENDFLAG_ORIGIN 1     //new origin value
#define SENDFLAG_ANGLE 2      //new angle value
#define SENDFLAG_VELOCITY 4   //new velocity value
#define SENDFLAG_DEAD 8       //deadflag changed 
#define SENDFLAG_CHANGE_WEP 16    //entity is making an attack
#define SENDFLAG_DAMAGE 32    //entity took damage.
#define SENDFLAG_IMPACT 64    //impact event, usually for projectiles.

#define SENDFLAG_NEW_ENT 128  //engine-set, entity is "new" for viewing client.

#define SENDFLAG_ATTACK 256

//================================


const float STAT_Q2WEAPONS = 32;
const float STAT_AMMO_SHELLS = 33;
const float STAT_AMMO_BULLETS = 34;	
const float STAT_AMMO_ROCKETS = 35;
const float STAT_AMMO_CELLS = 36;
const float STAT_AMMO_SLUGS = 37;
const float STAT_Q2KEYS = 38;
const float STAT_PICKUP = 39;
const float STAT_INV_QUAD = 40;
const float STAT_INV_REBREATHER = 41;
const float STAT_INV_INVIS = 42;
const float STAT_INV_SILENCER = 43;
const float STAT_INVINVUL = 44;
const float STAT_ENVIRO = 45;
const float STAT_FRAGS = 46;
const float STAT_PLAYERTYPE = 47;

.float isHub;

.float fadein;

.string myparticle;
.string myendparticle;

var float autocvar_howmanyplayers;

//Monster Customization/Debugging
var vector autocvar_q2soldier_shotgun_accuracy = '0.2 0.2 0.05';

// get center of bmodel (found in Doombringer source - thanks!)
vector() bmodelOrigin =
{
	return self.absmin + ((self.absmax - self.absmin) * 0.5);
};

vector(entity this) bmodelOriginEntity = //if owner is a bmodel or something...
{
	return this.absmin + ((this.absmax - this.absmin) * 0.5);
};	

#ifndef opgrade
//replaced with define
float() crandom =
{
	return 2*(random() - 0.5);
};
#endif

enum
{
	INV_PICKUP_NONE = 0,
	INV_PICKUP_QUAD = 1,
	INV_PICKUP_REBREATHER = 2,
	INV_PICKUP_INVISIBILITY = 3,
	INV_PICKUP_SILENCER = 4,
	INV_PICKUP_INVULNERABILITY = 5,
	INV_PICKUP_ENVIROSUIT = 6
}; //6

.float player_pickup_itemnum;

.float dmgradius;

//Currently used for debris
float numdecors;
float maxdecors;

//LOG STUFF (might expand on this) these may require {} braces on any conditional i.e. 'if' logging.

#define LOG(x) bprint(x);bprint("\n")
#define LOG2(x,y) bprint(x);bprint(y);bprint("\n")
#define LOG3(x,y,z) bprint(x);bprint(y);bprint(z);bprint("\n")
#define VLOG(x) bprint(vtos(x));bprint("\n")
#define FLOG(x) bprint(ftos(x));bprint("\n")

/*
============
Some bit functions
============
*/

void(entity ent, .float field, float bits) addBitsToEntity =
{
	ent.field |= bits;
}

void(entity ent, .float field, float bits) removeBitsFromEntity =
{
	ent.field -= (ent.field & bits);
}

//MrC: FixMe: use shared/reserved appearflags if there are any in defs or something

#define DOOR_START_OPEN				1
#define DOOR_KEY_PYRAMID			2
#define CRUSHER						4 //must be toggled?
#define NOMONSTER					8
#define DOOR_KEY_DATA_SPINNER		16
#define DOOR_TOGGLE					32
#define DOOR_KEY_PASS				64
#define DOOR_KEY_DATA_CD			128
#define DOOR_NOT_EASY				256
#define DOOR_NOT_NORMAL				512
#define DOOR_NOT_HARD				1024
#define DOOR_NOT_DEATHMATCH			2048
#define DOOR_KEY_BLUE_KEY			4096
#define DOOR_KEY_RED_KEY			8192
#define DOOR_KEY_COMMANDER_HEAD		16384
#define DOOR_KEY_POWER_CUBE			32768

//used by playerVOSound to select a sound under the following conditions
enum
{
	PLAYER_VOICE_JUMP,
	PLAYER_VOICE_PAIN25,
	PLAYER_VOICE_PAIN50,
	PLAYER_VOICE_PAIN75,
	PLAYER_VOICE_PAIN100,
	PLAYER_VOICE_DEATH,
	PLAYER_VOICE_LAND1,
	PLAYER_VOICE_LAND2,
	PLAYER_VOICE_GURP,
	PLAYER_VOICE_DROWN
};

//player types OTHER is cyborg atm, more could be added, be sure to extend playerVOSound  
enum
{
	PT_MALE,
	PT_FEMALE,
	PT_OTHER
};
.float playerType;

/*
============
MONSTER MUZZLE FLASH OFFSETS 

NOTE: This (and friends) should eventually go into its own file (possible TODO: port m_flash and choose from positions in a giant array of vectors like Q2
or put each one in it's own?).
============
*/

vector Q2MEDIC_CABLE_OFFSETS[] = {
'45.0 -9.2 15.5',
'48.4 -9.7 15.2',
'47.8 -9.8 15.8',
'47.3 -9.3 14.3',
'45.4 -10.1 13.1',
'41.9 -12.7 12.0',
'37.8 -15.8 11.2',
'34.3 -18.4 10.7',
'32.7 -19.7 10.4',
'32.7 -19.7 10.4'
};

vector MZ2_INFANTRY_MACHINEGUN[] = {
'18.2 7.5 15.4',
'17.2 10.3 17.9',
'17.0 12.8 20.1',
'15.1 14.1 21.8',
'11.8 17.2 23.1',
'11.4 20.2 21.0',
'9.0 23.0 18.9',
'13.9 18.6 17.7',
'15.4 15.6 15.8',
'10.2 15.2 25.1',
'-1.9 15.1 28.2',
'-12.4 13.0 20.2'
};

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

vector MZ2_TANK_MACHINEGUN[] = {
'22.9 -0.7 25.3',
'22.9 -0.7 25.3',
'22.2 6.2 22.3',
'19.4 13.1 18.6',
'19.4 18.8 18.6',
'17.9 25.0 18.6',
'14.1 30.5 20.6',
'9.3 35.3 22.1',
'4.7 38.4 22.1',
'-1.1 40.4 24.1',
'-6.5 41.2 24.1',
'3.2 40.1 24.7',
'11.7 36.7 26.0',
'18.9 31.3 26.0',
'24.4 24.4 26.4',
'27.1 17.1 27.2',
'28.5 9.1 28.0',
'27.1 2.2 28.0',
'24.9 -2.8 28.0',
'21.6 -7.0 26.4'
};

/*
============
PROGS DUMP / QUAKE 1.5 STUFF
============
*/

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

string SOUND_EMPTY = "misc/null.wav";			// No sound

/*
============
Flip/Flop self.eState switches first and second.
============
*/
void(float first, float second) estateFlipFlop =
{
	if (self.estate == first)
	{
		self.estate = second;
		return;
	}
	
	if (self.estate == second)
	{
		self.estate = first;
		return;
	}	
}

/*
============
Flip/Flop field float switches first and second.
============
*/
void(float first, float second, .float field) fieldFloatFlipFlop =
{
	if (self.field == first)
	{
		self.field = second;
		return;
	}
	
	if (self.field == second)
	{
		self.field = first;
		return;
	}	
}

/*
============
ADDITIONAL CONSOLE COMMANDS
============
*/

var float autocvar_cl_fastweaponswitch = 0;
var float autocvar_cl_surfacesniffer = 0;
var float autocvar_cl_smacktalk = 0;
var float autocvar_cl_idletalk = 0;
var float autocvar_cl_printpos = 0;
var float autocvar_cl_printstate = 0;
var float autocvar_cl_printroomsize = 0;
var float autocvar_q2_classicmode = 0;
//var float autocvar_cl_playertype = 0;
var float autocvar_bot_create_dynamic_waypoint = 0;

/*
============
SPEECH LINES
============
*/

//MrC: These don't currently take into account player types. 
//Will need to switch/case similar to player sound wrapper function (or something).

#define PLAYER_KILLCOMMENT_1 "player/killcomment1.wav"
#define PLAYER_KILLCOMMENT_2 "player/killcomment2.wav"
#define PLAYER_KILLCOMMENT_3 "player/killcomment3.wav"
#define PLAYER_KILLCOMMENT_4 "player/killcomment4.wav"
#define PLAYER_KILLCOMMENT_5 "player/killcomment5.wav"
#define PLAYER_KILLCOMMENT_6 "player/killcomment6.wav"

#define	PLAYER_IDLECOMMENT_1 "player/idlecomment1.wav"
#define	PLAYER_IDLECOMMENT_2 "player/idlecomment2.wav"
#define	PLAYER_IDLECOMMENT_3 "player/idlecomment3.wav"
#define	PLAYER_IDLECOMMENT_4 "player/idlecomment4.wav"

.float nexttalktime;
.float nextsmacktalktime;

.string sightSound;

vector(vector vUp) PlayerViewOrg={
	local vector v;
	v = vUp * self.view_ofs_z;
	return v;
};

.float weapon_anim_start;
.float weapon_frame_end;

.float droploot;

//MrC: Items can be added like health, powerups, etc...
enum
{
	LOOT_SHELLS,
	LOOT_BULLETS,
	LOOT_ROCKETS,
	LOOT_SLUGS,
	LOOT_CELLS,
	LOOT_ARMOR_SHARD,
	LOOT_HEALTH_SMALL,
	LOOT_SHOTGUN,
	LOOT_SUPERSHOTGUN,
	LOOT_MACHINEGUN,
	LOOT_CHAINGUN,
	LOOT_GRENADE_LAUNCHER,
	LOOT_ROCKET_LAUNCHER,
	LOOT_HYPERBLASTER,
	LOOT_RAILGUN,
	LOOT_BFG
};

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
.float weapon_ammo_min;				//many weapons have a 1 or 2 shot min to fire.
.string weapon_sound;	//maps to Q2's p_view client->weapon_sound, but as a string and not float
											//apparently used to do most spin up/down weapons. todo-  this is called in Q2's client end-of-frame processing

//frame_t wpnFramesFire[10];
//frame_t wpnFamesPause[10];

.float state;
.float bCrouched;

.float idletime;
.float animIdle;
.float nextframetime;

#define	FL_DUCKED 8192

/*
Quake used ammo_ for inventory tracking but Quake 2 used ammo_ as the pickup item name. 
For compatibility with Quake 2 maps (especially MP), all variables pertaining to the player's inventory were renamed to 
inv_ammo_ instead of ammo_. I would like to thank Find/Replace for all its hard work.
*/

.float inv_weapons;
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
#define WEP_GRENADE 			1024

.float items_q2keys;
#define	IT_KEY_DATACD			1
#define	IT_KEY_POWERCUBE		2
#define	IT_KEY_PYRAMID			4
#define	IT_KEY_DATASPINNER		8
#define	IT_KEY_PASS				16
#define	IT_KEY_BLUE				32
#define	IT_KEY_RED				64
#define	IT_KEY_HEAD				128

.float silencer_time;
.float silencer_finished;

//used self.items (powerups seem to be hard coded?)
//#define	IT_EXTRA			1
//#define	IT_EXTRA			2
//#define	IT_EXTRA			4
//#define	IT_EXTRA			8
#define	IT_DOUBLER				16
#define	IT_BREATHER				32
#define	IT_POWER_SHIELD			64
#define	IT_SLUGS				128
#define	IT_SHELLS				256
#define	IT_BULLETS				512
#define	IT_ROCKETS				1024
#define	IT_CELLS				2048
//#define IT_EXTRA				4096
#define	IT_ARMOR_JACKET			8192 //IT_ARMOR1
#define	IT_ARMOR_COMBAT			16384 //IT_ARMOR2
#define	IT_ARMOR_BODY			32768 //IT_ARMOR3
#define	IT_SUPERHEALTH			65536
#define	IT_KEY1					131072
#define	IT_KEY2					262144
#define	IT_INVISIBILITY			524288 //could replace power screen, cloak armor!
#define	IT_INVULNERABILITY		1048576
#define	IT_SUIT					2097152
#define	IT_QUAD					4194304

.float inv_ammo_bullets;
.float inv_ammo_shells;
.float inv_ammo_cells;
.float inv_ammo_slugs;
.float inv_ammo_rockets;
.float inv_ammo_grenades;

.float inv_pickup_quad;
.float inv_pickup_rebreather;
.float inv_pickup_invisibility; //power screen
.float inv_pickup_silencer;
.float inv_pickup_invulnerability;
.float inv_pickup_envirosuit;

.float anim_end;
.float anim_priority;

#define	ANIM_BASIC		0		// stand / run
#define	ANIM_WAVE		1
#define	ANIM_JUMP		2
#define	ANIM_PAIN		3
#define	ANIM_ATTACK		4
#define	ANIM_DEATH		5
#define	ANIM_REVERSE	6

#define WEAPON_SWITCH_SPEED 0.05 //think speed

enum 
{
	WEAPON_EMPTY,			//0
	WEAPON_READY, 		//1
	WEAPON_ACTIVATING,//2
	WEAPON_DROPPING,	//3
	WEAPON_SPINDOWN,	//4
	WEAPON_FIRING		//5
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

float(vector v1, vector v2) VectorCompare=
{
	if (v1_x != v2_x || v1_y != v2_y || v1_z != v2_z)
			return FALSE;
			
	return TRUE;
}

vector VectorScale (vector in, vector scale)=
{
	local vector v;
	v_x = in_x * scale_x;
	v_y = in_y * scale_y;
	v_z = in_z * scale_z;
	return v;
};

vector(vector veca, vector vecb) VectorSubtract=
{
	local vector v;
	v_x = veca_x - vecb_x;
	v_y = veca_y - vecb_y;
	v_z = veca_z - vecb_z;
	return v;
};

vector(vector veca, vector vecb) VectorAdd=
{
	local vector v;
	v_x = veca_x + vecb_x;
	v_y = veca_y + vecb_y;
	v_z = veca_z + vecb_z;
	return v;
};

vector(vector veca, float scale, vector vecb) VectorMA =
{
	local vector v;
	v_x = veca_x + scale*vecb_x;
	v_y = veca_y + scale*vecb_y;
	v_z = veca_z + scale*vecb_z;
	return v;
};


vector (float vX, float vY, float vZ ) VectorSet={
	local vector v;
	v_x = vX;
	v_y = vY;
	v_z = vZ;
	return v;
};

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
float Q3SURFACEFLAG_TILE = 	0x1000000;
float Q3SURFACEFLAG_ELECTRONIC = 0x2000000;

.float aiflags;
.float shotcount;

// aiflags
#define	FL_MEDIC				1
#define AI_RESURRECTING			2
#define AI_ANIMAL				4
#define AI_STROGG				8
#define AI_HUMAN				16

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
#define IMPULSE_USE_WEAPON11 11 //grenade

#define IMPULSE_SVFLAGS_CMD 12

#define IMPULSE_TOSS_WEAPON 13

#define IMPULSE_WEAPON_NEXT 30
#define IMPULSE_WEAPON_PREV 31

#define IMPULSE_ITEM_NEXT 32
#define IMPULSE_ITEM_PREV 33
#define IMPULSE_USE_ITEM 34

#define IMPULSE_SKIN_NEXT 35

#define IMPULSE_CHEAT_CMD 99

#define IMPULSE_FLIP 110
#define IMPULSE_SALUTE 111
#define IMPULSE_TAUNT 112
#define IMPULSE_WAVE 113
#define IMPULSE_POINT 114

#define IMPULSE_SETPLAYERMALE 115
#define	IMPULSE_SETPLAYERFEMALE 116
#define	IMPULSE_SETPLAYERCYBORG 117

//FrikBot Waypoint Edit Impulses
/*
	if (self.impulse == 104)
	if (self.impulse == 100)
	else if (self.impulse == 101)
	else if (self.impulse == 102)
	if (self.impulse == 103)

//FrikBot Follow Camera Impulses? Checks 200 - 250 frikbot/kascam.qc
	if ( (self.impulse == 100) ) {
	Line 833: 					if ( (self.impulse == 200) ) {
	Line 854: 						if ( (self.impulse == 201) ) {
	Line 882: 							if ( (self.impulse == 202) ) {
	Line 896: 								if ( (self.impulse == 203) ) {
	Line 905: 									if ( (self.impulse == 204) ) {
	Line 914: 										if ( (self.impulse == 205) ) {
	Line 929: 											if ( (self.impulse == 210) ) {
	Line 935: 												if ( (self.impulse == 211) ) {
	Line 943: 													if ( (self.impulse == 212) ) {
	Line 949: 														if ( (self.impulse == 213) ) {
	Line 955: 															if ( (self.impulse == 214) ) {
	Line 961: 																if ( (self.impulse == 215) ) {
	Line 967: 																	if ( (self.impulse == 216) ) {
	Line 977: 																		if ( (self.impulse == 217) ) {
*/

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
LENS OVERLAYS
============
*/

enum
{
OVERLAY_RIPPLE,
OVERLAY_RAIN,
OVERLAY_BLOODSPLAT1,
OVERLAY_BLOODSPLAT2,
OVERLAY_BLOODSPLAT3,
OVERLAY_BLOODSPLAT4,
OVERLAY_FACE,
OVERLAY_SLIME
};

/*
============
GIB TYPES
============
*/

.float material;

enum
{
GIB_NONE,
GIB_FLESH,
GIB_METAL,
GIB_FLAMING,
GIB_GLASS,
GIB_WOOD,
GIB_STONE
};

#define GIB_LIFE 4