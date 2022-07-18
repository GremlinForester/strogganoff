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
	self.items = IT_ARMOR_BODY;
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
	self.items = IT_ARMOR_COMBAT;
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
	self.items = IT_ARMOR_JACKET;
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
	self.classname = "item_armor_shard";
	self.noise = "misc/ar2_pkup.wav";
	StartItem ();
}


/*QUAKED item_power_screen (.3 .3 1) (-16 -16 -16) (16 16 16)
model="models/items/armor/screen/"
*/
//MrC: This item went apparently unused in Q2, how about an invisibility cloak?
void() item_power_screen =
{
	self.touch = inv_item_touch;
	precache_model ("models/items/armor/screen/tris.md2");
	precache_sound ("misc/ar3_pkup.wav");
	self.noise = "misc/ar3_pkup.wav";
	setmodel (self, "models/items/armor/screen/tris.md2");
	self.netname = "Power Screen";
//	self.items = IT_INVISIBILITY;
	self.modelflags = MF_ROTATE;
	setsize (self, '-16 -16 -16', '16 16 16');
	StartItem ();
}

/*QUAKED item_power_shield (.3 .3 1) (-16 -16 -16) (16 16 16)
model="models/items/armor/shield/"
*/
void() item_power_shield =
{
	self.touch = powerup_touch;
	precache_model ("models/items/armor/shield/tris.md2");
	precache_sound ("misc/ar3_pkup.wav");
	self.noise = "misc/ar3_pkup.wav";
	setmodel (self, "models/items/armor/shield/tris.md2");
	self.netname = "Power Shield";
	self.items = IT_POWER_SHIELD;
	self.modelflags = MF_ROTATE;
	setsize (self, '-16 -16 -16', '16 16 16');
	StartItem ();
}

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
	self.touch = inv_item_touch;
	precache_model ("models/items/quaddama/tris.md2");
	precache_sound ("items/damage.wav");
	precache_sound ("items/damage2.wav");
	precache_sound ("items/damage3.wav");
	self.noise = "items/damage.wav";
	setmodel (self, "models/items/quaddama/tris.md2");
	self.netname = "Quad Damage";
//	self.items = IT_QUAD;
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
//	self.items = IT_INVULNERABILITY;
	self.modelflags = MF_ROTATE;
	setsize (self, '-16 -16 -16', '16 16 16');
	self.touch = inv_item_touch;
	StartItem();
};

/*QUAKED item_silencer (.3 .3 1) (-16 -16 -16) (16 16 16)
model="models/items/silencer/"
*/
void() item_silencer =
{
	self.touch = inv_item_touch;
	precache_model ("models/items/silencer/tris.md2");
	precache_sound ("misc/ar3_pkup.wav");
	self.noise = "misc/ar3_pkup.wav";
	setmodel (self, "models/items/silencer/tris.md2");
	self.netname = "Doubler";
//	self.items = IT_DOUBLER;
	self.modelflags = MF_ROTATE;
	setsize (self, '-16 -16 -16', '16 16 16');
	StartItem ();
}

/*QUAKED item_doubler (.3 .3 1) (-16 -16 -16) (16 16 16)
model="models/items/silencer/"
*/
void() item_doubler =
{
	item_silencer();
}

/*QUAKED item_breather (.3 .3 1) (-16 -16 -16) (16 16 16)
model="models/items/breather/"
*/
void() item_breather =
{
	self.touch = inv_item_touch;
	precache_model ("models/items/breather/tris.md2");
	precache_sound ("misc/ar3_pkup.wav");
	self.noise = "misc/ar3_pkup.wav";
	setmodel (self, "models/items/breather/tris.md2");
	self.netname = "Rebreather";
//	self.items = IT_BREATHER;
	self.modelflags = MF_ROTATE;
	setsize (self, '-16 -16 -16', '16 16 16');
	StartItem ();
}

/*QUAKED item_enviro (.3 .3 1) (-16 -16 -16) (16 16 16)
model="models/items/enviro/"
*/
void() item_enviro =
{
	self.touch = inv_item_touch;
	precache_model ("models/items/enviro/tris.md2");
	precache_sound ("misc/ar3_pkup.wav");
	self.noise = "misc/ar3_pkup.wav";
	setmodel (self, "models/items/enviro/tris.md2");
	self.netname = "Environment Suit";
//	self.items = IT_SUIT;
	self.modelflags = MF_ROTATE;
	setsize (self, '-16 -16 -16', '16 16 16');
	StartItem ();
}

/*QUAKED item_bandolier (.3 .3 1) (-16 -16 -16) (16 16 16)
model="models/items/band/"
*/
void() item_bandolier =
{
	self.touch = powerup_touch;
	precache_model ("models/items/band/tris.md2");
	precache_sound ("items/pkup.wav");
	self.noise = "items/pkup.wav";
	setmodel (self, "models/items/band/tris.md2");
	self.netname = "Bandolier";
//	self.items = IT_QUAD;
	self.modelflags = MF_ROTATE;
	setsize (self, '-16 -16 -16', '16 16 16');
	StartItem ();
}

/*QUAKED item_pack (.3 .3 1) (-16 -16 -16) (16 16 16)
model="models/items/pack/"
*/
void() item_pack =
{
	self.touch = powerup_touch;
	precache_model ("models/items/pack/tris.md2");
	precache_sound ("items/pkup.wav");
	self.noise = "items/pkup.wav";
	setmodel (self, "models/items/pack/tris.md2");
	self.netname = "Ammo Pack";
//	self.items = IT_QUAD;
	self.modelflags = MF_ROTATE;
	setsize (self, '-16 -16 -16', '16 16 16');
	StartItem ();
}

/*
===============================================================================

KEYS

===============================================================================
*/

