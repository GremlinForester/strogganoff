void() target_gibshooter_use =
{
	local float n;

	if (self.noise)
		sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);

	if (self.dmg){
		T_RadiusDamage (self, self.owner, self.dmg, other); //BOOM! Get out the way!
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_EXPLOSION);
		WriteCoord (MSG_BROADCAST, self.origin_x);
		WriteCoord (MSG_BROADCAST, self.origin_y);
		WriteCoord (MSG_BROADCAST, self.origin_z);
	}

	switch(self.material)
	{
		case 1:
		for (n= 0; n < 2; n++)
			ThrowGib ("models/objects/debris1/tris.md2", self.speed, GIB_NONE, 1, self.speed);
		for (n= 0; n < 4; n++)
			ThrowGib ("models/objects/debris2/tris.md2", self.speed, GIB_NONE, 1, self.speed);
		for (n= 0; n < 3; n++)
			ThrowGib ("models/objects/debris3/tris.md2", self.speed, GIB_NONE, 1, self.speed);
		break;
		
		case 2:
		for (n= 0; n < 2; n++)
			ThrowGib ("models/objects/gibs/bone/tris.md2", self.speed, GIB_FLESH, 1, self.speed);
		for (n= 0; n < 4; n++)
			ThrowGib ("models/objects/gibs/sm_meat/tris.md2", self.speed, GIB_FLESH, 1, self.speed);
		for (n= 0; n < 3; n++)
			ThrowGib ("models/objects/gibs/bone2/tris.md2", self.speed, GIB_FLESH, 1, self.speed);
		break;
		
		case 3:
		for (n= 0; n < 2; n++)
			ThrowGib ("models/objects/debris1/tris.md2", self.speed, GIB_METAL, 1, self.speed);
		for (n= 0; n < 4; n++)
			ThrowGib ("models/objects/debris2/tris.md2", self.speed, GIB_METAL, 1, self.speed);
		for (n= 0; n < 3; n++)
			ThrowGib ("models/objects/debris3/tris.md2", self.speed, GIB_METAL, 1, self.speed);
		break;
		
		case 4:
		for (n= 0; n < 2; n++)
			ThrowGib ("models/objects/debris1/tris.md2", self.speed, GIB_FLAMING, 1, self.speed);
		for (n= 0; n < 4; n++)
			ThrowGib ("models/objects/debris2/tris.md2", self.speed, GIB_FLAMING, 1, self.speed);
		for (n= 0; n < 3; n++)
			ThrowGib ("models/objects/debris3/tris.md2", self.speed, GIB_FLAMING, 1, self.speed);		
		break;
		
		case 5:
		for (n= 0; n < 2; n++)
			ThrowGib ("models/objects/debris1/tris.md2", self.speed, GIB_GLASS, 1, self.speed);
		for (n= 0; n < 4; n++)
			ThrowGib ("models/objects/debris2/tris.md2", self.speed, GIB_GLASS, 1, self.speed);
		for (n= 0; n < 3; n++)
			ThrowGib ("models/objects/debris3/tris.md2", self.speed, GIB_GLASS, 1, self.speed);
		break;
		
		case 6:

		for (n= 0; n < 2; n++)
			ThrowGib ("models/objects/debris1/tris.md2", self.speed, GIB_WOOD, 1, self.speed);
		for (n= 0; n < 4; n++)
			ThrowGib ("models/objects/debris2/tris.md2", self.speed, GIB_WOOD, 1, self.speed);
		for (n= 0; n < 3; n++)
			ThrowGib ("models/objects/debris3/tris.md2", self.speed, GIB_WOOD, 1, self.speed);
		break;
		
		case 7:
		for (n= 0; n < 2; n++)
			ThrowGib ("models/objects/debris1/tris.md2", self.speed, GIB_STONE, 1, self.speed);
		for (n= 0; n < 4; n++)
			ThrowGib ("models/objects/debris2/tris.md2", self.speed, GIB_STONE, 1, self.speed);
		for (n= 0; n < 3; n++)
			ThrowGib ("models/objects/debris3/tris.md2", self.speed, GIB_STONE, 1, self.speed);
		break;		
	}
}

void() target_gibshooter =
{
/*
1: Normal Gibs
2: Flesh
3: Metal
4: Flaming
5: Glass
6: Wood
7: Stone	

speed: velocity of gibs

*/
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_NOCLIP;
	setorigin (self, self.origin);
	setmodel (self, "");

	makevectors(self.angles);
	SetMovedir ();
	
	if (!self.speed)
		self.speed = 10;
	
	self.use = target_gibshooter_use;
}

