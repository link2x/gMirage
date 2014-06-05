// From modGeneral
//
// Used for adding text to packet debugger
//
// textAdd(Textbox Object ID, Text, NewLine);

// I'm deprecating NewLine.
// I just don't see a case where one would need to /not/ have it newline.

// The argument will still be there, though, for compatability, so just put whatever there.

newLine = argument2;

argument0.messages+=1;
argument0.message[messages] = argument1;
