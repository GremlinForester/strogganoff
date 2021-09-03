/*
	Straight port of Q2's g_weapons file.
		adapted to QuakeC.
*/

/*
	handle the simple direction and sending of shot tracelines,
	sfx, punchangle, etc are left up to the calling func.
	
	slight optimization:
		combined elements of Firebullets because not every Firebullets needs a for-loop.
		and we'd like to reduce func call jump counts.
*/
void(vector aimAngle, vector spread, float damage) fire_bullet_base={
	local vector org;
	local vector dir;
	
	makevectors(aimAngle);
	
	org = self.origin + v_forward * 10;
	org_z = self.absmin_z + self.size_z * 0.7;

	dir = aim(self, 100000);
	dir = dir + crandom()*spread_x*v_right + crandom()*spread_y*v_up;
		
	traceline (org, org + dir*2048, FALSE, self);
	
	if (trace_fraction != 1.0)
	{
		Q3SurfaceTraceAttack(damage, dir);
	}
};


void(vector entOrg, vector aimAngle, float pellets, vector spread, float damage) fire_shotgun_base={

	local vector org;
	local vector dir;
	
	makevectors(aimAngle);
	
	org = entOrg + v_forward * 6;
	org_z = self.absmin_z + self.size_z * 0.7;

	dir = aim(self, 100000);
	
	ClearMultiDamage();
	while (pellets > 0)
	{
		dir = dir + crandom()*spread_x*v_right + crandom()*spread_y*v_up;
		
		traceline (org, org + dir*2048, FALSE, self);
		
		if (trace_fraction != 1.0)
		{
			Q3SurfaceTraceAttack(damage, dir);
		}
		pellets = pellets - 1;
	}
	ApplyMultiDamage ();
};



/*
=================
fire_lead
This is an internal support routine used for bullet/pellet based weapons.
=================
*/
/*void(vector start, vector aimdir, float damage, float kick, float te_impact, float hspread, float vspread, float mod) q2_fire_lead =
{
	trace_t		tr;
	vector		dir;
	vector		forward, right, up;
	vector		end;
	float		r;
	float		u;
	vector		water_start;
	float	water = false;
	float			content_mask = MASK_SHOT | MASK_WATER;

	traceline(self.origin, start, MASK_SHOT, self);
	if (!(trace_fraction < 1.0))
	{
		vectoangles (aimdir, dir);
		AngleVectors (dir, forward, right, up);
		makevectors(dir);

		r = crandom()*hspread;
		u = crandom()*vspread;
		end = VectorMA (start, 8192, v_forward);
		end = VectorMA (end, r, v_right);
		end = VectorMA (end, u, v_up);

		if (pointcontents (start) & MASK_WATER)
		{
			water = true;
			water_start = start;
			//content_mask &= ~MASK_WATER; ?
		}
		
		traceline(start, end, content_mask, self);

		// see if we hit water
		if (tr.contents & MASK_WATER)
		{
			float		color;

			water = true;
			water_start = trace_endpos;

			// TODO - material / contents 
			/*if (!VectorCompare (start, trace_endpos))
			{
				if (tr.contents & CONTENTS_WATER)
				{
					if (strcmp(tr.surface->name, "*brwater") == 0)
						color = SPLASH_BROWN_WATER;
					else
						color = SPLASH_BLUE_WATER;
				}
				else if (tr.contents & CONTENTS_SLIME)
					color = SPLASH_SLIME;
				else if (tr.contents & CONTENTS_LAVA)
					color = SPLASH_LAVA;
				else
					color = SPLASH_UNKNOWN;

				if (color != SPLASH_UNKNOWN)
				{
					gi.WriteByte (svc_temp_entity);
					gi.WriteByte (TE_SPLASH);
					gi.WriteByte (8);
					gi.WritePosition (tr.endpos);
					gi.WriteDir (tr.plane.normal);
					gi.WriteByte (color);
					gi.multicast (tr.endpos, MULTICAST_PVS);
				}

				// change bullet's course when it enters water
				VectorSubtract (end, start, dir);
				vectoangles (dir, dir);
				AngleVectors (dir, forward, right, up);
				r = crandom()*hspread*2;
				u = crandom()*vspread*2;
				VectorMA (water_start, 8192, forward, end);
				VectorMA (end, r, right, end);
				VectorMA (end, u, up, end);
			}

			// re-trace ignoring water this time
			traceline(water_start, end, MASK_SHOT, self);
		}
	}

	// send gun puff / flash
	if (!((tr.surface) && (tr.surface->flags & SURF_SKY)))
	{
		if (tr.fraction < 1.0)
		{
			if (trace_ent.takedamage)
			{
				T_Damage (tr.ent, self, self, aimdir, tr.endpos, tr.plane.normal, damage, kick, DAMAGE_BULLET, mod);
			}
			else
			{
				if (strncmp (tr.surface->name, "sky", 3) != 0)
				{
					gi.WriteByte (svc_temp_entity);
					gi.WriteByte (te_impact);
					gi.WritePosition (tr.endpos);
					gi.WriteDir (tr.plane.normal);
					gi.multicast (tr.endpos, MULTICAST_PVS);

					if (self->client)
						PlayerNoise(self, tr.endpos, PNOISE_IMPACT);
				}
			}
		}
	}

	// if went through water, determine where the end and make a bubble trail
	if (water)
	{
		vector	pos;
		
		dir = VectorSubtract (trace_endpos, water_start);
		dir = normalize(dir);
		pos = VectorMA (trace_endpos, -2, dir);
		if (pointcontents (pos) & MASK_WATER)
			pos = trace_endpos;
		else
			tr = gi.trace (pos, NULL, NULL, water_start, tr.ent, MASK_WATER);

		pos = VectorAdd (water_start, trace_endpos);
		pos = VectorScale (pos, 0.5);

		gi.WriteByte (svc_temp_entity);
		gi.WriteByte (TE_BUBBLETRAIL);
		gi.WritePosition (water_start);
		gi.WritePosition (tr.endpos);
		gi.multicast (pos, MULTICAST_PVS);
	}
}*/