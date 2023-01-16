/*
Based on the battleMETAL menu and metal-lib library by Peter Roohr 
and adapted for Q2DP by MrC (so if it's broke you know who to blame).
Date: 12/20/2022
Overview: options-controls
*/

//controls Globals

entity controls_title;

//movement
entity controls_mouse_sense;
entity controls_mouse_sense_more;
entity controls_mouse_sense_less;
entity controls_mouse_invert;
//entity controls_mouse_invert_on;
//entity controls_mouse_invert_off;
entity controls_forward;
entity controls_backward;
entity controls_strafe_left;
entity controls_strafe_right;
entity controls_sprint;
entity controls_jump;
entity controls_crouch;

//combat
entity controls_fire;
entity controls_altfire;
entity controls_prevweapon;  
entity controls_nextweapon;
entity controls_dropweapon;

//inventory
entity controls_weapon1;
entity controls_weapon2;
entity controls_weapon3;
entity controls_weapon4;
entity controls_weapon5;
entity controls_weapon6;
entity controls_weapon7;
entity controls_weapon8;
entity controls_weapon9;
entity controls_weapon10;
entity controls_useitem;
entity controls_previtem;
entity controls_nextitem;

//special
entity controls_flipoff;
entity controls_salute;
entity controls_taunt;
entity controls_wave;
entity controls_point;
entity controls_chat_team;
entity controls_chat_all;
entity controls_scores;

//controls constants
string IMG_CONTROLS_TITLE = "gfx/menu/options/options_title.png";

//controls callbacks
entity controls_mouse_sense;
entity controls_mouse_sense_more;
entity controls_mouse_sense_less;

entity controls_mouse_invert;

entity controls_back;
entity controls_accept;

void() click_control_mouse_sense_more={
  local float val;
  val = controls_mouse_sense.len;
  val = val + 1;
  if(val >= 35){
    val = 35;
    controls_mouse_sense_more.drawme = FALSE;
  }
  controls_mouse_sense_less.drawme = TRUE;
  controls_mouse_sense.len = val;
  cvar_set("sensitivity", ftos(controls_mouse_sense.len));
};
void() click_control_mouse_sense_less={
  local float val;
  val = controls_mouse_sense.len;
  val = val - 1;
  if(val <= 1){
    val = 1;
    controls_mouse_sense_less.drawme = FALSE;
  }
  controls_mouse_sense_more.drawme = TRUE;
  controls_mouse_sense.len = val;
  cvar_set("sensitivity", ftos(controls_mouse_sense.len));
};
/*
void() click_control_mouse_invert_on={
  cvar_set("m_pitch", "-0.022");
  controls_mouse_invert_on.drawme = FALSE;
  controls_mouse_invert_off.drawme = TRUE;

};
void() click_control_mouse_invert_off={
  cvar_set("m_pitch", "0.022");
  controls_mouse_invert_on.drawme = TRUE;
  controls_mouse_invert_off.drawme = FALSE;
};
*/

void() new_control_mouse_invert_check_callback =
{
	if( controls_mouse_invert.len == TRUE )
	{
  cvar_set("m_pitch", "-0.022");
	}
	else
	{
  cvar_set("m_pitch", "0.022");
	}
};

void() txt_control_bind_forward={
  menu_keybind_change ("+forward");
};
void() txt_control_bind_backward={
  menu_keybind_change ("+back");
};
void() txt_control_bind_strafeleft={
  menu_keybind_change ("+moveleft");
};
void() txt_control_bind_straferight={
  menu_keybind_change ("+moveright");
};
void() txt_control_bind_sprint={
  menu_keybind_change ("+button8");
};
void() txt_control_bind_jump={
  menu_keybind_change("+jump");
};
void() txt_control_bind_crouch={
  menu_keybind_change("+button4");
};

void() txt_control_bind_fire={
  menu_keybind_change ("+attack");
};
void() txt_control_bind_altfire={
  menu_keybind_change ("+button3");
};
void() txt_control_bind_prevweapon={
  menu_keybind_change ("impulse 31");
};
void() txt_control_bind_nextweapon={
  menu_keybind_change ("impulse 30");
};
void() txt_control_bind_dropweapon={
  menu_keybind_change ("impulse 13");
};

