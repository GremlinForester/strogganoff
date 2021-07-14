//
#define CAM_IDLE				0
#define CAM_FIXED			1
#define CAM_FLYBY			2
#define CAM_FOLLOW	3
#define CAM_HAND			4
#define CAM_FREE 			5
#define CAM_NOCLIP		6
#define CAM_DEATH			7

entity (entity ent) CamCycle = {

	if ( (ent == world) ) {

		self.cnt = CAM_IDLE;

	}
	if ( (self.cnt == CAM_IDLE) ) {

		ent = find (ent,classname,"player");
		if ( (ent == world) ) {

			self.cnt = CAM_FIXED;

		}

	}
	if ( (self.cnt == CAM_FIXED) ) {

		ent = find (ent,classname,"dmbot");

	}
	return ( ent );

};

void (entity ent) CamVectors = {

	if ( (ent.classname == "player") ) {

		makevectors (ent.v_angle);

	} else {

		makevectors (ent.angles);

	}

};
void (entity client, string s) camcenterprint1 = #73; 

#define		camcenterprint2		camcenterprint1
#define		camcenterprint3		camcenterprint1
#define		camcenterprint4		camcenterprint1
#define		camcenterprint5		camcenterprint1
#define		camcenterprint7		camcenterprint1
/*
void (entity client, string s) camcenterprint2 = #73; 
void (entity client, string s) camcenterprint3 = #73; 
void (entity client, string s) camcenterprint4 = #73; 
void (entity client, string s) camcenterprint5 = #73; 
*/
void (entity client, string s, string s, string s, string s, string s, string s) camcenterprint6 = #73; 
//void (entity client, string s) camcenterprint7 = #73; 
//void (entity client, string s) camcenterprint7 = #73; 

void (entity ent, string tit) CamReport = {

	local string s2;
	local string s3;

	if ( (ent.frags < CAM_FIXED) ) {

		s2 = "no";

	} else {

		s2 = ftos (ent.frags);

	}
	if ( (ent.frags != CAM_FIXED) ) {

		s3 = " frags";

	} else {

		s3 = " frag";

	}
	camcenterprint6 (self,tit,"\n\n\n",ent.netname," - ",s2,s3);

};
float (float num) CamSqrt = {

	local float apr;

	if ( (num < 0.001) ) {

		return ( CAM_IDLE );

	}
	if ( (num > CAM_FIXED) ) {

		apr = num;

	} else {

		apr = CAM_FIXED;

	}
	do {

		apr = ((num + (apr * apr)) / (CAM_FLYBY * apr));

	} while ( (fabs (((apr * apr) - num)) > (num * 0.001)) );
	return ( apr );

};
float (float a) CamReAngle = {

	while ( (a > 180) ) {

		a = (a - 360);

	}
	while ( (a < -180) ) {

		a = (a + 360);

	}
	return ( a );

};
float (vector vec) CamVisible = {

	traceline (self.origin,vec,TRUE,self);
	return ( ((trace_fraction == CAM_FIXED) && !(trace_inopen && trace_inwater)) );

};
float (entity ent) CamVisibleEnt = {

	local vector vec;

	if ( CamVisible (ent.origin) ) {

		return ( TRUE );

	}
	vec = ent.origin;
	vec_z = ent.absmin_z;
	if ( CamVisible (vec) ) {

		return ( TRUE );

	}
	vec_z = (ent.absmax_z - AI_DANGER);
	return ( CamVisible (vec) );

};
entity () CamShoot = {

	local entity ent;
	local entity entx;
	local vector vec;
	local float d1;
	local float dx;

	makevectors (self.v_angle);
	entx = world;
	ent = CamCycle (world);
	dx = CAM_IDLE;
	while ( (ent != world) ) {

		if ( (ent.deadflag == DEAD_NO) ) {

			vec = (ent.origin - self.origin);
			vec = normalize (vec);
			d1 = (((v_forward_x * vec_x) + (v_forward_y * vec_y)) + (v_forward_z * vec_z));
			if ( (d1 > dx) ) {

				if ( CamVisible (ent.origin) ) {

					entx = ent;
					dx = d1;

				}

			}

		}
		ent = CamCycle (ent);

	}
	return ( entx );

};
float (float d, float a) CamHurry = {

	local float dd;
	local float t;
	local float tt;

	if ( (d < CAM_IDLE) ) {

		a = (CAM_IDLE - a);

	}
	t = frametime;
	tt = CamSqrt ((d / a));
	if ( (t > tt) ) {

		return ( d );

	} else {

		return ( ((a * t) * ((CAM_FLYBY * tt) - t)) );

	}

};
vector (float s, float v, float a) CamSmooth = {

	local float dt;
	local float t1;
	local float t2;
	local float v2;
	local float as;
	local float sv2;
	local float b;
	local vector vec;

	s = CamReAngle (s);
	v2 = (v / CAM_FLYBY);
	as = (a * s);
	sv2 = (v2 * v2);
	dt = frametime;
	if ( (fabs (as) < sv2) ) {

		b = (v > CAM_IDLE);

	} else {

		b = (s > CAM_IDLE);

	}
	if ( b ) {

		t2 = (CamSqrt (((sv2 + as) / CAM_FLYBY)) / a);
		a = (CAM_IDLE - a);

	} else {

		t2 = (CamSqrt (((sv2 - as) / CAM_FLYBY)) / a);

	}
	t1 = (t2 - (v2 / a));
	if ( (t1 > dt) ) {

		s = ((((a * dt) + v) * dt) + s);
		v = (((a * dt) * CAM_FLYBY) + v);

	} else {

		s = ((((a * t1) + v) * t1) + s);
		v = (((a * t1) * CAM_FLYBY) + v);
		t1 = (dt - t1);
		if ( (t1 < t2) ) {

			s = (((v - (a * t1)) * t1) + s);
			v = (v - ((a * t1) * CAM_FLYBY));

		} else {

			s = CAM_IDLE;
			v = CAM_IDLE;

		}

	}
	vec_x = s;
	vec_y = v;
	return ( vec );

};
float (vector vec) TryFlybyVector = {

	local vector orig;
	local vector vec1;
	local float vl;

	vec1 = normalize (vec);
	vec = (700 * vec1);
	vec1 = (CAM_FREE * vec1);
	orig = self.enemy.origin;
	orig_z = (self.enemy.absmax_z - AI_DANGER);
	traceline (orig,(orig + vec),FALSE,self.enemy);
	if ( (trace_ent != world) ) {

		return ( 1111 );

	}
	if ( (trace_inopen && trace_inwater) ) {

		return ( 1111 );

	}
	trace_endpos = (trace_endpos - vec1);
	if ( (pointcontents (trace_endpos) == CONTENT_SOLID) ) {

		return ( 1111 );

	}
	vl = vlen ((self.enemy.origin - trace_endpos));
	if ( (vl < 50) ) {

		return ( 1111 );

	}
	return ( fabs ((333 - vl)) );

};

