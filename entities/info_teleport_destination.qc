/*QUAKED info_teleport_destination (.5 .5 .5) (-8 -8 -8) (8 8 32)
This is the destination marker for a teleporter.  It should have a "targetname" field with the same value as a teleporter's "target" field.
*/
void() info_teleport_destination =
{
// this does nothing, just serves as a target spot
	self.mangle = self.angles;
	self.angles = '0 0 0';
	self.model = string_null;
	self.origin = self.origin + '0 0 27';
	if (!self.targetname)
#ifdef noobjerr
	{

#ifdef xvars1
		if (cvar("svx_platdoorfail") < 0) // remove option - info_teleport_destination
		{
			remove(self);
			return;
		}
#endif
// later - set a random targetname from some ?
// for now do nothing
	}
#else
		objerror ("no targetname");					//opgrade protected
#endif
}; 
