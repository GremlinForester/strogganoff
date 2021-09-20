/*

Quake 2 items like armor, health and powerups.

*/

/*
===============================================================================

ARMOR

===============================================================================
*/

/*QUAKED item_armor_body (.3 .3 1) (-16 -16 -16) (16 16 16)
model="models/items/armor/body/"
*/
void() item_armor_body =
{
	self.touch = armor_touch;
	precache_model ("models/items/armor/body/tris.md2");
	setmodel (self, "models/items/armor/body/tris.md2");
	setsize (self, '-16 -16 -16', '16 16 16');
	self.modelflags = MF_ROTATE;
	self.netname = "Body Armor";
	StartItem ();
}

/*QUAKED item_armor_combat (.3 .3 1) (-16 -16 -16) (16 16 16)
model="models/items/armor/combat/"
*/
void() item_armor_combat =
{
	self.touch = armor_touch;
	precache_model ("models/items/armor/combat/tris.md2");
	setmodel (self, "models/items/armor/combat/tris.md2");
	setsize (self, '-16 -16 -16', '16 16 16');
	self.modelflags = MF_ROTATE;
	self.netname = "Combat Armor";
	StartItem ();
}

/*QUAKED item_armor_jacket (.3 .3 1) (-16 -16 -16) (16 16 16)
model="models/items/armor/jacket/"
*/
void() item_armor_jacket =
{
	self.touch = armor_touch;
	precache_model ("models/items/armor/jacket/tris.md2");
	setmodel (self, "models/items/armor/jacket/tris.md2");
	setsize (self, '-16 -16 -16', '16 16 16');
	self.modelflags = MF_ROTATE;
	self.netname = "Jacket Armor";
	StartItem ();
}

/*QUAKED item_armor_shard (.3 .3 1) (-16 -16 -16) (16 16 16)
model="models/items/armor/shard/"
*/
void() item_armor_shard =
{
	self.touch = armor_touch;
	precache_model ("models/items/armor/shard/tris.md2");
	setmodel (self, "models/items/armor/shard/tris.md2");
	precache_sound ("misc/ar2_pkup.wav");
	setsize (self, '-16 -16 -16', '16 16 16');
	self.modelflags = MF_ROTATE;
	self.netname = "Armor Shard";
	self.noise = "misc/ar2_pkup.wav";
	StartItem ();
}


/*QUAKED item_power_screen (.3 .3 1) (-16 -16 -16) (16 16 16)
model="models/items/armor/screen/"
*/


/*QUAKED item_power_shield (.3 .3 1) (-16 -16 -16) (16 16 16)
model="models/items/armor/shield/"
*/

/*
===============================================================================

POWERUPS

===============================================================================
*/

/*QUAKED item_quad (.3 .3 1) (-16 -16 -16) (16 16 16)
model="models/items/quaddama/"
*/
void() item_quad =
{
	self.touch = powerup_touch;
	precache_model ("models/items/quaddama/tris.md2");
	precache_sound ("items/damage.wav");
	precache_sound ("items/damage2.wav");
	precache_sound ("items/damage3.wav");
	self.noise = "items/damage.wav";
	setmodel (self, "models/items/quaddama/tris.md2");
	self.netname = "Quad Damage";
	self.items = IT_QUAD;
	self.modelflags = MF_ROTATE;
	setsize (self, '-16 -16 -16', '16 16 16');
	StartItem ();
}

/*QUAKED item_invulnerability (.3 .3 1) (-16 -16 -16) (16 16 16)
model="models/items/invulner/"
*/
void() item_invulnerability =
{
	precache_model ("models/items/invulner/tris.md2");
	precache_sound ("items/pkup.wav");
	precache_sound ("items/protect2.wav");
	precache_sound ("items/protect3.wav");
	self.noise = "items/pkup.wav";
	setmodel (self, "models/items/invulner/tris.md2");
	self.netname = "Invulnerability";
	self.items = IT_INVULNERABILITY;
	setsize (self, '-16 -16 -16', '16 16 16');
	self.touch = powerup_touch;
	StartItem();
};

/*QUAKED item_silencer (.3 .3 1) (-16 -16 -16) (16 16 16)
model="models/items/silencer/"
*/


/*QUAKED item_breather (.3 .3 1) (-16 -16 -16) (16 16 16)
model="models/items/breather/"
*/


/*QUAKED item_enviro (.3 .3 1) (-16 -16 -16) (16 16 16)
model="models/items/enviro/"
*/