void (float speedv, float speeda) CamUpdatePos = {

	local vector vec;
	local vector v1;
	local float vl;

	traceline (self.origin,self.dest,TRUE,self);
	if ( (trace_fraction != CAM_FIXED) ) {

		speedv = CAM_IDLE;
		speeda = CAM_IDLE;

	}
	if ( (speedv == CAM_IDLE) ) {

		setorigin (self,self.dest);

	} else {

		vec = (self.dest - self.origin);
		vl = vlen (vec);
		vec = normalize (vec);
		vl = CamHurry (vl,speedv);
		vec = (vl * vec);
		setorigin (self,(self.origin + vec));

	}
	self.fixangle = TRUE;
	self.movetype = MOVETYPE_NONE;
	if ( (self.state != CAM_DEATH) ) {

		vec = vectoangles ((self.dest1 - self.dest));

	} else {

		vec = vectoangles ((self.dest1 - self.origin));

	}
	vec_z = CAM_IDLE;
	vec_x = CamReAngle ((360 - vec_x));
	vec_y = CamReAngle (vec_y);
	if ( (vec_x > 70) ) {

		vec_x = 70;

	} else {

		if ( (vec_x < -70) ) {

			vec_x = -70;

		}

	}
	if ( (speeda == CAM_IDLE) ) {

		self.angles = vec;
		self.mangle = VEC_ORIGIN;

	} else {

		v1 = CamSmooth ((self.angles_x - vec_x),self.mangle_x,speeda);
		self.mangle_x = v1_y;
		self.angles_x = (vec_x + v1_x);
		v1 = CamSmooth ((self.angles_y - vec_y),self.mangle_y,speeda);
		self.mangle_y = v1_y;
		self.angles_y = (vec_y + v1_x);
		self.angles_x = CamReAngle (self.angles_x);
		self.angles_y = CamReAngle (self.angles_y);

	}
	self.v_angle = self.angles;

};

void () CamSetAuto = {

	self.dest = self.origin;
	makevectors (self.v_angle);
	self.dest1 = (self.origin + v_forward);
	CamUpdatePos (CAM_IDLE,CAM_IDLE);

};

void () CamGoIdle = {

	CamSetAuto ();
	self.state = CAM_IDLE;
	self.pausetime = (time + CAM_FLYBY);
	self.search_time = time;
	self.dest2 = self.dest1;
	self.enemy = self;

};

void () CamGoDeath = {

	if ( self.aflag ) {

		CamReport (self.enemy,"R.I.P.");

	}
	self.mangle = VEC_ORIGIN;
	self.dest = self.origin;
	self.state = CAM_DEATH;
	self.pausetime = (time + CAM_FIXED);
	self.movetarget = world;
	self.search_time = (time + CAM_FREE);

};
vector (entity ent) CamFlybyTarget = {

	local vector vec;

	vec = ent.origin;
	vec_z = (ent.absmax_z - AI_DANGER);
	return ( vec );

};