//INVENTORY CONTROL BINDS
void() txt_control_bind_weapon1={
  menu_keybind_change ("impulse 1");
};
void() txt_control_bind_weapon2={
  menu_keybind_change ("impulse 2");
};
void() txt_control_bind_weapon3={
  menu_keybind_change ("impulse 3");
};
void() txt_control_bind_weapon4={
  menu_keybind_change ("impulse 4");
};
void() txt_control_bind_weapon5={
  menu_keybind_change ("impulse 5");
};
void() txt_control_bind_weapon6={
  menu_keybind_change ("impulse 6");
};
void() txt_control_bind_weapon7={
  menu_keybind_change ("impulse 7");
};
void() txt_control_bind_weapon8={
  menu_keybind_change ("impulse 8");
};
void() txt_control_bind_weapon9={
  menu_keybind_change ("impulse 9");
};
void() txt_control_bind_weapon10={
  menu_keybind_change ("impulse 10");
};
void() txt_control_bind_useitem={
  menu_keybind_change ("impulse 34");
};
void() txt_control_bind_previtem={
  menu_keybind_change ("impulse 33");
};
void() txt_control_bind_nextitem={
  menu_keybind_change ("impulse 32");
};

//SPECIAL
void() txt_control_bind_flipoff={
  menu_keybind_change ("impulse 110");
};
void() txt_control_bind_salute={
  menu_keybind_change ("impulse 111");
};
void() txt_control_bind_taunt={
  menu_keybind_change ("impulse 112");
};
void() txt_control_bind_wave={
  menu_keybind_change ("impulse 113");
};
void() txt_control_bind_point={
  menu_keybind_change ("impulse 114");
};
void() txt_control_bind_chat_team={
  menu_keybind_change ("messagemode2");
};
void() txt_control_bind_chat_all={
  menu_keybind_change ("messagemode");
};
void() txt_control_bind_scores={
  menu_keybind_change ("+showscores");
};


void() click_controls_back={
  menu_clear_items(M_STATE);
  m_options_f();
};

void() click_controls_accept={
  localcmd("saveconfig\n");
  click_controls_back();
};

vector controls_font_size = '18 18';

void(vector rootOfs) controls_ini_movement=
{

  controls_mouse_sense = lbl_text(rootOfs + '110 200', '14 14', " ", CLR_DEF_WHITE, VIEW_CTX, M_OPTIONS_CONTROLS, 1, UI_FLAG_LBL_USELEN);
  controls_mouse_sense.len = cvar("sensitivity");
  
  controls_mouse_sense_more = btn_img_callback(controls_mouse_sense.origin + '16 0', '12 12', UI_IMG_ARW_RGT, 0, M_OPTIONS_CONTROLS, click_control_mouse_sense_more, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  controls_mouse_sense_less = btn_img_callback(controls_mouse_sense.origin - Vector2(24,0), '12 12', UI_IMG_ARW_LFT, 0, M_OPTIONS_CONTROLS, click_control_mouse_sense_less, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

  if(controls_mouse_sense.len == 1){
    controls_mouse_sense_less.drawme = FALSE;
  }
  else if(controls_mouse_sense.len == 35){
    controls_mouse_sense_more.drawme = FALSE;
  }
  
  /*
  controls_mouse_invert = lbl_text(rootOfs + '110 220', '14 14', "", CLR_DEF_WHITE, VIEW_CTX, M_OPTIONS_CONTROLS, 1, UI_FLAG_LBL_BOOL_ON);
  controls_mouse_invert.len = cvar("m_pitch");
  controls_mouse_invert_on = btn_img_callback(controls_mouse_invert.origin + '20 0', '12 12', UI_IMG_ARW_RGT, 0, M_OPTIONS_CONTROLS, click_control_mouse_invert_on, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  controls_mouse_invert_off = btn_img_callback(controls_mouse_invert.origin - Vector2(24,0), '12 12', UI_IMG_ARW_LFT, 0, M_OPTIONS_CONTROLS, click_control_mouse_invert_off, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  
  if(controls_mouse_invert.len < 0){
    controls_mouse_invert_on.drawme = FALSE;
  }
  else{
    controls_mouse_invert_off.drawme = FALSE;
  }
	*/

  controls_mouse_invert = btn_check_callback(rootOfs + '110 220', '14 14', 0, M_OPTIONS_CONTROLS, new_control_mouse_invert_check_callback, CLR_DEF_TXT_GRAY_SMOOTH, '1 1 1', 1, 0);
  controls_mouse_invert.label = "Invert Mouse  ";
	
  if( cvar("m_pitch") < 0){
    controls_mouse_invert.len = TRUE;
  }
  else{
    controls_mouse_invert.len = FALSE;
  }
  
  controls_forward = inp_keybindfield(rootOfs + '86 38', controls_font_size, txt_control_bind_forward, "Forward      ", "+forward", M_OPTIONS_CONTROLS, CLR_DEF_BLACK, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));

  controls_backward = inp_keybindfield(rootOfs + '86 60', controls_font_size, txt_control_bind_backward, "Backward      ", "+back", M_OPTIONS_CONTROLS, CLR_DEF_BLACK, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));

  controls_strafe_left = inp_keybindfield(rootOfs + '86 82', controls_font_size, txt_control_bind_strafeleft, "Strafe Left      ", "+moveleft", M_OPTIONS_CONTROLS, CLR_DEF_BLACK, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));

  controls_strafe_right = inp_keybindfield(rootOfs + '86 104', controls_font_size, txt_control_bind_straferight, "Strafe Right      ", "+moveright", M_OPTIONS_CONTROLS, CLR_DEF_BLACK, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));
  
  controls_sprint = inp_keybindfield(rootOfs + '86 126', controls_font_size, txt_control_bind_sprint, "Sprint      ", "+button8", M_OPTIONS_CONTROLS, CLR_DEF_BLACK, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));

  controls_jump = inp_keybindfield(rootOfs + '86 148', controls_font_size, txt_control_bind_jump, "Jump      ", "+jump", M_OPTIONS_CONTROLS, CLR_DEF_BLACK, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));
  
  controls_crouch = inp_keybindfield(rootOfs + '86 170', controls_font_size, txt_control_bind_crouch, "Crouch      ", "+button4", M_OPTIONS_CONTROLS, CLR_DEF_BLACK, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));
  
};



