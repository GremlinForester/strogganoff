//void() movetarget_f;
void() t_movetarget;
void() knight_walk1;
void() knight_bow6;
void() knight_bow1;
void(entity etemp, entity stemp, entity stemp, float dmg) T_Damage;
/*

.enemy
Will be world if not currently angry at anyone.

.movetarget
The next path spot to walk toward.  If .enemy, ignore .movetarget.
When an enemy is killed, the monster will try to return to it's path.

.hunt_time
Set to time + something when the player is in sight, but movement straight for
him is blocked.  This causes the monster to use wall following code for
movement direction instead of sighting on the player.

.ideal_yaw
A yaw angle of the intended direction, which will be turned towards at up
to 45 deg / state.  If the enemy is in view and hunt_time is not active,
this will be the exact line towards the enemy.

.pausetime
A monster will leave it's stand state and head towards it's .movetarget when
time > .pausetime.

walkmove(angle, speed) primitive is all or nothing
*/


//
// globals
//
//float	current_yaw;	// fx_warning

//
// when a monster becomes angry at a player, that monster will be used
// as the sight target the next frame so that monsters near that one
// will wake up even if they wouldn't have noticed the player
//
entity	sight_entity;
float	sight_entity_time;

float(float v) anglemod =
{
	while (v >= 360)
		v = v - 360;
	while (v < 0)
		v = v + 360;
	return v;
};

/*
==============================================================================

MOVETARGET CODE

The angle of the movetarget effects standing and bowing direction, but has no effect on movement, which allways heads to the next target.

targetname
must be present.  The name of this movetarget.

target
the next spot to move to.  If not present, stop here for good.

pausetime
The number of seconds to spend standing or bowing for path_stand or path_bow

==============================================================================
*/

/*
	more useless code - moved into path_corner, the only place it gets used

void() movetarget_f =
{
	if (!self.targetname)
#ifdef noobjerr
	{
		remove(self);
		return;
	}
#else
		objerror ("monster_movetarget: no targetname");					//opgrade protected
#endif
		
	self.solid = SOLID_TRIGGER;
	self.touch = t_movetarget;
	setsize (self, '-8 -8 -8', '8 8 8');
	
};
*/

/*
=============
t_movetarget

Something has bumped into a movetarget.  If it is a monster
moving towards it, change the next destination and continue.
==============
*/
void() t_movetarget =
{
local entity	temp;

	if (other.movetarget != self)
		return;
	
	if (other.enemy)
		return;		// fighting, not following a path

	temp = self;
	self = other;
	other = temp;

	if (self.classname == "monster_ogre")
		sound (self, CHAN_VOICE, "ogre/ogdrag.wav", 1, ATTN_IDLE);// play chainsaw drag sound

//dprint ("t_movetarget\n");
	self.goalentity = self.movetarget = find (world, targetname, other.target);
	self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
	if (!self.movetarget)
	{
		self.pausetime = time + 999999;
		self.th_stand ();
		return;
	}
};



//============================================================================

/*
=============
range

returns the range catagorization of an entity reletive to self
0	melee range, will become hostile even if back is turned
1	visibility and infront, or visibility and show hostile
2	infront and show hostile
3	only triggered by damage
=============
*/

//MrC TODO: Add different melee ranges based on monster class types

float(entity targ) range =
{
//local vector	spot1, spot2;
//local float		r;	
//	spot1 = self.origin + self.view_ofs;
//	spot2 = targ.origin + targ.view_ofs;
	
	self.f__ = vlen ((self.origin + self.view_ofs) - (targ.origin + targ.view_ofs));
	if (self.f__ < 75) //120 Most Q2 monsters in general were too far away for melee
		return RANGE_MELEE;
	if (self.f__ < 500)
		return RANGE_NEAR;
	if (self.f__ < 1000)
		return RANGE_MID;
	return RANGE_FAR;
};

/*
=============
visible

returns 1 if the entity is visible to self, even if not infront ()
=============
*/

#define newvisible

#ifndef newvisible 
float (entity targ) visible =
{
//	local vector	spot1, spot2;
	
//	spot1 = self.origin + self.view_ofs;
//	spot2 = targ.origin + targ.view_ofs;
	traceline ((self.origin + self.view_ofs), (targ.origin + targ.view_ofs), TRUE, self);	// see through other monsters

	if (trace_inopen && trace_inwater)
		return FALSE;			// sight line crossed contents

	if (trace_fraction == 1)
		return TRUE;
#ifdef pointless_warning
	return FALSE;
#endif
};
#endifndef newvisible 