void (entity newtarg) CamInitFlybyMode = {

	local float f;
	local float max;
	local vector vec;
	local vector vec2;
	local vector trg;
	local entity ent;

	self.pausetime = (time + 0.400);
	if ( (self.enemy != newtarg) ) {

		self.enemy = newtarg;
		if ( (self.movetarget != self.enemy) ) {

			if ( self.aflag ) {

				CamReport (self.enemy,"Now taking");

			}
			self.movetarget = newtarg;

		}

	}
	vec = self.enemy.angles;
	vec_x = CAM_IDLE;
	vec_y = CAM_IDLE;
	makevectors (vec);
	v_forward = (CAM_FOLLOW * v_forward);
	max = 1000;
	f = TryFlybyVector (((v_up + v_forward) + v_right));
	if ( (f < max) ) {

		max = f;
		vec = trace_endpos;

	}
	f = TryFlybyVector (((v_up - v_forward) + v_right));
	if ( (f < max) ) {

		max = f;
		vec = trace_endpos;

	}
	f = TryFlybyVector (((v_up + v_forward) - v_right));
	if ( (f < max) ) {

		max = f;
		vec = trace_endpos;

	}
	f = TryFlybyVector (((v_up - v_forward) - v_right));
	if ( (f < max) ) {

		max = f;
		vec = trace_endpos;

	}
	if ( (max >= 1000) ) {

		f = TryFlybyVector ((v_up + v_forward));
		if ( (f < max) ) {

			max = f;
			vec = trace_endpos;

		}
		f = TryFlybyVector ((v_up - v_forward));
		if ( (f < max) ) {

			max = f;
			vec = trace_endpos;

		}
		f = TryFlybyVector ((v_up + v_right));
		if ( (f < max) ) {

			max = f;
			vec = trace_endpos;

		}
		f = TryFlybyVector ((v_up - v_right));
		if ( (f < max) ) {

			max = f;
			vec = trace_endpos;

		}

	}
	if ( (max >= 1000) ) {

		f = TryFlybyVector ((v_forward + v_right));
		if ( (f < max) ) {

			max = f;
			vec = trace_endpos;

		}
		f = TryFlybyVector ((v_forward - v_right));
		if ( (f < max) ) {

			max = f;
			vec = trace_endpos;

		}
		f = TryFlybyVector (((VEC_ORIGIN - v_forward) + v_right));
		if ( (f < max) ) {

			max = f;
			vec = trace_endpos;

		}
		f = TryFlybyVector (((VEC_ORIGIN - v_forward) - v_right));
		if ( (f < max) ) {

			max = f;
			vec = trace_endpos;

		}

	}
	if ( (max >= 1000) ) {

		f = TryFlybyVector (v_forward);
		if ( (f < max) ) {

			max = f;
			vec = trace_endpos;

		}
		f = TryFlybyVector (v_right);
		if ( (f < max) ) {

			max = f;
			vec = trace_endpos;

		}
		f = TryFlybyVector ((VEC_ORIGIN - v_forward));
		if ( (f < max) ) {

			max = f;
			vec = trace_endpos;

		}
		f = TryFlybyVector ((VEC_ORIGIN - v_right));
		if ( (f < max) ) {

			max = f;
			vec = trace_endpos;

		}

	}
	if ( (max >= 1000) ) {

		f = TryFlybyVector ((((VEC_ORIGIN - v_up) + v_forward) + v_right));
		if ( (f < max) ) {

			max = f;
			vec = trace_endpos;

		}
		f = TryFlybyVector ((((VEC_ORIGIN - v_up) - v_forward) + v_right));
		if ( (f < max) ) {

			max = f;
			vec = trace_endpos;

		}
		f = TryFlybyVector ((((VEC_ORIGIN - v_up) + v_forward) - v_right));
		if ( (f < max) ) {

			max = f;
			vec = trace_endpos;

		}
		f = TryFlybyVector ((((VEC_ORIGIN - v_up) - v_forward) - v_right));
		if ( (f < max) ) {

			max = f;
			vec = trace_endpos;

		}

	}
	if ( (max >= 1000) ) {

		f = TryFlybyVector (((VEC_ORIGIN - v_up) + v_forward));
		if ( (f < max) ) {

			max = f;
			vec = trace_endpos;

		}
		f = TryFlybyVector (((VEC_ORIGIN - v_up) + v_right));
		if ( (f < max) ) {

			max = f;
			vec = trace_endpos;

		}
		f = TryFlybyVector (((VEC_ORIGIN - v_up) - v_forward));
		if ( (f < max) ) {

			max = f;
			vec = trace_endpos;

		}
		f = TryFlybyVector (((VEC_ORIGIN - v_up) - v_right));
		if ( (f < max) ) {

			max = f;
			vec = trace_endpos;

		}

	}
	if ( (max >= 1000) ) {

		CamGoIdle ();
		self.pausetime = (time + CAM_FLYBY);
		return ;

	}
	self.dest1 = CamFlybyTarget (self.enemy);
	self.dest = vec;
	self.state = CAM_FLYBY;
	self.lip = (1.500 * vlen ((self.dest - self.dest1)));
	if ( (self.lip < 500) ) {

		self.lip = 500;

	}
	CamUpdatePos (CAM_IDLE,CAM_IDLE);

};
vector () GetFollowCam = {

	local vector vec;
	local vector vec2;

	CamVectors (self.enemy);
	vec = (self.enemy.origin + ((self.enemy.maxs_z + CAM_HAND) * v_up));
	traceline (self.enemy.origin,vec,FALSE,self);
	vec = (trace_endpos - normalize (vec));
	vec2 = (-100 * v_forward);
	traceline (vec,(vec + vec2),TRUE,self);
	vec2 = (trace_endpos - normalize (vec2));
	if ( CamVisible (vec2) ) {

		return ( vec2 );

	} else {

		return ( vec );

	}

};
vector () GetFollowTrg = {

	local vector vec;

	if ( (self.enemy.deadflag == DEAD_NO) ) {

		CamVectors (self.enemy);
		vec = (self.enemy.origin + (AI_RIDE_TRAIN * v_forward));

	} else {

		vec = self.enemy.origin;

	}
	return ( vec );

};

