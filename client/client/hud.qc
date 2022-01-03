string number[10] = {
	"pics/num_0",
	"pics/num_1",
	"pics/num_2",
	"pics/num_3",
	"pics/num_4",
	"pics/num_5",
	"pics/num_6",
	"pics/num_7",
	"pics/num_8",
	"pics/num_9"
};

string anumber[10] = {
	"pics/anum_0",
	"pics/anum_1",
	"pics/anum_2",
	"pics/anum_3",
	"pics/anum_4",
	"pics/anum_5",
	"pics/anum_6",
	"pics/anum_7",
	"pics/anum_8",
	"pics/anum_9"
};

string hud_gfx[24] = {
	"gfx/hud_shotgun",
	"gfx/hud_sshotgun",
	"gfx/hud_machinegun",
	"gfx/hud_chaingun",
	"gfx/hud_gl",
	"gfx/hud_rl",
	"gfx/hud_hyperblaster",
	"gfx/hud_railgun",
	"gfx/hud_bfg",
	"pics/a_shells",
	"pics/a_bullets",
	"pics/a_rockets",
	"pics/a_cells",
	"pics/a_slugs",
	"gfx/sb_key1",
	"gfx/sb_key2",
	"pics/k_datacd",
	"pics/k_powercube",
	"pics/k_pyramid",
	"pics/k_dataspin",
	"pics/k_security",
	"pics/k_bluekey",
	"pics/k_redkey",
	"pics/k_comhead"
};

void() Hud_Init
{
	float i;
	precache_pic("sbar", true);
	for (i = 0; i < 10; i++)
	{
		precache_pic(number[i], true);
		precache_pic(anumber[i], true);
	}
	for (i = 0; i < 24; i++)
	{
		precache_pic(hud_gfx[i], true);
	}
};

vector screensize;
float stat_items, stat_items2;

void(vector pos, float value, float threshhold) Hud_DrawLargeValue =
{
	float c;
	float len;
	string s;
	if (value < 0)
		value = 0;	//hrm
	if (value>999)
		value = 999;

	s = ftos(floor(value));
	len = strlen(s);

	pos_x += 24 * (3-len);
	

	if (value <= threshhold)
	{	//use alternate (red) numbers

		while(len>0)
		{
			len--;
			c = str2chr(s, len);

			drawpic(pos+len * '24 0 0', anumber[c-'0'], '20 24 0', '1 1 1', 1, 0);
		}
	}
	else
	{	//use normal numbers

		while(len>0)
		{
			len--;
			c = str2chr(s, len);

			drawpic(pos+len * '24 0 0', number[c-'0'], '20 24 0', '1 1 1', 1, 0);
		}
	}
};

void(float type, vector pos, float drawback) Hud_DrawAmmoCount =
{
	string s;
	float value;
	float len;
	float c;
	value = GetStat_FLOAT_TRUNCATED(type);
	if (value < 0)
		value = 0;	//hrm
	if (value>999)
		value = 999;

	s = ftos(floor(value));
	len = strlen(s);

	pos_x += 1 * (3-len);
	while(len>0)
	{
		len--;
		c = str2chr(s, len);
		drawcharacter(pos+len * '8 0 0', (18-'0') + c, '8 8 0', '1 1 1', 1, 0);
	}
};

string(float f, float chars, string lead) FormatFloat
{
	string s = ftos(f);
	if (f < 10 && chars >= 3)
		s = strcat(lead, lead, s);
	else if (f < 10 && chars == 2)
		s = strcat(lead, s);
	else if (f < 100 && chars >= 3)
		s = strcat(lead, s);
	return s;
};