#ifdef newvisible 
float (entity targ) visible =
{
	//Thanks Subject9x for pointing the way here even though I messed it up!	
	
//  local float contentBuffer;
//	contentBuffer = (DPCONTENTS_SOLID | DPCONTENTS_BODY | DPCONTENTS_DONOTENTER | DPCONTENTS_MONSTERCLIP | DPCONTENTS_BOTCLIP | DPCONTENTS_WATER); //self.dphitcontentsmask;
//	self.dphitcontentsmask = 0;
//	self.dphitcontentsmask = self.dphitcontentsmask | (DPCONTENTS_SOLID | DPCONTENTS_BODY | DPCONTENTS_DONOTENTER | DPCONTENTS_OPAQUE | DPCONTENTS_SKY | DPCONTENTS_WATER);	//contents the AI CAN'T see through

//	if (self.classname == "BFG Projectile") //what tom hackery is this!?
//	{
//		traceline ((self.origin + self.view_ofs), (targ.origin + targ.view_ofs), TRUE, self);
//	}
//	else
//	{
		removeBitsFromEntity(self,dphitcontentsmask,DPCONTENTS_MONSTERCLIP); //Anything the AI should see through
		traceline ((self.origin + self.view_ofs), (targ.origin + targ.view_ofs), TRUE, self);
		
		if (!self.classname == "monster_marine")
			addBitsToEntity(self,dphitcontentsmask,DPCONTENTS_MONSTERCLIP);
//	}
//	self.dphitcontentsmask = self.dphitcontentsmask | rint(contentBuffer);

//	if (trace_inopen && trace_inwater) // sight line crossed contents
//		return FALSE;

	if (trace_fraction == 1)
		return TRUE;
		
#ifdef pointless_warning
	return FALSE;
#endif
};
#endifdef

/*
=============
infront

returns 1 if the entity is in front (in sight) of self
=============
*/
float(entity targ) infront =
{
//	local vector	vec;
//	local float		dot;
	
	makevectors (self.angles);
//	vec = normalize(targ.origin - self.origin);
	self.f__ = normalize(targ.origin - self.origin) * v_forward;
	
	if ( self.f__ > 0.3)
	{
		return TRUE;
	}
#ifdef pointless_warning
	return FALSE;
#endif
};


//============================================================================

/*
===========
ChangeYaw

Turns towards self.ideal_yaw at self.yaw_speed
Sets the global variable current_yaw
Called every 0.1 sec by monsters
============
*/
/*

void() ChangeYaw =
{
	local float		ideal, move;

//current_yaw = self.ideal_yaw;
// mod down the current angle
	current_yaw = anglemod( self.angles_y );
	ideal = self.ideal_yaw;
	
	if (current_yaw == ideal)
		return;
	
	move = ideal - current_yaw;
	if (ideal > current_yaw)
	{
		if (move > 180)
			move = move - 360;
	}
	else
	{
		if (move < -180)
			move = move + 360;
	}
		
	if (move > 0)
	{
		if (move > self.yaw_speed)
			move = self.yaw_speed;
	}
	else
	{
		if (move < 0-self.yaw_speed )
			move = 0-self.yaw_speed;
	}

	current_yaw = anglemod (current_yaw + move);

	self.angles_y = current_yaw;
};

*/


//============================================================================

void() HuntTarget =
{
	self.goalentity = self.enemy;
	self.think = self.th_run;
	self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
	self.nextthink = time + 0.1;
	SUB_AttackFinished (1);	// wait a while before first attack
};

