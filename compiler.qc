/* ::-::
 *
 * Cataboligne
 *
 * file: compiler.qc
 *
 * date: 11/21/14
 *
 * qc - precompiler specific codes
 *
 */
 
 
 /*
		This file is the core of the vanilla Quake-C recode ""qc++"" with fteqcc

		quake-c can not be more complicated

		The vision of this code base is the ability to include various secitons simply by
		using the defines below to control what is compiled in.

		release plan: v106 recoded, v107 clean, v107 only, pk 3.0, chaos mod mark III

 */



/// **************************************
/// compiler ID section
///
/// **************************************

#message			-- version 1.06 RECODED -- compile with fteqcc 
#message			-- (c) 1996 iD software,(c) 2014 Number Six
#message			-- Quake 2 additions by Gremlin 'MrC' Forester  
#message			-- GPL - see license.txt for rights and details 
#message 

// this is 50 bytes shorter
#pragma COPYRIGHT (c) 1.06 iD 1996, 1.07 Six 2014

// more detail - takes more bytes
//#pragma COPYRIGHT v1.06 iD (c)1996 v1.07 Number Six (c)2014 -GPL- www.moddb.com/groups/qc


// create a console version alias in code

#define qcvers

// takes up a global var (and string space), but gives the progs.dat code a qc version in the console		- requires localcmd(vers); somewhere in code
// note: over-ride by cv_setdef  below

// if this alias is set, when you type "version" in the console it will respond with the string
// with darkplaces this will display the darkplaces version first then this string
// requires an addtional instruciton thus:
//		localcmd(vers);
// to be run once somewhere in worldspawn()

#define version__						"alias version \"echo quake-c: 1.06 recoded\"\n"

// note: uses a global var and progs space -->
// this is better off being placed in a config file - refer to cv_setdef found below for instructions

/// **************************************
/// code weaver section
///
/// **************************************

// this section deals with what portions of the code base get compiled in and which get left out
// note - defines MUST be commented out or removed - you cannot define null or 0 to clear them


/// compiler controls

// dont list unused vars warning when compiling
//#pragma warning disable Q302

// turn off warnings for map spawn functions - most are normally only called by the engine
#pragma warning off F300



// ******************************************************************************************************************

// main ka-hoona

#define qc++

#ifdef qc++
#message			-- compile: qc++ v1.07 included 
#endifdef

/*
	an operation upgrade to vanilla qc 1.06

*/

	// 11.23.14
	// fx_warning
	// - some vars commented out to fix this compiler warning:
	//    defs.qc:401: warning: empty_float  no references



// ******************************************************************************************************************

// quake one operation upgrade

#define opgrade
/// opgrade turned ON



// do all the opgrade sub-items
#ifdef opgrade
#message			-- compile: operation upgrade v1.07 included 


//	part of opgrade - fix some q1 code issues - many also fix compiler warnings
#define codefix
/*

	codefix - removing this define puts code flaws back
'						fixing these flaws possibly affects game play, map loads, and monster behavior
'						e.g. - map loads, monsters, and entities may _not_ perform the same under the fixed code

	example in misc_fireball() - 

	if (!self.speed)
		self.speed == 1000;

this is fixed with
		self.speed = 1000;
*/


// remove autoaim from code
// this is done by translating all aim() calls as v_forward, which is set in PlayerPreThink() from v_angle
// more properly this should re-calculate v_forward every time aim() is called - see defs.qc

#define noautoaim



// instead of a regular function
// this saves a function def and a global def at the expense of more statements
// this is really an esthetic choice as both methods do the same thing op wise

#define crandom() 2*(random() - 0.5)

// end of opgrade subs



#else
/// opgrade turned OFF


// if we turn off opgrade and qc++ we have (mostly) v106 behavior in the base code
// in theory anyway
#ifndef qc++
#message			-- compile: quake-c v1.06 behavior 



// compile in un-used code sections
// these are bits of quake-c that are:
//		- vars never referenced - not even in the engine
//		- code that serves no purpose
#define unused


// end not using qc++
#endifdef


// end of opgrade not used
#endifdef

// ******************************************************************************************************************

// some code is pointless, but removing it creates warnings			- mostly these are return FALSE; };
// comment this out to remove the pointless code, the following bit removes the warnings!
//#define pointless_warning

