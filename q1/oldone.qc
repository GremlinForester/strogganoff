/*
==============================================================================

OLD ONE

==============================================================================
*/
$cd id1/models/old_one
$origin 0 0 24
$base base
$skin skin
$scale 1

void() finale_1;
void() finale_2;
void() finale_3;
void() finale_4;


entity	shub;

$frame old1 old2 old3 old4 old5 old6 old7 old8 old9 
$frame old10 old11 old12 old13 old14 old15 old16 old17 old18 old19 
$frame old20 old21 old22 old23 old24 old25 old26 old27 old28 old29 
$frame old30 old31 old32 old33 old34 old35 old36 old37 old38 old39 
$frame old40 old41 old42 old43 old44 old45 old46 

$frame shake1 shake2 shake3 shake4 shake5 shake6 shake7 shake8
#ifdef codefix
// note - the original code essentially skips the first of a dup frame and uses the 2nd
// this fixes the compiler warning
$frame shake9 shake10 shake11 shakeb12 shake12 shake13 shake14
#else
$frame shake9 shake10 shake11 shake12 shake12 shake13 shake14
#endif
$frame shake15 shake16 shake17 shake18 shake19 shake20

//void() old_stand     =[      $old1,       old_stand    ] {};

/*
void() old_idle1        =[      $old1,  old_idle2       ] {};
void() old_idle2        =[      $old2,  old_idle3       ] {};
void() old_idle3        =[      $old3,  old_idle4       ] {};
void() old_idle4        =[      $old4,  old_idle5       ] {};
void() old_idle5        =[      $old5,  old_idle6       ] {};
void() old_idle6        =[      $old6,  old_idle7       ] {};
void() old_idle7        =[      $old7,  old_idle8       ] {};
void() old_idle8        =[      $old8,  old_idle9       ] {};
void() old_idle9        =[      $old9,  old_idle10      ] {};
void() old_idle10       =[      $old10, old_idle11      ] {};
void() old_idle11       =[      $old11, old_idle12      ] {};
void() old_idle12       =[      $old12, old_idle13      ] {};
void() old_idle13       =[      $old13, old_idle14      ] {};
void() old_idle14       =[      $old14, old_idle15      ] {};
void() old_idle15       =[      $old15, old_idle16      ] {};
void() old_idle16       =[      $old16, old_idle17      ] {};
void() old_idle17       =[      $old17, old_idle18      ] {};
void() old_idle18       =[      $old18, old_idle19      ] {};
void() old_idle19       =[      $old19, old_idle20      ] {};
void() old_idle20       =[      $old20, old_idle21      ] {};
void() old_idle21       =[      $old21, old_idle22      ] {};
void() old_idle22       =[      $old22, old_idle23      ] {};
void() old_idle23       =[      $old23, old_idle24      ] {};
void() old_idle24       =[      $old24, old_idle25      ] {};
void() old_idle25       =[      $old25, old_idle26      ] {};
void() old_idle26       =[      $old26, old_idle27      ] {};
void() old_idle27       =[      $old27, old_idle28      ] {};
void() old_idle28       =[      $old28, old_idle29      ] {};
void() old_idle29       =[      $old29, old_idle30      ] {};
void() old_idle30       =[      $old30, old_idle31      ] {};
void() old_idle31       =[      $old31, old_idle32      ] {};
void() old_idle32       =[      $old32, old_idle33      ] {};
void() old_idle33       =[      $old33, old_idle34      ] {};
void() old_idle34       =[      $old34, old_idle35      ] {};
void() old_idle35       =[      $old35, old_idle36      ] {};
void() old_idle36       =[      $old36, old_idle37      ] {};
void() old_idle37       =[      $old37, old_idle38      ] {};
void() old_idle38       =[      $old38, old_idle39      ] {};
void() old_idle39       =[      $old39, old_idle40      ] {};
void() old_idle40       =[      $old40, old_idle41      ] {};
void() old_idle41       =[      $old41, old_idle42      ] {};
void() old_idle42       =[      $old42, old_idle43      ] {};
void() old_idle43       =[      $old43, old_idle44      ] {};
void() old_idle44       =[      $old44, old_idle45      ] {};
void() old_idle45       =[      $old45, old_idle46      ] {};
void() old_idle46       =[      $old46, old_idle1       ] {};
*/

framerloop($old1, $old46, old_idle1, 0.1,SUB_Null());


