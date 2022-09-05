/*

client/main.qc

Code entry points for CSQC

*/


//MrC: Some temporary empty functions so things compile for now.

void()main={};
void()StartFrame={};
void()PlayerPreThink={};
void()PlayerPostThink={};
void()ClientKill={};
void()ClientConnect={};
void()PutClientInServer={};
void()ClientDisconnect={};
void()SetNewParms={};
void()SetChangeParms={};
void(entity targ, entity inflictor, entity attacker, float damage) T_Damage = {};
float(entity e, float healamount, float ignore) T_Heal = {};
float(entity targ, entity inflictor) CanDamage = {};
float (entity targ) visible = {};

var float autocvar_hud_mapname = 1;
var float autocvar_waterfog = 0;
	
//-----------------------------------------------------------------------------
// Init
//-----------------------------------------------------------------------------
void() CSQC_Init =
{
//	Sbar_Init();
	Hud_Init();
	
	g_nVideoWidth = cvar("vid_conwidth");
	g_nVideoHeight = cvar("vid_conheight");

	if (autocvar_hud_mapname)
	{
		HUD_PrepareMapDisplayName();
		HUD_BeginMapNameDisplay();
	}
	
	if (cvar("r_editlights") && cvar("sv_cheats"))
	{
		localcmd("god");
		localcmd("notarget");
	}
	increment = 1;
	
	mouse = cvar("sensitivity");
	if (!mouse)	cvar_set("sensitivity", "3");
};

//-----------------------------------------------------------------------------
// Shutdown
//-----------------------------------------------------------------------------
void() CSQC_Shutdown =
{
//	Sbar_Shutdown();
	cvar_set("sensitivity", ftos(mouse));
};

//-----------------------------------------------------------------------------
// ConsoleCommand
//-----------------------------------------------------------------------------
float(string s) CSQC_ConsoleCommand =
{
	return FALSE;
};


void() CSQC_UpdateView =
{
	vid_conwidth = cvar("vid_conwidth");
	vid_conheight = cvar("vid_conheight");
	
	R_ClearScene();

	R_AddEntities(MASK_NORMAL | MASK_ENGINE | MASK_ENGINEVIEWMODELS);
	R_SetView(VF_DRAWWORLD, 1);
	R_SetView(VF_DRAWCROSSHAIR, 1);

	R_RenderScene();	
	
	if (showscores)
	{
	//	if (deathmatch){
	//		Hud_DeathmatchScoreboard(vid_conwidth, vid_conheight);
	//	}
				
		Hud_Draw(2, 1, vid_conwidth, vid_conheight);
	}
	else
	{
		Hud_Draw(2, 0, vid_conwidth, vid_conheight);
	}
	
	if (intermission){
		drawstring('0 0 0', "Intermission!", '8 8 0', '0 0 1', 1, 0);
		cvar_set("sensitivity", "0");			// disable mouselook
		viewpos = getentityvec(player_localentnum, E_ORIGINANDVECTORS);
		viewang = vectoangles2(v_forward, v_up);
		viewang_x = - viewang_x;

		viewang_x = viewang_x + sin(time * 0.5) * 0.75;	// camera sway
		viewang_y = viewang_y + sin(time * 1) * 0.75;
		viewang_z = viewang_z + sin(time * 0.25) * 0.25;
		R_SetView(VF_ORIGIN, viewpos);
		R_SetView(VF_ANGLES, viewang);

		R_RenderScene(); //so the view sways?

		Hud_Draw(3, 0, vid_conwidth, vid_conheight);	
	}

	if (cvar("r_editlights")){				
		rt_lights_editor_help();
	}
	
	if ((g_fMapNameDisplayState)&&(!intermission)&&(!showscores))	HUD_UpdateMapNameDisplay();
	if (waterfog)					   		UpdateFluidContents(true);
	
	/*
	if ((intermission && !finale) || finale == 1)
	{
		if (finale == 1) finale = 2;
		cvar_set("sensitivity", "0");			// disable mouselook
		viewpos = getentityvec(player_localentnum, E_ORIGINANDVECTORS);
		viewang = vectoangles2(v_forward, v_up);
		viewang_x = - viewang_x;

		viewang_x = viewang_x + sin(time * 0.5) * 0.75;	// camera sway
		viewang_y = viewang_y + sin(time * 1) * 0.75;
		viewang_z = viewang_z + sin(time * 0.25) * 0.25;

		R_SetView(VF_ORIGIN, viewpos);
		R_SetView(VF_ANGLES, viewang);
		Hud_Draw(0, 0, vid_conwidth, vid_conheight);
	}
	else if	(cvar("sensitivity"))	mouse = cvar("sensitivity");
	*/
//	R_RenderScene();	
	/*
	//finale sequence player entity position change check
	discrepancy = getpropertyvec(VF_ORIGIN) - getentityvec(player_localentnum, E_ORIGIN);
	if ((fabs(discrepancy_x)>100)||(fabs(discrepancy_y)>100)||(fabs(discrepancy_z)>100)) finale = 1;	
	*/
};

