#include "q2/q2_player.qh"

/*
void() W_SetDefaultFrames =
{
	switch (self.weapon)
	{
		case WEP_BLASTER:
			self.weaponframe=WEP_BLASTER_IDLE1_FIRSTFRAME;
			break;
		case WEP_SHOTGUN:
			self.weaponframe=19;
			break;
		case WEP_SUPERSHOTGUN:
			self.weaponframe=18;
			break;
		case WEP_MACHINEGUN:
			self.weaponframe=6;
			break;
		case WEP_CHAINGUN:
			if (self.weaponstate == WEAPON_SPINDOWN){
				return;
			}
			else{
			self.weaponframe=32;
			}
			break;
		case WEP_GRENADE_LAUNCHER:
			self.weaponframe=18;
			break;
		case WEP_ROCKET_LAUNCHER:
			self.weaponframe=13;
			break;
		case WEP_RAILGUN:
			self.weaponframe=19;
			break;
		case WEP_HYPERBLASTER:
			if (self.weaponstate == WEAPON_SPINDOWN){
				return;
			}
			else{
			self.weaponframe=22;
			}
			break;
		case WEP_BFG:
			self.weaponframe=32;
			break;
	}
}
*/

void() doQ2PlayerModelStandframes;

//THINK FUNCTION METHOD

/*
This was the first version of trying to get random view weapon idle fidget animations to work together with player animations.
It has been replaced with the Weapon_Generic implementation which will hopefully handle more than just idle stuff
and be more like Quake 2.

I just didn't have the heart to toss it out. :(

So this is more like a museum file if anything. 
Sometimes I come back here and just marvel at what the heck was I thinking!?

Have you ever stood and stared at it, marveled at it's beauty, it's genius? -Agent Smith
*/

void() q2Player_selectIdle;
void()	q2player_stand1 =[	$FRAME_stand01,	q2player_stand1	]
{
	doQ2PlayerModelStandframes();
	self.nextthink = time + 0.135;		
	self.idletime++;
//	self.weaponframe++;

	if (self.weapon == WEP_BLASTER)
	{
		if(self.weaponframe > WEP_BLASTER_IDLE1_FIRSTFRAME || self.weaponframe < WEP_BLASTER_IDLE1_FIRSTFRAME)
			self.weaponframe = WEP_BLASTER_IDLE1_FIRSTFRAME;
		
		if (self.idletime >= 40){
		//	self.weaponframe = WEP_BLASTER_ACTIVE_LASTFRAME;
			self.idletime = 0;
			self.think = q2Player_selectIdle;
		}
	}
	if (self.weapon == WEP_SHOTGUN)
	{
		if(self.weaponframe > 19)
			self.weaponframe = 19;
		
		if (self.idletime >= 40){
			self.weaponframe = 19;
			self.idletime = 0;
			self.think = q2Player_selectIdle;
		}
	}
	if (self.weapon == WEP_SUPERSHOTGUN)
	{
		if(self.weaponframe > 18)
			self.weaponframe = 18;
		
		if (self.idletime >= 40){
			self.weaponframe = 18;
			self.idletime = 0;
			self.think = q2Player_selectIdle;
		}
	}
	if (self.weapon == WEP_MACHINEGUN)
	{
		if(self.weaponframe > 6)
			self.weaponframe = 6;
		
		if (self.idletime >= 40){
			self.weaponframe = 6;
			self.idletime = 0;
			self.think = q2Player_selectIdle;
		}
	}
	if (self.weapon == WEP_CHAINGUN)
	{
		if(self.weaponframe > 32)
			self.weaponframe = 32;
		
		if (self.idletime >= 40){
			self.weaponframe = 32;
			self.idletime = 0;
			self.think = q2Player_selectIdle;
		}
	}
	if (self.weapon == WEP_GRENADE_LAUNCHER)
	{
		if(self.weaponframe > 18)
			self.weaponframe = 18;
		
		if (self.idletime >= 40){
			self.weaponframe = 18;
			self.idletime = 0;
			self.think = q2Player_selectIdle;
		}
	}
	if (self.weapon == WEP_ROCKET_LAUNCHER)
	{
		if(self.weaponframe > 13)
			self.weaponframe = 13;
		
		if (self.idletime >= 40){
			self.weaponframe = 13;
			self.idletime = 0;
			self.think = q2Player_selectIdle;
		}
	}
/*

A (poor) attempt to implement spin down stuff like in Quake 1.5.

	if (self.weapon == WEP_HYPERBLASTER && self.spindown == 1)
	{
			self.spintimer++;
			self.weaponframe++;
			bprint (ftos(self.spintimer));
			bprint ("\n");
			
			if(self.weaponframe <= 12)
				self.weaponframe = 12;
			
			if(self.weaponframe >= 21)
				self.weaponframe = 22;
		
			if(self.spintimer >= 8)
			{
				sound(self, CHAN_WEAPON, "weapons/Shotgr1b.wav", 0.5, ATTN_IDLE);
				self.spintimer = 0;
				self.spindown = 0;
			//	return;
			}
	}
	else
	{
		if(self.weaponframe > 22)
		self.weaponframe = 22;
		
		if (self.idletime >= 40)
		{
			self.weaponframe = 22;
			self.idletime = 0;
			self.think = q2Player_selectIdle;
		}
	}
*/
	
	if (self.weapon == WEP_HYPERBLASTER)
	{
		if(self.weaponframe > 22)
			self.weaponframe = 22;
		
		if (self.idletime >= 40){
			self.weaponframe = 22;
			self.idletime = 0;
			self.think = q2Player_selectIdle;
		}
	}

};

