/*
Based on the battleMETAL menu and metal-lib library by Peter Roohr 
and adapted for Q2DP by MrC (so if it's broke you know who to blame).
Date: 12/20/2022
Overview: options root menu
*/

//options root Globals
//entity options_title;
entity options_controls;
entity options_graphics;
entity options_audio;
entity options_gameplay;
entity options_back;
entity options_heroshot;

#define OPTIONS_HEROSHOT_IMAGE "gfx/menu/main_infantry.png"

//options root Constants
string IMG_OPTION_TITLE = "gfx/menu/options/options_title.png";

//options root callbacks
void() click_options_controls={
  menu_clear_items(M_STATE);
  m_controls_f();
};

void() click_options_graphics={
  menu_clear_items(M_STATE);
  m_graphics_f();
};

void() click_options_audio={
  menu_clear_items(M_STATE);
  m_audio_f();
};

void() click_options_gameplay={
  menu_clear_items(M_STATE);
  m_gameplay_f();
};

void() click_options_back={
  menu_clear_items(M_STATE);
  m_main_f();
};

// ini function, called by '_f' function as a setup func
void() m_options_i =
{
	//local float mainTitleFlag;
	local float spacing = 100;  
	local float spacer = 40;
	
	menu_parent_setup(VIEW_ORG + '75 75', '208 256');
    //mainTitleFlag = UI_FLAG_SIZE_IMG;

	main_title2 = lbl_img(MENU_ORG + menu_parent_center_width(10) + '-20 -20', '2.5 2.5 0', IMG_MAIN_TITLE2, '1 1 1', VIEW_CTX, M_OPTIONS, 1, UI_FLAG_SIZE_IMG);
	main_title = lbl_img(MENU_ORG + menu_parent_center_width(10) + '-20 -20', '2.5 2.5 0', IMG_MAIN_TITLE, '1 1 1', VIEW_CTX, M_OPTIONS, 1, UI_FLAG_SIZE_IMG);
    
	options_heroshot = lbl_img(MENU_ORG + menu_parent_center_width(10) + '415 185', '1 1 0', OPTIONS_HEROSHOT_IMAGE, '1 1 1', VIEW_CTX, M_OPTIONS, 1, UI_FLAG_SIZE_IMG);

    options_gameplay = btn_text_callback(MENU_ORG + menu_parent_center_width(spacing+=spacer), '40 40', "GAMEPLAY", VIEW_CTX, M_OPTIONS, click_options_gameplay, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, (UI_FLAG_NOLABEL | UI_FLAG_SIZE_IMG));
    options_gameplay.fontId = FONT_NUM_BLACKOPS_BOLD;
    
    options_audio = btn_text_callback(MENU_ORG + menu_parent_center_width(spacing+=spacer), '40 40', "AUDIO", VIEW_CTX, M_OPTIONS, click_options_audio, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, (UI_FLAG_NOLABEL | UI_FLAG_SIZE_IMG));
    options_audio.fontId = FONT_NUM_BLACKOPS_BOLD;
    
    options_graphics = btn_text_callback(MENU_ORG + menu_parent_center_width(spacing+=spacer), '40 40', "GRAPHICS", VIEW_CTX, M_OPTIONS, click_options_graphics, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, (UI_FLAG_NOLABEL | UI_FLAG_SIZE_IMG));
    options_graphics.fontId = FONT_NUM_BLACKOPS_BOLD;
	
    options_controls = btn_text_callback(MENU_ORG + menu_parent_center_width(spacing+=spacer), '40 40', "CONTROLS", VIEW_CTX, M_OPTIONS, click_options_controls, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, (UI_FLAG_NOLABEL | UI_FLAG_SIZE_IMG));
    options_controls.fontId = FONT_NUM_BLACKOPS_BOLD;	
	
	options_back = btn_text_callback(MENU_ORG + menu_parent_center_width(spacing+=(spacer*2)), '40 40', "BACK", VIEW_CTX, M_OPTIONS, click_options_back, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, (UI_FLAG_NOLABEL | UI_FLAG_SIZE_IMG));
    options_back.fontId = FONT_NUM_BLACKOPS_BOLD;
	/*
  menu_parent_setup(VIEW_ORG + '0 80', '208 224');

  options_title = lbl_img(MENU_ORG + menu_parent_center_width(5), '1 1', IMG_OPTION_TITLE, '1 1 1', VIEW_CTX, M_OPTIONS, 1, UI_FLAG_SIZE_IMG );
  
  options_controls = btn_text_callback(MENU_ORG + menu_parent_center_width(45), '16 16', "CONTROLS", VIEW_CTX, M_OPTIONS, click_options_controls, CLR_DEF_TXT_GRAY_SMOOTH, CLR_DEF_GREEN, 1, UI_FLAG_SIZE_IMG);
  options_controls.fontId = FONT_NUM_BLACKOPS_BOLD;
  
  options_graphics = btn_text_callback(MENU_ORG + menu_parent_center_width(64), '16 16', "GRAPHICS", VIEW_CTX, M_OPTIONS, click_options_graphics, CLR_DEF_TXT_GRAY_SMOOTH, CLR_DEF_GREEN,1, UI_FLAG_SIZE_IMG);
  options_graphics.fontId = FONT_NUM_BLACKOPS_BOLD;
  
  options_audio = btn_text_callback(MENU_ORG + menu_parent_center_width(83), '16 16', "SOUND", VIEW_CTX, M_OPTIONS, click_options_audio, CLR_DEF_TXT_GRAY_SMOOTH, CLR_DEF_GREEN, 1, UI_FLAG_SIZE_IMG);
  options_audio.fontId = FONT_NUM_BLACKOPS_BOLD;
  
  options_gameplay = btn_text_callback(MENU_ORG + menu_parent_center_width(102), '16 16', "GAMEPLAY", VIEW_CTX, M_OPTIONS, click_options_gameplay, CLR_DEF_TXT_GRAY_SMOOTH, CLR_DEF_GREEN, 1, UI_FLAG_SIZE_IMG);
  options_gameplay.fontId = FONT_NUM_BLACKOPS_BOLD;
  
  options_back = btn_text_callback(MENU_ORG + menu_parent_center_width(178), '16 16', "BACK", VIEW_CTX, M_OPTIONS, click_options_back, CLR_DEF_TXT_GRAY_SMOOTH,CLR_DEF_GREEN, 1, UI_FLAG_SIZE_IMG);
  options_back.fontId = FONT_NUM_BLACKOPS_BOLD;
  */
};

/*
  menu_f functions are like state-transition functions, preparing the menu for the next menu to load
*/
void() m_options_f={
  DRAW_MOUSE = TRUE;
  M_STATE = M_OPTIONS;
  setkeydest(KEY_MENU);
  m_options_i();
};

/*
  menu_d functions are the render functions, inside m_draw, there's a select case
  running on M_STATE to determine which menu_d to execute.
*/
void() m_options_d={
  local entity widget;
  
  //gui_renderPatch9_1_32(MENU_ORG, MENU_SIZE, '0.35 0.35 0.55', 0.85, 0);
  
  widget = findchainfloat(menuId, M_OPTIONS);
  while(widget){
    widget.draw(widget);
    widget = widget.chain;
  }
};

/*
  menu_k functions are the 'listener' functions
*/
void(float key, float ascii) m_options_k={
  //cons_logAFloat("m_join_k.key", key);  //DEBUG
  //cons_logAFloat("m_join_k.ascii", ascii);  //DEBUG   
  
  switch(key){
    case K_ESCAPE:
      localsound("sound/misc/menu2.wav");
      menu_clear_items(M_STATE);
      M_STATE = M_MAIN;
      m_main_f();
      break;
  }
};