/// NOTE: this masks off no return value compiler WARNINGS !!!
#ifndef pointless_warning
// comment this out to see any related warnings
#pragma warning disable Q206
#endifdef

// ******************************************************************************************************************



// part of opgrade - remove objerror if possible to continue, also removes error()
// but we do this always - there is no reason for map spudge to break the server
// "spudge" - crap in a map that shouldnt be - like missing targets, broken trains and such
// #define noobjerr

#ifdef noobjerr
#message			-- compile: objerror() and error() statements removed 
#endifdef


// ******************************************************************************************************************


// include all debug / warning code - uncomment this define to use
// includes special map spawns
#define debug

#ifdef debug

// optional warning code display system - NOT included in this code set !
//#define warning

/*
warning ideas

print fn entries
track global vars
track ent vars
track local vars on entry / exit?
spec track by cvar

*/

#else
// remove all dprints - they use globals --- comment this #define out to compile dprint code, also you must set the developer cvar to have them print to console
/// remove these segments entirely for final or gold release
#define nodprint

#endifdef


// ******************************************************************************************************************


/// non-darkplaces compile

// this is just a placeholder for certain bits of code that will only be optional in early releases
// uncomment the next line and certain darkplaces only code will not be compiled
// #define nondp

#ifdef nondp
#message			-- compile: darkplaces __not__ required - runs on any engine (in theory) 
#endifdef

/// remove the above section for dp only releases

// the darkplaces compile saves some resources

// ******************************************************************************************************************


// extra server cvars
// most should take the form "svx_{varname}"
// at this time these have limited effect

// note: these use up global vars and are designed to operate in a 3 (or 4) tiered system
//				 level 0 is the only level really necessary if server ops are agreeable with developer selected defaults

//#define xvars

#ifdef xvars

// level 0 control - we _always_ want these compiled in
// - important server controls needed for daily ops

#define xvars0

// engine behavior control vars - how to default when things behave badly or fail
//	-	these mostly modify existing default behavior to an alternate option

#define xvars1

// vars level 2 stuff
// - mostly cosmetic items not affecting game play

#define xvars2

#message			-- compile: xvars total (level 0 - 3) control package 
#else


// high priority - still want these
#define xvars0

#message			-- compile: xvars level 0 control package 


#endifdef


// cvar define package for default.cfg will be used if we define this element

//#define cv_setdef

// all cvars will (__MUST__) be set in default.cfg - they wont be set by code
// this saves a few global vars
// the default.cfg required is included in the docs dir


// ******************************************************************************************************************

// possible options - permanent compile in
// svx_glowcorpse used at xvars2 level - must be seta in default.cfg

//#define glowcorpse // dead with quad glows


// ******************************************************************************************************************


// compile in frikbots - see docs for use

#define FRIKBOT

// ******************************************************************************************************************


/// **************************************
/// ops section
///
/// **************************************

// this section is the operating macro functions and variable section


// framer()

// implement a frame seqeunce where anything might happen in the frames
// one frame is incremented each entry - if this is changed in excode, set eframe appropriate to that
// the third parameter - "t_on" - is the function name that can be called by other code

//  just mnemonics t0 help understand the code - we need brevity for the 256 limit
// t_  think_ functions
// t_on - function define for this loop - * can be called by other code *
// t_to - where we go when we hit end frame
// t_time - nextthink interval used in the _entire_ loop - unless adjusted in excode
// sframe - start_frame of the loop
// eframe - end_frame of the loop
/// excode --- run any arbitrary code - SUB_Null() __MUST__ be put in for nothing, you can NOT leave this blank!

#define framer(sframe,eframe,t_on,t_to,t_time,excode) void() t_on {if (self.think != t_on|| self.frame < sframe || self.frame >= eframe){self.frame = sframe - 1; self.think = t_on;} self.frame = self.frame + 1; self.nextthink = time + t_time; if (self.frame == eframe) {self.think = t_to;} excode;}

// self loop - does not think to a t_to on eframe

#define framerloop(sframe,eframe,t_on,t_time,excode) void() t_on {if (self.think != t_on|| self.frame < sframe || self.frame >= eframe){self.frame = sframe - 1; self.think = t_on;} self.frame = self.frame + 1; self.nextthink = time + t_time; excode;}