void(vector rootOfs) controls_ini_combat=
{
	controls_fire = inp_keybindfield(rootOfs + '56 16', controls_font_size, txt_control_bind_fire, "Fire      ", "+attack", M_OPTIONS_CONTROLS, CLR_DEF_BLACK, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));
   
	controls_altfire = inp_keybindfield(rootOfs + '56 38', controls_font_size, txt_control_bind_altfire, "Alt. Fire      ", "+button3", M_OPTIONS_CONTROLS, CLR_DEF_BLACK, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));
  
	controls_prevweapon = inp_keybindfield(rootOfs + '56 60', controls_font_size, txt_control_bind_prevweapon, "Prev. Weapon      ", "impulse 30", M_OPTIONS_CONTROLS, CLR_DEF_BLACK, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));
  
	controls_nextweapon = inp_keybindfield(rootOfs + '56 82', controls_font_size, txt_control_bind_nextweapon, "Next Weapon      ", "impulse 31", M_OPTIONS_CONTROLS, CLR_DEF_BLACK, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));

	controls_dropweapon = inp_keybindfield(rootOfs + '56 104', controls_font_size, txt_control_bind_dropweapon, "Drop Weapon      ", "impulse 13", M_OPTIONS_CONTROLS, CLR_DEF_BLACK, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));
};


void(vector rootOfs) controls_ini_inventory=
{
	controls_weapon1 = inp_keybindfield(rootOfs + '56 16', controls_font_size, txt_control_bind_weapon1, "Blaster      ", "impulse 1", M_OPTIONS_CONTROLS, CLR_DEF_BLACK, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));

	controls_weapon2 = inp_keybindfield(rootOfs + '56 38', controls_font_size, txt_control_bind_weapon2, "Shotgun      ", "impulse 2", M_OPTIONS_CONTROLS, CLR_DEF_BLACK, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));
  
	controls_weapon3 = inp_keybindfield(rootOfs + '56 60', controls_font_size, txt_control_bind_weapon3, "Super Shotgun      ", "impulse 3", M_OPTIONS_CONTROLS, CLR_DEF_BLACK, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));

	controls_weapon4 = inp_keybindfield(rootOfs + '56 82', controls_font_size, txt_control_bind_weapon4, "Machinegun      ", "impulse 4", M_OPTIONS_CONTROLS, CLR_DEF_BLACK, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));

	controls_weapon5 = inp_keybindfield(rootOfs + '56 104', controls_font_size, txt_control_bind_weapon5, "Chaingun      ", "impulse 5", M_OPTIONS_CONTROLS, CLR_DEF_BLACK, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));

	controls_weapon6 = inp_keybindfield(rootOfs + '56 126', controls_font_size, txt_control_bind_weapon6, "Grenade Launcher      ", "impulse 6", M_OPTIONS_CONTROLS, CLR_DEF_BLACK, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));
  
	controls_weapon7 = inp_keybindfield(rootOfs + '56 148', controls_font_size, txt_control_bind_weapon7, "Rocket Launcher      ", "impulse 7", M_OPTIONS_CONTROLS, CLR_DEF_BLACK, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));

	controls_weapon8 = inp_keybindfield(rootOfs + '56 170', controls_font_size, txt_control_bind_weapon8, "Hyperblaster      ", "impulse 8", M_OPTIONS_CONTROLS, CLR_DEF_BLACK, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));
  
	controls_weapon9 = inp_keybindfield(rootOfs + '56 192', controls_font_size, txt_control_bind_weapon9, "Railgun      ", "impulse 9", M_OPTIONS_CONTROLS, CLR_DEF_BLACK, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));
  
	controls_weapon10 = inp_keybindfield(rootOfs + '56 214', controls_font_size, txt_control_bind_weapon10, "BFG      ", "impulse 10", M_OPTIONS_CONTROLS, CLR_DEF_BLACK, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));
  
	controls_useitem = inp_keybindfield(rootOfs + '56 236', controls_font_size, txt_control_bind_useitem, "Use Item      ", "impulse 34", M_OPTIONS_CONTROLS, CLR_DEF_BLACK, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));

	controls_previtem = inp_keybindfield(rootOfs + '56 258', controls_font_size, txt_control_bind_previtem, "Prev. Item      ", "impulse 33", M_OPTIONS_CONTROLS, CLR_DEF_BLACK, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));

	controls_nextitem = inp_keybindfield(rootOfs + '56 280', controls_font_size, txt_control_bind_nextitem, "Next Item      ", "impulse 32", M_OPTIONS_CONTROLS, CLR_DEF_BLACK, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));  
};

