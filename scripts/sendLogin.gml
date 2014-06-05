// From modClientTCP

writebyte(CLogin,0); // Packet Type
writestring(argument0,0); // Username
writestring(md5string(argument1),0); // Password, MD5'd for !LIGHT! security
sendData();
