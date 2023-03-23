/*
Based on the battleMETAL menu and metal-lib library by Peter Roohr 
and adapted for Q2DP by MrC (so if it's broke you know who to blame).
Overview: utility functions for menu
*/

void() menu_write_new_save = 
{
  local float flannel;
  local string file, savefile;
  //file = strcat(PATH_DATA_SAVE, "/", SAVE_FILE_NAME, ftos(cvar("saveslot")), SAVEINFO_FILE_EXT);
  file = strcat(PATH_DATA_SAVE, "/", SAVE_FILE_NAME, ftos(self.data_bind), SAVEINFO_FILE_EXT);
  savefile = strcat(PATH_DATA_SAVE, "/", SAVE_FILE_NAME, ftos(self.data_bind));
  flannel = fopen(file, FILE_WRITE);
    fputs(flannel, "{\n");
    fputs(flannel, strcat("  'save' : ", cvar_string("saveslot"), ",\n"));
    fputs(flannel, strcat("  'mission' : ", CAMP_SELECT_START, ",\n"));
    fputs(flannel, strcat("  'points' : ", ftos(1), ",\n"));
    fputs(flannel, strcat("  'skill' : ", ftos(cvar("skill")), ",\n"));
    fputs(flannel, strcat("  'campaign' : ", CAMP_SELECT_NAME, ",\n"));
    fputs(flannel, strcat("  'image' : ", CAMP_SELECT_IMAGE, ",\n"));	
	fputs(flannel, strcat("  'savefile' : ", savefile, ",\n"));
    fputs(flannel, strcat("  'newgame+' : ", ftos(cvar("cl_newgameplus")), ",\n"));
    fputs(flannel, "}");
  fclose(flannel);
  
	local string slotname = strcat("data/saves/save_", ftos(self.data_bind), ".sav");

	localcmd(sprintf("echo save info to %s\n", file));
	localcmd(sprintf("echo saving to %s\n", slotname));
	localcmd(sprintf("save %s;\n", slotname));
	localcmd(sprintf("wait;screenshot %s.png\n", slotname));
};