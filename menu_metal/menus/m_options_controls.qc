/*
threshold3
Author: Peter Roohr
Overview: options-controls
*/

//controls Globals
entity controls_title;

//combat
entity controls_mouse_sense;
entity controls_mouse_sense_more;
entity controls_mouse_sense_less;
entity controls_mouse_invert;
entity controls_mouse_invert_on;
entity controls_mouse_invert_off;
entity controls_target;
entity controls_zoom;
entity controls_headlight;

//movement
entity controls_forward;
entity controls_backward;
entity controls_strafe_left;
entity controls_strafe_right;
entity controls_sprint;
entity controls_jump;
entity controls_crouch;

//inventory
entity controls_objectives;
entity controls_tacmap;

entity controls_wep_next;
entity controls_wep_prev;
entity controls_inv_prev;
entity controls_inv_next;
entity controls_inv_use;
entity controls_inv_drop_weapon;
entity controls_inv_drop_ammo;

//multiplayer
entity controls_chat_team;
entity controls_chat_all;

entity controls_taunt_flip;
entity controls_taunt_salute;
entity controls_taunt_taunt;
entity controls_taunt_wave;
entity controls_taunt_point;

entity controls_camera;

//controls constants
string IMG_CONTROLS_TITLE = "gfx/menu/options/options_title.png"; //ugh, re-used elsewhere, will need to clean up eventually.

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

void() txt_control_bind_target={
  menu_keybind_change ("impulse 7");
};

void() txt_control_bind_fire={
  menu_keybind_change ("+attack");
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
  menu_keybind_change ("+jump");
};

void() txt_control_bind_crouch={
  menu_keybind_change ("+button4");
};

void() txt_control_bind_obj={
  menu_keybind_change ("impulse 25");
};
void() txt_control_bind_map={
  menu_keybind_change ("impulse 12");
};

void() txt_control_bind_wep_next={
  menu_keybind_change ("impulse 30");
};
void() txt_control_bind_wep_prev={
  menu_keybind_change ("impulse 31");
};

void() txt_control_bind_inv_prev={
  menu_keybind_change ("impulse 32");
};

void() txt_control_bind_inv_next={
  menu_keybind_change ("impulse 33");
};

void() txt_control_bind_inv_use={
  menu_keybind_change ("impulse 34");
};

void() txt_control_bind_inv_drop_wep={
  //menu_keybind_change ("impulse 12");
  //TODO
};

void() txt_control_bind_inv_drop_ammo={
  //menu_keybind_change ("impulse 12");
  //TODO
};

void() txt_control_bind_chat_team={
  menu_keybind_change ("messagemode2");
};
void() txt_control_bind_chat_all={
  menu_keybind_change ("messagemode");
};

void() txt_control_bind_taunt_flip={
  menu_keybind_change ("impulse 110");
};
void() txt_control_bind_taunt_salute={
  menu_keybind_change ("impulse 111");
};
void() txt_control_bind_taunt_taunt={
  menu_keybind_change ("impulse 112");
};
void() txt_control_bind_taunt_wave={
  menu_keybind_change ("impulse 113");
};
void() txt_control_bind_taunt_point={
  menu_keybind_change ("impulse 114");
};

void() txt_control_bind_zoom={
  menu_keybind_change ("+button3");
};
void() txt_control_bind_camera={
  menu_keybind_change ("impulse 30");
};
void() txt_control_bind_headlight={
  menu_keybind_change ("impulse 32");
};



void() click_controls_back={
  menu_clear_items(M_STATE);
  m_options_f();
};

void() click_controls_accept={
  localcmd("saveconfig\n");
  click_controls_back();
};


