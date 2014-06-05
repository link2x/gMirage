// From modClientTCP

global.SEP_CHAR = chr(1)+"\0"+chr(0);
global.END_CHAR = chr(2);

// Load 39dll. Why 39dll? Because (as always) GM's networking is trashy.
dllinit(0,true,true);

// check if IP is valid
if isIP(GAME_IP) {  // See if we have a real IP to connect to.
                    // We won't be checking the port, as it's a number, not a string.
    global.RemoteHost = GAME_IP;
    global.RemotePort = GAME_PORT;
} else {
    msgBox(string(GAME_IP)+" does not appear as a valid IP address!");
    destroyGame();
}
