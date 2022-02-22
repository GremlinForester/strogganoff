.float nextfootstep;

float CheckFootStep () =
{
	if (self.deadflag)
		return FALSE;
	if (!(self.flags & FL_ONGROUND))
		return FALSE;
	if (self.flags & FL_DUCKED)
		return FALSE;
	if (vlen(self.velocity) < 100)
		return FALSE;
	if (self.movetype == MOVETYPE_NOCLIP || self.movetype == MOVETYPE_FLY)
		return FALSE;
  	if (self.waterlevel >= 3)
	{
		return FALSE;
	}
	
	return TRUE;
}

void play_step_sound () =
{
	local float r;

	r = random() * 4;
	
	if (trace_dphitq3surfaceflags & Q3SURFACEFLAG_NOSTEPS)
	{
		return;
	}
	else if (self.waterlevel == 1) //Foot Splashes
	{
		if (r < 1) {sound(self, CHAN_FOOT, "player/splash1.wav", 0.25, ATTN_IDLE);
						pointparticles(particleeffectnum("TE_GLASS_SHATTER"), (self.origin + '0 8 -8'), '0 32 0', 1);}
		else if (r < 2) {sound(self, CHAN_FOOT, "player/splash2.wav", 0.25, ATTN_IDLE);
						pointparticles(particleeffectnum("TE_GLASS_SHATTER"), (self.origin + '0 -8 -8'), '0 32 0', 1);}
		else if (r < 3) {sound(self, CHAN_FOOT, "player/splash3.wav", 0.25, ATTN_IDLE);
						pointparticles(particleeffectnum("TE_GLASS_SHATTER"), (self.origin + '0 8 -8'), '0 32 0', 1);}
		else            {sound(self, CHAN_FOOT, "player/splash4.wav", 0.25, ATTN_IDLE);
						pointparticles(particleeffectnum("TE_GLASS_SHATTER"), (self.origin + '0 -8 -8'), '0 32 0', 1);}
	}
	else if (self.waterlevel == 2) //Water Wade
	{
		if (r < 1) sound(self, CHAN_FOOT, "player/wade1.wav", 0.25, ATTN_IDLE);
		else if (r < 2) sound(self, CHAN_FOOT, "player/wade2.wav", 0.25, ATTN_IDLE);
		else if (r < 3) sound(self, CHAN_FOOT, "player/wade3.wav", 0.25, ATTN_IDLE);
		else            sound(self, CHAN_FOOT, "player/wade2.wav", 0.25, ATTN_IDLE);
	}
	else if (trace_dphitq3surfaceflags & Q3SURFACEFLAG_METALSTEPS)
	{
		if (r < 1) sound(self, CHAN_FOOT, "player/clank1.wav", 0.25, ATTN_IDLE);
		else if (r < 2) sound(self, CHAN_FOOT, "player/clank2.wav", 0.25, ATTN_IDLE);
		else if (r < 3) sound(self, CHAN_FOOT, "player/clank3.wav", 0.25, ATTN_IDLE);
		else sound(self, CHAN_FOOT, "player/clank4.wav", 0.25, ATTN_IDLE);
	}
	else if (trace_dphitq3surfaceflags & Q3SURFACEFLAG_WOOD)
	{
		if (r < 1) sound(self, CHAN_FOOT, "player/wood1.wav", 0.25, ATTN_IDLE);
		else if (r < 2) sound(self, CHAN_FOOT, "player/wood2.wav", 0.25, ATTN_IDLE);
		else if (r < 3) sound(self, CHAN_FOOT, "player/wood3.wav", 0.25, ATTN_IDLE);
		else            sound(self, CHAN_FOOT, "player/wood4.wav", 0.25, ATTN_IDLE);
	}
	else if (trace_dphitq3surfaceflags & Q3SURFACEFLAG_FLESH)
	{
		if (r < 1) sound(self, CHAN_FOOT, "player/footsteps/pl_slosh1.wav", 0.25, ATTN_IDLE);
		else if (r < 2) sound(self, CHAN_FOOT, "player/footsteps/pl_slosh2.wav", 0.25, ATTN_IDLE);
		else if (r < 3) sound(self, CHAN_FOOT, "player/footsteps/pl_slosh3.wav", 0.25, ATTN_IDLE);
		else            sound(self, CHAN_FOOT, "player/footsteps/pl_slosh4.wav", 0.25, ATTN_IDLE);
	}
	else if (trace_dphitq3surfaceflags & Q3SURFACEFLAG_GLASS)
	{
		if (r < 1) sound(self, CHAN_FOOT, "player/footsteps/pl_ladder1.wav", 0.25, ATTN_IDLE);
		else if (r < 2) sound(self, CHAN_FOOT, "player/footsteps/pl_ladder2.wav", 0.25, ATTN_IDLE);
		else if (r < 3) sound(self, CHAN_FOOT, "player/footsteps/pl_ladder3.wav", 0.25, ATTN_IDLE);
		else            sound(self, CHAN_FOOT, "player/footsteps/pl_ladder4.wav", 0.25, ATTN_IDLE);
	}
	else if (trace_dphitq3surfaceflags & Q3SURFACEFLAG_DIRT)
	{
		if (r < 1) sound(self, CHAN_FOOT, "player/footsteps/pl_dirt1.wav", 0.25, ATTN_IDLE);
		else if (r < 2) sound(self, CHAN_FOOT, "player/footsteps/pl_dirt2.wav", 0.25, ATTN_IDLE);
		else if (r < 3) sound(self, CHAN_FOOT, "player/footsteps/pl_dirt3.wav", 0.25, ATTN_IDLE);
		else            sound(self, CHAN_FOOT, "player/footsteps/pl_dirt4.wav", 0.25, ATTN_IDLE);
	}
	else if (trace_dphitq3surfaceflags & Q3SURFACEFLAG_FORCEFIELD)
	{
		if (r < 1) sound(self, CHAN_FOOT, "player/energy1.wav", 0.25, ATTN_IDLE);
		else if (r < 2) sound(self, CHAN_FOOT, "player/energy2.wav", 0.25, ATTN_IDLE);
		else if (r < 3) sound(self, CHAN_FOOT, "player/energy3.wav", 0.25, ATTN_IDLE);
		else            sound(self, CHAN_FOOT, "player/energy4.wav", 0.25, ATTN_IDLE);
	}
	else if (trace_dphitq3surfaceflags & Q3SURFACEFLAG_GRASS)
	{
		if (r < 1) sound(self, CHAN_FOOT, "player/footsteps/pl_snow1.wav", 0.25, ATTN_IDLE);
		else if (r < 2) sound(self, CHAN_FOOT, "player/footsteps/pl_snow2.wav", 0.25, ATTN_IDLE);
		else if (r < 3) sound(self, CHAN_FOOT, "player/footsteps/pl_snow3.wav", 0.25, ATTN_IDLE);
		else            sound(self, CHAN_FOOT, "player/footsteps/pl_snow4.wav", 0.25, ATTN_IDLE);
	}
	else if (trace_dphitq3surfaceflags & Q3SURFACEFLAG_TILE)
	{
		if (r < 1) sound(self, CHAN_FOOT, "player/footsteps/pl_tile1.wav", 1, ATTN_IDLE);
		else if (r < 2) sound(self, CHAN_FOOT, "player/footsteps/pl_tile2.wav", 1, ATTN_IDLE);
		else if (r < 3) sound(self, CHAN_FOOT, "player/footsteps/pl_tile3.wav", 1, ATTN_IDLE);
		else            sound(self, CHAN_FOOT, "player/footsteps/pl_tile4.wav", 1, ATTN_IDLE);
	}
	else
	{
		if (r < 1)	
		{
			sound(self, CHAN_FOOT, "player/foot1.wav", 0.35, ATTN_IDLE);
		}
		else if (r < 2)
		{
			sound(self, CHAN_FOOT, "player/foot2.wav", 0.35, ATTN_IDLE);
		}
		else if (r < 3)
		{
			sound(self, CHAN_FOOT, "player/foot3.wav", 0.35, ATTN_IDLE);
		}
		else
		{
			sound(self, CHAN_FOOT, "player/foot4.wav", 0.35, ATTN_IDLE);
		}
	}
}

