#define	PLAYER_ONLY	1
#define	SILENT 2

void() teleport_touch =
{
local entity	t;
local vector	org;

	if (self.targetname)
	{
		if (self.nextthink < time)
		{
			return;		// not fired yet
		}
	}

	if (self.spawnflags & PLAYER_ONLY)
	{
		if (other.classname != "player")
			return;
	}

// only teleport living creatures
	if (other.health <= 0 || other.solid != SOLID_SLIDEBOX)
		return;

	SUB_UseTargets ();

// put a tfog where the player was
	spawn_tfog (other.origin);

//#ifdef opgrade // note - we cannot block this off
	if (self.target) // fix for no target issue
//#endif

	t = find (world, targetname, self.target);
	if (!t)
#ifdef noobjerr
	{

#ifdef xvars1
		if (cvar("svx_platdoorfail") < 0) // remove option - teleport_touch
		{
			remove(self);
			return;
		}
#endif
// later - randomize dest
		t = find (world, classname, "info_player_deathmatch");
		if (!t) t = find (world, classname, "info_player_start");
		if (!t) return; // total fail

	}
#else
		objerror ("couldn't find target");					//opgrade protected
#endif
		
// spawn a tfog flash in front of the destination
	makevectors (t.mangle);
	org = t.origin + 32 * v_forward;

	spawn_tfog (org);
	spawn_tdeath(t.origin, other);

// move the player and lock him down for a little while
	if (!other.health)
	{
		other.origin = t.origin;
		other.velocity = (v_forward * other.velocity_x) + (v_forward * other.velocity_y);
		return;
	}

	setorigin (other, t.origin);
	other.angles = t.mangle;
	if (other.classname == "player")
	{
		other.fixangle = 1;		// turn this way immediately
		other.teleport_time = time + 0.7;
		if (other.flags & FL_ONGROUND)
			other.flags = other.flags - FL_ONGROUND;
		other.velocity = v_forward * 300;
	}
	other.flags = other.flags - other.flags & FL_ONGROUND;
};

void() teleport_use =
{
	self.nextthink = time + 0.2;
	force_retouch = 2;		// make sure even still objects get hit
	self.think = SUB_Null;
};

/*QUAKED trigger_teleport (.5 .5 .5) ? PLAYER_ONLY SILENT
Any object touching this will be transported to the corresponding info_teleport_destination entity. You must set the "target" field, and create an object with a "targetname" field that matches.

If the trigger_teleport has a targetname, it will only teleport entities when it has been fired.
*/
void() trigger_teleport =
{
	local vector o;

	InitTrigger ();
	self.touch = teleport_touch;
	// find the destination 
	if (!self.target)
#ifdef noobjerr
	{

#ifdef xvars1
		if (cvar("svx_platdoorfail") < 0) // remove option - trigger_teleport
		{
			remove(self);
			return;
		}
#endif
// later - pick random target, but it has to be find-able - may have to make a target
// for now teleport_touch can handle no target
	}
#else
		objerror ("no target");					//opgrade protected
#endif
	self.use = teleport_use;

	if (!(self.spawnflags & SILENT))
	{
		precache_sound ("ambience/hum1.wav");
		o = (self.mins + self.maxs)*0.5;
		ambientsound (o, "ambience/hum1.wav",0.5 , ATTN_STATIC);
	}
};
