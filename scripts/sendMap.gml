// From modClientTCP

canMoveNow = false;

writebyte(CMapData,0); // Packet Type
writestring(argument0,0); // Name
writebyte(argument1,0); // Moral
writeint(argument2,0); // Tileset
writedouble(argument3,0) // Map UP
writedouble(argument4,0) // Map DOWN
writedouble(argument5,0) // Map LEFT
writedouble(argument6,0) // Map RIGHT
writeint(argument7,0) // Music
writebyte(argument8,0) // BootMap? - I do believe this is a flag that sets the map as either THE spawn point, or a POSSIBLE spawn point. I don't remember.
writeint(argument9,0) // Boot X
writeint(argument10,0) // Boot Y
writedouble(argument11,0) // Map Shop

// NOTE: This is where the GM version is making a big improvement. You'll notice I used doubles
// for the u/d/l/r. This means you can have far more maps than the original engine could.
// This isn't to say that it wasn't possible on the engine, but rather it wasn't set up to
// handle it by default. This will, however, slow down saves/loads some, but the change in
// network speed/capacity should mean it isn't a big issue.

// Now on to the big part, sending the actual data for the map.

// I'm actually going to let the object that handles this script be a controller for mapping,
// giving it access to all tiles via an array.

// Doing this makes it easier to handle the maps like they did in the VB code.

for (x=0;x<MAX_MAPX;x+=1) {
    for (y=0;y<MAX_MAPY;y+=1) {
        with tile[x,y] {
            writeint(ground,0); // The tile of the GROUND layer.
            writeint(mask,0); // The tile of the MASK layer.
            writeint(anim,0); // The tile of the ANIM layer.
            writeint(fringe,0); // The tile of the FRINGE layer.
            writeint(type,0); // The tile type.
            writeint(data1,0); // Additional tile data.
            writeint(data2,0); // Additional tile data.
            writeint(data3,0); // Additional tile data.
        }
    }
}

for (n=1;n<MAX_MAP_NPCS;n+=1) {
writedouble(npc[n]); // NPC
                     // The X/Y seems to be unimportant here. I imagine this ties in nicely with an NPC spawner/placeholder tile type.
}

sendData();
