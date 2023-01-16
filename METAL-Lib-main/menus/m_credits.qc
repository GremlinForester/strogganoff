/*
Based on the battleMETAL menu and metal-lib library by Peter Roohr 
and adapted for Q2DP by MrC (so if it's broke you know who to blame).
Date: 12/20/2022
Overview: 
  credits menu class file.
*/

//credits Globals
entity credits_back;
entity credits_junk;

//credits callbacks
void() click_credits_back =
{
	menu_clear_items(M_STATE);
	m_main_f();
};

void() m_credits_back =
{
	local float offset_from_bottom = 48;
	
    local string lbl = "BACK";
	local float lblLen = stringwidth(lbl, 0, '32 32 0');
  
	local vector lowerLeft = VIEW_ORG;
	lowerLeft_y = lowerLeft_y + VIEW_MAX_y - offset_from_bottom;
	lowerLeft_x = lowerLeft_x + 24;
  
	//LOWER LEFT
	credits_back = btn_text_callback(lowerLeft, '32 32', "BACK", VIEW_LFT, M_CREDITS, click_credits_back, CLR_MENU_BLUE, '0 1 0', 1, UI_FLAG_SIZE_IMG);
	credits_back.fontId = FONT_NUM_BLACKOPS_BOLD;	
}

void() m_credits_background =
{
	local float ini_alpha = 1;
	
	local vector bimg = gui_newAspectRatio(drawgetimagesize("gfx/menu/background3.tga"), Vector2(VIEW_WIDTH, VIEW_MAX_y));	
	
	if (random() < 0.3)
	{
		credits_junk = lbl_img(ANCHOR_UPPER_LEFT, bimg, "gfx/menu/background.tga", '1 1 1', 0, M_CREDITS, ini_alpha, (UI_FLAG_IMG_SIZE_ASPECT) );
	}
	else if (random() < 0.6)
	{
		credits_junk = lbl_img(ANCHOR_UPPER_LEFT, bimg, "gfx/menu/background3.tga", '1 1 1', 0, M_CREDITS, ini_alpha, (UI_FLAG_IMG_SIZE_ASPECT) );	
	}
	else if (random() < 1)
	{
		credits_junk = lbl_img(ANCHOR_UPPER_LEFT, bimg, "gfx/menu/background2.tga", '1 1 1', 0, M_CREDITS, ini_alpha, (UI_FLAG_IMG_SIZE_ASPECT) );	
	}	
}