void() SightSound =
{
//local float	rsnd;

	sound (self, CHAN_VOICE, self.sightSound, 1, ATTN_NORM);

	if (self.classname == "monster_ogre")	
		sound (self, CHAN_VOICE, "ogre/ogwake.wav", 1, ATTN_NORM);
	else if (self.classname == "monster_knight")
		sound (self, CHAN_VOICE, "knight/ksight.wav", 1, ATTN_NORM);
	else if (self.classname == "monster_shambler")
		sound (self, CHAN_VOICE, "shambler/ssight.wav", 1, ATTN_NORM);
	else if (self.classname == "monster_demon1")
		sound (self, CHAN_VOICE, "demon/sight2.wav", 1, ATTN_NORM);
	else if (self.classname == "monster_wizard")
		sound (self, CHAN_VOICE, "wizard/wsight.wav", 1, ATTN_NORM);
	else if (self.classname == "monster_zombie")
		sound (self, CHAN_VOICE, "zombie/z_idle.wav", 1, ATTN_NORM);
	else if (self.classname == "monster_dog")
		sound (self, CHAN_VOICE, "dog/dsight.wav", 1, ATTN_NORM);
	else if (self.classname == "monster_hell_knight")
		sound (self, CHAN_VOICE, "hknight/sight1.wav", 1, ATTN_NORM);
	else if (self.classname == "monster_tarbaby")
		sound (self, CHAN_VOICE, "blob/sight1.wav", 1, ATTN_NORM);
	else if (self.classname == "monster_vomit")
		sound (self, CHAN_VOICE, "vomitus/v_sight1.wav", 1, ATTN_NORM);
	else if (self.classname == "monster_enforcer")
	{
		self.rnd_ = rint(random() * 3);			
		if (self.rnd_ == 1)
			sound (self, CHAN_VOICE, "enforcer/sight1.wav", 1, ATTN_NORM);
		else if (self.rnd_ == 2)
			sound (self, CHAN_VOICE, "enforcer/sight2.wav", 1, ATTN_NORM);
		else if (! self.rnd_) // == 0)
			sound (self, CHAN_VOICE, "enforcer/sight3.wav", 1, ATTN_NORM);
		else
			sound (self, CHAN_VOICE, "enforcer/sight4.wav", 1, ATTN_NORM);
	}
	else if (self.classname == "monster_army")
		sound (self, CHAN_VOICE, "soldier/sight1.wav", 1, ATTN_NORM);
	else if (self.classname == "monster_shalrath")
		sound (self, CHAN_VOICE, "shalrath/sight.wav", 1, ATTN_NORM);
};

void() FoundTarget =
{
	if (self.enemy.classname == "player")
	{	// let other monsters see this monster for a while
		sight_entity = self;
		sight_entity_time = time;
	}
	
	self.show_hostile = time + 1;		// wake up other monsters

	SightSound ();
	HuntTarget ();
};

//Thanks coffee!

// ------------------------------------------------
float() FindMonster =
// ------------------------------------------------
{
local entity beast;

	if (self.attack_state != AS_ESCORTING)
		return FALSE;

	if (self.enemy)
		return FALSE;

	beast = findradius(self.origin, 1500);

	while(beast)
		{
		if ( (beast.classtype == CLASS_STROGG || beast.classtype == CLASS_ANIMAL) && visible(beast) && beast != self && beast.health > 0){
			self.enemy = beast;
		}
		
		beast = beast.chain;
		
		}
	
	if (!self.enemy)
		return FALSE;
	
	FoundTarget();
	return TRUE;
};

/*
===========
FindTarget

Self is currently not attacking anything, so try to find a target

Returns TRUE if an enemy was sighted

When a player fires a missile, the point of impact becomes a fakeplayer so
that monsters that see the impact will respond as if they had seen the
player.

To avoid spending too much time, only a single client (or fakeclient) is
checked each frame.  This means multi player games will have slightly
slower noticing monsters.
============
*/
float() FindTarget =
{
	local entity	client;
//	local float		r;


	if (self.classname == "monster_marine" || self.classname == "misc_insane")
	{
		if (FindMonster()){
			return TRUE;
		}
	}

// if the first spawnflag bit is set, the monster will only wake up on
// really seeing the player, not another monster getting angry

// spawnflags & 3 is a big hack, because zombie crucified used the first
// spawn flag prior to the ambush flag, and I forgot about it, so the second
// spawn flag works as well
	if (sight_entity_time >= time - 0.1 && !(self.spawnflags & 3) )
	{
		client = sight_entity;
		if (client.enemy == self.enemy)
			return FALSE;
	}
	else
	{
		client = checkclient ();
		if (!client)
			return FALSE;	// current check entity isn't in PVS
	}

	if (client == self.enemy)
		return FALSE;

	if (client.flags & FL_NOTARGET)
		return FALSE;
	if (client.items & IT_INVISIBILITY)
		return FALSE;

	self.f__ = range (client);
	if (self.f__ == RANGE_FAR)
		return FALSE;
		
	if (!visible (client))
		return FALSE;

	if (self.f__ == RANGE_NEAR)
	{
		if (client.show_hostile < time && !infront (client))
			return FALSE;
	}
	else if (self.f__ == RANGE_MID)
	{
		if ( /* client.show_hostile < time || */ !infront (client))
			return FALSE;
	}
	
	//Thanks coffee! https://www.quaddicted.com/webarchive/minion.planetquake.gamespy.com/tutorial/tutor8.htm
	
	
	
	if (self.attack_state == AS_ESCORTING)
		return FALSE;

	if (self.classname == "monster_marine" || self.classname == "misc_insane")
	{
		self.goalentity = client;
		self.attack_state = AS_ESCORTING;
		self.th_walk();
		return TRUE;
	}	
	
	
//
// got one
//
	self.enemy = client;
	if (self.enemy.classname != "player")
	{
		self.enemy = self.enemy.enemy;
		if (self.enemy.classname != "player")
		{
			self.enemy = world;
			return FALSE;
		}
	}
	
	FoundTarget ();

	return TRUE;
};


