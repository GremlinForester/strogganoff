void() splashzone_on =
{
	self.solid = SOLID_TRIGGER;
	self.nextthink = -1;
};

.float splashtype;

void() splashzone_touch =
{
	if (other.classname != "player"){
	return;
	}
	else{
	self.solid = SOLID_NOT;
	
	if (self.splashtype == 0){
		SetVModelOverlayOther('0 0 0', "models/overlay.md3", OVERLAY_RAIN, self.colormod, 1);
	}
	
	if (self.splashtype == 1){
		if (random() < 0.3){
		SetVModelOverlayOther('0 0 0', "models/overlay.md3", OVERLAY_BLOODSPLAT1, '1 0 0', 0);
		}
		else if (random() < 0.5){
		SetVModelOverlayOther('0 0 0', "models/overlay.md3", OVERLAY_BLOODSPLAT2, '1 0 0', 0);
		}
		else if (random() < 0.8){
		SetVModelOverlayOther('0 0 0', "models/overlay.md3", OVERLAY_BLOODSPLAT3, '1 0 0', 0);
		}
		else{
		SetVModelOverlayOther('0 0 0', "models/overlay.md3", OVERLAY_BLOODSPLAT4, '1 0 0', 0);
		}
	}
	
	self.think = splashzone_on;
	self.nextthink = time + 1;
	}
	return;
};

/*QUAKED trigger_splashzone (.5 .5 .5) ?
Just a simple trigger that cuases a water dripping lens effect. Can be expanded to indicate whether to put out objects that are on fire.
*/

void() trigger_splashzone =
{
	InitTrigger ();
	self.touch = splashzone_touch;
	if (!self.splashtype)
		self.splashtype = 0;
	self.splashtype = self.splashtype;
	
	if (!self.colormod)
		self.colormod = '1 1 1';
};
