// From modClientTCP

writebyte(CSetMotd,0); // Packet Type
writestring(argument0,0); // MOTD
sendData();
