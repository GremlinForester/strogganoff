.float nextfootstep;

float sfx_ents;
#define MAX_SFXENTS 4

#define DEFAULT_FOOTSTEP_VOL 0.35;

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
		if (r < 1) {sound(self, CHAN_AUTO, "player/splash1.wav", 0.25, ATTN_IDLE);
						pointparticles(particleeffectnum("watersplashbig"), (self.origin + '0 8 -8'), '0 32 0', 1);}
		else if (r < 2) {sound(self, CHAN_AUTO, "player/splash2.wav", 0.25, ATTN_IDLE);
						pointparticles(particleeffectnum("watersplashbig"), (self.origin + '0 -8 -8'), '0 32 0', 1);}
		else if (r < 3) {sound(self, CHAN_AUTO, "player/splash3.wav", 0.25, ATTN_IDLE);
						pointparticles(particleeffectnum("watersplashbig"), (self.origin + '0 8 -8'), '0 32 0', 1);}
		else            {sound(self, CHAN_AUTO, "player/splash4.wav", 0.25, ATTN_IDLE);
						pointparticles(particleeffectnum("watersplashbig"), (self.origin + '0 -8 -8'), '0 32 0', 1);}
	}
	else if (self.waterlevel == 2) //Water Wade
	{
		sound (self, CHAN_AUTO, sprintf("player/wade%s.ogg", ftos((rint(random()*3)+1))), 0.25, ATTN_IDLE);		
	}
	else if (trace_dphitq3surfaceflags & Q3SURFACEFLAG_METALSTEPS)
	{
		sound (self, CHAN_AUTO, sprintf("player/metal%s.wav", ftos((rint(random()*3)+1))), 0.25, ATTN_IDLE);		
	}
	else if (trace_dphitq3surfaceflags & Q3SURFACEFLAG_WOOD)
	{
		sound (self, CHAN_AUTO, sprintf("player/wood%s.wav", ftos((rint(random()*3)+1))), 0.25, ATTN_IDLE);		
	}
	else if (trace_dphitq3surfaceflags & Q3SURFACEFLAG_FLESH)
	{
		sound (self, CHAN_AUTO, sprintf("player/flesh%s.wav", ftos((rint(random()*3)+1))), 0.25, ATTN_IDLE);
	}
	else if (trace_dphitq3surfaceflags & Q3SURFACEFLAG_GLASS)
	{
		sound (self, CHAN_AUTO, sprintf("player/gfvent%s.wav", ftos((rint(random()*5)+1))), 0.35, ATTN_IDLE);	
	}
	else if (trace_dphitq3surfaceflags & Q3SURFACEFLAG_DIRT)
	{
		sound (self, CHAN_AUTO, sprintf("player/dirt%s.wav", ftos((rint(random()*3)+1))), 0.25, ATTN_IDLE);
	}
	else if (trace_dphitq3surfaceflags & Q3SURFACEFLAG_FORCEFIELD)
	{
		sound (self, CHAN_AUTO, sprintf("player/energy%s.wav", ftos((rint(random()*3)+1))), 0.25, ATTN_IDLE);
	}
	else if (trace_dphitq3surfaceflags & Q3SURFACEFLAG_GRASS)
	{
		sound (self, CHAN_AUTO, sprintf("player/grass%s.ogg", ftos((rint(random()*3)+1))), 0.25, ATTN_IDLE);		
	}
	else if (trace_dphitq3surfaceflags & Q3SURFACEFLAG_TILE)
	{
		sound (self, CHAN_AUTO, sprintf("player/tile%s.wav", ftos((rint(random()*3)+1))), 0.25, ATTN_IDLE);
	}
	else
	{
	// Quake 2 Steps 
	sound (self, CHAN_AUTO, sprintf("player/step%s.wav", ftos((rint(random()*3)+1))), 0.35, ATTN_IDLE);
	
	//	sound (self, CHAN_AUTO, sprintf("player/gfstep%s.wav", ftos((rint(random()*3)+1))), 0.35, ATTN_IDLE);
	//	sound7(self, CHAN_AUTO, sprintf("player/gfstep%s.wav", ftos((rint(random()*3)+1))), 0.35, ATTN_IDLE, ((random() + 0.4) * 100), 0);	
	}
}

void() Q3Surface_FootStep =
{

	if (time < self.nextfootstep)
	return;

	if (!CheckFootStep())
	return;

	if (vlen(self.velocity) < 200)
		self.nextfootstep = time + 0.35 + random() * 0.1;
	else
		self.nextfootstep = time + 0.25 + random() * 0.1;
		
	if (self.waterlevel == 2)
		self.nextfootstep = time + 1.25 + random() * 0.1;

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
		//FLOG(sfx_ents);
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
		//FLOG(sfx_ents);	
	}
	else
	{
		impact_spark.nextthink = time + 0.1;	
		impact_spark.think = SUB_Remove;
	}
}