//=============================================================================

void(float dist) ai_forward =
{
	walkmove (self.angles_y, dist);
};

void(float dist) ai_back =
{
	walkmove ( (self.angles_y+180), dist);
};

/*
=============
ai_pain

stagger back a bit
=============
*/

#define ai_pain ai_back
/*
void(float dist) ai_pain =
{
	
	ai_back (dist);
/*
	local float	away;
	
	away = anglemod (vectoyaw (self.origin - self.enemy.origin) 
	+ 180*(random()- 0.5) );
	
	walkmove (away, dist);
*/
//};

/*
=============
ai_painforward

stagger back a bit
=============
*/
void(float dist) ai_painforward =
{
	walkmove (self.ideal_yaw, dist);
};

/*
=============
ai_walk

The monster is walking it's beat
=============
*/
void(float dist) ai_walk =
{
//	local vector		mtemp;	// fx_warning

	movedist = dist;

	// check for noticing a player
	if (FindTarget ())
		return;
	
	if (self.attack_state == AS_ESCORTING && vlen(self.origin - self.goalentity.origin) < 80)
	{
		self.pausetime = time + 3;
		self.th_stand();
	}	

	movetogoal (dist);
};


/*
=============
ai_stand

The monster is staying in one place for a while, with slight angle turns
=============
*/
void() ai_stand =
{
	if (FindTarget ()){
		return;
	}
	
	if (time > self.pausetime)
	{
		self.th_walk ();
		return;
	}
	
// change angle slightly

};

/*
=============
ai_turn

don't move, but turn towards ideal_yaw
=============
*/
void() ai_turn =
{
	if (FindTarget ())
		return;
	
	ChangeYaw ();
};

//=============================================================================

/*
=============
ChooseTurn
=============
*/
#ifdef unused

void(vector dest3) ChooseTurn =
{
	local vector	dir, newdir;
	
	dir = self.origin - dest3;

	newdir_x = trace_plane_normal_y;
	newdir_y = 0 - trace_plane_normal_x;
	newdir_z = 0;
	
	if (dir * newdir > 0)
	{
		dir_x = 0 - trace_plane_normal_y;
		dir_y = trace_plane_normal_x;
	}
	else
	{
		dir_x = trace_plane_normal_y;
		dir_y = 0 - trace_plane_normal_x;
	}

	dir_z = 0;
	self.ideal_yaw = vectoyaw(dir);	
};

#endif

/*
============
FacingIdeal

============
*/
float() FacingIdeal =
{
//	local	float	delta;

	self.f__ = anglemod(self.angles_y - self.ideal_yaw);
	if (self.f__ > 45 && self.f__ < 315)
		return FALSE;
	return TRUE;
};


//=============================================================================

float()	WizardCheckAttack;
//float()	DogCheckAttack;

float() CheckAnyAttack =
{
	if (!enemy_vis)
		return FALSE;

// qc++ check attack code boiled down to multi* & demon*

	if (self.classname == "monster_army" || self.classname == "monster_ogre" || self.classname == "monster_shambler")
		return MultiCheckAttack();
	if (self.classname == "monster_demon1" || self.classname == "monster_dog")
		return DemonCheckAttack();
	if (self.classname == "monster_wizard")
		return WizardCheckAttack();
	return CheckAttack();
};


