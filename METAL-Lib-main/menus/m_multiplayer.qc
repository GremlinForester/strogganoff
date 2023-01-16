/*
Based on the battleMETAL menu and metal-lib library by Peter Roohr 
and adapted for Q2DP by MrC (so if it's broke you know who to blame).
Date: 12/20/2022
Overview: 
  multiplayer top menu
*/

//Multiplayer Globals
//entity multi_title;
entity multi_playersetup;
entity multi_hostgame;
entity multi_joingame;
entity multi_back;
entity multi_heroshot;

#define MULTI_HEROSHOT_IMAGE "gfx/menu/main_infantry.png"

//MultiplayerConstants
string IMG_MULTI_TITLE   = "gfx/menu/multi/multi_title.png";

//Multiplayer callbacks
void() click_multi_back={
  menu_clear_items(M_STATE);
  m_main_f();
  localsound("sound/misc/menu2.wav");
};


void() click_multi_setup={
  menu_clear_items(M_STATE);
  m_setup_f();
};


void() click_multi_host={
  menu_clear_items(M_STATE);
  m_host_f();
};

void() click_multi_join={
  menu_clear_items(M_STATE);
  m_join_f();
};

// ini function, called by '_f' function as a setup func
void() m_multi_i =
{
	local float mainTitleFlag;
	local float spacing = 100;  
	local float spacer = 40;
	
	menu_parent_setup(VIEW_ORG + '75 75', '208 256');
    mainTitleFlag = UI_FLAG_SIZE_IMG;

	main_title2 = lbl_img_overlay(MENU_ORG + menu_parent_center_width(10) + '-20 -20', '2.5 2.5 0', IMG_MAIN_TITLE2, '1 1 1', VIEW_CTX, M_MULTI, 1, UI_FLAG_SIZE_IMG, 1);
	main_title = lbl_img(MENU_ORG + menu_parent_center_width(10) + '-20 -20', '2.5 2.5 0', IMG_MAIN_TITLE, '1 1 1', VIEW_CTX, M_MULTI, 1, UI_FLAG_SIZE_IMG);

	multi_heroshot = lbl_img(ANCHOR_LOWER_RIGHT + '-175 -250', '1 1 0', "gfx/menu/hero_multiplayer.png", '1 1 1', VIEW_CTX, M_MULTI, 1, UI_FLAG_SIZE_IMG);

    multi_playersetup = btn_text_callback(MENU_ORG + menu_parent_center_width(spacing+=spacer), '40 40', "PLAYER SETUP", VIEW_CTX, M_MULTI, click_multi_setup, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, (UI_FLAG_NOLABEL | UI_FLAG_SIZE_IMG));
    multi_playersetup.fontId = FONT_NUM_BLACKOPS_BOLD;
    
    multi_hostgame = btn_text_callback(MENU_ORG + menu_parent_center_width(spacing+=spacer), '40 40', "HOST GAME", VIEW_CTX, M_MULTI, click_multi_host, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, (UI_FLAG_NOLABEL | UI_FLAG_SIZE_IMG));
    multi_hostgame.fontId = FONT_NUM_BLACKOPS_BOLD;
    
    multi_joingame = btn_text_callback(MENU_ORG + menu_parent_center_width(spacing+=spacer), '40 40', "JOIN GAME", VIEW_CTX, M_MULTI, click_multi_join, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, (UI_FLAG_NOLABEL | UI_FLAG_SIZE_IMG));
    multi_joingame.fontId = FONT_NUM_BLACKOPS_BOLD;
	
	multi_back = btn_text_callback(MENU_ORG + menu_parent_center_width(spacing+=(spacer*2)), '40 40', "BACK", VIEW_CTX, M_MULTI, click_multi_back, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, (UI_FLAG_NOLABEL | UI_FLAG_SIZE_IMG));
    multi_back.fontId = FONT_NUM_BLACKOPS_BOLD;
/*  
multi_hostgame = btn_text_callback(MENU_ORG + menu_parent_center_width(64), '16 16', "HOST GAME", VIEW_CTX, M_MULTI, click_multi_host, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0',1, UI_FLAG_SIZE_IMG);
multi_hostgame.fontId = FONT_NUM_BLACKOPS_BOLD;
  
multi_joingame = btn_text_callback(MENU_ORG + menu_parent_center_width(83), '16 16', "JOIN GAME", VIEW_CTX, M_MULTI, click_multi_join, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, UI_FLAG_SIZE_IMG);
multi_joingame.fontId = FONT_NUM_BLACKOPS_BOLD;
  
multi_back = btn_text_callback(MENU_ORG + menu_parent_center_width(128), '16 16', "BACK", VIEW_CTX, M_MULTI, click_multi_back, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, UI_FLAG_SIZE_IMG);
multi_back.fontId = FONT_NUM_BLACKOPS_BOLD;
*/
};

/*
  menu_f functions are like state-transition functions, preparing the menu for the next menu to load
*/
void() m_multi_f =
{
	DRAW_MOUSE = TRUE;
	M_STATE = M_MULTI;
	setkeydest(KEY_MENU);
	m_multi_i();
};

/*
  menu_d functions are the render functions, inside m_draw, there's a select case
  running on M_STATE to determine which menu_d to execute.
*/
void() m_multi_d =
{
	local entity widget;
  
	widget = findchainfloat(menuId, M_MULTI);
	while(widget)
	{
		widget.draw(widget);
		widget = widget.chain;
	}
};

/*
  menu_k functions are the 'listener' functions
*/
void(float key, float ascii) m_multi_k={
  //cons_logAFloat("m_multi_k.key", key);  //DEBUG
  //cons_logAFloat("m_multi_k.ascii", ascii);  //DEBUG   
  
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