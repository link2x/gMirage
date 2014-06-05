// From modGeneral
//
// All of the game start code.
//
// main();

// Basically, we're gonna start the game in this room.
// frmSendGetData.Visible = True
// That is, it will be rmSendGetData.

global.gameStatus = ""; // This is for fixing setStatus later. Will be moved elsewhere, probably.

setStatus("Loading...");
    
global.GettingMap = True;
global.vbQuote = 34;
    
//Load frmMirage
room_goto(rmMirage);

// Update the window with the game's name
window_set_caption(global.gameName);

// Ranodmize the Seed
random_set_seed(random(mouse_x+mouse_y)*random(1000000)); //Using the random fuction to make a seed is bad, mmkay? Will update with more variance soon.
    
// Set the font.
initFont();

setStatus("Initializing TCP settings...");

tcpInit();

setStatus("Initializing DirectX..."); //We're going to be wrapping DX ASAP. Shouldn't be very hard, considering I get to simplify everything. Based YoYo.

checkTiles();
checkSprites();
checkSpells();
checkItems();
        
// DirectDraw Surface memory management setting
//DDSD_Temp.lFlags = DDSD_CAPS
//DDSD_Temp.ddsCaps.lCaps = DDSCAPS_OFFSCREENPLAIN Or DDSCAPS_VIDEOMEMORY

room_goto(rmMainMenu);
// I need some sort of room-load code here.
