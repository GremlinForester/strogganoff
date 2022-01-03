/*

Constants used only on the client.

*/

// add-entity mask bits
float MASK_ENGINE				= 1;
float MASK_ENGINEVIEWMODELS	= 2;
float MASK_NORMAL				= 4;
//float MASK_OVERLAY				= 8;

// renderflag bits
float RF_VIEWMODEL		= 1;
float RF_EXTERNALMODEL	= 2;
float RF_DEPTHHACK		= 4;
float RF_ADDATIVE			= 8;
float RF_USEAXIS			= 16;

// flags for 2d drawing
float DRAWFLAG_NORMAL       = 0;
float DRAWFLAG_ADDITIVE     = 1;
float DRAWFLAG_MODULATE     = 2;
float DRAWFLAG_2XMODULATE   = 3;

// setview parameter
float VF_MIN			= 1;	//(vector)
float VF_MIN_X		= 2;	//(float)
float VF_MIN_Y		= 3;	//(float)
float VF_SIZE			= 4;	//(vector) (viewport size)
float VF_SIZE_Y		= 5;	//(float)
float VF_SIZE_X		= 6;	//(float)
float VF_VIEWPORT		= 7;	//(vector, vector)
float VF_FOV			= 8;	//(vector)
float VF_FOVX			= 9;	//(float)
float VF_FOVY			= 10;	//(float)
float VF_ORIGIN		= 11;	//(vector)
float VF_ORIGIN_X		= 12;	//(float)
float VF_ORIGIN_Y		= 13;	//(float)
float VF_ORIGIN_Z		= 14;	//(float)
float VF_ANGLES		= 15;	//(vector)
float VF_ANGLES_X		= 16;	//(float)
float VF_ANGLES_Y		= 17;	//(float)
float VF_ANGLES_Z		= 18;	//(float)
float VF_DRAWWORLD	= 19;	//(float)
float VF_DRAWENGINESBAR	= 20;	//(float)
float VF_DRAWCROSSHAIR	= 21;	//(float)

float VF_CL_VIEWANGLES	= 33;	//(vector)
float VF_CL_VIEWANGLES_X	= 34;	//(float)
float VF_CL_VIEWANGLES_Y	= 35;	//(float)
float VF_CL_VIEWANGLES_Z	= 36;	//(float) 

// input events
float INPUT_KEYDOWN   = 0;
float INPUT_KEYUP     = 1;
float INPUT_MOUSEMOVE = 2;

// stats
// 0 - 31 are reserved for standard engine stats
// 32 - 128 are for QuakeC modders
float STAT_HEALTH			= 0;
float STAT_WEAPONMODEL		= 2;
float STAT_AMMO				= 3;
float STAT_ARMOR			= 4;
float STAT_WEAPONFRAME		= 5;
float STAT_SHELLS			= 6;
float STAT_BULLETS			= 7;
float STAT_ROCKETS			= 8;
float STAT_CELLS			= 9;
float STAT_ACTIVEWEAPON		= 10;
float STAT_TOTALSECRETS		= 11;
float STAT_TOTALMONSTERS	= 12;
float STAT_SECRETS			= 13; // bumped on client side by svc_foundsecret
float STAT_MONSTERS			= 14; // bumped by svc_killedmonster
float STAT_ITEMS			= 15;
//float STAT_Q2WEAPONS	= 32;

// player flags, calculated in 
float PFL_DEAD     = 4;
float PFL_GIBBED   = 8;

float		STAT_VIEWHEIGHT					= 16;

/*

common/constants.qc

Constants which are present on both client and server.

*/

// helpful things

float EXTRA_LOW = -99999999;
float EXTRA_HIGH = 99999999;

vector VEC_1  = '1 1 1';
vector VEC_0  = '0 0 0';
vector VEC_M1 = '-1 -1 -1';

float M_PI = 3.14159265358979323846;

// network update types
float NT_PLAYER = 2;
