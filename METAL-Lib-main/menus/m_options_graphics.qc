/*
Based on the battleMETAL menu and metal-lib library by Peter Roohr 
and adapted for Q2DP by MrC (so if it's broke you know who to blame).
Date: 12/20/2022
Overview: 
  options - graphics menu
  
Changes:
Radio buttons for bool options.
Simple overall graphics quality that merges lighting and particles.
*/

//graphics Globals
entity graphics_resolution_lbl;
entity graphics_resolution_change;

entity graphics_game_image;
entity graphics_game_brightness_image;
entity graphics_game_contrast_image;

entity graphics_resolution_aspect_lbl;

entity new_graphics_borderless_check;

entity graphics_bits_lbl;
entity graphics_bits_less;
entity graphics_bits_more;

entity graphics_fxaa_lbl;
entity graphics_fxaa_more;
entity graphics_fxaa_less;

entity new_graphics_refresh_check;

entity graphics_refresh_rate_lbl;
entity graphics_refresh_rate_up;
entity graphics_refresh_rate_dn;

entity new_graphics_fullscreen_check;

entity new_graphics_vsync_check;

entity graphics_aniso_lbl;
entity graphics_aniso_more;
entity graphics_aniso_less;

entity graphics_texture_quality_lbl;
entity graphics_texture_quality_more;
entity graphics_texture_quality_less;

entity new_graphics_texture_compress_check;

entity graphics_effects_lbl;
entity graphics_effects_more;
entity graphics_effects_less;
/*
entity graphics_gfx_lbl;
entity graphics_gfx_more;
entity graphics_gfx_less;
entity graphics_gfx_custom;
*/

entity graphics_game_contrast_lbl;
entity graphics_game_contrast_more;
entity graphics_game_contrast_less;

entity graphics_gamma_lbl;
entity graphics_gamma_more;
entity graphics_gamma_less;

entity graphics_back;
entity graphics_accept;
entity graphics_defaults;

entity graphics_resolution_change;

entity graphics_junk;

//graphics constants
float options_graphics_submenu;

#define SUB_GRAPHICS_MAIN 1
#define SUB_GRAPHICS_RESO 2

vector VID_NEXT;
vector VID_CNEXT;

float ACCEPT_TIMER;
float ACCEPT_PAUSE = 3;

string(float val) graphics_get_detail={
  local string lbl;
  switch(val){
    case 0:
      lbl = "DEFAULT";
      break;
    case 1:
      lbl = "LOW";
      break;
    case 2:
      lbl = "MEDIUM";
      break;
    case 3:
      lbl = "HIGH";
      break;
  }
  return lbl;
};

void() m_graphics_background =
{
	local float ini_alpha = 1;
	
	local vector bimg = gui_newAspectRatio(drawgetimagesize("gfx/menu/background3.tga"), Vector2(VIEW_WIDTH, VIEW_MAX_y));	
	
	if (random() < 0.3)
	{
		graphics_junk = lbl_img(ANCHOR_UPPER_LEFT, bimg, "gfx/menu/background.tga", '1 1 1', 0, M_OPTIONS_GRAPHICS, ini_alpha, (UI_FLAG_IMG_SIZE_ASPECT) );
	}
	else if (random() < 0.6)
	{
		graphics_junk = lbl_img(ANCHOR_UPPER_LEFT, bimg, "gfx/menu/background3.tga", '1 1 1', 0, M_OPTIONS_GRAPHICS, ini_alpha, (UI_FLAG_IMG_SIZE_ASPECT) );	
	}
	else if (random() < 1)
	{
		graphics_junk = lbl_img(ANCHOR_UPPER_LEFT, bimg, "gfx/menu/background2.tga", '1 1 1', 0, M_OPTIONS_GRAPHICS, ini_alpha, (UI_FLAG_IMG_SIZE_ASPECT) );	
	}
}


void(float level) graphics_effects_set={
  local string cvars;
  switch(level){
    default:
      cvars = "data/cache/settings/graphics_medium.cvl";
      break;
    case 2:
      cvars = "data/cache/settings/graphics_low.cvl"; 
      break;
    case 3:
      cvars = "data/cache/settings/graphics_medium.cvl";
      break;
    case 4:
      cvars = "data/cache/settings/graphics_high.cvl";
      break;
  }
  menu_execute_cvar_list(cvars);
};

string(float level) graphics_set_texture_quality_label={
  switch(level){
    case 4:
      return "VERY LOW";
    case 3:
      return "LOW";
    case 2:
      return "PERFORMANCE";
    case 1:
      return "NORMAL";
    case 0:
      return "ULTRA";
  }
  return "NORMAL";
};

void() graphics_reso_back={
  VID_NEXT = '0 0 0';
  VID_CNEXT = '0 0 0';
  
  graphics_resolution_aspect_lbl.len = graphics_resolution_lbl.len = menu_getvideo_modeid();
  
  freeGlobalString(graphics_resolution_lbl.label)
  cacheGlobalString(graphics_resolution_lbl.label, menu_getvideo_clean(graphics_resolution_lbl.len))
  
  freeGlobalString(graphics_resolution_aspect_lbl.label)
  cacheGlobalString(graphics_resolution_aspect_lbl.label, VID_RESO_NAME[graphics_resolution_lbl.len])
};

void(float choice) graphics_reso_menu={
  local entity reso_list, opt_list;

  reso_list = findchainfloat(subid, SUB_GRAPHICS_RESO);
  while(reso_list){
    reso_list.drawme = choice;
    reso_list = reso_list.chain;
  }
  
  if(choice)
  {
    options_graphics_submenu = SUB_GRAPHICS_RESO;
  }
  else
  {
    options_graphics_submenu = SUB_GRAPHICS_MAIN;
	}
  
  opt_list = findchainfloat( subid, SUB_GRAPHICS_MAIN);
  while(opt_list){
    opt_list.drawme = !choice;
    opt_list = opt_list.chain;
  }
};

//graphics callbacks

void() click_graphics_reso_change =
{

	options_graphics_submenu = SUB_GRAPHICS_RESO;

  menu_parent_setup(VIEW_ORG + '0 40', '512 400');
  
  graphics_reso_menu(TRUE);

};

void() click_graphics_reso_select={
  
  menu_parent_setup(VIEW_ORG + '0 40', '448 384');
  
  VID_NEXT = VID_RESO_SIZE[self.len];
  VID_CNEXT = VID_RESO_HALF[self.len];
  
  freeGlobalString(graphics_resolution_lbl.label)
  cacheGlobalString(graphics_resolution_lbl.label, menu_getvideo_clean(self.len) )

  graphics_resolution_lbl.len = self.len;

  freeGlobalString(graphics_resolution_aspect_lbl.label)
  cacheGlobalString(graphics_resolution_aspect_lbl.label,VID_RESO_NAME[self.len] )
  
  graphics_reso_menu(FALSE);
};


