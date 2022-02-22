/*
==============================================================================

STROGG ZOMBIE
(it's a start)
==============================================================================
*/

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8
$frame stand9 stand10 stand11 stand12 stand13 stand14 stand15

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9 walk10 walk11
$frame walk12 walk13 walk14 walk15 walk16 walk17 walk18 walk19

$frame run1 run2 run3 run4 run5 run6 run7 run8 run9 run10 run11 run12
$frame run13 run14 run15 run16 run17 run18

$frame atta1 atta2 atta3 atta4 atta5 atta6 atta7 atta8 atta9 atta10 atta11
$frame atta12 atta13

$frame attb1 attb2 attb3 attb4 attb5 attb6 attb7 attb8 attb9 attb10 attb11
$frame attb12 attb13 attb14

$frame attc1 attc2 attc3 attc4 attc5 attc6 attc7 attc8 attc9 attc10 attc11
$frame attc12

$frame paina1 paina2 paina3 paina4 paina5 paina6 paina7 paina8 paina9 paina10
$frame paina11 paina12

$frame painb1 painb2 painb3 painb4 painb5 painb6 painb7 painb8 painb9 painb10
$frame painb11 painb12 painb13 painb14 painb15 painb16 painb17 painb18 painb19
$frame painb20 painb21 painb22 painb23 painb24 painb25 painb26 painb27 painb28

$frame painc1 painc2 painc3 painc4 painc5 painc6 painc7 painc8 painc9 painc10
$frame painc11 painc12 painc13 painc14 painc15 painc16 painc17 painc18

$frame paind1 paind2 paind3 paind4 paind5 paind6 paind7 paind8 paind9 paind10
$frame paind11 paind12 paind13

$frame paine1 paine2 paine3 paine4 paine5 paine6 paine7 paine8 paine9 paine10
$frame paine11 paine12 paine13 paine14 paine15 paine16 paine17 paine18 paine19
$frame paine20 paine21 paine22 paine23 paine24 paine25 paine26 paine27 paine28
$frame paine29 paine30

$frame cruc_1 cruc_2 cruc_3 cruc_4 cruc_5 cruc_6

.float inpain;

/*
STAND
*/

framerloop($stand1, $stand15, stroggzombie_stand1, 0.1,ai_stand());

/*
WALK
*/

framerloop($walk1, $walk19, stroggzombie_walk1, 0.1,

	frame_arb($walk19,if (random() < 0.2) sound (self, CHAN_VOICE, "zombie/z_idle.wav", 1, ATTN_IDLE));

	ai_rep($walk1, ai_walk, 0, 2, 3, 2, 1, 0, 0, 0);
	ai_rep($walk9, ai_walk, 0, 0, 2, 2, 1, 0, 0, 0);
	framerange_arb($walk17,$walk19,ai_walk(0));
);

/*
RUN
*/

framerloop($run1, $run18, stroggzombie_run1, 0.1,

	frame_arb($run1,self.inpain = 0);
	frame_arb($run18,
	
		if (random() < 0.2) sound(self, CHAN_VOICE, "zombie/z_idle.wav", 1, ATTN_IDLE);
		if (random() > 0.8) sound(self, CHAN_VOICE, "zombie/z_idle1.wav", 1, ATTN_IDLE);
	);

	ai_rep($run1, ai_run, 1, 1, 0, 1, 2, 3, 4, 4);
	ai_rep($run9, ai_run, 2, 0, 0, 0, 2, 4, 6, 7);
	frame_arb($run17,ai_run(3));
	frame_arb($run18,ai_run(8));
);



/*
=============================================================================

ATTACKS

=============================================================================
*/

void() StroggZombieGrenadeTouch =
{
	if (other == self.owner)
		return;		// don't explode on owner
	if (other.takedamage)
	{
		T_Damage (other, self, self.owner, 20 );
		sound (self, CHAN_WEAPON, "blob/death1.wav", 1, ATTN_NORM);
	//	BecomeExplosion();
		pointparticles(particleeffectnum("TE_EXPLOSION"), self.origin, '0 0 0', 1);		
		remove (self);
		return;
	}
	sound (self, CHAN_WEAPON, "blob/death1.wav", 1, ATTN_NORM);	// bounce sound
	self.velocity = '0 0 0';
	self.avelocity = '0 0 0';
	T_RadiusDamage (self, self.owner, 60, other);
	pointparticles(particleeffectnum("TE_EXPLOSION"), self.origin, '0 0 0', 1);
//	BecomeExplosion();
	self.touch = SUB_Remove;
};

