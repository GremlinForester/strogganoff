//
void() InitBodyQue;

void( ) FRIK_FILE_precaches =
{
	local float f;                                      // file handle, basically assigns a number to whatever file is open
	local string ln;                                    // ln = line of the file being read
	
	
	
	f = fopen("cache/precache_server.txt" , FILE_READ);        // opens "data/precache.txt" to be read

    bprint("loaded cache/precache_server.txt\n");  //DEBUG
	
	if (f != -1){                                        // if f = -1 then the file could not be found
		ln = fgets(f);                              // this line sets ln to the string read from the file with the file handle of f
    
    while( ln != "EOF" ){                     // while there is still text to be read do the following
      if( cvar("developer") ){
        dprint(strcat("line value (",ln,")\n"));  //DEBUG
      }
      if( ln != "" && substring(ln,0, 2) != "//" ){
        if( cvar("developer") ){
          dprint(strcat("loaded [",ln,"]\n"));  //DEBUG
        }
        if(strstrofs(ln, ".wav",0) != -1)   // this checks if the file extension is .wav for a sound file
        {
          precache_sound(ln);         // if it is a sound, then it precaches said sound
        }
        else if(strstrofs(ln, ".ogg",0) != -1){
          precache_sound(ln);
        }
        else if(strstrofs(ln, ".mdl",0) != -1){
          precache_model(ln);         // so precache the model
        }		
        else if(strstrofs(ln, ".md2",0) != -1){
          precache_model(ln);         // so precache the model
        }
        else if(strstrofs(ln, ".spr",0) != -1){
          precache_model(ln);         // so precache the model
        }
        else if(strstrofs(ln, ".sp2",0) != -1){
          precache_model(ln);         // so precache the model
        }
        else if(strstrofs(ln, ".spr32",0) != -1){
          precache_model(ln);         // so precache the model
        }
        else if(strstrofs(ln, ".md3",0) != -1){
          precache_model(ln);         // so precache the model
        }
        else if( strstrofs(ln, ".obj", 0) != -1){
          precache_model(ln);
        }
        else if( strstrofs(ln, ".bsp", 0) != -1){
          precache_file(ln);
        }
      }
			ln = fgets(f);                      // get a new line from the file
		}
    fclose(f);                                          // when the while loop is over (no lines left in file) close file with the handle f    
	} 
};