void () CamHandJump = {

	makevectors (self.v_angle);
	traceline (self.origin,(self.origin + (2000 * v_forward)),TRUE,self);
	self.dest = (trace_endpos - (CAM_FREE * normalize ((trace_endpos - self.origin))));
	self.dest1 = self.origin;
	CamUpdatePos (CAM_IDLE,CAM_IDLE);

};
entity (float n) CamGetPos = {

	local entity ent;

	ent = find (world,classname,"CamSavedPos");
	while ( ((n > CAM_IDLE) && (ent != world)) ) {

		ent = find (ent,classname,"CamSavedPos");
		n = (n - CAM_FIXED);

	}
	return ( ent );

};

void (float n) CamSavePos = {

	local entity ent;

	ent = CamGetPos (n);
	if ( (ent != world) ) {

		ent.angles = self.angles;
		ent.v_angle = self.v_angle;
		setorigin (ent,self.origin);

	}

};

void (float n) CamLoadPos = {

	local entity ent;

	if ( (((self.state == CAM_HAND) || (self.state == CAM_FREE)) || (self.state == CAM_NOCLIP)) ) {

		ent = CamGetPos (n);
		if ( (ent != world) ) {

			self.fixangle = TRUE;
			self.angles = ent.angles;
			self.v_angle = ent.v_angle;
			setorigin (self,ent.origin);

		}

	}

};