void Hud_DrawIBar(vector pos)
{
//	drawpic(pos, "ibar", '320 24 0', '1 1 1', 0.333, 0);

	if (getstati(STAT_ACTIVEWEAPON) & WEP_SHOTGUN){
		drawpic(pos+'0 8 0', "gfx/hud_shotgun", '32 16 0', '1 1 1', 1, 0);	
	}
	else if (getstati(STAT_Q2WEAPONS) & WEP_SHOTGUN){
		drawpic(pos+'0 8 0', "gfx/hud_shotgun", '32 16 0', '1 1 1', 0.5, 0);
	}
	
	if (getstati(STAT_ACTIVEWEAPON) & WEP_SUPERSHOTGUN){
		drawpic(pos+'32 8 0', "gfx/hud_sshotgun", '32 16 0', '1 1 1', 1, 0);
	}
	else if (getstati(STAT_Q2WEAPONS) & WEP_SUPERSHOTGUN){
		drawpic(pos+'32 8 0', "gfx/hud_sshotgun", '32 16 0', '1 1 1', 0.5, 0);
	}

	if (getstati(STAT_ACTIVEWEAPON) & WEP_MACHINEGUN){
		drawpic(pos+'64 8 0', "gfx/hud_machinegun", '32 16 0', '1 1 1', 1, 0);
	}
	else if (getstati(STAT_Q2WEAPONS) & WEP_MACHINEGUN){
		drawpic(pos+'64 8 0', "gfx/hud_machinegun", '32 16 0', '1 1 1', 0.5, 0);
	}

	if (getstati(STAT_ACTIVEWEAPON) & WEP_CHAINGUN){
		drawpic(pos+'96 8 0', "gfx/hud_chaingun", '32 16 0', '1 1 1', 1, 0);
	}
	else if (getstati(STAT_Q2WEAPONS) & WEP_CHAINGUN){
		drawpic(pos+'96 8 0', "gfx/hud_chaingun", '32 16 0', '1 1 1', 0.5, 0);
	}

	if (getstati(STAT_ACTIVEWEAPON) & WEP_GRENADE_LAUNCHER){
		drawpic(pos+'128 8 0', "gfx/hud_gl", '32 16 0', '1 1 1', 1, 0);
	}
	else if (getstati(STAT_Q2WEAPONS) & WEP_GRENADE_LAUNCHER){
		drawpic(pos+'128 8 0', "gfx/hud_gl", '32 16 0', '1 1 1', 0.5, 0);
	}
	
	if (getstati(STAT_ACTIVEWEAPON) & WEP_ROCKET_LAUNCHER){
		drawpic(pos+'160 8 0', "gfx/hud_rl", '32 16 0', '1 1 1', 1, 0);
	}
	else if (getstati(STAT_Q2WEAPONS) & WEP_ROCKET_LAUNCHER){
		drawpic(pos+'160 8 0', "gfx/hud_rl", '32 16 0', '1 1 1', 0.5, 0);
	}

	if (getstati(STAT_ACTIVEWEAPON) & WEP_HYPERBLASTER){
		drawpic(pos+'192 8 0', "gfx/hud_hyperblaster", '32 16 0', '1 1 1', 1, 0);
	}
	else if (getstati(STAT_Q2WEAPONS) & WEP_HYPERBLASTER){
		drawpic(pos+'192 8 0', "gfx/hud_hyperblaster", '32 16 0', '1 1 1', 0.5, 0);
	}
	
	if (getstati(STAT_ACTIVEWEAPON) & WEP_RAILGUN){
		drawpic(pos+'224 8 0', "gfx/hud_railgun", '32 16 0', '1 1 1', 1, 0);
	}
	else if (getstati(STAT_Q2WEAPONS) & WEP_RAILGUN){
		drawpic(pos+'224 8 0', "gfx/hud_railgun", '32 16 0', '1 1 1', 0.5, 0);
	}
	
	if (getstati(STAT_ACTIVEWEAPON) & WEP_BFG){
		drawpic(pos+'256 8 0', "gfx/hud_bfg", '32 16 0', '1 1 1', 1, 0);
	}
	else if (getstati(STAT_Q2WEAPONS) & WEP_BFG){
		drawpic(pos+'256 8 0', "gfx/hud_bfg", '32 16 0', '1 1 1', 0.5, 0);
	}
	
	drawpic(pos+'0 -2 0', "pics/a_shells", '10 10 0', '1 1 1', 0.85, 0);	
	Hud_DrawAmmoCount(STAT_AMMO_SHELLS, pos + '10 0 0', true);
	drawpic(pos+'36 -2 0', "pics/a_bullets", '10 10 0', '1 1 1', 0.85, 0);	
	Hud_DrawAmmoCount(STAT_AMMO_BULLETS, pos + '45 0 0', true);
	drawpic(pos+'72 -2 0', "pics/a_rockets", '10 10 0', '1 1 1', 0.85, 0);	
	Hud_DrawAmmoCount(STAT_AMMO_ROCKETS, pos + '82 0 0', true);
	drawpic(pos+'108 -2 0', "pics/a_cells", '10 10 0', '1 1 1', 0.85, 0);	
	Hud_DrawAmmoCount(STAT_AMMO_CELLS, pos + '118 0 0', true);
	drawpic(pos+'144 -2 0', "pics/a_slugs", '10 10 0', '1 1 1', 0.85, 0);	
	Hud_DrawAmmoCount(STAT_AMMO_SLUGS, pos + '154 0 0', true);	

	if (stat_items & IT_KEY1)
		drawpic(pos+'192 -8 0', "gfx/sb_key1", '16 16 0', '1 1 1', 1, 0);
	if (stat_items & IT_KEY2)
		drawpic(pos+'208 -8 0', "gfx/sb_key2", '16 16 0', '1 1 1', 1, 0);

	//Quake 2 Keys
	
	if (getstati(STAT_Q2KEYS) & IT_KEY_DATACD)
		drawpic(pos+'0 -20 0', "pics/k_datacd", '16 16 0', '1 1 1', 1, 0);
	if (getstati(STAT_Q2KEYS) & IT_KEY_POWERCUBE)
		drawpic(pos+'16 -20 0', "pics/k_powercube", '16 16 0', '1 1 1', 1, 0);
	if (getstati(STAT_Q2KEYS) & IT_KEY_PYRAMID)
		drawpic(pos+'32 -20 0', "pics/k_pyramid", '16 16 0', '1 1 1', 1, 0);
	if (getstati(STAT_Q2KEYS) & IT_KEY_DATASPINNER)
		drawpic(pos+'48 -20 0', "pics/k_dataspin", '16 16 0', '1 1 1', 1, 0);
	if (getstati(STAT_Q2KEYS) & IT_KEY_PASS)
		drawpic(pos+'64 -20 0', "pics/k_security", '16 16 0', '1 1 1', 1, 0);
	if (getstati(STAT_Q2KEYS) & IT_KEY_BLUE)
		drawpic(pos+'80 -20 0', "pics/k_bluekey", '16 16 0', '1 1 1', 1, 0);
	if (getstati(STAT_Q2KEYS) & IT_KEY_RED)
		drawpic(pos+'96 -20 0', "pics/k_redkey", '16 16 0', '1 1 1', 1, 0);
	if (getstati(STAT_Q2KEYS) & IT_KEY_HEAD)
		drawpic(pos+'112 -20 0', "pics/k_comhead", '16 16 0', '1 1 1', 1, 0);	

	if (stat_items2 & 32)
		drawpic(pos+'288 8 0', "gfx/sb_sigil1", '8 16 0', '1 1 1', 1, 0);
	if (stat_items2 & 64)
		drawpic(pos+'296 8 0', "gfx/sb_sigil2", '8 16 0', '1 1 1', 1, 0);
	if (stat_items2 & 128)
		drawpic(pos+'304 8 0', "gfx/sb_sigil3", '8 16 0', '1 1 1', 1, 0);
	if (stat_items2 & 256)
		drawpic(pos+'312 8 0', "gfx/sb_sigil4", '8 16 0', '1 1 1', 1, 0);
};

