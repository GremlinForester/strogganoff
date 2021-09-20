/*

Quake 2 weapon pickups.

*/


/*QUAKED weapon_shotgun (0 .5 .8) (-16 -16 0) (16 16 32)
*/
void() weapon_shotgun =
{
	if (!self.model) // allow next 5 functions to come here & not run this set
	{
		precache_model ("models/weapons/g_shotg/tris.md2");
		setmodel (self, "models/weapons/g_shotg/tris.md2");
		self.weapon = WEP_SHOTGUN;
		self.netname = "Shotgun";
	}
	self.classname = "weapon_shotgun";
	self.modelflags = MF_ROTATE;
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};

/*QUAKED weapon_supershotgun (0 .5 .8) (-16 -16 0) (16 16 32)
*/
void() weapon_supershotgun =
{
	if (!self.model) // allow next 5 functions to come here & not run this set
	{
		precache_model ("models/weapons/g_shotg2/tris.md2");
		setmodel (self, "models/weapons/g_shotg2/tris.md2");
		self.weapon = WEP_SUPERSHOTGUN;
		self.netname = "Super Shotgun";
	}
	self.modelflags = MF_ROTATE;
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};

/*QUAKED weapon_machinegun (0 .5 .8) (-16 -16 0) (16 16 32)
*/
void() weapon_machinegun =
{
	precache_model ("models/weapons/g_machn/tris.md2");
	setmodel (self, "models/weapons/g_machn/tris.md2");
	self.weapon = WEP_MACHINEGUN;
	self.netname = "Machinegun";
	self.classname = "weapon_machinegun";
	self.modelflags = MF_ROTATE;
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};

/*QUAKED weapon_chaingun (0 .5 .8) (-16 -16 0) (16 16 32)
*/
void() weapon_chaingun =
{
	precache_model ("models/weapons/g_chain/tris.md2");
	setmodel (self, "models/weapons/g_chain/tris.md2");
	self.weapon = WEP_CHAINGUN;
	self.netname = "Chaingun";
	self.classname = "weapon_chaingun";
	self.modelflags = MF_ROTATE;
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};

/*QUAKED weapon_grenadelauncher (0 .5 .8) (-16 -16 0) (16 16 32)
*/
void() weapon_grenadelauncher =
{
	precache_model ("models/weapons/g_launch/tris.md2");
	setmodel (self, "models/weapons/g_launch/tris.md2");
	self.weapon = 3;
	self.netname = "Grenade Launcher";
	self.classname = "weapon_grenadelauncher";
	self.modelflags = MF_ROTATE;
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};

/*QUAKED weapon_rocketlauncher (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() weapon_rocketlauncher =
{
	precache_model ("models/weapons/g_rocket/tris.md2");
	setmodel (self, "models/weapons/g_rocket/tris.md2");
	self.weapon = 3;
	self.netname = "Rocket Launcher";
	self.classname = "weapon_rocketlauncher";
	self.modelflags = MF_ROTATE;
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};

/*QUAKED weapon_hyperblaster (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() weapon_hyperblaster =
{
	precache_model ("models/weapons/g_hyperb/tris.md2");
	setmodel (self, "models/weapons/g_hyperb/tris.md2");
	self.weapon = 3;
	self.netname = "Hyperblaster";
	self.classname = "weapon_hyperblaster";
	self.modelflags = MF_ROTATE;
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};

/*QUAKED weapon_railgun (0 .5 .8) (-16 -16 0) (16 16 32)
*/
void() weapon_railgun =
{
	precache_model ("models/weapons/g_rail/tris.md2");
	setmodel (self, "models/weapons/g_rail/tris.md2");
	self.weapon = 3;
	self.netname = "Railgun";
	self.classname = "weapon_railgun";
	self.modelflags = MF_ROTATE;
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};

/*QUAKED weapon_bfg (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() weapon_bfg =
{
	precache_model ("models/weapons/g_bfg/tris.md2");
	setmodel (self, "models/weapons/g_bfg/tris.md2");
	self.weapon = 3;
	self.netname = "BFG";
	self.classname = "weapon_bfg";
	self.modelflags = MF_ROTATE;
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};