#define PUSH_ONCE 1

.entity push_target;

//Also filed under TBD WIP WTF LOL... 
//Goal, copy Q3. Result: I'm balder now and took up chain smoking.

/*
void() trigger_push_touch =
{
	if (other.classname == "grenade")
		other.velocity = self.speed * self.movedir * 10;
	else if (other.health > 0)
	{
		other.velocity = self.speed * self.movedir * 10;
		if (other.classname == "player")
		{
			if (other.fly_sound < time)
			{
				other.fly_sound = time + 1.5;
				sound (other, CHAN_AUTO, "ambience/windfly.wav", 1, ATTN_NORM);
			}
		}
	}
	if (self.spawnflags & PUSH_ONCE)
		remove(self);
};
*/

//TODO: moving jumppad targets

void() triggerpush_think =
{
	local vector dir;
	local vector org;	

	if (self.target){
		self.push_target = find (world, targetname, self.target);
	}

	/*
	nep_traceline (bmodelOriginEntity(self), self.push_target.origin, FALSE, self);
	trailparticles(self, particleeffectnum("TR_KNIGHTSPIKE"), bmodelOriginEntity(self), trace_endpos);

	VLOG(self.push_target.origin);
	*/
	
	self.nextthink = time + 1;
	self.think = triggerpush_think;
}

/* This one works ""best"" so far...
void() trigger_push_touch =
{
	local entity ent;
	local float height, gravity, time, forward;
	local float dist;
	
	height = self.push_target.origin - other.origin_z;
	gravity = cvar("sv_gravity");
	time = sqrt( height / ( .5 * gravity ) );

	// set the push velocity
	dist = normalize( other.origin);
	forward = dist / time;
	
	if (other.classname != "player")
		return;
	
	if (other.movetype == MOVETYPE_NOCLIP || other.movetype == MOVETYPE_FLY)
		return;
	
	triggerTouched(1);
	
	if (self.target)
	{
		other.velocity = normalize(self.push_target.origin - other.origin);
		other.velocity = other.velocity * (time * gravity);
		other.velocity_z = time * gravity;		
			
			if (self.spawnflags & PUSH_ONCE)
			remove(self);
		
		return;
	}
	
	if (other.classname == "grenade")
		other.velocity = self.speed * self.movedir * 10;
	else if (other.health > 0)
	{
		other.velocity = self.speed * self.movedir * 10;
		if (other.classname == "player")
		{
			if (other.fly_sound < time)
			{
				other.fly_sound = time + 1.5;
				sound (other, CHAN_AUTO, "ambience/windfly.wav", 1, ATTN_NORM);
			}
		}
	}
};
*/

void() trigger_push_touch =
{
	local entity ent;
	local float height, gravity, time, forward;
	local float dist;
	
	height = self.push_target.origin - other.origin_z;
	gravity = cvar("sv_gravity");
	time = sqrt( height / ( .5 * gravity ) );

	// set the push velocity
	dist = normalize(self.push_target.origin - other.origin);
	forward = dist / time;
	
	if (other.classname != "player")
		return;
	
	if (other.movetype == MOVETYPE_NOCLIP || other.movetype == MOVETYPE_FLY)
		return;
	
	triggerTouched(1);
	
	if (self.target)
	{
		setorigin(other, (bmodelOriginEntity(self)));
		setorigin(other, other.origin + '0 0 10');
		
		/*
		other.velocity = normalize(self.push_target.origin - other.origin);
		other.velocity = other.velocity * (time * gravity);
		other.velocity_z = vlen(self.push_target.origin - other.origin) + (time * gravity);		
		*/
		
		other.velocity = normalize(self.push_target.origin - other.origin);
		other.velocity = other.velocity * (time * gravity);
		other.velocity_z = time * gravity;	
		
			if (self.spawnflags & PUSH_ONCE)
			remove(self);
		
		return;
	}
	
	if (other.classname == "grenade")
		other.velocity = self.speed * self.movedir * 10;
	else if (other.health > 0)
	{
		other.velocity = self.speed * self.movedir * 10;
		if (other.classname == "player")
		{
			if (other.fly_sound < time)
			{
				other.fly_sound = time + 1.5;
				sound (other, CHAN_AUTO, "ambience/windfly.wav", 1, ATTN_NORM);
			}
		}
	}
};

//From Quake 3
/*
void() AimAtTarget( gentity_t *self ) 
{
	gentity	ent;
	vec3_t		origin;
	float		height, gravity, time, forward;
	float		dist;

	VectorAdd( self->r.absmin, self->r.absmax, origin );
	VectorScale ( origin, 0.5, origin );

	ent = G_PickTarget( self->target );
	if ( !ent ) {
		G_FreeEntity( self );
		return;
	}

	height = ent->s.origin[2] - origin[2];
	gravity = g_gravity.value;
	time = sqrt( height / ( .5 * gravity ) );
	if ( !time ) {
		G_FreeEntity( self );
		return;
	}

	// set s.origin2 to the push velocity
	VectorSubtract ( ent->s.origin, origin, self->s.origin2 );
	self->s.origin2[2] = 0;
	dist = VectorNormalize( self->s.origin2);

	forward = dist / time;
	VectorScale( self->s.origin2, forward, self->s.origin2 );

	self->s.origin2[2] = time * gravity;
}
*/

/*QUAKED trigger_push (.5 .5 .5) ? PUSH_ONCE
Pushes the player
*/
void() trigger_push =
{
	InitTrigger ();
	precache_sound ("ambience/windfly.wav");
	self.touch = trigger_push_touch;
	if (!self.speed)
		self.speed = 1000;
	
	//setorigin(self, bmodelOriginEntity(self));
	
	self.nextthink = time + 0.1;
	self.think = triggerpush_think;		
};
