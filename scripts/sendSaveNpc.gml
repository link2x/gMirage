// From modClientTCP

writebyte(CSaveNpc,0); // Packet Type
writedouble(argument0,0); // NPC Number
writestring(argument1,0); // NPC Name
writestring(argument2,0); // Text On-Attack
writedouble(argument3,0); // Sprite
writeint(argument4,0); // SpawnSecs?
writeint(argument5,0); // NPC Behaviour
writeint(argument6,0); // NPC Range
writeint(argument7,0); // Drop Chance
writedouble(argument8,0); // Drop Item
writeint(argument9,0); // Drop Amount
writeint(argument10,0); // Strength
writeint(argument11,0); // Defense
writeint(argument12,0); // Speed
writeint(argument13,0); // Magic

sendData();
