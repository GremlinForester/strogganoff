Quake II for DarkPlaces
=======================

## What is it?

Quake II for DarkPlaces (AKA Quake Strogganoff) is a Quake modification that primarily adds Quake II's monsters, players and weapons to Quake 1 (using QuakeC) along with a slew of other effects and modding features using the DarkPlaces engine.

The mod places focus on coopertive play with additional features that take advantage of the DarkPlaces engine and serves as a base for custom missions or mods.

## The Code

Abandon Hope All Ye Who Enter Here. This project is first and foremost a learning exercise so if you come across something and think, wow that's dumber than the dumbest dumb to ever dumb. Sorry about that! Bug reports and pull requests welcome :)

The SSQC codebase is built on [Number Six's Quake 1.06 Recoded](https://www.moddb.com/games/quake/downloads/quake-c-version-106-recoded). There are a lot of known issues at the moment but for the most part it should be **mostly functional**.

Most of the major changes pertain to Q2 or are organizational, like putting entities into their own .qc files under /entities.

The "api" can be found under shared/strogganoff_defs.qc, future plans are to separate the more mod specific stuff and generalized reusable code into more modular libraries. Once cleaned up a bit more it should be possible to remove an entitity simply by deleting the file or commenting it out in the .src file.

The weapon system basically mimicks Quake 2's setup, same for monster weapon code which is more generic and shared.

AI is pretty much the same as Q1 although down the road it would be nice to explore some sort of pathfinding solution.

The CSQC needs work to say the least! This is still a major component to tackle so as it stands right now the CSQC is cobbled together from several sources and more than a few sleepless nights with my brain running on overdrive and smoke coming out of my ears like a GPU in a crypto mining farm. Basically there is A LOT of room for optimization here, especially for MP. So, anything you see there and wonder wtf!? That's probably on me, sorry!

The MENU was a late addition, so it's basically the battleMETAL menu mashed in there and hastily modified to make it work for this mod. Although it's in better shape than the CSQC portion!

And just to be clear, there is code from all over the place, written by many people over a very long time. I've tried to keep original comments, readme's and any mentions containing credits intact or at the very least where that code came from. To my knowledge all code used is GPL (or was up for grabs as-is) if however, there's an issue please reach out to get things addressed asap.

## Features

- Q2's monsters (except the medic or anything mission pack related) and a few custom monster variants.
- Q2's weapons (except the grenade).
- Q2's player types.
- Inventory system as seen in Q2 with basic crosslevel support for items like keys and powerups.
- Q3BSP Support with custom materials for footsteps and impact effects.
- Basic BOT support (Frik).
- A bunch of generic mapping toolbag entities.
- Custom mission support for easy sharing.
- Basic HUB map support for custom multi-level missions.
- Example maps and documentation.
- Skill configs for custom enemy health and damage via cvars as seen in Half-Life.
- Custom MENU based on [battleMETAL](https://github.com/Subject9x/battleMETAL).
- Blaster upgrade powerup (experimental).
- Slew of added visual effects.
- Lots and bugs (unplanned features).

## HUD/Client code readme credits (edited):
Chip for the great quakewiki.net 
Seven for arranging my code 
Unknow programmer for his great and simple use of csqc http://www.quakewiki.net/quake-1/mods/custom-hud/ 
To compile use fteqcc (not included). 
Nahuel. 
Show players in game and end stats maps, (kleshik and nexuiz stuff in "kleshikstuff.qc)

## The Latest Version

The latest version can be found in the releases section.

## Documentation

The documentation for this release is included in the main mod folder.

## Installation

Please see the file called INSTALL.

## Licensing

Please see the file called LICENSE.

## Contacts

* If want to report a bug or request a feature you can submit them to the project using the issue tracker.
