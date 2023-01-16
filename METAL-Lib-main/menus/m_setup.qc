/*
Based on the battleMETAL menu and metal-lib library by Peter Roohr 
and adapted for Q2DP by MrC (so if it's broke you know who to blame).
Date: 12/20/2022
Overview:
    Player Setup for multiplayer
*/

//Main Menu Globals

// From menusys
static string() skinopts =
{
	local float s;
	
	string opts = "";
	if (cvar("cl_playertype") == 0){
		float s = search_begin("players/male/*.pcx", TRUE, TRUE);
	}
	else if (cvar("cl_playertype") == 1)
	{
		float s = search_begin("players/female/*.pcx", TRUE, TRUE);	
	}
	else if (cvar("cl_playertype") == 2)
	{
		float s = search_begin("players/cyborg/*.pcx", TRUE, TRUE);	
	}
	
	if (s < 0)
		return opts;
	float n = search_getsize(s);
	for (float i = 0; i < n; i++)
	{
		string f = substring(search_getfilename(s, i), 6, -5);
		opts = strcat(opts, "\"", f, "\" \"", f, "\" ");
	}
	return opts;
};


//to remember what was selected
float playertype_num;

entity setup_title;
entity setup_label_playername;
entity setup_txtfld_playername;

entity setup_icon_label;
entity setup_icon_value;
entity setup_icon;
entity setup_icon_prev;
entity setup_icon_next;

entity setup_background_icon;

entity setup_playertype;

entity setup_accept;
entity setup_back;

//Main Menu Constants
#define IMG_SETUP_TITLE "gfx/menu/setup/setup_title.png"

string() setup_set_hero =
{
	if (playertype_num == 2) //cyborg
	{
		switch(setup_icon_value.len)
		{
			case 0:
				return PLAYER_HERO_CYBORG1;
			case 1:
				return PLAYER_HERO_CYBORG2;
			case 2:
				return PLAYER_HERO_CYBORG3;
			default:
				return PLAYER_HERO_CYBORG1;				
		}
	}
	
	if (playertype_num == 1) //female
	{
		switch(setup_icon_value.len)
		{
			case 0:
				return PLAYER_HERO_FEMALE1;
			case 1:
				return PLAYER_HERO_FEMALE2;
			case 2:
				return PLAYER_HERO_FEMALE3;
			case 3:
				return PLAYER_HERO_FEMALE4;
			case 4:
				return PLAYER_HERO_FEMALE5;
			case 5:
				return PLAYER_HERO_FEMALE6;
			case 6:
				return PLAYER_HERO_FEMALE7;
			case 7:
				return PLAYER_HERO_FEMALE8;
			case 8:
				return PLAYER_HERO_FEMALE9;				
			case 9:
				return PLAYER_HERO_FEMALE10;
			default:
				return PLAYER_HERO_FEMALE1;				
		}
	}
	
	if (playertype_num == 0) //male
	{
		switch(setup_icon_value.len)
		{
			case 0:
				return PLAYER_HERO_MALE1;
			case 1:
				return PLAYER_HERO_MALE2;
			case 2:
				return PLAYER_HERO_MALE3;
			case 3:
				return PLAYER_HERO_MALE4;
			case 4:
				return PLAYER_HERO_MALE5;
			case 5:
				return PLAYER_HERO_MALE6;
			case 6:
				return PLAYER_HERO_MALE7;
			case 7:
				return PLAYER_HERO_MALE8;
			case 8:
				return PLAYER_HERO_MALE9;
			case 9:
				return PLAYER_HERO_MALE10;
			case 10:
				return PLAYER_HERO_MALE11;
			case 11:
				return PLAYER_HERO_MALE12;
			case 12:
				return PLAYER_HERO_MALE13;
			case 13:
				return PLAYER_HERO_MALE14;				
			case 14:
				return PLAYER_HERO_MALE15;
			default:
				return PLAYER_HERO_MALE1;				
		}	
	}
};

/*
============
Cycle Player Skins 
============
*/