void(vector pos) Hud_CoopScores_SBar =
{
	string s;
	float secs;
	float mins;
	//When you press tab in single player/coop, you get some replacement info over the sbar
	vector sbar = screensize_y * ' 0 1 0' - '0 24 0';

	Hud_DrawIBar(pos - '0 48 0'); //0 48 0
	
//	drawpic(sbar, "scorebar", '320 24 0', '1 1 1', 0.333, 0);

	s = strcat("Monsters:", FormatFloat(getstati(STAT_MONSTERS), 3, " "), "/", FormatFloat(getstati(STAT_TOTALMONSTERS), 3, " "));
	drawstring(sbar + '8 4', s, '8 8 0', '1 1 1', 1, 0);
	s = strcat("Secrets :", FormatFloat(getstati(STAT_SECRETS), 3, " "), "/", FormatFloat(getstati(STAT_TOTALSECRETS), 3, " "));
	drawstring(sbar + '8 12', s, '8 8 0', '1 1 1', 1, 0);

	mins = floor(time/60);
	secs = floor(time - mins*60);
	s = strcat("Time :", FormatFloat(mins, 3, " "), ":", FormatFloat(secs, 2, "0"));
	drawstring(sbar + '184 4', s, '8 8 0', '1 1 1', 1, 0);

	drawstring(sbar + '232 12' - strlen(mapname)*'4 0', mapname, '8 8 0', '1 1 1', 1, 0);
};