/*QUAKED item_ancient_head (.3 .3 1) (-16 -16 -16) (16 16 16)
Special item that gives +2 to maximum health
*/


/*QUAKED item_adrenaline (.3 .3 1) (-16 -16 -16) (16 16 16)
gives +1 to maximum health
model="models/items/adrenal/"
*/


/*QUAKED item_bandolier (.3 .3 1) (-16 -16 -16) (16 16 16)
model="models/items/band/"
*/


/*QUAKED item_pack (.3 .3 1) (-16 -16 -16) (16 16 16)
model="models/items/pack/"
*/

/*
===============================================================================

KEYS

===============================================================================
*/

/*QUAKED key_data_cd (0 .5 .8) (-16 -16 -16) (16 16 16)
key for computer centers
model="models/items/keys/data_cd/"
*/


/*QUAKED key_power_cube (0 .5 .8) (-16 -16 -16) (16 16 16) TRIGGER_SPAWN NO_TOUCH
warehouse circuits
model="models/items/keys/power/"
*/


/*QUAKED key_pyramid (0 .5 .8) (-16 -16 -16) (16 16 16)
key for the entrance of jail3
model="models/items/keys/pyramid/"
*/


/*QUAKED key_data_spinner (0 .5 .8) (-16 -16 -16) (16 16 16)
key for the city computer
model="models/items/keys/spinner/"
*/


/*QUAKED key_pass (0 .5 .8) (-16 -16 -16) (16 16 16)
security pass for the security level
model="models/items/keys/pass/"
*/


/*QUAKED key_blue_key (0 .5 .8) (-16 -16 -16) (16 16 16)
normal door key - blue
model="models/items/keys/key/"
*/


/*QUAKED key_red_key (0 .5 .8) (-16 -16 -16) (16 16 16)
normal door key - red
model="models/items/keys/red_key/"
*/


/*QUAKED key_commander_head (0 .5 .8) (-16 -16 -16) (16 16 16)
tank commander's head
model="models/items/c_head/"
*/


/*QUAKED key_airstrike_target (0 .5 .8) (-16 -16 -16) (16 16 16)
tank commander's head
model="models/items/c_head/"
*/

/*
===============================================================================

HEALTH

===============================================================================
*/

/*QUAKED item_health (.3 .3 1) (-16 -16 -16) (16 16 16)
model="models/items/healing/medium/"
*/
void() item_health =
{
	self.touch = health_touch;
	precache_model ("models/items/healing/medium/tris.md2");
	precache_sound ("items/pkup.wav");
	self.noise = "items/pkup.wav";
	setmodel (self, "models/items/healing/medium/tris.md2");
	setsize (self, '-16 -16 -16', '16 16 16');
	self.healamount = 20;
	self.healtype = 1;
	StartItem ();
}

/*QUAKED item_health_small (.3 .3 1) (-16 -16 -16) (16 16 16)
model="models/items/healing/stimpack/"
*/
void() item_health_small =
{
	self.touch = health_touch;
	precache_model ("models/items/healing/stimpack/tris.md2");
	precache_sound ("items/pkup.wav");
	self.noise = "items/pkup.wav";
	setmodel (self, "models/items/healing/stimpack/tris.md2");
	setsize (self, '-16 -16 -16', '16 16 16');
	self.healamount = 2;
	self.healtype = 1;
	StartItem ();
}


/*QUAKED item_health_large (.3 .3 1) (-16 -16 -16) (16 16 16)
model="models/items/healing/large/"
*/
void() item_health_large =
{
	self.touch = health_touch;
	precache_model ("models/items/healing/large/tris.md2");
	precache_sound ("items/pkup.wav");
	self.noise = "items/pkup.wav";
	setmodel (self, "models/items/healing/large/tris.md2");
	setsize (self, '-16 -16 -16', '16 16 16');
	self.healamount = 25;
	self.healtype = 1;
	StartItem ();
}

/*QUAKED item_health_mega (.3 .3 1) (-16 -16 -16) (16 16 16)
model="models/items/mega_h/"
*/
void() item_health_mega =
{
	self.touch = health_touch;
	precache_model ("models/items/mega_h/tris.md2");
	precache_sound ("items/pkup.wav");
	self.noise = "items/pkup.wav";
	setmodel (self, "models/items/mega_h/tris.md2");
	setsize (self, '-16 -16 -16', '16 16 16');
	self.healamount = 100;
	self.healtype = 1;
	StartItem ();
}