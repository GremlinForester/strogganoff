void() train_blocked =
{
	if (time < self.attack_finished)
		return;
	self.attack_finished = time + 0.5;
	T_Damage (other, self, self, self.dmg);
};
void() train_use =
{
	if (self.think != func_train_find)
		return;		// already activated
	train_next();
};

void() train_wait =
{
	if (self.wait)
	{
		self.nextthink = self.ltime + self.wait;
		sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);
	}
	else
		self.nextthink = self.ltime + 0.1;
	
	self.think = train_next;
};

void() train_next =
{
	local entity	targ;

	targ = find (world, targetname, self.target);
	self.target = targ.target;
	if (!self.target)
#ifdef noobjerr
	{

#ifdef xvars1
		if (cvar("svx_platdoorfail") < 0) // remove option
		{
			remove(self);
			return;
		}
		else
#endif
		{
			self.velocity = '0 0 0';
			return;
		}
	}
#else
		objerror ("train_next: no next target");					//opgrade protected
#endif

	if (targ.wait)
		self.wait = targ.wait;
	else
		self.wait = 0;
	sound (self, CHAN_VOICE, self.noise1, 1, ATTN_NORM);
		//sound7(self, CHAN_VOICE, self.noise1, 1, ATTN_IDLE, targ.speed *.5, 0);
	
	if (!targ.speed)
	{
		SUB_CalcMove (targ.origin - self.mins, self.speed, train_wait);
	}
	else
	{
		SUB_CalcMove (targ.origin - self.mins, targ.speed, train_wait);
		sound (self, CHAN_AUTO, self.noise, 1, ATTN_NORM);
	}
//	SUB_CalcMove (targ.origin - ((self.mins + self.maxs) * .5), self.speed, train_wait);
};

void() func_train_find =

{
	local entity	targ;

	targ = find (world, targetname, self.target);
	self.target = targ.target;
	setorigin (self, targ.origin - self.mins);
	if (!self.targetname)
	{	// not triggered, so start immediately
		self.nextthink = self.ltime + 0.1;
		self.think = train_next;
	}
};

/*QUAKED func_train (0 .5 .8) ?
Trains are moving platforms that players can ride.
The targets origin specifies the min point of the train at each corner.
The train spawns at the first target it is pointing at.
If the train is the target of a button or trigger, it will not begin moving until activated.
speed	default 100
dmg		default	2
sounds
1) ratchet metal
*/
void() func_train =
{	
	if (!self.speed)
		self.speed = 100;
	if (!self.dmg)
		self.dmg = 2;

	if (! self.sounds) // == 0)
	{
		self.noise = ("misc/null.wav");
		precache_sound ("misc/null.wav");
		self.noise1 = ("misc/null.wav");
		precache_sound ("misc/null.wav");
	}

	if (self.sounds == 1)
	{
		self.noise = ("world/train2.wav");
		precache_sound ("world/train2.wav");
        self.noise1 = "plats/train1.wav"; //move sound
        precache_sound("plats/train1.wav");
	}

	self.cnt = 1;
	self.solid = SOLID_BSP;
	self.movetype = MOVETYPE_PUSH;
	self.blocked = train_blocked;
	self.use = train_use;
	self.classname = "train";
	setmodel (self, self.model);
	setsize (self, self.mins , self.maxs);
	setorigin (self, self.origin);

// moved because the non-remove option is to leave an inert solid platform
	if (!self.target)
#ifdef noobjerr
	{

#ifdef xvars1
		if (cvar("svx_platdoorfail") < 0) // remove option
		{
			remove(self);
			return;
		}
		else
#endif
		return;
	}
#else
		objerror ("func_train without a target");					//opgrade protected
#endif


// start trains on the second frame, to make sure their targets have had
// a chance to spawn
	self.nextthink = self.ltime + 0.1;
	self.think = func_train_find;
};
