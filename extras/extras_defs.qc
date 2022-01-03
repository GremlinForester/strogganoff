/*
This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by the
Free Software Foundation; either version 2 of the License, or (at your
option) any later version.

This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software Foundation,
Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
*/

/* 
	Written by Frank Condello <pox@planetquake.com>
	
	Prototypes and globals for extra junk...
*/

// Globals ====================================================================

// Footsteps
.float		spawnsilent;
.vector		old_velocity;

// Swimming
.float	outwsound;		// head out of water flag
.float	inwsound;		// head back in water flag


// Corpse
.string headmdl;

// func_liquid & func_ladder
.float fwatershift;
.float fwatershifttime;
.string cshift;
.float drag;
.float gravity;// actually a system global from the Mission Pack builds of Quake
.float oldgravity;
.float zerogtime;

// General use
.float speed2;
.float wait2;
.string event, event2;
.string noise5;
.string	mdl2;
float START_ON = 1;
.string message2, killtarget2;

// Hipnotic Rotate
.vector neworigin;
.vector rotate;
.float  endtime;
.float  rotate_type;
.string path;
.string group;
.float	duration;

// Prototypes =================================================================
void() CheckFuncWaterDeath;

