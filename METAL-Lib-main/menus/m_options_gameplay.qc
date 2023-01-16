/*
Based on the battleMETAL menu and metal-lib library by Peter Roohr 
and adapted for Q2DP by MrC (so if it's broke you know who to blame).
Date: 12/20/2022
Overview: 
  options - gameplay menu
    fun and helpful tweaks to the game experience like:
      showing FPS counter, adjusting HUD color and reticles.
*/

#include "m_options_gameplay.qh"

void() m_gameplay_header =
{
  gameplay_title = lbl_text_centered(ANCHOR_UPPER_CENTER + '0 20', '44 44', "GAMEPLAY", CLR_DEF_TXT_GRAY_SMOOTH, 0, M_OPTIONS_GAMEPLAY, 1, 0);
  gameplay_title.fontId = FONT_NUM_BLACKOPS_BOLD;
  gameplay_title = lbl_img(gameplay_title.origin + '100 -10', '1 1 0', IMG_SUBMENUHEADER_BG, '1 1 1', VIEW_CTX, M_OPTIONS_GAMEPLAY, 1, UI_FLAG_SIZE_IMG );
}

// ini function, called by '_f' function as a setup func
void() m_gameplay_i =
{
  menu_parent_setup(ANCHOR_UPPER_CENTER + '-125 80', '88 240');
  
  //gameplay_title = lbl_img(MENU_ORG + menu_parent_center_width(5), '1 1 0', IMG_OPTION_TITLE, '1 1 1', VIEW_CTX, M_OPTIONS_GAMEPLAY, 1, UI_FLAG_SIZE_IMG );

	m_gameplay_header();
  
  gameplay_fov_lbl = lbl_text(MENU_ORG + '125 63', '14 14', "", CLR_DEF_WHITE, VIEW_CTX, M_OPTIONS_GAMEPLAY, 1, UI_FLAG_LBL_USELEN);
  gameplay_fov_lbl.len = cvar("fov");
  gameplay_fov_more = btn_img_callback(gameplay_fov_lbl.origin + Vector2(stringwidth("100", 0, gameplay_fov_lbl.size), 0), '12 12', UI_IMG_ARW_RGT, 0, M_OPTIONS_GAMEPLAY, click_gameplay_fov_more, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  gameplay_fov_less = btn_img_callback(gameplay_fov_lbl.origin - '20 0', '12 12', UI_IMG_ARW_LFT, 0, M_OPTIONS_GAMEPLAY, click_gameplay_fov_less, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

  if(gameplay_fov_lbl.len == 40){
    gameplay_fov_less.drawme = FALSE;
  }
  else if(gameplay_fov_lbl.len == 130){
    gameplay_fov_more.drawme = FALSE;
  }
  
  gameplay_datetime_lbl = lbl_text(MENU_ORG + '125 83', '14 14', "", CLR_DEF_WHITE, VIEW_CTX, M_OPTIONS_GAMEPLAY, 1, UI_FLAG_LBL_BOOL_ON);
  gameplay_datetime_lbl.len = cvar("showdate");
  gameplay_datetime_on = btn_img_callback(gameplay_datetime_lbl.origin + Vector2(stringwidth("OFF", 0, gameplay_datetime_lbl.size), 0), '12 12', UI_IMG_ARW_RGT, 0, M_OPTIONS_GAMEPLAY, click_gameplay_date_on, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  gameplay_datetime_off = btn_img_callback(gameplay_datetime_lbl.origin - '20 0', '12 12', UI_IMG_ARW_LFT, 0, M_OPTIONS_GAMEPLAY, click_gameplay_date_off, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

  if(gameplay_datetime_lbl.len){
    gameplay_datetime_on.drawme = FALSE;
  }
  else{
    gameplay_datetime_off.drawme = FALSE;
  }
   
  gameplay_fps_lbl = lbl_text(MENU_ORG + '125 103', '14 14', "", CLR_DEF_WHITE, VIEW_CTX, M_OPTIONS_GAMEPLAY, 1, UI_FLAG_LBL_BOOL_ON);
  gameplay_fps_lbl.len = cvar("showfps");
  gameplay_fps_on = btn_img_callback(gameplay_fps_lbl.origin + Vector2(stringwidth("OFF", 0, gameplay_fps_lbl.size), 0), '12 12', UI_IMG_ARW_RGT, 0, M_OPTIONS_GAMEPLAY, click_gameplay_fps_on, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  gameplay_fps_off = btn_img_callback(gameplay_fps_lbl.origin - '20 0', '12 12', UI_IMG_ARW_LFT, 0, M_OPTIONS_GAMEPLAY, click_gameplay_fps_off, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

  if(gameplay_fps_lbl.len){
    gameplay_fps_on.drawme = FALSE;
  }
  else{
    gameplay_fps_off.drawme = FALSE;
  }
  
  local float clean;
  clean = cvar("crosshair");
  gameplay_crosshair_lbl = lbl_text(MENU_ORG + '125 123', '14 14', strzone(sprintf("%0.0f", clean)), CLR_DEF_WHITE, VIEW_CTX, M_OPTIONS_GAMEPLAY, 1, 0);
  gameplay_crosshair_lbl.len = cvar("crosshair");
  gameplay_crosshair_lbl.image1 = gameplay_crosshair_img( cvar("crosshair") );
  gameplay_crosshair_nx = btn_img_callback(gameplay_crosshair_lbl.origin + Vector2(stringwidth("5", 0, gameplay_crosshair_lbl.size), 0), '12 12', UI_IMG_ARW_RGT, 0, M_OPTIONS_GAMEPLAY, click_gameplay_crosshair_nx, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  gameplay_crosshair_pr = btn_img_callback(gameplay_crosshair_lbl.origin - '20 0', '12 12', UI_IMG_ARW_LFT, 0, M_OPTIONS_GAMEPLAY, click_gameplay_crosshair_pr, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

  clean = cvar("cl_hud_alpha");
  gameplay_hudalpha_lbl = lbl_text(MENU_ORG + '125 143', '14 14', strzone(sprintf("%0.2f", clean)), CLR_DEF_WHITE, VIEW_CTX, M_OPTIONS_GAMEPLAY, 1, 0);
  gameplay_hudalpha_lbl.len = cvar("cl_hud_alpha");
  gameplay_hudalpha_up = btn_img_callback(gameplay_hudalpha_lbl.origin + Vector2(stringwidth("9.99", 0, gameplay_crosshair_lbl.size), 0), '12 12', UI_IMG_ARW_RGT, 0, M_OPTIONS_GAMEPLAY, click_gameplay_hudalpha_up, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  gameplay_hudalpha_dn = btn_img_callback(gameplay_hudalpha_lbl.origin - '20 0', '12 12', UI_IMG_ARW_LFT, 0, M_OPTIONS_GAMEPLAY, click_gameplay_hudalpha_dn, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

  if( gameplay_hudalpha_lbl.len < 0.1 ){
    gameplay_hudalpha_dn.drawme = FALSE;
  }
  if( gameplay_hudalpha_lbl.len > 0.95 ){
    gameplay_hudalpha_up.drawme = FALSE;
  }
  
  local string colr;
  colr = gameplay_hudcolor_name( cvar("cl_hud_color") );
  gameplay_hudcolor_lbl = lbl_text(MENU_ORG + '125 163', '14 14', strzone(colr), CLR_DEF_WHITE, VIEW_CTX, M_OPTIONS_GAMEPLAY, 1, 0);
  gameplay_hudcolor_lbl.len = cvar("cl_hud_color");
  gameplay_hudcolor_lbl.color_x = cvar("crosshair_color_red");
  gameplay_hudcolor_lbl.color_y = cvar("crosshair_color_green");
  gameplay_hudcolor_lbl.color_z = cvar("crosshair_color_blue");
  gameplay_hudcolor_nx = btn_img_callback(gameplay_hudcolor_lbl.origin + Vector2(stringwidth("PURPLE", 0, gameplay_crosshair_lbl.size), 0), '12 12', UI_IMG_ARW_RGT, 0, M_OPTIONS_GAMEPLAY, click_gameplay_hudcolor_nx, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  gameplay_hudcolor_pr = btn_img_callback(gameplay_hudcolor_lbl.origin - '20 0', '12 12', UI_IMG_ARW_LFT, 0, M_OPTIONS_GAMEPLAY, click_gameplay_hudcolor_pr, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

	gameplay_hudcolorR_nx = btn_img_callback(MENU_ORG + '135 200', '12 12', UI_IMG_ARW_RGT, 0, M_OPTIONS_GAMEPLAY, incrementHUD_R, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
	gameplay_hudcolorR_pr = btn_img_callback(MENU_ORG + '105 200', '12 12', UI_IMG_ARW_LFT, 0, M_OPTIONS_GAMEPLAY, decrementHUD_R, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

	gameplay_hudcolorG_nx = btn_img_callback(MENU_ORG + '135 220', '12 12', UI_IMG_ARW_RGT, 0, M_OPTIONS_GAMEPLAY, incrementHUD_G, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
	gameplay_hudcolorG_pr = btn_img_callback(MENU_ORG + '105 220', '12 12', UI_IMG_ARW_LFT, 0, M_OPTIONS_GAMEPLAY, decrementHUD_G, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
	
	gameplay_hudcolorB_nx = btn_img_callback(MENU_ORG + '135 240', '12 12', UI_IMG_ARW_RGT, 0, M_OPTIONS_GAMEPLAY, incrementHUD_B, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
	gameplay_hudcolorB_pr = btn_img_callback(MENU_ORG + '105 240', '12 12', UI_IMG_ARW_LFT, 0, M_OPTIONS_GAMEPLAY, decrementHUD_B, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

	m_gameplay_back_and_accept();  
};

/*
  menu_f functions are like state-transition functions, preparing the menu for the next menu to load
*/
void() m_gameplay_f={
  DRAW_MOUSE = TRUE;
  M_STATE = M_OPTIONS_GAMEPLAY;
  setkeydest(KEY_MENU);
  m_gameplay_i();
};

/*
  menu_d functions are the render functions, inside m_draw, there's a select case
  running on M_STATE to determine which menu_d to execute.
*/
void() m_gameplay_d={
  local vector crossColor;
  
//  gui_renderPatch9_1_32(MENU_ORG, MENU_SIZE, '0.35 0.35 0.55', 0.85, 0);
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
  
  //gui_renderString("- Gameplay -", MENU_ORG + menu_parent_center_width(40) - Vector2((stringwidth("- Particle Settings -", 0, '16 16')/2),0), CLR_DEF_WHITE, '16 16', 1, 0);
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_LIGHT;
  
    gui_renderString("Field of View:", gameplay_fov_less.origin - Vector2(stringwidth("Field of View:  ", 0, '12 12'),0), CLR_DEF_TXT_NONSELECT, '12 12', 1, 0);
    gui_renderString("Show FPS:", gameplay_fps_off.origin - Vector2(stringwidth("Show FPS:  ", 0, '12 12'),0), CLR_DEF_TXT_NONSELECT, '12 12', 1, 0);
    gui_renderString("Show Date/Time:", gameplay_datetime_off.origin - Vector2(stringwidth("Show Date/Time:  ", 0, '12 12'),0), CLR_DEF_TXT_NONSELECT, '12 12', 1, 0);
    gui_renderString("Crosshair Style:", gameplay_crosshair_pr.origin - Vector2(stringwidth("Crosshair Style:  ", 0, '12 12'),0), CLR_DEF_TXT_NONSELECT, '12 12', 1, 0);
    gui_renderString("HUD Alpha:", gameplay_hudalpha_dn.origin - Vector2(stringwidth("HUD Alpha:  ", 0, '12 12'),0), CLR_DEF_TXT_NONSELECT, '12 12', 1, 0);
    gui_renderString("HUD Color preset:", gameplay_hudcolor_pr.origin - Vector2(stringwidth("HUD Color preset:  ", 0, '12 12'),0), CLR_DEF_TXT_NONSELECT, '12 12', 1, 0);

	gui_renderString("RED:", gameplay_hudcolorR_pr.origin - Vector2(stringwidth("RED:  ", 0, '12 12'),0), CLR_DEF_TXT_NONSELECT, '12 12', 1, 0);
	gui_renderString("GREEN:", gameplay_hudcolorG_pr.origin - Vector2(stringwidth("GREEN:  ", 0, '12 12'),0), CLR_DEF_TXT_NONSELECT, '12 12', 1, 0);	
	gui_renderString("BLUE:", gameplay_hudcolorB_pr.origin - Vector2(stringwidth("BLUE:  ", 0, '12 12'),0), CLR_DEF_TXT_NONSELECT, '12 12', 1, 0);

  drawfont = drawfont_prev;

  crossColor_x = cvar("crosshair_color_red");
  crossColor_y = cvar("crosshair_color_green");
  crossColor_z = cvar("crosshair_color_blue");
  
  drawpic(MENU_ORG + '96 256', gameplay_crosshair_lbl.image1 , '64 64', crossColor, gameplay_hudalpha_lbl.len, 0);
  
  
  
  gui_renderString(ftos(floor(crossColor_x * 10)), gameplay_hudcolorR_nx.origin - Vector2(stringwidth("0.0", 0, '12 12'),0), CLR_DEF_TXT_NONSELECT, '12 12', 1, 0);
  gui_renderString(ftos(floor(crossColor_y * 10)), gameplay_hudcolorG_nx.origin - Vector2(stringwidth("0.0", 0, '12 12'),0), CLR_DEF_TXT_NONSELECT, '12 12', 1, 0);
  gui_renderString(ftos(floor(crossColor_z * 10)), gameplay_hudcolorB_nx.origin - Vector2(stringwidth("0.0", 0, '12 12'),0), CLR_DEF_TXT_NONSELECT, '12 12', 1, 0);

  if( gameplay_hudcolor_lbl.len < 5 )
  {
    gameplay_hudcolorR_nx.drawme = FALSE;
	gameplay_hudcolorR_pr.drawme = FALSE;
	gameplay_hudcolorG_nx.drawme = FALSE;
	gameplay_hudcolorG_pr.drawme = FALSE;
	gameplay_hudcolorB_nx.drawme = FALSE;
	gameplay_hudcolorB_pr.drawme = FALSE;
  }
  else
  {
	gameplay_hudcolorR_nx.drawme = TRUE;
	gameplay_hudcolorR_pr.drawme = TRUE;
	gameplay_hudcolorG_nx.drawme = TRUE;
	gameplay_hudcolorG_pr.drawme = TRUE;
	gameplay_hudcolorB_nx.drawme = TRUE;
	gameplay_hudcolorB_pr.drawme = TRUE;
  } 


  local entity widget;
  widget = findchainfloat(menuId, M_OPTIONS_GAMEPLAY);
  while(widget){
    widget.draw(widget);
    widget = widget.chain;
  }
};

/*
  menu_k functions are the 'listener' functions
*/
void(float key, float ascii) m_gameplay_k={
  //cons_logAFloat("m_gameplay_k.key", key);  //DEBUG
  //cons_logAFloat("m_gameplay_k.ascii", ascii);  //DEBUG   
  
  switch(key){
    case K_ESCAPE:
      localcmd("saveconfig\n");
      localsound("sound/misc/menu2.wav");
      menu_clear_items(M_STATE);
      M_STATE = M_OPTIONS;
      m_options_f();
      break;
  }
};