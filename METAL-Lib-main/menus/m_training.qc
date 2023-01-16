/*
Based on the battleMETAL menu and metal-lib library by Peter Roohr 
and adapted for Q2DP by MrC (so if it's broke you know who to blame).
Date: 12/20/2022
Overview: training menu
*/

#define TRAIN_HEROSHOT_IMAGE "gfx/menu/menu_hero_train.png"

//Training Menu globals
entity train_title;
entity train_move_btn;
//entity train_shoot_btn;
//entity train_brieft_btn;
entity train_heroshot;

entity train_back_btn;

//funcs
void( string mapName ) train_click_launch={
  menu_clear_items(M_STATE);
  menu_exit_togame();
  localcmd("deathmatch 0\n");
  localcmd("teamplay 0\n");
  localcmd("coop 0\n");
  localcmd("cd stop\n");
  localcmd("maxplayers 1\n");
  localcmd(strcat("map ", mapName,"\n")); 
};

void() click_train_back={
  menu_clear_items(M_STATE);
  m_camp_f();
  localsound("sound/misc/menu2.wav");
};

//callbacks
void() click_train_boot =
{
	train_click_launch( "q2dp_training" );
};

void() m_train_header =
{
  train_title = lbl_text_centered(ANCHOR_UPPER_CENTER + '0 20', '44 44', "TRAINING", CLR_DEF_TXT_GRAY_SMOOTH, 0, M_TRAINING, 1, 0);
  train_title.fontId = FONT_NUM_BLACKOPS_BOLD;
  train_title = lbl_img(train_title.origin + '90 -10', '1 1 0', IMG_SUBMENUHEADER_BG, '1 1 1', VIEW_CTX, M_TRAINING, 1, UI_FLAG_SIZE_IMG );
}

void() m_train_back =
{
	train_back_btn = btn_text_callback(ANCHOR_LOWER_LEFT + '25 -50', '32 32', "BACK", VIEW_LFT, M_TRAINING, click_train_back, CLR_MENU_BLUE, '0 1 0', 1, UI_FLAG_SIZE_IMG);
	train_back_btn.fontId = FONT_NUM_BLACKOPS_BOLD;	
}

// ini function, called by '_f' function as a setup func
void() m_train_i =
{
	m_train_header();
	
	menu_parent_setup(ANCHOR_CENTER + '-136 -128', '272 256');
  
	train_move_btn = btn_text_callback(ANCHOR_CENTER + '25 90', '32 32', "Enter Boot Camp", VIEW_CTX, M_TRAINING, click_train_boot, CLR_MENU_BLUE, CLR_DEF_GREEN, 1, UI_FLAG_SIZE_IMG);
	train_move_btn.fontId = FONT_NUM_BLACKOPS_BOLD;
  
	m_train_back();
	
	train_heroshot = lbl_img(ANCHOR_LOWER_CENTER + '0 -256', '512 256 0', TRAIN_HEROSHOT_IMAGE, '1 1 1', VIEW_CTX, M_TRAINING, 1, 0);
	//train_back_btn = btn_text_callback(MENU_ORG + '40 225', '16 16', "BACK", VIEW_CTX, M_TRAINING, click_train_back, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, UI_FLAG_SIZE_IMG);
	//train_back_btn.fontId = FONT_NUM_BLACKOPS_BOLD;
};


/*
  menu_f functions are like state-transition functions, preparing the menu for the next menu to load
*/
void() m_train_f = 
{
	DRAW_MOUSE = TRUE;
	M_STATE = M_TRAINING;
	setkeydest(KEY_MENU);
	m_train_i();
};


/*
  menu_d functions are the render functions, inside m_draw, there's a select case
  running on M_STATE to determine which menu_d to execute.
*/
void() m_train_d={
  local entity widget;
  
  //gui_renderPatch9_1_32(MENU_ORG, MENU_SIZE, '0.35 0.35 0.55', 0.85, 0);
  gui_renderPatch9_1_32(MENU_ORG + '0 -500', '272 2048', '0.35 0.35 0.35', 0.35, 0);
  
  widget = findchainfloat(menuId, M_TRAINING);
  while(widget){
    widget.draw(widget);
    widget = widget.chain;
  }
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
    gui_wrapText(MENU_ORG + '20 45', '265 300', "This boot camp is for new and experienced players alike (mostly new) and will cover movement and combat mechanics to ensure you don't end up another Strogg.", '14 14', '1 1 1', 1);
  drawfont = drawfont_prev;
};

/*
  menu_k functions are the 'listener' functions
*/
void(float key, float ascii) m_train_k={
  //cons_logAFloat("m_camp_k.key", key);  //DEBUG
  //cons_logAFloat("m_camp_k.ascii", ascii);  //DEBUG   
  
  switch(key){
    case K_ESCAPE:
      //note how this is different than m_main_k, here we just want to go 'up' one
      //menu and not leave the menu system
      localsound("sound/misc/menu2.wav");
      menu_clear_items(M_STATE);
      m_camp_f();
      break;
  }
};