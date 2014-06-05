// From modClientTCP

// I'm not exactly sure what this one is/does, but I /think/ it destroys the entire
// server-side ban list. I suggest either removing it entirely (that shouldn't be
// a client-side command regardless of admin status) or modifying it to just unban
// a given user.

writebyte(CBanDestroy,0);      // Packet Type
sendData();
