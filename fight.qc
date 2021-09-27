
/*

A monster is in fight mode if it thinks it can effectively attack its
enemy.

When it decides it can't attack, it goes into hunt mode.

*/

float(float v) anglemod;

void() knight_atk1;
void() knight_runatk1;
void() ogre_smash1;
void() ogre_swing1;

void() sham_smash1;
void() sham_swingr1;
void() sham_swingl1;

float()	DemonCheckAttack;
void(float side)	Demon_Melee;

#ifdef unused
void(vector dest) ChooseTurn;
#endif

void() ai_face;


float	enemy_vis, enemy_infront, enemy_range;
float	enemy_yaw;


void() knight_attack =
{
//	local float		len;
	
// decide if now is a good swing time
	self.f__ = vlen(self.enemy.origin+self.enemy.view_ofs - (self.origin+self.view_ofs));
	
	if (self.f__ <80)
		knight_atk1 ();
	else
		knight_runatk1 ();
};

//=============================================================================

/*
===========
CheckAttack

The player is in view, so decide to move or launch an attack
Returns FALSE if movement should continue
============
*/
float() CheckAttack =
{
//	local vector	spot1, spot2;	
//	local entity	targ;
//	local float		chance;

//	targ = self.enemy;
	
// see if any entities are in the way of the shot
//	spot1 = self.origin + self.view_ofs;
//	spot2 = targ.origin + targ.view_ofs;

	traceline ((self.origin + self.view_ofs), (self.enemy.origin + self.enemy.view_ofs), FALSE, self);

	if (trace_ent != self.enemy)
		return FALSE;		// don't have a clear shot
			
	if (trace_inopen && trace_inwater)
		return FALSE;			// sight line crossed contents

	if (enemy_range == RANGE_MELEE)
	{	// melee attack
		if (self.th_melee)
		{
			if (self.classname == "monster_knight")
				knight_attack ();
			else
				self.th_melee ();
			return TRUE;
		}
	}
	
// missile attack
	if (!self.th_missile)
		return FALSE;
		
	if (time < self.attack_finished)
		return FALSE;
		
	if (enemy_range == RANGE_FAR)
		return FALSE;
		
	if (enemy_range == RANGE_MELEE)
	{
		self.rnd_ = 0.9;
		self.attack_finished = 0;
	}
	else if (enemy_range == RANGE_NEAR)
	{
		if (self.th_melee)
			self.rnd_ = 0.2;
		else
			self.rnd_ = 0.4;
	}
	else if (enemy_range == RANGE_MID)
	{
		if (self.th_melee)
			self.rnd_ = 0.05;
		else
			self.rnd_ = 0.1;
	}
	else
		self.rnd_ = 0;

	if (random () < self.rnd_)
	{
		self.th_missile ();
		SUB_AttackFinished (2*random());
		return TRUE;
	}

#ifdef pointless_warning
	return FALSE;
#endif
};


/*
=============
ai_face

Stay facing the enemy
=============
*/
void() ai_face =
{
	self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
	ChangeYaw();
};

/*
=============
ai_charge

The monster is in a melee attack, so get as close as possible to .enemy
=============
*/
float (entity targ) visible;
float(entity targ) infront;
float(entity targ) range;

void(float d) ai_charge =
{
	ai_face ();	
	movetogoal (d);		// done in C code...
};

// note: *_side only called by knight so far

void() ai_charge_side =
{
#define heading	self.f__
//	local	vector	dtemp;
//	local	float	heading;
	
// aim to the left of the enemy for a flyby

//	self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
//	ChangeYaw ();
	ai_face(); // same code

	makevectors (self.angles);
//	dtemp = self.enemy.origin - 30*v_right;
//	heading = vectoyaw(dtemp - self.origin);
	heading = vectoyaw((self.enemy.origin - 30*v_right) - self.origin);
	
	walkmove(heading, 20);

#undef heading
};


/*
=============
ai_melee

=============
*/
void() ai_melee =
{
//	local vector	delta;
//	local float 	ldmg;

	if (!self.enemy)
		return;		// removed before stroke
		
//	delta = self.enemy.origin - self.origin;

	if (vlen(self.enemy.origin - self.origin) > 60)
		return;
		
	self.ldmg_ = (random() + random() + random()) * 3;
	T_Damage (self.enemy, self, self, self.ldmg_);
};


void() ai_melee_side =
{
//	local vector	delta;
//	local float 	ldmg;

	if (!self.enemy)
		return;		// removed before stroke
		
	ai_charge_side();
	
//	delta = self.enemy.origin - self.origin;

//	if (vlen(self.enemy.origin - self.origin) > 60)
//		return;
	if (!CanDamage (self.enemy, self))
		return;
//	self.ldmg_ = (random() + random() + random()) * 3;
//	T_Damage (self.enemy, self, self, self.ldmg_);
	ai_melee();
};


//=============================================================================