void() click_graphics_bits_less={
  graphics_bits_lbl.len = 16;
  graphics_bits_less.drawme = FALSE;
  graphics_bits_more.drawme = TRUE;
};
void() click_graphics_bits_more={
  graphics_bits_lbl.len = 32;
  graphics_bits_less.drawme = TRUE;
  graphics_bits_more.drawme = FALSE;
};

void() click_refresh_rate_up={
  local float rate;
  rate = graphics_refresh_rate_lbl.len;
  rate = rate + 10;
  if(rate > 120){
    rate = 120;
    graphics_refresh_rate_up.drawme = FALSE;
  }
  graphics_refresh_rate_lbl.len = rate;
  if( !graphics_refresh_rate_dn.drawme ){
    graphics_refresh_rate_dn.drawme = TRUE;
  }
};
void() click_refresh_rate_dn={
  local float rate;
  rate = graphics_refresh_rate_lbl.len;
  rate = rate - 10;
  if(rate < 50){
    rate = 50;
    graphics_refresh_rate_dn.drawme = FALSE;
  }
  graphics_refresh_rate_lbl.len = rate;
  
  if( !graphics_refresh_rate_up.drawme ){
    graphics_refresh_rate_up.drawme = TRUE;
  }
};

void() click_graphics_aniso_more={
  local float sampl;
  sampl = graphics_aniso_lbl.len;
  
  if( sampl == 0 ){
    sampl = 1;
  }
  else{
    sampl = sampl * 2;
  }
  if(sampl >= 32){
    sampl = 32;
    graphics_aniso_more.drawme = FALSE;
  }
  if( !graphics_aniso_less.drawme ){
    graphics_aniso_less.drawme = TRUE;
  }
  graphics_aniso_lbl.len = sampl;
};
void() click_graphics_aniso_less={
  local float sampl;
  
  sampl = graphics_aniso_lbl.len;
  if( sampl > 1){
    sampl = sampl / 2;
  }
  else{
    sampl = 0;
  }
  if(sampl == 0){
    graphics_aniso_less.drawme = FALSE;
  }
  if( !graphics_aniso_more.drawme ){
    graphics_aniso_more.drawme = TRUE;
  }
  graphics_aniso_lbl.len = sampl;
};

void() click_graphics_texture_quality_more={
  local float sampl;
  sampl = graphics_texture_quality_lbl.len;
  sampl = sampl - 1;
  if(sampl <= 0){
    sampl = 0;
    graphics_texture_quality_more.drawme = FALSE;
  }
  if( !graphics_texture_quality_less.drawme ){
    graphics_texture_quality_less.drawme = TRUE;
  }
  graphics_texture_quality_lbl.len = sampl;
  graphics_texture_quality_lbl.label = graphics_set_texture_quality_label(sampl);
};
void() click_graphics_texture_quality_less={
  local float sampl;
  sampl = graphics_texture_quality_lbl.len;
  sampl = sampl + 1;
  if(sampl >= 4){
    sampl = 4;
    graphics_texture_quality_less.drawme = FALSE;
  }
  graphics_texture_quality_lbl.len = sampl;
  if( !graphics_texture_quality_more.drawme ){
    graphics_texture_quality_more.drawme = TRUE;
  }
  graphics_texture_quality_lbl.label =  graphics_set_texture_quality_label(sampl);
};

void() click_graphics_effects_more={
  local float level;
  level = graphics_effects_lbl.len;
  level = level + 1;
  if( level > 0){ 
   // graphics_effects_custom.drawme = FALSE;
  }
  if(level >= 3){
    level = 3;
   // graphics_effects_more.drawme = FALSE;
  }
  if(level != 0){
    graphics_effects_set(level);
  }
  graphics_effects_lbl.label = graphics_get_detail(level);
  graphics_effects_lbl.len = level;
  if( !graphics_effects_less.drawme ){
    graphics_effects_less.drawme = TRUE;
  }
};

void() click_graphics_effects_less={
  local float level;
  level = graphics_effects_lbl.len;
  level = level - 1;
  if(level <= 0){
    level = 0;
    graphics_effects_less.drawme = FALSE;
   // graphics_effects_custom.drawme = TRUE;
  }
  if(level != 0){
    graphics_effects_set(level);
  }
  graphics_effects_lbl.label = graphics_get_detail(level);
  graphics_effects_lbl.len = level;
  if( !graphics_effects_more.drawme ){
    graphics_effects_more.drawme = TRUE;
  }
};

void() click_graphics_gfx={
  menu_clear_items(M_STATE);
  m_gfx_f();
};

void() click_graphics_effects={
  menu_clear_items(M_STATE);
  m_effects_f();
};

void() click_contrast_up={
  local float rate;
  rate = graphics_game_contrast_lbl.len;
  rate = rate + 0.062;
  if(rate >= 4){
    rate = 4;
    graphics_game_contrast_more.drawme = FALSE;
  }
  cacheGlobalString( graphics_game_contrast_lbl.label, sprintf("%0.3f", rate))
  graphics_game_contrast_lbl.len = rate;
  cvar_set("v_contrast",  graphics_game_contrast_lbl.label);
  graphics_game_contrast_less.drawme = TRUE;

//	graphics_game_contrast_image.alpha += graphics_game_contrast_lbl.len / 4;

  
};
void() click_contrast_dn={
  local float rate;
  rate = graphics_game_contrast_lbl.len;
  rate = rate - 0.062;
  if(rate <= 1){
    rate = 1;
    graphics_game_contrast_less.drawme = FALSE;
  }
  cacheGlobalString( graphics_game_contrast_lbl.label, sprintf("%0.3f", rate))
  graphics_game_contrast_lbl.len = rate;
  cvar_set("v_contrast",  graphics_game_contrast_lbl.label);
  graphics_game_contrast_more.drawme = TRUE;

//	graphics_game_contrast_image.alpha -= graphics_game_contrast_lbl.len / 4;  
  
};

void() click_gamma_up={
  local float rate;
  rate = graphics_gamma_lbl.len;
  rate = rate + 0.062;
  if(rate >= 3){
    rate = 3;
    graphics_gamma_more.drawme = FALSE;
  }
  cacheGlobalString( graphics_gamma_lbl.label, sprintf("%0.3f", rate))
  graphics_gamma_lbl.len = rate;
  cvar_set("v_gamma",  graphics_gamma_lbl.label);
  graphics_gamma_less.drawme = TRUE;

//	graphics_game_brightness_image.alpha += graphics_gamma_lbl.len / 4;
  
};
void() click_gamma_dn={
  local float rate;
  rate = graphics_gamma_lbl.len;
  rate = rate - 0.062;
  if(rate <= 1){
    rate = 1;
    graphics_gamma_less.drawme = FALSE;
  }
  cacheGlobalString( graphics_gamma_lbl.label, sprintf("%0.3f", rate))
  graphics_gamma_lbl.len = rate;
  cvar_set("v_gamma",  graphics_gamma_lbl.label);
  graphics_gamma_more.drawme = TRUE;

//	graphics_game_brightness_image.alpha += graphics_gamma_lbl.len / 4;
  
};