/*
================
ZombieFireGrenade
================
*/
void(vector st) StroggZombieFireGrenade =
{
//	local	entity missile;//, mpuff;	// fx_warning
//	local	vector	org;

	sound (self, CHAN_WEAPON, "zombie/z_shot1.wav", 1, ATTN_NORM);

/*
	newmis = spawn ();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_BOUNCE;
	newmis.solid = SOLID_BBOX;
*/

// calc org
 	self.v__ = self.origin + st_x * v_forward + st_y * v_right + (st_z - 24) * v_up;

// closer to a zombie grenade than a weapon grenade
	SpawnMeatSpray(self.v__, '0 0 0');
	newmis.solid = SOLID_BBOX;
// set missile speed	

//	makevectors (self.angles);

	newmis.velocity = normalize(self.enemy.origin - self.v__);
	newmis.velocity = newmis.velocity * 600;
	newmis.velocity_z = 200;

//	newmis.avelocity = '3000 1000 2000';

	newmis.touch = StroggZombieGrenadeTouch;
	
// set missile duration
	newmis.nextthink = time + 2.5;
	newmis.modelflags = MF_ROCKET;	
/*
	newmis.think = SUB_Remove;

	setmodel (newmis, "progs/zom_gib.mdl");
	setsize (newmis, '0 0 0', '0 0 0');		
	setorigin (newmis, self.v__);
*/
};

/*
ATTACK 1
*/

framer($atta1, $atta13, stroggzombie_atta1, stroggzombie_run1, 0.1,

	ai_face();
	frame_arb($atta13,StroggZombieFireGrenade('-10 -22 30'));
);

/*
ATTACK 2
*/

framer($attb1, $attb13, stroggzombie_attb1, stroggzombie_run1, 0.1,

	ai_face();
	frame_arb($attb13,StroggZombieFireGrenade('-10 -24 29'));
);

/*
ATTACK 3
*/

framer($attc1, $attc12, stroggzombie_attc1, stroggzombie_run1, 0.1,

	ai_face();
	frame_arb($attc12,StroggZombieFireGrenade('-12 -19 29'));
);


void() stroggzombie_missile =
{
//	local float	r;
	
	self.rnd_ = random();
	
	if (self.rnd_ < 0.3)
		stroggzombie_atta1 ();
	else if (self.rnd_ < 0.6)
		stroggzombie_attb1 ();
	else
		stroggzombie_attc1 ();
};


/*
=============================================================================

PAIN

=============================================================================
*/

/*
PAIN 1
*/

framer($paina1, $paina12, stroggzombie_paina1, stroggzombie_run1, 0.1,

	frame_arb($paina1,sound(self, CHAN_VOICE, "zombie/z_pain.wav", 1, ATTN_NORM));
	frame_arb($paina2,ai_painforward(3));
	frame_arb($paina3,ai_painforward(1));
	frame_arb($paina5,ai_pain(3));
	frametwo_arb($paina4,$paina6,ai_pain(1));
);


/*
PAIN 2
*/

framer($painb1, $painb28, stroggzombie_painb1, stroggzombie_run1, 0.07,

	frame_arb($painb1,sound(self, CHAN_VOICE, "zombie/z_pain1.wav", 1, ATTN_NORM));
	frame_arb($painb9,sound(self, CHAN_BODY, "zombie/z_fall.wav", 1, ATTN_NORM));
	frame_arb($painb25,ai_painforward(1));
	frame_arb($painb3,ai_pain(8));
	frame_arb($painb4,ai_pain(6));
	frametwo_arb($painb2,$painb5,ai_pain(2));
);


/*
PAIN 3
*/

framer($painc1, $painc18, stroggzombie_painc1, stroggzombie_run1, 0.1,

	frame_arb($painc1,sound(self, CHAN_VOICE, "zombie/z_pain1.wav", 1, ATTN_NORM));
	frame_arb($painc4,ai_pain(1));
	frame_arb($painc3,ai_pain(3));
	frametwo_arb($painc11,$painc12,ai_painforward(1));
);


/*
PAIN 4
*/

framer($paind1, $paind13, stroggzombie_paind1, stroggzombie_run1, 0.1,

	frame_arb($paind1,sound(self, CHAN_VOICE, "zombie/z_pain.wav", 1, ATTN_NORM));
	frame_arb($paind9,ai_pain(1));
);

/*
PAIN 5
*/