void () CamImpulses = {

	local float c;
	local entity ent;
	local string s;

	if ( (self.impulse == 100) ) {

		self.goalentity = world;
		CamGoIdle ();

	} else {

		if ( ((self.impulse > 100) && (self.impulse < 150)) ) {

			self.goalentity = world;
			c = (self.impulse - 100);
			ent = world;
			do {

				ent = CamCycle (ent);
				c = (c - CAM_FIXED);

			} while ( ((c > CAM_IDLE) && (ent != world)) );
			if ( (ent != world) ) {

				if ( (ent.deadflag == DEAD_NO) ) {

					CamInitFlybyMode (ent);
					self.delay = (time + TE_LAVASPLASH);
					self.search_time = (time + 60);

				}

			}

		} else {

			if ( ((self.impulse >= 180) && (self.impulse <= 189)) ) {

				c = (self.impulse - 180);
				CamSavePos (c);

			} else {

				if ( ((self.impulse >= 190) && (self.impulse <= 199)) ) {

					c = (self.impulse - 190);
					CamLoadPos (c);

				} else {

					if ( (self.impulse == 200) ) {

						if ( (self.enemy != self) ) {

							CamInitFlybyMode (self.enemy);

						} else {

							ent = CamShoot ();
							if ( (ent != world) ) {

								CamInitFlybyMode (ent);
								self.delay = (time + TE_LAVASPLASH);
								self.search_time = (time + 60);

							}

						}

					} else {

						if ( (self.impulse == 201) ) {

							if ( (self.enemy != self) ) {

								self.state = CAM_FOLLOW;

							} else {

								ent = CamShoot ();
								if ( (ent != world) ) {

									self.enemy = ent;
									self.movetarget = ent;
									if ( self.aflag ) {

										CamReport (self.enemy,"Now Taking");

									}
									self.state = CAM_FOLLOW;
									self.search_time = (time + 60);
									self.mangle = VEC_ORIGIN;

								}

							}

						} else {

							if ( (self.impulse == 202) ) {

								if ( ((self.state != CAM_FLYBY) && (self.state != CAM_FIXED)) ) {

									CamHandJump ();

								}
								self.state = CAM_HAND;
								self.movetype = MOVETYPE_NONE;
								self.enemy = self;
								self.movetarget = world;

							} else {

								if ( (self.impulse == 203) ) {

									self.state = CAM_FREE;
									self.movetype = MOVETYPE_FLY;
									self.enemy = self;
									self.movetarget = world;

								} else {

									if ( (self.impulse == 204) ) {

										self.state = CAM_NOCLIP;
										self.enemy = self;
										self.movetarget = world;
										self.movetype = MOVETYPE_NOCLIP;

									} else {

										if ( (self.impulse == 205) ) {

											if ( ((self.state == CAM_FLYBY) || (self.state == CAM_HAND)) ) {

												CamSetAuto ();
												self.state = CAM_FIXED;
												self.enemy = self;
												self.movetarget = world;
												self.search_time = (time + 100000);
												self.pausetime = (time + CAM_FOLLOW);

											}

										} else {

											if ( (self.impulse == 210) ) {

												self.aflag = !self.aflag;

											} else {

												if ( (self.impulse == 211) ) {

													bprint ("Current camera position: ");
													bprint (vtos (self.origin));
													bprint ("\n");

												} else {

													if ( (self.impulse == 212) ) {

														self.aflag = TRUE;

													} else {

														if ( (self.impulse == 213) ) {

															self.aflag = FALSE;

														} else {

															if ( (self.impulse == 214) ) {

																self.attack_state = TRUE;

															} else {

																if ( (self.impulse == 215) ) {

																	self.attack_state = FALSE;

																} else {

																	if ( (self.impulse == 216) ) {

																		if ( (self.enemy != self) ) {

																			self.goalentity = self.enemy;

																		}

																	} else {

																		if ( (self.impulse == 217) ) {

																			if ( (self.enemy != self) ) {

																				ent = CamCycle (world);
																				while ( ((ent != world) && (ent != self.enemy)) ) {

																					ent = CamCycle (ent);

																				}
																				if ( (ent != world) ) {

																					c = TRUE;
																					while ( c ) {

																						ent = CamCycle (ent);
																						if ( (ent == world) ) {

																							ent = CamCycle (ent);

																						}
																						if ( (ent == world) ) {

																							c = FALSE;

																						} else {

																							if ( (ent.deadflag == DEAD_NO) ) {

																								if ( (self.goalentity != world) ) {

																									self.goalentity = ent;

																								}
																								CamInitFlybyMode (ent);
																								self.delay = (time + TE_LAVASPLASH);
																								self.search_time = (time + 60);
																								c = FALSE;

																							}

																						}

																					}

																				}

																			}

																		}

																	}

																}

															}

														}

													}

												}

											}

										}

									}

								}

							}

						}

					}

				}

			}

		}

	}
	self.impulse = CAM_IDLE;

};

void () CamUpdValues = {

	local float it;

	if ( (((self.enemy != self) && (self.enemy.classname != "bodyque")) && (self.enemy.health > CAM_IDLE)) ) {

		it = (((IT_INVISIBILITY | IT_INVULNERABILITY) | IT_SUIT) | IT_QUAD);
		self.items = ((self.enemy.items | it) - it);
		self.health = self.enemy.health;
		self.armorvalue = self.enemy.armorvalue;
		self.ammo_shells = self.enemy.ammo_shells;
		self.inv_ammo_bullets = self.enemy.inv_ammo_bullets;
		self.ammo_rockets = self.enemy.ammo_rockets;
		self.ammo_cells = self.enemy.ammo_cells;
		self.weapon = self.enemy.weapon;
		self.currentammo = self.enemy.currentammo;

	} else {

		self.items = CAM_IDLE;
		self.health = 111;
		self.armorvalue = 111;
		self.ammo_shells = 111;
		self.inv_ammo_bullets = 111;
		self.ammo_rockets = 111;
		self.ammo_cells = 111;
		self.weapon = WEP_BLASTER;
		self.currentammo = 111;

	}

};
float (entity ent) CamHealthVal = {

	local float alldmg;

	alldmg = (ent.health / (CAM_FIXED - ent.armortype));
	if ( (alldmg > (ent.health + ent.armorvalue)) ) {

		alldmg = (ent.health + ent.armorvalue);

	}
	return ( alldmg );

};