void(vector rootOfs) controls_ini_special=
{
	controls_flipoff = inp_keybindfield(rootOfs + '56 16', controls_font_size, txt_control_bind_flipoff, "Flipoff      ", "impulse 110", M_OPTIONS_CONTROLS, CLR_DEF_BLACK, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));

	controls_salute = inp_keybindfield(rootOfs + '56 38', controls_font_size, txt_control_bind_salute, "Salute      ", "impulse 111", M_OPTIONS_CONTROLS, CLR_DEF_BLACK, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));
  
	controls_taunt = inp_keybindfield(rootOfs + '56 60', controls_font_size, txt_control_bind_taunt, "Taunt      ", "impulse 112", M_OPTIONS_CONTROLS, CLR_DEF_BLACK, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));

	controls_wave = inp_keybindfield(rootOfs + '56 82', controls_font_size, txt_control_bind_wave, "Wave      ", "impulse 113", M_OPTIONS_CONTROLS, CLR_DEF_BLACK, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));

	controls_point = inp_keybindfield(rootOfs + '56 104', controls_font_size, txt_control_bind_point, "Point      ", "impulse 114", M_OPTIONS_CONTROLS, CLR_DEF_BLACK, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));

	controls_chat_team = inp_keybindfield(rootOfs + '56 126', controls_font_size, txt_control_bind_chat_team, "Chat Team      ", "messagemode2", M_OPTIONS_CONTROLS, CLR_DEF_BLACK, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));

	controls_chat_all = inp_keybindfield(rootOfs + '56 148', controls_font_size, txt_control_bind_chat_all, "Chat All      ", "messagemode", M_OPTIONS_CONTROLS, CLR_DEF_BLACK, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));
  
	controls_scores = inp_keybindfield(rootOfs + '56 170', controls_font_size, txt_control_bind_scores, "Scores      ", "+showscores", M_OPTIONS_CONTROLS, CLR_DEF_BLACK, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));
};

