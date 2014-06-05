// From modClientTCP

writebyte(CSaveSpell,0); // Packet Type

writedouble(argument0,0); // Spell Number
writestring(argument1,0); // Spell Name
writedouble(argument2,0); // Spell Sprite
writeint(argument3,0);    // Level Requirement
writedouble(argument4,0); // Spell Type
writedouble(argument5,0); // Data 1
writedouble(argument6,0); // Data 2
writedouble(argument7,0); // Data 3

sendData();
