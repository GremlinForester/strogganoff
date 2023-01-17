/*
Based on the battleMETAL menu and metal-lib library by Peter Roohr 
and adapted for Q2DP by MrC (so if it's broke you know who to blame).
Date: 1/16/2022
Overview: 
  help menu class file.
*/

//help Globals
entity help_back;
entity help_junk;

//help callbacks
void() click_help_back =
{
	menu_clear_items(M_STATE);
	m_main_f();
};

void() m_help_back =
{
	local float offset_from_bottom = 48;
	
    local string lbl = "BACK";
	local float lblLen = stringwidth(lbl, 0, '32 32 0');
  
	local vector lowerLeft = VIEW_ORG;
	lowerLeft_y = lowerLeft_y + VIEW_MAX_y - offset_from_bottom;
	lowerLeft_x = lowerLeft_x + 24;
  
	//LOWER LEFT
	help_back = btn_text_callback(lowerLeft, '32 32', "BACK", VIEW_LFT, M_HELP, click_help_back, CLR_MENU_BLUE, '0 1 0', 1, UI_FLAG_SIZE_IMG);
	help_back.fontId = FONT_NUM_BLACKOPS_BOLD;	
}

// ini function, called by '_f' function as a setup func
void() m_help_i =
{
	//MENU_ORG = MENU_ORG + '320 -40';
	MENU_ORG = ANCHOR_UPPER_CENTER + '0 20';

	local vector spacer = '0 20';
	
	local float ini_alpha = 1;
	
	help_junk = lbl_text_centered(MENU_ORG, '20 20', "Quake 2 for DarkPlaces", CLR_MENU_BLUE, VIEW_CTX, M_HELP, ini_alpha, 0);
	help_junk = lbl_text_centered(MENU_ORG += spacer, '10 10', "", CLR_DEF_TXT_HIGHLIGHT, VIEW_CTX, M_HELP, ini_alpha, 0);	
	help_junk = lbl_text_centered(MENU_ORG += spacer, '18 18', "", CLR_MENU_BLUE, VIEW_CTX, M_HELP, ini_alpha, 0);	
	help_junk = lbl_text_centered(MENU_ORG += spacer, '14 14', "", CLR_DEF_TXT_HIGHLIGHT, VIEW_CTX, M_HELP, ini_alpha, 0);
	help_junk = lbl_text_centered(MENU_ORG += spacer, '14 14', "", CLR_DEF_TXT_HIGHLIGHT, VIEW_CTX, M_HELP, ini_alpha, 0);
	help_junk = lbl_text_centered(MENU_ORG += spacer, '10 10', "", CLR_DEF_TXT_HIGHLIGHT, VIEW_CTX, M_HELP, ini_alpha, 0);
	help_junk = lbl_text_centered(MENU_ORG += spacer, '14 14', "", CLR_DEF_TXT_HIGHLIGHT, VIEW_CTX, M_HELP, ini_alpha, 0);
	help_junk = lbl_text_centered(MENU_ORG += spacer, '10 10', "", CLR_DEF_TXT_HIGHLIGHT, VIEW_CTX, M_HELP, ini_alpha, 0);
	help_junk = lbl_text_centered(MENU_ORG += spacer, '18 18', "TBD", CLR_MENU_BLUE, VIEW_CTX, M_HELP, ini_alpha, 0);
	help_junk = lbl_text_centered(MENU_ORG += spacer, '14 14', "", CLR_DEF_TXT_HIGHLIGHT, VIEW_CTX, M_HELP, ini_alpha, 0);		
	help_junk = lbl_text_centered(MENU_ORG += spacer, '14 14', "", CLR_DEF_TXT_HIGHLIGHT, VIEW_CTX, M_HELP, ini_alpha, 0);	
	help_junk = lbl_text_centered(MENU_ORG += spacer, '10 10', "", CLR_DEF_TXT_HIGHLIGHT, VIEW_CTX, M_HELP, ini_alpha, 0);	
	help_junk = lbl_text_centered(MENU_ORG += spacer, '18 18', "", CLR_MENU_BLUE, VIEW_CTX, M_HELP, ini_alpha, 0);
	help_junk = lbl_text_centered(MENU_ORG += spacer, '14 14', "", CLR_DEF_TXT_HIGHLIGHT, VIEW_CTX, M_HELP, ini_alpha, 0);
	help_junk = lbl_text_centered(MENU_ORG += spacer, '10 10', "", CLR_DEF_TXT_HIGHLIGHT, VIEW_CTX, M_HELP, ini_alpha, 0);	
	help_junk = lbl_text_centered(MENU_ORG += spacer, '14 14', "", CLR_DEF_TXT_HIGHLIGHT, VIEW_CTX, M_HELP, ini_alpha, 0);	
	help_junk = lbl_text_centered(MENU_ORG += spacer, '14 14', "", CLR_DEF_TXT_HIGHLIGHT, VIEW_CTX, M_HELP, ini_alpha, 0);
	help_junk = lbl_text_centered(MENU_ORG += spacer, '14 14', "", CLR_DEF_TXT_HIGHLIGHT, VIEW_CTX, M_HELP, ini_alpha, 0);
	help_junk = lbl_text_centered(MENU_ORG += spacer, '10 10', "", CLR_DEF_TXT_HIGHLIGHT, VIEW_CTX, M_HELP, 1, 0);		
	help_junk = lbl_text_centered(MENU_ORG += spacer, '14 14', "", CLR_DEF_TXT_HIGHLIGHT, VIEW_CTX, M_HELP, ini_alpha, 0);
	help_junk = lbl_text_centered(MENU_ORG += spacer, '14 14', "", CLR_DEF_TXT_HIGHLIGHT, VIEW_CTX, M_HELP, ini_alpha, 0);

	m_help_back();
};


/*
  menu_f functions are like state-transition functions, preparing the menu for the next menu to load
*/
void() m_help_f =
{
	updateAnchorPos();

	DRAW_MOUSE = TRUE;
	M_STATE = M_HELP;
	setkeydest(KEY_MENU);
	m_help_i();
};

/*
  menu_d functions are the render functions, inside m_draw, there's a select case
  running on M_STATE to determine which menu_d to execute.
*/
void() m_help_d =
{
	/*
	if( gettime() < ACCEPT_TIMER )
	{
		return;
	}
	
	ACCEPT_TIMER = gettime() + 0.1;
	*/
	
 	local entity widget;  
	widget = findchainfloat(menuId, M_HELP);
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
void(float key, float ascii) m_help_k={
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