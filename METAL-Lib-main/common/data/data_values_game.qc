/*
Based on the battleMETAL menu and metal-lib library by Peter Roohr 
and adapted for Q2DP by MrC (so if it's broke you know who to blame).
Overview: 
  all the miscellaneous shared values between client and server.
*/

//============================
//   FILE PATHS           
//============================
#define PATH_DATA_SAVE "saves"

//globals
#define SAVE_FILE_NAME "save_" //bake this in cause the name shouldnt change
#define SAVE_FILE_EXT ".sav"
#define SAVEINFO_FILE_EXT ".savinfo"

//============================
//   GAME MODES
//============================
#define GAMEMODE_CAMPAIGN 1
#define GAMEMODE_COOP 2
#define GAMEMODE_DM 3
#define GAMEMODE_TEAMDM 4