string() setup_set_icon =
{
	if (playertype_num == 2) //cyborg
	{
		switch(setup_icon_value.len)
		{
			case 0:
				return PLAYER_ICON_CYBORG1;
			case 1:
				return PLAYER_ICON_CYBORG2;
			case 2:
				return PLAYER_ICON_CYBORG3;
			default:
				return PLAYER_ICON_CYBORG1;				
		}
	}
	
	if (playertype_num == 1) //female
	{
		switch(setup_icon_value.len)
		{
			case 0:
				return PLAYER_ICON_FEMALE1;
			case 1:
				return PLAYER_ICON_FEMALE2;
			case 2:
				return PLAYER_ICON_FEMALE3;
			case 3:
				return PLAYER_ICON_FEMALE4;
			case 4:
				return PLAYER_ICON_FEMALE5;
			case 5:
				return PLAYER_ICON_FEMALE6;
			case 6:
				return PLAYER_ICON_FEMALE7;
			case 7:
				return PLAYER_ICON_FEMALE8;
			case 8:
				return PLAYER_ICON_FEMALE9;				
			case 9:
				return PLAYER_ICON_FEMALE10;
			default:
				return PLAYER_ICON_FEMALE1;				
		}
	}
	
	if (playertype_num == 0) //male
	{
		switch(setup_icon_value.len)
		{
			case 0:
				return PLAYER_ICON_MALE1;
			case 1:
				return PLAYER_ICON_MALE2;
			case 2:
				return PLAYER_ICON_MALE3;
			case 3:
				return PLAYER_ICON_MALE4;
			case 4:
				return PLAYER_ICON_MALE5;
			case 5:
				return PLAYER_ICON_MALE6;
			case 6:
				return PLAYER_ICON_MALE7;
			case 7:
				return PLAYER_ICON_MALE8;
			case 8:
				return PLAYER_ICON_MALE9;
			case 9:
				return PLAYER_ICON_MALE10;
			case 10:
				return PLAYER_ICON_MALE11;
			case 11:
				return PLAYER_ICON_MALE12;
			case 12:
				return PLAYER_ICON_MALE13;
			case 13:
				return PLAYER_ICON_MALE14;				
			case 14:
				return PLAYER_ICON_MALE15;
			default:
				return PLAYER_ICON_MALE1;				
		}	
	}
};

//button callbacks
//because we define these right before the menu functions are defined, we 
//don't have to put them in a header, and they can be 'somewhat' flexibily generated
/*void() click_newg_back={
  menu_clear_items(M_STATE);
  M_STATE = M_SINGLE;
  localsound("sound/misc/menu2.wav");
};*/
void() click_setup_accept =
{
	cvar_set("cl_playertype", ftos(playertype_num));
	local string s = sprintf("cl_playertype set to %s \n", ftos(cvar("cl_playertype")));
	print(s);
	
	cvar_set("skin", ftos(setup_icon_value.len));
	s = sprintf("skin set to %s \n", ftos(cvar("skin")));
	print(s);
	
	localcmd("saveconfig\n");
	menu_clear_items(M_STATE);

	if( MAIN_MISSION ) 
	{
		m_main_f();
	}
	else
	{
		m_multi_f();
	}
};

void() click_setup_back =
{
	menu_clear_items(M_STATE);

	if( MAIN_MISSION ) 
	{
		m_main_f();
	}
	else
	{
		m_multi_f();
	}
};

string() playerTypeLabel =
{
	switch(playertype_num)
	{
		case 0:
			return "Male";
		case 1:
			return "Female";
		case 2:
			return "Cyborg";
	}
}

void() setup_icon_next_f;

void() click_playertype =
{
	playertype_num++;

	if (playertype_num > 2)
		playertype_num = 0;
	
	if (playertype_num == 1)
	{
		setup_playertype.label = "Female";
	}
	else if (playertype_num == 2)
	{
		setup_playertype.label = "Cyborg";
	}
	else
	{
		setup_playertype.label = "Male";
	}
	setup_icon_next_f();
};

void() textfield_setup_name = 
{
	if( strlen(self.data_text) > 0 )
	{
		cvar_set("_cl_name", self.data_text);
	}
	else
	{
		cvar_set("_cl_name", "BITTERMAN");
		cacheGlobalString(  self.data_text, str_cvar("_cl_name"))
	}
};

void(float nextIcon) setup_icon_set = 
{
	setup_icon_value.len = nextIcon;
	
	setup_icon.image1 = setup_set_icon( setup_icon_value.len );
	
	setup_background_icon.image1 = setup_set_hero( setup_icon_value.len );
};

void() setup_icon_prev_f =
{
	local float nextIcon;
	nextIcon = setup_icon_value.len - 1;
  
	if (playertype_num == 1) //Female
	{
		if( nextIcon < 0 )
		{
			nextIcon = 9;
		}
	}
	else if (playertype_num == 2) //Cyborg
	{
		if( nextIcon < 0 )
		{
			nextIcon = 2;
		}
	}
	else //Male
	{
		if( nextIcon < 0 )
		{
			nextIcon = 14;
		}
	}

	//cvar_set("skin", ftos(nextIcon));

	setup_icon_set(nextIcon);
};

void() setup_icon_next_f =
{
	local float nextIcon;
	nextIcon = setup_icon_value.len + 1;
  
	if (playertype_num == 1) //Female
	{
		if( nextIcon > 9 )
		{
			nextIcon = 0;
		}
	}
	else if (playertype_num == 2) //Cyborg
	{
		if( nextIcon > 2 )
		{
			nextIcon = 0;
		}
	}
	else //Male
	{
		if( nextIcon > 14 )
		{
			nextIcon = 0;
		}
	//	print(ftos(nextIcon));
	}
	
	//cvar_set("skin", ftos(nextIcon));
	
	setup_icon_set(nextIcon);
};

