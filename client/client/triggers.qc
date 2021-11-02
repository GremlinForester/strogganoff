/*
void() splashzone_on =
{
	self.solid = SOLID_TRIGGER;
	self.nextthink = -1;
};

void() splashzone_touch =
{
	if (other.classname != "player"){
	return;
	}
	else{
	self.solid = SOLID_NOT;
	SetVModelOverlayOther('0 0 0', "models/overlay.md3", OVERLAY_BLOODSPLAT1, '1 0 0'); //0 ripple 1 rain
	self.think = splashzone_on;
	self.nextthink = time + 2;
	}
	return;
};
*/
/*QUAKED trigger_splashzone (.5 .5 .5) ?
Just a simple trigger that cuases a water dripping lens effect. Can be expanded to indicate whether to put out objects that are on fire.
*/
/*
void() trigger_splashzone =
{
	InitTrigger ();
	self.touch = splashzone_touch;
};
*/