#ifdef nondp
// the one place we have this - because the loop uses substring
// this will be for a non-darkplaces version of the v107 framer only
void() old_thrash1        =[ $shake1,  old_thrash2       ] {lightstyle(0, "m");};
void() old_thrash2        =[      $shake2,  old_thrash3       ] {lightstyle(0, "k");};
void() old_thrash3        =[      $shake3,  old_thrash4       ] {lightstyle(0, "k");};
void() old_thrash4        =[      $shake4,  old_thrash5       ] {lightstyle(0, "i");};
void() old_thrash5        =[      $shake5,  old_thrash6       ] {lightstyle(0, "g");};
void() old_thrash6        =[      $shake6,  old_thrash7       ] {lightstyle(0, "e");};
void() old_thrash7        =[      $shake7,  old_thrash8       ] {lightstyle(0, "c");};
void() old_thrash8        =[      $shake8,  old_thrash9       ] {lightstyle(0, "a");};
void() old_thrash9        =[      $shake9,  old_thrash10      ] {lightstyle(0, "c");};
void() old_thrash10       =[      $shake10, old_thrash11      ] {lightstyle(0, "e");};
void() old_thrash11       =[      $shake11, old_thrash12      ] {lightstyle(0, "g");};
void() old_thrash12       =[      $shake12, old_thrash13      ] {lightstyle(0, "i");};
void() old_thrash13       =[      $shake13, old_thrash14      ] {lightstyle(0, "k");};
void() old_thrash14       =[      $shake14, old_thrash15      ] {lightstyle(0, "m");};
void() old_thrash15       =[      $shake15, old_thrash16      ] {lightstyle(0, "m");
self.cnt = self.cnt + 1;
if (self.cnt != 3)
	self.think = old_thrash1;
};
void() old_thrash16       =[      $shake16, old_thrash17      ] {lightstyle(0, "g");};
void() old_thrash17       =[      $shake17, old_thrash18      ] {lightstyle(0, "c");};
void() old_thrash18       =[      $shake18, old_thrash19      ] {lightstyle(0, "b");};
void() old_thrash19       =[      $shake19, old_thrash20      ] {lightstyle(0, "a");};
void() old_thrash20       =[      $shake20, old_thrash20      ] {finale_4();};
#else
// for substring - lightstyle(0, ss);												- note: a dp _only_ feature
// via thrash_lightstyle(self.frame - $shake1);
// str = "mkkigecaceg ikmmgcba"
// space is for original code skipped frame
// ($shake12 - 1) - skip the same frame the original macro skipped

void(float fr) thrash_lightstyle =
{
	lightstyle(0, substring("mkkigecaceg ikmmgcba", fr, 1));
};

framer($shake1, $shake20, old_thrash1, SUB_Null, 0.1,

	frame_arb($shake16,

		self.cnt = self.cnt + 1;
		if (self.cnt != 3)
			self.frame = $shake1;
	);

	if (self.frame == ($shake12 - 1)) self.frame = $shake12;
	thrash_lightstyle(self.frame - $shake1);

	frame_arb($shake20,finale_4());
);

#endif

//============================================================================

void() finale_1 =
{
	local entity	pos, pl;
	local entity	timer;
	
#ifdef opgrade
	killed_monsters = killed_monsters + 1;
	WriteByte (MSG_ALL, SVC_KILLEDMONSTER);	// FIXME: reliable broadcast
#endif

	intermission_exittime = time + 10000000;	// never allow exit
	intermission_running = 1;

	// find the intermission spot
	pos = find (world, classname, "info_intermission");
	if (!pos)
#ifdef noobjerr
	{
// later use our uber random find dest
		pos = find (world, classname, "info_player_deathmatch");
		if (!pos) pos = find (world, classname, "info_teleport_destination");
		if (!pos)
		{
			pos = spawn(); // the dude abides - just make one
			pos.classname =  "info_intermission";
		}

	}
#else
		error ("no info_intermission");					//opgrade protected
#endif

	pl = find (world, classname, "misc_teleporttrain");
	if (!pl)
#ifdef noobjerr
		SUB_Null(); // yeah, this is a screwey thing here, but in theory some map designer could have used a reg. teleport to take out shubs
	else
#else
		error ("no teleporttrain");					//opgrade protected
#endif
	remove (pl);

	WriteByte (MSG_ALL, SVC_FINALE);
	WriteString (MSG_ALL, string_null);

	pl = find (world, classname, "player");
	while (pl) // != world)
	{
		pl.view_ofs = '0 0 0';
		pl.angles = other.v_angle = pos.mangle;
		pl.fixangle = TRUE;		// turn this way immediately
		pl.map = self.map;
		pl.nextthink = time + 0.5;
		pl.takedamage = DAMAGE_NO;
		pl.solid = SOLID_NOT;
		pl.movetype = MOVETYPE_NONE;
		pl.modelindex = 0;
		setorigin (pl, pos.origin);
		pl = find (pl, classname, "player");
	}	
	
	// make fake versions of all players as standins, and move the real
	// players to the intermission spot
	
	// wait for 1 second
	timer = spawn();
	timer.nextthink = time + 1;
	timer.think = finale_2;	
};

