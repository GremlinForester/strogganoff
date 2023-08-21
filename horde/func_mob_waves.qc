/*
	horde mod

    TODO
        + wave-point rollover - better iteration of wave points.
        + wave-point occupied detection,.
        + wave-point path corner, generate? make mapper place?
        + 'reset' wave-group to refire.

*/

entity(float mobId) mob_generate;   //include reference
float() mob_spawn_next;

void() wavemonster_start;
void() wavemonster_flystart;

//void() heist_core_music_loud;

/*
    server entry-point to wave manager
*/
void() horde_wave_manager_use;
void() horde_wave_manager_init;

void() horde_wave_manager =
{

    local entity this;

    HORDE_MANAGER = spawn();

    if(!HORDE_MANAGER){
        error("worldspawn - failed to generate HORDE_MANAGER!\n");
        return;
    }

    this = self;
    self = HORDE_MANAGER;
        self.attack_state = FUNC_WAVE_STATE_INIT;
        self.think = horde_wave_manager_init;
        self.nextthink = time + 10;
    self = this;
};

void() horde_wave_manager_init={

    local entity firstWave;
    local entity hordeWave;
    local entity nextWave;

    firstWave = find(world, targetname, world.wave_next_id);

    if(!firstWave){
        //logStr("ERROR(HORDE_MANAGER)", world.wave_next_id);
		dprint("ERROR(HORDE_MANAGER) "); 
		LOG(world.wave_next_id);
        objerror("failed to find first horde_wave_group by id!\n");
        return;
    }

    //build the chain of waves.
    //NOTE - DP/FTE can just do findchain();
    self.wave_next = firstWave;
    self.count = 1;
    hordeWave = firstWave;
    
    while((hordeWave != world)){
        nextWave = find(world, targetname, hordeWave.wave_next_id);
        if(nextWave && nextWave.classname == "horde_wave_group"){
            hordeWave.wave_next = nextWave;
            self.count = self.count + 1;
            hordeWave = nextWave;
        }
        else{
            hordeWave = world;
        }
    }

    self.use = horde_wave_manager_use;

    if(!self.wave_interval || self.wave_interval <= 44.99){
        self.wave_interval = 45;
    }

    self.attack_state = FUNC_WAVE_STATE_READY;
    self.count_start = self.count;
    self.count = 1;
};

void() horde_wave_manager_use={
    //TODO - VA event
    //logStr("HORDE MANAGER", "USE ");   //debug
    if(self.wave_next){
        //heist_core_music_loud();
        //logStr("HORDE MANAGER- USE()", self.wave_next.targetname);   //debug
        self.attack_state = FUNC_WAVE_STATE_RUN;
        self.wave_next.think = self.wave_next.use;
        self.wave_next.nextthink = time + 1;

    }
};
void() horde_wave_manager_next_wave={
    //logStr("HORDE MANAGER- horde_wave_manager_next_wave()", "exec");   //debug

    //TODO - VA event
    if(self.wave_next.wave_next){
        self.count = self.count + 1;
        self.wave_next = self.wave_next.wave_next;
        self.attack_state = FUNC_WAVE_STATE_RUN;
        self.wave_next.think = self.wave_next.use;
        self.wave_next.nextthink = time + self.wave_interval;

       // logStr("HORDE MANAGER- NEXT_WAVE()", self.wave_next.targetname);   //debug
    }
    else{
       // logStr("HORDE MANAGER- WAVES COMPLETE", "FUNC_WAVE_STATE_DONE");   //debug
        self.attack_state = FUNC_WAVE_STATE_DONE;
        self.nextthink = -1;
    }
};

//=====================================================
void() horde_wave_group_init;
void() horde_wave_group_use;
void() horde_wave_group_spawn;
void() hord_wave_group_mob_dead;

/*
    Wave groups are brush-entities that scan their contents for mobs.
    Mobs are linked together as the basis of the wave.

*/
void() horde_wave_group={

    InitTrigger();

    if(!self.targetname || self.targetname == "")
    {
        objerror("missing targetname, needed for use.");
        remove(self);
        return;
    }

    if(!self.wave_interval)
    {
        self.wave_interval = 1;
    }

    if(!self.wait)
    {
        self.wait = 1;
    }

    self.attack_state = FUNC_WAVE_STATE_INIT;
    self.use = horde_wave_group_use;
    self.think = horde_wave_group_init;
    self.nextthink = time + 5.001;
};

