// From modGeneral
//
// Adds a line to the chatbox.
//
// addText(Text, Color);
s = argument0;
c = argument1;
    
with objUI.txtChat {
messages+=1;
message[messages] = s;
messagecolor[messages] = c;
}

// Note:
// 
// Instead of trying to write the UI in the style of VB (which would be absolutely absurd),
// I'm going to come up with a simple UI and modify the VB code to fit nicely.
//
// As such, expect to see a lot of seemingly missing code.
// It's not necessarily missing, just unneeded.
//