void() stroggzombie_paine10	=[	$paine10,	stroggzombie_paine11	]
{
	sound (self, CHAN_BODY, "zombie/z_fall.wav", 1, ATTN_NORM);
	self.solid = SOLID_NOT;
};
void() stroggzombie_paine11	=[	$paine11,	stroggzombie_paine12	] {self.nextthink = self.nextthink + 5;self.health = 60;};
void() stroggzombie_paine12	=[	$paine12,	stroggzombie_paine13	]
{
// see if ok to stand up
	self.health = 60;
	sound (self, CHAN_VOICE, "zombie/z_idle.wav", 1, ATTN_IDLE);
	self.solid = SOLID_SLIDEBOX;
	if (!walkmove (0, 0))
	{
		self.think = stroggzombie_paine11;
		self.solid = SOLID_NOT;
		return;
	}
};

framer($paine1, $paine9, stroggzombie_paine1, stroggzombie_paine10, 0.1,

	frame_arb($paine1,self.health = 60;sound(self, CHAN_VOICE, "zombie/z_pain.wav", 1, ATTN_NORM));

	ai_rep($paine2, ai_pain, 8, 5, 3, 1, 2, 1, 1, 2);
);

framer($paine13, $paine30, stroggzombie_paine13, stroggzombie_run1, 0.1,

	frame_arb($paine28,ai_pain(1));
	frame_arb($paine25,ai_painforward(5));
	frame_arb($paine26,ai_painforward(3));
	frame_arb($paine27,ai_painforward(1));
);


void() stroggzombie_die =
{
	gibbs("progs/h_zombie.mdl");
	sound (self, CHAN_VOICE, "zombie/z_gib.wav", 1, ATTN_NORM);
};

/*
=================
zombie_pain

Zombies can only be killed (gibbed) by doing 60 hit points of damage
in a single frame (rockets, grenades, quad shotgun, quad nailgun).

A hit of 25 points or more (super shotgun, quad nailgun) will allways put it
down to the ground.

A hit of from 10 to 40 points in one frame will cause it to go down if it
has been twice in two seconds, otherwise it goes into one of the four
fast pain frames.

A hit of less than 10 points of damage (winged by a shotgun) will be ignored.

FIXME: don't use pain_finished because of nightmare hack
=================
*/
void(entity attacker, float take) stroggzombie_pain =
{
//	local float r;

	self.health = 60;		// allways reset health

	if (take < 9)
		return;				// totally ignore

	if (self.inpain == 2)
		return;			// down on ground, so don't reset any counters

// go down immediately if a big enough hit
	if (take >= 25)
	{
		self.inpain = 2;
		stroggzombie_paine1 ();
		return;
	}
	
	if (self.inpain)
	{
// if hit again in next gre seconds while not in pain frames, definately drop
		self.pain_finished = time + 3;
		return;			// currently going through an animation, don't change
	}
	
	if (self.pain_finished > time)
	{
// hit again, so drop down
		self.inpain = 2;
		stroggzombie_paine1 ();
		return;
	}

// gp into one of the fast pain animations	
	self.inpain = 1;

	self.rnd_ = random();
	if (self.rnd_ < 0.25)
		stroggzombie_paina1 ();
	else if (self.rnd_ <  0.5)
		stroggzombie_painb1 ();
	else if (self.rnd_ <  0.75)
		stroggzombie_painc1 ();
	else
		stroggzombie_paind1 ();
};



//============================================================================

/*QUAKED monster_stroggzombie (1 0 0) (-16 -16 -24) (16 16 32) ambush
*/
void() monster_stroggzombie =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	
	self.classname = "monster_stroggzombie";

	precache_model ("progs/zombie.mdl");
	precache_model ("progs/h_zombie.mdl");
	precache_model ("progs/zom_gib.mdl");

	precache_sound ("zombie/z_idle.wav");
	precache_sound ("zombie/z_idle1.wav");
	precache_sound ("zombie/z_shot1.wav");
	precache_sound ("zombie/z_gib.wav");
	precache_sound ("zombie/z_pain.wav");
	precache_sound ("zombie/z_pain1.wav");
	precache_sound ("zombie/z_fall.wav");
	precache_sound ("zombie/z_miss.wav");
	precache_sound ("zombie/z_hit.wav");
	precache_sound ("zombie/idle_w2.wav");

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/zombie.mdl");

	setsize (self, '-16 -16 -24', '16 16 40');
	self.health = 60;

	self.th_stand = stroggzombie_stand1;
	self.th_walk = stroggzombie_walk1;
	self.th_run = stroggzombie_run1;
	self.th_pain = stroggzombie_pain;
	self.th_die = stroggzombie_die;
	self.th_missile = stroggzombie_missile;

	walkmonster_start;
};
