// From modClientTCP

writebyte(CSaveShop,0); // Packet Type

writedouble(argument0,0); // Shop Number
writestring(argument1,0); // Shop Name
writestring(argument2,0); // Text On-Join
writestring(argument3,0); // Text On-Leave
writebyte(argument4,0);   // Fixes Items

for (i=1;i<MAX_TRADES;i+=1) {
    with shop[argument0] {
        writedouble(giveItem[i],0);  // Item Given
        writedouble(giveValue[i],0); // Number Given
        writedouble(getItem[i],0);   // Item Received
        writedouble(getValue[i],0);  // Number Received
    }
}

sendData();
