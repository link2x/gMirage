// From modClientTCP

// Modified to be a bit more secure. Need to go over this some more ASAP,
// as MD5 is now known as insecure.

// Still it's better than the original code, which offered absolutely no
// protection.
writebyte(CNewAccount,0); // Packet Type
writestring(argument0,0); // Username
writestring(md5string(argument1),0); // Password, MD5'd for !LIGHT! security
                                     // This is also everywhere the password is needed.
sendData();
