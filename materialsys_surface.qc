.float nextfootstep;

float sfx_ents;
#define MAX_SFXENTS 4

#define SOUND_IMPACT_FLESH1 "world/impacts/flesh1.ogg"
#define SOUND_IMPACT_FLESH2 "world/impacts/flesh2.ogg"
#define SOUND_IMPACT_FLESH3 "world/impacts/flesh3.ogg"
#define SOUND_IMPACT_FLESH4 "world/impacts/flesh4.ogg"

#define SOUND_IMPACT_WOOD1 "world/impacts/wood1.ogg"
#define SOUND_IMPACT_WOOD2 "world/impacts/wood2.ogg"
#define SOUND_IMPACT_WOOD3 "world/impacts/wood3.ogg"
#define SOUND_IMPACT_WOOD4 "world/impacts/wood4.ogg"

#define SOUND_IMPACT_GLASS1 "world/impacts/glass1.ogg"
#define SOUND_IMPACT_GLASS2 "world/impacts/glass2.ogg"
#define SOUND_IMPACT_GLASS3 "world/impacts/glass3.ogg"
#define SOUND_IMPACT_GLASS4 "world/impacts/glass4.ogg"

#define SOUND_IMPACT_DIRT1 "world/impacts/dirt1.ogg"
#define SOUND_IMPACT_DIRT2 "world/impacts/dirt2.ogg"
#define SOUND_IMPACT_DIRT3 "world/impacts/dirt3.ogg"
#define SOUND_IMPACT_DIRT4 "world/impacts/dirt4.ogg"

#define SOUND_IMPACT_FORCEFIELD1 "world/impacts/ff1.ogg"
#define SOUND_IMPACT_FORCEFIELD2 "world/impacts/ff2.ogg"
#define SOUND_IMPACT_FORCEFIELD3 "world/impacts/ff3.ogg"
#define SOUND_IMPACT_FORCEFIELD4 "world/impacts/ff4.ogg"

#define SOUND_IMPACT_GRASS1 "world/impacts/grass1.ogg"
#define SOUND_IMPACT_GRASS2 "world/impacts/grass2.ogg"
#define SOUND_IMPACT_GRASS3 "world/impacts/grass3.ogg"
#define SOUND_IMPACT_GRASS4 "world/impacts/grass4.ogg"

#define SOUND_IMPACT_TILE1 "world/impacts/tile1.ogg"
#define SOUND_IMPACT_TILE2 "world/impacts/tile2.ogg"
#define SOUND_IMPACT_TILE3 "world/impacts/tile3.ogg"
#define SOUND_IMPACT_TILE4 "world/impacts/tile4.ogg"

#define SOUND_IMPACT_ELEC1 "world/impacts/electronic1.ogg"
#define SOUND_IMPACT_ELEC2 "world/impacts/electronic2.ogg"
#define SOUND_IMPACT_ELEC3 "world/impacts/electronic3.ogg"
#define SOUND_IMPACT_ELEC4 "world/impacts/electronic4.ogg"

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

void() Impact_Spark_think =
{
	local float r;

	self.nextthink = time + (random() * 1);
	self.think = Impact_Spark_think;
	
	if (random() > 0.2)
	{
		r = random() * 4;
		
		if (r < 1){ sound(self, CHAN_AUTO, "world/spark1.wav", 0.5, ATTN_IDLE);	
		}
		else if (r < 2){ 
		sound(self, CHAN_AUTO, "world/spark2.wav", 0.5, ATTN_IDLE);
		}
		else if (r < 3){ 
		sound(self, CHAN_AUTO, "world/spark3.wav", 0.5, ATTN_IDLE);
		}
		else
		{
			sound(self, CHAN_AUTO, "world/spark5.wav", 0.5, ATTN_IDLE);
		}
		pointparticles(particleeffectnum("electronic_spark"), (self.origin + '0 0 0'), '0 0 0', 1);
	}
	else
	{
		sfx_ents--;
		FLOG(sfx_ents);
		remove(self);
	}
}

