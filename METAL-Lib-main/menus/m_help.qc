/*
Based on the battleMETAL menu and metal-lib library by Peter Roohr 
and adapted for Q2DP by MrC (so if it's broke you know who to blame).
Date: 1/22/2023
Overview: 
  Readme!
*/

//help Globals
entity help_back;
entity help_junk;
entity help_header;
entity help_page_next;
entity help_page_back;

float HELP_PAGE;
float HELP_PAGE_HEADER;

#define help_page_header1 "What is it?"
#define help_page1 "Welcome to the alpha build of Quake 2 for DarkPlaces, a devkit that adds basic support for Quake 2 on the DarkPlaces engine using QuakeC. For a more complete overview, please see the documentation included in the mod folder. | | It should be noted that not all features found in Quake 2 are supported, such as complete unit support, meaning interconnected levels are very limited."

#define help_page_header2 "Why?"
#define help_page2 "This project was started as a learning excercise in gameplay programming. It's being released as-is for now for anyone who might find it useful."

#define help_page_header3 "Known issues..." 
#define help_page3 "There are a bunch of known issues that will hopefully get sorted out with later releases, like save games, inventory and bots. | | If you do happen upon anything and wish to report it, please log the issue on github. And thanks for checking it out!"

#define help_page_header4 "We have Quake 2 at home..." 
#define help_page4 "This."

#define MAX_PAGES 4

string() help_page_header =
{
	switch(HELP_PAGE)
	{
		case 1:
		return help_page_header1;	
		  break;
		case 2:
		return help_page_header2;	
		  break;
		case 3:
		return help_page_header3;	
		  break;
		case 4:
		return help_page_header4;	
		  break;
	}

}

string() help_page_content =
{
	switch(HELP_PAGE)
	{
		case 1:
		return help_page1;	
		  break;
		case 2:
		return help_page2;	
		  break;
		case 3:
		return help_page3;	
		  break;
		case 4:
		return help_page4;	
		  break;
	}
}

void() click_help_page_back =
{
	HELP_PAGE--;
	HELP_PAGE_HEADER--;
	
	if (HELP_PAGE < 1)
		HELP_PAGE = 1;
	
	if (HELP_PAGE_HEADER < 1)
		HELP_PAGE_HEADER = 1;	
};

void() click_help_page_next =
{
	HELP_PAGE++;
	HELP_PAGE_HEADER++;
	
	if (HELP_PAGE > MAX_PAGES)
		HELP_PAGE = MAX_PAGES;

	if (HELP_PAGE_HEADER > MAX_PAGES)
		HELP_PAGE_HEADER = MAX_PAGES;	
};

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
	HELP_PAGE = 1;
	HELP_PAGE_HEADER = 1;	

	local vector spacer = '0 20';
	
	help_junk = lbl_text_centered(MENU_ORG, '20 20', "Quake 2 for DarkPlaces", CLR_MENU_BLUE, VIEW_CTX, M_HELP, 1, 0);
	help_header = lbl_text(ANCHOR_CENTER_UL + '6.5 -20', '16 16', "", CLR_MENU_BLUE, VIEW_CTX, M_HELP, 1, 0);

	help_page_next = btn_img_callback(ANCHOR_LOWER_CENTER + '55 -60', '32 32', UI_IMG_ARW_RGT, VIEW_CTX, M_HELP, click_help_page_next, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
	help_page_back = btn_img_callback(ANCHOR_LOWER_CENTER + '-50 -60', '32 32', UI_IMG_ARW_LFT, VIEW_CTX, M_HELP, click_help_page_back, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

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
 	local entity widget;

	help_header.label = help_page_header();

	gui_wrapText(ANCHOR_CENTER_UL + '0 0', '400 300', help_page_content(), '14 14', '1 1 1', 1);
	
	gui_renderString(ftos(HELP_PAGE), ANCHOR_LOWER_CENTER + '-25 -50', CLR_DEF_TXT_NONSELECT, '16 16', 1, 0);
	gui_renderString("/", ANCHOR_LOWER_CENTER + '0 -50', CLR_DEF_TXT_NONSELECT, '16 16', 1, 0);
	gui_renderString(ftos(MAX_PAGES), ANCHOR_LOWER_CENTER + '25 -50', CLR_DEF_TXT_NONSELECT, '16 16', 1, 0);	
	
	widget = findchainfloat(menuId, M_HELP);
	while(widget)
	{
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