void () CamIdleThink = {

	local entity ent;
	local entity ent2;
	local vector vec;
	local vector vec2;
	local float p1;
	local float p2;
	local float pa;
	local float pb;

	ent2 = self;
	if ( (self.movetarget != world) ) {

		if ( (self.movetarget.deadflag == DEAD_NO) ) {

			ent2 = self.movetarget;

		}

	}
	p2 = CONTENT_EMPTY;
	p1 = (CAM_FREE * random ());
	if ( (self.goalentity != world) ) {

		if ( (self.goalentity.deadflag == DEAD_NO) ) {

			ent2 = self.goalentity;

		} else {

			ent2 = self;

		}

	} else {

		if ( (p1 < CAM_FIXED) ) {

			ent = CamCycle (world);
			while ( (ent != world) ) {

				if ( ((ent != self.movetarget) && (ent.deadflag == DEAD_NO)) ) {

					p1 = CamHealthVal (ent);
					if ( (p2 < p1) ) {

						ent2 = ent;
						p2 = p1;

					}

				}
				ent = CamCycle (ent);

			}

		} else {

			if ( (p1 < CAM_FLYBY) ) {

				ent = CamCycle (world);
				while ( (ent != world) ) {

					if ( ((ent != self.movetarget) && (ent.deadflag == DEAD_NO)) ) {

						p1 = ent.frags;
						if ( (p1 < CAM_IDLE) ) {

							p1 = CAM_IDLE;

						}
						if ( (p2 < p1) ) {

							ent2 = ent;
							p2 = p1;

						}

					}
					ent = CamCycle (ent);

				}

			} else {

				p2 = CAM_IDLE;
				ent = CamCycle (world);
				while ( (ent != world) ) {

					if ( ((ent != self.movetarget) && (ent.deadflag == DEAD_NO)) ) {

						p2 = (p2 + CAM_FIXED);

					}
					ent = CamCycle (ent);

				}
				if ( (p2 > CAM_IDLE) ) {

					p2 = (p2 * random ());
					ent = world;
					do {

						do {

							ent = CamCycle (ent);

						} while ( ((ent == self.movetarget) || (ent.deadflag != DEAD_NO)) );
						p2 = (p2 - CAM_FIXED);

					} while ( (p2 > CAM_IDLE) );
					if ( (ent != world) ) {

						ent2 = ent;

					}

				}

			}

		}

	}
	if ( (ent2 != self) ) {

		CamInitFlybyMode (ent2);
		self.delay = (time + TE_LAVASPLASH);
		self.search_time = (time + 60);

	} else {

		self.enemy = self;
		traceline (self.dest,self.dest1,TRUE,self);
		self.dest1 = trace_endpos;
		vec_x = ((40 * random ()) - 20);
		vec_y = (360 * random ());
		vec_z = CAM_IDLE;
		pa = vec_y;
		if ( (self.origin != self.dest) ) {

			vec2 = (self.origin - self.dest);
			vec2 = vectoangles (vec2);
			pb = vec2_y;

		} else {

			pb = CAM_IDLE;

		}
		pa = CamReAngle (pa);
		makevectors (vec);
		vec = (2000 * v_forward);
		p2 = vlen ((self.dest2 - self.dest));
		if ( (fabs (CamReAngle ((pa - pb))) > 60) ) {

			vec2 = (self.dest + vec);
			traceline (self.dest,vec2,TRUE,self);
			vec2 = trace_endpos;
			p1 = vlen ((vec2 - self.dest));
			if ( (p1 > p2) ) {

				self.dest2 = vec2;
				p2 = p1;

			}

		}
		pa = (pa + 180);
		pa = CamReAngle (pa);
		if ( (fabs (CamReAngle ((pa - pb))) > 60) ) {

			vec2 = (self.dest - vec);
			traceline (self.dest,vec2,TRUE,self);
			vec2 = trace_endpos;
			p1 = vlen ((vec2 - self.dest));
			if ( (p1 > p2) ) {

				self.dest2 = vec2;
				p2 = p1;

			}

		}
		if ( (self.pausetime < time) ) {

			self.pausetime = ((time + CAM_FOLLOW) + (CAM_FLYBY * random ()));
			self.dest1 = self.dest2;

		}
		if ( (self.search_time < time) ) {

			vec = (self.dest - self.dest1);
			vec = ((CAM_FREE + (50 * random ())) * normalize (vec));
			vec = (self.dest1 + vec);
			traceline (self.origin,vec,TRUE,self);
			if ( (trace_fraction == CAM_FIXED) ) {

				self.dest = vec;
				self.dest2 = self.dest1;
				self.search_time = ((time + AI_DANGER) + (CAM_FREE * random ()));

			} else {

				self.dest2 = self.dest;
				self.search_time = ((time + CAM_FIXED) + random ());

			}

		}

	}

};

