/*
threshold3
Author: Peter Roohr
Overview:
    Player Setup for multiplayer
*/

float TINT_MIN = 0.2;
float TINT_STEP = 0.05;

float SETUP_COLOR_PART_SELECTED;

float SETUP_COLOR_SHOW;

//Main Menu Globals
entity setup_title;
entity setup_label_playername;
entity setup_txtfld_playername;

entity setup_team_label;
entity setup_team_value;
entity setup_team_icon;
entity setup_team_prev;
entity setup_team_next;

entity setup_pic_label;

//color tinting
entity setup_accept;

//Main Menu Constants
#define IMG_SETUP_TITLE "gfx/menu/setup/setup_title.png"

string(float factionType) setup_set_icon={
  /*switch(setup_team_value.len){
    case 2:
      return IMG_TEAM_SURVEST;
    
    case 3:
      return IMG_TEAM_MILITAR;
    
    default:
      return IMG_TEAM_PSC;
  }*/
  return "";
};


//button callbacks
//because we define these right before the menu functions are defined, we 
//don't have to put them in a header, and they can be 'somewhat' flexibily generated
/*void() click_newg_back={
  menu_clear_items(M_STATE);
  M_STATE = M_SINGLE;
  localsound("sound/misc/menu2.wav");
};*/
void() click_setup_accept={
  localcmd("saveconfig\n");
  if( clientstate() == CS_CONNECTED ){
    //send update to client, and then eventually the server.
    
    localcmd("cl_cmd tint");
  }
  menu_clear_items(M_STATE);
  M_STATE = M_MAIN;
  m_main_f();
};

void() textfield_setup_name={
  if( strlen(self.data_text) > 0 ){
    cvar_set("_cl_name", self.data_text);
  }
  else{
    freeGlobalString(self.data_text)
    cvar_set("_cl_name", "DEAD_HAND");
    cacheGlobalString(  self.data_text, str_cvar("_cl_name"))
  }
};

void(float selectTeam) setup_team_set={
  
  setup_team_value.len = selectTeam;
  
  setup_team_icon.image1 = setup_set_icon( setup_team_value.len );

  
  cvar_set("cl_team", ftos(setup_team_value.len) );
};

void() setup_team_prev_f={
  local float prevTeam;
  prevTeam = setup_team_value.len - 1;
  if( prevTeam < 1 ){
    prevTeam = 3;
  }
  setup_team_set(prevTeam);
};

void() setup_team_next_f={
  local float nextTeam;
  nextTeam = setup_team_value.len + 1;
  if( nextTeam > 3 ){
    nextTeam = 1;
  }
  setup_team_set(nextTeam);
};




void(entity elm) setup_draw_color_highlight={
  local float drawPanel;
  drawPanel = FALSE;
  
  if( drawPanel ){
    drawpic(elm.origin - '4 4', "gfx/ui/box_64.png", '22 22', '1 1 0.5', 1.0 , 0);
  }
};

// ini functions
void() m_setup_i={
  
  menu_parent_setup([UI_CTR_x - 423/2, VIEW_ORG_y + 32], '423 416');
  
  setup_title = lbl_img(MENU_ORG + menu_parent_center_width(5), '1 1 0', IMG_SETUP_TITLE, '1 1 1', VIEW_CTX | VIEW_CTY, M_SETUP, 1, UI_FLAG_SIZE_IMG );
  
  setup_label_playername = lbl_text(MENU_ORG + '10 45', '12 12', "Player Name : ", CLR_DEF_TXT_NONSELECT, 0, M_SETUP, 1, 0);
  
  setup_txtfld_playername = inp_textfield(setup_label_playername.origin + Vector2(stringwidth("Player Name :   ", 0, '12 12'), 0), '14 14', 24, textfield_setup_name, 0, M_SETUP, CLR_DEF_WHITE, CLR_DEF_BLUE, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_UPP));
  cacheGlobalString( setup_txtfld_playername.data_text, str_cvar("_cl_name") )
  
  setup_team_label = lbl_text(MENU_ORG + '10 115', '12 12', "TDM Team Colors : ", CLR_DEF_TXT_NONSELECT, 0, M_SETUP, 1, 0);
  setup_team_value = lbl_text(setup_team_label.origin + Vector2(stringwidth("TDM Team Colors : ", 0, '12 12') + 128, 0), '12 12', "", CLR_DEF_TXT_NONSELECT, 0, M_SETUP, 1, 0);
  setup_team_value.len = cvar("cl_team");
  
  //setup_team_icon = lbl_img(setup_team_value.origin, '96 96', setup_set_icon(setup_team_value.len), '1 1 1', 0, M_SETUP, 1, UI_FLAG_IMG_SIZE_ASPECT | UI_FLAG_CENTER_IMG );
  
  setup_team_prev = btn_img_callback(setup_team_value.origin - '64 0', '14 14', UI_IMG_ARW_LFT, VIEW_CTX | VIEW_CTY, M_SETUP, setup_team_prev_f, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  setup_team_next = btn_img_callback(setup_team_value.origin + '64 0', '14 14', UI_IMG_ARW_RGT, VIEW_CTX | VIEW_CTY, M_SETUP, setup_team_next_f, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  
  //setup_pic_label = lbl_text(MENU_ORG + '10 160', '16 16', "Player Color Tint", CLR_DEF_TXT_NONSELECT, 0, M_SETUP, 1, UI_FLAG_SIZE_IMG);
  
  setup_accept = btn_text_callback(MENU_ORG + '45 395', '16 16', "SAVE", VIEW_CTX, M_SETUP, click_setup_accept, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, UI_FLAG_SIZE_IMG);
  setup_accept.fontId = FONT_NUM_BLACK_OPS_ONE;
};

/*
  menu_f functions are like state-transition functions, preparing the menu for the next menu to load
*/
void() m_setup_f={
  DRAW_MOUSE = TRUE;
  M_STATE = M_SETUP;
  setkeydest(KEY_MENU);
  m_setup_i();
};

/*
  menu_d functions are the render functions, inside m_draw, there's a select case
  running on M_STATE to determine which menu_d to execute.
*/
void() m_setup_d={
  
  gui_renderPatch9_1_32(MENU_ORG, MENU_SIZE, '0.35 0.35 0.55', 0.85, 0);
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_BLACK_OPS_ONE;
  
  drawfont = drawfont_prev;
  
  
  local entity widget;
  widget = findchainfloat(menuId, M_SETUP);
  while(widget){
    widget.draw(widget);
    widget = widget.chain;
  }
  
};

/*
  menu_k functions are the 'listener' functions
*/
void(float key, float ascii) m_setup_k={
  switch(key){
    case K_ESCAPE:
      localsound("sound/misc/menu2.wav");
      menu_clear_items(M_STATE);
      localcmd("saveconfig\n");
      M_STATE = M_MAIN;
      m_main_f();
      break;
  }
};