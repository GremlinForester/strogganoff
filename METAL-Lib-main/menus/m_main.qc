/*
Based on the battleMETAL menu and metal-lib library by Peter Roohr 
and adapted for Q2DP by MrC (so if it's broke you know who to blame).
Date: 12/20/2022
Overview: 
  definition file for a menu ui.
  
  basically I'm mimicking the DP source architecture on this one cause there's no documentation
on how to use menu.dat. 
*/

entity main_junk;

entity main_title;
entity main_title2;

/*
entity main_title;
entity main_title2;
entity main_title_infantry;
//entity main_label;
entity main_leave;
entity main_camp;
//entity main_training;
entity main_options;
entity main_multi;
entity main_help;
entity main_credits;
entity main_quit;

entity main_player_options; //link to player options during network play

entity main_save; //updates .sav file pointed to in .mission file
//entity main_restart; //restart current mission (runs kill)
*/

//Main Menu Constants
string IMG_MULTI_PLAYERSETUP   = "gfx/menu/multi/multi_playersetup.png";
string IMG_MAIN_TITLE  = "gfx/menu/menu_main_header.png";
string IMG_MAIN_TITLE2  = "gfx/menu/menu_main_header3.png";
string IMG_MAIN_PAUSE  = "gfx/pause.png";
string IMG_MAIN_LBL    = "gfx/menu/main/main_label.png";

string IMG_MAIN_LEAVE = "gfx/menu/quit_mission.png";

string IMG_TITLE;
//string IMG_QUIT;

//Rollover callbacks
void() playersetupRollOver =
{
//Nothing happens. Roll again.
}

//Rollover callbacks
void() playersetupRollOverExit =
{
//Nothing happens.
}

//Main callbacks
//because we define these right before the menu functions are defined, we 
//don't have to put them in a header, and they can be 'somewhat' flexibily generated
void() click_main_camp={
  menu_clear_items(M_STATE);
  M_STATE = M_SINGLE;
  m_camp_f();
};

void() click_main_train={
  menu_clear_items(M_STATE);
  M_STATE = M_TRAINING;
  m_train_f();
};

void() click_main_multi={
  menu_clear_items(M_STATE);
  M_STATE = M_MULTI;
  m_multi_f();
};

void() click_main_quit={
  menu_clear_items(M_STATE);
  localcmd("quit\n");
};

void() click_main_options={
  menu_clear_items(M_STATE);
  M_STATE = M_OPTIONS;
  m_options_f();
};

void() click_main_help={
  menu_clear_items(M_STATE);
  M_STATE = M_HELP;
  m_help_f();
};

void() click_main_credits={
  menu_clear_items(M_STATE);
  M_STATE = M_CREDITS;
  m_credits_f();
};

void() click_main_leave={
  menu_clear_items(M_STATE);
  M_STATE = M_MAIN;
  MAIN_MISSION = FALSE;
  m_main_f();
  cvar_set("sv_public", "-2");
  cvar_set("deathmatch", "0");
  cvar_set("teamplay", "0");
  cvar_set("coop", "0");
  cvar_set("sv_serverflags", "0");  //accounts for player-hosted servers rather than using dedicated hosting.
  localcmd("maxplayers 1;\n");
  localcmd("disconnect;\n");
  localcmd("togglemenu;\n");
  localcmd("cd play 2;\n");
  cvar_set("cl_newgameplus", "0");
};

void() click_main_player_setup={
  menu_clear_items(M_STATE);
  m_setup_f();
};

void() click_main_save={
  menu_clear_items(M_STATE);
  m_newsave_f();
};

