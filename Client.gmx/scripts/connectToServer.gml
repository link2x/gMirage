// From modClientTCP

// Check to see if we are already connected, if so just exit

if tcpconnected(global.socket) {
    connectedToServer = true;
    return 1;
}

wait = getTickCount();

global.socket = tcpconnect(global.RemoteHost,global.RemotePort,1);    
    
setStatus("Connecting to server...");
    
if isConnected() {
    connectedToServer = true;
} else {
    connectedToServer = false;
}

return connectedToServer;
