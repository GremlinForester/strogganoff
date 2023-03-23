/*
Based on the battleMETAL menu and metal-lib library by Peter Roohr 
and adapted for Q2DP by MrC (so if it's broke you know who to blame).
Date: 12/18/2022
Overview:
  menu definition file
  NEW GAME MENU
*/

//Main Menu Globals
entity new_title;
entity new_novice;
entity new_regular;
entity new_veteran;
entity new_elite;
entity new_back;

float newgame_substate;

string TRAINING_LABEL;

//Main Menu Constants
#define NEWGAME_CAMPAIGN 1
#define NEWGAME_SKILL 2
#define NEWGAME_BRIEF 3

#define IMG_NEW_TITLE "gfx/menu/newgame/new_title.png"

#define NEWGAME_ROLL_ROK 1
#define NEWGAME_ROLL_REG 2
#define NEWGAME_ROLL_VET 3
#define NEWGAME_ROLL_ACE 4

//Campaign Maps
entity new_camp_lbl;
entity new_camp_start_lbl;
entity new_camp_start_btn;

//button callbacks
//because we define these right before the menu functions are defined, we 
//don't have to put them in a header, and they can be 'somewhat' flexibily generated
void() click_newg_back =
{
	if( newgame_substate == NEWGAME_SKILL )
	{
		newgame_substate = NEWGAME_CAMPAIGN;
	}
	else if( newgame_substate == NEWGAME_BRIEF )
	{
		newgame_substate = NEWGAME_CAMPAIGN;
	}
	else
	{
		menu_clear_items(M_STATE);
		m_main_f();
		//m_newsave_f();
		localsound("sound/misc/menu2.wav");
		cvar_set("cl_newgameplus", "0");
	}
};

void() click_newg_launch_map =
{  
	/*
	if( GAME_SAVES_NEWG[cvar("saveslot")] == FALSE )
	{
		menu_write_new_save();
	}
	*/
	
	menu_clear_items(M_STATE);
	menu_exit_togame();
	localcmd("deathmatch 0\n");
	localcmd("teamplay 0\n");
	localcmd("coop 0\n");
	localcmd("cd stop\n");
	localcmd("maxplayers 1\n");
	localcmd("sv_hub_state 0\n");	
	
	/*
	if( GAME_SAVES_NEWG[cvar("saveslot")] )
	{
		localcmd("map o1m1\n"); 
	}
	else
	{
		localcmd(strcat("map ", self.data_text,"\n")); 
	}
	*/
	
	localcmd(strcat("map ", self.data_text,"\n")); 
  
	freeGlobalString(CAMP_SELECT_START);
	freeGlobalString(CAMP_SELECT_INFO);
	freeGlobalString(CAMP_SELECT_NAME);
	freeGlobalString(CAMP_SELECT_IMAGE);
};

/*
  Sub-Menu: Campaign Briefing
  allow player to skip training here.
*/
void() click_newg_info={
  newgame_substate = NEWGAME_BRIEF;
  new_camp_lbl.label = CAMP_SELECT_NAME;
  
  new_camp_start_btn.data_text = CAMP_SELECT_START;
  new_camp_start_btn.drawme = TRUE;
};


void() click_newg_novice={
  cvar_set("skill", "0");
  click_newg_info();
};

void() click_newg_regular={
  cvar_set("skill", "1");
  click_newg_info();
};

void() click_newg_veteran={
  cvar_set("skill", "2");
  click_newg_info();
};

void() click_newg_elite={
  cvar_set("skill", "3");
  click_newg_info();
};

void() click_newg_campaign={
  newgame_substate = NEWGAME_SKILL;
  
  cacheGlobalString(CAMP_SELECT_START, CAMP_START[self.data_bind])
  cacheGlobalString(CAMP_SELECT_NAME, CAMP_NAME[self.data_bind])
  cacheGlobalString(CAMP_SELECT_INFO, CAMP_INFO[self.data_bind])
  cacheGlobalString(CAMP_SELECT_IMAGE, CAMP_IMAGE[self.data_bind])  
};

