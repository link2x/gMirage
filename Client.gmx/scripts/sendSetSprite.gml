// From modClientTCP

writebyte(CSetSprite,0); // Packet Type
writestring(argument0,0); // Player Name
writeint(argument1,0); // Sprite Number
sendData();
