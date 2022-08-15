void() trigger_reset =
{
	self.solid = SOLID_TRIGGER;	// allow it to be touched again
	self.nextthink = time + 2;
	self.think = trigger_reset;	
}

void() trigger_skill_touch =
{
	local float selectedSkill;
	
	if (other.classname != "player")
		return;
	
	self.solid = SOLID_NOT;	

	cvar_set ("skill", self.message);
		
	selectedSkill = cvar("skill");
	
	if (selectedSkill == 0){
		stuffcmd(other, "exec cfg/skill0.cfg");
		return;
	}
	
	if (selectedSkill == 1){
		stuffcmd(other, "exec cfg/skill1.cfg");
		return;
	}		

	if (selectedSkill == 2){
		stuffcmd(other, "exec cfg/skill2.cfg");
		return;
	}		

	if (selectedSkill == 3){
		stuffcmd(other, "exec cfg/skill3.cfg");
	}
};

/*QUAKED trigger_setskill (.5 .5 .5) ?
sets skill level to the value of "message".
Only used on start map.
*/
void() trigger_setskill =
{
	InitTrigger ();
	self.touch = trigger_skill_touch;
	self.think = trigger_reset;
	self.nextthink = time;	
};