/*

// code layout
// note logic change - if current self.frame is beyond start frame or end frame in either direction, we reset to start frame
// freset has been removed - no longer needed, if we re-enter, looping to self and see the endframe, that is a reset
// remove t_to and this line for framerloop: if (self.frame == eframe) { self.think = t_to; }

void() t_on 
{
	if (self.think != t_on|| self.frame < sframe || self.frame >= eframe)
	{
		self.frame = sframe - 1;
		self.think = t_on;
	}
	self.frame = self.frame + 1;
	self.nextthink = time + t_time;
	if (self.frame == eframe) { self.think = t_to; }
	excode; // run any arbitrary code - SUB_Null() for nothing, you can NOT leave this blank!
}

*/

// run arbitrary code in a specific frame, range of frames or set of frames

#define frame_arb(thisframe,arbcode) if (self.frame == thisframe) { arbcode; };

#define frametwo_arb(thisframe,thatframe,arbcode) if (self.frame == thisframe || self.frame == thatframe) { arbcode; };

#define framerange_arb(thisframe,thatframe,arbcode) if (self.frame >= thisframe && self.frame <= thatframe) { arbcode; };

// no instances of this logic yet
//#define framethree_arb(thisframe,thatframe,threeframe,arbcode) if (self.frame == thisframe || self.frame == thatframe || self.frame == threeframe) { arbcode; };
//#define framenot_arb(thisframe,arbcode) if (self.frame != thisframe) { arbcode; };
//#define framenottwo_arb(thisframe,thatframe,arbcode) if (self.frame != thisframe && self.frame != thatframe) { arbcode; };

// arbcode will run on any frame in the list
// use -666 to negate a frame test with this							- you could use any sufficiently small negative number, just always use the same one

//#define frameset_arb(thisframe,twoframe,threeframe,fourframe,fiveframe,sixframe,arbcode) if (self.frame == thisframe || self.frame == twoframe || self.frame == threeframe || self.frame == fourframe || self.frame == fiveframe || self.frame == sixframe) { arbcode; };



// ******************************************************************************************************************

// re-used variable assignments
//			a few entity variables go unused, many more are under used
//			one main issue is when you decide to make a re-used a unique new variable
// 		advantage here - if we have a conflict, comment out the define and make a regular entity variable

// hints
// use a script like lsevar to find out where evars are used
// use "grep -C 3" or so to check individual lines of code


/// issues - make sure _NOTHING_ uses the replace text - NOTHING ! -- the precompiler will swap EVERY LAST INSTANCE of matching text
// note: the precompiler might have some logic smarts - {something}_b does not seem to swap if #define {something} thisdef
//				 these have been checked extensively but might break new code or old mod code - they will have to be carefully checked

// the most recent entity spawned in certain functions - we re-use newmis

#define nspawn newmis

// self.frags is used repeatedly for local defines - excepting players / bots
// self.oldenemy is used for local defines - doors & plats

// ent var sub for generic floats - NOT a reliable store		-- ** same as rnd_ **

#define f__			bubble_count

// ent var sub for generic vectors - NOT a reliable store

#define v__		dest1
#define v___x		dest1_x
#define v___y		dest1_y
#define v___z		dest1_z

// set an ent var for local damage - ldmg
// dmg_take is only referenced once in combat.qc

#define ldmg_			dmg_take

// dog & demon jump velocity length test - vector length ONLY -- jump_vel assigned:

#define jump_vel		jump_flag

// various random choices ents make - ONLY reliable locally !
// can NOT ! use f__ and rnd_ together in the same code

#define rnd_		bubble_count

// spike type for spikes, superspikes, hell knight shot, wizard shot

#define spike_type		bubble_count

// some local vector spot1, spot2 replacements
//			*** CAN NEVER happen for ANY door called code, which use dest*

#define spot1_		dest1

#define spot1__x		dest1_x
#define spot1__y		dest1_y
#define spot1__z		dest1_z

#define spot2_		dest2

#define spot2__x		dest2_x
#define spot2__y		dest2_y
#define spot2__z		dest2_z

//#define q2model_lighting

#define q2monster_replace_soldier
//#define q2monster_replace_demon

// Quake 2 Strogg Replacements
// Replaces Quake 1 monsters with Quake 2 counterparts

#ifdef q2monster_replace_soldier
#message			-- compile: Replace Quake 1 Soldier with Quake 2 Soldier 
#endifdef
#ifdef q2monster_replace_demon
#message			-- compile: Replace Quake 1 Demon with Quake 2 Mutant 
#endifdef