void() main =
{
#ifndef nodprint
	dprint ("main function\n");
#endif

// these are just commands the the prog compiler to copy these files

	precache_file ("progs.dat");
	precache_file ("gfx.wad");
	precache_file ("quake.rc");
	precache_file ("default.cfg");

	precache_file ("end1.bin");
	precache_file2 ("end2.bin");

	precache_file ("demo1.dem");
	precache_file ("demo2.dem");
	precache_file ("demo3.dem");

//
// these are all of the lumps from the cached.ls files
//
	precache_file ("gfx/palette.lmp");
	precache_file ("gfx/colormap.lmp");

	precache_file2 ("gfx/pop.lmp");

	precache_file ("gfx/complete.lmp");
	precache_file ("gfx/inter.lmp");

	precache_file ("gfx/ranking.lmp");
	precache_file ("gfx/vidmodes.lmp");
	precache_file ("gfx/finale.lmp");
	precache_file ("gfx/conback.lmp");
	precache_file ("gfx/qplaque.lmp");

	precache_file ("gfx/menudot1.lmp");
	precache_file ("gfx/menudot2.lmp");
	precache_file ("gfx/menudot3.lmp");
	precache_file ("gfx/menudot4.lmp");
	precache_file ("gfx/menudot5.lmp");
	precache_file ("gfx/menudot6.lmp");

	precache_file ("gfx/menuplyr.lmp");
	precache_file ("gfx/bigbox.lmp");
	precache_file ("gfx/dim_modm.lmp");
	precache_file ("gfx/dim_drct.lmp");
	precache_file ("gfx/dim_ipx.lmp");
	precache_file ("gfx/dim_tcp.lmp");
	precache_file ("gfx/dim_mult.lmp");
	precache_file ("gfx/mainmenu.lmp");
	
	precache_file ("gfx/box_tl.lmp");
	precache_file ("gfx/box_tm.lmp");
	precache_file ("gfx/box_tr.lmp");
	
	precache_file ("gfx/box_ml.lmp");
	precache_file ("gfx/box_mm.lmp");
	precache_file ("gfx/box_mm2.lmp");
	precache_file ("gfx/box_mr.lmp");
	
	precache_file ("gfx/box_bl.lmp");
	precache_file ("gfx/box_bm.lmp");
	precache_file ("gfx/box_br.lmp");
	
	precache_file ("gfx/sp_menu.lmp");
	precache_file ("gfx/ttl_sgl.lmp");
	precache_file ("gfx/ttl_main.lmp");
	precache_file ("gfx/ttl_cstm.lmp");
	
	precache_file ("gfx/mp_menu.lmp");
	
	precache_file ("gfx/netmen1.lmp");
	precache_file ("gfx/netmen2.lmp");
	precache_file ("gfx/netmen3.lmp");
	precache_file ("gfx/netmen4.lmp");
	precache_file ("gfx/netmen5.lmp");
	
	precache_file ("gfx/sell.lmp");
	
	precache_file ("gfx/help0.lmp");
	precache_file ("gfx/help1.lmp");
	precache_file ("gfx/help2.lmp");
	precache_file ("gfx/help3.lmp");
	precache_file ("gfx/help4.lmp");
	precache_file ("gfx/help5.lmp");

	precache_file ("gfx/pause.lmp");
	precache_file ("gfx/loading.lmp");

	precache_file ("gfx/p_option.lmp");
	precache_file ("gfx/p_load.lmp");
	precache_file ("gfx/p_save.lmp");
	precache_file ("gfx/p_multi.lmp");

// sounds loaded by C code
	precache_sound ("misc/menu1.wav");
	precache_sound ("misc/menu2.wav");
	precache_sound ("misc/menu3.wav");

	precache_sound ("ambience/water1.wav");
	precache_sound ("ambience/wind2.wav");
	
// shareware
	precache_file ("maps/start.bsp");

	precache_file ("maps/e1m1.bsp");
	precache_file ("maps/e1m2.bsp");
	precache_file ("maps/e1m3.bsp");
	precache_file ("maps/e1m4.bsp");
	precache_file ("maps/e1m5.bsp");
	precache_file ("maps/e1m6.bsp");
	precache_file ("maps/e1m7.bsp");
	precache_file ("maps/e1m8.bsp");

// registered
	precache_file2 ("gfx/pop.lmp");

	precache_file2 ("maps/e2m1.bsp");
	precache_file2 ("maps/e2m2.bsp");
	precache_file2 ("maps/e2m3.bsp");
	precache_file2 ("maps/e2m4.bsp");
	precache_file2 ("maps/e2m5.bsp");
	precache_file2 ("maps/e2m6.bsp");
	precache_file2 ("maps/e2m7.bsp");

	precache_file2 ("maps/e3m1.bsp");
	precache_file2 ("maps/e3m2.bsp");
	precache_file2 ("maps/e3m3.bsp");
	precache_file2 ("maps/e3m4.bsp");
	precache_file2 ("maps/e3m5.bsp");
	precache_file2 ("maps/e3m6.bsp");
	precache_file2 ("maps/e3m7.bsp");

	precache_file2 ("maps/e4m1.bsp");
	precache_file2 ("maps/e4m2.bsp");
	precache_file2 ("maps/e4m3.bsp");
	precache_file2 ("maps/e4m4.bsp");
	precache_file2 ("maps/e4m5.bsp");
	precache_file2 ("maps/e4m6.bsp");
	precache_file2 ("maps/e4m7.bsp");
	precache_file2 ("maps/e4m8.bsp");

	precache_file2 ("maps/end.bsp");

	precache_file2 ("maps/dm1.bsp");
	precache_file2 ("maps/dm2.bsp");
	precache_file2 ("maps/dm3.bsp");
	precache_file2 ("maps/dm4.bsp");
	precache_file2 ("maps/dm5.bsp");
	precache_file2 ("maps/dm6.bsp");
};


