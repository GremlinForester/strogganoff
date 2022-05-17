/*QUAKED trigger_stripkeys (.5 .5 .5) ?
Strips the player of all keys and then removes itself.
*/
void() trigger_stripkeys_touch =
{
	if (other.classname != "player")
		return;
	
	stripKeys(other); //other
	
//	remove(self); //TODO: Add spawnflag to remove or not, maybe a delay to go non-solid?
};

void() trigger_stripkeys =
{
	InitTrigger ();
	self.touch = trigger_stripkeys_touch;
};