void() m_newg_back =
{
	local float offset_from_bottom = 48;
	
    local string lbl = "BACK";
	local float lblLen = stringwidth(lbl, 0, '32 32 0');
  
	local vector lowerLeft = VIEW_ORG;
	lowerLeft_y = lowerLeft_y + VIEW_MAX_y - offset_from_bottom;
	lowerLeft_x = lowerLeft_x + 24;
  
	//LOWER LEFT
	new_back = btn_text_callback(lowerLeft, '32 32', "BACK", VIEW_LFT, M_NEWGAME, click_newg_back, CLR_MENU_BLUE, '0 1 0', 1, UI_FLAG_SIZE_IMG);
	//new_back = btn_text_callback(lowerLeft, '32 32', "BACK", VIEW_LFT, M_NEWGAME, click_newg_back, CLR_MENU_BLUE, '0 1 0', 1, UI_FLAG_SIZE_IMG);
	new_back.fontId = FONT_NUM_BLACKOPS_BOLD;	
}

void() click_newg_skill={
  newgame_substate = NEWGAME_SKILL;
};

void() m_newg_header =
{
  new_title = lbl_text_centered(ANCHOR_UPPER_CENTER + '0 20', '44 44', "NEW GAME", CLR_DEF_TXT_GRAY_SMOOTH, 0, M_NEWGAME, 1, 0);
  new_title.fontId = FONT_NUM_BLACKOPS_BOLD;
  new_title = lbl_img(new_title.origin + '95 -10', '1 1 0', IMG_SUBMENUHEADER_BG, '1 1 1', VIEW_CTX, M_NEWGAME, 1, UI_FLAG_SIZE_IMG );
}

// ini functions
void() m_newg_i =
{
	local vector start;
	local float itr;
	local float actual;
	local entity list;
	local vector next;
  
	//menu_parent_setup(VIEW_ORG + '160 70', '100 100');
	menu_parent_setup(VIEW_ORG + '160 70', '160 200');
  
  	m_newg_header();
 
	newgame_substate = NEWGAME_CAMPAIGN;

	//SUB-MENU: SKILL SELECT
	new_novice = btn_text_callback_centered(ANCHOR_CENTER + '0 -100', '32 32', "NOVICE", 0, M_NEWGAME, click_newg_novice, CLR_DEF_TXT_GRAY_SMOOTH, CLR_DEF_BLUE, 1, UI_FLAG_SIZE_IMG);
	new_novice.fontId = FONT_NUM_BLACKOPS_BOLD;
  
	new_regular = btn_text_callback_centered(ANCHOR_CENTER + '0 -50', '32 32', "REGULAR", 0, M_NEWGAME, click_newg_regular, CLR_DEF_TXT_GRAY_SMOOTH, CLR_DEF_GREEN, 1, UI_FLAG_SIZE_IMG);
	new_regular.fontId = FONT_NUM_BLACKOPS_BOLD;
  
	new_veteran = btn_text_callback_centered(ANCHOR_CENTER, '32 32', "VETERAN", 0, M_NEWGAME, click_newg_veteran, CLR_DEF_TXT_GRAY_SMOOTH, CLR_DEF_ARM_THREEQ, 1, UI_FLAG_SIZE_IMG);
	new_veteran.fontId = FONT_NUM_BLACKOPS_BOLD;
  
	new_elite = btn_text_callback_centered(ANCHOR_CENTER + '0 50', '32 32', "ELITE", 0, M_NEWGAME, click_newg_elite, CLR_DEF_TXT_GRAY_SMOOTH, CLR_DEF_RED, 1, UI_FLAG_SIZE_IMG);
	new_elite.fontId = FONT_NUM_BLACKOPS_BOLD;
	
	new_novice.subid = NEWGAME_SKILL;
	new_regular.subid = NEWGAME_SKILL;
	new_veteran.subid = NEWGAME_SKILL;
	new_elite.subid = NEWGAME_SKILL;
  
	//SUB-MENU: TRAINING SELECT
	//new_camp_lbl = lbl_text(MENU_ORG + '10 45', '14 14', CAMP_SELECT_NAME, '1 1 1', 0, M_NEWGAME, 1, 0);
	new_camp_lbl = lbl_text(ANCHOR_CENTER_UL + '0 0', '14 14', CAMP_SELECT_NAME, CLR_MENU_BLUE, 0, M_NEWGAME, 1, 0);
	new_camp_lbl.subid = NEWGAME_BRIEF;
  
	//new_camp_train_lbl = lbl_text(MENU_ORG + '10 64', '12 12', CAMP_SELECT_INFO, CLR_DEF_ARM_THREEQ, 0, M_NEWGAME, 1, 0);
	//new_camp_train_lbl.subid = NEWGAME_BRIEF;
	//new_camp_train_lbl.drawme = FALSE;
  
	new_camp_start_lbl = lbl_text(MENU_ORG + '10 83', '12 12', "Otherwise click START to skip training and begin the game:", CLR_DEF_ARM_THREEQ, 0, M_NEWGAME, 1, 0);
	new_camp_start_lbl.subid = NEWGAME_BRIEF;
	new_camp_start_lbl.drawme = FALSE;
  
	//new_camp_start_btn = btn_text_callback(MENU_ORG + menu_parent_center_width(121), '14 14', ">START CAMPAIGN<", VIEW_CTX, M_NEWGAME, click_newg_launch_map, CLR_DEF_TXT_GRAY_SMOOTH, CLR_DEF_GREEN, 1, UI_FLAG_SIZE_IMG);
	new_camp_start_btn = btn_text_callback(ANCHOR_LOWER_RIGHT + '-64 -48', '32 32', "LAUNCH", VIEW_CTX, M_NEWGAME, click_newg_launch_map, CLR_MENU_BLUE, CLR_DEF_GREEN, 1, UI_FLAG_SIZE_IMG);
	new_camp_start_btn.fontId = FONT_NUM_BLACKOPS_BOLD;
	new_camp_start_btn.subid = NEWGAME_BRIEF;
	new_camp_start_btn.drawme = FALSE;
	new_camp_start_btn.data_text = CAMP_SELECT_START;

	//SUB-MENU: CAMPAIGN SELECT
	itr = 1;
  
	if(CAMP_NAME[itr] != "")
	{
		start = ANCHOR_CENTER_UL;
		while (itr < CAMP_TOTAL )
		{
			if( CAMP_NAME[itr] != "" )
			{
				next = start;
				next_y = next_y + ( (itr-1) * 20);
				list = btn_text_callback(next, '14 14', CAMP_NAME[itr], 0, M_NEWGAME, click_newg_campaign, CLR_DEF_WHITE, CLR_DEF_GREEN, 1, UI_FLAG_SIZE_IMG);
				list.data_bind = itr; //databind
				list.subid = NEWGAME_CAMPAIGN;
				actual = actual + 1;
			}
			itr = itr + 1;
		}
	}
 
	m_newg_back();
};

