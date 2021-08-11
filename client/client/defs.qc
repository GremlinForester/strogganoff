//NOTE: THIS IS AN INTERFACE FILE. DO NOT EDIT.
//MODIFYING THIS FILE CAN RESULT IN CRC ERRORS.
//YOU HAVE BEEN WARNED.

//feel free to look though. :)

#define CSQC 1

/*
==============================================================================

			SOURCE FOR GLOBALVARS_T C STRUCTURE

==============================================================================
*/

//
// system globals
//
float 		player_localentnum;	//the entnum
float 		player_localnum;	//the playernum
float		maxclients;	//a constant filled in by the engine. gah, portability eh?

float		clientcommandframe;	//player movement
float		servercommandframe;	//clientframe echoed off the server

float		intermission;

//
// required prog functions
//
void()		CSQC_Init;
void()		CSQC_Shutdown;
float(float f, float t)	CSQC_InputEvent;
void()		CSQC_UpdateView;
float(string s)	CSQC_ConsoleCommand;


/*
==============================================================================

			SOURCE FOR ENTVARS_T C STRUCTURE

==============================================================================
*/

//
// system fields (*** = do not set in prog code, maintained by C code)
//
.float		entnum;	// *** the ent number as on the server
.float		drawmask;
.void()		predraw;


//-----------------------------------------------------------------------------
// BUILTINS
//-----------------------------------------------------------------------------

// 'csqc'
float(string name, string value) registercvar = #93;

// CSQC Builtins
float()									ReadByte = #360;
float()									ReadChar = #361;
float()									ReadShort = #362;
float()									ReadLong = #363;
float()									ReadCoord = #364;
float()									ReadAngle = #365;
string()								ReadString = #366;	//warning: this returns a temporary!

// CSQC builtins
void ()									R_ClearScene = #300;
void (float mask)						R_AddEntities = #301;
void (entity e)							R_AddEntity = #302;
float (float property, ...)				R_SetView = #303;
void ()									R_RenderScene = #304;
void (vector org, float radius, vector rgb)	R_AddDynamicLight = #305;
void ()									R_CalcRefDef = #306;

vector (vector v)						cs_unproject = #310;
vector (vector v)						cs_project = #311;

// CSQC draw builtins
void	drawline(float width, vector pos1, vector pos2, vector rgb, float alpha, float flags) = #315;

float	iscachedpic(string name)	= #316;
string	precache_pic(string name, ...)	= #317;
vector	drawgetimagesize(string pic) = #318;
void	freepic(string name)		= #319;
float	drawcharacter(vector position, float character, vector scale, vector rgb, float alpha, float flag) = #320;
float	drawstring(vector position, string text, vector scale, vector rgb, float alpha, float flag) = #321;
float	drawpic(vector position, string pic, vector size, vector rgb, float alpha, float flag) = #322;
float	drawfill(vector position, vector size, vector rgb, float alpha, float flag) = #323;
void	drawsetcliparea(float x, float y, float width, float height) = #324;
void	drawresetcliparea(void) = #325;

// CSQC stat builtins
// coerent names with the server functions by krimzon
float (float statnum)	GetStat_FLOAT           = #330;
float (float statnum)	GetStat_FLOAT_TRUNCATED = #331;
float(float statnum, float first, float count) GetStat_BITS = #331; // only needed for STAT_ITEMS
string (float statnum)	GetStat_STRING          = #332;

// client side centerprint and print
void (string s, ...)	cprint = #338;
void (string s, ...)	print = #339;

// csqc
void (entity e, float i)					setmodelindex = #333;
string (float i)							modelnameforindex = #334;

float(string efname)						particleseffectforname = #335;
void(entity ent, float effectnum, vector start, vector end, ...)	trailparticles = #336;
void (float efnum, vector org, vector vel, float countmultiplier)	pointparticles = #337;

// csqc input thingy
float(float framenum)	CL_getinputstate = #345;

void (float scale)		setsensitivityscale = #347;

void (float framenum)	RetrieveMovementFrame = #345;
void ()					DefaultPlayerPhysics = #347;

string (float playernum, string key)	getplayerkey = #348;
void (string cmdname)	registercmd = #352;
vector ()				getmousepos = #344;

float ()				playernum = #354;

void (vector org, vector forward, vector right, vector up) setlistener = #351;

float (vector start, vector end, float ignore, float csqcents) selecttraceline = #355;
float ()				isdemo = #349;
float ()				isserver = #350;

void (float f)			setwantsmousemove = #343;
string (float key)		getkeybind = #342;

float () onground = #355;

// CSQC manual drawing
void(string texturename, ...) R_BeginPolygon = #306;
void(vector org, vector texcoords, vector rgb, float alpha) R_PolygonVertex = #307;
void() R_EndPolygon = #308;

float(string s) tokenize = #441;
string(float n) argv = #442;

float(string s, float num) charindex = #356;
float(float a, float b) min = #94;
float(float a, float b, float c) min3 = #94;
float(float a, float b, float c, float d) min4 = #94;
float(float a, float b, float c, float d, float e) min5 = #94;
float(float a, float b, float c, float d, float e, float f) min6 = #94;
float(float a, float b, float c, float d, float e, float f, float g) min7 = #94;
float(float a, float b, float c, float d, float e, float f, float g, float h) min8 = #94;
float(float a, float b) max = #95;
float(float a, float b, float c) max3 = #95;
float(float a, float b, float c, float d) max4 = #95;
float(float a, float b, float c, float d, float e) max5 = #95;
float(float a, float b, float c, float d, float e, float f) max6 = #95;
float(float a, float b, float c, float d, float e, float f, float g) max7 = #95;
float(float a, float b, float c, float d, float e, float f, float g, float h) max8 = #95;
//float		deathmatch;

vector(vector forward, vector up) vectoangles2 = #51;

float E_ACTIVE 	    = 0; // float 0/1
float E_ORIGIN      = 1; // vector
float E_FORWARD     = 2; // vector
float E_RIGHT       = 3; // vector
float E_UP          = 4; // vector
float E_SCALE       = 5; // float
float E_ORIGINANDVECTORS = 6; // returns origin, + sets v_* vectors to orientation
float E_ALPHA       = 7; // float
float E_COLORMOD    = 8; // vector
float E_PANTSCOLOR  = 9; // vector
float E_SHIRTCOLOR  = 10; // vector
float E_SKIN        = 11; // float
float E_MINS        = 12; // vector
float E_MAXS        = 13; // vector
float E_ABSMIN      = 14; // vector
float E_ABSMAX      = 15; // vector
float E_LIGHT       = 16; // vector - modellight
// builtin definitions:
float(float entitynum, float fldnum) getentity = #504;
vector(float entitynum, float fldnum) getentityvec = #504;
vector(float property) getpropertyvec = #303;