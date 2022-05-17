.string item;
.float notify;

/*QUAKED trigger_key (.5 .5 .5) (-8 -8 -8) (8 8 8)
A relay trigger that only fires it's targets if player has the proper key.
Use "item" to specify the required key, for example "key_data_cd"

Quake2 handles keys in a weird way, this trigger will have to check if the activator has
the right item by checking something like inv_item_keys before it triggers whatever its target is.
This will work like doors with keys set via spawnflags.

*/
void() trigger_key_touch =
{
	local string keyname;
	
	if (other.classname != "player")
		return;
	
	if (self.message) // != string_null)
	{
		centerprint (other, self.owner.message);
		sound (other, CHAN_VOICE, "misc/talk.wav", 1, ATTN_NORM);
	}
	
	if (!self.items_q2keys)
		return;


	switch(self.items_q2keys){
		case IT_KEY_DATACD:
			keyname = "Data CD";
			break;
		case IT_KEY_POWERCUBE:
			keyname = "Power Cube";
			break;
		case IT_KEY_PYRAMID:
			keyname = "Pyramid Key";
			break;
		case IT_KEY_DATASPINNER:
			keyname = "Data Spinner";
			break;			
		case IT_KEY_PASS:
			keyname = "Security Pass";
			break;
		case IT_KEY_BLUE:
			keyname = "Blue Key";
			break;
		case IT_KEY_RED:
			keyname = "Red Key";
			break;
		case IT_KEY_HEAD:
			keyname = "Head Key";
			break;
	}
	
	if ( (self.items_q2keys & other.items_q2keys) != self.items_q2keys )
	{
		/*
		if (self.items == IT_KEY_DATACD)
		{
				centerprint (other, "You need the data CD");
				sound (self, CHAN_VOICE, self.noise3, 1, ATTN_NORM);
		}
		else if (self.items == IT_KEY_POWERCUBE)
		{
				centerprint (other, "You need a power cube");
				sound (self, CHAN_VOICE, self.noise3, 1, ATTN_NORM);
		}
		else if (self.items == IT_KEY_PYRAMID)
		{
				centerprint (other, "You need the pyramid key");
				sound (self, CHAN_VOICE, self.noise3, 1, ATTN_NORM);
		}
		else if (self.owner.items == IT_KEY_DATASPINNER)
		{
				centerprint (other, "You need the data spinner");
				sound (self, CHAN_VOICE, self.noise3, 1, ATTN_NORM);
		}
		else if (self.items == IT_KEY_PASS)
		{
				centerprint (other, "You need the security pass");
				sound (self, CHAN_VOICE, self.noise3, 1, ATTN_NORM);
		}
		else if (self.items == IT_KEY_BLUE)
		{
				centerprint (other, "You need the blue keycard");
				sound (self, CHAN_VOICE, self.noise3, 1, ATTN_NORM);
		}
		else if (self.items == IT_KEY_RED)
		{
				centerprint (other, "You need the red keycard");
				sound (self, CHAN_VOICE, self.noise3, 1, ATTN_NORM);
		}
		else if (self.items == IT_KEY_HEAD)
		{
				centerprint (other, "You need to get a head");
				sound (self, CHAN_VOICE, self.noise3, 1, ATTN_NORM);
		}
		*/
		return;
	}
	
	if (self.spawnflags & REMOVE_KEY){
			if (self.notify >= 1){
			centerprint (other, strcat("Access granted: ", keyname, " removed"));
			}
		other.items_q2keys = other.items_q2keys - self.items_q2keys;
		SUB_UseTargets ();
		return;
	}
	self.touch = SUB_Null;
	SUB_UseTargets ();
};

void() trigger_key = 
{
	self.solid = SOLID_TRIGGER;
	self.movetype = MOVETYPE_NONE;
	setorigin (self, self.origin);	
	setmodel (self, self.model);
	self.classname = "trigger_key";

	if (self.spawnflags & DOOR_KEY_DATA_CD)
		self.items_q2keys = IT_KEY_DATACD;
	
	if (self.spawnflags & DOOR_KEY_POWER_CUBE)
		self.items_q2keys = IT_KEY_POWERCUBE;
	
	if (self.spawnflags & DOOR_KEY_PYRAMID)
		self.items_q2keys = IT_KEY_PYRAMID;
	
	if (self.spawnflags & DOOR_KEY_DATA_SPINNER)
		self.items_q2keys = IT_KEY_DATASPINNER;
	
	if (self.spawnflags & DOOR_KEY_PASS)
		self.items_q2keys = IT_KEY_PASS;
	
	if (self.spawnflags & DOOR_KEY_BLUE_KEY)
		self.items_q2keys = IT_KEY_BLUE;
	
	if (self.spawnflags & DOOR_KEY_RED_KEY)
		self.items_q2keys = IT_KEY_RED;
	
	if (self.spawnflags & DOOR_KEY_COMMANDER_HEAD)
		self.items_q2keys = IT_KEY_HEAD;
		
	self.touch = trigger_key_touch;
}