/*
  menu_f functions are like state-transition functions, preparing the menu for the next menu to load
*/
void() m_newg_f =
{
	updateAnchorPos();
	DRAW_MOUSE = TRUE;
	M_STATE = M_NEWGAME;
	setkeydest(KEY_MENU);
	m_newg_i();
};

string m_newgame_brief_bg;

/*
  menu_d functions are the render functions, inside m_draw, there's a select case
  running on M_STATE to determine which menu_d to execute.
*/
void() m_newg_d =
{
	local entity widget;
  
	local string new_novice_desc = "I'm new around here.";
	local string new_regular_desc = "I've fired a couple of guns.";
	local string new_veteran_desc = "I'm your backup.";
	local string new_elite_desc = "I am death incarnate.";

	if( newgame_substate == NEWGAME_SKILL )
	{
		if (new_novice.rolledover)
		{
			gui_renderString(new_novice_desc, (ANCHOR_LOWER_CENTER + '0 -90' - Vector2(stringwidth(new_novice_desc, 0, '16 16'),0)/2), CLR_DEF_TXT_NONSELECT, '16 16', 1, 0);
		}
		
		if (new_regular.rolledover)
		{
			gui_renderString(new_regular_desc, (ANCHOR_LOWER_CENTER + '0 -90' - Vector2(stringwidth(new_regular_desc, 0, '16 16'),0)/2), CLR_DEF_TXT_NONSELECT, '16 16', 1, 0);
		}
		
		if (new_veteran.rolledover)
		{
			gui_renderString(new_veteran_desc, (ANCHOR_LOWER_CENTER + '0 -90' - Vector2(stringwidth(new_veteran_desc, 0, '16 16'),0)/2), CLR_DEF_TXT_NONSELECT, '16 16', 1, 0);
		}

		if (new_elite.rolledover)
		{
			gui_renderString(new_elite_desc, (ANCHOR_LOWER_CENTER + '0 -90' - Vector2(stringwidth(new_elite_desc, 0, '16 16'),0)/2), CLR_DEF_TXT_NONSELECT, '16 16', 1, 0);
		}
	}
	else if( newgame_substate == NEWGAME_BRIEF)
	{
		//new_camp_start_lbl.origin_y = MENU_ORG_y + gui_wrapText(MENU_ORG + '10 64', '400 300', CAMP_SELECT_INFO, '12 12', CLR_DEF_ARM_THREEQ, 1) + 78;
		drawpic(ANCHOR_UPPER_LEFT, m_newgame_brief_bg, Vector2(VIEW_MAX_x, VIEW_MAX_y), '1 1 1', 1, 0);
		gui_renderPatch9_1_32(ANCHOR_CENTER_UL, '400 300', '0.0 0.0 0.0', 0.5, 0);
		new_camp_start_lbl.origin_y = MENU_ORG_y + gui_wrapText(ANCHOR_CENTER_UL + '0 20', '400 300', CAMP_SELECT_INFO, '12 12', '1 1 1', 1) + 78;
		
	}
	else
	{
		//drawpic(MENU_ORG + '300 60', "gfx/menu/nosignal.png", '256 256', '1 1 1', 0.75, 0);
		drawpic(ANCHOR_CENTER + '33 -110', "gfx/menu/nosignal.png", '256 256', '1 1 1', 0.75, 0);
		
//		drawfont = FONT_NUM_ROBOT_LIGHT;
//			gui_wrapText(MENU_ORG + '450 145', '350 300', "NO SIGNAL", '14 14', '1 1 0.1', 1);
		
		drawfont_prev = drawfont;
		drawfont = FONT_NUM_ROBOT_REGULAR;
		drawstring(MENU_ORG + '120 40', "Select a Mission", '14 14', '1 1 1', 1, 0);
		drawfont = drawfont_prev;
	}
  
  for( widget = findchainfloat(menuId, M_NEWGAME); widget != null_entity; widget = widget.chain){
    if( widget.subid == FALSE){
      widget.draw(widget);
    }
    else if( widget.subid == newgame_substate){
      widget.draw(widget);
      if( widget.subid == NEWGAME_CAMPAIGN && widget.data_bind > 0 ){
        
        if( menu_checkMouseInBounds(VIEW_MPOS, widget.drawOrg, widget.drawSize))
		{
		//IMAGE (should change a global)
		m_newgame_brief_bg = CAMP_IMAGE[widget.data_bind];
		drawpic(ANCHOR_CENTER + '33 -110', CAMP_IMAGE[widget.data_bind], '256 256', '1 1 1', 1, 0);

		drawfont_prev = drawfont;
		
		drawfont = FONT_NUM_BLACKOPS_REG;
			drawstring(MENU_ORG + '300 60', CAMP_NAME[widget.data_bind], '16 16', '1 1 1', 1, 0);
		
		drawfont = FONT_NUM_ROBOT_REGULAR;
			drawstring(MENU_ORG + '300 45', strcat("Author: ", CAMP_AUTH[widget.data_bind]), '14 14', '1 1 1', 1, 0);
		
		drawfont = FONT_NUM_ROBOT_LIGHT;
			gui_wrapText(MENU_ORG + '300 30', '350 300', CAMP_DESC[widget.data_bind], '14 14', '1 1 0.1', 1);
		
		drawfont = drawfont_prev;
        }
      }
    }
  }
};

/*
  menu_k functions are the 'listener' functions
*/
void(float key, float ascii) m_newg_k={
  switch(key){
    case K_ESCAPE:
      if(newgame_substate == NEWGAME_SKILL){
        newgame_substate = NEWGAME_CAMPAIGN;
      }
      if(newgame_substate == NEWGAME_BRIEF ){
        newgame_substate = NEWGAME_CAMPAIGN;
      }
      else{
        localsound("sound/misc/menu2.wav");
        menu_clear_items(M_STATE);
        m_camp_f();
        freeGlobalString(TRAINING_LABEL)
      }
      break;
  }
};