// From modClientTCP

writebyte(CPlayerMove,0); // Packet Type
writebyte(argument0,0); // Direction
writebyte(argument1,0); // Is Moving
sendData();