void Hud_DrawSBar(vector pos)
{
//	drawpic(pos, "sbar", '320 24 0', '1 1 1', 0.333, 0);

	if (stat_items & IT_INVULNERABILITY)
	{
		drawpic(pos, "gfx/disc", '24 24 0', '1 1 1', 1, 0);
		Hud_DrawLargeValue(pos+'24 0 0', 999, 25);
	}
	else
	{
		if (getstati(STAT_ARMOR) <= 0)
		{
		}
		else{
		Hud_DrawLargeValue(pos+'24 0 0', getstati(STAT_ARMOR), 25);
		if (stat_items & IT_ARMOR_BODY)
			drawpic(pos, "pics/i_bodyarmor", '24 24 0', '1 1 1', 1, 0);
		else if (stat_items & IT_ARMOR_COMBAT)
			drawpic(pos, "pics/i_combatarmor", '24 24 0', '1 1 1', 1, 0);
		else if (stat_items & IT_ARMOR_JACKET)
			drawpic(pos, "pics/i_jacketarmor", '24 24 0', '1 1 1', 1, 0);
		}
	}

	drawpic(pos+'112 0 0', "pics/i_health", '0 24 0', '1 1 1', 1, 0);
	Hud_DrawLargeValue(pos+'136 0 0', getstati(STAT_HEALTH), 25);

	if (stat_items & IT_SHELLS)
		drawpic(pos+'224 0 0', "pics/a_shells", '24 24 0', '1 1 1', 1, 0);
	else if (stat_items & IT_BULLETS)
		drawpic(pos+'224 0 0', "pics/a_bullets", '24 24 0', '1 1 1', 1, 0);
	else if (stat_items & IT_ROCKETS)
		drawpic(pos+'224 0 0', "pics/a_rockets", '24 24 0', '1 1 1', 1, 0);
	else if (stat_items & IT_CELLS)
		drawpic(pos+'224 0 0', "pics/a_cells", '24 24 0', '1 1 1', 1, 0);
	else if (stat_items & IT_SLUGS)
		drawpic(pos+'224 0 0', "pics/a_slugs", '24 24 0', '1 1 1', 1, 0);
	else
		drawpic(pos+'224 0 0', "pics/a_blaster", '24 24 0', '1 1 1', 1, 0);
	
	if (getstati(STAT_ACTIVEWEAPON) & WEP_BLASTER){
	//	Hud_DrawWeaponActive(0, pos+'0 8 0');
	}
	else{
	Hud_DrawLargeValue(pos+'248 0 0', getstati(STAT_AMMO), 10);
	}
	
	local string itemImage = string_null;
	
	switch (getstati(STAT_PICKUP)){
		case INV_PICKUP_NONE:
			itemImage = string_null;
			break;
		case INV_PICKUP_QUAD:
			drawpic(pos+'0 -24 0', "pics/p_quad", '24 24 0', '1 1 1', 1, 0);
			Hud_DrawAmmoCount(STAT_INV_QUAD, pos + '15 -8 0', true);
			break;
		case INV_PICKUP_REBREATHER:
			drawpic(pos+'0 -24 0', "pics/p_rebreather", '24 24 0', '1 1 1', 1, 0);
			Hud_DrawAmmoCount(STAT_INV_REBREATHER, pos + '15 -8 0', true);			
			break;
		case INV_PICKUP_INVISIBILITY:
			drawpic(pos+'0 -24 0', "pics/i_powerscreen", '24 24 0', '1 1 1', 1, 0);
			Hud_DrawAmmoCount(STAT_INV_INVIS, pos + '15 -8 0', true);			
			break;
		case INV_PICKUP_SILENCER:
			drawpic(pos+'0 -24 0', "gfx/i_silencer", '24 24 0', '1 1 1', 1, 0);
			Hud_DrawAmmoCount(STAT_INV_SILENCER, pos + '15 -8 0', true);			
			break;
		case INV_PICKUP_INVULNERABILITY:
			drawpic(pos+'0 -24 0', "pics/p_invulnerability", '24 24 0', '1 1 1', 1, 0);
			Hud_DrawAmmoCount(STAT_INVINVUL, pos + '15 -8 0', true);			
			break;
		case INV_PICKUP_ENVIROSUIT:
			drawpic(pos+'0 -24 0', "pics/p_envirosuit", '24 24 0', '1 1 1', 1, 0);
			Hud_DrawAmmoCount(STAT_ENVIRO, pos + '15 -8 0', true);			
			break;
	}

	if (stat_items & IT_SILENCER)
		drawpic(pos+'96 -20 0', "gfx/i_silencer", '16 16 0', '1 1 1', 1, 0);
	if (stat_items & IT_BREATHER)
		drawpic(pos+'112 -20 0', "pics/p_rebreather", '16 16 0', '1 1 1', 1, 0);
	if (stat_items & IT_INVISIBILITY)
		drawpic(pos+'128 -20 0', "pics/i_powerscreen", '16 16 0', '1 1 1', 1, 0);
	if (stat_items & IT_INVULNERABILITY)
		drawpic(pos+'144 -20 0', "pics/p_invulnerability", '16 16 0', '1 1 1', 1, 0);
	if (stat_items & IT_SUIT)
		drawpic(pos+'160 -20 0', "pics/p_envirosuit", '16 16 0', '1 1 1', 1, 0);
	if (stat_items & IT_QUAD)
		drawpic(pos+'176 -20 0', "pics/p_quad", '16 16 0', '1 1 1', 1, 0);
};

nonstatic void Hud_Draw(float hudtype, float scoreboard, float width, float height)
{
	vector pos;
	screensize_x = width;
	screensize_y = height;
	screensize_z = 0;

	pos_x = (screensize_x-320)/2;
	pos_y = screensize_y;

	stat_items = GetStat_BITS(STAT_ITEMS, 0, 23);
	stat_items2 = GetStat_BITS(STAT_ITEMS, 23, 9);

	//if hudtype == 0 then the engine already drew it.
	if (hudtype == 2)
	{
		if (scoreboard)
		{
			Hud_CoopScores_SBar(pos - '0 0 0'); //0 24 0
		}
		else
		{
			Hud_DrawSBar(pos - '0 24 0');
		}
	}
	
	if (hudtype == 1)
	{
		//intermission?
		Hud_DrawSBar(pos - '0 -96 0');
	}
};
