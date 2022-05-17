/*QUAKED func_illusionary (0 .5 .8) ?
A simple entity that looks solid but lets you walk through it.
*/
void() func_illusionary =

{
#ifdef opgrade 
// this op leaves func_wall_use possibly active for func_illusionary
	func_wall();
#else
	self.angles = '0 0 0';
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	setmodel (self, self.model);
#endif 

// interesting - makestatic makes SOLID_BSP map brush objects like func_wall non solid !
//							  unless some engine mod treats this differently - most opgrades were only tested in darkplaces
	makestatic ( 
#ifdef codefix 
					 self 
#endif 
						  );
};  