//break out 3 major categories into 'sub' groups for alignment
void(vector rootOfs) controls_ini_movement={

  controls_mouse_sense = lbl_text(rootOfs + '110 0', '14 14', " ", CLR_DEF_TXT_GRAY_SMOOTH, VIEW_CTX, M_OPTIONS_CONTROLS, 1, UI_FLAG_LBL_USELEN);
  controls_mouse_sense.len = cvar("sensitivity");
  
  controls_mouse_sense_more = btn_img_callback(controls_mouse_sense.origin + '16 0', '12 12', UI_IMG_ARW_RGT, 0, M_OPTIONS_CONTROLS, click_control_mouse_sense_more, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  controls_mouse_sense_less = btn_img_callback(controls_mouse_sense.origin - Vector2(24,0), '12 12', UI_IMG_ARW_LFT, 0, M_OPTIONS_CONTROLS, click_control_mouse_sense_less, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

  if(controls_mouse_sense.len == 1){
    controls_mouse_sense_less.drawme = FALSE;
  }
  else if(controls_mouse_sense.len == 35){
    controls_mouse_sense_more.drawme = FALSE;
  }
  
  controls_mouse_invert = lbl_text(rootOfs + '110 19', '14 14', "", CLR_DEF_TXT_GRAY_SMOOTH, VIEW_CTX, M_OPTIONS_CONTROLS, 1, UI_FLAG_LBL_BOOL_ON);
  controls_mouse_invert.len = cvar("m_pitch");
  
  controls_mouse_invert_on = btn_img_callback(controls_mouse_invert.origin + '20 0', '12 12', UI_IMG_ARW_RGT, 0, M_OPTIONS_CONTROLS, click_control_mouse_invert_on, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  controls_mouse_invert_off = btn_img_callback(controls_mouse_invert.origin - Vector2(24,0), '12 12', UI_IMG_ARW_LFT, 0, M_OPTIONS_CONTROLS, click_control_mouse_invert_off, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

  if(controls_mouse_invert.len < 0){
    controls_mouse_invert_on.drawme = FALSE;
  }
  else{
    controls_mouse_invert_off.drawme = FALSE;
  }
  
  controls_forward = inp_keybindfield(rootOfs + '86 38', '14 14', txt_control_bind_forward, "Forward:  ", "+forward", M_OPTIONS_CONTROLS, CLR_DEF_TXT_GRAY_SMOOTH, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));

  controls_backward = inp_keybindfield(rootOfs + '86 60', '14 14', txt_control_bind_backward, "Backward:  ", "+back", M_OPTIONS_CONTROLS, CLR_DEF_TXT_GRAY_SMOOTH, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));

  controls_strafe_left = inp_keybindfield(rootOfs + '86 82', '14 14', txt_control_bind_strafeleft, "Strafe Left:  ", "+moveleft", M_OPTIONS_CONTROLS, CLR_DEF_TXT_GRAY_SMOOTH, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));

  controls_strafe_right = inp_keybindfield(rootOfs + '86 104', '14 14', txt_control_bind_straferight, "Strafe Right:  ", "+moveright", M_OPTIONS_CONTROLS, CLR_DEF_TXT_GRAY_SMOOTH, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));
  
  controls_sprint = inp_keybindfield(rootOfs + '86 126', '14 14', txt_control_bind_sprint, "Sprint:  ", "+button8", M_OPTIONS_CONTROLS, CLR_DEF_TXT_GRAY_SMOOTH, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));

  controls_jump = inp_keybindfield(rootOfs + '86 148', '14 14', txt_control_bind_jump, "Jump:  ", "+jump", M_OPTIONS_CONTROLS, CLR_DEF_TXT_GRAY_SMOOTH, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));
  
  controls_crouch = inp_keybindfield(rootOfs + '86 170', '14 14', txt_control_bind_crouch, "Crouch:  ", "+button4", M_OPTIONS_CONTROLS, CLR_DEF_TXT_GRAY_SMOOTH, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));
};


void(vector rootOfs) controls_ini_inventory={
  
  controls_objectives = inp_keybindfield(rootOfs + '40 0', '14 14', txt_control_bind_forward, "Toggle Objectives:  ", "todo", M_OPTIONS_CONTROLS, CLR_DEF_TXT_GRAY_SMOOTH, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));

  controls_tacmap = inp_keybindfield(rootOfs + '40 19', '14 14', txt_control_bind_forward, "Tac Map?:  ", "todo", M_OPTIONS_CONTROLS, CLR_DEF_TXT_GRAY_SMOOTH, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));
  
  controls_wep_next = inp_keybindfield(rootOfs + '40 38', '14 14', txt_control_bind_wep_next, "Next Weapon:  ", "impulse 30", M_OPTIONS_CONTROLS, CLR_DEF_TXT_GRAY_SMOOTH, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));
  
  controls_wep_prev = inp_keybindfield(rootOfs + '40 60', '14 14', txt_control_bind_wep_prev, "Prev Weapon:  ", "impulse 31", M_OPTIONS_CONTROLS, CLR_DEF_TXT_GRAY_SMOOTH, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));
  
  controls_inv_next = inp_keybindfield(rootOfs + '40 82', '14 14', txt_control_bind_inv_next, "Next Item:  ", "impulse 32", M_OPTIONS_CONTROLS, CLR_DEF_TXT_GRAY_SMOOTH, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));
  
  controls_inv_prev = inp_keybindfield(rootOfs + '40 104', '14 14', txt_control_bind_inv_prev, "Prev Item:  ", "impulse 33", M_OPTIONS_CONTROLS, CLR_DEF_TXT_GRAY_SMOOTH, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));
  
  controls_inv_use = inp_keybindfield(rootOfs + '40 126', '14 14', txt_control_bind_inv_use, "Use Item:  ", "impulse 34", M_OPTIONS_CONTROLS, CLR_DEF_TXT_GRAY_SMOOTH, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));
  
  controls_inv_drop_weapon = inp_keybindfield(rootOfs + '40 148', '14 14', txt_control_bind_inv_drop_wep, "Drop Weapon:  ", "todo", M_OPTIONS_CONTROLS, CLR_DEF_TXT_GRAY_SMOOTH, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));
  
  controls_inv_drop_ammo = inp_keybindfield(rootOfs + '40 170', '14 14', txt_control_bind_inv_drop_ammo, "Drop Ammo:  ", "todo", M_OPTIONS_CONTROLS, CLR_DEF_TXT_GRAY_SMOOTH, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));
  
};


