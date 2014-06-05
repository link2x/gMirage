// From modClientTCP

writebyte(CSaveItem,0);   // Packet Type
writedouble(argument0,0); // Item Number
writestring(argument1,0); // Item Name
writedouble(argument2,0); // Item Sprite
writefloat(argument3,0);  // Item Type
writedouble(argument4,0); // Data 1
writedouble(argument5,0); // Data 2
writedouble(argument6,0); // Data 3
sendData();
