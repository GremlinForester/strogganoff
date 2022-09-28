string(float playernum, string keyname) getplayerkeyvalue = #348;

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

//Deathmatch and Coop scoreboards are the same for now. May just integrate into one with checks later one depending on different stat tracking.

vector(string picname, float height) Hud_AspectSize =
{
	vector sz = drawgetimagesize(picname);
	return [sz_x * height/sz_y, height];
};
void(string picname, float screenwidth, vector pos, float height) Hud_CentrePic =
{
	vector sz = Hud_AspectSize(picname, height);
	pos_x += (screenwidth-sz_x)/2;
	drawpic(pos, picname, sz, [1,1,1],1,0);
};
void(vector virtmin, vector virtsize) Hud_DeathmatchScoreboard =
{
	vector pos = virtmin;
	
	drawstring('0 0 0', "Deathmatch Scores", '8 8 0', '0 0 1', 1, 0);		
	
	if not (getplayerkeyvalue(-16, "name"))
		pos_y += (virtsize_y-200)/2;

	if not (getplayerkeyvalue(-24, "name"))
	{	//and only draw the header when its not a really big game
		pos_y += 8;
		Hud_CentrePic("gfx/ranking.lmp", virtsize_x, pos, 24);	pos_y += 24;
		pos_y += 10;
	}
	/*
	if (autocvar(cg_woot, 0))	//I added this mostly just to demonstrate that you're actually using the csqc version...
		pos_x = (virtsize_x-320)/2 * (1+sin(time));
	else
		pos_x += (virtsize_x-320)/2;
	*/
	
	pos_x += (virtsize_x-320)/2;	
	
	pos_x += 80;

	//negative numbers are players sorted by frags.
	for (float i = -1; ; i--, pos_y += 10)
	{
		string name = getplayerkeyvalue(i, "name");
		if not (name)
			break;
		float isspec = stof(getplayerkeyvalue(i, "*spectator"));
		string frags = getplayerkeyvalue(i, "frags");
		string ping = getplayerkeyvalue(i, "ping");
		vector top = stov(getplayerkeyvalue(i, "topcolor_rgb"));
		vector bot = stov(getplayerkeyvalue(i, "bottomcolor_rgb"));
		name = strconv(0,2,2, name);
		//FIXME: string team = getplayerkeyvalue(i, "team");	//QW team names do NOT match player colours.
		/*Other interesting fields
			pl 			- for packetloss
			activetime	- how long the player has been on the server.
			chat 		- to check if someone is at the console/tabbed out
			userid		- for easy banning etc, assuming you're the server.
			ignored		- text from this player will be dropped clientside.
			vignored	- voicechat from this player will be dropped (clientside and hopefully serverside too).
			voipspeaking- whether they're speaking or not
			voiploudness- the player's average voip volume.
			also any other networked userinfo
		*/

		drawstring(pos-[8*5	,0], strpad(-4, ping), [8,8], [1,1,1],1,0);
		if (isspec)
			drawstring(pos+[4,0], "spec", [8,8], [1,1,1],1,0);
		else
		{
			drawfill(pos+[0,0], [40,4], top, 0.75, 0);
			drawfill(pos+[0,4], [40,4], bot, 0.75, 0);
			drawstring(pos+[8,0], strpad(-3, frags), [8,8], [1,1,1],1,0);
			if (player_localentnum == stof(getplayerkeyvalue(i, "viewentity")))
			{
//				drawcharacter(pos-[8,0], 0xe00d, [8,8], [1,1,1],1, 0);
				drawcharacter(pos+[ 0,0], 0xe010, [8,8], [1,1,1],1, 0);
				drawcharacter(pos+[32,0], 0xe011, [8,8], [1,1,1],1, 0);
			}
		}
		drawstring(pos+[64,0], name, [8,8], [1,1,1],1,0);
	}
};