void() finale_2 =
{
//	local vector	o;

	// start a teleport splash inside shub

//	o = shub.origin - '0 100 0';

// not precisely the same code - below "shub" makes the sound, location is still same	
	spawn_tfog(shub.origin - '0 100 0');

/*
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_TELEPORT);
	WriteCoord (MSG_BROADCAST, o_x);
	WriteCoord (MSG_BROADCAST, o_y);
	WriteCoord (MSG_BROADCAST, o_z);

	sound (shub, CHAN_VOICE, "misc/r_tele1.wav", 1, ATTN_NORM);
*/	
	
	self.nextthink = time + 2;
	self.think = finale_3;
};

void() finale_3 =
{
	// start shub thrashing wildly
	shub.think = old_thrash1;
	sound (shub, CHAN_VOICE, "boss2/death.wav", 1, ATTN_NORM);
	lightstyle(0, "abcdefghijklmlkjihgfedcb");	
};

void() finale_4 =
{
	// throw tons of meat chunks	
//	local	vector	oldo;
//	local	float	x__, y__, z__;
#define x__		self.dest2_x
#define y__		self.dest2_y
#define z__		self.dest2_z

#ifdef opgrade
// mega gibs
#define GIB_RATIO1 16
#define GIB_RATIO2 32
// spatter factor
#define spat_	self.frags

#else
// regular shub gibs
#define GIB_RATIO1 32
#define GIB_RATIO2 96
// spatter factor
#define spat_	-999

#endif

//	local	float	r;
//	local entity	n;

	sound (self, CHAN_VOICE, "boss2/pop2.wav", 1, ATTN_NORM);
	
	self.v__ = self.origin;

	z__ = 16;
	while (z__ <= 144)
	{
		x__ = -64;
		while (x__ <= 64)
		{
			y__ = -64;
			while (y__ <= 64)
			{
				self.origin_x = self.v___x + x__;
				self.origin_y = self.v___y + y__;
				self.origin_z = self.v___z + z__;

#ifdef opgrade
// opg - some random spatter factor for shubs gibs
				spat_ = -999;
				if (random() < 0.3) spat_ = -666 * random();
#endif
				self.rnd_ = random();
				if (self.rnd_ < 0.3)				
					ThrowGib ("progs/gib1.mdl", spat_);
				else if (self.rnd_ < 0.6)
					ThrowGib ("progs/gib2.mdl", spat_);
				else
					ThrowGib ("progs/gib3.mdl", spat_);
#ifdef opgrade
// opg in dp - scale some chunks up
#ifndef nondp
				if (random() < 0.25) nspawn.scale = 6 * random();
#endif
#endif
				y__ = y__ + GIB_RATIO1;
			}
			x__ = x__ + GIB_RATIO1;
		}
		z__ = z__ + GIB_RATIO2;
	}
	// start the end text
	WriteByte (MSG_ALL, SVC_FINALE);
	WriteString (MSG_ALL, "Congratulations and well done! You have\nbeaten the hideous Shub-Niggurath, and\nher hundreds of ugly changelings and\nmonsters. You have proven that your\nskill and your cunning are greater than\nall the powers of Quake. You are the\nmaster now. Id Software salutes you.");

// put a player model down
	nspawn = spawn();
	setmodel (nspawn, "progs/player.mdl");
	self.v__ = self.v__ - '32 264 0';
	setorigin (nspawn, self.v__);
	nspawn.angles = '0 290 0';
	nspawn.frame = 1;

	remove (self);

// switch cd track
	WriteByte (MSG_ALL, SVC_CDTRACK);
	WriteByte (MSG_ALL, 3);
	WriteByte (MSG_ALL, 3);
	lightstyle(0, "m");	

#undef x__
#undef y__
#undef z__
#undef spat_
};

//============================================================================

void () nopain =
{
	self.health = 40000;
};

//============================================================================


/*QUAKED monster_oldone (1 0 0) (-16 -16 -24) (16 16 32)
*/
void() monster_oldone =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}

	precache_model2 ("progs/oldone.mdl");

	precache_sound2 ("boss2/death.wav");
	precache_sound2 ("boss2/idle.wav");
	precache_sound2 ("boss2/sight.wav");
	precache_sound2 ("boss2/pop2.wav");

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	
	setmodel (self, "progs/oldone.mdl");
	setsize (self, '-160 -128 -24', '160 128 256');

	self.health = 40000;		// kill by telefrag
	self.think = old_idle1;
	self.nextthink = time + 0.1;	
	self.takedamage = DAMAGE_YES;
	self.th_pain = nopain;
	self.th_die = finale_1;
	shub = self;
	
	total_monsters = total_monsters + 1;
};

