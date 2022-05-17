/*QUAKED trigger_setplayertype (.5 .5 .5) (-8 -8 -8) (8 8 8)
Sets the player's type (self.playerType) upon touch.
*/
void() trigger_setplayertype_touch =
{
	local string pt;
	
	if (other.classname != "player")
		return;
	
	if (self.message) // != string_null)
	{
		centerprint (other, self.owner.message);
		sound (other, CHAN_VOICE, "misc/talk.wav", 1, ATTN_NORM);
	}

	switch(self.playerType){
		case PT_MALE:
			pt = "male";
			break;
		case PT_FEMALE:
			pt = "female";
			break;
		case PT_OTHER:
			pt = "cyborg";
			break;
	}
		
	if (self.notify >= 1)
	{
		centerprint (other, strcat("Player type changed to ", pt, "\n"));
	}
	
	other.playerType = self.playerType;
	setPlayerModel(other);

	SUB_UseTargets ();
};

void() trigger_setplayertype = 
{
	self.classname = "trigger_setplayertype";	
	self.solid = SOLID_TRIGGER;
	self.movetype = MOVETYPE_NONE;
	setorigin (self, self.origin);	
	setmodel (self, self.model);
	
	if (!self.playerType)
		self.playerType = 0;
	
	self.touch = trigger_setplayertype_touch;
}