void(vector virtmin, vector virtsize) Hud_CoopScoreboard =
{
	vector pos = virtmin;
	
	drawstring('0 0 0', "Coop Scores", '8 8 0', '0 0 1', 1, 0);	
	
	if not (getplayerkeyvalue(-16, "name"))
		pos_y += (virtsize_y-200)/2;

	if not (getplayerkeyvalue(-24, "name"))
	{	//and only draw the header when its not a really big game
		pos_y += 8;
		Hud_CentrePic("gfx/ranking.lmp", virtsize_x, pos, 24);	pos_y += 24;
		pos_y += 10;
	}
	/*
	if (autocvar(cg_woot, 0))	//I added this mostly just to demonstrate that you're actually using the csqc version...
		pos_x = (virtsize_x-320)/2 * (1+sin(time));
	else
		pos_x += (virtsize_x-320)/2;
	*/

	pos_x += (virtsize_x-320)/2;
	
	pos_x += 80;

	//negative numbers are players sorted by frags.
	for (float i = -1; ; i--, pos_y += 10)
	{
		string name = getplayerkeyvalue(i, "name");
		if not (name)
			break;
		float isspec = stof(getplayerkeyvalue(i, "*spectator"));
		string frags = getplayerkeyvalue(i, "frags");
		string ping = getplayerkeyvalue(i, "ping");
		vector top = stov(getplayerkeyvalue(i, "topcolor_rgb"));
		vector bot = stov(getplayerkeyvalue(i, "bottomcolor_rgb"));
		name = strconv(0,2,2, name);
		//FIXME: string team = getplayerkeyvalue(i, "team");	//QW team names do NOT match player colours.
		/*Other interesting fields
			pl 			- for packetloss
			activetime	- how long the player has been on the server.
			chat 		- to check if someone is at the console/tabbed out
			userid		- for easy banning etc, assuming you're the server.
			ignored		- text from this player will be dropped clientside.
			vignored	- voicechat from this player will be dropped (clientside and hopefully serverside too).
			voipspeaking- whether they're speaking or not
			voiploudness- the player's average voip volume.
			also any other networked userinfo
		*/

		drawstring(pos-[8*5	,0], strpad(-4, ping), [8,8], [1,1,1],1,0);
		if (isspec)
			drawstring(pos+[4,0], "spec", [8,8], [1,1,1],1,0);
		else
		{
			drawfill(pos+[0,0], [40,4], top, 0.75, 0);
			drawfill(pos+[0,4], [40,4], bot, 0.75, 0);
			drawstring(pos+[8,0], strpad(-3, frags), [8,8], [1,1,1],1,0);
			if (player_localentnum == stof(getplayerkeyvalue(i, "viewentity")))
			{
//				drawcharacter(pos-[8,0], 0xe00d, [8,8], [1,1,1],1, 0);
				drawcharacter(pos+[ 0,0], 0xe010, [8,8], [1,1,1],1, 0);
				drawcharacter(pos+[32,0], 0xe011, [8,8], [1,1,1],1, 0);
			}
		}
		drawstring(pos+[64,0], name, [8,8], [1,1,1],1,0);
	}
};

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

			//drawpic(pos+len * '24 0 0', anumber[c-'0'], '20 24 0', '1 1 1', 1, 0);
						drawpic(pos+len * '20 0 0', anumber[c-'0'], '20 24 0', '1 1 1', 1, 0);
		}
	}
	else
	{	//use normal numbers

		while(len>0)
		{
			len--;
			c = str2chr(s, len);

			//drawpic(pos+len * '24 0 0', number[c-'0'], '20 24 0', '1 1 1', 1, 0);
						drawpic(pos+len * '20 0 0', number[c-'0'], '20 24 0', '1 1 1', 1, 0);
		}
	}
};