// ini function, called by '_f' function as a setup func
void() m_credits_i =
{
	//MENU_ORG = MENU_ORG + '320 -40';
	MENU_ORG = ANCHOR_UPPER_CENTER + '0 20';

	local vector spacer = '0 20';
	
	local float ini_alpha = 1;
	
	credits_junk = lbl_text_centered(MENU_ORG, '20 20', "Quake 2 for DarkPlaces", CLR_MENU_BLUE, VIEW_CTX, M_CREDITS, ini_alpha, 0);
	credits_junk = lbl_text_centered(MENU_ORG += spacer, '10 10', "", CLR_DEF_TXT_HIGHLIGHT, VIEW_CTX, M_CREDITS, ini_alpha, 0);	
	credits_junk = lbl_text_centered(MENU_ORG += spacer, '18 18', "Programming", CLR_MENU_BLUE, VIEW_CTX, M_CREDITS, ini_alpha, 0);	
	credits_junk = lbl_text_centered(MENU_ORG += spacer, '14 14', "Gremlin 'MrC' Forester", CLR_DEF_TXT_HIGHLIGHT, VIEW_CTX, M_CREDITS, ini_alpha, 0);
	credits_junk = lbl_text_centered(MENU_ORG += spacer, '14 14', "Peter 'Subject9x' Roohr", CLR_DEF_TXT_HIGHLIGHT, VIEW_CTX, M_CREDITS, ini_alpha, 0);
	credits_junk = lbl_text_centered(MENU_ORG += spacer, '10 10', "", CLR_DEF_TXT_HIGHLIGHT, VIEW_CTX, M_CREDITS, ini_alpha, 0);
	credits_junk = lbl_text_centered(MENU_ORG += spacer, '14 14', "Based on Quake 1.06 Re-coded by Number Six", CLR_DEF_TXT_HIGHLIGHT, VIEW_CTX, M_CREDITS, ini_alpha, 0);
	credits_junk = lbl_text_centered(MENU_ORG += spacer, '10 10', "", CLR_DEF_TXT_HIGHLIGHT, VIEW_CTX, M_CREDITS, ini_alpha, 0);
	credits_junk = lbl_text_centered(MENU_ORG += spacer, '18 18', "Special Thanks", CLR_MENU_BLUE, VIEW_CTX, M_CREDITS, ini_alpha, 0);
	credits_junk = lbl_text_centered(MENU_ORG += spacer, '14 14', "The DarkPlaces Team", CLR_DEF_TXT_HIGHLIGHT, VIEW_CTX, M_CREDITS, ini_alpha, 0);		
	credits_junk = lbl_text_centered(MENU_ORG += spacer, '14 14', "The Quake Community", CLR_DEF_TXT_HIGHLIGHT, VIEW_CTX, M_CREDITS, ini_alpha, 0);	
	credits_junk = lbl_text_centered(MENU_ORG += spacer, '10 10', "", CLR_DEF_TXT_HIGHLIGHT, VIEW_CTX, M_CREDITS, ini_alpha, 0);	
	credits_junk = lbl_text_centered(MENU_ORG += spacer, '18 18', "Join the DarkPlaces Discord", CLR_MENU_BLUE, VIEW_CTX, M_CREDITS, ini_alpha, 0);
	credits_junk = lbl_text_centered(MENU_ORG += spacer, '14 14', "https://discord.gg/tHQT4DFy", CLR_DEF_TXT_HIGHLIGHT, VIEW_CTX, M_CREDITS, ini_alpha, 0);
	credits_junk = lbl_text_centered(MENU_ORG += spacer, '10 10', "", CLR_DEF_TXT_HIGHLIGHT, VIEW_CTX, M_CREDITS, ini_alpha, 0);	
	credits_junk = lbl_text_centered(MENU_ORG += spacer, '14 14', "Care has been taken to ensure credit for any source code used throughout the project", CLR_DEF_TXT_HIGHLIGHT, VIEW_CTX, M_CREDITS, ini_alpha, 0);	
	credits_junk = lbl_text_centered(MENU_ORG += spacer, '14 14', "has been documented in the comments. If you feel something was in error,", CLR_DEF_TXT_HIGHLIGHT, VIEW_CTX, M_CREDITS, ini_alpha, 0);
	credits_junk = lbl_text_centered(MENU_ORG += spacer, '14 14', "please contact MrC on the DarkPlaces Discord.", CLR_DEF_TXT_HIGHLIGHT, VIEW_CTX, M_CREDITS, ini_alpha, 0);
	credits_junk = lbl_text_centered(MENU_ORG += spacer, '10 10', "", CLR_DEF_TXT_HIGHLIGHT, VIEW_CTX, M_CREDITS, 1, 0);		
	credits_junk = lbl_text_centered(MENU_ORG += spacer, '14 14', "Bugs/issues are welcome, please use the GitHub issues page:", CLR_DEF_TXT_HIGHLIGHT, VIEW_CTX, M_CREDITS, ini_alpha, 0);
	credits_junk = lbl_text_centered(MENU_ORG += spacer, '14 14', "https://github.com/GremlinForester/strogganoff", CLR_DEF_TXT_HIGHLIGHT, VIEW_CTX, M_CREDITS, ini_alpha, 0);

	/*
	credits_junk = lbl_img(ANCHOR_UPPER_LEFT, '1 1 0', "gfx/menu/32grey.png", '1 0 0', 0, M_CREDITS, 1, (UI_FLAG_SIZE_IMG) );
	credits_junk = lbl_text(credits_junk.origin + '32 0', '14 14', "Upper Left", CLR_DEF_TXT_HIGHLIGHT, VIEW_CTX, M_CREDITS, 1, 0);
	credits_junk = lbl_img(ANCHOR_UPPER_CENTER, '1 1 0', "gfx/menu/32grey.png", '0 1 0', 0, M_CREDITS, 1, (UI_FLAG_SIZE_IMG) );
	credits_junk = lbl_text(credits_junk.origin + '32 0', '14 14', "Upper Center", CLR_DEF_TXT_HIGHLIGHT, VIEW_CTX, M_CREDITS, 1, 0);
	credits_junk = lbl_img(ANCHOR_UPPER_RIGHT + '-8 0', '1 1 0', "gfx/menu/32grey.png", '0 0 1', 0, M_CREDITS, 1, (UI_FLAG_SIZE_IMG) );
	credits_junk = lbl_text(credits_junk.origin + '-32 0', '14 14', "Upper Right", CLR_DEF_TXT_HIGHLIGHT, VIEW_CTX, M_CREDITS, 1, 0);	
	
	credits_junk = lbl_img(ANCHOR_CENTER_LEFT, '1 1 0', "gfx/menu/32grey.png", '0 0 1', 0, M_CREDITS, 1, (UI_FLAG_SIZE_IMG) );
	credits_junk = lbl_text(credits_junk.origin + '32 0', '14 14', "CENTER LEFT", CLR_DEF_TXT_HIGHLIGHT, VIEW_CTX, M_CREDITS, 1, 0);
	credits_junk = lbl_img(ANCHOR_CENTER, '1 1 0', "gfx/menu/32grey.png", '0 1 0', 0, M_CREDITS, 1, (UI_FLAG_SIZE_IMG) );
	credits_junk = lbl_text(credits_junk.origin + '32 0', '14 14', "CENTER", CLR_DEF_TXT_HIGHLIGHT, VIEW_CTX, M_CREDITS, 1, 0);
	credits_junk = lbl_img(ANCHOR_CENTER_RIGHT + '-32 0', '1 1 0', "gfx/menu/32grey.png", '1 0 0', 0, M_CREDITS, 1, (UI_FLAG_SIZE_IMG) );
	credits_junk = lbl_text(credits_junk.origin + '-32 0', '14 14', "CENTER RIGHT", CLR_DEF_TXT_HIGHLIGHT, VIEW_CTX, M_CREDITS, 1, 0);	

	credits_junk = lbl_img(ANCHOR_LOWER_LEFT + '0 -32', '1 1 0', "gfx/menu/32grey.png", '1 0 1', 0, M_CREDITS, 1, (UI_FLAG_SIZE_IMG) );
	credits_junk = lbl_text(credits_junk.origin + '32 0', '14 14', "LOWER LEFT", CLR_DEF_TXT_HIGHLIGHT, VIEW_CTX, M_CREDITS, 1, 0);
	credits_junk = lbl_img(ANCHOR_LOWER_CENTER + '0 -32', '1 1 0', "gfx/menu/32grey.png", '0 1 1', 0, M_CREDITS, 1, (UI_FLAG_SIZE_IMG) );
	credits_junk = lbl_text(credits_junk.origin + '32 0', '14 14', "LOWER CENTER", CLR_DEF_TXT_HIGHLIGHT, VIEW_CTX, M_CREDITS, 1, 0);
	credits_junk = lbl_img(ANCHOR_LOWER_RIGHT + '-16 -32', '1 1 0', "gfx/menu/32grey.png", '1 1 0', 0, M_CREDITS, 1, (UI_FLAG_SIZE_IMG) );
	credits_junk = lbl_text(credits_junk.origin + '-32 0', '14 14', "LOWER RIGHT", CLR_DEF_TXT_HIGHLIGHT, VIEW_CTX, M_CREDITS, 1, 0);
	
	credits_junk = lbl_img(ANCHOR_CENTER_25, '1 1 0', "gfx/menu/32grey.png", '1 1 1', 0, M_CREDITS, 1, (UI_FLAG_SIZE_IMG) );
	credits_junk = lbl_text(credits_junk.origin + '-32 0', '14 14', "ANCHOR_CENTER_25", CLR_DEF_TXT_HIGHLIGHT, VIEW_CTX, M_CREDITS, 1, 0);
	credits_junk = lbl_img(ANCHOR_CENTER_75, '1 1 0', "gfx/menu/32grey.png", '1 1 1', 0, M_CREDITS, 1, (UI_FLAG_SIZE_IMG) );
	credits_junk = lbl_text(credits_junk.origin + '-32 0', '14 14', "ANCHOR_CENTER_75", CLR_DEF_TXT_HIGHLIGHT, VIEW_CTX, M_CREDITS, 1, 0);
	
	credits_junk = lbl_img(ANCHOR_CENTER_UL, '1 1 0', "gfx/menu/32grey.png", '1 1 1', 0, M_CREDITS, 1, (UI_FLAG_SIZE_IMG) );
	credits_junk = lbl_text_centered(credits_junk.origin + '0 16', '14 14', "ANCHOR_CENTER_UL", CLR_DEF_TXT_HIGHLIGHT, VIEW_CTX, M_CREDITS, 1, 0);
	credits_junk = lbl_img(ANCHOR_CENTER_LR, '1 1 0', "gfx/menu/32grey.png", '1 1 1', 0, M_CREDITS, 1, (UI_FLAG_SIZE_IMG) );
	credits_junk = lbl_text_centered(credits_junk.origin + '0 16', '14 14', "ANCHOR_CENTER_LR", CLR_DEF_TXT_HIGHLIGHT, VIEW_CTX, M_CREDITS, 1, 0);	
	
	credits_junk = lbl_img(ANCHOR_CENTER_UR, '1 1 0', "gfx/menu/32grey.png", '1 1 1', 0, M_CREDITS, 1, (UI_FLAG_SIZE_IMG) );
	credits_junk = lbl_text_centered(credits_junk.origin + '0 16', '14 14', "ANCHOR_CENTER_UR", CLR_DEF_TXT_HIGHLIGHT, VIEW_CTX, M_CREDITS, 1, 0);
	credits_junk = lbl_img(ANCHOR_CENTER_LL, '1 1 0', "gfx/menu/32grey.png", '1 1 1', 0, M_CREDITS, 1, (UI_FLAG_SIZE_IMG) );
	credits_junk = lbl_text_centered(credits_junk.origin + '0 16', '14 14', "ANCHOR_CENTER_LL", CLR_DEF_TXT_HIGHLIGHT, VIEW_CTX, M_CREDITS, 1, 0);	
	*/
	
	m_credits_back();
	
	m_credits_background();
};


/*
  menu_f functions are like state-transition functions, preparing the menu for the next menu to load
*/
void() m_credits_f =
{
	updateAnchorPos();

	DRAW_MOUSE = TRUE;
	M_STATE = M_CREDITS;
	setkeydest(KEY_MENU);
	m_credits_i();
};

/*
  menu_d functions are the render functions, inside m_draw, there's a select case
  running on M_STATE to determine which menu_d to execute.
*/
void() m_credits_d =
{
	/*
	if( gettime() < ACCEPT_TIMER )
	{
		return;
	}
	
	ACCEPT_TIMER = gettime() + 0.1;
	*/
	
 	local entity widget;  
	widget = findchainfloat(menuId, M_CREDITS);
	while(widget)
	{
		/*
		if (widget.alpha >= 1)
			widget.alpha = 1;
		*/
		
		widget.draw(widget);
		widget = widget.chain;
	}
};

/*
  menu_k functions are the 'listener' functions
*/
void(float key, float ascii) m_credits_k={
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