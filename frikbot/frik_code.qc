/* ::-::
 *
 * Cataboligne
 *
 * file: frik_code.qc
 *
 * date: 4.27.15
 *
 * qc - frikbot module - 0.10.1.cat 
 *
 */


/// this is the frikbot code control file - with compiler options for the various configurations

// the waypoint editor and botcam may be excluded to save resources - this is the default


// ** bot_qw.qc has not been updated for qc++ **


// FRIKBOT is defined or not defined in compiler.qc, the master control file

#ifdef FRIKBOT

#message			-- compile: frikbot version 0.10.1.cat 

// process fril bot qc

// note: kascam code is disabled - I use darkplaces builtin cam which is near as good as any software cam
//				 also - this is not the same as botcam

// defs.qc replacements

#ifdef noautoaim
// qc++ remove autoaim entirely - aim fn is normally controlled by an engine cvar
// note: this entirely counts on v_forward being pre-calculated at some point - as happens in PlayerPreThink - makevectors (self.v_angle);
#define frik_aim(ign,igntwo) v_forward
#else
// may be affected by sv_aim
vector(entity e, float speed) frik_aim = #44;		// returns the shooting vector
#endif


// activate here if unused doesnt get it
#ifndef unused
entity(entity e) nextent = #47;					// for looping through all ents			// qc++ - seems not used in v1.06
#endif


#ifdef nodprint
// currently this is only used in dprints & frikbot
// activate here if dprint doesnt get it
string(vector v) vtos				= #27;
#endif



//uncommenting this will include frikbot code for qc compiled waypoints on dm1 - dm6

#define frikbot_waycode

/*
this takes up globals (many because of the vectors) and progs space, 
however bots _might_ play better on those levels - but you dont need this to play dm*

and this is global / size expensive -
compiled on 4.29.15 with fteqcc 1.0

 69700 strofs (of 1000000)
 29529 numstatements (of 524288)
   753 numfunctions (of 16384)
  3873 numglobaldefs (of 32768)
   270 numfielddefs (242 unique) (of 2048)
  5811 numpr_globals (of 65536)
Writing ./progs.dat
389608 TOTAL SIZE


vs. excluding dm* waypoints and editor -

 55112 strofs (of 1000000)
 25183 numstatements (of 524288)
   737 numfunctions (of 16384)
  2896 numglobaldefs (of 32768)
   267 numfielddefs (239 unique) (of 2048)
  3244 numpr_globals (of 65536)
Writing ./progs.dat
321568 TOTAL SIZE


*** this does not affect dynamic waypoints

*/


// hand coded dm? waypoints and editor

// it is possible to include the editor without these - some finagle is required for this

	#ifdef frikbot_waycode

	#messagefrikbot compiled waypoints: dm1 - dm6 

	#include "map_dm1.qc"
	#include "map_dm2.qc"
	#include "map_dm3.qc"
	#include "map_dm4.qc"
	#include "map_dm5.qc"
	#include "map_dm6.qc"

	#endif


// limit placement of dynamic waypoints by world _z boundary, or server spec

// the idea is to prevent a bot fallen out of the level or a player observer from
// making a ton of waypoints in solid space where bots cant go anyway
// the real issue I had with this was in Archon where dynamic spawns were happening in solid space

#define NOWAY

#ifdef NOWAY

float noway_above;
float noway_below;

#endif



#ifdef xvars0

// server controls section - enables options to allow server console control of bots
// note: these are controlled by xvars - if that system is disabled, these will be too

// new admin - server control of frikbots
// if defined, the original impulse controls to add and remove bots are __deactivated__
/// WARNING: the old impulse code has NO authentication - _any_ player can add or remove bots

//#define svc_botcon //MrC: so I don't forget, this should prolly be re-enabled


// allow server op to blanket deactivate all frikbot - any active bots will be removed

//#define svc_frikbot

// server control of botcam - note: this will auto enable botcam code compile
/// idea: admin protected botcam mode, include bot "thoughts" in cam view of them
// note: botcam has _nothing_ to do with kascam.qc

#define svc_botcam

	#ifdef svc_botcam
	#define botcam_code
	#endif

#endif

// enable use of botcam
// this uses some global resources and gives players a way to spy on other players

//#define botcam_code

#ifndef botcam_code

#message			-- compile: frikbot botcam disabled - code excluded 

#endif


// main bot modules

#messagefrikbot/bot.qc 
#include "bot.qc"

#messagefrikbot/bot_way.qc 
#include "bot_way.qc"

#messagefrikbot/bot_fight.qc 
#include "bot_fight.qc"

#messagefrikbot/bot_ai.qc 
#include "bot_ai.qc"

#messagefrikbot/bot_misc.qc 
#include "bot_misc.qc"

#messagefrikbot/bot_phys.qc 
#include "bot_phys.qc"

#messagefrikbot/bot_move.qc 
#include "bot_move.qc"





// hard coded dm? waypoints and editor

	#ifdef frikbot_waycode

	#message			-- compile: frikbot waypoint editor 
	 
	#messagefrikbot/bot_ed.qc 
	#include "bot_ed.qc"

	#endif



#endif


/*

estimated cost of basic frikbot package (no waycode, botcam, or svc_frikbot)
compiled on 5.1.15 with fteqcc 1.0

 55056 strofs (of 1000000)
 24961 numstatements (of 524288)
   735 numfunctions (of 16384)
  2893 numglobaldefs (of 32768)
   267 numfielddefs (239 unique) (of 2048)
  3241 numpr_globals (of 65536)
Writing ./progs.dat
319628 TOTAL SIZE

vs.

no frikbot code

 45044 strofs (of 1000000)
 18483 numstatements (of 524288)
   607 numfunctions (of 16384)
  2093 numglobaldefs (of 32768)
   210 numfielddefs (188 unique) (of 2048)
  2437 numpr_globals (of 65536)
Writing ./progs.dat
243112 TOTAL SIZE

the frikbot code base used (at compile date indicated):

6478 statements
128 functions
800 global defs
57 field defs
804 numpr globals
76516 bytes in progs.dat
*/