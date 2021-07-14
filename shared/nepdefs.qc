/*  Copyright (C) 1996-1997  Id Software, Inc.

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    See file, 'COPYING', for details.
*/
// FrikaC: reltest
.vector newvelocity;
.float needsvelocity;
.vector lastorigin;

// FrikaC: activation
.void() 	th_activate;
.void() 	th_deactivate;


// FrikaC: added targets
.string targetname2, targetname3, targetname4;
.string killtarget2;
.float delay2, delay3, delay4;


/******************
	Warpzonelib
	Requirements
******************/
.float Version;
.float SendFlags;
.float(entity to, float sendflags) SendEntity;
.float modelscale; // scaling factor of the dlight
float	MSG_ENTITY				= 5; // csqc
const float ENT_CLIENT_WARPZONE_TELEPORTED = 32;
const float ENT_CLIENT_WARPZONE = 24;
const float ENT_CLIENT_WARPZONE_CAMERA = 25;


float engine_features;
float NEP_FEAT_WARPZONE = 1;

float NEP_AFLAG_ROTATESETSIZE = 4;

// wrapping for engine features
//void(vector v1, vector v2, float nomonsters, entity forent) nep_traceline;

void(vector v1, vector v2, float nomonsters, entity forent) nep_traceline =
{
		traceline( v1, v2, nomonsters, forent );
};