entity	lastspawn;

void(vector org, float height, vector rot) make_ladderVolume;

//=======================
/*QUAKED worldspawn (0 0 0) ?
Only used for the world entity.
Set message to the level name.
Set sounds to the cd track to play.

World Types:
0: medieval
1: metal
2: base
*/
//=======================
void() worldspawn =
{
//	local	float		fraglimit;
//	fraglimit = ;

//	local string s;
//	s = strcat("maxplayers ", ftos(autocvar_howmanyplayers), "\n");

	lastspawn = world;
	InitBodyQue ();

	addstat (STAT_Q2WEAPONS, 2, inv_weapons);
	addstat (STAT_AMMO_SHELLS, 2, inv_ammo_shells);
	addstat (STAT_AMMO_BULLETS, 2, inv_ammo_bullets);	
	addstat (STAT_AMMO_ROCKETS, 2, inv_ammo_rockets);
	addstat (STAT_AMMO_CELLS, 2, inv_ammo_cells);
	addstat (STAT_AMMO_SLUGS, 2, inv_ammo_slugs);
	addstat (STAT_Q2KEYS, 2, items_q2keys);
	addstat (STAT_PICKUP, 2, player_pickup_itemnum);
	addstat (STAT_INV_QUAD, 2, inv_pickup_quad);
	addstat (STAT_INV_REBREATHER, 2, inv_pickup_rebreather);
	addstat (STAT_INV_INVIS, 2, inv_pickup_invisibility);
	addstat (STAT_INV_SILENCER, 2, inv_pickup_silencer);
	addstat (STAT_INVINVUL, 2, inv_pickup_invulnerability);
	addstat (STAT_ENVIRO,2, inv_pickup_envirosuit);
	addstat (STAT_FRAGS,2, frags);
	addstat (STAT_PLAYERTYPE, 2, playerType);	
	
#ifndef cv_setdef
// set cv defaults if set def package not used

// version command string for console
	#ifdef qcvers
	localcmd(version__);
	#endif

// xvars level 1

	#ifdef xvars1

		localcmd("seta svx_platdoorfail	0\n");
		localcmd("seta svx_tc_defmap \"\"\n");
	
	#endif

// xvars level 2

	#ifdef xvars2
	
		localcmd("seta svx_defsigil 0\n");
		localcmd("seta svx_glowcorpse 0\n");

	#endif


#endif


#ifdef FRIKBOT

	#ifndef cv_setdef
	
		#ifdef svc_botcon
// create non-storable cvar for frikbot control
// has same code as impulse - 100, 101 - add bot, 102 - remove bot
		localcmd("set sv_botcon 0\n");
		#endif

		#ifdef svc_frikbot
// create a config.cfg storable xvar for frikbots, default to on
		localcmd("seta svx_frikbot 1\n");
		#endif

		#ifdef svc_botcam
// create a config.cfg storable xvar for botcam, default to off
		localcmd("seta svx_botcam 0\n");
		#endif
	
	#endif
	
// an alternate that saves global vars is to place these commands in default.cfg
// and comment out the lines of code

// frikbot tie-in

	BotInit ();

// kascam - not used, using darkplaces internal instead
//   CamSpawn ();

// waypoint limits

	#ifdef NOWAY

		#ifndef cv_setdef

		localcmd("set sv_bot_noway_above 0\n");
		localcmd("set sv_bot_noway_below 0\n");

		#endif

// note: these require a per map load
	noway_below = cvar("sv_bot_noway_below");
	noway_above = cvar("sv_bot_noway_above");

	if (!noway_below) noway_below = world.mins_z - 8;
	if (!noway_above) noway_above = world.maxs_z + 8;

	#endif

// end frikbot section
#endif

// custom map attributes
	if (self.model == "maps/e1m8.bsp")
		cvar_set ("sv_gravity", "100");
	else
		cvar_set ("sv_gravity", "800");
/*

Quake 2 MP Map ladder volumes

*/	
	if (self.model == "maps/q2dm3.bsp")
		make_ladderVolume('-226 202 -15', 130, '0 -30 0');
	
	if (self.model == "maps/base1.bsp")
		make_ladderVolume('389 47 -220', 128, '0 -30 0');

	// the area based ambient sounds MUST be the first precache_sounds

// player precaches	
	W_Precache ();			// get weapon precaches

	FRIK_FILE_precaches(); //MrC: Thanks goes to Peter Roohr (battleMETAL), precaching with external text files is TIGHT!
	
// sounds used from C physics code
	precache_sound ("demon/dland2.wav");		// landing thud
	precache_sound ("misc/h2ohit1.wav");		// landing splash

// setup precaches allways needed
	precache_sound ("items/itembk2.wav");		// item respawn sound
	precache_sound ("player/plyrjmp8.wav");		// player jump
	precache_sound ("player/land.wav");			// player landing
	precache_sound ("player/land2.wav");		// player hurt landing
	precache_sound ("player/drown1.wav");		// drowning pain
	precache_sound ("player/drown2.wav");		// drowning pain
	precache_sound ("player/gasp1.wav");		// gasping for air
	precache_sound ("player/gasp2.wav");		// taking breath
	precache_sound ("player/h2odeath.wav");		// drowning death

	precache_sound ("misc/talk.wav");			// talk
	precache_sound ("player/teledth1.wav");		// telefrag
	precache_sound ("misc/r_tele1.wav");		// teleport sounds
	precache_sound ("misc/r_tele2.wav");
	precache_sound ("misc/r_tele3.wav");
	precache_sound ("misc/r_tele4.wav");
	precache_sound ("misc/r_tele5.wav");
	precache_sound ("weapons/lock4.wav");		// ammo pick up
	precache_sound ("weapons/pkup.wav");		// weapon up
	precache_sound ("items/armor1.wav");		// armor up
	precache_sound ("weapons/lhit.wav");		//lightning
	precache_sound ("weapons/lstart.wav");		//lightning start
	precache_sound ("items/damage3.wav");

	precache_sound ("misc/power.wav");			//lightning for boss

// player gib sounds
	precache_sound ("player/gib.wav");			// player gib sound
	precache_sound ("player/udeath.wav");		// player gib sound
	precache_sound ("player/tornoff2.wav");		// gib sound

	precache_sound (PLAYER_KILLCOMMENT_1);
	precache_sound (PLAYER_KILLCOMMENT_2);
	precache_sound (PLAYER_KILLCOMMENT_3);
	precache_sound (PLAYER_KILLCOMMENT_4);
	precache_sound (PLAYER_KILLCOMMENT_5);
	precache_sound (PLAYER_KILLCOMMENT_6);

	precache_sound (PLAYER_IDLECOMMENT_1);
	precache_sound (PLAYER_IDLECOMMENT_2);
	precache_sound (PLAYER_IDLECOMMENT_3);
	precache_sound (PLAYER_IDLECOMMENT_4);

// player pain sounds

	precache_sound ("player/pain1.wav");
	precache_sound ("player/pain2.wav");
	precache_sound ("player/pain3.wav");
	precache_sound ("player/pain4.wav");
	precache_sound ("player/pain5.wav");
	precache_sound ("player/pain6.wav");

// player death sounds
	precache_sound ("player/death1.wav");
	precache_sound ("player/death2.wav");
	precache_sound ("player/death3.wav");
	precache_sound ("player/death4.wav");
	precache_sound ("player/death5.wav");

// ax sounds	
	precache_sound ("weapons/ax1.wav");			// ax swoosh
	precache_sound ("player/axhit1.wav");		// ax hit meat
	precache_sound ("player/axhit2.wav");		// ax hit world

	precache_sound ("player/h2ojump.wav");		// player jumping into water
	precache_sound ("player/slimbrn2.wav");		// player enter slime
	precache_sound ("player/inh2o.wav");		// player enter water
	precache_sound ("player/inlava.wav");		// player enter lava
	precache_sound ("misc/outwater.wav");		// leaving water sound

	precache_sound ("player/lburn1.wav");		// lava burn
	precache_sound ("player/lburn2.wav");		// lava burn

	precache_sound ("misc/water1.wav");			// swimming
	precache_sound ("misc/water2.wav");			// swimming

	precache_model ("progs/player.mdl");
	precache_model ("progs/h_player.mdl");
	precache_model ("progs/gib1.mdl");
	precache_model ("progs/gib2.mdl");
	precache_model ("progs/gib3.mdl");

	precache_model ("progs/s_bubble.spr");	// drowning bubbles
	precache_model ("progs/s_explod.spr");	// sprite explosion
	
	precache_model ("progs/muzzleflash3.spr");
	precache_model ("progs/combust.spr32");	
	precache_model ("models/glass64_broke.MD3");
	precache_model ("models/glass64_cracked.MD3");
	precache_model ("models/objects/flash/tris.md2");
	precache_model ("players/male/w_blaster.md2");
	precache_model ("players/male/w_shotgun.md2");
	precache_model ("players/male/w_sshotgun.md2");
	precache_model ("players/male/w_machinegun.md2");
	precache_model ("players/male/w_chaingun.md2");
	precache_model ("players/male/w_glauncher.md2");
	precache_model ("players/male/w_rlauncher.md2");
	precache_model ("players/male/w_railgun.md2");
	precache_model ("players/male/w_hyperblaster.md2");
	precache_model ("players/male/w_bfg.md2");
	precache_model ("players/male/tris.md2");
	
	precache_model ("players/female/w_blaster.md2");
	precache_model ("players/female/w_shotgun.md2");
	precache_model ("players/female/w_sshotgun.md2");
	precache_model ("players/female/w_machinegun.md2");
	precache_model ("players/female/w_chaingun.md2");
	precache_model ("players/female/w_glauncher.md2");
	precache_model ("players/female/w_rlauncher.md2");
	precache_model ("players/female/w_railgun.md2");
	precache_model ("players/female/w_hyperblaster.md2");
	precache_model ("players/female/w_bfg.md2");
	precache_model ("players/female/tris.md2");

	precache_model ("players/cyborg/w_blaster.md2");
	precache_model ("players/cyborg/w_shotgun.md2");
	precache_model ("players/cyborg/w_sshotgun.md2");
	precache_model ("players/cyborg/w_machinegun.md2");
	precache_model ("players/cyborg/w_chaingun.md2");
	precache_model ("players/cyborg/w_glauncher.md2");
	precache_model ("players/cyborg/w_rlauncher.md2");
	precache_model ("players/cyborg/w_railgun.md2");
	precache_model ("players/cyborg/w_hyperblaster.md2");
	precache_model ("players/cyborg/w_bfg.md2");
	precache_model ("players/cyborg/tris.md2");
	
	precache_model ("models/objects/flash/tris.md2");
	
	precache_model ("models/weapons/v_blast/tris.md2");
	precache_model ("models/weapons/v_shotg/tris.md2");
	precache_model ("models/weapons/v_shotg2/tris.md2");
	precache_model ("models/weapons/v_machn/tris.md2");
	precache_model ("models/weapons/v_chain/tris.md2");
	precache_model ("models/weapons/v_launch/tris.md2");
	precache_model ("models/weapons/v_rocket/tris.md2");
	precache_model ("models/weapons/v_hyperb/tris.md2");
	precache_model ("models/weapons/v_rail/tris.md2");
	precache_model ("models/weapons/v_bfg/tris.md2");

	precache_model ("progs/bolt.mdl");		// for lightning gun
	precache_model ("progs/bolt2.mdl");		// for lightning gun
	precache_model ("progs/bolt3.mdl");		// for boss shock
	precache_model ("progs/lavaball.mdl");	// for testing
	
	precache_model ("progs/missile.mdl");
	precache_model ("models/objects/rocket/tris.md2");
	precache_model ("progs/grenade.mdl");
	precache_model ("progs/spike.mdl");
	precache_model ("progs/s_spike.mdl");

	precache_model ("progs/backpack.mdl");

	precache_model ("progs/zom_gib.mdl");

	precache_model ("models/objects/grenade/tris.md2");
	precache_model ("sprites/s_bfg1.sp2");
	
	// player foot sounds
	
	precache_sound ("weapons/HGRENT1A.WAV");
	precache_sound ("weapons/ROCKLF1A.wav");
	
	precache_sound ("items/suit2.wav");	

//
// Setup light animation tables. 'a' is total darkness, 'z' is maxbright.
//

	// 0 normal
	lightstyle(0, "m");
	
	// 1 FLICKER (first variety)
	lightstyle(1, "mmnmmommommnonmmonqnmmo");
	
	// 2 SLOW STRONG PULSE
	lightstyle(2, "abcdefghijklmnopqrstuvwxyzyxwvutsrqponmlkjihgfedcba");
	
	// 3 CANDLE (first variety)
	lightstyle(3, "mmmmmaaaaammmmmaaaaaabcdefgabcdefg");
	
	// 4 FAST STROBE
	lightstyle(4, "mamamamamama");
	
	// 5 GENTLE PULSE 1
	lightstyle(5,"jklmnopqrstuvwxyzyxwvutsrqponmlkj");
	
	// 6 FLICKER (second variety)
	lightstyle(6, "nmonqnmomnmomomno");
	
	// 7 CANDLE (second variety)
	lightstyle(7, "mmmaaaabcdefgmmmmaaaammmaamm");
	
	// 8 CANDLE (third variety)
	lightstyle(8, "mmmaaammmaaammmabcdefaaaammmmabcdefmmmaaaa");
	
	// 9 SLOW STROBE (fourth variety)
	lightstyle(9, "aaaaaaaazzzzzzzz");
	
	// 10 FLUORESCENT FLICKER
	lightstyle(10, "mmamammmmammamamaaamammma");

	// 11 SLOW PULSE NOT FADE TO BLACK
	lightstyle(11, "abcdefghijklmnopqrrqponmlkjihgfedcba");
	
	// 12 PULSE
//	lightstyle(12, "mpqsvsqp");
	lightstyle(12, "mpsic");	
	
	// styles 32-62 are assigned by the light program for switchable lights

	// 63 testing
	lightstyle(63, "a");
};

