/*

Quake 2 ammo pickups.

*/


/*
"model" - bsp box model - size MUST be '0 0 0', '32 32 56'
- model must be set or this will be a regular shell box
"aflag" - ammo count
"weapon" - this determines where aflag will be added !
- 1 = shells
- 2 = bullets
- 3 = rockets / grenades
- 4 = cells
- 5 = slugs
*/

/*

Quake 2 ammo_ entities

*/

/*QUAKED ammo_shells (.3 .3 1) (-16 -16 -16) (16 16 16)
*/
void() ammo_shells =
{
	precache_model ("models/items/ammo/shells/medium/tris.md2");
	setmodel (self, "models/items/ammo/shells/medium/tris.md2");
	self.aflag = self.aflag;
	if (!self.aflag)
		self.aflag = 10;
	self.weapon = 1;
	self.netname = "shells";
	setorigin (self, self.origin + '0 0 0');
	setsize (self, '-16 -16 -16', '16 16 16');
	self.touch = ammo_touch;
	StartItem ();
};

/*QUAKED ammo_bullets (.3 .3 1) (-16 -16 -16) (16 16 16)
*/
void() ammo_bullets =
{
	precache_model ("models/items/ammo/bullets/medium/tris.md2");
	setmodel (self, "models/items/ammo/bullets/medium/tris.md2");
	self.aflag = self.aflag;
	if (!self.aflag)
		self.aflag = 50;
	self.weapon = 2;
	self.netname = "bullets";
	setorigin (self, self.origin + '0 0 0');
	setsize (self, '-16 -16 -16', '16 16 16');
	self.touch = ammo_touch;
	StartItem ();
};

/*QUAKED ammo_rockets (.3 .3 1) (-16 -16 -16) (16 16 16)
*/
void() ammo_rockets =
{
	precache_model ("models/items/ammo/rockets/medium/tris.md2");
	setmodel (self, "models/items/ammo/rockets/medium/tris.md2");
	self.aflag = self.aflag;
	if (!self.aflag)
		self.aflag = 5;
	self.weapon = 3;
	self.netname = "rockets";
	setorigin (self, self.origin + '0 0 0');
	setsize (self, '-16 -16 -16', '16 16 16');
	self.touch = ammo_touch;
	StartItem ();
};

/*QUAKED ammo_cells (.3 .3 1) (-16 -16 -16) (16 16 16)
*/
void() ammo_cells =
{
	precache_model ("models/items/ammo/cells/medium/tris.md2");
	setmodel (self, "models/items/ammo/cells/medium/tris.md2");
	self.aflag = self.aflag;
	if (!self.aflag)
		self.aflag = 50;
	self.weapon = 4;
	self.netname = "cells";
	setorigin (self, self.origin + '0 0 0');
	setsize (self, '-16 -16 -16', '16 16 16');
	self.touch = ammo_touch;
	StartItem ();
};

/*QUAKED ammo_slugs (.3 .3 1) (-16 -16 -16) (16 16 16)
*/
void() ammo_slugs =
{
	precache_model ("models/items/ammo/slugs/medium/tris.md2");
	setmodel (self, "models/items/ammo/slugs/medium/tris.md2");
	self.aflag = self.aflag;
	if (!self.aflag)
		self.aflag = 10;
	self.weapon = 5;
	self.netname = "slugs";
	setorigin (self, self.origin + '0 0 0');
	setsize (self, '-16 -16 -16', '16 16 16');
	self.touch = ammo_touch;
	StartItem ();
};

/*QUAKED ammo_grenades (.3 .3 1) (-16 -16 -16) (16 16 16)
model="models/items/ammo/grenades/medium/"
*/