// ini functions
void() m_main_i={
  local vector orgOptions;
  local vector orgHelp;
  local vector orgQuit;
  local float mainTitleFlag;
  local float spacing = 100;  
  local float spacer = 40;//35
  
  gui_set_screen_size();  //ugh
  
  updateAnchorPos();
  
  if( MAIN_MISSION && !isdemo()){
    menu_parent_setup(VIEW_ORG + '75 100', '208 256');
    
    IMG_TITLE = IMG_MAIN_PAUSE;
    mainTitleFlag = UI_FLAG_SIZE_IMG;

	if (!(cvar("coop") || cvar("deathmatch")))
	main_junk = btn_text_callback(MENU_ORG + menu_parent_center_width(spacing), '40 40', "SAVE", VIEW_CTX, M_MAIN, click_main_save, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, UI_FLAG_SIZE_IMG);
    main_junk.fontId = FONT_NUM_BLACKOPS_BOLD;

    main_junk = btn_text_callback(MENU_ORG + menu_parent_center_width(spacing+=spacer), '40 40', "PLAYER SETUP", VIEW_CTX, M_MAIN, click_main_player_setup, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, UI_FLAG_SIZE_IMG);
    main_junk.fontId = FONT_NUM_BLACKOPS_BOLD;
    
    orgOptions = MENU_ORG + menu_parent_center_width(spacing+=spacer);
    
    orgHelp = MENU_ORG + menu_parent_center_width(spacing+=spacer);
		
    main_junk = btn_text_callback(MENU_ORG + menu_parent_center_width(spacing+=spacer), '40 40', "LEAVE", VIEW_CTX, M_MAIN, click_main_leave, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, UI_FLAG_SIZE_IMG);
    main_junk.fontId = FONT_NUM_BLACKOPS_BOLD;
    
    orgQuit = MENU_ORG + menu_parent_center_width(spacing+=spacer);	
    
//    main_label = lbl_img(MENU_ORG + menu_parent_center_width(5), '1 1', IMG_TITLE, '1 1 1', VIEW_CTX, M_MAIN, 1, mainTitleFlag );
    /*
    main_player_options = btn_text_callback(MENU_ORG + menu_parent_center_width(135), '40 40', "PLAYER SETUP", VIEW_CTX, M_MAIN, click_main_player_setup, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, UI_FLAG_SIZE_IMG);
    main_player_options.fontId = FONT_NUM_BLACKOPS_BOLD;
    
    orgOptions = MENU_ORG + menu_parent_center_width(170);
    
    orgHelp = MENU_ORG + menu_parent_center_width(205);
		
    main_leave = btn_text_callback(MENU_ORG + menu_parent_center_width(240), '40 40', "LEAVE", VIEW_CTX, M_MAIN, click_main_leave, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, UI_FLAG_SIZE_IMG);
    main_leave.fontId = FONT_NUM_BLACKOPS_BOLD;
    
    orgQuit = MENU_ORG + menu_parent_center_width(275);
	*/
  }
  else
  {
    menu_parent_setup(VIEW_ORG + '75 75', '208 256');

//    IMG_TITLE = IMG_MAIN_LBL;
    mainTitleFlag = UI_FLAG_SIZE_IMG;
//    main_title = lbl_img(MENU_ORG + menu_parent_center_width(10) + '-20 -20', '2.5 2.5 0', IMG_MAIN_TITLE, '1 1 1', VIEW_CTX, M_MAIN, 1, UI_FLAG_SIZE_IMG );
	main_junk = lbl_img_overlay(MENU_ORG + menu_parent_center_width(10) + '-20 -20', '2.5 2.5 0', IMG_MAIN_TITLE2, '1 1 1', VIEW_CTX, M_MAIN, 1, UI_FLAG_SIZE_IMG, 1 );
	main_junk = lbl_img(MENU_ORG + menu_parent_center_width(10) + '-20 -20', '2.5 2.5 0', IMG_MAIN_TITLE, '1 1 1', VIEW_CTX, M_MAIN, 1, UI_FLAG_SIZE_IMG);
    
	//main_junk = lbl_img(MENU_ORG + menu_parent_center_width(10) + '415 185', '1 1 0', "gfx/menu/main_infantry.png", '1 1 1', VIEW_CTX, M_MAIN, 1, UI_FLAG_SIZE_IMG);
	//main_junk = lbl_img(ANCHOR_LOWER_RIGHT + '-175 -212', '1 1 0', "gfx/menu/main_infantry.png", '1 1 1', VIEW_CTX, M_MAIN, 1, UI_FLAG_SIZE_IMG);


//    main_label = lbl_img(MENU_ORG + menu_parent_center_width(60), '1 1', IMG_TITLE, '1 1 1', VIEW_CTX, M_MAIN, 1, mainTitleFlag );
    
//    main_training = btn_text_callback(MENU_ORG + menu_parent_center_width(100), '40 40', "TRAINING", VIEW_CTX, M_MAIN, click_main_train, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, UI_FLAG_SIZE_IMG);
//    main_training.fontId = FONT_NUM_BLACKOPS_BOLD;

//    main_player_options = btn_text_callback(MENU_ORG + menu_parent_center_width(spacing), '40 40', "PLAYER SETUP", VIEW_CTX, M_MAIN, click_main_player_setup, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, UI_FLAG_SIZE_IMG, playersetupRollOver);
//    main_player_options.fontId = FONT_NUM_BLACKOPS_BOLD;
    
    main_junk = btn_text_callback(MENU_ORG + menu_parent_center_width(spacing+=spacer), '40 40', "SINGLE PLAYER", VIEW_CTX, M_MAIN, click_main_camp, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, (UI_FLAG_NOLABEL | UI_FLAG_SIZE_IMG));
    main_junk.fontId = FONT_NUM_BLACKOPS_BOLD;
    
    main_junk = btn_text_callback(MENU_ORG + menu_parent_center_width(spacing+=spacer), '40 40', "MULTIPLAYER", VIEW_CTX, M_MAIN, click_main_multi, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, (UI_FLAG_NOLABEL | UI_FLAG_SIZE_IMG));
    main_junk.fontId = FONT_NUM_BLACKOPS_BOLD;
    
    orgOptions = MENU_ORG + menu_parent_center_width(spacing+=spacer);
    orgHelp = MENU_ORG + menu_parent_center_width(spacing+=spacer);
    
    main_junk = btn_text_callback(MENU_ORG + menu_parent_center_width(spacing+=spacer), '40 40', "CREDITS", VIEW_CTX, M_MAIN, click_main_credits, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, (UI_FLAG_NOLABEL | UI_FLAG_SIZE_IMG));
    main_junk.fontId = FONT_NUM_BLACKOPS_BOLD;
    
    orgQuit = MENU_ORG + menu_parent_center_width(spacing+=spacer);
    
  }
  
  main_junk = btn_text_callback(orgOptions, '40 40', "OPTIONS", VIEW_CTX, M_MAIN, click_main_options, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, (UI_FLAG_NOLABEL | UI_FLAG_SIZE_IMG));
  main_junk.fontId = FONT_NUM_BLACKOPS_BOLD;
  
	main_junk = btn_text_callback(orgHelp, '40 40', "README!", VIEW_CTX, M_MAIN, click_main_help, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, (UI_FLAG_NOLABEL | UI_FLAG_SIZE_IMG));
	main_junk.fontId = FONT_NUM_BLACKOPS_BOLD;
  
  main_junk = btn_text_callback(orgQuit, '40 40', "QUIT", VIEW_CTX, M_MAIN, click_main_quit, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, (UI_FLAG_NOLABEL | UI_FLAG_SIZE_IMG));
  main_junk.fontId = FONT_NUM_BLACKOPS_BOLD;
  

};

/*
  menu_f functions are like state-transition functions, preparing the menu for the next menu to load
*/
void() m_main_f={
  DRAW_MOUSE = TRUE;
  M_STATE = M_MAIN;
  setkeydest(KEY_MENU);
  m_main_i();
};

/*
  menu_d functions are the render functions, inside m_draw, there's a select case
  running on M_STATE to determine which menu_d to execute.
*/
void() m_main_d = 
{
  local entity widget;
  
  widget = findchainfloat(menuId, M_MAIN);
  while(widget){
    widget.draw(widget);
    widget = widget.chain;
  }
};

/*
  menu_k functions are the 'listener' functions
*/
void(float key, float ascii) m_main_k={
  //cons_logAFloat("m_main_k.key", key);  //DEBUG
  //cons_logAFloat("m_main_k.ascii", ascii);  //DEBUG   
  
  switch(key){
    case K_ESCAPE:
      menu_clear_items(M_STATE);
      menu_exit_togame();
      break;
  }
};