/*
=============
ai_run_melee

Turn and close until within an angle to launch a melee attack
=============
*/
//void() ai_run_melee =
void(void() call) ai_run_mix =
{
	self.ideal_yaw = enemy_yaw;
	ChangeYaw ();

	if (FacingIdeal())
	{
//		self.th_melee();
		call();
		self.attack_state = AS_STRAIGHT;
	}
};


/*
=============
ai_run_missile

Turn in place until within an angle to launch a missile attack
=============
*
void() ai_run_missile =
{
	self.ideal_yaw = enemy_yaw;
	ChangeYaw ();
	if (FacingIdeal())
	{
		self.th_missile();
		self.attack_state = AS_STRAIGHT;
	}
};
*/

/*
=============
ai_run_slide

Strafe sideways, but stay at aproximately the same range
=============
*/
void() ai_run_slide =
{
//	local float	ofs;
	
	self.ideal_yaw = enemy_yaw;
	ChangeYaw ();
	if (self.lefty)
		self.f__ = 90;
	else
		self.f__ = -90;
	
	if (walkmove (self.ideal_yaw + self.f__, movedist))
		return;
		
	self.lefty = 1 - self.lefty;
	
	walkmove (self.ideal_yaw - self.f__, movedist);
};


/*
=============
ai_run

The monster has an enemy it is trying to kill
=============
*/
void(float dist) ai_run =
{
//	local	vector	delta;	// fx_warning
//	local	float	axis;	// fx_warning
//	local	float	direct, ang_rint, ang_floor, ang_ceil;	// fx_warning

	movedist = dist;

// see if the enemy is dead
	if (self.enemy.health <= 0)
	{
		self.enemy = world;
	// FIXME: look all around for other targets
		if (self.oldenemy.health > 0)
		{
			self.enemy = self.oldenemy;
			HuntTarget ();
		}
		else
		{
			if (self.movetarget)
				self.th_walk ();
			else
				self.th_stand ();
			return;
		}
	}

	self.show_hostile = time + 1;		// wake up other monsters

// check knowledge of enemy
	enemy_vis = visible(self.enemy);
	if (enemy_vis)
		self.search_time = time + 5;

// look for other coop players
	if (coop && self.search_time < time)
	{
		if (FindTarget ())
			return;
	}

	enemy_infront = infront(self.enemy);
	enemy_range = range(self.enemy);
	enemy_yaw = vectoyaw(self.enemy.origin - self.origin);
	
	if (self.attack_state == AS_MISSILE)
	{
//dprint ("ai_run_missile\n");
//		ai_run_missile();
		ai_run_mix(self.th_missile);
		return;
	}
	if (self.attack_state == AS_MELEE)
	{
//dprint ("ai_run_melee\n");
//		ai_run_melee();
		ai_run_mix(self.th_melee);
		return;
	}

	if (CheckAnyAttack ())
		return;					// beginning an attack
		
	if (self.attack_state == AS_SLIDING)
	{
		ai_run_slide ();
		return;
	}

// head straight in
	movetogoal (dist);		// done in C code...
};


/*
=============
ai_rep

handle repetitve calls from framer

adds 11 global vars, but way simplifies the recode replacement of the old frame macro

d* = -6 is the nop control
=============
*/
void(float frm, void(float d) ai_call, float d1, float d2, float d3, float d4, float d5, float d6, float d7, float d8) ai_rep =
{
	if (self.frame < frm || self.frame > frm + 7) return;
	if((d1 != -6) && self.frame == frm) ai_call(d1);
	else if((d5 != -6) && self.frame == frm + 4) ai_call(d5);
	else if((d2 != -6) && self.frame == frm + 1) ai_call(d2);
	else if((d6 != -6) && self.frame == frm + 5) ai_call(d6);
	else if((d3 != -6) && self.frame == frm + 2) ai_call(d3);
	else if((d7 != -6) && self.frame == frm + 6) ai_call(d7);
	else if((d4 != -6) && self.frame == frm + 3) ai_call(d4);
	else if((d8 != -6) && self.frame == frm + 7) ai_call(d8);
};

