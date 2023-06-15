/*QUAKED info_notnull (0 0.5 0) (-4 -4 -4) (4 4 4)
Used as a positional target for lightning.
*/
void() info_notnull =
{
};

void() target_position =
{
	self.movetype = MOVETYPE_NONE;
	setorigin (self, self.origin);
	setsize (self, '-8 -8 -8', '8 8 8');
};