void() click_graphics_fxaa_more={
  if(graphics_fxaa_lbl.len == 0 ){
    graphics_fxaa_lbl.len = graphics_fxaa_lbl.len + 1;
  }
  else{
    graphics_fxaa_lbl.len = graphics_fxaa_lbl.len * 2;
  }
  
  if( graphics_fxaa_lbl.len > 4 ){
    graphics_fxaa_lbl.len = 8;
    graphics_fxaa_more.drawme = FALSE;
  }
  graphics_fxaa_less.drawme = TRUE;
};
void() click_graphics_fxaa_less={
  if(graphics_fxaa_lbl.len == 1 ){
    graphics_fxaa_lbl.len = graphics_fxaa_lbl.len - 1;
  }
  else{
    graphics_fxaa_lbl.len = rint(graphics_fxaa_lbl.len * 0.5);
  }
  
  if( graphics_fxaa_lbl.len == 0){
    graphics_fxaa_lbl.len = 0;
    graphics_fxaa_less.drawme = FALSE;
  }
  graphics_fxaa_more.drawme = TRUE;
};

void() click_graphics_back={
  
  if(options_graphics_submenu == SUB_GRAPHICS_RESO ){
    graphics_reso_menu(FALSE);
    graphics_reso_back();
    return;
  }

  menu_clear_items(M_STATE);
  m_options_f();
};

void() click_graphics_accept =
{
  if( gettime() < ACCEPT_TIMER ){
    return;
  }
  ACCEPT_TIMER = gettime() + ACCEPT_PAUSE;
  
  cvar_set("vid_borderless", ftos(new_graphics_borderless_check.len));
  
  cvar_set("r_fxaa", ftos(graphics_fxaa_lbl.len));
  
  cvar_set("vid_bitsperpixel", ftos(graphics_bits_lbl.len));
  
  //vid_samples is...broken I think engine-side.
  //cvar_set("vid_samples", ftos(graphics_aa_lbl.len));
  
  if(graphics_refresh_rate_lbl.len != FALSE){
    cvar_set("vid_userefreshrate", ftos(rint(new_graphics_refresh_check.len)));
    cvar_set("vid_refreshrate", ftos(rint(graphics_refresh_rate_lbl.len)));
  }
  else{
    cvar_set("vid_userefreshrate", ftos(0));
    cvar_set("vid_refreshrate", ftos(0));
  }
  //cvar_set("vid_fullscreen", ftos(graphics_fullscreen_lbl.len));
  cvar_set("vid_fullscreen", ftos(new_graphics_fullscreen_check.len));
  cvar_set("vid_vsync", ftos(new_graphics_vsync_check.len));
  cvar_set("gl_texture_anisotropy", ftos(graphics_aniso_lbl.len));
  cvar_set("gl_picmip", ftos(graphics_texture_quality_lbl.len));
  cvar_set("gl_texturecompression", ftos(new_graphics_texture_compress_check.len));
  cvar_set("saved1", ftos(graphics_effects_lbl.len));
  //cvar_set("saved2", ftos(graphics_gfx_lbl.len));
  
  
  if(VID_NEXT != '0 0 0'){
    cvar_set("vid_width", ftos(rint(VID_NEXT_x)));
    cvar_set("vid_height", ftos(rint(VID_NEXT_y)));
    cvar_set("vid_pixelheight", ftos(rint(VID_NEXT_z)));
    cvar_set("vid_conwidthauto", "1"); //enforced
    //cvar_set("vid_conwidth", ftos(rint(VID_CNEXT_x)));
    //cvar_set("vid_conheight",ftos(rint(VID_CNEXT_y)));
    VID_NEXT = '0 0 0';
  }
  //m_graphics_f();
  graphics_effects_set(cvar("saved1"));
  localcmd("saveconfig;\n");
  localcmd("vid_restart;\n");
  RESO_CHANGE = TRUE;
  //apparently also loads autoexec.cfg and .rc
};

void() click_graphics_defaults =
{
	aspect = VIEW_MAX_x / VIEW_MAX_y;
	updateAnchorPos();
};

void() m_graphics_i;

void() m_graphics_back_and_accept =
{
	local float offset_from_bottom = 48;

	if(options_graphics_submenu == SUB_GRAPHICS_RESO )
	{
		graphics_reso_back();
		m_graphics_i();
		return;
	}	
	
	//BACK and ACCEPT (should anchor with res)
    local string lbl = "BACK";
	local float lblLen = stringwidth(lbl, 0, '32 32 0');
  
	local vector lowerLeft = VIEW_ORG;
	lowerLeft_y = lowerLeft_y + VIEW_MAX_y - offset_from_bottom;
	lowerLeft_x = lowerLeft_x + 24;	
	
	local vector lowerRight = VIEW_MAX;
	lowerRight_x = lowerRight_x - lblLen;
	lowerRight_y = lowerRight_y - offset_from_bottom;
  
	//LOWER LEFT
	graphics_back = btn_text_callback(lowerLeft, '32 32', "BACK", VIEW_LFT, M_OPTIONS_GRAPHICS, click_graphics_back, CLR_MENU_BLUE, '0 1 0', 1, UI_FLAG_SIZE_IMG);
	graphics_back.fontId = FONT_NUM_BLACKOPS_BOLD;
   
    lbl = "ACCEPT";
	lblLen = stringwidth(lbl, 0, '32 32 0');
   
	//LOWER RIGHT
	graphics_accept = btn_text_callback(lowerRight, '32 32', "ACCEPT", VIEW_CTX, M_OPTIONS_GRAPHICS, click_graphics_accept, CLR_MENU_BLUE, '0 1 0', 1, UI_FLAG_SIZE_IMG);
	graphics_accept.fontId = FONT_NUM_BLACKOPS_BOLD;
	graphics_accept.subid = SUB_GRAPHICS_MAIN;

	//CENTER
	graphics_defaults = btn_text_callback(ANCHOR_LOWER_CENTER + '0 -50', '32 32', "DEFAULTS", VIEW_CTX, M_OPTIONS_GRAPHICS, click_graphics_defaults, CLR_MENU_BLUE, '0 1 0', 1, UI_FLAG_SIZE_IMG);
	graphics_defaults.fontId = FONT_NUM_BLACKOPS_BOLD;
	graphics_defaults.subid = SUB_GRAPHICS_MAIN;	
}

void() new_graphics_refresh_check_callback =
{
	if( new_graphics_refresh_check.len == TRUE )
	{
		graphics_refresh_rate_up.drawme = TRUE;
		graphics_refresh_rate_dn.drawme = TRUE;
		graphics_refresh_rate_lbl.color = CLR_DEF_ARM_OK;
	}
	else
	{
		graphics_refresh_rate_up.drawme = FALSE;
		graphics_refresh_rate_dn.drawme = FALSE;
		graphics_refresh_rate_lbl.color = CLR_DEF_GRAY_H;
	}
};

