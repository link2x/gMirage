// From modClientTCP

writebyte(CSetAccess,0); // Packet Type
writestring(argument0,0); // Player Name
writebyte(argument1,0); // Access Level
sendData();