void(vector org) Q3Surface_Impact =
{
	if (trace_ent.flags & FL_MONSTER)
	{
		pointsound (org, sprintf("world/impacts/flesh%s.ogg", ftos((rint(random()*3)+1))), 1, ATTN_IDLE);	
		pointparticles(particleeffectnum("TE_BLOOD"), org, '0 0 0', 1);
		return;
	}
	
	if (trace_dphitq3surfaceflags & Q3SURFACEFLAG_NOSTEPS)
	{
		return;
	}
	else if (trace_dphitq3surfaceflags & Q3SURFACEFLAG_METALSTEPS)
	{
		pointsound (org, sprintf("world/ric%s.wav", ftos((rint(random()*2)+1))), 1, ATTN_IDLE);		
		pointparticles(particleeffectnum("TE_GUNSHOT"), org, '0 0 0', 1);	
	}
	else if (trace_dphitq3surfaceflags & Q3SURFACEFLAG_FLESH)
	{
		pointsound (org, sprintf("world/impacts/flesh%s.ogg", ftos((rint(random()*3)+1))), 1, ATTN_IDLE);	
		pointparticles(particleeffectnum("TE_BLOOD"), org, '0 0 0', 1);
	}	
	else if (trace_dphitq3surfaceflags & Q3SURFACEFLAG_WOOD)
	{
		pointsound (org, sprintf("world/impacts/wood%s.ogg", ftos((rint(random()*3)+1))), 1, ATTN_IDLE);
		pointparticles(particleeffectnum("TE_WOODIMPACT"), org, '0 0 0', 1);
	}
	else if (trace_dphitq3surfaceflags & Q3SURFACEFLAG_GLASS || trace_ent.material == GIB_GLASS)
	{
		pointsound (org, sprintf("world/impacts/glass%s.ogg", ftos((rint(random()*3)+1))), 1, ATTN_IDLE);
		pointparticles(particleeffectnum("TE_WOODIMPACT"), org, '0 0 0', 1);
	}
	else if (trace_dphitq3surfaceflags & Q3SURFACEFLAG_DIRT)
	{
		pointsound (org, sprintf("world/impacts/dirt%s.ogg", ftos((rint(random()*3)+1))), 1, ATTN_IDLE);
		pointparticles(particleeffectnum("TE_WOODIMPACT"), org, '0 0 0', 1);
	}
	else if (trace_dphitq3surfaceflags & Q3SURFACEFLAG_FORCEFIELD)
	{
		pointsound (org, sprintf("world/impacts/ff%s.ogg", ftos((rint(random()*3)+1))), 1, ATTN_IDLE);
		pointparticles(particleeffectnum("TE_WOODIMPACT"), org, '0 0 0', 1);
	}
	else if (trace_dphitq3surfaceflags & Q3SURFACEFLAG_GRASS)
	{
		pointsound (org, sprintf("world/impacts/grass%s.ogg", ftos((rint(random()*3)+1))), 1, ATTN_IDLE);
		pointparticles(particleeffectnum("TE_WOODIMPACT"), org, '0 0 0', 1);
	}	
	else if (trace_dphitq3surfaceflags & Q3SURFACEFLAG_TILE)
	{
		pointsound (org, sprintf("world/impacts/tile%s.ogg", ftos((rint(random()*3)+1))), 1, ATTN_IDLE);
		pointparticles(particleeffectnum("TE_WOODIMPACT"), org, '0 0 0', 1);
	}		
	else if (trace_dphitq3surfaceflags & Q3SURFACEFLAG_ELECTRONIC)
	{
		pointsound (org, sprintf("world/impacts/electronic%s.ogg", ftos((rint(random()*3)+1))), 1, ATTN_IDLE);
		//pointparticles(particleeffectnum("Lightning_gun_impact"), org, '0 0 0', 1);
		pointparticles(particleeffectnum("TE_GUNSHOT"), org, '0 0 0', 1);
		if (sfx_ents < MAX_SFXENTS){
			Impact_Spark(org);
		}
	}	
	else //DEFAULT TO CONCRETE? 
	{
		pointsound (org, sprintf("world/ric%s.wav", ftos((rint(random()*2)+1))), 1, ATTN_IDLE);
		pointparticles(particleeffectnum("TE_GUNSHOT"), org, '0 0 0', 1);
	}	
}