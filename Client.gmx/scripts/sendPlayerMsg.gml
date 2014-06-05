// From modClientTCP

writebyte(CPlayerMsg,0); // Packet Type
writestring(argument0,0); // Player
writestring(argument1,0); // Text
sendData();