void () CamFlyByThink = {

	local float p0;
	local float p1;
	local float grad;
	local float p;
	local vector vec;
	local entity ent;
	local float ok;

	if ( (self.enemy.deadflag != DEAD_NO) ) {

		if ( (time < SVC_FINALE) ) {

			CamGoIdle ();
			return ;

		}
		CamGoDeath ();
		return ;

	}
	p1 = vlen ((self.dest - self.enemy.origin));
	CamVisibleEnt (self.enemy);
	if ( ((CamVisibleEnt (self.enemy) && (self.lip > p1)) || (self.pausetime > time)) ) {

		self.dest1 = CamFlybyTarget (self.enemy);

	} else {

		CamInitFlybyMode (self.enemy);

	}
	if ( self.attack_state ) {

		self.state = CAM_FOLLOW;
		return ;

	} else {

		p1 = vlen ((self.enemy.origin - self.origin));
		if ( (p1 < 170) ) {

			grad = fabs ((self.enemy.angles_y - self.angles_y));
			if ( (grad > 180) ) {

				grad = (360 - grad);

			}
			if ( (grad < SVC_INTERMISSION) ) {

				vec = GetFollowCam ();
				if ( CamVisible (vec) ) {

					self.state = CAM_FOLLOW;
					return ;

				}

			}

		}

	}
	if ( (self.goalentity == world) ) {

		p0 = CAM_IDLE;
		p1 = CAM_IDLE;
		if ( (self.delay < time) ) {

			ent = CamCycle (world);
			while ( (ent != world) ) {

				p0 = (p0 + CAM_FIXED);
				if ( (ent.deadflag == DEAD_NO) ) {

					p = vlen ((ent.origin - self.origin));
					if ( (p < 1500) ) {

						if ( CamVisible (ent.origin) ) {

							p1 = (p1 + CAM_FIXED);

						}

					}

				}
				ent = CamCycle (ent);

			}

		}
		if ( (p0 < CAM_HAND) ) {

			p0 = CAM_FLYBY;

		} else {

			if ( (p0 < AI_DANGER) ) {

				p0 = CAM_FOLLOW;

			} else {

				p0 = CAM_HAND;

			}

		}
		if ( (p1 > p0) ) {

			self.enemy = self;
			self.movetarget = world;
			self.state = CAM_FIXED;
			self.search_time = (time + 15);
			self.pausetime = (time + CAM_FOLLOW);
			return ;

		}

	}
	if ( (self.search_time < time) ) {

		CamGoIdle ();

	}

};

void () CamFollowThink = {

	local entity ent;
	local vector vec;

	if ( (self.enemy.deadflag != DEAD_NO) ) {

		if ( (time < SVC_FINALE) ) {

			CamGoIdle ();
			return ;

		}
		CamGoDeath ();
		return ;

	} else {

		if ( CamVisibleEnt (self.enemy) ) {

			self.dest = GetFollowCam ();
			self.dest1 = GetFollowTrg ();
			if ( (pointcontents (self.dest) == CONTENT_SOLID) ) {

				CamInitFlybyMode (self.enemy);

			}

		} else {

			CamInitFlybyMode (self.enemy);

		}

	}
	if ( (self.search_time < time) ) {

		CamGoIdle ();

	}

};

void () CamFixedThink = {

	local vector vec;
	local entity ent;
	local float cang;
	local float a;
	local float cscr;
	local float maxscr;
	local float minscr;
	local float maxlo;
	local float minhi;
	local vector scrv;
	local vector hiv;
	local vector lov;
	local float c;

	cang = self.v_angle_y;
	cscr = CAM_IDLE;
	maxscr = -45;
	minscr = 45;
	maxlo = -181;
	minhi = 181;
	scrv = VEC_ORIGIN;
	c = CAM_IDLE;
	ent = CamCycle (world);
	while ( (ent != world) ) {

		if ( (ent.deadflag == DEAD_NO) ) {

			a = vlen ((ent.origin - self.origin));
			if ( (a < 1500) ) {

				if ( CamVisible (ent.origin) ) {

					c = (c + CAM_FIXED);
					vec = vectoangles ((ent.origin - self.origin));
					a = (vec_y - cang);
					while ( (a > 180) ) {

						a = (a - 360);

					}
					while ( (a < -180) ) {

						a = (a + 360);

					}
					if ( (fabs (a) < 45) ) {

						cscr = (cscr + CAM_FIXED);
						scrv = (scrv + ent.origin);
						if ( (a < minscr) ) {

							minscr = a;

						}
						if ( (a > maxscr) ) {

							maxscr = a;

						}

					} else {

						if ( (a > CAM_IDLE) ) {

							if ( (a < minhi) ) {

								minhi = a;
								hiv = ent.origin;

							}

						} else {

							if ( (a > maxlo) ) {

								maxlo = a;
								lov = ent.origin;

							}

						}

					}

				}

			}

		}
		ent = CamCycle (ent);

	}
	if ( (c > CAM_IDLE) ) {

		if ( (c > CAM_FIXED) ) {

			self.pausetime = (time + CAM_FOLLOW);

		}
		if ( (cscr < c) ) {

			if ( (((cscr == CAM_IDLE) || ((maxscr - maxlo) <= 90)) || ((minhi - minscr) <= 90)) ) {

				cscr = (cscr + CAM_FIXED);
				if ( ((maxscr - maxlo) > (minhi - minscr)) ) {

					scrv = (scrv + hiv);

				} else {

					scrv = (scrv + lov);

				}

			}

		}
		scrv_x = (scrv_x / cscr);
		scrv_y = (scrv_y / cscr);
		scrv_z = (scrv_z / cscr);
		self.dest1 = scrv;

	}
	self.dest = self.origin;
	if ( ((self.pausetime < time) || (self.search_time < time)) ) {

		CamGoIdle ();

	}

};

