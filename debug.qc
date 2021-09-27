/* ::-::
 *
 * Cataboligne
 *
 * file: debug.qc
 *
 * date: 12/20/14
 *
 * qc - debug codes
 *
 */







// ******************************************************************************************************************
// qc dev specific codes & warning system

#ifdef debug

#message			-- compile: debug code, warnings and options included 



// ******************************************************************************************************************

// amtest.qc, jctest.qc, & flag.qc are 3 files that were included with v1.06 qc, but not put in progs.src to compile
// it is unknown if anyone (after iD) tested with them, but here they are for completeness
// - deathball generates a compiler warning - and touching it would fail

// one could imagine amtest is for American McGee and jctest is John Carmack

// 		stats - 
//											110 numstatements, 8 numfunctions, 17 numglobaldefs, 21 numpr_globals and 1756 bytes
/*
'      test compiled in																		no test code
46664 strofs (of 1000000)                                    |  46328 strofs (of 1000000)
 19440 numstatements (of 524288)                      |  19330 numstatements (of 524288)
   638 numfunctions (of 16384)                            |    630 numfunctions (of 16384)
  2232 numglobaldefs (of 32768)                         |   2215 numglobaldefs (of 32768)
   214 numfielddefs (191 unique) (of 2048)          |    210 numfielddefs (188 unique) (of 2048)
  2573 numpr_globals (of 65536)                         |   2552 numpr_globals (of 65536)
255269 TOTAL SIZE                                            | 253513 TOTAL SIZE
*/

// I fixed the compile errors, and brought the code in line with qc++ spec

// yet these are hardly functional even as test code
//		- the teleport sets velocity to move, and dest (?)
//		- while the test_fodder keeps making moving objects that only last 5 secs
//		- trigger_jctest just changes a lightstyle, and can have a dprint

// with no obvious use, they can be blocked from compiling by commenting out this define:
#define idtest

#ifdef idtest

#message			-- compile: debug - iD test codes

// **************************************
// from amtest.qc
//
// **************************************

// 		- I think this funky comment bar is to indicate debug codes
/*~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>
~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~*/

void() test_teleport_touch;
void() tele_done;

/*QUAKED test_teleport (0 .5 .8) ?
Teleporter testing
*/
void() test_teleport =
{
	precache_model ("sprites/s_aball.spr");
	setmodel (self, self.model);								// does nada without this - No. 6
	setsize (self, self.mins, self.maxs);	

	self.touch = test_teleport_touch;
	self.solid = 1;

// note: if you dont set a target string you wont have this on a map - it does not use this
	if (!self.target)
#ifdef noobjerr
	{
		remove(self);
		return;
	}
#else
		objerror ("no target\n");				//opgrade protected
#endif
};

void() test_teleport_touch =
{
local entity oldself;
	other.movetype = MOVETYPE_TOSS;
//	other.solid = SOLID_NOT;

	other.dest = '256 -128 -128';
	oldself = self;
	self = other;
//	SUB_CalcMove (self.dest, 200, tele_done);
	self.velocity = '1000 0 0 ';
	self = oldself;
};

void() tele_done =
{
	self.movetype = MOVETYPE_WALK;
	self.solid = SOLID_SLIDEBOX;	
};

/*~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>
~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~*/

//void() test_goaway;
void() test_spawn;

/*QUAKED test_fodder (0 .5 .8) ?
beating guy
*/
void() test_fodder =
{
	self.nextthink = time + 3;
	self.think = test_spawn;
};

void() test_spawn =
{
#define body self.enemy
#define test_goaway SUB_Remove
//local entity	body;
	makevectors (self.angles);
	precache_model ("progs/soldier.mdl");
	body = spawn();
	setmodel (body, "progs/soldier.mdl");
	setorigin (body, self.origin);
	body.classname = "player";					// a lot of code tests against this, 		*** ent has really strange effects in game
	body.health = 1000;
//	body.frags = 0; // pointless
	body.takedamage = DAMAGE_AIM;
	body.solid = SOLID_SLIDEBOX;
	body.movetype = MOVETYPE_WALK;
//	body.show_hostile = 0; // pointless
	body.weapon = 1;
	body.velocity = v_forward * 200;			// movement

	body.nextthink = time + 5;						// gone in 5 secs - unless think gets wacked
	body.think = test_goaway;

self.nextthink = time + 3;							// make one every 3 secs
self.think = test_spawn;

#undef body
#undef test_goaway
};

/*
duplicates SUB_Remove

void() test_goaway =
{
	remove (self);
};
*/


// **************************************
// from jctest.qc
//
// **************************************


void() jctrig =
{
#ifdef opgrade
// otherwise this damn thing is fired off as soon as the level loads - and you will know it
	if (other.classname != "player") return;
#endif

#ifndef nodprint
	dprint ("here\n\n");
#endif

// when this happens, the level wide lighting starts flashing
	lightstyle(0, "az");
};

/*QUAKED trigger_jctest (.5 .5 .5) ?
*/
void() trigger_jctest =
{
	setmodel (self, self.model);								// does nada without this - No. 6
	setsize (self, self.mins, self.maxs);
//	self.solid = SOLID_EDGE; // this is an error - since this is a trigger, the next line is most likely
	self.solid = SOLID_TRIGGER;
	self.touch = jctrig;
};


// **************************************
// from flag.qc
//
// **************************************

/*QUAKED item_deathball (.3 .3 1) (0 0 0) (32 32 32)

void() deathball_touch;

// note: this is total fail as is

void() item_deathball =
{	
	self.touch = deathball_touch;
};
*/
