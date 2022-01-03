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
	
	Modified SUB_CalcMove clone that work with non-push entities,
	and misc reusable functions...
	
*/

//============================================================================

/*
============
SUB_RandomRange

Return a random number between min & max (or min if max is 0)
Just make sure max is greater than min...
============
*/
float(float rmin, float rmax) SUB_RandomRange =
{
	if (!rmax)
		return rmin;
	else
		return rmin + random()*(rmax-rmin);
};

//============================================================================


//============================================================================

/*
	The following are routines from Scourge of Armagon,
	required by rotating brush entities (see hipnotic/hiprot.qc)
*/

void(entity ent, float amount) hurt_setdamage =
{
	ent.dmg = amount;
	if (!amount)
		ent.solid = SOLID_NOT;
	else
	  ent.solid = SOLID_TRIGGER;
	  
	ent.nextthink = -1;
};

vector(vector ang) SUB_NormalizeAngles =
{
	while(ang_x > 360)
	  ang_x = ang_x - 360;

	while(ang_x < 0)
	  ang_x = ang_x + 360;
	
	while(ang_y > 360)
	  ang_y = ang_y - 360;
	  
	while(ang_y < 0)
	  ang_y = ang_y + 360;
	
	while(ang_z > 360)
	  ang_z = ang_z - 360;

	while(ang_z < 0)
	  ang_z = ang_z + 360;
	
	return ang;
};

//============================================================================