//scan area of brush for any mobs being contained in it.
void() horde_wave_group_init =
{
	/*
    local float totes;

    totes = 0;

    totes = totes + self.mob_fish;
    totes = totes + self.mob_dog;
    totes = totes + self.mob_army;
    totes = totes + self.mob_enforcer;
    totes = totes + self.mob_knight;
    totes = totes + self.mob_ogre;
    totes = totes + self.mob_fiend;
    totes = totes + self.mob_hellknight;
    totes = totes + self.mob_wizard;
    totes = totes + self.mob_vore;
    totes = totes + self.mob_shambler;
    totes = totes + self.mob_zombie;
    totes = totes + self.mob_tarbb;
	*/
    /*
	if(self.mob_fish){
        self.wave_mobs = self.wave_mobs | MOB_ID_FISH;
    }
    if(self.mob_dog){
        self.wave_mobs = self.wave_mobs | MOB_ID_DOG;
    }
    if(self.mob_army){
        self.wave_mobs = self.wave_mobs | MOB_ID_ARMY;
    }
    if(self.mob_enforcer){
        self.wave_mobs = self.wave_mobs | MOB_ID_ENFRCE;
    }
    if(self.mob_knight){
        self.wave_mobs = self.wave_mobs | MOB_ID_KNIGHT;
    }
    if(self.mob_ogre){
        self.wave_mobs = self.wave_mobs | MOB_ID_OGRE;
    }
    if(self.mob_fiend){
        self.wave_mobs = self.wave_mobs | MOB_ID_FIEND;
    }
    if(self.mob_hellknight){
        self.wave_mobs = self.wave_mobs | MOB_ID_HKNIGHT;
    }
    if(self.mob_wizard){
        self.wave_mobs = self.wave_mobs | MOB_ID_WIZRD;
    }
    if(self.mob_vore){
        self.wave_mobs = self.wave_mobs | MOB_ID_VORE;
    }
    if(self.mob_shambler){
        self.wave_mobs = self.wave_mobs | MOB_ID_SHMBL;
    }
    if(self.mob_zombie){
        self.wave_mobs = self.wave_mobs | MOB_ID_ZMBIE;
    }
    if(self.mob_tarbb){
        self.wave_mobs = self.wave_mobs | MOB_ID_TARBB;
    }
	*/
	
    self.spawnflags = self.spawnflags | SPAWNFLAG_HORDE_GRP_ORD_SIZE;
    if((self.spawnflags & SPAWNFLAG_HORDE_GRP_ORD_RAND) || (self.spawnflags & SPAWNFLAG_HORDE_GRP_ORD_RVSIZE))
    {
        self.spawnflags = self.spawnflags - (self.spawnflags & SPAWNFLAG_HORDE_GRP_ORD_SIZE);
    }

    if(self.count_start <= 0){
        objerror("you forgot to add a count_start to this group!?\n");
        remove(self);
        return;
    }

    if(!self.wave_point){
        objerror("failed to build wave-point spawn list.\n");
        remove(self);
        return;
    }
    else{
        if(cvar("developer") > 0){
            dprint("wave point list built.\n"); //debug
        }
    }

    self.owner = HORDE_MANAGER;
    self.attack_state = FUNC_WAVE_STATE_READY;
    self.count = self.count_start;
    self.wave_size = self.count_start;
    self.th_die = hord_wave_group_mob_dead;
};

void() hord_wave_group_mob_dead={
    if(self.attack_state < FUNC_WAVE_STATE_RUN){
        return;
    }
    self.wave_size = self.wave_size - 1;
    if(self.wave_size == 0){
        //WAVE COMPLETE
        //TODO - EVENT - VA "you guys really cleaned house! but there'll be more, keep moving!"
        bprint("\n you guys really cleaned house! but there'll be more, keep moving!\n");
        HORDE_MANAGER.think = horde_wave_manager_next_wave;
        HORDE_MANAGER.nextthink = time + 1.01;
    }
};
void() horde_wave_group_use={

    if(self.attack_state != FUNC_WAVE_STATE_READY)
    {
        dprint("\n self.attack_state != FUNC_WAVE_STATE_READY \n");
        return;
    }

    if(self.attack_state == FUNC_WAVE_STATE_READY)
    {
        //detects "first-time use"
        //TODO - EVENT -> VA ""
        if(self.owner.count == 1)
        //    bprint("\n there goes the alarm! we got creeps comin'!\n");
			LOG(self.owner.targetname);
    //    else
      //      bprint("\n Get Ready, more mobs comin'!\n");
    }
    self.attack_state = FUNC_WAVE_STATE_RUN;

    self.think = horde_wave_group_spawn;
    self.nextthink = time + self.wait;

};

//NOTE - if spawn point is 'blocked', pause the wave-spawning
void() horde_wave_group_spawn_pause={


};

