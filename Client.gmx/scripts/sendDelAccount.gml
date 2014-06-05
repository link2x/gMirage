// From modClientTCP

// Fair warning, I'm removing this code from my personal build
// and I suggest you do, too. Single-stage deletion isn't something
// I think you should allow, and the web would be a better front-end
// for multi-stage deletion.

writebyte(CDelAccount,0); // Packet Type
writestring(argument0,0); // Username
writestring(md5string(argument1),0); // Password, MD5'd for !LIGHT! security
sendData();
