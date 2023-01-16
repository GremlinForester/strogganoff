/*
Based on the battleMETAL menu and metal-lib library by Peter Roohr 
and adapted for Q2DP by MrC (so if it's broke you know who to blame).
Date: 12/20/2022
Overview: new campaign, pick save slot
*/

//New Game Save Slot globals
string IMG_NEWSAVE_TITLE  = "gfx/menu/newgame/new_title.png";
entity newsave_title;
entity newsave_back;

//button callbacks

void() click_newsave_back={
  localsound("sound/misc/menu2.wav");
  cvar_set("cl_newgameplus", "0");
  menu_clear_items(M_STATE);
  m_camp_f();
};

void() click_saveslot={
  cvar_set("saveslot", ftos(self.data_bind));

  if( GAME_SAVES_NEWG[cvar("saveslot")] == FALSE ){
    menu_write_new_save();
  }
  
  // menu_write_new_save();
  /*
  freeGlobalString(CAMP_SELECT_START)
  freeGlobalString(CAMP_SELECT_INFO)
  freeGlobalString(CAMP_SELECT_NAME)
//  freeGlobalString(CAMP_SELECT_MECHS)
 // freeGlobalString(CAMP_SELECT_ITEMS)
  freeGlobalString(CAMP_SELECT_IMAGE)   
  */
  
  //bprint("THE DAT STRING THINGY: ");
  //bprint(ftos(self.data_bind));
  
    menu_clear_items(M_STATE);
  menu_exit_togame();
//  m_newg_f();
};

void() m_newsave_back =
{
	local float offset_from_bottom = 48;
	
    local string lbl = "BACK";
	local float lblLen = stringwidth(lbl, 0, '32 32 0');
  
	local vector lowerLeft = VIEW_ORG;
	lowerLeft_y = lowerLeft_y + VIEW_MAX_y - offset_from_bottom;
	lowerLeft_x = lowerLeft_x + 24;
  
	//LOWER LEFT
	newsave_back = btn_text_callback(lowerLeft, '32 32', "BACK", VIEW_LFT, M_NEWSAVE, click_newsave_back, CLR_MENU_BLUE, '0 1 0', 1, UI_FLAG_SIZE_IMG);
	newsave_back.fontId = FONT_NUM_BLACKOPS_BOLD;	
}

void() m_newsave_header =
{
  newsave_title = lbl_text_centered(ANCHOR_UPPER_CENTER + '0 20', '44 44', "SAVE GAME", CLR_DEF_TXT_GRAY_SMOOTH, 0, M_NEWSAVE, 1, 0);
  newsave_title.fontId = FONT_NUM_BLACKOPS_BOLD;
  newsave_title = lbl_img(newsave_title.origin + '100 -10', '1 1 0', IMG_SUBMENUHEADER_BG, '1 1 1', VIEW_CTX, M_NEWSAVE, 1, UI_FLAG_SIZE_IMG );
}

void() m_newsave_i={
  local vector start;
  local float itr;
  local float actual;
  local entity list;
  local vector next;
  local string name;
  local vector backOrg;
  
  menu_parent_setup(VIEW_ORG + '320 70', '346 304');
  
  //newsave_title = lbl_img(MENU_ORG + menu_parent_center_width(5), '1 1 0', IMG_NEWSAVE_TITLE, '1 1 1', VIEW_CTX, M_NEWSAVE, 1, UI_FLAG_SIZE_IMG );
  
  m_newsave_header();

  start = MENU_ORG + '10 65';
  
  itr = 0;
  actual = 0;
  
  while (itr < GAME_SAVES_MAX ){
    next = start;
    next_x = next_x + 16;
    next_y = next_y + (itr * 20);
    
    if( GAME_SAVES_DRAWNAME[itr] == "" ){
      name = "- NEW SAVE SLOT -";
      list = btn_text_callback(next, '14 14', name, 0, M_NEWSAVE, click_saveslot, CLR_DEF_WHITE, CLR_DEF_GREEN, 1, UI_FLAG_SIZE_IMG);
      list.fontId = FONT_NUM_ROBOT_LIGHT;
    }
    else{
      name = GAME_SAVES_DRAWNAME[itr];
      list = btn_text_callback(next, '14 14', name, 0, M_NEWSAVE, click_saveslot, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, UI_FLAG_SIZE_IMG);
      list.fontId = FONT_NUM_ROBOT_REGULAR;
    }
    
    list.data_bind = itr; //databind
    itr = itr + 1;
  }
  backOrg = MENU_ORG + '80 0';
  backOrg_y = next_y + 36;
  //newsave_back = btn_text_callback(backOrg, '16 16', "BACK", VIEW_CTX, M_NEWSAVE, click_newsave_back, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, UI_FLAG_SIZE_IMG);
  //newsave_back.fontId = FONT_NUM_BLACKOPS_BOLD;
    m_newsave_back();
};

void() m_newsave_f={
  DRAW_MOUSE = true;
  M_STATE = M_NEWSAVE;
  setkeydest(KEY_MENU);
  menu_scan_saves();
  m_newsave_i();
};

void() m_newsave_d={
  local entity widget;

  //gui_renderPatch9_1_32(MENU_ORG, MENU_SIZE, '0.35 0.35 0.55', 0.85, 0);

  gui_renderString("Clicking a SaveSlot will OVERRIDE that save.", MENU_ORG + '10 45', CLR_DEF_ARM_THREEQ, '14 14 0', 1, 0);

  widget = findchainfloat(menuId, M_NEWSAVE);
  while(widget){
    widget.draw(widget);
    widget = widget.chain;
  }
};

void(float ky, float ascii) m_newsave_k={
  switch(ky){
    case K_ESCAPE:
      localsound("sound/misc/menu2.wav");
      menu_clear_items(M_STATE);
      m_camp_f();
      break;
  }
};