void() horde_wave_group_spawn={

    local float mobId;
    local entity mob;
    local entity point;
    local entity clientTarg;
    local entity this;

    if(self.count < 1)
    {
        dprint("horde_wave_group_spawn complete!\n");
        self.attack_state = FUNC_WAVE_STATE_DONE;
        self.nextthink = -1;
        multi_trigger();
        return;
    }

    //TODO - EVENT - VA "Here we go, more fuzz!"
    if(self.count == self.count_start)
    {
        bprint("\n Here we go, more fuzz!\n");
    }
        
    
    point = self.wave_point;

    mobId = mob_spawn_next();

    if(mobId == -1)
    {
        //logStr("horde_wave_group_spawn", "trying spawn again.");    //debug
        LOG("horde_wave_group_spawn trying spawn again.");    //debug
        dprint("count left "); 
		FLOG(self.count); //debug
        self.think = horde_wave_group_spawn;
        self.nextthink = time + 0.01;   //trying again.
        return;
    }

    mob = mob_generate(mobId);

    if(!mob && self.count > 0)
    {
        //logStr("horde_wave_group_spawn", "trying spawn again.");    //debug
        //logFloat("count left", self.count); //debug
		
		LOG("horde_wave_group_spawn trying spawn again.");    //debug
        dprint("count left "); 
		FLOG(self.count); //debug
		
        self.think = horde_wave_group_spawn;
        self.nextthink = time + 0.01;   //trying again.
        return;
    }

    if(mob)
    {
        mob.owner = self;
        if((self.spawnflags & SPAWNFLAG_HORDE_GROUP_VFX_TELE))
        {
            spawn_tfog(point.origin);
        }
        makevectors(self.wave_point.angles);
        setorigin(mob, point.origin + (v_forward * mob.maxs_x) + '0 0 2');
        mob.angles = point.angles;
        
		/*
        if(ENT_CLIENT1 || (ENT_CLIENT1.flags & FL_CLIENT)){
            clientTarg = ENT_CLIENT1;
        }
        if(ENT_CLIENT2 || (ENT_CLIENT2.flags & FL_CLIENT)){
            clientTarg = ENT_CLIENT2;
        }
        if(ENT_CLIENT3 || (ENT_CLIENT3.flags & FL_CLIENT)){
            clientTarg = ENT_CLIENT3;
        }
        if(ENT_CLIENT4 || (ENT_CLIENT4.flags & FL_CLIENT)){
            clientTarg = ENT_CLIENT4;
        }      
		*/
		
		if(SV_PLAYER1 || (SV_PLAYER1.flags & FL_CLIENT)){
            clientTarg = SV_PLAYER1;
        }
        if(SV_PLAYER2 || (SV_PLAYER2.flags & FL_CLIENT)){
            clientTarg = SV_PLAYER2;
        }
        if(SV_PLAYER3 || (SV_PLAYER3.flags & FL_CLIENT)){
            clientTarg = SV_PLAYER3;
        }
        if(SV_PLAYER4 || (SV_PLAYER4.flags & FL_CLIENT)){
            clientTarg = SV_PLAYER4;
        }
		
		
        this = self;
        self = mob;
            force_retouch = 2;
            droptofloor();
            if(self.classname == "monster_wizard")
            {
                wavemonster_flystart();
            }
            else
            {
                wavemonster_start();
            }
			
			//local entity client;
			//client = checkclient();
			self.enemy = clientTarg;
			//self.enemy = client;
        
			FoundTarget();
        
		self = this;

        if(self.wave_point.wave_point)
        {
            self.wave_point = self.wave_point.wave_point;
        }
        else
        {
            self.wave_point = self.wave_point_start;
        }
        
    }
    else
    {
        dprint("horde_wave_group_spawn no more mobs!\n");
        self.attack_state = FUNC_WAVE_STATE_DONE;
        self.nextthink = -1;
        multi_trigger();
        return;
    }

    self.count = self.count - 1;
    self.think = horde_wave_group_spawn;
    self.nextthink = time + self.wave_interval;

};

/*
    Monster wave-point, use these to spawn waves of baddies as players are hordein'.
*/
void() th_horde_mob_spawn_init;
void() horde_mob_spawn_point={

    if(!self.wave_point_group  || self.wave_point_group == ""){
        objerror("[horde_mob_spawn_point] missing .wave_point_group field.\n");
        remove(self);
        return;
    }

    self.solid = SOLID_NOT;
    self.movetype = MOVETYPE_NONE;
    setsize(self, '-16 -16 -24', '16 16 24');
    setorigin(self, self.origin);

    self.think = th_horde_mob_spawn_init;
    self.nextthink = time + 2.01;
};

//wave_point waits a few seconds for all map-ents to spawn in before building its linked list.
void() th_horde_mob_spawn_init={

    local entity funcWave;
    local entity pointLink;
    local entity pointNext;

    funcWave = find(world, targetname, self.wave_point_group);
    if(!funcWave){
        objerror("missing parent(.wave_point_group) entity\n");
        remove(self);
        return;
    }

    if(funcWave.classname != "horde_wave_group"){
        objerror("missing parent wasn't a horde_wave_group!\n");
        remove(self);
        return;
    }

    //construct func_wave's point chain bottom-up.
    pointLink = funcWave.wave_point;

    if(pointLink){
        pointNext = pointLink.wave_point;

        while(pointNext){
            pointLink = pointNext;
            pointNext = pointNext.wave_point;
        }
        pointLink.wave_point = self;
    }
    else{
        funcWave.wave_point = self;
        funcWave.wave_point_start = self;
    }
};