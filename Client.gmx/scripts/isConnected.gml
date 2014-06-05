// From modClientTCP

// This is a heavily unnecessary wrapper, but I'm leaving it in to keep
// more of the original code intact.

// If you want to remove this, just change everywhere this is used like so:

// isConnected()
// becomes
// tcpconnected(global.socket)

// Basically, just tell us if we're connected.
return tcpconnected(global.socket);