void() m_setup_back_and_accept =
{
	local float offset_from_bottom = 48;

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
	setup_back = btn_text_callback(lowerLeft, '32 32', "BACK", VIEW_LFT, M_SETUP, click_setup_back, CLR_MENU_BLUE, '0 1 0', 1, UI_FLAG_SIZE_IMG);
	setup_back.fontId = FONT_NUM_BLACKOPS_BOLD;
   
    lbl = "ACCEPT";
	lblLen = stringwidth(lbl, 0, '32 32 0');
   
	//LOWER RIGHT
	setup_accept = btn_text_callback(lowerRight, '32 32', "ACCEPT", VIEW_CTX, M_SETUP, click_setup_accept, CLR_MENU_BLUE, '0 1 0', 1, UI_FLAG_SIZE_IMG);
	setup_accept.fontId = FONT_NUM_BLACKOPS_BOLD;
}

// ini functions
void() m_setup_i =
{
	menu_parent_setup(VIEW_ORG + '160 60', '432 400');

	setup_title = lbl_text(VIEW_ORG + '400 20', '44 44', "PLAYER SETUP", CLR_DEF_TXT_GRAY_SMOOTH, 0, M_SETUP, 1, 0);
	setup_title.fontId = FONT_NUM_BLACKOPS_BOLD;
	setup_title = lbl_img((VIEW_ORG + '400 20'), '1 1 0', IMG_SUBMENUHEADER_BG, '1 1 1', VIEW_CTX, M_SETUP, 1, UI_FLAG_SIZE_IMG );
  
	setup_label_playername = lbl_text(MENU_ORG + '10 45', '12 12', "Player Name : ", CLR_DEF_TXT_NONSELECT, 0, M_SETUP, 1, 0);
  
	setup_txtfld_playername = inp_textfield(setup_label_playername.origin + Vector2(stringwidth("Player Name :   ", 0, '12 12'), 0), '14 14', 24, textfield_setup_name, 0, M_SETUP, CLR_DEF_WHITE, CLR_DEF_BLUE, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_UPP));
	cacheGlobalString( setup_txtfld_playername.data_text, str_cvar("_cl_name") )

	setup_icon_label = lbl_text(MENU_ORG + '10 85', '12 12', "Type: ", CLR_DEF_TXT_NONSELECT, 0, M_SETUP, 1, 0);

	setup_playertype = btn_text_callback(setup_icon_label.origin + Vector2(stringwidth("Skin", 0, '12 12') + 64, -8), '24 24', playerTypeLabel(), VIEW_CTX, M_SETUP, click_playertype, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, UI_FLAG_SIZE_IMG);
	setup_playertype.fontId = FONT_NUM_BLACKOPS_BOLD;
	

	setup_icon_label = lbl_text(MENU_ORG + '10 115', '12 12', "Skin/Icon: ", CLR_MENU_BLUE, 0, M_SETUP, 1, 0);
	setup_icon_value = lbl_text(setup_icon_label.origin + Vector2(stringwidth("Skin", 0, '12 12') + 128, 0), '12 12', "", CLR_DEF_TXT_NONSELECT, 0, M_SETUP, 1, 0);
	setup_icon_value.len = cvar("skin");
  
	setup_icon = lbl_img(setup_icon_value.origin, '96 96', setup_set_icon(setup_icon_value.len), '1 1 1', 0, M_SETUP, 1, UI_FLAG_IMG_SIZE_ASPECT | UI_FLAG_CENTER_IMG);
	//setup_background_icon = lbl_img(ANCHOR_UPPER_LEFT, Vector2(VIEW_MAX_y, VIEW_MAX_y), setup_icon.image1, '1 1 1', 0, M_SETUP, 0.5, 0);
	setup_background_icon = lbl_img(ANCHOR_CENTER_75 - '256 0', '256 256', setup_background_icon.image1, '1 1 1', 0, M_SETUP, 1, 0);

	setup_background_icon.image1 = setup_set_hero( setup_icon_value.len );
  
	setup_icon_prev = btn_img_callback(setup_icon_value.origin - '64 0', '14 14', UI_IMG_ARW_LFT, 0, M_SETUP, setup_icon_prev_f, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
	setup_icon_next = btn_img_callback(setup_icon_value.origin + '64 0', '14 14', UI_IMG_ARW_RGT, 0, M_SETUP, setup_icon_next_f, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

	m_setup_back_and_accept();

//	setup_accept = btn_text_callback(MENU_ORG + '45 395', '16 16', "SAVE", VIEW_CTX, M_SETUP, click_setup_accept, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, UI_FLAG_SIZE_IMG);
//	setup_accept.fontId = FONT_NUM_BLACKOPS_BOLD;
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
  
  gui_renderPatch9_1_32(MENU_ORG, MENU_SIZE + '104 0', '0.35 0.35 0.35', 0.35, 0);
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
  
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
void(float key, float ascii) m_setup_k =
{
	switch(key)
	{	
		case K_ESCAPE:
		localsound("sound/misc/menu2.wav");
		menu_clear_items(M_STATE);
		localcmd("saveconfig\n");
		
		if( MAIN_MISSION ) 
		{
			m_main_f();
		}
		else
		{
			m_multi_f();
		}
		break;
	}
};