void() Q3Surface_FootStep =
{

	if (time < self.nextfootstep)
	return;

	if (!CheckFootStep())
	{
		return;
	}

	if (vlen(self.velocity) < 200)
		self.nextfootstep = time + 0.35 + random() * 0.1;
	else
		self.nextfootstep = time + 0.25 + random() * 0.1;

	traceline(self.origin, self.origin - '0 0 32', MOVE_NORMAL, self);

	play_step_sound();
};

void() Generic_FootStep =
{
  	if (self.waterlevel >= 3)
	{
		return;
	}

	traceline(self.origin, self.origin - '0 0 32', MOVE_NORMAL, self);

	play_step_sound();
};

void(entity e) Q3Surface_Impact_Ent =
{
	local float r;

	if (trace_dpstartcontents & DPCONTENTS_WATER)
	{
	//	bprint("WATER HIT");
		r = random() * 4;
		if (r < 1) sound(e, CHAN_BODY, "player/splash1.wav", 1, ATTN_IDLE);
		else if (r < 2) sound(e, CHAN_BODY, "player/splash2.wav", 1, ATTN_IDLE);
		else if (r < 3) sound(e, CHAN_BODY, "player/splash3.wav", 1, ATTN_IDLE);
		else
		{
			sound(e, CHAN_BODY, "player/splash4.wav", 1, ATTN_IDLE);
			pointparticles(particleeffectnum("TE_GLASS_SHATTER"), (e.origin + '0 0 4'), '0 0 0', 1);
		}
	}
	
	if (trace_dphitq3surfaceflags & Q3SURFACEFLAG_NOIMPACT) // || Q3SURFACEFLAG_NOMARKS)
	{
		return;
	}
	else if (trace_dphitq3surfaceflags & Q3SURFACEFLAG_FLESH)
	{
		r = random() * 4;
		if (r < 1) sound(e, CHAN_BODY, "player/footsteps/pl_slosh1.wav", 1, ATTN_IDLE);
		else if (r < 2) sound(e, CHAN_BODY, "player/footsteps/pl_slosh2.wav", 1, ATTN_IDLE);
		else if (r < 3) sound(e, CHAN_BODY, "player/footsteps/pl_slosh3.wav", 1, ATTN_IDLE);
		else            sound(e, CHAN_BODY, "player/footsteps/pl_slosh4.wav", 1, ATTN_IDLE);
		pointparticles(particleeffectnum("TE_BLOOD"), e.origin, '0 0 0', 1);
	}
	else if (trace_dphitq3surfaceflags & Q3SURFACEFLAG_METALSTEPS)
	{
		r = random() * 8;
		if (r < 1) sound(e, CHAN_BODY, "world/ric1.wav", 1, ATTN_IDLE);
		else if (r < 2) sound(e, CHAN_BODY, "player/clank1.wav", 1, ATTN_IDLE);
		else if (r < 3) sound(e, CHAN_BODY, "player/clank2.wav", 1, ATTN_IDLE);
		else if (r < 4) sound(e, CHAN_BODY, "world/ric2.wav", 1, ATTN_IDLE);
		else if (r < 5) sound(e, CHAN_BODY, "player/clank3.wav", 1, ATTN_IDLE);
		else if (r < 6) sound(e, CHAN_BODY, "player/clank4.wav", 1, ATTN_IDLE);
		else if (r < 7) sound(e, CHAN_BODY, "world/ric3.wav", 1, ATTN_IDLE);
		else            sound(e, CHAN_BODY, "player/clank1.wav", 1, ATTN_IDLE);
		pointparticles(particleeffectnum("TE_GUNSHOT"), e.origin, '0 0 0', 1);
	}
	else if (trace_dphitq3surfaceflags & Q3SURFACEFLAG_WOOD)
	{
		r = random() * 4;
		if (r < 1) sound(e, CHAN_BODY, "player/wood1.wav", 1, ATTN_IDLE);
		else if (r < 2) sound(e, CHAN_BODY, "player/wood2.wav", 1, ATTN_IDLE);
		else if (r < 3) sound(e, CHAN_BODY, "player/wood3.wav", 1, ATTN_IDLE);
		else            sound(e, CHAN_BODY, "player/wood4.wav", 1, ATTN_IDLE);
		pointparticles(particleeffectnum("TE_WOODIMPACT"), e.origin, '0 0 0', 1);
	}
	else if (trace_dphitq3surfaceflags & Q3SURFACEFLAG_TILE)
	{
		r = random() * 4;
		if (r < 1) sound(e, CHAN_BODY, "player/footsteps/pl_tile1.wav", 1, ATTN_IDLE);
		else if (r < 2) sound(e, CHAN_BODY, "player/footsteps/pl_tile2.wav", 1, ATTN_IDLE);
		else if (r < 3) sound(e, CHAN_BODY, "player/footsteps/pl_tile3.wav", 1, ATTN_IDLE);
		else            sound(e, CHAN_BODY, "player/footsteps/pl_tile4.wav", 1, ATTN_IDLE);
		pointparticles(particleeffectnum("TE_WOODIMPACT"), e.origin, '0 0 0', 1);
	}
	else if (trace_dphitq3surfaceflags & Q3SURFACEFLAG_GLASS)
	{
		if (r < 1) sound(e, CHAN_BODY, "player/footsteps/pl_ladder1.wav", 0.25, ATTN_IDLE);
		else if (r < 2) sound(e, CHAN_BODY, "player/footsteps/pl_ladder2.wav", 0.25, ATTN_IDLE);
		else if (r < 3) sound(e, CHAN_BODY, "player/footsteps/pl_ladder3.wav", 0.25, ATTN_IDLE);
		else            sound(e, CHAN_BODY, "player/footsteps/pl_ladder4.wav", 0.25, ATTN_IDLE);
		pointparticles(particleeffectnum("TE_GUNSHOT"), e.origin, '0 0 0', 1);
	}
	else if (trace_dphitq3surfaceflags & Q3SURFACEFLAG_DIRT)
	{
		if (r < 1) sound(e, CHAN_FOOT, "player/footsteps/pl_dirt1.wav", 0.25, ATTN_IDLE);
		else if (r < 2) sound(e, CHAN_FOOT, "player/footsteps/pl_dirt2.wav", 0.25, ATTN_IDLE);
		else if (r < 3) sound(e, CHAN_FOOT, "player/footsteps/pl_dirt3.wav", 0.25, ATTN_IDLE);
		else            sound(e, CHAN_FOOT, "player/footsteps/pl_dirt4.wav", 0.25, ATTN_IDLE);
		pointparticles(particleeffectnum("TE_WOODIMPACT"), e.origin, '0 0 0', 1);		
	}
	else if (trace_dphitq3surfaceflags & Q3SURFACEFLAG_FORCEFIELD)
	{
		if (r < 1) sound(e, CHAN_FOOT, "player/energy1.wav", 0.25, ATTN_IDLE);
		else if (r < 2) sound(e, CHAN_FOOT, "player/energy2.wav", 0.25, ATTN_IDLE);
		else if (r < 3) sound(e, CHAN_FOOT, "player/energy3.wav", 0.25, ATTN_IDLE);
		else            sound(e, CHAN_FOOT, "player/energy4.wav", 0.25, ATTN_IDLE);
	}
	else if (trace_dphitq3surfaceflags & Q3SURFACEFLAG_GRASS)
	{
		if (r < 1) sound(e, CHAN_FOOT, "player/footsteps/pl_snow1.wav", 0.25, ATTN_IDLE);
		else if (r < 2) sound(e, CHAN_FOOT, "player/footsteps/pl_snow2.wav", 0.25, ATTN_IDLE);
		else if (r < 3) sound(e, CHAN_FOOT, "player/footsteps/pl_snow3.wav", 0.25, ATTN_IDLE);
		else            sound(e, CHAN_FOOT, "player/footsteps/pl_snow4.wav", 0.25, ATTN_IDLE);
		pointparticles(particleeffectnum("TE_WOODIMPACT"), e.origin, '0 0 0', 1);		
	}
	else //DEFAULT TO CONCRETE?
	{
		r = random() * 2;
		if (r < 1) 		sound(e, CHAN_BODY, "world/ric1.wav", 1, ATTN_IDLE);
		else if (r < 2) sound(e, CHAN_BODY, "world/ric2.wav", 1, ATTN_IDLE);
		else 			sound(e, CHAN_BODY, "world/ric3.wav", 1, ATTN_IDLE);
		
/* 		r = random() * 4;
		if (r < 1) sound(e, CHAN_BODY, "player/foot1.wav", 1, ATTN_IDLE);
		else if (r < 2) sound(e, CHAN_BODY, "player/foot2.wav", 1, ATTN_IDLE);
		else if (r < 3) sound(e, CHAN_BODY, "player/foot3.wav", 1, ATTN_IDLE);
		else            sound(e, CHAN_BODY, "player/foot4.wav", 1, ATTN_IDLE);*/
		pointparticles(particleeffectnum("TE_GUNSHOT"), e.origin, '0 0 0', 1);
	}
};