void()	q2Player_stand1_fidgetA =[	$FRAME_stand01,	q2Player_stand1_fidgetA	]
{
	doQ2PlayerModelStandframes();
	self.nextthink = time + 0.135;
	self.weaponframe++;	
	if (self.weapon == WEP_BLASTER)
	{
		if (self.weaponframe <= WEP_BLASTER_IDLE1_FIRSTFRAME)
			self.weaponframe = WEP_BLASTER_IDLE1_FIRSTFRAME;
		
		if(self.weaponframe >= WEP_BLASTER_IDLE1_LASTFRAME){
			self.weaponframe = WEP_BLASTER_IDLE1_FIRSTFRAME;
			self.think = q2Player_selectIdle;
		}
	}
	
	if (self.weapon == WEP_SHOTGUN)
	{
	
		if (self.weaponframe < 19)
			self.weaponframe = 19;
		
		if(self.weaponframe >= 36){
			self.weaponframe = 19;
			self.think = q2Player_selectIdle;
		}
	}
	
	if (self.weapon == WEP_SUPERSHOTGUN)
	{
	
		if (self.weaponframe < 18)
			self.weaponframe = 18;
		
		if(self.weaponframe >= 57){
			self.weaponframe = 18;
			self.think = q2Player_selectIdle;
		}
	}
	
	if (self.weapon == WEP_MACHINEGUN)
	{
	
		if (self.weaponframe < 6)
			self.weaponframe = 6;
		
		if(self.weaponframe >= 45){
			self.weaponframe = 6;
			self.think = q2Player_selectIdle;
		}
	}
	
	if (self.weapon == WEP_CHAINGUN)
	{
	
		if (self.weaponframe < 32)
			self.weaponframe = 32;
		
		if(self.weaponframe >= 61){
			self.weaponframe = 32;
			self.think = q2Player_selectIdle;
		}
	}
	
	if (self.weapon == WEP_GRENADE_LAUNCHER)
	{
	
		if (self.weaponframe < 18)
			self.weaponframe = 18;
		
		if(self.weaponframe >= 60){
			self.weaponframe = 18;
			self.think = q2Player_selectIdle;
		}
	}
	
	if (self.weapon == WEP_ROCKET_LAUNCHER)
	{
	
		if (self.weaponframe < 13)
			self.weaponframe = 13;
		
		if(self.weaponframe >= 50){
			self.weaponframe = 13;
			self.think = q2Player_selectIdle;
		}
	}
	
	if (self.weapon == WEP_HYPERBLASTER)
	{
	
		if (self.weaponframe < 22)
			self.weaponframe = 22;
		
		if(self.weaponframe >= 49){
			self.weaponframe = 22;
			self.think = q2Player_selectIdle;
		}
	}
};

void()	q2Player_stand1_fidgetB =[	$FRAME_stand01,	q2Player_stand1_fidgetB	]
{
	doQ2PlayerModelStandframes();
	self.nextthink = time + 0.135;
	self.weaponframe++;
	// skip weapons that only have 1 idle
	
	switch(self.weapon)
	{
		case WEP_SHOTGUN:
			self.weaponframe = 19;
			self.think = q2Player_selectIdle;
			break;
		
		case WEP_SUPERSHOTGUN:
			self.weaponframe = 18;
			self.think = q2Player_selectIdle;
			break;
		
		case WEP_MACHINEGUN:
			self.weaponframe = 6;
			self.think = q2Player_selectIdle;
			break;

		case WEP_CHAINGUN:
			self.weaponframe = 32;
			self.think = q2Player_selectIdle;
			break;
			
		case WEP_GRENADE_LAUNCHER:
			self.weaponframe = 18;
			self.think = q2Player_selectIdle;
			break;
		
		case WEP_ROCKET_LAUNCHER:
			self.weaponframe = 13;
			self.think = q2Player_selectIdle;
			break;
		
		case WEP_HYPERBLASTER:
			self.weaponframe = 22;
			self.think = q2Player_selectIdle;
			break;
	}
	
	if (self.weapon == WEP_BLASTER)
	{
		if (self.weaponframe <= WEP_BLASTER_IDLE2_FIRSTFRAME)
			self.weaponframe = WEP_BLASTER_IDLE2_FIRSTFRAME;
		
		if(self.weaponframe >= WEP_BLASTER_IDLE2_LASTFRAME){
			self.weaponframe = WEP_BLASTER_IDLE2_FIRSTFRAME;
			self.think = q2Player_selectIdle;
		}
	}
};


void()	q2Player_selectIdle =
{
	local float r = random();

	if (r < 0.2){
		q2Player_stand1_fidgetA ();
	}
	else if (r < 0.4){
		q2Player_stand1_fidgetB ();
	}
	else{
		q2player_stand1 ();
	}
};