/*QUAKED target_speaker (1 0 0) (-8 -8 -8) (8 8 8) looped-on looped-off reliable changelevel
"noise"		wav file to play
"attenuation"

-1 = none, send to whole level
 1 = normal fighting sounds
 2 = idle sound level
 3 = ambient sound level

"volume"	0.0 to 1.0
Normal sounds play each time the target is used.  The reliable flag can be set for crucial voiceovers.

Looped sounds are always atten 3 / vol 1, and the use function toggles it on/off.
Multiple identical looping sounds will just increase volume without any speed cost.
*/

var float autocvar_sound_debug_showall = 0;
var float autocvar_sound_debug_showdistance = 128;

void() target_speaker_think =
{
	local float chan;

	local entity objectivetarget;
	local vector dir;
	local float objectivedist = autocvar_sound_debug_showdistance;

	dir = normalize(self.origin - objectivetarget.origin);
	
	objectivetarget = findradius(self.origin, objectivedist);	
	
	if (self.spawnflags & 1)
	{	// looping sound toggles
		if (self.noise) 
		{
			//pointsound(self.origin, self.noise, self.volume, self.attenuation);
			sound7(self, CHAN_BODY, self.noise, self.volume, self.attenuation, self.speed, self.flags);
			self.nextthink = (time + soundlength(self.noise));

			//ambientsound (self.origin, self.noise, self.volume, self.attenuation);
			//self.nextthink = -1;
		//	return;
		}
		else 
		{
			self.alpha = 0.01;
			self.nextthink = -1;
		}
	}

	if (autocvar_sound_debug_showall >= 1)
	{
		self.alpha = 0.5;
		
		while(objectivetarget)
		{
			if(objectivetarget.flags & FL_CLIENT)
			{
				if(objectivetarget.health > 0)
				{
					if (vlen(objectivetarget.origin - self.origin) < objectivedist)
					{
						bprint("\n"); 
						bprint("target_speaker at "); 
						bprint(vtos(self.origin));
						bprint(", CHAN:"); 
						bprint(ftos(chan));
						bprint(", SOUND:"); 
						bprint(self.noise);
						bprint(", VOL:"); 
						bprint(ftos(self.volume));
						bprint(", ATT:"); 
						bprint(ftos(self.attenuation));
						bprint(", SPEED:"); 
						bprint(ftos(self.speed));
						bprint(", FLG:"); 
						bprint(ftos(self.flags));
						bprint("\n");
						FLOG(soundlength(self.noise));
						self.alpha = 1.00;					
					}
				}
			}
		objectivetarget = objectivetarget.chain;
		}
	}
	else
	{
		self.alpha = 0.01;
	}

	self.think = target_speaker_think;
}

void target_speaker_use ()
{
	local float	chan;

	if (self.spawnflags & 3)
	{	// looping sound toggles
		if (self.noise) 
		{
			self.noise = "";	// turn it off
			self.nextthink = -1;
		}
		else 
		{
			self.nextthink = time + soundlength(self.noise);
			self.think = target_speaker_think;
			//self.noise = self.noise;	// start it
		}
	}
	else
	{
		if (self.attenuation == -2) 
		{
			if(self.spawnflags & 4)
				chan = CHAN_VOICE|SOUNDFLAG_RELIABLE;
			else
				chan = CHAN_VOICE;
			//gi.sound (activator, chan, ent->noise_index, 1, ATTN_NORM, 0);
			//void(vector origin, string sample, float volume, float attenuation) pointsound
			//pointsound(self.origin, self.noise, self.volume, self.attenuation);
			sound7(self, chan, self.noise, self.volume, self.attenuation, 0, 0);
		}
		else
		{	// normal sound
			if (self.spawnflags & 4)
				chan = CHAN_VOICE|SOUNDFLAG_RELIABLE;
			else
				chan = CHAN_VOICE;
			// use a positioned_sound, because this entity won't normally be
			// sent to any clients because it is invisible
			//gi.positioned_sound (ent->s.origin, ent, chan, ent->noise_index, ent->volume, ent->attenuation, 0);
			//pointsound(self.origin, self.noise, self.volume, self.attenuation);
			sound7(self, CHAN_VOICE, self.noise, self.volume, self.attenuation, 100, self.flags);
		}
		self.nextthink = time + soundlength(self.noise);
	}
}

void() target_speaker =
{
	if(!(self.spawnflags & 8))
	{
		if(!self.noise)
		{
			dprint("target_speaker with no noise set at "); 
			dprint(vtos(self.origin));
			return;
		}
		// DWH: Use "message" key to store noise for speakers that change levels
		//      via trigger_transition
		/*if (!strstr (st.noise, ".wav"))
		{
			ent->message = gi.TagMalloc(strlen(st.noise)+5,TAG_LEVEL);
			sprintf(ent->message, "%s.wav", st.noise);
		}
		else
		{
			ent->message = gi.TagMalloc(strlen(st.noise)+1,TAG_LEVEL);
			strcpy(ent->message, st.noise);
		}*/
	}

	if (!self.volume)
		self.volume = 1.0;

	if (!self.attenuation)
		self.attenuation = (self.spawnflags & 1) ? 3.0 : 1.0;
	else if (self.attenuation == -1)	// use -1 so 0 defaults to 1
		self.attenuation = 0;

	// check for prestarted looping sound
/*	if (self.spawnflags & 1) {
		self.noise = self.noise;
		self.attenuation = self.attenuation;
	}*/
	
	//for sound debug
	self.effects = 	self.effects | EF_FULLBRIGHT | EF_NODEPTHTEST;
	precache_model ("models/mapobjects/hub/stroggos_system/logo_strogg.MD3");
	setmodel (self, "models/mapobjects/hub/stroggos_system/logo_strogg.MD3");
	self.alpha = 0.01;
	
	precache_sound (self.noise);
	self.use = target_speaker_use;
	self.think = target_speaker_think;
	self.nextthink = time + soundlength(self.noise);
}
