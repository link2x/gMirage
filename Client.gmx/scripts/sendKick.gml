// From modClientTCP

// Should probably modify this to add reasoning.

writebyte(CKickPlayer,0); // Packet Type
writestring(argument0,0); // Player Name
sendData();
