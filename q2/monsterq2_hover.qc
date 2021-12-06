/*
==============================================================================

QUAKE II STROGG HOVER

monster_hover

==============================================================================
*/
// [0-9]{1,} - strips out frame num
#include "monsterq2_hover.qh"

#define HOVER_SOUND_ATTACK1 "hover/HOVATCK1.WAV"
#define HOVER_SOUND_DETH1		"hover/HOVDETH1.WAV"
#define HOVER_SOUND_DETH2		"hover/HOVDETH2.WAV"
#define HOVER_SOUND_IDLE1		"hover/HOVIDLE1.WAV"
#define HOVER_SOUND_PAIN1		"hover/HOVPAIN1.WAV"
#define HOVER_SOUND_PAIN2		"hover/HOVPAIN2.WAV"
#define HOVER_SOUND_SIGHT1	"hover/HOVSGHT1.WAV"
#define HOVER_SOUND_SRCH1		"hover/HOVSRCH1.WAV"
#define HOVER_SOUND_SRCH2		"hover/HOVSRCH2.WAV"

void() hover_sight={
	sound (self, CHAN_VOICE, HOVER_SOUND_SIGHT1, 1, ATTN_NORM);
};

void() hover_search={
	if(random() < 0.6)
		sound (self, CHAN_VOICE, HOVER_SOUND_SRCH1, 1, ATTN_NORM);
	else
		sound (self, CHAN_VOICE, HOVER_SOUND_SRCH2, 1, ATTN_NORM);
};

void() hover_run;
void() hover_stand;
void() hover_dead;
void() hover_attack;
void() hover_reattack;
void() hover_fire_blaster;
void() hover_die;

//STAND1
framerloop($FRAME_stand01, $FRAME_stand30, hover_move_stand, 0.1, ai_stand(););

//STOP1
framer($FRAME_stop101, $FRAME_stop109, hover_move_stop, SUB_Null, 0.1, ai_charge(0););

//STOP2
framer($FRAME_stop201, $FRAME_stop208, hover_move_stop2_, SUB_Null, 0.1, ai_charge(0););

//TAKEOFF
framer($FRAME_takeof01, $FRAME_takeof30, hover_move_takeoff, SUB_Null, 0.1, ai_charge(0););

//PAIN3
framer($FRAME_pain301, $FRAME_pain309, hover_move_pain3_, hover_run, 0.1, ai_charge(0););

//PAIN2
framer($FRAME_pain201, $FRAME_pain212, hover_move_pain2_, hover_run, 0.1, ai_charge(0););

//PAIN1
framer($FRAME_pain101, $FRAME_pain128, hover_move_pain1, hover_run, 0.1, ai_charge(0);
	//todo - frame values
	ai_rep($FRAME_pain101, ai_charge, 0, 0, 2, -8, -4, -6, -4, -3);
	ai_rep($FRAME_pain109, ai_charge, 1, 0, 0, 0, 3, 1, 0, 0);
	ai_rep($FRAME_pain117, ai_charge, 2, 3, 2, 7, 1, 0, 0, 2);
	ai_rep($FRAME_pain125, ai_charge, 0, 0, 5, 3, 4, -6, -6, -6);
	
);

//LAND
framer($FRAME_land01, $FRAME_land01, hover_move_land, SUB_Null, 0.1, SUB_Null(););

//FORWARD
framer($FRAME_forwrd01, $FRAME_forwrd35, hover_move_forward, SUB_Null, 0.1, ai_charge(0););

//WALK
framer($FRAME_forwrd01, $FRAME_forwrd35, hover_move_walk, SUB_Null, 0.1, ai_walk(4););

//RUN
framerloop($FRAME_forwrd01, $FRAME_forwrd35, hover_move_run, 0.1, ai_run(10););

//DEATH
framer($FRAME_death101, $FRAME_death111, hover_move_death, hover_dead, 0.1,
	ai_rep($FRAME_death101, ai_charge, 0,0,0,0,0,0,-10,3);
	ai_rep($FRAME_death109, ai_charge, 5,4,7,-6,-6,-6,-6,-6);
);

//BACKWARD
framer($FRAME_backwd01, $FRAME_backwd24, hover_move_backward, SUB_Null, 0.1, ai_charge(0););

//START ATTACK
framer($FRAME_attak104, $FRAME_attak106, hover_move_start_attack, hover_attack, 0.1,
	ai_charge(1);
);

//ATTACK1
framer($FRAME_attak104, $FRAME_attak106, hover_move_attack, hover_reattack, 0.1, 
	frame_arb($FRAME_attak104, ai_charge(-10);hover_fire_blaster(););
	frame_arb($FRAME_attak105, ai_charge(-10);hover_fire_blaster(););
	frame_arb($FRAME_attak106, ai_charge(0););
);

//END ATTACK
framer($FRAME_attak107, $FRAME_attak108, hover_move_end_attack, hover_run, 0.1, ai_charge(1););

void() hover_reattack={
	if(self.enemy.health > 0)
		if(visible(self.enemy))
			if(random() <= 0.6){
				hover_move_attack();
				return;
			}
	hover_move_end_attack();
};