void() StartFrame =
{
	teamplay = cvar("teamplay");
	skill = cvar("skill");
	
	framecount = framecount + 1;

#ifdef FRIKBOT

// frikbot tie-in

	BotFrame(); 

#endif

};

/*
==============================================================================

BODY QUE

==============================================================================
*/

entity	bodyque_head;

#ifdef unused
void() bodyque =
{	// just here so spawn functions don't complain after the world
	// creates bodyques
};
#endif

void() InitBodyQue =
{
//	local entity	e;	// fx_warning
	
	bodyque_head = spawn();
	bodyque_head.classname = "bodyque";
	bodyque_head.owner = spawn();
	bodyque_head.owner.classname = "bodyque";
	bodyque_head.owner.owner = spawn();
	bodyque_head.owner.owner.classname = "bodyque";
	bodyque_head.owner.owner.owner = spawn();
	bodyque_head.owner.owner.owner.classname = "bodyque";
	bodyque_head.owner.owner.owner.owner = bodyque_head;
};


// make a body que entry for the given ent so the ent can be
// respawned elsewhere
void(entity ent) CopyToBodyQue =
{
	bodyque_head.angles = ent.angles;
	bodyque_head.model = ent.model;
	bodyque_head.modelindex = ent.modelindex;
	bodyque_head.frame = ent.frame;
	bodyque_head.colormap = ent.colormap;
	bodyque_head.movetype = ent.movetype;
	bodyque_head.velocity = ent.velocity;
	bodyque_head.flags = 0;
	setorigin (bodyque_head, ent.origin);
	setsize (bodyque_head, ent.mins, ent.maxs);
	bodyque_head = bodyque_head.owner;
};


