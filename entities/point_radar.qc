//3D Radar by VENOMUS

// VENOMUS START
void () radar_think =
{
	local entity head;

	head = nextent (world);
	while (head != world)
	{
	//	if (head.health > 0)
	//	{
			if (head.classname == "train")
			{
				local vector bliporg;

				bliporg = '0 0 0';
				bliporg_x = (head.origin_x / self.punchangle_x) + self.origin_x;
				bliporg_y = (head.origin_y / self.punchangle_y) + self.origin_y;
				bliporg_z = (head.origin_z / self.punchangle_z) + self.origin_z;

				local entity blip;

				blip = spawn ();
				setorigin (blip, bliporg);
				setmodel (blip, "progs/s_bubble.spr");
				blip.think = SUB_Remove;
				blip.nextthink = time + self.cnt;
			}
		//}

		head = nextent (head);
	}

	self.think = radar_think;
	self.nextthink = time + self.cnt;
};

/*QUAKED point_radar (1 0.5 0) (-100 -100 -100) (100 100 100)*/

void () point_radar =
{
	if (!self.model)
		setsize (self, '-100 -100 -100', '100 100 100');
	else
	{
		setmodel (self, self.model);

		local vector org;

		org = '0 0 0';
		org_x = (self.maxs_x + self.mins_x) / 2;
		org_y = (self.maxs_y + self.mins_y) / 2;
		org_z = (self.maxs_z + self.mins_z) / 2;
		setorigin (self, org);
	}

	if (!self.cnt)
		self.cnt = 0.5;

	self.punchangle = '0 0 0';
	self.punchangle_x = 8192 / self.size_x;
	self.punchangle_y = 8192 / self.size_y;
	self.punchangle_z = 8192 / self.size_z;

	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_NONE;

	self.think = radar_think;
	self.nextthink = time + self.cnt;
};
// VENOMUS END 