/*
===========
SoldierCheckAttack

The player is in view, so decide to move or launch an attack
Returns FALSE if movement should continue
============
*
float() SoldierCheckAttack =
{
// fteqcc allows us to remove these
//	local vector	spot1, spot2;	
//	local entity	targ;
//	local float		chance;

//	targ = self.enemy;
	
// see if any entities are in the way of the shot
//	spot1 = self.origin + self.view_ofs;
//	spot2 = targ.origin + targ.view_ofs;

//	traceline (spot1, spot2, FALSE, self);
	traceline ((self.origin + self.view_ofs), (self.enemy.origin + self.enemy.view_ofs), FALSE, self);

	if (trace_inopen && trace_inwater)
		return FALSE;			// sight line crossed contents

	if (trace_ent != self.enemy)
		return FALSE;	// don't have a clear shot
			
	
// missile attack
	if (time < self.attack_finished)
		return FALSE;
		
	if (enemy_range == RANGE_FAR)
		return FALSE;
		
	if (enemy_range == RANGE_MELEE)
		self.rnd_ = 0.9;
	else if (enemy_range == RANGE_NEAR)
		self.rnd_ = 0.4;
	else if (enemy_range == RANGE_MID)
		self.rnd_ = 0.05;
	else
		self.rnd_ = 0;

	if (random () < self.rnd_)
	{
		self.th_missile ();
		SUB_AttackFinished (1 + random());
		if (random() < 0.3)
			self.lefty = !self.lefty;

		return TRUE;
	}

	return FALSE;
};
*/
//=============================================================================

/*
===========
MultiCheckAttack

replaces ShamCheckAttack & OgreCheckAttack & SoldierCheckAttack

The player is in view, so decide to move or launch an attack
Returns FALSE if movement should continue
============
*/
//float() ShamCheckAttack =
float() MultiCheckAttack =
{
//	local vector	spot1, spot2;
//	local entity	targ;
//	local float		chance;	// fx_warning
//	local float		enemy_yaw;

	if (self.classname != "monster_army")
	{
		if (enemy_range == RANGE_MELEE)
		{
			if (CanDamage (self.enemy, self))
			{
				self.attack_state = AS_MELEE;
				return TRUE;
			}
		}
		
		if (!enemy_vis)
			return FALSE;
	}

	if (time < self.attack_finished)
		return FALSE;

	if (enemy_range == RANGE_FAR)
		return FALSE;

//	targ = self.enemy;
	
// see if any entities are in the way of the shot
// .dest1, .dest2
	self.spot1_ = self.origin + self.view_ofs;
	self.spot2_ = self.enemy.origin + self.enemy.view_ofs;

	traceline (self.spot1_, self.spot2_, FALSE, self);

	if (trace_inopen && trace_inwater)
		return FALSE;			// sight line crossed contents

	if (trace_ent != self.enemy)
		return FALSE;	// don't have a clear shot

	if (self.classname == "monster_shambler")
	{
		if (vlen(self.spot1_ - self.spot2_) > 600)
			return FALSE;
		self.f__ = 2;
	}
	else if (self.classname == "monster_army")
	{
		self.rnd_ = 0;
		if (enemy_range == RANGE_MELEE)
			self.rnd_ = 0.9;
		else if (enemy_range == RANGE_NEAR)
			self.rnd_ = 0.4;
		else if (enemy_range == RANGE_MID)
			self.rnd_ = 0.05;
		if (random () >= self.rnd_)
			return FALSE;

		self.th_missile ();
		SUB_AttackFinished (1 + random());
		return TRUE;
	}
	else
	{
		self.f__ = 1;
	}

// missile attack
	self.attack_state = AS_MISSILE;
	SUB_AttackFinished (self.f__ + 2 * random());
	return TRUE;
};

//============================================================================

/*
===========
OgreCheckAttack

The player is in view, so decide to move or launch an attack
Returns FALSE if movement should continue
============

float() OgreCheckAttack =
{
//	local vector	spot1, spot2;	
//	local entity	targ;
//	local float		chance;

	if (enemy_range == RANGE_MELEE)
	{
		if (CanDamage (self.enemy, self))
		{
			self.attack_state = AS_MELEE;
			return TRUE;
		}
	}

	if (time < self.attack_finished)
		return FALSE;
	
	if (!enemy_vis)
		return FALSE;
		
//	targ = self.enemy;
	
// see if any entities are in the way of the shot
//	spot1 = self.origin + self.view_ofs;
//	spot2 = targ.origin + targ.view_ofs;

	traceline ((self.origin + self.view_ofs), (self.enemy.origin + self.enemy.view_ofs), FALSE, self);

	if (trace_inopen && trace_inwater)
		return FALSE;			// sight line crossed contents

	if (trace_ent != self.enemy)
	{
		return FALSE;	// don't have a clear shot
	}
			
// missile attack
	if (time < self.attack_finished)
		return FALSE;
		
	if (enemy_range == RANGE_FAR)
		return FALSE;
/*

this code does nada
self.rnd_ (chance) is never used

	else if (enemy_range == RANGE_NEAR)
		self.rnd_ = 0.10;
	else if (enemy_range == RANGE_MID)
		self.rnd_ = 0.05;
	else
		self.rnd_ = 0;
*
	self.attack_state = AS_MISSILE;
	SUB_AttackFinished (1 + 2*random());
	return TRUE;
};

*/