void(float type, vector pos, float drawback) Hud_DrawAmmoCount =
{
	string s;
	float value;
	float len;
	float c;
//	value = GetStat_FLOAT_TRUNCATED(type);
	value = getstati(type);
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

const float		STAT_FRAGLIMIT					= 235;

void(vector pos) Hud_DeathmatchScores_SBar =
{
	string s;
	float secs;
	float mins;
	
	//When you press tab in single player/coop, you get some replacement info over the sbar
	vector sbar = screensize_y * ' 0 1 0' - '0 24 0';

	Hud_DrawIBar(pos - '0 48 0'); //0 48 0
	
//	drawpic(sbar, "scorebar", '320 24 0', '1 1 1', 0.333, 0);

	s = strcat("Frags:", FormatFloat(getstati(STAT_FRAGS), 3, " "), "/", FormatFloat(getstatf(STAT_FRAGLIMIT), 3, " "));
	drawstring(sbar + '8 4', s, '8 8 0', '1 1 1', 1, 0);
	s = strcat("Secrets :", FormatFloat(getstati(STAT_SECRETS), 3, " "), "/", FormatFloat(getstati(STAT_TOTALSECRETS), 3, " "));
	drawstring(sbar + '8 12', s, '8 8 0', '1 1 1', 1, 0);

	mins = floor(time/60);
	secs = floor(time - mins*60);
	s = strcat("Time :", FormatFloat(mins, 3, " "), ":", FormatFloat(secs, 2, "0"));
	drawstring(sbar + '184 4', s, '8 8 0', '1 1 1', 1, 0);

	drawstring(sbar + '232 12' - strlen(mapname)*'4 0', mapname, '8 8 0', '1 1 1', 1, 0);
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
//	drawstring(sbar + '252 12' - strlen(g_strMapDisplayName)*'4 0', g_strMapDisplayName, '8 8 0', '1 1 1', 1, 0);
};

void Hud_DrawIntermission(vector pos)
{
	string s;
//	drawpic(pos, "sbar", '320 24 0', '1 1 1', 0.333, 0);

	//Hud_DrawIntermissionNumber(pos+'144 64 0', sprintf("%3.0f:%02.0f", intermission_time/60, intermission_time%60));
	//Hud_DrawLargeValue(pos+'144 64 0', getstati(STAT_HEALTH), 25);

	drawpic(pos+'224 0 0', "pics/a_shells", '24 24 0', '1 1 1', 1, 0);	
		drawpic(pos+[0,56], "gfx/inter.lmp", [160,144],[1,1,1],1,0);
	//Hud_DrawIntermissionNumber(pos+'144 104 0', sprintf("%3.0f/%.0f", getstatf(STAT_FOUNDSECRETS), getstatf(STAT_TOTALSECRETS)));
	Hud_DrawLargeValue(pos+'144 64 0', getstati(STAT_HEALTH), 25);
	
	//Hud_DrawIntermissionNumber(pos+'144 144 0', sprintf("%3.0f/%.0f", getstatf(STAT_KILLEDMONSTERS), getstatf(STAT_TOTALMONSTERS)));
	Hud_DrawLargeValue(pos+'144 64 0', getstati(STAT_HEALTH), 25);
	
	s = strcat("Monsters:", FormatFloat(getstati(STAT_MONSTERS), 3, " "), "/", FormatFloat(getstati(STAT_TOTALMONSTERS), 3, " "));
	drawstring(pos+'144 64 0', s, '8 8 0', '1 1 1', 1, 0);
	s = strcat("Secrets :", FormatFloat(getstati(STAT_SECRETS), 3, " "), "/", FormatFloat(getstati(STAT_TOTALSECRETS), 3, " "));
	drawstring(pos+'144 64 0', s, '8 8 0', '1 1 1', 1, 0);
	
	R_RenderScene();
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
	
	local float skinnum = getstati(STAT_PLAYERSKIN)

	if (getstati(STAT_PLAYERTYPE) == 0)
	{
	switch (skinnum)
		{
		case 0:
			drawpic(pos+'106 0 0', "players/male/grunt_i", '0 24 0', '1 1 1', 1, 0);
			break;
		case 1:
			drawpic(pos+'106 0 0', "players/male/cipher_i", '0 24 0', '1 1 1', 1, 0);
			break;
		case 2:
			drawpic(pos+'106 0 0', "players/male/claymore_i", '0 24 0', '1 1 1', 1, 0);
			break;
		case 3:
			drawpic(pos+'106 0 0', "players/male/flak_i", '0 24 0', '1 1 1', 1, 0);
			break;
		case 4:
			drawpic(pos+'106 0 0', "players/male/howitzer_i", '0 24 0', '1 1 1', 1, 0);
			break;
		case 5:
			drawpic(pos+'106 0 0', "players/male/major_i", '0 24 0', '1 1 1', 1, 0);
			break;
		case 6:
			drawpic(pos+'106 0 0', "players/male/nightops_i", '0 24 0', '1 1 1', 1, 0);
			break;
		case 7:
			drawpic(pos+'106 0 0', "players/male/pointman_i", '0 24 0', '1 1 1', 1, 0);
			break;
		case 8:
			drawpic(pos+'106 0 0', "players/male/psycho_i", '0 24 0', '1 1 1', 1, 0);
			break;
		case 9:
			drawpic(pos+'106 0 0', "players/male/rampage_i", '0 24 0', '1 1 1', 1, 0);
			break;
		case 10:
			drawpic(pos+'106 0 0', "players/male/razor_i", '0 24 0', '1 1 1', 1, 0);
			break;
		case 11:
			drawpic(pos+'106 0 0', "players/male/recon_i", '0 24 0', '1 1 1', 1, 0);
			break;
		case 12:
			drawpic(pos+'106 0 0', "players/male/scout_i", '0 24 0', '1 1 1', 1, 0);
			break;
		case 13:
			drawpic(pos+'106 0 0', "players/male/sniper_i", '0 24 0', '1 1 1', 1, 0);
			break;
		case 14:
			drawpic(pos+'106 0 0', "players/male/viper_i", '0 24 0', '1 1 1', 1, 0);
			break;			
		}
	}
	if (getstati(STAT_PLAYERTYPE) == 1)
	{
	switch (skinnum)
		{
		case 0:
			drawpic(pos+'106 0 0', "players/female/athena_i", '0 24 0', '1 1 1', 1, 0);
			break;
		case 1:
			drawpic(pos+'106 0 0', "players/female/brianna_i", '0 24 0', '1 1 1', 1, 0);
			break;
		case 2:
			drawpic(pos+'106 0 0', "players/female/cobalt_i", '0 24 0', '1 1 1', 1, 0);
			break;
		case 3:
			drawpic(pos+'106 0 0', "players/female/ensign_i", '0 24 0', '1 1 1', 1, 0);
			break;
		case 4:
			drawpic(pos+'106 0 0', "players/female/jezebel_i", '0 24 0', '1 1 1', 1, 0);
			break;
		case 5:
			drawpic(pos+'106 0 0', "players/female/jungle_i", '0 24 0', '1 1 1', 1, 0);
			break;
		case 6:
			drawpic(pos+'106 0 0', "players/female/lotus_i", '0 24 0', '1 1 1', 1, 0);
			break;
		case 7:
			drawpic(pos+'106 0 0', "players/female/stiletto_i", '0 24 0', '1 1 1', 1, 0);
			break;
		case 8:
			drawpic(pos+'106 0 0', "players/female/venus_i", '0 24 0', '1 1 1', 1, 0);
			break;
		case 9:
			drawpic(pos+'106 0 0', "players/female/voodoo_i", '0 24 0', '1 1 1', 1, 0);
			break;			
		}
	}
	if (getstati(STAT_PLAYERTYPE) == 2)
	{
	switch (skinnum)
		{
		case 0:
			drawpic(pos+'106 0 0', "players/cyborg/oni911_i", '0 24 0', '1 1 1', 1, 0);
			break;
		case 1:
			drawpic(pos+'106 0 0', "players/cyborg/ps9000_i", '0 24 0', '1 1 1', 1, 0);
			break;
		case 2:
			drawpic(pos+'106 0 0', "players/cyborg/tyr574_i", '0 24 0', '1 1 1', 1, 0);
			break;
		}
	}
	/*
	else
	{
		drawpic(pos+'112 0 0', "pics/i_health", '0 24 0', '1 1 1', 1, 0);
	}
	*/
	/*
	if (self.playerType == 0)
	{
	switch (self.skin)
		{
		case 0:
			drawpic(pos+'106 0 0', "players/male/grunt_i", '0 24 0', '1 1 1', 1, 0);
			break;
		case 1:
			drawpic(pos+'106 0 0', "players/male/cipher_i", '0 24 0', '1 1 1', 1, 0);
			break;
		case 2:
			drawpic(pos+'106 0 0', "players/male/claymore_i", '0 24 0', '1 1 1', 1, 0);
			break;
		case 3:
			drawpic(pos+'106 0 0', "players/male/flak_i", '0 24 0', '1 1 1', 1, 0);
			break;
		case 4:
			drawpic(pos+'106 0 0', "players/male/howitzer_i", '0 24 0', '1 1 1', 1, 0);
			break;
		case 5:
			drawpic(pos+'106 0 0', "players/male/major_i", '0 24 0', '1 1 1', 1, 0);
			break;
		case 6:
			drawpic(pos+'106 0 0', "players/male/nightops_i", '0 24 0', '1 1 1', 1, 0);
			break;
		case 7:
			drawpic(pos+'106 0 0', "players/male/pointman_i", '0 24 0', '1 1 1', 1, 0);
			break;
		case 8:
			drawpic(pos+'106 0 0', "players/male/psycho_i", '0 24 0', '1 1 1', 1, 0);
			break;
		case 9:
			drawpic(pos+'106 0 0', "players/male/rampage_i", '0 24 0', '1 1 1', 1, 0);
			break;
		case 10:
			drawpic(pos+'106 0 0', "players/male/razor_i", '0 24 0', '1 1 1', 1, 0);
			break;
		case 11:
			drawpic(pos+'106 0 0', "players/male/recon_i", '0 24 0', '1 1 1', 1, 0);
			break;
		case 12:
			drawpic(pos+'106 0 0', "players/male/scout_i", '0 24 0', '1 1 1', 1, 0);
			break;
		case 13:
			drawpic(pos+'106 0 0', "players/male/sniper_i", '0 24 0', '1 1 1', 1, 0);
			break;
		case 14:
			drawpic(pos+'106 0 0', "players/male/viper_i", '0 24 0', '1 1 1', 1, 0);
			break;			
		}
	}
	else if (self.playerType == 1)
	{
	switch (self.skin)
		{
		case 0:
			drawpic(pos+'106 0 0', "players/female/athena_i", '0 24 0', '1 1 1', 1, 0);
			break;
		case 1:
			drawpic(pos+'106 0 0', "players/female/brianna_i", '0 24 0', '1 1 1', 1, 0);
			break;
		case 2:
			drawpic(pos+'106 0 0', "players/female/cobalt_i", '0 24 0', '1 1 1', 1, 0);
			break;
		case 3:
			drawpic(pos+'106 0 0', "players/female/ensign_i", '0 24 0', '1 1 1', 1, 0);
			break;
		case 4:
			drawpic(pos+'106 0 0', "players/female/jezebel_i", '0 24 0', '1 1 1', 1, 0);
			break;
		case 5:
			drawpic(pos+'106 0 0', "players/female/jungle_i", '0 24 0', '1 1 1', 1, 0);
			break;
		case 6:
			drawpic(pos+'106 0 0', "players/female/lotus_i", '0 24 0', '1 1 1', 1, 0);
			break;
		case 7:
			drawpic(pos+'106 0 0', "players/female/stiletto_i", '0 24 0', '1 1 1', 1, 0);
			break;
		case 8:
			drawpic(pos+'106 0 0', "players/female/venus_i", '0 24 0', '1 1 1', 1, 0);
			break;
		case 9:
			drawpic(pos+'106 0 0', "players/female/voodoo_i", '0 24 0', '1 1 1', 1, 0);
			break;			
		}
	}
	else if (self.playerType == 2)
	{
	switch (self.skin)
		{
		case 0:
			drawpic(pos+'106 0 0', "players/cyborg/oni911_i", '0 24 0', '1 1 1', 1, 0);
			break;
		case 1:
			drawpic(pos+'106 0 0', "players/cyborg/ps9000_i", '0 24 0', '1 1 1', 1, 0);
			break;
		case 2:
			drawpic(pos+'106 0 0', "players/cyborg/tyr574_i", '0 24 0', '1 1 1', 1, 0);
			break;
		}
	}
	else
	{
		drawpic(pos+'112 0 0', "pics/i_health", '0 24 0', '1 1 1', 1, 0);
	}
	*/
	
	//drawpic(pos+'112 0 0', "pics/i_health", '0 24 0', '1 1 1', 1, 0);

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
//		case INV_PICKUP_JUMPBOOTS:
//			drawpic(pos+'0 -24 0', "pics/p_envirosuit", '24 24 0', '1 1 1', 1, 0);
//			Hud_DrawAmmoCount(STAT_ENVIRO, pos + '15 -8 0', true);			
//			break;			
	}

	if (stat_items & IT_DOUBLER)
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

float intermission_time;	/* when the intermission started */

nonstatic void Hud_Draw(float hudtype, float scoreboard, float width, float height)
{
	vector pos;
	screensize_x = width;
	screensize_y = height;
	screensize_z = 0;

	local float intermission_time = time;	//make a guess at the intermission time...

	pos_x = (screensize_x-320)/2;
	pos_y = screensize_y;

	stat_items = GetStat_BITS(STAT_ITEMS, 0, 23);
	stat_items2 = GetStat_BITS(STAT_ITEMS, 23, 9);

	//if hudtype == 0 then the engine already drew it.
	if (hudtype == 2)
	{
		if (intermission)
			return;

		if (scoreboard)
		{
			if (deathmatch){
			Hud_DeathmatchScores_SBar(pos - '0 0 0'); //0 24 0
			Hud_DeathmatchScoreboard(pos - '-120 175 0', '100 100 0');
			}
			
			if (coop){
			Hud_CoopScores_SBar(pos - '0 0 0'); //0 24 0
			Hud_CoopScoreboard(pos - '-120 175 0', '100 100 0');			
			}
		}
		else
		{
			Hud_DrawSBar(pos - '0 24 0');
		}
	}
	
	if (hudtype == 3)
	{
		if (intermission)	
			{
				string s;

				if (deathmatch)
				{
					Hud_DeathmatchScoreboard(pos - '-120 175 0', '100 100 0');
				}
				else
				{
				drawpic(pos+'75 -220 0', "gfx/complete", '192 24 0', '1 1 1', 1, 0);	
					
				s = strcat("Monsters:", FormatFloat(getstati(STAT_MONSTERS), 3, " "), "/", FormatFloat(getstati(STAT_TOTALMONSTERS), 3, " "));
				drawstring(pos+'25 -180 0', s, '16 16 0', '1 1 1', 1, 0);
				
				s = strcat("Secrets :", FormatFloat(getstati(STAT_SECRETS), 3, " "), "/", FormatFloat(getstati(STAT_TOTALSECRETS), 3, " "));
				drawstring(pos+'25 -160 0', s, '16 16 0', '1 1 1', 1, 0);
				}
			}
	}
};
