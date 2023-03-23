/*
This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by the
Free Software Foundation; either version 2 of the License, or (at your
option) any later version.

This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software Foundation,
Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
*/

/*
	Written by Frank Condello <pox@planetquake.com>
	
	Misc triggers...
	
	trigger_chat
	trigger_chat_relay
*/



//============================================================================

void() chat_chat =
{
	if (self.touch) {
		
		if (other.classname != "player")
			return;
		
		if (self.movedir != '0 0 0')
		{
			makevectors (other.angles);
			if (v_forward * self.movedir < 0)
				return;// not facing the right way
		}
	}
	
	activator = world;// This will centreprint if player is activator
	
	// Basically swiped from FikBot...
	WriteByte(MSG_ALL, 8);// svc_print
	WriteByte(MSG_ALL, 1);// svc_nop
	WriteString(MSG_ALL, self.netname);
	WriteByte(MSG_ALL, 8);
	//WriteByte(MSG_ALL, 1);
	WriteString(MSG_ALL, ": ");
	WriteByte(MSG_ALL, 8);
	//WriteByte(MSG_ALL, 1);
	WriteString(MSG_ALL, self.message);
	WriteByte(MSG_ALL, 8);
	//WriteByte(MSG_ALL, 2);// svc_disconnect
	WriteString(MSG_ALL, "\n");
	
	if (self.target)
		SUB_UseTargets();
	
	remove(self);
};

/*QUAKED trigger_chat (.5 .5 .5) ?
A little hack to print a "chat" message in a single player game from a non-existant
source (good for sending messages to the player from "HQ" or whatever).

"angle"			Angle the player must be facing to trigger
"netname"		Name of the sender
"message"		The chat message
"delay"			Delay before activating target
"target"		Activate this ent after delay (setup a chat relay)

NOTES:

These are always one-off triggers, removed after sending their message.

*/
void() trigger_chat =
{
	if (!self.netname) objerror("trigger_chat without netname");
	if (!self.message) objerror("trigger_chat without message");
	
	if (self.delay <=0)
		self.delay = 0.1;
	
	InitTrigger ();
	
	self.touch = chat_chat;
};

/*QUAKED trigger_chat_relay (.5 .5 .5) (-8 -8 -8) (8 8 8) ?
Like trigger_chat, but must be remotely triggered. Can trigger another
ent after delay time (for stringing together a bunch of timed messages)

"netname"		Name of the sender
"message"		The chat message
"delay"			Delay before activating target
"target"		Activate this ent after delay
"targetname"	This trigger's name

NOTES:

See trigger_chat notes.

*/
void() trigger_chat_relay =
{
	if (!self.netname) objerror("trigger_chat_relay without netname");
	if (!self.message) objerror("trigger_chat_relay without message");
	
	if (self.delay <=0)
		self.delay = 0.1;
		
	self.use = chat_chat;
};