void () CamDeathThink = {

	local float f;

	if ( (self.search_time < time) ) {

		CamGoIdle ();
		return ;

	}
	if ( (self.enemy != self) ) {

		f = vlen ((self.origin - self.dest));
		if ( ((f > CAM_FIXED) || (self.mangle != VEC_ORIGIN)) ) {

			f = (time + 0.500);
			if ( (self.pausetime < f) ) {

				self.pausetime = f;

			}

		}

	}
	if ( (time > self.pausetime) ) {

		CamGoIdle ();

	} else {

		if ( (self.enemy != self) ) {

			self.dest1 = self.enemy.origin;

		}

	}
	if ( (self.enemy != self) ) {

		traceline (self.origin,self.dest1,TRUE,self);
		if ( (trace_fraction != CAM_FIXED) ) {

			if ( (self.enemy.velocity == VEC_ORIGIN) ) {

				CamGoIdle ();

			} else {

				CamInitFlybyMode (self.enemy);
				self.state = CAM_DEATH;
				self.pausetime = (time + CAM_FLYBY);

			}

		}
		if ( (self.enemy.velocity != VEC_ORIGIN) ) {

			self.pausetime = (time + CAM_FLYBY);

		}

	}
	if ( (vlen ((self.dest - self.dest1)) > 60) ) {

		self.dest = (self.dest - self.dest1);
		self.dest = normalize (self.dest);
		self.dest = ((59 * self.dest) + self.dest1);

	}

};

void () CamThink = {

	CamUpdValues ();
	self.velocity = VEC_ORIGIN;
	self.avelocity = VEC_ORIGIN;
	if ( (self.state == CAM_IDLE) ) {

		CamIdleThink ();
		CamUpdatePos (CAM_FIXED,80);

	} else {

		if ( (self.state == CAM_FLYBY) ) {

			CamFlyByThink ();
			CamUpdatePos (CAM_IDLE,500);

		} else {

			if ( (self.state == CAM_FOLLOW) ) {

				CamFollowThink ();
				CamUpdatePos (800,1000);

			} else {

				if ( (self.state == CAM_FIXED) ) {

					CamFixedThink ();
					CamUpdatePos (CAM_IDLE,80);

				} else {

					if ( (self.state == CAM_DEATH) ) {

						CamDeathThink ();
						CamUpdatePos (100,150);

					}

				}

			}

		}

	}
	CamImpulses ();

};

void () CamClientInit = {

	local entity ent;

	self.classname = "KasCam";
	setmodel (self,string_null);
	self.weaponmodel = string_null;
	setsize (self,VEC_ORIGIN,VEC_ORIGIN);
	self.velocity = VEC_ORIGIN;
	self.view_ofs = VEC_ORIGIN;
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	self.takedamage = DAMAGE_NO;
	self.fixangle = TRUE;
	self.nextthink = CONTENT_EMPTY;
	self.colormap = CAM_IDLE;
	self.effects = CAM_IDLE;
	self.rad_time = CAM_FIXED;
	self.radsuit_finished = CAM_IDLE;
	self.invincible_time = CAM_IDLE;
	self.invincible_finished = CAM_IDLE;
	self.invisible_time = CAM_IDLE;
	self.invisible_finished = CAM_IDLE;
	self.super_time = CAM_IDLE;
	self.super_damage_finished = CAM_IDLE;
	self.dest = self.origin;
	makevectors (self.v_angle);
	self.dest1 = (self.dest + (100 * v_forward));
	self.enemy = self;
	self.movetarget = world;
	self.goalentity = world;
	self.aflag = TRUE;
	self.mangle = VEC_ORIGIN;
	self.pausetime = time;
	self.delay = time;
	self.attack_state = FALSE;
	CamGoIdle ();
	bprint ("Camera running\n");

};

void () CamSpawn = {

	local float i;
	local entity ent;
	local entity start;

	start = find (world,classname,"info_player_start");
	i = TE_LAVASPLASH;
	while ( (i > CAM_IDLE) ) {

		ent = spawn ();
		ent.classname = "CamSavedPos";
		ent.angles = start.angles;
		ent.v_angle = start.v_angle;
		setorigin (ent,start.origin);
		i = (i - CAM_FIXED);

	}

};
float () CamDisconnect = {

	local entity cam;
	local entity oself;

	if ( (self.classname == "KasCam") ) {

		bprint ("Camera deactivated\n");
		return ( FALSE );

	} else {

		cam = find (world,classname,"KasCam");
		while ( cam ) {

			if ( (cam.enemy == self) ) {

				oself = self;
				self = cam;
				CamGoIdle ();
				self = oself;

			}
			if ( (cam.movetarget == self) ) {

				cam.movetarget = world;

			}
			cam = find (cam,classname,"KasCam");

		}
		return ( TRUE );

	}

};

void (entity ent, entity que) CamCopyBody = {

	local entity oself;
	local entity cam;

	cam = find (world,classname,"KasCam");
	while ( cam ) {

		if ( (ent == cam.enemy) ) {

			if ( (cam.state != CAM_DEATH) ) {

				oself = self;
				self = cam;
				CamGoDeath ();
				self = oself;

			}
			cam.enemy = que;

		} else {

			if ( (que == cam.enemy) ) {

				cam.enemy = cam;

			}

		}
		cam = find (cam,classname,"KasCam");

	}

};
