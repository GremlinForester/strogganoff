/*
Based on the battleMETAL menu and metal-lib library by Peter Roohr 
and adapted for Q2DP by MrC (so if it's broke you know who to blame).
Date: 12/20/2022
Overview: singleplayer menu
*/

//Main Menu Globals
//entity camp_title;
entity camp_new;
entity camp_load;
//entity camp_save;
entity camp_back;
entity camp_heroshot;
entity camp_train;

//Main Menu Constants
string IMG_CAMP_TITLE   = "gfx/menu/single/camp_label.png";

#define CAMP_HEROSHOT_IMAGE "gfx/menu/main_infantry.png"

//button callbacks
void() click_camp_new ={
  menu_clear_items(M_STATE);
  m_newg_f(); //m_newsave_f();
};

void() click_camp_load = {
  menu_clear_items(M_STATE);
  m_load_f();
};

void() click_camp_training ={
  menu_clear_items(M_STATE);
  m_train_f();
};

/*void() click_camp_save={
  menu_clear_items(M_STATE);
  m_save_f();
};*/

void() click_camp_back={
  menu_clear_items(M_STATE);
  M_STATE = M_MAIN;
  m_main_f();
};


// ini function, called by '_f' function as a setup func
void() m_camp_i =
{
	campaign_loadfiles();
  
	local float spacing = 100;  
	local float spacer = 40;
	
	menu_parent_setup(VIEW_ORG + '75 75', '208 256');

	main_title2 = lbl_img_overlay(MENU_ORG + menu_parent_center_width(10) + '-20 -20', '2.5 2.5 0', IMG_MAIN_TITLE2, '1 1 1', VIEW_CTX, M_SINGLE, 1, UI_FLAG_SIZE_IMG, 1 );
	main_title = lbl_img(MENU_ORG + menu_parent_center_width(10) + '-20 -20', '2.5 2.5 0', IMG_MAIN_TITLE, '1 1 1', VIEW_CTX, M_SINGLE, 1, UI_FLAG_SIZE_IMG);
    
	camp_heroshot = lbl_img(MENU_ORG + menu_parent_center_width(10) + '415 185', '1 1 0', CAMP_HEROSHOT_IMAGE, '1 1 1', VIEW_CTX, M_SINGLE, 1, UI_FLAG_SIZE_IMG);

    camp_train = btn_text_callback(MENU_ORG + menu_parent_center_width(spacing+=spacer), '40 40', "TRAINING", VIEW_CTX, M_SINGLE, click_camp_training, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, (UI_FLAG_NOLABEL | UI_FLAG_SIZE_IMG));
    camp_train.fontId = FONT_NUM_BLACKOPS_BOLD;

    camp_new = btn_text_callback(MENU_ORG + menu_parent_center_width(spacing+=spacer), '40 40', "NEW GAME", VIEW_CTX, M_SINGLE, click_camp_new, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, (UI_FLAG_NOLABEL | UI_FLAG_SIZE_IMG));
    camp_new.fontId = FONT_NUM_BLACKOPS_BOLD;
    
    camp_load = btn_text_callback(MENU_ORG + menu_parent_center_width(spacing+=spacer), '40 40', "LOAD GAME", VIEW_CTX, M_SINGLE, click_camp_load, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, (UI_FLAG_NOLABEL | UI_FLAG_SIZE_IMG));
    camp_load.fontId = FONT_NUM_BLACKOPS_BOLD;
	
	camp_back = btn_text_callback(MENU_ORG + menu_parent_center_width(spacing+=(spacer*2)), '40 40', "BACK", VIEW_CTX, M_SINGLE, click_camp_back, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, (UI_FLAG_NOLABEL | UI_FLAG_SIZE_IMG));
    camp_back.fontId = FONT_NUM_BLACKOPS_BOLD;
};

/*
  menu_f functions are like state-transition functions, preparing the menu for the next menu to load
*/
void() m_camp_f={
  DRAW_MOUSE = TRUE;
  M_STATE = M_SINGLE;
  setkeydest(KEY_MENU);
  m_camp_i();
};

/*
  menu_d functions are the render functions, inside m_draw, there's a select case
  running on M_STATE to determine which menu_d to execute.
*/
void() m_camp_d={
  local entity widget;
  
  //gui_renderPatch9_1_32(MENU_ORG, MENU_SIZE, '0.35 0.35 0.55', 0.85, 0);
  
  widget = findchainfloat(menuId, M_SINGLE);
  while(widget){
    widget.draw(widget);
    widget = widget.chain;
  }
};

/*
  menu_k functions are the 'listener' functions
*/
void(float key, float ascii) m_camp_k={
  //cons_logAFloat("m_camp_k.key", key);  //DEBUG
  //cons_logAFloat("m_camp_k.ascii", ascii);  //DEBUG   
  
  switch(key){
    case K_ESCAPE:
      //note how this is different than m_main_k, here we just want to go 'up' one
      //menu and not leave the menu system
      localsound("sound/misc/menu2.wav");
      menu_clear_items(M_STATE);
      m_main_f();
      break;
  }
};