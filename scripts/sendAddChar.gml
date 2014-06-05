// From modClientTCP

writebyte(CAddChar,0); // Packet Type
writestring(argument0,0); // Character Name
writebyte(argument1,0); // Sex
writebyte(argument2,0); // Class Number
writebyte(argument3,0); // Slot
sendData();