/*QUAKED key_data_cd (0 .5 .8) (-16 -16 -16) (16 16 16)
key for computer centers
model="models/items/keys/data_cd/"
*/
void() key_data_cd =
{

	precache_model ("models/items/keys/data_cd/tris.md2");
	setmodel (self, "models/items/keys/data_cd/tris.md2");
	precache_sound ("items/pkup.wav");
	self.noise = "items/pkup.wav";
	self.netname = "Data CD";
	self.modelflags = MF_ROTATE;
	self.noise = "items/pkup.wav";
	self.touch = q2key_touch;
	self.items_q2keys = IT_KEY_DATACD;
	setsize (self, '-16 -16 -16', '16 16 16');
	StartItem ();
};


/*QUAKED key_power_cube (0 .5 .8) (-16 -16 -16) (16 16 16) TRIGGER_SPAWN NO_TOUCH
warehouse circuits
model="models/items/keys/power/"
*/
void() key_power_cube =
{
	precache_model ("models/items/keys/power/tris.md2");
	setmodel (self, "models/items/keys/power/tris.md2");
	precache_sound ("items/pkup.wav");
	self.noise = "items/pkup.wav";
	self.netname = "Power Cube";
	self.modelflags = MF_ROTATE;
	self.noise = "items/pkup.wav";
	self.touch = q2key_touch;
	self.items_q2keys = IT_KEY_POWERCUBE;
	setsize (self, '-16 -16 -16', '16 16 16');
	StartItem ();
};

/*QUAKED key_pyramid (0 .5 .8) (-16 -16 -16) (16 16 16)
key for the entrance of jail3
model="models/items/keys/pyramid/"
*/
void() key_pyramid =
{
	precache_model ("models/items/keys/pyramid/tris.md2");
	setmodel (self, "models/items/keys/pyramid/tris.md2");
	precache_sound ("items/pkup.wav");
	self.noise = "items/pkup.wav";
	self.netname = "Pyramid Key";
	self.modelflags = MF_ROTATE;
	self.noise = "items/pkup.wav";
	self.touch = q2key_touch;
	self.items_q2keys = IT_KEY_PYRAMID;
	setsize (self, '-16 -16 -16', '16 16 16');
	StartItem ();
};

/*QUAKED key_data_spinner (0 .5 .8) (-16 -16 -16) (16 16 16)
key for the city computer
model="models/items/keys/spinner/"
*/
void() key_data_spinner =
{
	precache_model ("models/items/keys/spinner/tris.md2");
	setmodel (self, "models/items/keys/spinner/tris.md2");
	precache_sound ("items/pkup.wav");
	self.noise = "items/pkup.wav";
	self.netname = "Data Spinner";
	self.modelflags = MF_ROTATE;
	self.noise = "items/pkup.wav";
	self.touch = q2key_touch;
	self.items_q2keys = IT_KEY_DATASPINNER;
	setsize (self, '-16 -16 -16', '16 16 16');
	StartItem ();
};

/*QUAKED key_pass (0 .5 .8) (-16 -16 -16) (16 16 16)
security pass for the security level
model="models/items/keys/pass/"
*/
void() key_pass =
{
	precache_model ("models/items/keys/pass/tris.md2");
	setmodel (self, "models/items/keys/pass/tris.md2");
	precache_sound ("items/pkup.wav");
	self.noise = "items/pkup.wav";
	self.netname = "Security Pass";
	self.modelflags = MF_ROTATE;
	self.noise = "items/pkup.wav";
	self.touch = q2key_touch;
	self.items_q2keys = IT_KEY_PASS;
	setsize (self, '-16 -16 -16', '16 16 16');
	StartItem ();
};

/*QUAKED key_blue_key (0 .5 .8) (-16 -16 -16) (16 16 16)
normal door key - blue
model="models/items/keys/key/"
*/
void() key_blue_key =
{
	precache_model ("models/items/keys/key/tris.md2");
	setmodel (self, "models/items/keys/key/tris.md2");
	precache_sound ("items/pkup.wav");
	self.noise = "items/pkup.wav";
	self.netname = "Blue Key";
	self.modelflags = MF_ROTATE;
	self.noise = "items/pkup.wav";
	self.touch = q2key_touch;
	self.items_q2keys = IT_KEY_BLUE;
	setsize (self, '-16 -16 -16', '16 16 16');
	StartItem ();
};

/*QUAKED key_red_key (0 .5 .8) (-16 -16 -16) (16 16 16)
normal door key - red
model="models/items/keys/red_key/"
*/
void() key_red_key =
{
	precache_model ("models/items/keys/red_key/tris.md2");
	setmodel (self, "models/items/keys/red_key/tris.md2");
	precache_sound ("items/pkup.wav");
	self.noise = "items/pkup.wav";
	self.netname = "Red Key";
	self.modelflags = MF_ROTATE;
	self.noise = "items/pkup.wav";
	self.touch = q2key_touch;
	self.items_q2keys = IT_KEY_RED;
	setsize (self, '-16 -16 -16', '16 16 16');
	StartItem ();
};

/*QUAKED key_commander_head (0 .5 .8) (-16 -16 -16) (16 16 16)
tank commander's head
model="models/items/c_head/"
*/
void() key_commander_head =
{
	precache_model ("models/monsters/commandr/head/tris.md2");
	setmodel (self, "models/monsters/commandr/head/tris.md2");
	precache_sound ("items/pkup.wav");
	self.noise = "items/pkup.wav";
	self.netname = "Commander's Head";
	self.noise = "items/pkup.wav";
	self.touch = q2key_touch;
	self.items_q2keys = IT_KEY_HEAD;
	setsize (self, '-16 -16 -16', '16 16 16');
	StartItem ();
};

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
	self.healtype = 2;
	StartItem ();
}