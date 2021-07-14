/* ::-::
 *
 * Cataboligne
 *
 * file: dpext.qc
 *
 * date: 11/25/14
 *
 * qc - darkplaces extension support
 *
 */

// note: avoid adding extensions not being used - they take up global vars

#ifndef nondp

// read cvar as strings
string (string s) cvar_string = #448;

// scale models in dp

.float scale;

// returns a section of a string as a tempstring - see FTE_STRINGS for enhanced version
string(string s, float start, float length) substring = #116;

// for testing right now

//string(float chars, string s, ...) strpad = #225;
// effect of #nondp here

#endifdef