void(vector rootOfs) controls_ini_net={

  controls_target = inp_keybindfield(rootOfs + '56 0', '14 14', txt_control_bind_target, "Ping area:  ", "impulse 7", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));

  controls_chat_team = inp_keybindfield(rootOfs + '56 19', '14 14 0', txt_control_bind_chat_team, "Chat Team:  ", "messagemode2", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));

  controls_chat_all = inp_keybindfield(rootOfs + '56 38', '14 14 0', txt_control_bind_chat_all, "Chat All:  ", "messagemode", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));
  
  controls_taunt_flip = inp_keybindfield(rootOfs + '56 60', '14 14 0', txt_control_bind_taunt_flip, "Flipoff:  ", "impulse 110", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));;
  
  controls_taunt_salute = inp_keybindfield(rootOfs + '56 82', '14 14 0', txt_control_bind_taunt_salute, "Salute:  ", "impulse 111", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));;
  
  controls_taunt_taunt = inp_keybindfield(rootOfs + '56 104', '14 14 0', txt_control_bind_taunt_taunt, "taunt:  ", "impulse 112", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));;
  
  controls_taunt_wave = inp_keybindfield(rootOfs + '56 126', '14 14 0', txt_control_bind_taunt_wave, "Wave:  ", "impulse 113", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));;
  
  controls_taunt_point = inp_keybindfield(rootOfs + '56 148', '14 14 0', txt_control_bind_taunt_point, "Point:  ", "impulse 114", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));;
  
  controls_zoom = inp_keybindfield(rootOfs + '56 170', '14 14 0', txt_control_bind_zoom, "Optical Zoom:  ", "+button3", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));
 
  controls_camera = inp_keybindfield(rootOfs + '56 192', '14 14 0', txt_control_bind_camera, "External Camera: ", "impulse 30", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));
  
  controls_headlight = inp_keybindfield(rootOfs + '56 212', '14 14 0', txt_control_bind_headlight, "Headlight: ", "impulse 32", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));
};

// ini function, called by '_f' function as a setup func
void() m_controls_i={
  
  menu_parent_setup([UI_CTR_x - 560/2, VIEW_ORG_y + 64], '560 320');
  
  controls_title = lbl_text( menu_parent_center_width(75), '18 18', "CONTROLS", '0.75 0.75 0.75', VIEW_CTX | VIEW_CTY, M_OPTIONS_CONTROLS, 1, UI_FLAG_SIZE_IMG );
  
  //movement
  controls_ini_movement(MENU_ORG + '10 58');
  
  //combat
  controls_ini_inventory(MENU_ORG + '235 58');

  //multiplayer
  controls_ini_net(MENU_ORG + '425 58');
  
  controls_back = btn_text_callback(MENU_ORG + '40 272', '16 16', "BACK", VIEW_CTX, M_OPTIONS_CONTROLS, click_controls_back, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, UI_FLAG_SIZE_IMG);
  controls_back.fontId = FONT_NUM_BLACK_OPS_ONE;
  
  controls_accept = btn_text_callback(MENU_ORG + '255 272', '16 16', "ACCEPT", VIEW_CTX, M_OPTIONS_CONTROLS, click_controls_accept, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, UI_FLAG_SIZE_IMG);
  controls_accept.fontId = FONT_NUM_BLACK_OPS_ONE;
};

/*
  menu_f functions are like state-transition functions, preparing the menu for the next menu to load
*/
void() m_controls_f={
  DRAW_MOUSE = TRUE;
  M_STATE = M_OPTIONS_CONTROLS;
  setkeydest(KEY_MENU);
  m_controls_i();
};

/*
  menu_d functions are the render functions, inside m_draw, there's a select case
  running on M_STATE to determine which menu_d to execute.
*/
void() m_controls_d={
  local entity widget;

  gui_renderPatch9_1_32(MENU_ORG, MENU_SIZE, '0.35 0.35 0.55', 0.85, 0);

  drawfont_prev = drawfont;
  drawfont = FONT_NUM_BLACK_OPS_ONE;

  //combat
  gui_renderString("Movement", MENU_ORG + '46 40', CLR_DEF_ARM_THREEQ, '16 16 0', 1, 0);
    gui_renderString("Mouse Sensitivity:", controls_mouse_sense_less.origin - Vector2(stringwidth("Mouse Sensitivity:  ", 0, '12 12'), -1), CLR_DEF_WHITE, '12 12', 1, 0);
    gui_renderString("Invert Mouse:", controls_mouse_invert_off.origin - Vector2(stringwidth("Invert Mouse:  ", 0, '12 12'),-1), CLR_DEF_WHITE, '12 12', 1, 0);
  
  //Inventory
  gui_renderString("Inventory", MENU_ORG + '235 40', CLR_DEF_IIF_FRIEND_BLD, '16 16 0', 1, 0);

  //Misc
  gui_renderString("Multiplayer", MENU_ORG + '425 40', CLR_DEF_GREEN, '16 16 0', 1, 0);
  
  drawfont = drawfont_prev;
  
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