void(vector org) Q3Surface_Impact = //q3surface_hit =
{
	local float r;

	if (trace_dphitq3surfaceflags & Q3SURFACEFLAG_NOSTEPS)
	{
		return;
	}
	else if (trace_dphitq3surfaceflags & Q3SURFACEFLAG_METALSTEPS)
	{
		r = random() * 4;
		if (r < 1) sound(self, CHAN_WEAPON2, "player/clank1.wav", 1, ATTN_IDLE);
		else if (r < 2) sound(self, CHAN_WEAPON2, "player/clank2.wav", 1, ATTN_IDLE);
		else if (r < 3) sound(self, CHAN_WEAPON2, "player/clank3.wav", 1, ATTN_IDLE);
		else            sound(self, CHAN_WEAPON2, "player/clank4.wav", 1, ATTN_IDLE);
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_GUNSHOT);
		WriteCoord (MSG_BROADCAST, org_x);
		WriteCoord (MSG_BROADCAST, org_y);
		WriteCoord (MSG_BROADCAST, org_z);
	}
	else if (trace_dphitq3surfaceflags & Q3SURFACEFLAG_WOOD)
	{
		r = random() * 4;
		if (r < 1) sound(self, CHAN_WEAPON2, "player/wood1.wav", 1, ATTN_IDLE);
		else if (r < 2) sound(self, CHAN_WEAPON2, "player/wood2.wav", 1, ATTN_IDLE);
		else if (r < 3) sound(self, CHAN_WEAPON2, "player/wood3.wav", 1, ATTN_IDLE);
		else            sound(self, CHAN_WEAPON2, "player/wood4.wav", 1, ATTN_IDLE);
		pointparticles(particleeffectnum("TE_WOODIMPACT"), org, '0 0 0', 1);
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_GUNSHOT);
		WriteCoord (MSG_BROADCAST, org_x);
		WriteCoord (MSG_BROADCAST, org_y);
		WriteCoord (MSG_BROADCAST, org_z);
		return;
	}
	else
	{	// hit wall
		sound (self, CHAN_WEAPON, "player/axhit2.wav", 1, ATTN_NORM);
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_GUNSHOT);
		WriteCoord (MSG_BROADCAST, org_x);
		WriteCoord (MSG_BROADCAST, org_y);
		WriteCoord (MSG_BROADCAST, org_z);
	}
};