// ini function, called by '_f' function as a setup func
void() m_controls_i =
{
  //menu_parent_setup(VIEW_ORG + '25 50', '560 320');

  //controls_title = lbl_text(MENU_ORG + menu_parent_center_width(1), '44 44', "CONTROLS", CLR_DEF_TXT_GRAY_SMOOTH, 0, M_OPTIONS_CONTROLS, 1, 0);
  controls_title = lbl_text_centered(ANCHOR_UPPER_CENTER + '0 20', '44 44', "CONTROLS", CLR_DEF_TXT_GRAY_SMOOTH, 0, M_OPTIONS_CONTROLS, 1, 0);
  controls_title.fontId = FONT_NUM_BLACKOPS_BOLD;
  //controls_title = lbl_img((MENU_ORG + menu_parent_center_width(1)+'50 -10'), '1 1 0', IMG_SUBMENUHEADER_BG, '1 1 1', VIEW_CTX, M_OPTIONS_CONTROLS, 1, UI_FLAG_SIZE_IMG );
  controls_title = lbl_img(controls_title.origin + '95 -10', '1 1 0', IMG_SUBMENUHEADER_BG, '1 1 1', VIEW_CTX, M_OPTIONS_CONTROLS, 1, UI_FLAG_SIZE_IMG );

  //movement
  //controls_ini_movement(MENU_ORG + '10 75');
  controls_ini_movement(ANCHOR_CENTER_LEFT + '15 -125');
  
  //combat
  //controls_ini_combat(MENU_ORG + '235 75');
  controls_ini_combat(ANCHOR_CENTER_25 + '35 -110');

  //inventory
  //controls_ini_inventory(MENU_ORG + '495 75');
  controls_ini_inventory(ANCHOR_CENTER_75 + '-110 -110');
  
  //special
  controls_ini_special(ANCHOR_CENTER_RIGHT + '-160 -110');
  
  controls_back = btn_text_callback(MENU_ORG + '40 375', '32 32', "BACK", VIEW_LFT, M_OPTIONS_CONTROLS, click_controls_back, CLR_MENU_BLUE, '0 1 0', 1, UI_FLAG_SIZE_IMG);
  controls_back.fontId = FONT_NUM_BLACKOPS_BOLD;
  
  controls_accept = btn_text_callback(MENU_ORG + '255 375', '32 32', "ACCEPT", VIEW_CTX, M_OPTIONS_CONTROLS, click_controls_accept, CLR_MENU_BLUE, '0 1 0', 1, UI_FLAG_SIZE_IMG);
  controls_accept.fontId = FONT_NUM_BLACKOPS_BOLD;
};

/*
  menu_f functions are like state-transition functions, preparing the menu for the next menu to load
*/
void() m_controls_f={
  DRAW_MOUSE = TRUE;
  M_STATE = M_OPTIONS_CONTROLS;
  setkeydest(KEY_MENU);
  updateAnchorPos();
  m_controls_i();
};

/*
  menu_d functions are the render functions, inside m_draw, there's a select case
  running on M_STATE to determine which menu_d to execute.
*/
void() m_controls_d=
{
	local entity widget;

	drawfont_prev = drawfont;
	drawfont = FONT_NUM_BLACKOPS_BOLD;
  
  /*
	//combat
	gui_renderString("MOVEMENT", MENU_ORG + '46 40', CLR_MENU_BLUE, '32 32 0', 1, 0);
	//controls
	gui_renderString("COMBAT", MENU_ORG + '255 40', CLR_MENU_BLUE, '32 32 0', 1, 0);
	//movement
	gui_renderString("INVENTORY", MENU_ORG + '450 40', CLR_MENU_BLUE, '32 32 0', 1, 0);
	//special
	gui_renderString("SPECIAL", MENU_ORG + '675 40', CLR_MENU_BLUE, '32 32 0', 1, 0);	//combat
	*/
	
	//combat
	gui_renderString("MOVEMENT", ANCHOR_CENTER_LEFT + '15 -135', CLR_MENU_BLUE, '32 32 0', 1, 0);
	//controls
	gui_renderString("COMBAT", ANCHOR_CENTER_25 + '35 -135', CLR_MENU_BLUE, '32 32 0', 1, 0);
	//movement
	gui_renderString("INVENTORY", ANCHOR_CENTER_75 + '-160 -135', CLR_MENU_BLUE, '32 32 0', 1, 0);
	//special
	gui_renderString("SPECIAL", ANCHOR_CENTER_RIGHT + '-160 -135', CLR_MENU_BLUE, '32 32 0', 1, 0);
	
	drawfont = drawfont_prev;
  
   gui_renderString("Mouse Sensitivity:", controls_mouse_sense_less.origin - Vector2(stringwidth("Mouse Sensitivity:  ", 0, '12 12'), -1), CLR_DEF_WHITE, '12 12', 1, 0);
   // gui_renderString("Invert Mouse:", controls_mouse_invert_off.origin - Vector2(stringwidth("Invert Mouse:  ", 0, '12 12'),-1), CLR_DEF_WHITE, '12 12', 1, 0);  
  
  widget = findchainfloat(menuId, M_OPTIONS_CONTROLS);
  while(widget){
    widget.draw(widget);
    widget = widget.chain;
  }
};

/*
  menu_k functions are the 'listener' functions
*/
void(float key, float ascii) m_controls_k={
  //cons_logAFloat("m_controls_k.key", key);  //DEBUG
  //cons_logAFloat("m_controls_k.ascii", ascii);  //DEBUG   
  
  switch(key){
    case K_ESCAPE:
      localsound("sound/misc/menu2.wav");
      localcmd("saveconfig\n");
      menu_clear_items(M_STATE);
      M_STATE = M_OPTIONS;
      m_options_f();
      break;
  }
};