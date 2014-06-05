// From modClientTCP
//
//

// Basically, this script is here to
// 1. Check if there is data to read.
// 2. Pull that data into a usable area.
// 3. Parse

// GM's Networking doesn't seem to be too suited for this,
// so we're going to use 39dll instead.

data = receivemessage(global.socket); // Step 2. Due to how 39dll works, we pull anything and everything out first.

// Step 1. Now we check if there is data to read.
if data=0  {return;} // Disconnected. Need to (find and) hook the old code in here somehow.
if data<=0 {return;} // Idle connection. No data to read.

handleData(data); // Step 3. We have data, so we're sending it along to the parser.