void(vector org) Impact_Spark =
{
	local entity impact_spark;
	
	impact_spark = spawn();
	impact_spark.origin = org;
	impact_spark.solid = SOLID_NOT;
	impact_spark.movetype = MOVETYPE_NONE;
	impact_spark.effects = self.effects | EF_LOWPRECISION;
	setmodel (impact_spark, "");

	if (random() > 0.5)
	{
		impact_spark.nextthink = time + (random() * 2);	
		impact_spark.think = Impact_Spark_think;
		sfx_ents++;
		FLOG(sfx_ents);	
	}
	else
	{
		impact_spark.nextthink = time + 0.1;	
		impact_spark.think = SUB_Remove;
	}
}

void(vector org) Q3Surface_Impact =
{
	local float r;

	if (trace_dphitq3surfaceflags & Q3SURFACEFLAG_NOSTEPS)
	{
		return;
	}
	else if (trace_dphitq3surfaceflags & Q3SURFACEFLAG_METALSTEPS)
	{
		r = random() * 2;
		if (r < 1) 		pointsound(org, "world/ric1.wav", 1, ATTN_IDLE);
		else if (r < 2) pointsound(org, "world/ric2.wav", 1, ATTN_IDLE);
		else 			pointsound(org, "world/ric3.wav", 1, ATTN_IDLE);
		pointparticles(particleeffectnum("TE_GUNSHOT"), org, '0 0 0', 1);	
	}
	else if (trace_dphitq3surfaceflags & Q3SURFACEFLAG_FLESH)
	{
		r = random() * 4;
		if (r < 1) pointsound(org, SOUND_IMPACT_FLESH1, 1, ATTN_IDLE);
		else if (r < 2) pointsound(org, SOUND_IMPACT_FLESH2, 1, ATTN_IDLE);
		else if (r < 3) pointsound(org, SOUND_IMPACT_FLESH3, 1, ATTN_IDLE);
		else            pointsound(org, SOUND_IMPACT_FLESH4, 1, ATTN_IDLE);
		pointparticles(particleeffectnum("TE_BLOOD"), org, '0 0 0', 1);
	}	
	else if (trace_dphitq3surfaceflags & Q3SURFACEFLAG_WOOD)
	{
		r = random() * 4;
		if (r < 1) pointsound(org, SOUND_IMPACT_WOOD1, 1, ATTN_IDLE);
		else if (r < 2) pointsound(org, SOUND_IMPACT_WOOD2, 1, ATTN_IDLE);
		else if (r < 3) pointsound(org, SOUND_IMPACT_WOOD3, 1, ATTN_IDLE);
		else            pointsound(org, SOUND_IMPACT_WOOD4, 1, ATTN_IDLE);
		pointparticles(particleeffectnum("TE_WOODIMPACT"), org, '0 0 0', 1);
	}
	else if (trace_dphitq3surfaceflags & Q3SURFACEFLAG_GLASS)
	{
		r = random() * 4;
		if (r < 1) pointsound(org, SOUND_IMPACT_GLASS1, 1, ATTN_IDLE);
		else if (r < 2) pointsound(org, SOUND_IMPACT_GLASS2, 1, ATTN_IDLE);
		else if (r < 3) pointsound(org, SOUND_IMPACT_GLASS3, 1, ATTN_IDLE);
		else            pointsound(org, SOUND_IMPACT_GLASS4, 1, ATTN_IDLE);
		pointparticles(particleeffectnum("TE_WOODIMPACT"), org, '0 0 0', 1);
	}
	else if (trace_dphitq3surfaceflags & Q3SURFACEFLAG_DIRT)
	{
		r = random() * 4;
		if (r < 1) pointsound(org, SOUND_IMPACT_DIRT1, 1, ATTN_IDLE);
		else if (r < 2) pointsound(org, SOUND_IMPACT_DIRT2, 1, ATTN_IDLE);
		else if (r < 3) pointsound(org, SOUND_IMPACT_DIRT3, 1, ATTN_IDLE);
		else            pointsound(org, SOUND_IMPACT_DIRT4, 1, ATTN_IDLE);
		pointparticles(particleeffectnum("TE_WOODIMPACT"), org, '0 0 0', 1);
	}
	else if (trace_dphitq3surfaceflags & Q3SURFACEFLAG_FORCEFIELD)
	{
		r = random() * 4;
		if (r < 1) pointsound(org, SOUND_IMPACT_FORCEFIELD1, 1, ATTN_IDLE);
		else if (r < 2) pointsound(org, SOUND_IMPACT_FORCEFIELD2, 1, ATTN_IDLE);
		else if (r < 3) pointsound(org, SOUND_IMPACT_FORCEFIELD3, 1, ATTN_IDLE);
		else            pointsound(org, SOUND_IMPACT_FORCEFIELD4, 1, ATTN_IDLE);
		pointparticles(particleeffectnum("TE_WOODIMPACT"), org, '0 0 0', 1);
	}
	else if (trace_dphitq3surfaceflags & Q3SURFACEFLAG_GRASS)
	{
		r = random() * 4;
		if (r < 1) pointsound(org, SOUND_IMPACT_GRASS1, 1, ATTN_IDLE);
		else if (r < 2) pointsound(org, SOUND_IMPACT_GRASS2, 1, ATTN_IDLE);
		else if (r < 3) pointsound(org, SOUND_IMPACT_GRASS3, 1, ATTN_IDLE);
		else            pointsound(org, SOUND_IMPACT_GRASS4, 1, ATTN_IDLE);
		pointparticles(particleeffectnum("TE_WOODIMPACT"), org, '0 0 0', 1);
	}	
	else if (trace_dphitq3surfaceflags & Q3SURFACEFLAG_TILE)
	{
		r = random() * 4;
		if (r < 1) pointsound(org, SOUND_IMPACT_TILE1, 1, ATTN_IDLE);
		else if (r < 2) pointsound(org, SOUND_IMPACT_TILE2, 1, ATTN_IDLE);
		else if (r < 3) pointsound(org, SOUND_IMPACT_TILE3, 1, ATTN_IDLE);
		else            pointsound(org, SOUND_IMPACT_TILE4, 1, ATTN_IDLE);
		pointparticles(particleeffectnum("TE_WOODIMPACT"), org, '0 0 0', 1);
	}		
	else if (trace_dphitq3surfaceflags & Q3SURFACEFLAG_ELECTRONIC)
	{
		if (r < 1) pointsound(org, SOUND_IMPACT_ELEC1, 1, ATTN_IDLE);
		else if (r < 2) pointsound(org, SOUND_IMPACT_ELEC2, 1, ATTN_IDLE);
		else if (r < 3) pointsound(org, SOUND_IMPACT_ELEC3, 1, ATTN_IDLE);
		else            pointsound(org, SOUND_IMPACT_ELEC4, 1, ATTN_IDLE);
		//pointparticles(particleeffectnum("Lightning_gun_impact"), org, '0 0 0', 1);
		pointparticles(particleeffectnum("TE_GUNSHOT"), org, '0 0 0', 1);
		if (sfx_ents < MAX_SFXENTS){
			Impact_Spark(org);
		}
	}	
	else //DEFAULT TO CONCRETE? 
	{
		r = random() * 2;
		if (r < 1) 		pointsound(org, "world/ric1.wav", 1, ATTN_IDLE);
		else if (r < 2) pointsound(org, "world/ric2.wav", 1, ATTN_IDLE);
		else 			pointsound(org, "world/ric3.wav", 1, ATTN_IDLE);
		pointparticles(particleeffectnum("TE_GUNSHOT"), org, '0 0 0', 1);
	}	
}