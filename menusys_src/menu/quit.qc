/***************************************************************************
Quit menu. Quite lame for now.
*/

#define QUIT_MENU_ITEM_SCALE 8 //16

float() cvars_haveunsaved = #0;
nonstatic void(mitem_desktop desktop) M_Quit =
{
	local float pos;
	mitem_exmenu m;
	m = spawn(mitem_exmenu, item_text:_("Options"), item_flags:IF_SELECTABLE, item_command:"m_main");
	desktop.add(m, RS_X_MIN_PARENT_MIN|RS_Y_MIN_PARENT_MIN | RS_X_MAX_PARENT_MAX|RS_Y_MAX_PARENT_MAX, '0 0', '0 0');
	desktop.item_focuschange(m, IF_KFOCUSED);
	m.totop();

	//center the actual items
	pos = (16/-2)*(2);

	//draw title art above the options
//	mitem_pic banner = spawn(mitem_pic, item_text:"gfx/p_option.lmp", item_size_y:24, item_flags:IF_CENTERALIGN);
//	m.add(banner, RS_X_MIN_PARENT_MID|RS_Y_MIN_PARENT_MID | RS_X_MAX_PARENT_MID|RS_Y_MAX_PARENT_MID, [(-160-banner.item_size_x)*0.5, pos-32], [(-160+banner.item_size_x)*0.5, pos-8]);

	if (cvars_haveunsaved())
	{
		m.add(spawn(mitem_text, item_text:"Save configuration?", item_scale:QUIT_MENU_ITEM_SCALE, item_flags:IF_CENTERALIGN), RS_X_MIN_PARENT_MID|RS_Y_MIN_PARENT_MID | RS_X_MAX_PARENT_MID|RS_Y_MAX_PARENT_MID, [-160, pos-(8+16)], [0, pos-8]);	pos += 16;

		m.add(spawn(mitem_text, item_text:"Save and quit", item_command:"m_pop;cfg_save;quit", item_scale:QUIT_MENU_ITEM_SCALE, item_flags:IF_CENTERALIGN), RS_X_MIN_PARENT_MID|RS_Y_MIN_PARENT_MID | RS_X_MAX_PARENT_MID|RS_Y_MAX_PARENT_MID, [-160, pos], [0, pos+16]);	pos += 16;
		m.add(spawn(mitem_text, item_text:"Quit and discard settings", item_command:"m_pop;quit", item_scale:QUIT_MENU_ITEM_SCALE, item_flags:IF_CENTERALIGN), RS_X_MIN_PARENT_MID|RS_Y_MIN_PARENT_MID | RS_X_MAX_PARENT_MID|RS_Y_MAX_PARENT_MID, [-160, pos], [0, pos+16]);	pos += 16;
		m.add(spawn(mitem_text, item_text:"Keep playing.", item_command:"m_pop;m_main", item_scale:QUIT_MENU_ITEM_SCALE, item_flags:IF_CENTERALIGN), RS_X_MIN_PARENT_MID|RS_Y_MIN_PARENT_MID | RS_X_MAX_PARENT_MID|RS_Y_MAX_PARENT_MID, [-160, pos], [0, pos+16]);	pos += 16;
	}
	else
	{
		m.add(spawn(mitem_text, item_text:"Really Quit?", item_scale:QUIT_MENU_ITEM_SCALE, item_flags:IF_CENTERALIGN), RS_X_MIN_PARENT_MID|RS_Y_MIN_PARENT_MID | RS_X_MAX_PARENT_MID|RS_Y_MAX_PARENT_MID, [-160, pos-(8+16)], [0, pos-8]);	pos += 16;

		m.add(spawn(mitem_text, item_text:"Yes, I'm late for work.", item_command:"m_pop;quit", item_scale:QUIT_MENU_ITEM_SCALE, item_flags:IF_CENTERALIGN), RS_X_MIN_PARENT_MID|RS_Y_MIN_PARENT_MID | RS_X_MAX_PARENT_MID|RS_Y_MAX_PARENT_MID, [-160, pos], [0, pos+16]);	pos += 16;
		m.add(spawn(mitem_text, item_text:"No, keep playing!", item_command:"m_pop;m_main", item_scale:QUIT_MENU_ITEM_SCALE, item_flags:IF_CENTERALIGN), RS_X_MIN_PARENT_MID|RS_Y_MIN_PARENT_MID | RS_X_MAX_PARENT_MID|RS_Y_MAX_PARENT_MID, [-160, pos], [0, pos+16]);	pos += 16;
	}

	//random art for style
#if 1//def CSQC
	m.add(spawn (mitem_spinnymodel, item_text: "progs/suit.mdl"), RS_X_MIN_PARENT_MID|RS_Y_MIN_PARENT_MID | RS_X_MAX_PARENT_MID|RS_Y_MAX_PARENT_MID, [0, 12*-16/2], [160, 12*16/2]);
#else
	//menuqc doesn't support entities. shove some random crappy static image there instead.
	local mitem_pic plaque = spawn (mitem_pic, item_text:"gfx/qplaque.lmp", item_alpha:1);
	m.addm(plaque, [(160-plaque.item_size_x)*0.5, 12*-16/2], [(160+plaque.item_size_x)*0.5, 12*16/2]);
#endif
	addmenuback(m);
};