void() m_display_header =
{
  host_title = lbl_text_centered(ANCHOR_UPPER_CENTER + '0 20', '44 44', "GRAPHICS", CLR_DEF_TXT_GRAY_SMOOTH, 0, M_OPTIONS_GRAPHICS, 1, 0);
  host_title.fontId = FONT_NUM_BLACKOPS_BOLD;
  host_title = lbl_img(host_title.origin + '90 -10', '1 1 0', IMG_SUBMENUHEADER_BG, '1 1 1', VIEW_CTX, M_OPTIONS_GRAPHICS, 1, UI_FLAG_SIZE_IMG );
}

// ini function, called by '_f' function as a setup func
void() m_graphics_i =
{
	local float vid;
	local string reso;
	local float row, col;
	local vector startOrg;
	local float idx;
	local entity reso_list;	
	  
	options_graphics_submenu = SUB_GRAPHICS_MAIN;

	//menu_parent_setup((VIEW_ORG + (VIEW_CTR * 0.5)) + '0 -50', '450 380');
	//menu_parent_setup((VIEW_ORG + (VIEW_CTR * 0.5)) + '0 -100', '450 380');
	
	
/*
	if (aspect < 1.78)
	{ //16:9
		menu_parent_setup(ANCHOR_CENTER_LEFT + '100 -215', '0 0');
	}
	else if (aspect < 1.34)
	{ //4:3
		menu_parent_setup(ANCHOR_CENTER_LEFT + '-25 -215', '0 0');
	}	
*/
	
		menu_parent_setup(ANCHOR_CENTER_LEFT + '100 -215', '0 0');
	
	VID_NEXT = '0 0 0'; //initialize this here so its not null;

	m_display_header();
	
  	/*
	RESOLUTION
	*/
	vid = menu_getvideo_modeid();
	reso = strcat(ftos(VIEW_ACT_x), " x ", ftos(VIEW_ACT_y) );
	//graphics_resolution_lbl = lbl_text_centered(MENU_ORG + '175 82', '14 14', "", CLR_MENU_BLUE, VIEW_CTX, M_OPTIONS_GRAPHICS, 1, 0);
	graphics_resolution_lbl = btn_text_callback(MENU_ORG + '97.5 90', '16 16', "", 0, M_OPTIONS_GRAPHICS, click_graphics_reso_change, CLR_MENU_BLUE, '0 1 0', 1, UI_FLAG_SIZE_IMG );
	graphics_resolution_lbl.subid = SUB_GRAPHICS_MAIN;
	graphics_resolution_lbl.len = vid;
	cacheGlobalString(graphics_resolution_lbl.label, reso)

	//graphics_resolution_change = btn_text_callback(graphics_resolution_lbl.origin + '0 16', '16 16', "CHANGE", 0, M_OPTIONS_GRAPHICS, click_graphics_reso_change, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, UI_FLAG_SIZE_IMG );
	//graphics_resolution_change.subid = SUB_GRAPHICS_MAIN;
	  
	startOrg = MENU_ORG + '25 125';
	
	for(row=0; row < 14; row = row + 1)
	{
		for(col=0; col < 4; col = col + 1)
		{
			idx = (row * 4) + col;
			
			if( idx < VID_RESO_TOTAL )
			{
				reso = VID_RESO_NAME[idx];
				//reso_list = btn_text_callback(startOrg + Vector2(col * max(stringwidth(reso, 0, '12 12'), 128), row * 25), '12 12', "", 0, M_OPTIONS_GRAPHICS, click_graphics_reso_select, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, UI_FLAG_SIZE_IMG);
				reso_list = btn_text_callback(startOrg + Vector2(col * max(stringwidth(reso, 0, '16 16'), 128), row * 25), '16 16', "", 0, M_OPTIONS_GRAPHICS, click_graphics_reso_select, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, UI_FLAG_SIZE_IMG);
				reso_list.len = idx;
				reso_list.subid = SUB_GRAPHICS_RESO;
				cacheGlobalString( reso_list.label, reso)
				reso_list.fontId = FONT_NUM_ROBOT_REGULAR;
			}
		}
	}
	
  	/*
	BORDERLESS WINDOW
	*/  

	new_graphics_borderless_check = btn_check_callback(MENU_ORG + '150 142', '14 14', 0, M_OPTIONS_GRAPHICS, 0, CLR_DEF_TXT_GRAY_SMOOTH, '1 1 1', 1, 0);
	//new_graphics_borderless_check.label = "Borderless Window  ";
	new_graphics_borderless_check.len = cvar("vid_borderless");
	new_graphics_borderless_check.subid = SUB_GRAPHICS_MAIN;	
  
  	/*
	FXAA
	*/
	graphics_fxaa_lbl = lbl_text(MENU_ORG + '150 162', '14 14', "", CLR_DEF_WHITE, VIEW_CTX, M_OPTIONS_GRAPHICS, 1, UI_FLAG_LBL_USELEN);
	graphics_fxaa_lbl.len = cvar("r_fxaa");
	graphics_fxaa_more = btn_img_callback(graphics_fxaa_lbl.origin + Vector2(stringwidth(ftos(graphics_fxaa_lbl.len), 0, graphics_fxaa_lbl.size), 0), '12 12', UI_IMG_PLUS, 0, M_OPTIONS_GRAPHICS, click_graphics_fxaa_more, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
	graphics_fxaa_less = btn_img_callback(graphics_fxaa_lbl.origin - '20 0', '12 12', UI_IMG_MINUS, 0, M_OPTIONS_GRAPHICS, click_graphics_fxaa_less, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

	if(graphics_fxaa_lbl.len >= 8)
	{
		graphics_fxaa_more.drawme = FALSE;
	}
	else
	{
		if(graphics_fxaa_lbl.len >= 0)
		{
			graphics_fxaa_less.drawme = TRUE;
		}
		else
		{
			graphics_fxaa_less.drawme = FALSE;	
		}
	}
	cacheGlobalString(graphics_fxaa_lbl.label, ftos(graphics_fxaa_lbl.len))
  
	/*
	PIXEL BITS
	*/
	graphics_bits_lbl = lbl_text(MENU_ORG + '150 182', '14 14', "", CLR_DEF_WHITE, VIEW_CTX, M_OPTIONS_GRAPHICS, 1, UI_FLAG_LBL_USELEN);
	graphics_bits_lbl.len = cvar("vid_bitsperpixel");
	graphics_bits_more = btn_img_callback(graphics_bits_lbl.origin + Vector2(stringwidth(ftos(graphics_bits_lbl.len), 0, graphics_bits_lbl.size), 0), '12 12', UI_IMG_PLUS, 0, M_OPTIONS_GRAPHICS, click_graphics_bits_more, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
	graphics_bits_less = btn_img_callback(graphics_bits_lbl.origin - '20 0', '12 12', UI_IMG_MINUS, 0, M_OPTIONS_GRAPHICS, click_graphics_bits_less, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

	if(graphics_bits_lbl.len == 32)
	{
		graphics_bits_more.drawme = FALSE;
	}
	else
	{
		graphics_bits_less.drawme = FALSE;
	}
   
	/*
	REFRESH
	*/
	new_graphics_refresh_check = btn_check_callback(MENU_ORG + '150 202', '14 14', 0, M_OPTIONS_GRAPHICS, new_graphics_refresh_check_callback, CLR_DEF_TXT_GRAY_SMOOTH, '1 1 1', 1, 0);
	//new_graphics_refresh_check.label = "Use Custom Refresh Rate  ";
	new_graphics_refresh_check.len = cvar("vid_userefreshrate");  

	graphics_refresh_rate_lbl = lbl_text(MENU_ORG + '150 222', '14 14 0', "60", CLR_DEF_WHITE, VIEW_CTX, M_OPTIONS_GRAPHICS, 1, UI_FLAG_LBL_USELEN);
	graphics_refresh_rate_lbl.len =  cvar("vid_refreshrate");
	graphics_refresh_rate_up = btn_img_callback(graphics_refresh_rate_lbl.origin + Vector2(stringwidth(graphics_refresh_rate_lbl.label, 0, graphics_refresh_rate_lbl.size), 0), '12 12', UI_IMG_ARW_RGT, 0, M_OPTIONS_GRAPHICS, click_refresh_rate_up, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
	graphics_refresh_rate_dn = btn_img_callback(graphics_refresh_rate_lbl.origin - '20 0', '12 12', UI_IMG_ARW_LFT, 0, M_OPTIONS_GRAPHICS, click_refresh_rate_dn, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  
	if(new_graphics_refresh_check.len == FALSE)
	{
		graphics_refresh_rate_lbl.color = CLR_DEF_GRAY_H;
		graphics_refresh_rate_lbl.len = 60;
		graphics_refresh_rate_up.drawme = FALSE;
		graphics_refresh_rate_dn.drawme = FALSE;
	}
	else if (new_graphics_refresh_check.len == TRUE)
	{
		graphics_refresh_rate_lbl.color = CLR_DEF_ARM_OK;
	}

	/*
	FULLSCREEN
	*/
	
	new_graphics_fullscreen_check = btn_check_callback(MENU_ORG + '150 242', '14 14', 0, M_OPTIONS_GRAPHICS, 0, CLR_DEF_TXT_GRAY_SMOOTH, '1 1 1', 1, 0);
	//new_graphics_fullscreen_check.label = "Fullscreen  ";
	new_graphics_fullscreen_check.len = cvar("vid_fullscreen");  
  
	/*
	VSYNC
	*/
	new_graphics_vsync_check = btn_check_callback(MENU_ORG + '150 262', '14 14', 0, M_OPTIONS_GRAPHICS, 0, CLR_DEF_TXT_GRAY_SMOOTH, '1 1 1', 1, 0);
	//new_graphics_vsync_check.label = "VSYNC  ";
	new_graphics_vsync_check.len = cvar("vid_vsync"); 

	/*
	ANISOTROPY
	*/
	graphics_aniso_lbl = lbl_text(MENU_ORG + '150 282', '14 14', "16", CLR_DEF_WHITE, VIEW_CTX, M_OPTIONS_GRAPHICS, 1, UI_FLAG_LBL_USELEN);
	graphics_aniso_lbl.len = cvar("gl_texture_anisotropy");
	graphics_aniso_more = btn_img_callback(graphics_aniso_lbl.origin + Vector2(stringwidth(graphics_aniso_lbl.label, 0, graphics_aniso_lbl.size), 0), '12 12', UI_IMG_PLUS, 0 , M_OPTIONS_GRAPHICS, click_graphics_aniso_more, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
	graphics_aniso_less = btn_img_callback(graphics_aniso_lbl.origin - '20 0', '12 12', UI_IMG_MINUS, 0, M_OPTIONS_GRAPHICS, click_graphics_aniso_less, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  
	if(graphics_aniso_lbl.len == 32)
	{
		graphics_aniso_more.drawme = FALSE;
	}
	else if(graphics_aniso_lbl.len == 0)
	{
		graphics_aniso_less.drawme = FALSE;
	}
  
	/*
	TEXTURE QUALITY
	*/
	graphics_texture_quality_lbl = lbl_text(MENU_ORG + '150 302', '14 14', graphics_set_texture_quality_label(cvar("gl_picmip")), CLR_DEF_WHITE, VIEW_CTX, M_OPTIONS_GRAPHICS, 1, 0);
	graphics_texture_quality_lbl.len = cvar("gl_picmip");
	graphics_texture_quality_more = btn_img_callback(graphics_texture_quality_lbl.origin + Vector2(stringwidth(graphics_texture_quality_lbl.label, 0, graphics_texture_quality_lbl.size), 0), '12 12', UI_IMG_PLUS, 0, M_OPTIONS_GRAPHICS, click_graphics_texture_quality_more, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
	graphics_texture_quality_less = btn_img_callback(graphics_texture_quality_lbl.origin - '20 0', '12 12', UI_IMG_MINUS, 0, M_OPTIONS_GRAPHICS, click_graphics_texture_quality_less, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
	 
	if(graphics_texture_quality_lbl.len == 0)
	{
		graphics_texture_quality_more.drawme = FALSE;
	}
	else if(graphics_texture_quality_lbl.len == 4)
	{
		graphics_texture_quality_less.drawme = FALSE;
	}

	/*
	TEXTURE COMPRESSION
	*/
	new_graphics_texture_compress_check = btn_check_callback(MENU_ORG + '150 322', '14 14', 0, M_OPTIONS_GRAPHICS, 0, CLR_DEF_TXT_GRAY_SMOOTH, '1 1 1', 1, 0);
	//new_graphics_texture_compress_check.label = "Texture Compression  ";
	new_graphics_texture_compress_check.len = cvar("gl_texturecompression");   
  
	/*
	OVERALL QUALITY
	*/
	graphics_effects_lbl = lbl_text(MENU_ORG + '150 122', '14 14', graphics_get_detail(cvar("saved1")), CLR_DEF_WHITE,VIEW_CTX, M_OPTIONS_GRAPHICS, 1, 0);
	graphics_effects_lbl.len = cvar("saved1");
	graphics_effects_lbl.label = graphics_get_detail(cvar("saved1"));	
	graphics_effects_more = btn_img_callback(graphics_effects_lbl.origin + Vector2(stringwidth("MEDIUM", 0, graphics_effects_lbl.size), 0), '12 12', UI_IMG_PLUS, 0, M_OPTIONS_GRAPHICS, click_graphics_effects_more, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
	graphics_effects_less = btn_img_callback(graphics_effects_lbl.origin - '20 0', '12 12', UI_IMG_MINUS, 0, M_OPTIONS_GRAPHICS, click_graphics_effects_less, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

	/*
	CONTRAST
	*/
	//Contrast label position also affects graphics_gamma_lbl and preview image
	graphics_game_contrast_lbl = lbl_text(ANCHOR_CENTER_75 + '0 85', '14 14', "", CLR_DEF_WHITE, VIEW_CTX, M_OPTIONS_GRAPHICS, 1, 0);
	graphics_game_contrast_lbl.len = cvar("v_contrast");
  
	cacheGlobalString( graphics_game_contrast_lbl.label, sprintf("%0.3f", graphics_game_contrast_lbl.len))
  
	graphics_game_contrast_more = btn_img_callback(graphics_game_contrast_lbl.origin + Vector2(stringwidth(graphics_game_contrast_lbl.label, 0, graphics_game_contrast_lbl.size), 0), '12 12', UI_IMG_PLUS, 0, M_OPTIONS_GRAPHICS, click_contrast_up, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
	graphics_game_contrast_less = btn_img_callback(graphics_game_contrast_lbl.origin - '20 0', '12 12', UI_IMG_MINUS, 0, M_OPTIONS_GRAPHICS, click_contrast_dn, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

	/*
	  if(graphics_game_contrast_lbl.len >= 4){
		graphics_game_contrast_more.drawme = FALSE;
	  }
	  else if (graphics_game_contrast_lbl.len <= 1){
		graphics_game_contrast_less.drawme = FALSE;
	  }
	*/
	
	/*
	GAMMA
	*/ 
	graphics_gamma_lbl = lbl_text(graphics_game_contrast_lbl.origin + '0 20', '14 14', "", CLR_DEF_WHITE, VIEW_CTX, M_OPTIONS_GRAPHICS, 1, 0);
	graphics_gamma_lbl.len = cvar("v_gamma");
  
	cacheGlobalString( graphics_gamma_lbl.label, sprintf("%0.3f", graphics_gamma_lbl.len))
  
	graphics_gamma_more = btn_img_callback(graphics_gamma_lbl.origin + Vector2(stringwidth(graphics_gamma_lbl.label, 0, graphics_gamma_lbl.size), 0), '12 12', UI_IMG_PLUS, 0, M_OPTIONS_GRAPHICS, click_gamma_up, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
	graphics_gamma_less = btn_img_callback(graphics_gamma_lbl.origin - '20 0', '12 12', UI_IMG_MINUS, 0, M_OPTIONS_GRAPHICS, click_gamma_dn, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

	/*
	  if(graphics_game_contrast_lbl.len >= 3){
		graphics_gamma_more.drawme = FALSE;
	  }
	  else if (graphics_game_contrast_lbl.len <= 1){
		graphics_gamma_less.drawme = FALSE;
	  }
	*/

	//graphics_brightnesscontrastimage = lbl_img(graphics_game_contrast_lbl.origin + '-30 -150', '1 1 0', "gfx/menu/brightnesscontrastimage.png", '1 1 1', VIEW_CTX, M_OPTIONS_GRAPHICS, 1, UI_FLAG_SIZE_IMG );

	if(!(clientstate() == CS_CONNECTED))
	{
		//graphics_game_contrast_image = lbl_img(graphics_game_contrast_lbl.origin + '-30 -115', '256 192 0', "gfx/menu/menu_screenshot_contrast.jpg", '1 1 1', VIEW_CTX, M_OPTIONS_GRAPHICS, 1, UI_FLAG_CENTER_IMG );
		graphics_game_contrast_image = lbl_img(graphics_game_contrast_lbl.origin + '-30 -115', '256 192 0', "gfx/menu/menu_screenshot_contrast.jpg", '1 1 1', VIEW_CTX, M_OPTIONS_GRAPHICS, 1, UI_FLAG_CENTER_IMG );
		//graphics_game_brightness_image = lbl_img(graphics_game_contrast_lbl.origin + '-30 -115', '256 192 0', "gfx/menu/menu_screenshot_gamma.jpg", '1 1 1', VIEW_CTX, M_OPTIONS_GRAPHICS, 1, UI_FLAG_CENTER_IMG );
		graphics_game_brightness_image = lbl_img(graphics_game_contrast_lbl.origin + '-30 -115', '256 192 0', "gfx/menu/menu_screenshot_gamma.jpg", '1 1 1', VIEW_CTX, M_OPTIONS_GRAPHICS, 1, UI_FLAG_CENTER_IMG );
		graphics_game_image = lbl_img(graphics_game_contrast_lbl.origin + '-30 -115', '256 192 0', "gfx/menu/menu_screenshot_base2.jpg", '1 1 1', VIEW_CTX, M_OPTIONS_GRAPHICS, 1, UI_FLAG_CENTER_IMG );
		
	}
  
	//Back and Accept
	m_graphics_back_and_accept();
  
	//assign sub menu
	graphics_resolution_change.subid = SUB_GRAPHICS_MAIN;
  
	new_graphics_refresh_check.subid = SUB_GRAPHICS_MAIN;
	new_graphics_fullscreen_check.subid = SUB_GRAPHICS_MAIN;
	new_graphics_vsync_check.subid = SUB_GRAPHICS_MAIN;
	new_graphics_texture_compress_check.subid = SUB_GRAPHICS_MAIN;
	new_graphics_borderless_check.subid = SUB_GRAPHICS_MAIN; 

	graphics_fxaa_lbl.subid = SUB_GRAPHICS_MAIN;
	graphics_fxaa_more.subid = SUB_GRAPHICS_MAIN;
	graphics_fxaa_less.subid = SUB_GRAPHICS_MAIN;
	  
	graphics_bits_lbl.subid = SUB_GRAPHICS_MAIN;
	graphics_bits_less.subid = SUB_GRAPHICS_MAIN;
	graphics_bits_more.subid = SUB_GRAPHICS_MAIN;
	  
	/*
	graphics_aa_lbl.subid = SUB_GRAPHICS_MAIN;
	graphics_aa_more.subid = SUB_GRAPHICS_MAIN;
	graphics_aa_less.subid = SUB_GRAPHICS_MAIN;
	*/
	  
	graphics_refresh_rate_lbl.subid = SUB_GRAPHICS_MAIN;
	graphics_refresh_rate_up.subid = SUB_GRAPHICS_MAIN;
	graphics_refresh_rate_dn.subid = SUB_GRAPHICS_MAIN;
	  
	graphics_aniso_lbl.subid = SUB_GRAPHICS_MAIN;
	graphics_aniso_more.subid = SUB_GRAPHICS_MAIN;
	graphics_aniso_less.subid = SUB_GRAPHICS_MAIN;
	  
	graphics_texture_quality_lbl.subid = SUB_GRAPHICS_MAIN;
	graphics_texture_quality_more.subid = SUB_GRAPHICS_MAIN;
	graphics_texture_quality_less.subid = SUB_GRAPHICS_MAIN;
	  
	graphics_effects_lbl.subid = SUB_GRAPHICS_MAIN;
	graphics_effects_more.subid = SUB_GRAPHICS_MAIN;
	graphics_effects_less.subid = SUB_GRAPHICS_MAIN;
	  
	/*
	graphics_gfx_lbl.subid = SUB_GRAPHICS_MAIN;
	graphics_gfx_more.subid = SUB_GRAPHICS_MAIN;
	graphics_gfx_less.subid = SUB_GRAPHICS_MAIN;
	graphics_gfx_custom.subid = SUB_GRAPHICS_MAIN;
	*/
	
  	if(!(clientstate() == CS_CONNECTED))
	{
	graphics_game_image.subid = SUB_GRAPHICS_MAIN;
	graphics_game_brightness_image.subid = SUB_GRAPHICS_MAIN;
	graphics_game_contrast_image.subid = SUB_GRAPHICS_MAIN;
	}
	
	graphics_game_contrast_lbl.subid = SUB_GRAPHICS_MAIN;
	graphics_game_contrast_more.subid = SUB_GRAPHICS_MAIN;
	graphics_game_contrast_less.subid = SUB_GRAPHICS_MAIN;
	  
	graphics_gamma_lbl.subid = SUB_GRAPHICS_MAIN;
	graphics_gamma_more.subid = SUB_GRAPHICS_MAIN;
	graphics_gamma_less.subid = SUB_GRAPHICS_MAIN;
};

/*
  menu_f functions are like state-transition functions, preparing the menu for the next menu to load
*/
void() m_graphics_f =
{
	aspect = VIEW_MAX_x / VIEW_MAX_y;
	updateAnchorPos();	
	DRAW_MOUSE = TRUE;
	M_STATE = M_OPTIONS_GRAPHICS;
	setkeydest(KEY_MENU);
	menu_ini_display_constants();
	m_graphics_i();
};

#define QUALITY_UPPER_TEXT_OFFSET '0 -90'
#define QUALITY_LOWER_TEXT_OFFSET '0 -70'

/*
  menu_d functions are the render functions, inside m_draw, there's a select case
  running on M_STATE to determine which menu_d to execute.
*/
void() m_graphics_d =
{
	//gui_renderPatch9_1_32(MENU_ORG, MENU_SIZE, '0.35 0.35 0.55', 0.85, 0);
	//gui_renderPatch9_1_32((VIEW_ORG + (VIEW_CTR * 0.5)) + '0 -50', MENU_SIZE, '0.0 0.0 0.0', 0.33, 0);  

	drawfont_prev = drawfont;
	drawfont = FONT_NUM_ROBOT_REGULAR;

	local vector bimg = gui_newAspectRatio(drawgetimagesize("gfx/menu/background3.tga"), Vector2(VIEW_WIDTH, VIEW_MAX_y));
  
	//display
	//gui_renderString("Display", MENU_ORG + '90 40', CLR_DEF_ARM_THREEQ, '16 16', 1, 0);
	//gui_renderString("Current Resolution:", MENU_ORG + '36 60', CLR_DEF_TXT_NONSELECT, '12 12', 1, 0);
	//gui_renderString(strcat(ftos(VIEW_ACT_x),"x",ftos(VIEW_ACT_y)), MENU_ORG + '150 60', CLR_DEF_WHITE, '14 14', 1, 0);
    
	if(!(clientstate() == CS_CONNECTED))
	{
		drawpic(ANCHOR_UPPER_LEFT, "gfx/menu/background3.tga", bimg, '1 1 1', 1, 0);
		
	//	gui_renderString("Adjusting brightness and contrast is best done while in game.", graphics_gamma_less.origin - Vector2(stringwidth("Adjusting brightness and contrast is best done while in game.", 0, '12 12'),0) + '125 20', CLR_DEF_YELLOW, '12 12 0', 1, 0);		
	}
	
	
	//gui_renderString("Display", ANCHOR_CENTER_UL + '90 -50', CLR_DEF_ARM_THREEQ, '16 16', 1, 0);
	//gui_renderString("Current Resolution:", ANCHOR_CENTER_UL + '43 -33', CLR_DEF_TXT_NONSELECT, '12 12', 1, 0);
	gui_renderString("Current Resolution:", graphics_resolution_lbl.origin + '-96 -20', CLR_DEF_TXT_NONSELECT, '12 12', 1, 0);
	gui_renderString(strcat(ftos(VIEW_ACT_x),"x",ftos(VIEW_ACT_y)), graphics_resolution_lbl.origin + '0 -20', CLR_DEF_WHITE, '14 14', 1, 0);

    gui_renderString("New Resolution:", graphics_resolution_lbl.origin - '96 0', CLR_DEF_TXT_NONSELECT, '12 12', 1, 0);

	if( options_graphics_submenu == SUB_GRAPHICS_MAIN )
	{
  //drawstring('4 60', ftos(aspect), '16 16 0', '1 1 0', 1, 0);
		/*
		gui_renderString("Overall Quality:  ", graphics_effects_less.origin - Vector2(stringwidth("Overall Quality:  ", 0, '12 12'),0), CLR_DEF_TXT_NONSELECT, '12 12', 1, 0);
		gui_renderString("Anti-aliasing (FXAA)", graphics_fxaa_less.origin - Vector2(stringwidth("Anti-aliasing (FXAA):  ", 0, '12 12'),0), CLR_DEF_TXT_NONSELECT, '12 12', 1, 0);
		gui_renderString("Bits per pixel:", graphics_bits_less.origin - Vector2(stringwidth("Bits per pixel:  ", 0, '12 12'),0), CLR_DEF_TXT_NONSELECT, '12 12', 1, 0);
		gui_renderString("Refresh Rate:", graphics_refresh_rate_dn.origin - Vector2(stringwidth("Refresh Rate:  ", 0, '12 12'),0), CLR_DEF_TXT_NONSELECT, '12 12', 1, 0);
        gui_renderString("Anisotropic Filter:", graphics_aniso_less.origin - Vector2(stringwidth("Anisotropic Filter:  ", 0, '12 12'),0), CLR_DEF_TXT_NONSELECT, '12 12', 1, 0);
        gui_renderString("Texture Quality:", graphics_texture_quality_less.origin - Vector2(stringwidth("Texture Quality:  ", 0, '12 12'),0), CLR_DEF_TXT_NONSELECT, '12 12', 1, 0);
		*/
		
				
		gui_renderString("Overall Quality:  ", graphics_effects_less.origin - '128 0', CLR_DEF_TXT_NONSELECT, '12 12', 1, 0);
		gui_renderString("Anti-aliasing (FXAA)", graphics_fxaa_less.origin - '128 0', CLR_DEF_TXT_NONSELECT, '12 12', 1, 0);
		gui_renderString("Bits per pixel:", graphics_bits_less.origin - '128 0', CLR_DEF_TXT_NONSELECT, '12 12', 1, 0);
		gui_renderString("Refresh Rate:", graphics_refresh_rate_dn.origin - '128 0', CLR_DEF_TXT_NONSELECT, '12 12', 1, 0);
        gui_renderString("Anisotropic Filter:", graphics_aniso_less.origin - '128 0', CLR_DEF_TXT_NONSELECT, '12 12', 1, 0);
        gui_renderString("Texture Quality:", graphics_texture_quality_less.origin - '128 0', CLR_DEF_TXT_NONSELECT, '12 12', 1, 0);	 
        //Radio Buttons
		gui_renderString("VSYNC:", new_graphics_vsync_check.origin - '148 0', CLR_DEF_TXT_NONSELECT, '12 12', 1, 0); 
		gui_renderString("Borderless Window:", new_graphics_borderless_check.origin - '148 0', CLR_DEF_TXT_NONSELECT, '12 12', 1, 0);
		gui_renderString("Use Custom Refresh Rate:", new_graphics_refresh_check.origin - '148 0', CLR_DEF_TXT_NONSELECT, '12 12', 1, 0);
		gui_renderString("Fullscreen:", new_graphics_fullscreen_check.origin - '148 0', CLR_DEF_TXT_NONSELECT, '12 12', 1, 0);
		gui_renderString("Texture Compression:", new_graphics_texture_compress_check.origin - '148 0', CLR_DEF_TXT_NONSELECT, '12 12', 1, 0);
		
		/* 		
		if (graphics_effects_lbl.len == 0)
		{
			gui_renderString("Overall quality set for balanced play.", (ANCHOR_LOWER_CENTER + '0 -40' - Vector2(stringwidth("Overall quality set for balanced play.", 0, '12 12'),0)/2), CLR_DEF_TXT_NONSELECT, '16 16', 1, 0);
			gui_renderString("Most onboard video systems (i.e. Intel HD4000, AMD R7)", (ANCHOR_LOWER_CENTER + '0 -20' - Vector2(stringwidth("Overall quality set for balanced play.", 0, '12 12'),0)/2), CLR_DEF_TXT_NONSELECT, '16 16', 1, 0);			
		}
		else  
		*/
		
		if (graphics_effects_lbl.len == 1)
		{
			gui_renderString("Overall quality set to low for optimized play.", (ANCHOR_LOWER_CENTER + QUALITY_UPPER_TEXT_OFFSET - Vector2(stringwidth("Overall quality set to low for optimized play.", 0, '16 16'),0)/2), CLR_DEF_TXT_NONSELECT, '16 16', 1, 0);
			gui_renderString("Recommeneded graphics card (i.e GeForce 1030 or AMD RX550)", (ANCHOR_LOWER_CENTER + QUALITY_LOWER_TEXT_OFFSET - Vector2(stringwidth("Recommeneded graphics card (i.e GeForce 1030 or AMD RX550)", 0, '16 16'),0)/2), CLR_DEF_TXT_NONSELECT, '16 16', 1, 0);
		}
		else if (graphics_effects_lbl.len == 2)
		{
			gui_renderString("Overall quality set to medium supporting most systems.",(ANCHOR_LOWER_CENTER + QUALITY_UPPER_TEXT_OFFSET - Vector2(stringwidth("Overall quality set to medium supporting most systems.", 0, '16 16'),0)/2), CLR_DEF_TXT_NONSELECT, '16 16', 1, 0);
			gui_renderString("Recommeneded graphics card (i.e GeForce 1050ti or AMD RX570)", (ANCHOR_LOWER_CENTER + QUALITY_LOWER_TEXT_OFFSET - Vector2(stringwidth("Recommeneded graphics card (i.e GeForce 1050ti or AMD RX570)", 0, '16 16'),0)/2), CLR_DEF_TXT_NONSELECT, '16 16', 1, 0);		
		}
		else if (graphics_effects_lbl.len == 3)
		{
			gui_renderString("Overall quality set to high supporting powerful systems.", (ANCHOR_LOWER_CENTER + QUALITY_UPPER_TEXT_OFFSET - Vector2(stringwidth("Overall quality set to high supporting powerful systems.", 0, '16 16'),0)/2), CLR_DEF_TXT_NONSELECT, '16 16', 1, 0);	
			gui_renderString("Recommeneded graphics card (i.e GeForce 1060 or AMD RX580)", (ANCHOR_LOWER_CENTER + QUALITY_LOWER_TEXT_OFFSET - Vector2(stringwidth("Recommeneded graphics card (i.e GeForce 1060 or AMD RX580)", 0, '16 16'),0)/2), CLR_DEF_TXT_NONSELECT, '16 16', 1, 0);		
		}		
		else
		{
			gui_renderString("Overall quality set for balanced play.", (ANCHOR_LOWER_CENTER + QUALITY_UPPER_TEXT_OFFSET - Vector2(stringwidth("Overall quality set for balanced play.", 0, '16 16'),0)/2), CLR_DEF_TXT_NONSELECT, '16 16', 1, 0);	
			gui_renderString("Most onboard video systems (i.e. Intel HD4000, AMD R7)", (ANCHOR_LOWER_CENTER + QUALITY_LOWER_TEXT_OFFSET - Vector2(stringwidth("Most onboard video systems (i.e. Intel HD4000, AMD R7)", 0, '16 16'),0)/2), CLR_DEF_TXT_NONSELECT, '16 16', 1, 0);	
		}		

		//contrast
		gui_renderString("Video Contrast:", graphics_game_contrast_less.origin - Vector2(stringwidth("Video Contrast:    ", 0, '12 12'),0), CLR_DEF_TXT_NONSELECT, '12 12 0', 1, 0);
		gui_renderString("Video Gamma:", graphics_gamma_less.origin - Vector2(stringwidth("Video Contrast:    ", 0, '12 12'),0), CLR_DEF_TXT_NONSELECT, '12 12 0', 1, 0);
	
		if(!(clientstate() == CS_CONNECTED))
		{
			gui_renderString("Adjusting brightness and contrast is best done while in game.", graphics_gamma_less.origin - Vector2(stringwidth("Adjusting brightness and contrast is best done while in game.", 0, '12 12'),0) + '125 20', CLR_DEF_YELLOW, '12 12 0', 1, 0);		
		}
	}
	drawfont = drawfont_prev;

	//this might not be correct or useful but at least it looks nicer than a big empty space
	if(!(clientstate() == CS_CONNECTED))
	{
		graphics_game_contrast_image.alpha = (cvar("v_contrast") / 4); //max 4.0
		graphics_game_brightness_image.alpha = (cvar("v_gamma") / 3); //max 3.0
	}
	
	local entity widget;

	widget = findchainfloat(menuId, M_OPTIONS_GRAPHICS);
		
	while(widget)
	{
		if( widget.subid == FALSE)
		{
			widget.draw(widget);
		}	    
		else if( widget.subid == options_graphics_submenu)
		{
			widget.draw(widget);
		}
		widget = widget.chain;
	}
};

/*
  menu_k functions are the 'listener' functions
*/
void(float key, float ascii) m_graphics_k={
  //cons_logAFloat("m_graphics_k.key", key);  //DEBUG
  //cons_logAFloat("m_graphics_k.ascii", ascii);  //DEBUG   
  
  if(key == K_ESCAPE){
    localsound("sound/misc/menu2.wav");
    if(options_graphics_submenu == SUB_GRAPHICS_RESO ){
      graphics_reso_menu(FALSE);
      graphics_reso_back();
      return;
    }
    
    menu_clear_items(M_STATE);
    M_STATE = M_OPTIONS;
    m_options_f();
  }
};