void() hover_fire_blaster={
	local vector org;
	local vector end;
	local vector dir;
	
	makevectors(self.angles);
	
	org = self.origin + (v_forward * 32.5) + (v_right * -0.8) + (v_up * 10.0);
	
	end = self.enemy.origin;
	end_z = end_z + self.enemy.view_ofs_z;
	
	dir = normalize(end - org);
	sound (self, CHAN_AUTO, HOVER_SOUND_ATTACK1, 1, ATTN_NORM);
	monster_fire_blaster(org, dir, 1, '0.1 2 0.1', MF_TRACER);
};

void() hover_stand={
	hover_move_stand();
};

void() hover_run={
	hover_move_run();
};

void() hover_walk={
	hover_move_walk();
};

void() hover_start_attack={
	hover_move_start_attack();
};

void() hover_attack={
	hover_move_attack();
};

void(entity attacker, float damage) hover_pain={
	if(self.health < self.max_health / 2)
		self.skin = 1;
	
	if(time < self.pain_finished)
		return;
	
	self.pain_finished = time + 3;
	
	if(skill == 3)
		return;
	
	if(damage <= 25){
		if(random() < 0.5){
			sound (self, CHAN_VOICE, HOVER_SOUND_PAIN1, 1, ATTN_NORM);
			hover_move_pain3_();
		}
		else{
			sound (self, CHAN_VOICE, HOVER_SOUND_PAIN2, 1, ATTN_NORM);
			hover_move_pain2_();
		}
	}
	else{
		sound (self, CHAN_VOICE, HOVER_SOUND_PAIN2, 1, ATTN_NORM);
		hover_move_pain1();
	}
};

void() hover_deadthink={
	if(!(self.flags & FL_ONGROUND) && time < self.nextthink){
		self.nextthink = time + frametime;
		return;
	}
	gibMonster();
};

void() hover_dead={
	setsize(self, '-16 -16 -24', '16 16 -8');
	setorigin(self, self.origin);
	
	self.movetype = MOVETYPE_TOSS;
	self.think = hover_deadthink;
	self.nextthink = time + 1;
};

void() hover_die={
	float n;
	
	if(self.health <= -40){
		gibMonster();
		remove(self);
		return;
	}
	
	if(self.deadflag == DEAD_DEAD)
		return;
	
	if(random() < 0.5)
		sound (self, CHAN_VOICE, HOVER_SOUND_DETH1, 1, ATTN_NORM);
	else
		sound (self, CHAN_VOICE, HOVER_SOUND_DETH2, 1, ATTN_NORM);
	
	self.deadflag = DEAD_DEAD;
	self.takedamage = DAMAGE_YES;
	hover_move_death();
};

void() q2hoverSound_think =
{
	if (self.owner.health <= 0)
	{
		remove(self);
		return;
	}

	self.origin = self.owner.origin;
	sound (self, CHAN_BODY, "hover/hovidle1.wav", 1, ATTN_IDLE);
	self.think = q2hoverSound_think;
	self.nextthink = time + soundlength("hover/hovidle1.wav");
}

void(entity ent) attachq2hoverSound =
{
	local entity q2hoverSound;
	
	q2hoverSound = spawn();
	setorigin (q2hoverSound, ent.owner.origin);
	q2hoverSound.owner = ent;
	q2hoverSound.netname = "q2hoverSound";
	setmodel (q2hoverSound, "");
	q2hoverSound.solid = SOLID_NOT;
	q2hoverSound.movetype = MOVETYPE_NOCLIP;
	q2hoverSound.think = q2hoverSound_think;
	q2hoverSound.nextthink = time;

	setattachment(q2hoverSound, ent, "");
};

void() precache_hover =
{
	precache_model("models/monsters/hover/tris.md2");
	
	precache_sound (HOVER_SOUND_ATTACK1);
	precache_sound (HOVER_SOUND_DETH1);
	precache_sound (HOVER_SOUND_DETH2);
	precache_sound (HOVER_SOUND_IDLE1);
	precache_sound (HOVER_SOUND_PAIN1);
	precache_sound (HOVER_SOUND_PAIN2);
	precache_sound (HOVER_SOUND_SIGHT1);
	precache_sound (HOVER_SOUND_SRCH1);
	precache_sound (HOVER_SOUND_SRCH2);	
}

/*QUAKED monster_hover (1 .5 0) (-16 -16 -24) (16 16 32) Ambush Trigger_Spawn Sight
*/
void() monster_hover=
{
	if(deathmatch){
		remove(self);
		return;
	}

	self.classname = "monster_hover";

	precache_hover();
	
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	
	setmodel(self, "models/monsters/hover/tris.md2");
	
	setsize(self, '-16 -16 -24', '16 16 32');
	self.health = 240;
	self.max_health = self.health;
	
	self.th_stand = hover_stand;
	self.th_walk = hover_walk;
	self.th_run = hover_run;
	self.th_missile = hover_start_attack;
	self.th_pain = hover_pain;
	self.th_die = hover_die;

	attachq2hoverSound(self);

	flymonster_start;
}