//-----------------------------------------------------------------------------
// InputEvent
//-----------------------------------------------------------------------------
float(float event, float parama) CSQC_InputEvent =
{
	if (cvar("r_editlights"))
		if (rt_lights_editor(event, parama)) return TRUE;
	/*
	if ( getkeybind(parama) == "itembar" )		// show/hide inventory
	{
		if (event == INPUT_KEYDOWN)
		{	
			if((cvar("viewsize") >= 100) && (cvar("viewsize") < 110))
			{
				cvar_set("viewsize", "110");
				return TRUE;
			}
			if((cvar("viewsize") >= 110) && (cvar("viewsize") < 120))
			{
				if ( ibar == 1 )
				{
					ibar = 0;
					return TRUE;
				}
				else if(ibar_flag) { ibar=1;   return TRUE; }
				else { cvar_set("viewsize", "100"); return TRUE; }
			}
			else return TRUE;
		}
	}
	*/
	/*
	// +- keys will put custom ibar between viewsizes [100-109)...[110-119) and reset below 100 cvar "viewsize" value to 100
	if ( getkeybind(parama) == "sizeup" )
	{
		if (event == INPUT_KEYDOWN)
		{		
			if((cvar("viewsize") >= 100) && (cvar("viewsize") < 110))
			{	ibar = 1; ibar_flag = 1; return FALSE;	}
			
			if((cvar("viewsize") >= 110) && (cvar("viewsize") < 120))
			{
				if(ibar_flag == 1) {ibar = 1; ibar_flag = 2; return TRUE;}
				if(ibar_flag == 2) {ibar = 0; ibar_flag = 0; return TRUE;}
				else return FALSE;
			}
			if((cvar("viewsize") < 100)) {cvar_set("viewsize", "100"); return TRUE;}
		}
	}
	if ( getkeybind(parama) == "sizedown" )
	{
		if (event == INPUT_KEYDOWN)
		{		
			if((cvar("viewsize") >= 110) && (cvar("viewsize") < 120))
			{
				if(ibar == 0) {ibar = 1; ibar_flag = 2; return TRUE;}
				else 
				{
					if (ibar_flag == 2 ) { ibar_flag = 1; ibar = 1; return TRUE; }
					if (ibar_flag == 1 ) { ibar_flag = 0; ibar = 0; return FALSE; }
				}
			}
			if((cvar("viewsize") < 110)) {cvar_set("viewsize", "100"); return TRUE;}
		}
	}
	*/
	// HUD/MENU size
	if ( getkeybind(parama) == "consizedown" )
	{
		if (event == INPUT_KEYDOWN)
		{	
			if ((cvar("vid_conwidth") > 320 ) && (cvar("vid_conwidth") <= 1280 )) cvar_set("vid_conwidth", ftos(cvar("vid_conwidth") - 80));
			else if (((cvar("vid_width")/cvar("vid_height")) <= (16/9)) && (cvar("vid_conwidth") > 1280 )) cvar_set("vid_conwidth", ftos( 1280 ));
			else 	cvar_set("vid_conwidth", ftos( 320 ));
			cvar_set("vid_conheight", ftos(cvar("vid_conwidth") * cvar("vid_height")/cvar("vid_width")));
			return TRUE;
		}
	}
	if ( getkeybind(parama) == "consizeup" )
	{
		if (event == INPUT_KEYDOWN)
		{	
			if ((cvar("vid_conwidth") < 1280 ) || ((cvar("vid_width")/cvar("vid_height")) > (16/9)))
				cvar_set("vid_conwidth", ftos(cvar("vid_conwidth") + 80));
			else cvar_set("vid_conwidth", ftos( 1280 ));
			cvar_set("vid_conheight", ftos(cvar("vid_conwidth") * cvar("vid_height")/cvar("vid_width")));
			return TRUE;	
		}
	}

	if (getkeybind(parama) == "+showscores")
	{
		if (event == INPUT_KEYDOWN)
		{
			showscores = TRUE;
			return FALSE;
		}
		if (event == INPUT_KEYUP)
		{
			showscores = FALSE;
			return FALSE;
		}
	}
	else return FALSE; 
};

/*
  Remember, the read order must exactly match the write order,
  so if you sent (changeFlags & SENDFLAG_ORIGIN), you MUST
    WriteCoord();
    WriteCoord();
    WriteCoord();
    
    which is then read IF (changeFlags & SENDFLAG_ORIGIN)
*/

void(float isnew, float changeFlags) sendent_handle_player_TEST={
  vector prevOrg;
  vector prevAngle;
  float prevDeadFlag;
   
  if( (changeFlags & SENDFLAG_ORIGIN) ){
    self.origin_x = ReadCoord();
    self.origin_y = ReadCoord();
    self.origin_z = ReadCoord();
  }
  
  if( (changeFlags & SENDFLAG_ANGLE) ){
    self.angles_x = ReadAngle();
    self.angles_y = ReadAngle();
    self.angles_z = ReadAngle();
  }
  
  if( (changeFlags & SENDFLAG_DEAD) ){
    self.deadflag = ReadByte();
  }
  
  if( (changeFlags & SENDFLAG_CHANGE_WEP) ){
    //change player weapon to this new one
  }
  
  if( (changeFlags & SENDFLAG_NEW_ENT) ){
    //stand up any new stuff
  }
  
  if( (changeFlags & SENDFLAG_ATTACK) ){
    //do player attack animation, etc
  }
  
};

/*
  parse a network update, isnew indicates this network slot was previously empty
  if you wish to do interpolation, be sure to make use the proper time variables: 
    time is previous packet time, 
    servertime is new packet time, 
  so the tick time between packets is servertime - time and the interpolation should begin 
  the new move at servertime and end at servertime + (servertime - time)
*/
void(float isNew) CSQC_Ent_Update={
  float entType;
  float entFlags;
  
  entType = ReadByte();
  entFlags = fabs(rint(ReadLong())); //expanding entFlags values -> data/common
  
  switch(entType){
    case SENDTYPE_PLAYER:
      //TEST
      sendent_handle_player_TEST( isNew, entFlags );
      break;
    case SENDTYPE_MONSTER:
      //TODO -  handle monster
      break;
    case SENDTYPE_PROJECTILE:
      //TODO -  handle projectiles
      break;
    case SENDTYPE_MISC_ENT:
	      //TODO -  handle misc. ents
      break;
    case SENDTYPE_MAP_OBJ:
      //TODO -  handle map objects
      break;
  }
};